import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_drawer/src/sliding_drawer.dart';
import 'package:sliding_drawer/src/sliding_drawer_scroll_position.dart';

/// A controller for a [SlidingDrawer].
///
/// A page controller lets you manipulate
/// a drawer visibility in a [SlidingDrawer].
///
/// See also:
///
///  * [SlidingDrawer], which is the widget this object controls.
///  * [SlidingDrawerScrollPosition], which manages the scroll offset for
///  a [SlidingDrawer] widget.
class SlidingDrawerController extends ScrollController {
  /// Creates a [SlidingDrawer] controller.
  ///
  /// The [drawerFraction] argument must be greater than 0
  /// and less or equal to 1.
  SlidingDrawerController({
    this.isOpenOnInitial = false,
    this.drawerFraction = 0.7,
  })  : assert(
          drawerFraction > 0.0,
          'The drawer fraction must be greater than 0',
        ),
        assert(
          drawerFraction <= 1.0,
          'The drawer fraction must be less than or equal to 1',
        );

  /// Indicates the initial state of the drawer.
  final bool isOpenOnInitial;

  /// The fraction of the total available width
  /// which is used to calculate the drawer width.
  ///
  /// Must be greater than 0 and less or equal to 1.
  final double drawerFraction;

  /// Indicates whether the drawer is currently fully open.
  bool get isOpen {
    return relativePosition - precisionErrorTolerance <= 0.0;
  }

  /// Indicates whether the drawer is currently fully closed.
  bool get isClosed {
    return relativePosition + precisionErrorTolerance >= 1.0;
  }

  /// Indicates a relative position of the drawer from 0 to 1.
  ///
  /// * 0 indicates the fully open drawer.
  /// * 1 indicates the fully closed drawer.
  double get relativePosition {
    final position = this.position as SlidingDrawerScrollPosition;

    return position.relativePosition;
  }

  /// Opens the drawer with an animation.
  Future<void> animateOpen({
    required Duration duration,
    required Curve curve,
  }) {
    final position = this.position as SlidingDrawerScrollPosition;

    return position.animateTo(
      position.drawerOffset,
      duration: duration,
      curve: curve,
    );
  }

  /// Closes the drawer with an animation.
  Future<void> animateClose({
    required Duration duration,
    required Curve curve,
  }) {
    final position = this.position as SlidingDrawerScrollPosition;

    return position.animateTo(
      position.bodyOffset,
      duration: duration,
      curve: curve,
    );
  }

  /// Opens the drawer immediately.
  void open() {
    final position = this.position as SlidingDrawerScrollPosition;

    position.jumpTo(position.drawerOffset);
  }

  /// Closes the drawer immediately.
  void close() {
    final position = this.position as SlidingDrawerScrollPosition;

    position.jumpTo(position.bodyOffset);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return SlidingDrawerScrollPosition(
      drawerFraction: drawerFraction,
      isOpenOnInitial: isOpenOnInitial,
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}
