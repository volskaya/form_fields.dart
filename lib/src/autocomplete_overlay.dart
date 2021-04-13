import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

typedef AutocompleteRequestSuggestionCallback = void Function(String suggestion);
typedef AutocompleteOverlaySwitcherBuilder = FancySwitcher Function({required Widget? child});
typedef AutocompleteOverlayListBuilder = Widget Function(
  BuildContext context,
  String query,
  double itemExtent,
  void Function(String value) handleSelect,
  AutocompleteOverlaySwitcherBuilder switcher,
);

class AutocompleteOverlayClient {
  AutocompleteOverlayClient._(this.onSuggestion, this.state);

  final AutocompleteRequestSuggestionCallback onSuggestion;
  AutocompleteOverlayState? state;

  static AutocompleteOverlayClient? of(
    BuildContext context, {
    required AutocompleteRequestSuggestionCallback onSuggestion,
  }) =>
      AutocompleteOverlay.of(context).getClient(onSuggestion);

  String text = '';
  bool hasFocus = false;

  void reportTextChange(String text, {bool forceChange = false}) {
    if (!forceChange && this.text == text) return;
    this.text = text;
    state?._activeClient = this;
    state?._handleChange();
  }

  void reportFocus(bool hasFocus) {
    this.hasFocus = hasFocus;

    if (hasFocus) {
      final resetQuery = state?._activeClient != this;
      state?._activeClient = this;
      state?._handleFocusChange();
      if (resetQuery) reportTextChange(text, forceChange: true);
    } else if (state?._activeClient == this) {
      state!._activeClient = null;
      state!._handleFocusChange();
    }
  }

  void dispose() {
    state?._clients.remove(this);
    if (state?._activeClient == this) {
      state!._activeClient = null;
      state!._handleFocusChange();
    }
    state = null;
  }
}

