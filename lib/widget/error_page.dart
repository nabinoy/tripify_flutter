// import 'package:flutter/material.dart';

// class FilterDialog extends StatefulWidget {
//   const FilterDialog({Key? key}) : super(key: key);

//   @override
//   FilterDialogState createState() => FilterDialogState();
// }

// class FilterDialogState extends State<FilterDialog> {
//   String _selectedOption = 'Most relevant';
//   final List<String> _selectedChips = [];

//   void _handleOptionChange(String? value) {
//     setState(() {
//       _selectedOption = value!;
//     });
//   }

//   void _handleChipSelection(String value) {
//     setState(() {
//       if (_selectedChips.contains(value)) {
//         _selectedChips.remove(value);
//       } else {
//         _selectedChips.add(value);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Filter'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Sort by:'),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Radio<String>(
//                   value: 'Most relevant',
//                   groupValue: _selectedOption,
//                   onChanged: _handleOptionChange,
//                 ),
//                 const Text('Most relevant'),
//                 Radio<String>(
//                   value: 'Most recent',
//                   groupValue: _selectedOption,
//                   onChanged: _handleOptionChange,
//                 ),
//                 const Text('Most recent'),
//               ],
//             ),
//             const Text('Filter by:'),
//             Wrap(
//               spacing: 8.0,
//               children: [
//                 FilterChip(
//                   label: const Text('Chip 1'),
//                   selected: _selectedChips.contains('Chip 1'),
//                   onSelected: (_) => _handleChipSelection('Chip 1'),
//                 ),
//                 FilterChip(
//                   label: const Text('Chip 2'),
//                   selected: _selectedChips.contains('Chip 2'),
//                   onSelected: (_) => _handleChipSelection('Chip 2'),
//                 ),
//                 FilterChip(
//                   label: const Text('Chip 3'),
//                   selected: _selectedChips.contains('Chip 3'),
//                   onSelected: (_) => _handleChipSelection('Chip 3'),
//                 ),
//                 FilterChip(
//                   label: const Text('Chip 4'),
//                   selected: _selectedChips.contains('Chip 4'),
//                   onSelected: (_) => _handleChipSelection('Chip 4'),
//                 ),
//                 FilterChip(
//                   label: const Text('Chip 5'),
//                   selected: _selectedChips.contains('Chip 5'),
//                   onSelected: (_) => _handleChipSelection('Chip 5'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('CANCEL'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('APPLY'),
//         ),
//       ],
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Filter Dialog Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => const FilterDialog(),
//             );
//           },
//           child: const Text('Show filter dialog'),
//         ),
//       ),
//     );
//   }
// }