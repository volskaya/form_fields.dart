import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

typedef AutocompleteOverlaySwitcherBuilder = FancySwitcher Function({required Widget? child});
typedef AutocompleteOverlayListBuilder = Widget Function(
  BuildContext context,
  String query,
  double itemExtent,
  void Function(String value) handleSelect,
  AutocompleteOverlaySwitcherBuilder switcher,
);

/// [AutocompleteOverlay] handles autocompletion window overlay logic for text input fields.
class AutocompleteOverlay extends StatefulWidget {
  const AutocompleteOverlay({
    required this.controller,
    required this.focusNode,
    required this.child,
    required this.listBuilder,
    this.listenable,
    this.itemExtent = 56.0,
    this.visibleItemCount = 4,
    this.overlayPadding = const EdgeInsets.only(bottom: 8.0),
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget child;
  final ChangeNotifier? listenable;
  final AutocompleteOverlayListBuilder listBuilder;
  final double itemExtent; // Expected item extent to size the overlay material by.
  final int visibleItemCount;
  final EdgeInsets overlayPadding;

  @override
  _AutocompleteOverlayState createState() => _AutocompleteOverlayState();
}

class _AutocompleteOverlayState extends State<AutocompleteOverlay> {
  final _layerLink = LayerLink();

  String _query = '';
  String? _lastValue;
  OverlayEntry? _overlayEntry;

  void _selectSuggestion(String value) {
    _lastValue = value;
    _updateQuery('');
    widget.controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
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
    final value = widget.controller.text;
    if (_lastValue == value) return;
    _lastValue = value;

    if (_overlayEntry != null && widget.focusNode.hasFocus) {
      Debounce.milliseconds(300, _updateQuery, <dynamic>[value]);
    }
  }

  void _createOverlay() {
    assert(widget.focusNode.hasFocus);
    assert(_query.isEmpty);
    assert(_overlayEntry == null);

    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = _buildOverlay();
      overlay.insert(_overlayEntry!);

      // Fire off search, if the text controller already has value.
      //
      // NOTE: Have to wait 2 frames, since frame 1 is still the insert operation above.
      final value = widget.controller.text.trim();

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
    assert(!widget.focusNode.hasFocus);
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

  /// If the focus node has focus, build the overlay, else animate it out and destroy it.
  void _handleFocusChange() {
    if (widget.focusNode.hasFocus && _overlayEntry == null) {
      return _createOverlay(); // Makes `markNeedsBuild` redundant.
    } else if (!widget.focusNode.hasFocus && _query.isNotEmpty) {
      _query = '';
    } else if (!widget.focusNode.hasFocus && _overlayEntry != null && _query.isEmpty) {
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

  Future<bool> _handlePopScope() async {
    if (_overlayEntry != null && _query.isNotEmpty) {
      _resetQuery();
      return false;
    }
    return true;
  }

  @override
  void initState() {
    widget.focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleChange);
    widget.listenable?.addListener(_handleScroll);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handleChange);
    widget.listenable?.removeListener(_handleScroll);
    widget.focusNode.removeListener(_handleFocusChange);
    if (_overlayEntry != null) {
      _query = '';
      _overlayEntry?.markNeedsBuild();
    }
  }

  FancySwitcher _buildOverlaySwitcher({required Widget? child}) => FancySwitcher.vertical(
        alignment: Alignment.bottomCenter,
        onEnd: _maybeRemoveOverlay,
        child: widget.focusNode.hasFocus && _query.isNotEmpty
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
        child: CompositedTransformTarget(
          link: _layerLink,
          child: widget.child,
        ),
      );
}
