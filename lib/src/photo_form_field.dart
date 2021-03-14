import 'dart:io';

import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:form_fields/src/overlayed_ink_well.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log/log.dart';
import 'package:quiver/strings.dart';

part 'photo_form_field.freezed.dart';

typedef PhotoFormFieldIdleBuilder = Widget Function(BuildContext context, Widget child, String error);

@freezed
abstract class PhotoFormFieldValue with _$PhotoFormFieldValue {
  const factory PhotoFormFieldValue.local({@required File file}) = _LocalFileValue;
  const factory PhotoFormFieldValue.online({@required ImageProvider imageProvider}) = _OnlineFileValue;
}

class PhotoFormField extends FormField<Map<int, PhotoFormFieldValue>> {
  PhotoFormField({
    bool interactive = true,
    bool singlePhoto = false,
    EdgeInsets secondaryPhotoPadding,
    FormFieldSetter<Map<int, PhotoFormFieldValue>> onSaved,
    FormFieldValidator<Map<int, PhotoFormFieldValue>> validator,
    Map<int, PhotoFormFieldValue> initialValue = const <int, PhotoFormFieldValue>{},
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    PhotoFormFieldIdleBuilder idleBuilder,
    BorderRadius borderRadius,
    Duration switchDuration = const Duration(milliseconds: 250),
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (state) => _Widget(
            state: state,
            interactive: interactive,
            singlePhoto: singlePhoto,
            secondaryPhotoPadding: secondaryPhotoPadding,
            idleBuilder: idleBuilder,
            borderRadius: borderRadius,
            switchDuration: switchDuration,
          ),
        );

  static IconData photoIcon = Icons.image;
  static int maxSecondaryPhotos = 4;

  static Future<File> pickImage({bool useCamera = false}) async {
    final picker = ImagePicker();
    File file;

    try {
      final pickedFile = await picker.getImage(
        source: useCamera ? ImageSource.camera : ImageSource.gallery,
      );

      file = File(pickedFile.path);
    } catch (e) {
      final response = await picker.getLostData();
      file = response?.type == RetrieveType.image ? File(response.file.path) : null;
    }

    return file;
  }
}

class _Widget extends StatelessWidget {
  const _Widget({
    Key key,
    @required this.state,
    @required this.interactive,
    @required this.singlePhoto,
    this.secondaryPhotoPadding = EdgeInsets.zero,
    this.idleBuilder,
    this.borderRadius,
    this.switchDuration = const Duration(milliseconds: 250),
  }) : super(key: key);

  final FormFieldState<Map<int, PhotoFormFieldValue>> state;
  final EdgeInsets secondaryPhotoPadding;
  final bool interactive;
  final bool singlePhoto;
  final PhotoFormFieldIdleBuilder idleBuilder;
  final BorderRadius borderRadius;
  final Duration switchDuration;

  static final _log = Log.named('PhotoFormField');

  Future _handleTap({int id = 0, bool remove = false}) async {
    final photo = !remove ? await PhotoFormField.pickImage() : null;

    if (photo == null && !remove) {
      return _log.v('Picker returned no image, skipping…');
    } else if (id == 0 && photo == null) {
      // Main photo deleted
      state.didChange(const <int, PhotoFormFieldValue>{});
    } else {
      // Only handle the index photo
      state.didChange(Map<int, PhotoFormFieldValue>.from(state.value)
        ..[id] = photo != null ? PhotoFormFieldValue.local(file: photo) : null);
    }
  }

  Widget _buildImage(ThemeData theme, [int index = 0]) {
    final defaultIdleChild = AnimatedContainer(
      duration: switchDuration,
      curve: standardEasing,
      color: theme.backgroundColor,
      alignment: Alignment.center,
      child: interactive
          ? Icon(
              PhotoFormField.photoIcon,
              size: index == 0 ? 48.0 : 24.0,
              color: !state.hasError ? theme.hintColor : theme.colorScheme.error,
            )
          : null,
    );

    final idleChild = idleBuilder?.call(
          state.context,
          defaultIdleChild,
          state.hasError ? state.errorText : null,
        ) ??
        defaultIdleChild;

    final image = LayoutBuilder(
      builder: (_, c) {
        final imageProvider = state.value[index]?.map(
          local: (value) => FileImage(value.file),
          online: (value) => value.imageProvider,
        );

        if (imageProvider is FirebaseImage) {
          imageProvider.setCacheSize(FirebaseImage.getCacheSize(imageProvider.size, c.biggest));
        }

        return SwitchingFirebaseImage(
          imageProvider: imageProvider,
          type: interactive ? SwitchingImageType.scale : SwitchingImageType.fade,
          idleChild: idleChild,
          borderRadius: borderRadius,
        );
      },
    );

    return interactive
        ? OverlayedInkWell(
            borderRadius: borderRadius,
            child: image,
            onTap:
                state.widget.enabled && index == 0 || state.value.containsKey(0) ? () => _handleTap(id: index) : null,
            onLongPress: state.widget.enabled && state.value.containsKey(index)
                ? () => _handleTap(id: index, remove: true)
                : null,
          )
        : image;
  }

  @override
  Widget build(BuildContext _) {
    final theme = Theme.of(state.context);
    final mainPhoto = AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          _buildImage(theme),

          // Error message
          Positioned(
            bottom: 16,
            right: 16,
            child: FancySwitcher(
              child: state.hasError && isNotEmpty(state.errorText)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        state.errorText,
                        style: theme.textTheme.caption.apply(color: theme.colorScheme.error),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );

    return singlePhoto
        ? mainPhoto
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Main photo.
              mainPhoto,

              // Secondary photos.
              Padding(
                padding: secondaryPhotoPadding ?? EdgeInsets.zero,
                child: AnimatedCrossFade(
                  duration: switchDuration,
                  alignment: Alignment.topCenter,
                  sizeCurve: standardEasing,
                  firstCurve: standardEasing,
                  secondCurve: standardEasing,
                  crossFadeState: state.value.containsKey(0) && (interactive || state.value.length >= 2)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...List<Widget>.generate(
                            PhotoFormField.maxSecondaryPhotos,
                            (index) => Flexible(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: _buildImage(theme, index + 1),
                              ),
                            ),
                            growable: false,
                          ).expand((widget) sync* {
                            yield const SizedBox(width: 8);
                            yield widget;
                          }).skip(1),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
