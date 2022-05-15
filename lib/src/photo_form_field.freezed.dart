// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'photo_form_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PhotoFormFieldValue {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File file, FirebaseImage? previousValue) local,
    required TResult Function(FirebaseImage imageProvider) online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(File file, FirebaseImage? previousValue)? local,
    TResult Function(FirebaseImage imageProvider)? online,
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocalFileValue value)? local,
    TResult Function(_OnlineFileValue value)? online,
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
abstract class _$$_LocalFileValueCopyWith<$Res> {
  factory _$$_LocalFileValueCopyWith(
          _$_LocalFileValue value, $Res Function(_$_LocalFileValue) then) =
      __$$_LocalFileValueCopyWithImpl<$Res>;
  $Res call({File file, FirebaseImage? previousValue});
}

/// @nodoc
class __$$_LocalFileValueCopyWithImpl<$Res>
    extends _$PhotoFormFieldValueCopyWithImpl<$Res>
    implements _$$_LocalFileValueCopyWith<$Res> {
  __$$_LocalFileValueCopyWithImpl(
      _$_LocalFileValue _value, $Res Function(_$_LocalFileValue) _then)
      : super(_value, (v) => _then(v as _$_LocalFileValue));

  @override
  _$_LocalFileValue get _value => super._value as _$_LocalFileValue;

  @override
  $Res call({
    Object? file = freezed,
    Object? previousValue = freezed,
  }) {
    return _then(_$_LocalFileValue(
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
        (other.runtimeType == runtimeType &&
            other is _$_LocalFileValue &&
            const DeepCollectionEquality().equals(other.file, file) &&
            const DeepCollectionEquality()
                .equals(other.previousValue, previousValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(file),
      const DeepCollectionEquality().hash(previousValue));

  @JsonKey(ignore: true)
  @override
  _$$_LocalFileValueCopyWith<_$_LocalFileValue> get copyWith =>
      __$$_LocalFileValueCopyWithImpl<_$_LocalFileValue>(this, _$identity);

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
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(File file, FirebaseImage? previousValue)? local,
    TResult Function(FirebaseImage imageProvider)? online,
  }) {
    return local?.call(file, previousValue);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocalFileValue value)? local,
    TResult Function(_OnlineFileValue value)? online,
  }) {
    return local?.call(this);
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
      {required final File file,
      final FirebaseImage? previousValue}) = _$_LocalFileValue;

  File get file => throw _privateConstructorUsedError;
  FirebaseImage? get previousValue => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$_LocalFileValueCopyWith<_$_LocalFileValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_OnlineFileValueCopyWith<$Res> {
  factory _$$_OnlineFileValueCopyWith(
          _$_OnlineFileValue value, $Res Function(_$_OnlineFileValue) then) =
      __$$_OnlineFileValueCopyWithImpl<$Res>;
  $Res call({FirebaseImage imageProvider});
}

/// @nodoc
class __$$_OnlineFileValueCopyWithImpl<$Res>
    extends _$PhotoFormFieldValueCopyWithImpl<$Res>
    implements _$$_OnlineFileValueCopyWith<$Res> {
  __$$_OnlineFileValueCopyWithImpl(
      _$_OnlineFileValue _value, $Res Function(_$_OnlineFileValue) _then)
      : super(_value, (v) => _then(v as _$_OnlineFileValue));

  @override
  _$_OnlineFileValue get _value => super._value as _$_OnlineFileValue;

  @override
  $Res call({
    Object? imageProvider = freezed,
  }) {
    return _then(_$_OnlineFileValue(
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
        (other.runtimeType == runtimeType &&
            other is _$_OnlineFileValue &&
            const DeepCollectionEquality()
                .equals(other.imageProvider, imageProvider));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(imageProvider));

  @JsonKey(ignore: true)
  @override
  _$$_OnlineFileValueCopyWith<_$_OnlineFileValue> get copyWith =>
      __$$_OnlineFileValueCopyWithImpl<_$_OnlineFileValue>(this, _$identity);

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
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(File file, FirebaseImage? previousValue)? local,
    TResult Function(FirebaseImage imageProvider)? online,
  }) {
    return online?.call(imageProvider);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocalFileValue value)? local,
    TResult Function(_OnlineFileValue value)? online,
  }) {
    return online?.call(this);
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
  const factory _OnlineFileValue({required final FirebaseImage imageProvider}) =
      _$_OnlineFileValue;

  FirebaseImage get imageProvider => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$_OnlineFileValueCopyWith<_$_OnlineFileValue> get copyWith =>
      throw _privateConstructorUsedError;
}
