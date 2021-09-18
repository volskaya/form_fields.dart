import 'dart:io';

import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_fields/src/overlayed_ink_well.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log/log.dart';
import 'package:quiver/strings.dart';

part 'photo_form_field.freezed.dart';

typedef PhotoFormFieldIdleBuilder = Widget Function(BuildContext context, Widget child, String? error);

@freezed
class PhotoFormFieldValue with _$PhotoFormFieldValue {
  const factory PhotoFormFieldValue.local({required File file, FirebaseImage? previousValue}) = _LocalFileValue;
  const factory PhotoFormFieldValue.online({required FirebaseImage imageProvider}) = _OnlineFileValue;
}

class PhotoFormField extends FormField<Map<int, PhotoFormFieldValue?>> {
  PhotoFormField({
    bool interactive = true,
    bool singlePhoto = false,
    EdgeInsets secondaryPhotoPadding = EdgeInsets.zero,
    FormFieldSetter<Map<int, PhotoFormFieldValue?>>? onSaved,
    FormFieldSetter<Map<int, PhotoFormFieldValue?>>? onChanged,
    FormFieldValidator<Map<int, PhotoFormFieldValue?>>? validator,
    Map<int, PhotoFormFieldValue?> initialValue = const <int, PhotoFormFieldValue?>{},
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool enableReorder = false,
    PhotoFormFieldIdleBuilder? idleBuilder,
    BorderRadius? borderRadius,
    ShapeBorder? shape,
    BorderRadius? secondaryBorderRadius,
    ShapeBorder? secondaryShape,
    Duration switchDuration = const Duration(milliseconds: 250),
    Axis? draggableAffinity = Axis.horizontal,
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
            shape: shape,
            secondaryBorderRadius: secondaryBorderRadius,
            secondaryShape: secondaryShape,
            switchDuration: switchDuration,
            enableReorder: enableReorder,
            onChanged: onChanged,
            draggableAffinity: draggableAffinity,
          ),
        );

  static IconData photoIcon = Icons.image;
  static int maxSecondaryPhotos = 4;

  static Future<List<File>> pickImages({
    bool useCamera = false,
    bool allowMultiple = true,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: allowMultiple,
      );

      return result?.files.where((x) => x.path?.isNotEmpty == true).map((x) => File(x.path!)).toList(growable: false) ??
          const <File>[];
    } catch (_) {}

    return const <File>[];
  }

  static Future<File?> pickImage({bool useCamera = false}) async {
    return (await pickImages(allowMultiple: false)).firstOrNull;
  }
}

class _Widget extends StatelessWidget {
  const _Widget({
    Key? key,
    required this.state,
    required this.interactive,
    required this.singlePhoto,
    this.secondaryPhotoPadding = EdgeInsets.zero,
    this.idleBuilder,
    this.switchDuration = const Duration(milliseconds: 250),
    this.enableReorder = false,
    this.borderRadius,
    this.secondaryBorderRadius,
    this.shape,
    this.secondaryShape,
    this.onChanged,
    this.draggableAffinity = Axis.horizontal,
  }) : super(key: key);

  final FormFieldState<Map<int, PhotoFormFieldValue?>> state;
  final EdgeInsets secondaryPhotoPadding;
  final bool interactive;
  final bool singlePhoto;
  final PhotoFormFieldIdleBuilder? idleBuilder;
  final Duration switchDuration;
  final bool enableReorder;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;
  final BorderRadius? secondaryBorderRadius;
  final ShapeBorder? secondaryShape;
  final FormFieldSetter<Map<int, PhotoFormFieldValue?>>? onChanged;
  final Axis? draggableAffinity;

  static final _log = Log.named('PhotoFormField');

  static Future<List<File>> _pickImages(bool single) async {
    if (single) {
      final file = await PhotoFormField.pickImage();
      return file != null ? [file] : const <File>[];
    } else {
      return PhotoFormField.pickImages();
    }
  }

  void _handleStateChange(Map<int, PhotoFormFieldValue?>? value) {
    state.didChange(value);
    onChanged?.call(value);
  }

  Future _handleTap({int id = 0, bool remove = false}) async {
    final photos = !remove ? await _pickImages(singlePhoto) : null;
    final remainingPhotos = !singlePhoto ? 4 - id : 0;

    if (photos?.isNotEmpty != true && !remove) {
      return _log.w('Picker returned no image, skipping…');
    } else if (id == 0 && photos == null) {
      // Main photo deleted.
      _handleStateChange(const <int, PhotoFormFieldValue>{});
    } else {
      final newValue = Map<int, PhotoFormFieldValue?>.from(state.value ?? const <int, PhotoFormFieldValue?>{});

      if (photos == null) {
        newValue[id] = null;
      } else {
        for (var i = 0; i < photos.length; i += 1) {
          if (i > remainingPhotos) break;

          final key = id + i;
          final photo = photos[i];

          newValue[key] = PhotoFormFieldValue.local(
            file: photo,
            previousValue: state.value?[key]?.map(
              online: (v) => v.imageProvider,
              local: (v) => v.previousValue,
            ),
          );
        }
      }

      _handleStateChange(newValue);
    }
  }

