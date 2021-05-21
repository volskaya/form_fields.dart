import 'package:animations/animations.dart';
import 'package:country_catalog/country_catalog.dart';
import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:form_fields/src/l10n/form_fields_localizations.dart';
import 'package:form_fields/src/typedefs.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';

class CountryTextFormField extends FormField<Country> {
  CountryTextFormField({
    Key? key,
    Country? initialValue,
    FormFieldSetter<Country>? onSaved,
    FormFieldValidator<Country>? validator,
    ValueChanged<Country?>? onChanged,
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
  });

  final FormFieldState<Country> state;
  final ValueChanged<Country?>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final FormFieldAttachmentBuilder? attachmentBuilder;

  @override
  __WidgetState createState() => __WidgetState();
}

class __WidgetState extends State<_Widget> with InitialDependencies {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;

  void _updateCountry([Country? country]) {
    _controller.text = country?.name != null ? Country.localize(context, country!) : '';
    widget.onChanged?.call(country);
    widget.state.didChange(country);
  }

  Future _pickCountry() async {
    final scrollController = ScrollController();
    final scrollToggle = ScrollControllerToggle(controller: scrollController);
    final notifier = ValueNotifier<Country?>(widget.state.value);
    final attachment = widget.attachmentBuilder?.call(context, 'country_text_form_field');

    final pickedCountry = await showModal<Country>(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          final strings = MaterialLocalizations.of(context);
          final buttons = [
            TextButton(
              child: Text(strings.cancelButtonLabel, layoutTwice: true),
              onPressed: () => Navigator.pop(context),
            ),
            ValueListenableBuilder<Country?>(
              valueListenable: notifier,
              builder: (_, selectedValue, child) => TextButton(
                child: Text(strings.okButtonLabel, layoutTwice: true),
                onPressed: selectedValue != null ? () => Navigator.pop(context, notifier.value) : null,
              ),
            ),
          ];

          final content = UnboundedCustomScrollView(
            controller: scrollController,
            slivers: [
              SliverFixedExtentList(
                itemExtent: 56.0,
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final country = CountryCatalog.countries[i];
                    final title = Text(Country.localize(context, country), overflow: TextOverflow.ellipsis);
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
                            child: Icon(CountryTextFormField.flagIcon, size: 12),
                          ),
                          type: SwitchingImageType.fade,
                          fit: BoxFit.contain,
                          addRepaintBoundary: false,
                        ),
                      ),
                    );

                    return ValueListenableBuilder<Country?>(
                      valueListenable: notifier,
                      builder: (_, selectedValue, ___) => RadioListTile<Country>(
                        contentPadding: const EdgeInsets.only(left: 12, right: 24),
                        onChanged: (val) => notifier.value = val,
                        value: country,
                        groupValue: selectedValue,
                        activeColor: theme.colorScheme.primary,
                        title: title,
                        secondary: flag,
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
                title: Text(FormFieldsLocalizations.of(context)?.countryDialogTitle ?? 'Country'),
                content: content,
                overlapsContent: overlapsContent,
                buttons: buttons,
                attachment: attachment,
              ),
            ),
          );
        });

    if (pickedCountry != null) _updateCountry(pickedCountry);
    if (widget.state.value == null)
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => mounted ? _focusNode.unfocus() : null,
      );
  }

  @override
  void initDependencies() {
    _shouldDisposeController = widget.controller == null;
    _shouldDisposeFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ??
        TextEditingController(
          text: widget.state.value?.name != null ? Country.localize(context, widget.state.value!) : '',
        );
  }

  @override
  void dispose() {
    if (_shouldDisposeController) _controller.dispose();
    if (_shouldDisposeFocusNode) _focusNode.dispose();
    super.dispose();
  }

  Widget _buildFlag(BuildContext context, ThemeData theme, [Country? country]) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 40,
          width: 32.0,
          child: Tooltip(
            message: FormFieldsLocalizations.of(context)?.countryPickButtonTooltip ?? 'Pick a country',
            child: SwitchingImage(
              imageProvider: isNotEmpty(country?.alphaCode2) ? Country.imageOf(country!) : null,
              expandBox: true,
              type: SwitchingImageType.scale,
              fit: BoxFit.contain,
              idleChild: Center(
                child: Icon(CountryTextFormField.flagIcon),
              ),
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
      readOnly: true,
      style: widget.style,
      onTap: _pickCountry,
      onLongPress: _updateCountry,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      decoration: inputDecoration.copyWith(
        errorText: widget.state.hasError ? widget.state.errorText : null,
        suffixIcon: _buildFlag(context, theme, widget.state.value),
      ),
    );
  }
}
