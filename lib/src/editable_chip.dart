import 'dart:ui' as ui;
import 'package:fancy_switcher/fancy_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef EditableChipWrap = Widget Function(
  BuildContext contex,
  TextEditingController controller,
  FocusNode focusNode,
  Widget chip,
);

class EditableChip extends StatefulWidget {
  const EditableChip({
    Key? key,
    this.controller,
    this.focusNode,
    this.hasError = false,
    this.avatar,
    this.breakPoint = ',',
    this.onDeleted,
    this.onBreakPoint,
    this.onFocusLost,
    this.onSubmitted,
    this.onTap,
    this.selectionEnabled = true,
    this.enableInteractiveSelection = true,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.readOnly = false,
    this.wrap,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool hasError;
  final Widget? avatar;
  final String breakPoint;
  final VoidCallback? onDeleted;
  final VoidCallback? onBreakPoint;
  final VoidCallback? onFocusLost;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final bool selectionEnabled;
  final bool enableInteractiveSelection;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final EditableChipWrap? wrap;

  @override
  EditableChipState createState() => EditableChipState();
}

class EditableChipState extends State<EditableChip>
    with SingleTickerProviderStateMixin
    implements TextSelectionGestureDetectorBuilderDelegate {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final _TextFieldSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;

  bool _editing = true;
  bool _showSelectionHandles = false;

  @override final editableTextKey = GlobalKey<EditableTextState>();
  @override bool forcePressEnabled = false;

  @override
  bool get selectionEnabled => widget.selectionEnabled;

  void _handleEditableChanged(String val) {
    if (val.isEmpty) return;
    final value = val.split('');
    if (value.removeLast() == widget.breakPoint) {
      widget.onBreakPoint?.call();
      _controller.text = value.join('');
    }
  }

  void _ensureSelection() {
    if (_controller.text.isNotEmpty) {
      _controller.selection = _controller.selection.copyWith(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    }
  }

  void requestKeyboard() {
    editableTextKey.currentState?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) return false;
    if (cause == SelectionChangedCause.keyboard) return false;
    if (widget.readOnly && _controller.selection.isCollapsed) return false;
    if (cause == SelectionChangedCause.longPress) return true;
    if (_controller.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    final willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      _showSelectionHandles = willShowSelectionHandles;
      markNeedsBuild();
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          editableTextKey.currentState?.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_controller.selection.isCollapsed) {
      editableTextKey.currentState?.toggleToolbar();
    }
  }

  void _handleFocusNodeChange() {
    if (!_focusNode.hasFocus && _editing) {
      // Focus dropped, hide editable.
      _editing = false;
      _showSelectionHandles = false;
      _controller.text = _controller.text.trim();
      markNeedsBuild();
      widget.onFocusLost?.call();
    } else if (_focusNode.hasFocus && !_editing) {
      // Focus acquired, turn the chip into an editable.
      _editing = true;
      markNeedsBuild();
      _ensureSelection();
    }
  }

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = (widget.focusNode ?? FocusNode())..addListener(_handleFocusNodeChange);
    _selectionGestureDetectorBuilder = _TextFieldSelectionGestureDetectorBuilder(state: this);

    // If an initial value was used, don't spawn the chip in an editable state.
    _editing = _controller.text.isEmpty;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditableChip oldWidget) {
    assert(oldWidget.controller == widget.controller);
    assert(oldWidget.focusNode == widget.focusNode);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _selectionGestureDetectorBuilder.dispose();
    _focusNode.removeListener(_handleFocusNodeChange);

    // Only disposed, if they weren't passed trough the widget props.
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
  }

  // NOTE: Some code copied from [TextField].
  Widget _buildEditable(ThemeData theme) {
    TextSelectionControls textSelectionControls;
    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset? cursorOffset;
    Color cursorColor;
    Radius? cursorRadius;

    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        forcePressEnabled = true;
        textSelectionControls = cupertinoTextSelectionControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorColor = CupertinoTheme.of(context).primaryColor;
        cursorRadius = const Radius.circular(2.0);
        cursorOffset = Offset(iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        forcePressEnabled = false;
        textSelectionControls = materialTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor = theme.textSelectionTheme.cursorColor ?? Colors.green;
        break;
    }

    return _selectionGestureDetectorBuilder.buildGestureDetector(
      key: const ValueKey('edit'),
      behavior: HitTestBehavior.translucent,
      child: RepaintBoundary(
        child: EditableText(
          key: editableTextKey,
          style: theme.textTheme.bodyText1!,
          focusNode: _focusNode,
          controller: _controller,
          maxLines: 1,
          onChanged: _handleEditableChanged,
          onSubmitted: widget.onSubmitted,
          readOnly: widget.readOnly,
          forceLine: false,
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          backgroundCursorColor: cursorColor,
          selectionColor: theme.textSelectionTheme.selectionColor,
          keyboardAppearance: theme.brightness,
          paintCursorAboveText: paintCursorAboveText,
          cursorOpacityAnimates: cursorOpacityAnimates,
          cursorOffset: cursorOffset,
          cursorColor: cursorColor,
          cursorRadius: cursorRadius,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          onSelectionChanged: _handleSelectionChanged,
          rendererIgnoresPointer: true,
          onSelectionHandleTapped: _handleSelectionHandleTapped,
          showSelectionHandles: _showSelectionHandles,
          selectionControls: widget.selectionEnabled ? textSelectionControls : null,
        ),
      ),
    );
  }

  Widget _buildChip(ThemeData theme) => InputChip(
        key: const ValueKey('idle'),
        showCheckmark: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        label: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Text(_controller.text, layoutTwice: true),
        ),
        onDeleted: widget.onDeleted,
        onPressed: () {
          _editing = true;
          _ensureSelection();
          markNeedsBuild();

          // Switcher hasn't built the input field at this point.
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) _focusNode.requestFocus();
          });
        },
        avatar: widget.avatar != null
            ? SizedBox.expand(
                child: PhysicalShape(
                  clipper: const ShapeBorderClipper(shape: CircleBorder()),
                  color: theme.dividerColor,
                  child: Center(
                    child: IconTheme.merge(
                      data: const IconThemeData(size: 12),
                      child: widget.avatar!,
                    ),
                  ),
                ),
              )
            : null,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip = SizedBox(
      height: 32.0, // Material chip height.
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _focusNode,
          builder: (_, __) => FancySwitcher(
            alignment: AlignmentDirectional.centerStart,
            child: _editing || _focusNode.hasFocus ? _buildEditable(theme) : _buildChip(theme),
          ),
        ),
      ),
    );

    return widget.wrap?.call(context, _controller, _focusNode, chip) ?? chip;
  }
}

class _TextFieldSelectionGestureDetectorBuilder extends TextSelectionGestureDetectorBuilder {
  _TextFieldSelectionGestureDetectorBuilder({
    required EditableChipState state,
  })  : _state = state,
        super(delegate: state);

  EditableChipState? _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (_state == null) return;
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state!.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWordsInRange(
            from: details.globalPosition - details.offsetFromOrigin,
            to: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
      }
    }
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    if (_state == null) return;
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state!.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;
      }
    }
    _state!.requestKeyboard();
    _state!.widget.onTap?.call();
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (_state == null) return;
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state!.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWord(cause: SelectionChangedCause.longPress);
          Feedback.forLongPress(_state!.context);
          break;
      }
    }
  }

  void dispose() {
    _state = null;
  }
}