  Widget _buildImageWidget(BuildContext _, int index, int imageIndex, Widget idleChild) {
    ShapeBorder? shape;
    BorderRadius? borderRadius;

    if (index > 0 && (secondaryBorderRadius != null || secondaryShape != null)) {
      shape = secondaryShape;
      borderRadius = secondaryBorderRadius;
    } else {
      shape = this.shape;
      borderRadius = this.borderRadius;
    }

    return _ImageWidget(
      index: index,
      idleChild: idleChild,
      borderRadius: borderRadius,
      shape: shape,
      interactive: interactive,
      draggable: enableReorder && !singlePhoto,
      draggableAffinity: draggableAffinity,
      imageProvider: state.value?[imageIndex]?.map(
        local: (value) => FileImage(value.file),
        online: (value) => value.imageProvider,
      ),
      onTap: state.widget.enabled && index == 0 || state.value?.containsKey(0) == true
          ? () => _handleTap(id: index)
          : null,
      onLongPress: state.widget.enabled && state.value?.containsKey(index) == true
          ? () => _handleTap(id: index, remove: true)
          : null,
    );
  }

  Widget _buildImage(BuildContext context, ThemeData theme, [int index = 0]) {
    final defaultIdleChild = ColoredBox(
      color: theme.backgroundColor,
      child: interactive
          ? Center(
              child: Icon(
                PhotoFormField.photoIcon,
                size: index == 0 ? 48.0 : 24.0,
                color: theme.dividerColor,
              ),
            )
          : null,
    );

    final idleChild = idleBuilder?.call(
          context,
          defaultIdleChild,
          state.hasError ? state.errorText : null,
        ) ??
        defaultIdleChild;

    return !enableReorder || singlePhoto
        ? _buildImageWidget(context, index, index, idleChild)
        : DragTarget<int>(
            builder: (context, candidateData, rejectedData) {
              final candidate = candidateData.firstOrNull;
              final imageIndex = candidate ?? index;
              return _buildImageWidget(context, index, imageIndex, idleChild);
            },
            onAccept: (acceptedIndex) {
              final newValue = Map<int, PhotoFormFieldValue?>.from(state.value ?? const <int, PhotoFormFieldValue?>{});
              final currentIndexValue = newValue[index];
              newValue[index] = newValue[acceptedIndex];
              newValue[acceptedIndex] = currentIndexValue;
              _handleStateChange(newValue);
              HapticFeedback.vibrateFor(theme.platform);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainPhoto = AspectRatio(
      aspectRatio: 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          _buildImage(context, theme),

          // Error message.
          if (state.hasError && isNotEmpty(state.errorText))
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: PhysicalShape(
                clipper: ShapeBorderClipper(shape: theme.cardTheme.shape!),
                color: theme.colorScheme.error,
                shadowColor: theme.cardTheme.shadowColor!,
                clipBehavior: theme.cardTheme.clipBehavior!,
                elevation: 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    state.errorText!,
                    style: theme.textTheme.caption!.apply(color: theme.colorScheme.onSurface),
                    layoutTwice: true,
                  ),
                ),
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
                padding: secondaryPhotoPadding,
                child: AnimatedCrossFade(
                  duration: switchDuration,
                  alignment: Alignment.topCenter,
                  sizeCurve: standardEasing,
                  firstCurve: standardEasing,
                  secondCurve: standardEasing,
                  crossFadeState: state.value?.containsKey(0) == true && (interactive || state.value!.length >= 2)
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
                                child: _buildImage(context, theme, index + 1),
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

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    Key? key,
    required this.index,
    required this.imageProvider,
    required this.idleChild,
    required this.borderRadius,
    required this.interactive,
    required this.onTap,
    required this.onLongPress,
    this.draggable = false,
    this.shape,
    this.draggableAffinity = Axis.horizontal,
  }) : super(key: key);

  final int index;
  final ImageProvider? imageProvider;
  final Widget idleChild;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;
  final bool interactive;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool draggable;
  final Axis? draggableAffinity;

  Widget _buildImage(
    ImageProvider? imageProvider,
    Size constraints, {
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool interactive = true,
  }) {
    ImageProvider? image = imageProvider;

    if (image is FirebaseImage) {
      image = image.copyWith(cacheSize: FirebaseImage.getCacheSize(image.size, constraints));
    }

    Widget widget = SwitchingFirebaseImage(
      imageProvider: image,
      type: interactive ? SwitchingImageType.scale : SwitchingImageType.fade,
      duration: const Duration(milliseconds: 300),
      curve: decelerateEasing,
      idleChild: idleChild,
      borderRadius: borderRadius,
      shape: shape,
      expandBox: true,
      inherit: true,
      wrapInheritBoundary: true,
    );

    if (interactive) {
      widget = OverlayedInkWell(
        borderRadius: borderRadius,
        shape: shape,
        child: widget,
        onTap: onTap,
        onLongPress: onLongPress,
      );
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, c) {
          final widget = _buildImage(
            imageProvider,
            c.biggest,
            onTap: onTap,
            onLongPress: onLongPress,
            interactive: interactive,
          );

          return interactive && draggable
              ? Draggable<int>(
                  data: index,
                  maxSimultaneousDrags: imageProvider != null ? 1 : 0, // Disable while there's no image.
                  ignoringFeedbackSemantics: true,
                  affinity: draggableAffinity,
                  rootOverlay: true,
                  dragAnchorStrategy: (_, __, ___) => const Offset(56.0, 56.0) / 2,
                  onDragStarted: () => Feedback.forLongPress(context),
                  child: widget, // Match tree with `childWhenDragging`.
                  childWhenDragging: _buildImage(null, c.biggest, interactive: interactive), // Match tree with `child`.
                  feedback: SizedBox.fromSize(
                    size: const Size.square(56.0),
                    child: _buildImage(imageProvider, c.biggest, interactive: false),
                  ),
                )
              : widget;
        },
      );
}
