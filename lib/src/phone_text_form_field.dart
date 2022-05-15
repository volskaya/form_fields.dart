import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:country_catalog/country_catalog.dart';
import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_fields/src/l10n/form_fields_localizations.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:quiver/strings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:utils/utils.dart';

class PhoneTextFormField extends FormField<String> {
  PhoneTextFormField({
    Key? key,
    String? initialValue,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    ValueChanged<String?>? onChanged,
    ValueChanged<String?>? onFieldSubmitted,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
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
            onFieldSubmitted: onFieldSubmitted,
            controller: controller,
            focusNode: focusNode,
            decoration: decoration,
            readOnly: readOnly,
            style: style,
            attachmentBuilder: attachmentBuilder,
          ),
        );

  static IconData flagIcon = Icons.flag;
}

class _Widget extends StatefulWidget {
  const _Widget({
    required this.state,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.readOnly = false,
    this.attachmentBuilder,
  });

  final FormFieldState<String> state;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool readOnly;
  final FormFieldAttachmentBuilder? attachmentBuilder;

  @override
  __WidgetState createState() => __WidgetState();
}

class __WidgetState extends State<_Widget> {
  final _countryNotifier = ValueNotifier<Country?>(null);

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;

  void _updateCountry(Country country) {
    if (_countryNotifier.value == country) return;

    final split = _controller.text.split(' ');
    final startsWithPlus = split.first.startsWith('+');

    final buffer = StringBuffer();
    buffer.write('${country.code} ');
    if (startsWithPlus) {
      buffer.write(split.skip(1).join(' '));
    } else {
      buffer.write(_controller.text);
    }

    _countryNotifier.value = country;
    _controller.text = buffer.toString();
  }

  void _deriveCountryFromText() {
    final split = _controller.text.split(' ');
    final startsWithPlus = split.first.startsWith('+');

    if (split.first != _countryNotifier.value?.code) {
      final code = split.first.substring(0, math.min(split.first.length, 4));
      _countryNotifier.value = startsWithPlus ? CountryCatalog.fromCountryCode(code) : null;
    }
  }

  void _handleChange() {
    _deriveCountryFromText();
    widget.onChanged?.call(_controller.text);
    widget.state.didChange(_controller.text);
  }

  Future _pickCountry() async {
    final scrollController = ScrollController();
    final scrollToggle = ScrollControllerToggle(controller: scrollController);
    final notifier = ValueNotifier<Country?>(_countryNotifier.value);
    final attachment = widget.attachmentBuilder?.call(context, 'phone_text_form_field');

    final pickedCountry = await showModal<Country>(
        context: context,
        builder: (context) {
          final content = UnboundedCustomScrollView(
            controller: scrollController,
            slivers: [
              SliverFixedExtentList(
                itemExtent: 56.0,
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final country = CountryCatalog.countries[i];
                    final title = Text(Country.localize(context, country), overflow: TextOverflow.ellipsis);
                    final leading = SizedBox(
                      height: 40.0,
                      width: 48.0,
                      child: Center(
                        child: Text(country.code, style: Theme.of(context).textTheme.subtitle2),
                      ),
                    );
                    final flag = SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: DisposableBuildContextBuilder(
                        builder: (_, context) => SwitchingImage(
                          imageProvider: ScrollAwareImageProvider(
                            context: context,
                            imageProvider: Country.imageOf(country),
                          ),
                          idleChild: Center(
                            child: Icon(PhoneTextFormField.flagIcon, size: 12),
                          ),
                          type: SwitchingImageType.fade,
                          duration: const Duration(milliseconds: 300),
                          curve: decelerateEasing,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          optimizeFade: true,
                          addRepaintBoundary: false,
                        ),
                      ),
                    );

                    return ValueListenableBuilder<Country?>(
                      valueListenable: notifier,
                      builder: (_, selectedValue, ___) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                        onTap: () => Navigator.pop(context, country),
                        leading: leading,
                        title: title,
                        trailing: flag,
                      ),
                    );
                  },
                  addAutomaticKeepAlives: false,
                  childCount: CountryCatalog.countries.length,
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
              builder: (context, overlapsContent, ___) => MaterialDialogContainer(
                title: Text(FormFieldsLocalizations.of(context)?.phoneCountryDialogTitle ?? 'Country code'),
                content: content,
                overlapsContent: overlapsContent,
                attachment: attachment,
              ),
            ),
          );
        });

    if (pickedCountry != null) _updateCountry(pickedCountry);
    if (widget.state.value == null)
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => mounted ? _focusNode.unfocus() : null,
      );
  }

  @override
  void initState() {
    super.initState();

    _shouldDisposeController = widget.controller == null;
    _shouldDisposeFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = (widget.controller ?? TextEditingController(text: widget.state.value ?? ''))
      ..addListener(_handleChange);
    _deriveCountryFromText();
  }

  @override
  void dispose() {
    super.dispose();
    _countryNotifier.dispose();
    _controller.removeListener(_handleChange);
    if (_shouldDisposeController) _controller.dispose();
    if (_shouldDisposeFocusNode) _focusNode.dispose();
  }

  Widget _buildFlag(BuildContext context, ThemeData theme, [Country? country]) => IconButton(
        tooltip: FormFieldsLocalizations.of(context)?.phoneCountryCodeButtonTooltip ?? 'Pick a country code',
        onPressed: !widget.readOnly ? _pickCountry : null,
        icon: SizedBox(
          width: 24.0,
          height: 32.0,
          child: SwitchingImage(
            imageProvider: isNotEmpty(country?.alphaCode2) ? Country.imageOf(country!) : null,
            type: SwitchingImageType.scale,
            duration: const Duration(milliseconds: 300),
            curve: decelerateEasing,
            fit: BoxFit.contain,
            expandBox: true,
            filterQuality: FilterQuality.none,
            optimizeFade: true,
            idleChild: Center(
              child: Icon(PhoneTextFormField.flagIcon),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecoration = widget.decoration ?? const InputDecoration(hintText: '', counterText: '');

    return TextField(
      enabled: widget.state.widget.enabled,
      readOnly: widget.readOnly,
      style: widget.style,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      onSubmitted: (val) => widget.onFieldSubmitted?.call(val),
      inputFormatters: [FilteringTextInputFormatter.deny(r'[^0-9+() -]')],
      maxLength: 30,
      decoration: inputDecoration.copyWith(
        errorText: widget.state.hasError ? widget.state.errorText : null,
        counterText: '',
        suffixIcon: inputDecoration.suffixIcon ??
            ValueListenableBuilder<Country?>(
              valueListenable: _countryNotifier,
              builder: (context, country, __) => _buildFlag(context, theme, country),
            ),
      ),
    );
  }
}
