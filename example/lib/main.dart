import 'package:example/body_widget.dart';
import 'package:example/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:sliding_drawer/sliding_drawer.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a drawer controller.
  // Also you can set up the drawer width and
  // the initial state here (optional).
  final SlidingDrawerController _drawerController = SlidingDrawerController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    // from the widget tree.
    _drawerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingDrawer(
      // Connect the controller to the drawer.
      controller: _drawerController,
      // You can set up some optional properties
      // (eg, a shade color, an axis direction, a onShadedAreaTap callback).
      shadeColor: Colors.black.withOpacity(0.35),
      axisDirection: AxisDirection.right,
      onShadedAreaTap: () {
        // Use the controller to interact with the drawer (eg, for closing).
        _drawerController.animateClose(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      // Add a drawer widget.
      drawer: const DrawerWidget(),
      // Add a body widget.
      body: BodyWidget(
        onMenuPressed: () {
          _drawerController.animateOpen(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }
}
