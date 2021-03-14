// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'photo_form_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$PhotoFormFieldValueTearOff {
  const _$PhotoFormFieldValueTearOff();

// ignore: unused_element
  _LocalFileValue local({@required File file}) {
    return _LocalFileValue(
      file: file,
    );
  }

// ignore: unused_element
  _OnlineFileValue online({@required ImageProvider<Object> imageProvider}) {
    return _OnlineFileValue(
      imageProvider: imageProvider,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $PhotoFormFieldValue = _$PhotoFormFieldValueTearOff();

/// @nodoc
mixin _$PhotoFormFieldValue {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult local(File file),
    @required TResult online(ImageProvider<Object> imageProvider),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult local(File file),
    TResult online(ImageProvider<Object> imageProvider),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult local(_LocalFileValue value),
    @required TResult online(_OnlineFileValue value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult local(_LocalFileValue value),
    TResult online(_OnlineFileValue value),
    @required TResult orElse(),
  });
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
  $Res call({File file});
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
    Object file = freezed,
  }) {
    return _then(_LocalFileValue(
      file: file == freezed ? _value.file : file as File,
    ));
  }
}

/// @nodoc
class _$_LocalFileValue implements _LocalFileValue {
  const _$_LocalFileValue({@required this.file}) : assert(file != null);

  @override
  final File file;

  @override
  String toString() {
    return 'PhotoFormFieldValue.local(file: $file)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LocalFileValue &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(file);

  @override
  _$LocalFileValueCopyWith<_LocalFileValue> get copyWith =>
      __$LocalFileValueCopyWithImpl<_LocalFileValue>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult local(File file),
    @required TResult online(ImageProvider<Object> imageProvider),
  }) {
    assert(local != null);
    assert(online != null);
    return local(file);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult local(File file),
    TResult online(ImageProvider<Object> imageProvider),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (local != null) {
      return local(file);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult local(_LocalFileValue value),
    @required TResult online(_OnlineFileValue value),
  }) {
    assert(local != null);
    assert(online != null);
    return local(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult local(_LocalFileValue value),
    TResult online(_OnlineFileValue value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (local != null) {
      return local(this);
    }
    return orElse();
  }
}

abstract class _LocalFileValue implements PhotoFormFieldValue {
  const factory _LocalFileValue({@required File file}) = _$_LocalFileValue;

  File get file;
  _$LocalFileValueCopyWith<_LocalFileValue> get copyWith;
}

/// @nodoc
abstract class _$OnlineFileValueCopyWith<$Res> {
  factory _$OnlineFileValueCopyWith(
          _OnlineFileValue value, $Res Function(_OnlineFileValue) then) =
      __$OnlineFileValueCopyWithImpl<$Res>;
  $Res call({ImageProvider<Object> imageProvider});
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
    Object imageProvider = freezed,
  }) {
    return _then(_OnlineFileValue(
      imageProvider: imageProvider == freezed
          ? _value.imageProvider
          : imageProvider as ImageProvider<Object>,
    ));
  }
}

/// @nodoc
class _$_OnlineFileValue implements _OnlineFileValue {
  const _$_OnlineFileValue({@required this.imageProvider})
      : assert(imageProvider != null);

  @override
  final ImageProvider<Object> imageProvider;

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

  @override
  _$OnlineFileValueCopyWith<_OnlineFileValue> get copyWith =>
      __$OnlineFileValueCopyWithImpl<_OnlineFileValue>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult local(File file),
    @required TResult online(ImageProvider<Object> imageProvider),
  }) {
    assert(local != null);
    assert(online != null);
    return online(imageProvider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult local(File file),
    TResult online(ImageProvider<Object> imageProvider),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (online != null) {
      return online(imageProvider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult local(_LocalFileValue value),
    @required TResult online(_OnlineFileValue value),
  }) {
    assert(local != null);
    assert(online != null);
    return online(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult local(_LocalFileValue value),
    TResult online(_OnlineFileValue value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (online != null) {
      return online(this);
    }
    return orElse();
  }
}

abstract class _OnlineFileValue implements PhotoFormFieldValue {
  const factory _OnlineFileValue(
      {@required ImageProvider<Object> imageProvider}) = _$_OnlineFileValue;

  ImageProvider<Object> get imageProvider;
  _$OnlineFileValueCopyWith<_OnlineFileValue> get copyWith;
}
