import 'package:flutter/material.dart';

class ChipToggleFormField<T> extends FormField<Set<T>> {
  ChipToggleFormField({
    Key? key,
    required Set<T> items,
    required String Function(T value) getText,
    Set<T>? initialValue,
    FormFieldSetter<Set<T>>? onSaved,
    FormFieldValidator<Set<T>>? validator,
    ValueChanged<Set<T>>? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    InputDecoration? decoration,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (state) => _Widget<T>(
            items: items,
            getText: getText,
            state: state,
            onChanged: onChanged,
            decoration: decoration,
          ),
        );
}

class _Widget<T> extends StatelessWidget {
  const _Widget({
    required this.state,
    required this.items,
    required this.getText,
    this.onChanged,
    this.decoration,
    this.min,
    this.max,
  });

  final String Function(T value) getText;
  final Set<T> items;
  final FormFieldState<Set<T>> state;
  final ValueChanged<Set<T>>? onChanged;
  final InputDecoration? decoration;
  final int? min;
  final int? max;

  int get _toggledCount => state.value?.length ?? 0;

  bool _minimumNotReached() => min == null || _toggledCount > min!;
  bool _maximumNotReached() => max == null || _toggledCount < max!;
  bool _shouldAllowChange(T val) => state.value?.contains(val) == true ? _minimumNotReached() : _maximumNotReached();

  void _handleChange(Set<T> value) {
    onChanged?.call(value);
    state.didChange(value);
  }

  Widget _buildChip(T value) => ChoiceChip(
        label: Text(getText(value), maxLines: 1, layoutTwice: true),
        selected: state.value?.contains(value) == true,
        onSelected: _shouldAllowChange(value)
            ? (selected) => _handleChange(
                  selected
                      ? <T>{...state.value ?? <T>{}, value}
                      : <T>{...(state.value ?? <T>{}).where((x) => x != value)},
                )
            : null,
      );

  @override
  Widget build(BuildContext context) {
    final inputDecoration = decoration ?? const InputDecoration(hintText: '', counterText: '');
    final chips = items.map(_buildChip).toList(growable: false);

    return InputDecorator(
      isFocused: false,
      isEmpty: chips.isEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: SizedBox(
          height: 32.0, // Material chip height.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: chips,
          ),
        ),
      ),
      decoration: inputDecoration.copyWith(
        errorText: state.hasError ? state.errorText : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      ),
    );
  }
}
