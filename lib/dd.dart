// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../controller/workshop_data.dart';
// import '../../model/workshop_template.dart';
//
// class DetailsForm extends StatefulWidget {
//   final DateTime id;
//   final AboutWorkshopDetails? existingDetails; // Optional for editing
//
//   const DetailsForm({super.key, required this.id, this.existingDetails});
//
//   @override
//   State<DetailsForm> createState() => _DetailsFormState();
// }
//
// class _DetailsFormState extends State<DetailsForm> {
//   late TextEditingController _descriptionController;
//   late TextEditingController _objectiveController;
//   late TextEditingController _impactStudentsController;
//   late TextEditingController _impactIndustryController;
//   late TextEditingController _impactResearchController;
//
//   final List<String> _outcomes = [];
//   final List<String> _futureScope = [];
//   final TextEditingController _outcomeController = TextEditingController();
//   final TextEditingController _futureScopeController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _descriptionController =
//         TextEditingController(text: widget.existingDetails?.description ?? '');
//     _objectiveController =
//         TextEditingController(text: widget.existingDetails?.objective ?? '');
//     _impactStudentsController = TextEditingController(
//         text: widget.existingDetails?.impact.students ?? '');
//     _impactIndustryController = TextEditingController(
//         text: widget.existingDetails?.impact.industry ?? '');
//     _impactResearchController = TextEditingController(
//         text: widget.existingDetails?.impact.research ?? '');
//     if (widget.existingDetails != null) {
//       _outcomes.addAll(widget.existingDetails!.outcomes);
//       _futureScope.addAll(widget.existingDetails!.futureScope);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.existingDetails == null
//             ? "Add Workshop Details"
//             : "Edit Workshop Details"),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildCard(
//               title: "Description",
//               icon: Icons.description,
//               child: TextField(
//                 maxLines: 10,
//                 controller: _descriptionController,
//                 decoration: _inputDecoration("Enter workshop description"),
//               ),
//             ),
//             _buildCard(
//               title: "Objective",
//               icon: Icons.flag,
//               child: TextField(
//                 maxLines: 10,
//                 controller: _objectiveController,
//                 decoration: _inputDecoration("Enter workshop objective"),
//               ),
//             ),
//             _buildCard(
//               title: "Impact",
//               icon: Icons.deck_rounded,
//               child: Column(
//                 children: [
//                   TextField(
//                     maxLines: 10,
//                     controller: _impactStudentsController,
//                     decoration: _inputDecoration("Impact on Students"),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     maxLines: 10,
//                     controller: _impactIndustryController,
//                     decoration: _inputDecoration("Impact on Industry"),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     maxLines: 10,
//                     controller: _impactResearchController,
//                     decoration: _inputDecoration("Impact on Research"),
//                   ),
//                 ],
//               ),
//             ),
//             _buildListAdder(
//               "Outcomes",
//               _outcomes,
//               _outcomeController,
//               Icons.check_circle,
//             ),
//             _buildListAdder(
//               "Future Scope",
//               _futureScope,
//               _futureScopeController,
//               Icons.lightbulb,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                 backgroundColor: Colors.teal,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: _saveDetails,
//               child: Text(
//                 widget.existingDetails == null ? "Add Details" : "Save Changes",
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(String hintText) {
//     return InputDecoration(
//       hintText: hintText,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//     );
//   }
//
//   Widget _buildCard({required String title, required IconData icon, required Widget child}) {
//     return Card(
//
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: Colors.teal, size: 28),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.teal,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildListAdder(
//       String label,
//       List<String> list,
//       TextEditingController controller,
//       IconData icon,
//       ) {
//     return _buildCard(
//       title: label,
//       icon: icon,
//       child: Column(
//         children: [
//           // TextField to add new items with better design
//           TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: "Add $label",
//               hintStyle: const TextStyle(color: Colors.grey),
//               contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//               filled: true,
//               fillColor: Colors.teal.shade50,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.add, color: Colors.teal),
//                 onPressed: () {
//                   if (controller.text.isNotEmpty) {
//                     setState(() {
//                       list.add(controller.text);
//                       controller.clear();
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           // Displaying list of items with delete options
//           Wrap(
//             spacing: 10,
//             children: list
//                 .asMap()
//                 .entries
//                 .map((entry) {
//               int index = entry.key;
//               String item = entry.value;
//               return Chip(
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                 label: Text(
//                   item,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 backgroundColor: Colors.teal.shade200,
//                 deleteIcon: const Icon(Icons.delete, color: Colors.red),
//                 onDeleted: () {
//                   setState(() {
//                     list.removeAt(index);
//                   });
//                 },
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 4,
//               );
//             })
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   void _saveDetails() {
//     final impact = Impact(
//       students: _impactStudentsController.text,
//       industry: _impactIndustryController.text,
//       research: _impactResearchController.text,
//     );
//
//     final details = AboutWorkshopDetails(
//       description: _descriptionController.text,
//       objective: _objectiveController.text,
//       outcomes: _outcomes,
//       futureScope: _futureScope,
//       impact: impact,
//     );
//
//     Provider.of<WorkshopDataProvider>(context, listen: false)
//         .addWorkshopDetails(widget.id, details);
//
//     Navigator.pop(context);
//   }
// }