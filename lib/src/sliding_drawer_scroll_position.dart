import 'package:flutter/widgets.dart';
import 'package:sliding_drawer/src/sliding_drawer.dart';
import 'package:sliding_drawer/src/sliding_drawer_controller.dart';

/// A scroll position that controls a [SlidingDrawer] widget.
///
/// See also:
///
///  * [SlidingDrawer] which can be controlled by a [ScrollController].
///  * [SlidingDrawerController] which can manipulate
///  [SlidingDrawerScrollPosition].
class SlidingDrawerScrollPosition extends ScrollPositionWithSingleContext {
  /// Creates a [SlidingDrawer] scroll controller.
  ///
  /// The [drawerFraction] argument must be greater than 0
  /// and less or equal to 1.
  SlidingDrawerScrollPosition({
    required this.drawerFraction,
    required this.isOpenOnInitial,
    required super.physics,
    required super.context,
    super.oldPosition,
    super.debugLabel,
  })  : assert(
          drawerFraction > 0.0,
          'The drawer fraction should be greater than 0',
        ),
        assert(
          drawerFraction <= 1.0,
          'The drawer fraction should be less than or equal to 1',
        ),
        super(
          keepScrollOffset: false,
          initialPixels: null,
        );

  /// Indicates the initial state of the drawer.
  final bool isOpenOnInitial;

  /// When the viewport has a zero-size, the current state can not
  /// be retrieved, so we need to cache the state
  /// for use when resizing the viewport to non-zero next time.
  double? _cachedPosition;

  /// The fraction of the total available width
  /// which is used to calculate the drawer width.
  ///
  /// Must be greater than 0 and less or equal to 1.
  final double drawerFraction;

  /// The offset in pixels when the drawer is open.
  double get drawerOffset => 0;

  /// The offset in pixels when the drawer is closed.
  double get bodyOffset => viewportDimension * drawerFraction;

  /// Indicates a relative position of the drawer from 0 to 1.
  ///
  /// * 0 indicates the fully open drawer.
  /// * 1 indicates the fully closed drawer.
  double get relativePosition {
    return _cachedPosition ?? (pixels / bodyOffset);
  }

  double _getRelativePosition({
    required double pixels,
    required double viewportDimension,
    required double drawerFraction,
  }) {
    assert(
      viewportDimension > 0.0,
      'The viewport dimension should be greater than 0',
    );
    assert(
      drawerFraction > 0.0,
      'The drawer fraction should be greater than 0',
    );
    assert(
      drawerFraction <= 1.0,
      'The drawer fraction should be less than or equal to 1',
    );

    final bodyOffset = viewportDimension * drawerFraction;
    final relativePosition = pixels / bodyOffset;

    return relativePosition;
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final oldViewportDimension =
        hasViewportDimension ? this.viewportDimension : null;

    if (viewportDimension == oldViewportDimension) {
      return true;
    }

    final result = super.applyViewportDimension(viewportDimension);
    final oldPixels = hasPixels ? pixels : null;

    var relativePosition = 0.0;

    if (oldPixels == null) {
      relativePosition = isOpenOnInitial ? 0.0 : 1.0;
    } else if (oldViewportDimension == 0.0) {
      // if resize from zero, we should use
      // the _cachedPosition to recover the state.
      relativePosition = _cachedPosition!;
    } else {
      relativePosition = _getRelativePosition(
        pixels: oldPixels,
        viewportDimension: oldViewportDimension!,
        drawerFraction: drawerFraction,
      );
    }

    _cachedPosition = (viewportDimension == 0.0) ? relativePosition : null;

    final newPixels = relativePosition * bodyOffset;

    if (newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }

    return result;
  }

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);

    assert(_cachedPosition == null, '_cachedPosition should not be null');

    if (other is! SlidingDrawerScrollPosition) {
      return;
    }

    if (other._cachedPosition != null) {
      _cachedPosition = other._cachedPosition;
    }
  }
}
