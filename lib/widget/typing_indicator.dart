// import 'package:flutter/material.dart';

// class TypingIndicator extends StatefulWidget {
//   const TypingIndicator({super.key});

//     @override
//   State<TypingIndicator> createState() => _TypingIndicatorState();
// }

// class _TypingIndicatorState extends State<TypingIndicator>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     // Create the animation controller with a duration of 1 second
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     // Set up the animation to loop from 0 to 1 and back to 0
//     _controller.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (BuildContext context, Widget child) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               width: 10.0,
//               height: 10.0,
//               margin: const EdgeInsets.only(right: 5.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               // The opacity is animated from 0.2 to 1.0 and back to 0.2
//               opacity: _controller.value < 0.5
//                   ? 0.2 + _controller.value
//                   : 1.0 - _controller.value,
//             ),
//             Container(
//               width: 10.0,
//               height: 10.0,
//               margin: const EdgeInsets.only(right: 5.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               // The opacity is animated from 0.2 to 1.0 and back to 0.2
//               opacity: _controller.value < 0.5
//                   ? 0.2 + _controller.value
//                   : 1.0 - _controller.value,
//             ),
//             Container(
//               width: 10.0,
//               height: 10.0,
//               margin: const EdgeInsets.only(right: 5.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               // The opacity is animated from 0.2 to 1.0 and back to 0.2
//               opacity: _controller.value < 0.5
//                   ? 0.2 + _controller.value
//                   : 1.0 - _controller.value,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
