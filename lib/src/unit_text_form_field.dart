import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:utils/utils.dart';

typedef UnitTextFormFieldItemBuilder<T> = Widget Function(BuildContext context, T value);
typedef UnitTextFormFieldTextBuilder<T> = String Function(T? value);
typedef UnitTextFormFieldSecondaryBuilder<T> = Widget? Function(BuildContext, T value);
typedef UnitTextFormFieldCustomValue<T> = Future<T?> Function(
  BuildContext context,
  List<T> items,
  T? previousValue,
  Widget title,
  UnitTextFormFieldTextBuilder<T> getText,
  UnitTextFormFieldItemBuilder<T> itemBuilder,
  UnitTextFormFieldSecondaryBuilder? secondaryBuilder,
);

class UnitTextFormField<T> extends FormField<T> {
  UnitTextFormField({
    required List<T> items,
    required UnitTextFormFieldItemBuilder<T> itemBuilder,
    required UnitTextFormFieldTextBuilder<T> getText,
    required Widget title,
    UnitTextFormFieldCustomValue<T>? pickValue,
    UnitTextFormFieldSecondaryBuilder? secondaryBuilder,
    bool Function(T? value)? getValueState,
    bool shrinkWrap = false,
    bool toggleable = false,
    Key? key,
    T? defaultValue,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    ValueChanged<T?>? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextStyle? style,
    FormFieldAttachmentBuilder? attachmentBuilder,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (state) => _Widget<T>(
            state: state,
            onChanged: onChanged,
            controller: controller,
            focusNode: focusNode,
            decoration: decoration,
            defaultValue: defaultValue,
            getValueState: getValueState,
            style: style,
            items: items,
            itemBuilder: itemBuilder,
            secondaryBuilder: secondaryBuilder,
            getText: getText,
            shrinkWrap: shrinkWrap,
            toggleable: toggleable,
            title: title,
            attachmentBuilder: attachmentBuilder,
            pickValue: pickValue,
          ),
        );
}

class _Widget<T> extends StatefulWidget {
  const _Widget({
    required this.state,
    required this.items,
    required this.itemBuilder,
    required this.getText,
    required this.title,
    this.secondaryBuilder,
    this.onChanged,
    this.getValueState,
    this.defaultValue,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.toggleable = false,
    this.shrinkWrap = false,
    this.attachmentBuilder,
    this.pickValue,
  });

  final FormFieldState<T> state;
  final ValueChanged<T?>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final List<T> items;
  final UnitTextFormFieldItemBuilder<T> itemBuilder;
  final UnitTextFormFieldSecondaryBuilder? secondaryBuilder;
  final UnitTextFormFieldTextBuilder<T> getText;
  final Widget title;
  final bool shrinkWrap;
  final bool toggleable;
  final T? defaultValue;
  final bool Function(T? value)? getValueState;
  final FormFieldAttachmentBuilder? attachmentBuilder;
  final UnitTextFormFieldCustomValue<T>? pickValue;

  @override
  __WidgetState<T> createState() => __WidgetState<T>();
}

class __WidgetState<T> extends State<_Widget<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;

  void _updateValue([T? value]) {
    final _value = value ?? widget.defaultValue;
    widget.onChanged?.call(_value);

    if (mounted) {
      _controller.text = _value != null ? widget.getText(_value) : '';
      widget.state.didChange(_value);
    }
  }

  Future _pickUnit() async {
    T? value;

    if (widget.pickValue != null) {
      value = await widget.pickValue!(
        context,
        widget.items,
        widget.state.value,
        widget.title,
        widget.getText,
        widget.itemBuilder,
        widget.secondaryBuilder,
      );
    } else {
      final scrollController = ScrollController();
      final scrollToggle = ScrollControllerToggle(controller: scrollController);
      final notifier = ValueNotifier<T?>(widget.state.value);
      final key = widget.title is Text ? (widget.title as Text).data : T.toString();
      final attachment = widget.attachmentBuilder?.call(context, 'unit_text_form_field_ad_$key');

      value = await showModal<T>(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          final strings = MaterialLocalizations.of(context);
          final buttons = [
            TextButton(
              child: Text(strings.cancelButtonLabel, shrinkWrap: true),
              onPressed: () => Navigator.pop(context),
            ),
            ValueListenableBuilder<T?>(
              valueListenable: notifier,
              builder: (_, selectedValue, child) => TextButton(
                child: Text(strings.okButtonLabel, shrinkWrap: true),
                onPressed:
                    (widget.toggleable || selectedValue != null) && (widget.getValueState?.call(selectedValue) ?? true)
                        ? () => Navigator.pop(context, notifier.value)
                        : null,
              ),
            ),
          ];

          final content = UnboundedCustomScrollView(
            controller: scrollController,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.shrinkWrap ? const ClampingScrollPhysics() : const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFixedExtentList(
                itemExtent: 56.0,
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final item = widget.items[i];
                    final child = widget.itemBuilder(context, item);
                    final secondary = widget.secondaryBuilder?.call(context, item);

                    return ValueListenableBuilder<T?>(
                      valueListenable: notifier,
                      builder: (_, selectedValue, ___) => RadioListTile<T>(
                        contentPadding: const EdgeInsets.only(left: 12, right: 24),
                        value: item,
                        toggleable: widget.toggleable,
                        groupValue: selectedValue,
                        title: child,
                        secondary: secondary,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (widget.getValueState?.call(item) ?? true) ? (val) => notifier.value = val : null,
                      ),
                    );
                  },
                  addAutomaticKeepAlives: false,
                  childCount: widget.items.length,
                ),
              ),
            ],
          );

          return ProxyWidgetBuilder(
            onUnmounted: () {
              scrollToggle.dispose();
              scrollController.dispose();
              notifier.dispose();
            },
            child: ValueListenableBuilder<bool>(
              valueListenable: scrollToggle,
              builder: (_, overlapsContent, ___) => MaterialDialogContainer(
                title: widget.title,
                content: content,
                overlapsContent: overlapsContent,
                buttons: buttons,
                attachment: attachment,
              ),
            ),
          );
        },
      );
    }

    if (value != null) _updateValue(value);
    if (widget.state.value == null)
      WidgetsBinding.instance.addPostFrameCallback((_) => mounted ? _focusNode.unfocus() : null);
  }

  @override
  void initState() {
    super.initState();
    _shouldDisposeController = widget.controller == null;
    _shouldDisposeFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ??
        TextEditingController(text: widget.state.value != null ? widget.getText(widget.state.value!) : '');
  }

  @override
  void dispose() {
    if (_shouldDisposeController) _controller.dispose();
    if (_shouldDisposeFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecoration = widget.decoration ?? const InputDecoration(hintText: '', counterText: '');

    return TextField(
      enabled: widget.state.widget.enabled,
      readOnly: true,
      style: widget.style ?? theme.textTheme.bodyText1,
      onTap: _pickUnit,
      onLongPress: _updateValue,
      controller: _controller,
      focusNode: _focusNode,
      decoration: inputDecoration.copyWith(
        errorText: widget.state.hasError ? widget.state.errorText : null,
      ),
    );
  }
}
