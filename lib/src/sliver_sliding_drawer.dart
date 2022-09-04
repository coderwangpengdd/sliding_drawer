import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A sliver that places the body and the drawer widget.
///
/// The body always fills the viewport.
///
/// The drawers fills the part of the viewport
/// that relies on the [drawerFraction].
class SliverSlidingDrawer extends StatelessWidget {
  /// Creates a sliver that places the body and the drawer widget.
  const SliverSlidingDrawer({
    required this.drawer,
    required this.body,
    required this.drawerFraction,
    super.key,
  })  : assert(
          drawerFraction > 0.0,
          'The drawer fraction should be greater than 0',
        ),
        assert(
          drawerFraction <= 1.0,
          'The drawer fraction should be less than or equal to 1',
        );

  /// The fraction of the total available width
  /// which is used to calculate the drawer width.
  ///
  /// Must be greater than 0 and less or equal to 1.
  final double drawerFraction;

  /// The content which displayed to the side of the body.
  ///
  /// Fills the part of the viewport that relies on the [drawerFraction].
  final Widget drawer;

  /// The primary content of the widget.
  ///
  /// Fills the viewport.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return _SliverSlidingDrawerRenderObjectWidget(
      drawerFraction: drawerFraction,
      delegate: SliverChildListDelegate.fixed(
        [
          drawer,
          body,
        ],
      ),
    );
  }
}

class _SliverSlidingDrawerRenderObjectWidget
    extends SliverMultiBoxAdaptorWidget {
  const _SliverSlidingDrawerRenderObjectWidget({
    required super.delegate,
    required this.drawerFraction,
  })  : assert(
          drawerFraction > 0.0,
          'The drawer fraction should be greater than 0',
        ),
        assert(
          drawerFraction <= 1.0,
          'The drawer fraction should be less than or equal to 1',
        );

  final double drawerFraction;

  @override
  _RenderSliverSlidingDrawer createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;

    return _RenderSliverSlidingDrawer(
      childManager: element,
      drawerFraction: drawerFraction,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliverSlidingDrawer renderObject,
  ) {
    renderObject.drawerFraction = drawerFraction;
  }
}

class _RenderSliverSlidingDrawer extends RenderSliverMultiBoxAdaptor {
  _RenderSliverSlidingDrawer({
    required double drawerFraction,
    required super.childManager,
  })  : assert(
          drawerFraction > 0.0,
          'The drawer fraction should be greater than 0',
        ),
        assert(
          drawerFraction <= 1.0,
          'The drawer fraction should be less than or equal to 1',
        ),
        _drawerFraction = drawerFraction;

  double get drawerExtent =>
      constraints.viewportMainAxisExtent * drawerFraction;

  double get bodyExtent => constraints.viewportMainAxisExtent;

  double get drawerFraction => _drawerFraction;

  double _drawerFraction;

  set drawerFraction(double value) {
    if (_drawerFraction == value) {
      return;
    }

    _drawerFraction = value;

    markNeedsLayout();
  }

  @override
  void performLayout() {
    final constraints = this.constraints;

    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    assert(
      scrollOffset >= 0.0,
      'The scrollOffset should be greater than 0',
    );

    final remainingExtent = constraints.remainingCacheExtent;
    assert(
      remainingExtent >= 0.0,
      'The remainingExtent should be greater than 0',
    );

    final drawerConstraints = constraints.asBoxConstraints(
      minExtent: drawerExtent,
      maxExtent: drawerExtent,
    );

    final bodyConstraints = constraints.asBoxConstraints(
      minExtent: bodyExtent,
      maxExtent: bodyExtent,
    );

    // none of children should be garbage collected
    collectGarbage(0, 0);

    final drawer = _layoutDrawer(drawerConstraints);
    _layoutBody(bodyConstraints, drawer);

    const leadingScrollOffset = 0.0;
    final trailingScrollOffset = drawerExtent + bodyExtent;

    assert(
      debugAssertChildListIsNonEmptyAndContiguous(),
      '''The reified child list should be not empty and has a contiguous sequence of indices''',
    );
    assert(
      indexOf(firstChild!) == 0,
      'The index of the first child should be equal to 0',
    );

    final estimatedMaxScrollOffset = math.min(
      drawerExtent + bodyExtent,
      childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: 0,
        lastIndex: 1,
        leadingScrollOffset: leadingScrollOffset,
        trailingScrollOffset: trailingScrollOffset,
      ),
    );

    final paintExtent = calculatePaintOffset(
      constraints,
      from: leadingScrollOffset,
      to: trailingScrollOffset,
    );

    final cacheExtent = calculateCacheOffset(
      constraints,
      from: leadingScrollOffset,
      to: trailingScrollOffset,
    );

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: constraints.scrollOffset > 0.0,
    );

    // We may have started the layout while scrolled to the end,
    // which would not expose a new child.
    if (estimatedMaxScrollOffset == trailingScrollOffset) {
      childManager.setDidUnderflow(true);
    }

    childManager.didFinishLayout();
  }

  RenderBox _layoutDrawer(BoxConstraints constraints) {
    late RenderBox drawer;

    if (firstChild == null) {
      addInitialChild();
    }

    if (indexOf(firstChild!) == 1) {
      drawer = insertAndLayoutLeadingChild(constraints)!;
    } else {
      firstChild!.layout(constraints);
      drawer = firstChild!;
    }

    final drawerParentData =
        drawer.parentData! as SliverMultiBoxAdaptorParentData;

    assert(
      drawerParentData.index == 0,
      'the drawer index should be equal 0',
    );

    drawerParentData.layoutOffset = 0.0;

    return drawer;
  }

  RenderBox _layoutBody(BoxConstraints constraints, RenderBox drawer) {
    var body = childAfter(drawer);

    if (body == null) {
      body = insertAndLayoutChild(constraints, after: drawer);
    } else {
      body.layout(constraints);
    }

    final bodyParentData = body!.parentData! as SliverMultiBoxAdaptorParentData;

    assert(
      bodyParentData.index == 1,
      'the body index should be equal 1',
    );

    bodyParentData.layoutOffset = drawerExtent;

    return body;
  }
}
