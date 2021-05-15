import 'package:animations/animations.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MultiUnitTextFormField<T> extends FormField<Set<T>> {
  MultiUnitTextFormField({
    required List<T> items,
    required Widget Function(BuildContext context, T value) itemBuilder,
    required String Function(Set<T> value) getText,
    required Widget title,
    Widget? Function(BuildContext, T value)? secondaryBuilder,
    bool Function(T? value)? getValueState,
    bool shrinkWrap = false,
    bool toggleable = true,
    Key? key,
    Set<T>? defaultValue,
    Set<T>? initialValue,
    FormFieldSetter<Set<T>>? onSaved,
    FormFieldValidator<Set<T>>? validator,
    ValueChanged<Set<T>?>? onChanged,
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
    this.toggleable = true,
    this.shrinkWrap = false,
    this.attachmentBuilder,
  });

  final FormFieldState<Set<T>> state;
  final ValueChanged<Set<T>?>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final List<T> items;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget? Function(BuildContext, T value)? secondaryBuilder;
  final String Function(Set<T> value) getText;
  final Widget title;
  final bool shrinkWrap;
  final bool toggleable;
  final Set<T>? defaultValue;
  final bool Function(T? value)? getValueState;
  final FormFieldAttachmentBuilder? attachmentBuilder;

  @override
  __WidgetState<T> createState() => __WidgetState<T>();
}

class __WidgetState<T> extends State<_Widget<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;

  void _updateValue([Set<T>? value]) {
    final _value = value ?? widget.defaultValue ?? <T>{};
    _controller.text = widget.getText(_value);
    widget.onChanged?.call(_value);
    widget.state.didChange(_value);
  }

  Future _pickUnit() async {
    final scrollController = ScrollController();
    final scrollToggle = ScrollControllerToggle(controller: scrollController);
    final notifier = ValueNotifier<Set<T>?>(widget.state.value?.isNotEmpty == true ? widget.state.value : null);
    final key = widget.title is Text ? (widget.title as Text).data : T.toString();
    final attachment = widget.attachmentBuilder?.call(context, 'unit_text_form_field_ad_$key');

    final value = await showModal<Set<T>?>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final strings = MaterialLocalizations.of(context);
        final buttons = [
          TextButton(
            child: Text(strings.cancelButtonLabel, layoutTwice: true),
            onPressed: () => Navigator.pop(context),
          ),
          ValueListenableBuilder<Set<T>?>(
            valueListenable: notifier,
            builder: (_, selectedValue, child) => TextButton(
              child: Text(strings.okButtonLabel, layoutTwice: true),
              onPressed: selectedValue != null ? () => Navigator.pop(context, notifier.value) : null,
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

                  return ValueListenableBuilder<Set<T>?>(
                    valueListenable: notifier,
                    builder: (_, selectedValue, ___) => RadioListTile<T>(
                      contentPadding: const EdgeInsets.only(left: 12, right: 24),
                      value: item,
                      toggleable: widget.toggleable,
                      groupValue: selectedValue?.contains(item) == true ? item : null,
                      title: child,
                      secondary: secondary,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (widget.getValueState?.call(item) ?? true)
                          ? (val) => notifier.value = val != null
                              ? <T>{...notifier.value ?? <T>{}, item}
                              : (<T>{...notifier.value ?? <T>{}}..remove(item))
                          : null,
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

    _updateValue(value);
    if ((widget.state.value?.isEmpty ?? true) == true)
      WidgetsBinding.instance!.addPostFrameCallback((_) => mounted ? _focusNode.unfocus() : null);
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
