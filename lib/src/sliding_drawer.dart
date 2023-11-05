import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliding_drawer/src/drawer_scroll_physics.dart';
import 'package:sliding_drawer/src/sliding_drawer_controller.dart';
import 'package:sliding_drawer/src/sliver_sliding_drawer.dart';

/// A widget that provides a drawer with the sliding effect.
///
/// {@tool snippet}
/// This example shows how to create a simple [SlidingDrawer].
/// If you want to see more, check the full example on the package page:
/// https://pub.dev/packages/sliding_drawer/example
///
/// ```dart
/// SlidingDrawer(
///   // Connect the controller to the drawer.
///   controller: _drawerController,
///   // You can set up some optional properties
///   // (eg, a shade color, an axis direction, a onShadedAreaTap callback)
///   shadeColor: Colors.black,
///   axisDirection: AxisDirection.right,
///   onShadedAreaTap: () {},
///   // Add a drawer widget.
///   drawer: const Scaffold(
///     body: ColoredBox(
///       color: Colors.amber,
///       child: Center(
///         child: Text('Drawer'),
///       ),
///     ),
///   ),
///   // Add a body widget.
///   body: const Scaffold(
///     body: ColoredBox(
///       color: Colors.pink,
///       child: Center(
///         child: Text('Body'),
///       ),
///     ),
///   ),
/// );
/// ```
/// {@end-tool}
class SlidingDrawer extends StatelessWidget {
  /// Creates a sliding drawer.
  const SlidingDrawer({
    required this.controller,
    required this.drawer,
    required this.body,
    this.axisDirection,
    this.onShadedAreaTap,
    this.shadeColor = Colors.transparent,
    super.key,
  });

  /// An object that can be used to control the [drawer].
  final SlidingDrawerController controller;

  /// The content which displayed to the side of the [body].
  final Widget drawer;

  /// The primary content of the widget.
  final Widget body;

  /// Indicates a direction which the [drawer] slides to
  ///
  /// Defaults to current text direction:
  /// * [AxisDirection.right] if Directionality.of(context)
  /// returns [TextDirection.ltr],
  /// * [AxisDirection.left] if Directionality.of(context)
  /// returns [TextDirection.rtl]
  final AxisDirection? axisDirection;

  /// Called when a user taps on the shaded area.
  ///
  /// When [onShadedAreaTap] is not null and the drawer is not closed
  /// every interaction with the [body] will be ignored.
  /// To avoid this behavior leave [onShadedAreaTap] is null.
  ///
  /// Usually used for closing the [drawer].
  final void Function()? onShadedAreaTap;

  /// The drawer shade color which displayed when the [drawer] is open.
  final Color shadeColor;

  @override
  Widget build(BuildContext context) {
    final direction =
        axisDirection ?? _textToAxisDirection(Directionality.of(context));

    return Scrollable(
      axisDirection: direction,
      controller: controller,
      physics: const DrawerScrollPhysics(),
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        overscroll: false,
      ),
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Viewport(
          axisDirection: direction,
          offset: position,
          slivers: [
            SliverSlidingDrawer(
              drawerFraction: controller.drawerFraction,
              drawer: drawer,
              body: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return Stack(
                    children: [
                      body,
                      if (!controller.isClosed)
                        IgnorePointer(
                          ignoring: onShadedAreaTap == null,
                          child: ColoredBox(
                            color: _getShadeColor(),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                            ),
                          ),
                        ),
                      if (onShadedAreaTap != null && controller.isOpen)
                        GestureDetector(
                          onTap: onShadedAreaTap,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  AxisDirection _textToAxisDirection(TextDirection textDirection) {
    switch (textDirection) {
      case TextDirection.rtl:
        return AxisDirection.left;
      case TextDirection.ltr:
        return AxisDirection.right;
    }
  }

  Color _getShadeColor() {
    final target = controller.relativePosition;

    final color = Color.lerp(
      shadeColor,
      Colors.transparent,
      target,
    );

    return color!;
  }
}
