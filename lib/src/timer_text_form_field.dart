import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:refresh_storage/refresh_storage.dart';

typedef TimeToStringCallback = String Function(TimeOfDay val);

class TimerTextFormField extends FormField<TimeOfDay> {
  TimerTextFormField({
    Key key,
    @required TimeToStringCallback getText,
    TimeOfDay initialValue,
    FormFieldSetter<TimeOfDay> onSaved,
    FormFieldValidator<TimeOfDay> validator,
    ValueChanged<TimeOfDay> onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    TextEditingController controller,
    FocusNode focusNode,
    InputDecoration decoration,
    TextStyle style,
    FormFieldAttachmentBuilder attachmentBuilder,
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
            getText: getText,
            attachmentBuilder: attachmentBuilder,
          ),
        );
}

class _Widget extends StatefulWidget {
  const _Widget({
    @required this.state,
    @required this.onChanged,
    @required this.getText,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.attachmentBuilder,
  });

  final FormFieldState<TimeOfDay> state;
  final ValueChanged<TimeOfDay> onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextStyle style;
  final TimeToStringCallback getText;
  final FormFieldAttachmentBuilder attachmentBuilder;

  @override
  __WidgetState createState() => __WidgetState();
}

class __WidgetState extends State<_Widget> {
  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;
  TextEditingController _controller;
  FocusNode _focusNode;

  void _updateValue([TimeOfDay value]) {
    _controller.text = value != null ? widget.getText(value) : '';
    widget.onChanged?.call(value);
    widget.state.didChange(value);
  }

  Future _pickUnit() async {
    final time = widget.state.value ?? TimeOfDay.now();
    final attachment = widget.attachmentBuilder?.call(context, 'timer_text_form_field');
    final value = await showTimePicker(
      context: context,
      initialTime: time,
      dialogBuilder: (_, builder) => showModal<TimeOfDay>(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0) + MediaQuery.of(context).padding,
          child: attachment != null
              ? RefreshStorage.wrapProvider(
                  state: attachment.storage,
                  child: MaterialDialogAttachmentContainer(
                    attachment: attachment.widget,
                    child: builder(context),
                  ),
                )
              : builder(context),
        ),
      ),
    );

    if (value != null) _updateValue(value);
    if (widget.state.value == null) WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode?.unfocus());
  }

  @override
  void initState() {
    _shouldDisposeController = widget.controller == null;
    _shouldDisposeFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ??
        TextEditingController(text: widget.state.value != null ? widget.getText(widget.state.value) : '');
    super.initState();
  }

  @override
  void dispose() {
    if (_shouldDisposeController) _controller?.dispose();
    if (_shouldDisposeFocusNode) _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = widget.decoration ?? const InputDecoration(hintText: '', counterText: '');
    return TextField(
      enabled: widget.state.widget.enabled,
      readOnly: true,
      style: widget.style,
      onTap: _pickUnit,
      onLongPress: _updateValue,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      decoration: inputDecoration.copyWith(
        errorText: widget.state.hasError ? widget.state.errorText : null,
      ),
    );
  }
}