/// [AutocompleteOverlay] handles autocompletion window overlay logic for text input fields.
class AutocompleteOverlay extends StatefulWidget {
  const AutocompleteOverlay({
    this.controller,
    this.focusNode,
    required this.child,
    required this.listBuilder,
    this.listenable,
    this.itemExtent = 56.0,
    this.visibleItemCount = 4,
    this.overlayPadding = const EdgeInsets.only(bottom: 8.0),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget child;
  final ChangeNotifier? listenable;
  final AutocompleteOverlayListBuilder listBuilder;
  final double itemExtent; // Expected item extent to size the overlay material by.
  final int visibleItemCount;
  final EdgeInsets overlayPadding;

  static AutocompleteOverlayState of(BuildContext context) =>
      Provider.of<AutocompleteOverlayState>(context, listen: false);

  @override
  AutocompleteOverlayState createState() => AutocompleteOverlayState();
}

class AutocompleteOverlayState extends State<AutocompleteOverlay> {
  final _layerLink = LayerLink();
  final _clients = <AutocompleteOverlayClient>{};

  String _query = '';
  String? _lastValue;
  OverlayEntry? _overlayEntry;
  AutocompleteOverlayClient? _activeClient;

  String get _text => _activeClient?.text ?? widget.controller?.text ?? '';
  bool get _isFocused => _activeClient?.hasFocus ?? widget.focusNode?.hasFocus ?? false;

  AutocompleteOverlayClient? getClient(AutocompleteRequestSuggestionCallback onSuggestion) {
    if (!mounted) return null;
    final client = AutocompleteOverlayClient._(onSuggestion, this);
    _clients.add(client);
    return client;
  }

  void _selectSuggestion(String value) {
    _lastValue = value;
    _updateQuery('');

    if (_activeClient != null) {
      _activeClient!.onSuggestion(value);
    } else {
      widget.controller?.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  void _resetQuery() {
    if (mounted) {
      _query = '';
      markNeedsBuild();
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _updateQuery(String value) {
    if (mounted) {
      _query = value.trim();
      markNeedsBuild();
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _handleChange() {
    if (_overlayEntry == null) return;
    final value = _text;
    if (_lastValue == value) return;
    _lastValue = value;

    if (_overlayEntry != null && _isFocused) {
      Debounce.milliseconds(300, _updateQuery, <dynamic>[value]);
    }
  }

  /// If the focus node has focus, build the overlay, else animate it out and destroy it.
  void _handleFocusChange() {
    if (!mounted) return;

    if (_isFocused && _overlayEntry == null) {
      return _createOverlay(); // Makes `markNeedsBuild` redundant.
    } else if (!_isFocused && _query.isNotEmpty) {
      _query = '';
    } else if (!_isFocused && _overlayEntry != null && _query.isEmpty) {
      // Switcher won't animate and never call `onEnd`, to destroy the overlay,
      // so destroy it here manually.
      //
      // TODO(volskaya): Assert the animation is not in progress.
      return _removeOverlay();
    }

    _overlayEntry?.markNeedsBuild();
  }

  /// Scrolling closes search.
  void _handleScroll() {
    if (_query.isNotEmpty && _overlayEntry != null) {
      _query = '';
      _overlayEntry?.markNeedsBuild();
      _handleFocusChange();
    }
  }

  void _createOverlay() {
    assert(_isFocused);
    assert(_query.isEmpty);
    assert(_overlayEntry == null);

    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = _buildOverlay();
      overlay.insert(_overlayEntry!);

      // Fire off search, if the text controller already has value.
      // Wait 2 frames, since frame 1 is still the insert operation above.
      final value = _text.trim();

      if (value.isNotEmpty) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) _updateQuery(value);
          });
        });
      }
    }
  }

  // NOTE: Don't call this from dispose.
  void _removeOverlay() {
    assert(!_isFocused);
    assert(_query.isEmpty, 'Destroy overlay after suggestions are gone');
    assert(_overlayEntry != null);

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Animating children are expected to to call this, when their animation ends,
  // to remove the overlay only when the autocompletion suggestions have actually
  // animated out.
  void _maybeRemoveOverlay() {
    if (mounted && _query.isEmpty) {
      _handleFocusChange();
    }
  }

  Future<bool> _handlePopScope() async {
    if (_overlayEntry != null && _query.isNotEmpty) {
      _resetQuery();
      return false;
    }
    return true;
  }

  void _handleTextControllerChange() {
    _activeClient = null;
    _handleChange();
  }

  void _handleFocusNodeChange() {
    _activeClient = null;
    _handleFocusChange();
  }

  @override
  void initState() {
    widget.focusNode?.addListener(_handleFocusNodeChange);
    widget.controller?.addListener(_handleTextControllerChange);
    widget.listenable?.addListener(_handleScroll);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    while (_clients.isNotEmpty) {
      final client = _clients.first;
      _clients.remove(client);
      client.dispose();
    }

    widget.controller?.removeListener(_handleTextControllerChange);
    widget.listenable?.removeListener(_handleScroll);
    widget.focusNode?.removeListener(_handleFocusNodeChange);
    if (_overlayEntry != null) {
      _query = '';

      // Overlay depends on `this.state`.
      // Make sure it doesn't build after this state has disposed.
      _overlayEntry!.dispose();
      _overlayEntry = null;
    }
  }

  @override
  void didUpdateWidget(covariant AutocompleteOverlay oldWidget) {
    assert(oldWidget.controller == widget.controller);
    assert(oldWidget.focusNode == widget.focusNode);
    super.didUpdateWidget(oldWidget);
  }

  FancySwitcher _buildOverlaySwitcher({required Widget? child}) => FancySwitcher.vertical(
        alignment: Alignment.bottomCenter,
        onEnd: _maybeRemoveOverlay,
        child: _isFocused && _query.isNotEmpty
            ? Material(
                key: ValueKey(_query),
                type: MaterialType.card,
                elevation: 8.0,
                clipBehavior: Clip.antiAlias,
                child: child,
              )
            : null,
      );

  OverlayEntry _buildOverlay() => OverlayEntry(
        builder: (context) {
          final box = this.context.findRenderObject() as RenderBox?;
          if (box == null) return const SizedBox.shrink();

          final offset = Offset(widget.overlayPadding.left, -widget.overlayPadding.bottom);
          final size = Size(
            box.size.width - widget.overlayPadding.horizontal,
            widget.itemExtent * widget.visibleItemCount + widget.itemExtent / 2,
          );

          final switcher =
              widget.listBuilder(context, _query, widget.itemExtent, _selectSuggestion, _buildOverlaySwitcher);

          return IgnorePointer(
            ignoring: _query.isEmpty,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _resetQuery,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: offset,
                  followerAnchor: Alignment.bottomLeft,
                  child: Container(
                    constraints: BoxConstraints.loose(size),
                    alignment: Alignment.bottomCenter,
                    child: switcher,
                  ),
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _handlePopScope,
        child: Provider<AutocompleteOverlayState>.value(
          value: this,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: widget.child,
          ),
        ),
      );
}
