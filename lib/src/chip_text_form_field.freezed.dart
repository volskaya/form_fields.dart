// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chip_text_form_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$_Chip {
  GlobalKey<EditableChipState> get key => throw _privateConstructorUsedError;
  TextEditingController get controller => throw _privateConstructorUsedError;
  FocusNode get focusNode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  _$ChipCopyWith<_Chip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ChipCopyWith<$Res> {
  factory _$ChipCopyWith(_Chip value, $Res Function(_Chip) then) =
      __$ChipCopyWithImpl<$Res>;
  $Res call(
      {GlobalKey<EditableChipState> key,
      TextEditingController controller,
      FocusNode focusNode});
}

/// @nodoc
class __$ChipCopyWithImpl<$Res> implements _$ChipCopyWith<$Res> {
  __$ChipCopyWithImpl(this._value, this._then);

  final _Chip _value;
  // ignore: unused_field
  final $Res Function(_Chip) _then;

  @override
  $Res call({
    Object? key = freezed,
    Object? controller = freezed,
    Object? focusNode = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as GlobalKey<EditableChipState>,
      controller: controller == freezed
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      focusNode: focusNode == freezed
          ? _value.focusNode
          : focusNode // ignore: cast_nullable_to_non_nullable
              as FocusNode,
    ));
  }
}

/// @nodoc
abstract class _$$__ChipCopyWith<$Res> implements _$ChipCopyWith<$Res> {
  factory _$$__ChipCopyWith(_$__Chip value, $Res Function(_$__Chip) then) =
      __$$__ChipCopyWithImpl<$Res>;
  @override
  $Res call(
      {GlobalKey<EditableChipState> key,
      TextEditingController controller,
      FocusNode focusNode});
}

/// @nodoc
class __$$__ChipCopyWithImpl<$Res> extends __$ChipCopyWithImpl<$Res>
    implements _$$__ChipCopyWith<$Res> {
  __$$__ChipCopyWithImpl(_$__Chip _value, $Res Function(_$__Chip) _then)
      : super(_value, (v) => _then(v as _$__Chip));

  @override
  _$__Chip get _value => super._value as _$__Chip;

  @override
  $Res call({
    Object? key = freezed,
    Object? controller = freezed,
    Object? focusNode = freezed,
  }) {
    return _then(_$__Chip(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as GlobalKey<EditableChipState>,
      controller: controller == freezed
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      focusNode: focusNode == freezed
          ? _value.focusNode
          : focusNode // ignore: cast_nullable_to_non_nullable
              as FocusNode,
    ));
  }
}

/// @nodoc

class _$__Chip extends __Chip {
  const _$__Chip(
      {required this.key, required this.controller, required this.focusNode})
      : super._();

  @override
  final GlobalKey<EditableChipState> key;
  @override
  final TextEditingController controller;
  @override
  final FocusNode focusNode;

  @override
  String toString() {
    return '_Chip(key: $key, controller: $controller, focusNode: $focusNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$__Chip &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality()
                .equals(other.controller, controller) &&
            const DeepCollectionEquality().equals(other.focusNode, focusNode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(controller),
      const DeepCollectionEquality().hash(focusNode));

  @JsonKey(ignore: true)
  @override
  _$$__ChipCopyWith<_$__Chip> get copyWith =>
      __$$__ChipCopyWithImpl<_$__Chip>(this, _$identity);
}

abstract class __Chip extends _Chip {
  const factory __Chip(
      {required final GlobalKey<EditableChipState> key,
      required final TextEditingController controller,
      required final FocusNode focusNode}) = _$__Chip;
  const __Chip._() : super._();

  @override
  GlobalKey<EditableChipState> get key => throw _privateConstructorUsedError;
  @override
  TextEditingController get controller => throw _privateConstructorUsedError;
  @override
  FocusNode get focusNode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$__ChipCopyWith<_$__Chip> get copyWith =>
      throw _privateConstructorUsedError;
}
