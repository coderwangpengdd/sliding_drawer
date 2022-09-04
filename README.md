
# Sliding Drawer

<p align="center">
    <a href="https://pub.dev/packages/sliding_drawer"><img src="https://img.shields.io/pub/v/sliding_drawer.svg" alt="pub"></a>
    <a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="license: MIT"></a>
</p>

---

A Flutter widget that provides a drawer with the sliding effect.

<img src="https://user-images.githubusercontent.com/39079821/188270276-8920f536-5245-494f-b3db-3070b6211ca3.gif" width="300"/>

## 🎯 Features

* Easy to use API
* Any direction support
* Customizable drawer width
* Controller which manages a drawer state
* Customizable shade color

## ⚙️ Getting started

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  sliding_drawer: ^1.0.0
```

## 🚀 Usage

1. Create a SlidingDrawerController in the state of your stateful widget:

```dart
class _SomeWidgetState extends State<SomeWidget> {
  // Create a drawer controller.
  // Also you can set up the drawer width and
  // the initial state here (optional).
  final SlidingDrawerController _drawerController = SlidingDrawerController(
    this.isOpenOnInitial = false,
    this.drawerFraction = 0.7,
  );

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    // from the widget tree.
    _drawerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
  }
}
```

2. Create a SlidingDrawer and connect the controller to it:

```dart
SlidingDrawer(
  // Connect the controller to the drawer.
  controller: _drawerController,
  // You can set up some optional properties
  // (eg, a shade color, an axis direction, a onShadedAreaTap callback)
  shadeColor: Colors.black,
  axisDirection: AxisDirection.right,
  onShadedAreaTap: () {},
  // Add a drawer widget.
  drawer: const Scaffold(
    body: ColoredBox(
      color: Colors.amber,
      child: Center(
        child: Text('Drawer'),
      ),
    ),
  ),
  // Add a body widget.
  body: const Scaffold(
    body: ColoredBox(
      color: Colors.pink,
      child: Center(
        child: Text('Body'),
      ),
    ),
  ),
);
```

3. (Optional) Use the controller to interact with the drawer (eg, for closing):

```dart
// Call the animateClose method to close the drawer with an animation. 
_drawerController.animateClose(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
);
```

## ❤️ Additional information

Pull requests are welcome!

If you encounter any problems or you have any ideas, feel free to open an issue: 
 * [Form for bugs](https://github.com/Ilya-Korolev/sliding_drawer/issues/new?template=bug_report.md)
 * [Form for feature requests](https://github.com/Ilya-Korolev/sliding_drawer/issues/new?template=feature_request.md)
 * [Form for questions](https://github.com/Ilya-Korolev/sliding_drawer/issues/new?template=question.md)

There might be some grammar issues in the docs. I would be very grateful if you help me to fix it.
