// import 'package:flutter/material.dart';

// class AnimatedAlertDialog extends StatefulWidget {
//   const AnimatedAlertDialog({Key? key}) : super(key: key);

//   @override
//   _AnimatedAlertDialogState createState() => _AnimatedAlertDialogState();
// }

// class _AnimatedAlertDialogState extends State<AnimatedAlertDialog>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     vsync: this,
//     duration: Duration(milliseconds: 500),
//   );

//   late final Animation<double> _animation = CurvedAnimation(
//     parent: _controller,
//     curve: Curves.easeInOut,
//   );

//   TextEditingController _textEditingController = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   void _showDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Enter your name'),
//         content: TextField(
//           controller: _textEditingController,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _textEditingController.clear();
//             },
//             child: Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _textEditingController.clear();
//               _showSuccessDialog();
//             },
//             child: Text('SUBMIT'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Success!'),
//         content: Text('Your name has been submitted.'),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Animated Alert Dialog'),
//       ),
//       body: Column(
//         children: [
//           Text('data'),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _controller.forward();
//                     _showDialog();
//                   },
//                   child: Text('SHOW DIALOG'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
