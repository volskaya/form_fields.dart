import 'package:form_fields/src/currency_text_input_formatter.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyTextFormField extends FormField<int> {
  MoneyTextFormField({
    Key? key,
    int? initialValue,
    String? currency,
    FormFieldSetter<int>? onSaved,
    FormFieldValidator<int>? validator,
    ValueChanged<int?>? onChanged,
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
          builder: (state) => _Widget(
            state: state,
            onChanged: onChanged,
            controller: controller,
            focusNode: focusNode,
            decoration: decoration,
            style: style,
            attachmentBuilder: attachmentBuilder,
            currency: currency,
          ),
        );

  static IconData flagIcon = Icons.flag;
}

class _Widget extends StatefulWidget {
  const _Widget({
    required this.state,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.attachmentBuilder,
    this.currency,
  });

  final FormFieldState<int> state;
  final ValueChanged<int?>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final FormFieldAttachmentBuilder? attachmentBuilder;
  final String? currency;

  @override
  __WidgetState createState() => __WidgetState();
}

class __WidgetState extends State<_Widget> {
  static final _onlyNumbersRegex = RegExp(r'[^\d.]');

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;

  void _handleControllerChange() {
    final text = _controller.text.replaceAll(_onlyNumbersRegex, '');
    final value = text.isNotEmpty ? (double.parse(text) * 100).round() : 0;

    widget.onChanged?.call(value);
    widget.state.didChange(value);
  }

  @override
  void initState() {
    _shouldDisposeController = widget.controller == null;
    _shouldDisposeFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = (widget.controller ??
        TextEditingController(
          text: widget.state.value != null && widget.state.value! > 0
              ? (widget.state.value! / 100).toStringAsFixed(2)
              : '',
        ))
      ..addListener(_handleControllerChange);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handleControllerChange);
    if (_shouldDisposeController) _controller.dispose();
    if (_shouldDisposeFocusNode) _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecoration = widget.decoration ?? const InputDecoration(hintText: '', counterText: '');
    final inputFormatter = CurrencyTextInputFormatter(
      locale: Localizations.localeOf(context).toString(),
      decimalDigits: 2,
      symbol: '', // Symbol is added as a prefix icon to the [TextField.decoration].
    );

    return TextField(
      controller: _controller,
      enabled: widget.state.widget.enabled,
      style: widget.style,
      onLongPress: () => _controller.text = '',
      keyboardType: const TextInputType.numberWithOptions(),
      textInputAction: TextInputAction.done,
      focusNode: _focusNode,
      inputFormatters: [inputFormatter],
      enableInteractiveSelection: false,
      decoration: inputDecoration.copyWith(
        errorText: widget.state.hasError ? widget.state.errorText : null,
        prefix: widget.currency != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  widget.currency!,
                  style: theme.textTheme.overline!.apply(color: theme.hintColor),
                  layoutTwice: true,
                ),
              )
            : null,
      ),
    );
  }
}
