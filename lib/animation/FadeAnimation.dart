// ignore_for_file: file_names
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final tween = MultiTrackTween([
      // ignore: deprecated_member_use
      Track("opacity")
          .add(const Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      // ignore: deprecated_member_use
      Track("translateY").add(
          const Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    // ignore: deprecated_member_use
    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
