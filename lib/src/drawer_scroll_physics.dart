import 'package:flutter/widgets.dart';
import 'package:sliding_drawer/src/sliding_drawer.dart';
import 'package:sliding_drawer/src/sliding_drawer_scroll_position.dart';

/// Scroll physics used by a [SlidingDrawer].
///
/// These physics cause the drawer to snap to boundaries.
///
/// See also:
///
///  * [ScrollPhysics], the base class which defines the API for scrolling
///    physics.
class DrawerScrollPhysics extends ScrollPhysics {
  /// Creates physics for a [SlidingDrawer].
  const DrawerScrollPhysics({
    super.parent,
  });

  @override
  DrawerScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return DrawerScrollPhysics(
      parent: buildParent(ancestor),
    );
  }

  double _getTargetPixels({
    required SlidingDrawerScrollPosition position,
    required Tolerance tolerance,
    required double velocity,
  }) {
    var direction = position.relativePosition;

    if (velocity < -tolerance.velocity) {
      direction -= 0.5;
    } else if (velocity > tolerance.velocity) {
      direction += 0.5;
    }

    final target = direction.roundToDouble() * position.bodyOffset;

    return target;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final drawerPosition = position as SlidingDrawerScrollPosition;

    final tolerance = this.tolerance;
    final target = _getTargetPixels(
      position: drawerPosition,
      tolerance: tolerance,
      velocity: velocity,
    );

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
