import 'package:form_fields/src/editable_chip.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

part 'chip_text_form_field.freezed.dart';

@freezed
class _Chip with _$_Chip {
  const factory _Chip({
    required GlobalKey<EditableChipState> key,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) = __Chip;

  const _Chip._();

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class ChipTextFormField extends FormField<List<String>> {
  ChipTextFormField({
    Key? key,
    List<String>? initialValue,
    String? currency,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
    ValueChanged<List<String>?>? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    InputDecoration? decoration,
    TextStyle? style,
    FormFieldAttachmentBuilder? attachmentBuilder,
    Widget? avatar,
    EditableChipWrap? wrap,
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
            decoration: decoration,
            style: style,
            attachmentBuilder: attachmentBuilder,
            currency: currency,
            avatar: avatar,
            wrap: wrap,
            initialValue: initialValue,
          ),
        );

  static IconData flagIcon = Icons.flag;
}

class _Widget extends StatefulWidget {
  const _Widget({
    required this.state,
    this.onChanged,
    this.decoration,
    this.style,
    this.attachmentBuilder,
    this.currency,
    this.avatar,
    this.wrap,
    this.initialValue,
  });

  final FormFieldState<List<String>> state;
  final ValueChanged<List<String>?>? onChanged;
  final InputDecoration? decoration;
  final TextStyle? style;
  final FormFieldAttachmentBuilder? attachmentBuilder;
  final String? currency;
  final Widget? avatar;
  final EditableChipWrap? wrap;
  final List<String>? initialValue;

  @override
  __WidgetState createState() => __WidgetState();
}

class __WidgetState extends State<_Widget> {
  final _scrollController = ScrollController();
  final _chips = <_Chip>[];

  bool _isFocused = false;
  bool get _isEmpty => _chips.isEmpty;

  void _handleChange() {
    final value = _chips.map((x) => x.controller.text).toList(growable: false);
    widget.onChanged?.call(value);
    widget.state.didChange(value);
  }

  /// Sets `_isFocused` = true, when one of the `_chips` has focus.
  void _checkIsFocused() {
    bool isFocused = false;

    for (final chip in _chips) {
      if (chip.focusNode.hasFocus) {
        isFocused = true;
        break;
      }
    }

    if (_isFocused != isFocused) {
      _isFocused = isFocused;
      markNeedsBuild();
    }
  }

  void _handleFieldTap() {
    if (_chips.isEmpty) {
      addChip();
    } else if (_chips.last.controller.text.isEmpty) {
      _chips.last.focusNode.requestFocus();
    } else {
      // If a chip is empty and without focus, it is deleted.
      //
      // Spawn a new chip, when tapping the input field without
      // any focused chips.
      for (final chip in _chips) {
        if (chip.focusNode.hasFocus == true) {
          chip.key.currentState?.requestKeyboard();
          return;
        }
      }

      addChip();
    }
  }

  void addChip({
    String? initialValue,
    bool scrollToEnd = true,
    bool requestFocus = true,
  }) {
    final chip = _Chip(
      key: GlobalKey<EditableChipState>(),
      controller: TextEditingController(text: initialValue ?? ''),
      focusNode: FocusNode(),
    );

    _chips.add(chip);
    chip.focusNode.addListener(_checkIsFocused);
    chip.controller.addListener(_handleChange);
    markNeedsBuild();

    if (!requestFocus && !scrollToEnd) return;

    // Focus change animates the [EditableChip] from text field to a chip.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!mounted) return;
      if (requestFocus) {
        if (chip.controller.text.isEmpty) chip.focusNode.requestFocus();
      }

      if (scrollToEnd) {
        // Needs another frame for the correct scroll extent.
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (!mounted) return;
          // Use duration and curve from [EditableText._caretAnimation].
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
          );
        });
      }
    });
  }

  void _removeChip(_Chip chip) {
    final removed = _chips.remove(chip);
    if (removed) {
      markNeedsBuild();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (mounted) chip.dispose();
      });
    }
  }

  Widget _buildChip(int i) {
    final chip = _chips[i];
    return SliverPadding(
      padding: EdgeInsets.only(
        left: i != 0 ? 4.0 : 0.0,
        right: i != _chips.length - 1 ? 4.0 : 0.0,
      ),
      sliver: SliverToBoxAdapter(
        child: EditableChip(
          key: chip.key,
          controller: chip.controller,
          focusNode: chip.focusNode,
          avatar: widget.avatar,
          onBreakPoint: addChip,
          onDeleted: () => _removeChip(chip),
          onFocusLost: () => (chip.controller.text.trim().isEmpty) ? _removeChip(chip) : null,
          wrap: widget.wrap,
        ),
      ),
    );
  }

  @override
  void initState() {
    for (final val in widget.initialValue ?? const <String>[]) {
      addChip(initialValue: val, scrollToEnd: false, requestFocus: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final chip in _chips) chip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = widget.decoration ?? const InputDecoration(hintText: '', counterText: '');
    final container = InputDecorator(
      isFocused: _isFocused,
      isEmpty: _isEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: SizedBox(
          height: 32.0, // Material chip height.
          child: UnboundedCustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            // Compensate for the edge of chip container, so the [EditableText]
            // can be mounted and handle scrollview scrolling, when typing.
            cacheExtent: 64.0,
            // NOTE: [EditableChip] state must be kept alive
            slivers: List<Widget>.generate(_chips.length, _buildChip, growable: false),
          ),
        ),
      ),
      decoration: inputDecoration.copyWith(
        errorText: widget.state.hasError ? widget.state.errorText : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: addChip,
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleFieldTap,
      child: container,
    );
  }
}
