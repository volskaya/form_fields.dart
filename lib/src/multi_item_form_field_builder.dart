import 'package:animations/animations.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';

typedef MultiItemFormFieldBuilderOpenPicker<T> = Future<Set<T>> Function(BuildContext context);
typedef MultiItemFormFieldBuilderGetToggle<T> = VoidCallback? Function(T item);
typedef MultiItemFormFieldBuilderToggleCallback<T> = void Function(T item);
typedef MultiItemFormFieldBuilderFieldBuilder<T> = Widget Function(
  BuildContext context,
  Set<T> value,
  MultiItemFormFieldBuilderOpenPicker<T> openPicker,
  MultiItemFormFieldBuilderGetToggle<T> getToggle,
  void Function(T a, T b) swapValues,
);
typedef MultiItemFormFieldBuilderContentBuilder<T> = Widget Function(
  BuildContext context,
  ValueNotifier<Set<T>?> notifier,
  ScrollController scrollController,
  MultiItemFormFieldBuilderGetToggle<T> getToggle,
);

class MultiItemFormFieldBuilder<T> extends FormField<Set<T>> {
  MultiItemFormFieldBuilder({
    required Widget title,
    required MultiItemFormFieldBuilderContentBuilder<T> contentBuilder,
    required MultiItemFormFieldBuilderFieldBuilder<T> fieldBuilder,
    Key? key,
    Set<T>? initialValue,
    FormFieldSetter<Set<T>>? onSaved,
    FormFieldValidator<Set<T>>? validator,
    ValueChanged<Set<T>>? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    FormFieldAttachmentBuilder? attachmentBuilder,
    InputDecoration? decoration,
    bool showFullWidth = true,
    int? min,
    int? max,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (state) => _Widget<T>(
            state: state,
            contentBuilder: contentBuilder,
            fieldBuilder: fieldBuilder,
            onChanged: onChanged,
            title: title,
            attachmentBuilder: attachmentBuilder,
            decoration: decoration,
            showFullWidth: showFullWidth,
            min: min,
            max: max,
          ),
        );
}

class _Widget<T> extends StatelessWidget {
  const _Widget({
    Key? key,
    required this.state,
    required this.title,
    required this.contentBuilder,
    required this.fieldBuilder,
    this.onChanged,
    this.attachmentBuilder,
    this.decoration,
    this.showFullWidth = true,
    this.min,
    this.max,
  }) : super(key: key);

  final FormFieldState<Set<T>> state;
  final ValueChanged<Set<T>>? onChanged;
  final Widget title;
  final MultiItemFormFieldBuilderContentBuilder<T> contentBuilder;
  final MultiItemFormFieldBuilderFieldBuilder<T> fieldBuilder;
  final FormFieldAttachmentBuilder? attachmentBuilder;
  final InputDecoration? decoration;
  final bool showFullWidth;
  final int? min;
  final int? max;

  // int get _toggledCount => state.value?.length ?? 0;

  // bool _minimumNotReached() => min == null || _toggledCount > min!;
  // bool _maximumNotReached() => max == null || _toggledCount < max!;
  // bool _shouldAllowChange(T val) => state.value?.contains(val) == true ? _minimumNotReached() : _maximumNotReached();

  void _updateValue(Set<T> value) {
    onChanged?.call(value);
    state.didChange(value);
  }

  Future<Set<T>> _pickUnit(BuildContext context) async {
    final scrollController = ScrollController();
    final scrollToggle = ScrollControllerToggle(controller: scrollController);
    final notifier = ValueNotifier<Set<T>?>(state.value?.isNotEmpty == true ? state.value : null);
    final key = title is Text ? (title as Text).data : T.toString();
    final attachment = attachmentBuilder?.call(context, 'model_list_form_field_ad_$key');
    final onUmounted = () {
      scrollToggle.dispose();
      scrollController.dispose();
      notifier.dispose();
    };

    // Users of this form field are intended to build a list or content widget,
    // for the model, and update the passed `notifier` as the items are toggled.
    final value = await showModal<Set<T>?>(
      context: context,
      builder: (context) {
        final strings = MaterialLocalizations.of(context);
        final content = ValueListenableBuilder<Set<T>?>(
          valueListenable: notifier,
          builder: (context, value, ___) {
            final toggledCount = notifier.value?.length ?? 0;
            final minimumNotReached = () => min == null || toggledCount > min!;
            final maximumNotReached = () => max == null || toggledCount < max!;
            final shouldAllowChange =
                (T val) => value?.contains(val) == true ? minimumNotReached() : maximumNotReached();

            final getToggle = (T v) => shouldAllowChange(v)
                ? () => notifier.value = notifier.value?.contains(v) == true
                    ? <T>{...notifier.value!.where((x) => x != v)}
                    : <T>{...notifier.value ?? <T>{}, v}
                : null;

            return contentBuilder(context, notifier, scrollController, getToggle);
          },
        );
        final buttons = [
          TextButton(
            child: Text(strings.cancelButtonLabel, layoutTwice: true),
            onPressed: () => Navigator.pop(context),
          ),
          ValueListenableBuilder<Set<T>?>(
            valueListenable: notifier,
            builder: (_, selectedValue, child) => TextButton(
              child: Text(strings.okButtonLabel, layoutTwice: true),
              onPressed: selectedValue != null ? () => Navigator.pop(context, selectedValue) : null,
            ),
          ),
        ];

        return ProxyWidgetBuilder(
          onUnmounted: onUmounted,
          child: ValueListenableBuilder<bool>(
            valueListenable: scrollToggle,
            builder: (_, overlapsContent, ___) => MaterialDialogContainer(
              title: title,
              content: content,
              overlapsContent: overlapsContent,
              buttons: buttons,
              attachment: attachment,
              showFullWidth: showFullWidth,
            ),
          ),
        );
      },
    );

    if (state.mounted && value != null) _updateValue(value);
    return value ?? state.value ?? <T>{};
  }

  /// Swaps `a` -> `b`.
  void _swapValues(T a, T b) {
    assert(state.value?.contains(a) == true);
    assert(state.value?.contains(b) == true);

    final list = state.value?.toList(growable: false) ?? <T>[];
    final indexOfA = list.indexOf(a);
    final indexOfB = list.indexOf(b);
    final newList = List<T>.generate(
      list.length,
      (i) {
        if (i == indexOfA) {
          return b;
        } else if (i == indexOfB) {
          return a;
        } else {
          return list[i];
        }
      },
      growable: false,
    );

    _updateValue(newList.toSet());
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = decoration ?? const InputDecoration(counterText: '');
    final toggledCount = state.value?.length ?? 0;
    final minimumNotReached = () => min == null || toggledCount > min!;
    final maximumNotReached = () => max == null || toggledCount < max!;
    final shouldAllowChange = (T val) => state.value?.contains(val) == true ? minimumNotReached() : maximumNotReached();

    final getToggle = (T v) => shouldAllowChange(v)
        ? () => _updateValue(state.value?.contains(v) == true
            ? <T>{...state.value!.where((x) => x != v)}
            : <T>{...state.value ?? <T>{}, v})
        : null;

    return InputDecorator(
      isEmpty: state.value?.isNotEmpty != true,
      child: fieldBuilder(context, state.value ?? <T>{}, _pickUnit, getToggle, _swapValues),
      decoration: inputDecoration.copyWith(
        errorText: state.hasError ? state.errorText : null,
        counterText: inputDecoration.hintText ?? (max != null ? '${state.value?.length ?? 0}/$max' : null),
      ),
    );
  }
}
