// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'photo_form_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PhotoFormFieldValueTearOff {
  const _$PhotoFormFieldValueTearOff();

  _LocalFileValue local({required File file, FirebaseImage? previousValue}) {
    return _LocalFileValue(
      file: file,
      previousValue: previousValue,
    );
  }

  _OnlineFileValue online({required FirebaseImage imageProvider}) {
    return _OnlineFileValue(
      imageProvider: imageProvider,
    );
  }
}

/// @nodoc
const $PhotoFormFieldValue = _$PhotoFormFieldValueTearOff();

/// @nodoc
mixin _$PhotoFormFieldValue {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File file, FirebaseImage? previousValue) local,
    required TResult Function(FirebaseImage imageProvider) online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File file, FirebaseImage? previousValue)? local,
    TResult Function(FirebaseImage imageProvider)? online,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocalFileValue value) local,
    required TResult Function(_OnlineFileValue value) online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocalFileValue value)? local,
    TResult Function(_OnlineFileValue value)? online,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoFormFieldValueCopyWith<$Res> {
  factory $PhotoFormFieldValueCopyWith(
          PhotoFormFieldValue value, $Res Function(PhotoFormFieldValue) then) =
      _$PhotoFormFieldValueCopyWithImpl<$Res>;
}

/// @nodoc
class _$PhotoFormFieldValueCopyWithImpl<$Res>
    implements $PhotoFormFieldValueCopyWith<$Res> {
  _$PhotoFormFieldValueCopyWithImpl(this._value, this._then);

  final PhotoFormFieldValue _value;
  // ignore: unused_field
  final $Res Function(PhotoFormFieldValue) _then;
}

/// @nodoc
abstract class _$LocalFileValueCopyWith<$Res> {
  factory _$LocalFileValueCopyWith(
          _LocalFileValue value, $Res Function(_LocalFileValue) then) =
      __$LocalFileValueCopyWithImpl<$Res>;
  $Res call({File file, FirebaseImage? previousValue});
}

/// @nodoc
class __$LocalFileValueCopyWithImpl<$Res>
    extends _$PhotoFormFieldValueCopyWithImpl<$Res>
    implements _$LocalFileValueCopyWith<$Res> {
  __$LocalFileValueCopyWithImpl(
      _LocalFileValue _value, $Res Function(_LocalFileValue) _then)
      : super(_value, (v) => _then(v as _LocalFileValue));

  @override
  _LocalFileValue get _value => super._value as _LocalFileValue;

  @override
  $Res call({
    Object? file = freezed,
    Object? previousValue = freezed,
  }) {
    return _then(_LocalFileValue(
      file: file == freezed
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      previousValue: previousValue == freezed
          ? _value.previousValue
          : previousValue // ignore: cast_nullable_to_non_nullable
              as FirebaseImage?,
    ));
  }
}

/// @nodoc
class _$_LocalFileValue implements _LocalFileValue {
  const _$_LocalFileValue({required this.file, this.previousValue});

  @override
  final File file;
  @override
  final FirebaseImage? previousValue;

  @override
  String toString() {
    return 'PhotoFormFieldValue.local(file: $file, previousValue: $previousValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LocalFileValue &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)) &&
            (identical(other.previousValue, previousValue) ||
                const DeepCollectionEquality()
                    .equals(other.previousValue, previousValue)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(file) ^
      const DeepCollectionEquality().hash(previousValue);

  @JsonKey(ignore: true)
  @override
  _$LocalFileValueCopyWith<_LocalFileValue> get copyWith =>
      __$LocalFileValueCopyWithImpl<_LocalFileValue>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File file, FirebaseImage? previousValue) local,
    required TResult Function(FirebaseImage imageProvider) online,
  }) {
    return local(file, previousValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File file, FirebaseImage? previousValue)? local,
    TResult Function(FirebaseImage imageProvider)? online,
    required TResult orElse(),
  }) {
    if (local != null) {
      return local(file, previousValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocalFileValue value) local,
    required TResult Function(_OnlineFileValue value) online,
  }) {
    return local(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocalFileValue value)? local,
    TResult Function(_OnlineFileValue value)? online,
    required TResult orElse(),
  }) {
    if (local != null) {
      return local(this);
    }
    return orElse();
  }
}

abstract class _LocalFileValue implements PhotoFormFieldValue {
  const factory _LocalFileValue(
      {required File file, FirebaseImage? previousValue}) = _$_LocalFileValue;

  File get file => throw _privateConstructorUsedError;
  FirebaseImage? get previousValue => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$LocalFileValueCopyWith<_LocalFileValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$OnlineFileValueCopyWith<$Res> {
  factory _$OnlineFileValueCopyWith(
          _OnlineFileValue value, $Res Function(_OnlineFileValue) then) =
      __$OnlineFileValueCopyWithImpl<$Res>;
  $Res call({FirebaseImage imageProvider});
}

/// @nodoc
class __$OnlineFileValueCopyWithImpl<$Res>
    extends _$PhotoFormFieldValueCopyWithImpl<$Res>
    implements _$OnlineFileValueCopyWith<$Res> {
  __$OnlineFileValueCopyWithImpl(
      _OnlineFileValue _value, $Res Function(_OnlineFileValue) _then)
      : super(_value, (v) => _then(v as _OnlineFileValue));

  @override
  _OnlineFileValue get _value => super._value as _OnlineFileValue;

  @override
  $Res call({
    Object? imageProvider = freezed,
  }) {
    return _then(_OnlineFileValue(
      imageProvider: imageProvider == freezed
          ? _value.imageProvider
          : imageProvider // ignore: cast_nullable_to_non_nullable
              as FirebaseImage,
    ));
  }
}

/// @nodoc
class _$_OnlineFileValue implements _OnlineFileValue {
  const _$_OnlineFileValue({required this.imageProvider});

  @override
  final FirebaseImage imageProvider;

  @override
  String toString() {
    return 'PhotoFormFieldValue.online(imageProvider: $imageProvider)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OnlineFileValue &&
            (identical(other.imageProvider, imageProvider) ||
                const DeepCollectionEquality()
                    .equals(other.imageProvider, imageProvider)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(imageProvider);

  @JsonKey(ignore: true)
  @override
  _$OnlineFileValueCopyWith<_OnlineFileValue> get copyWith =>
      __$OnlineFileValueCopyWithImpl<_OnlineFileValue>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File file, FirebaseImage? previousValue) local,
    required TResult Function(FirebaseImage imageProvider) online,
  }) {
    return online(imageProvider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File file, FirebaseImage? previousValue)? local,
    TResult Function(FirebaseImage imageProvider)? online,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(imageProvider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocalFileValue value) local,
    required TResult Function(_OnlineFileValue value) online,
  }) {
    return online(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocalFileValue value)? local,
    TResult Function(_OnlineFileValue value)? online,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(this);
    }
    return orElse();
  }
}

abstract class _OnlineFileValue implements PhotoFormFieldValue {
  const factory _OnlineFileValue({required FirebaseImage imageProvider}) =
      _$_OnlineFileValue;

  FirebaseImage get imageProvider => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$OnlineFileValueCopyWith<_OnlineFileValue> get copyWith =>
      throw _privateConstructorUsedError;
}
