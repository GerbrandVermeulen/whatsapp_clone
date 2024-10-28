// import 'package:flutter/material.dart';

// class PhoneInputForm extends StatefulWidget {
//   const PhoneInputForm({
//     super.key,
//     required this.countryCodeController,
//     required this.numberController,
//     required this.formKey,
//   });

//   final TextEditingController countryCodeController;
//   final TextEditingController numberController;
//   final GlobalKey<FormState> formKey;

//   @override
//   State<PhoneInputForm> createState() => _PhoneInputFormState();
// }

// class _PhoneInputFormState extends State<PhoneInputForm> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 200,
//       child: Form(
//         key: widget.formKey,
//         child: Column(
//           children: [
//             DropdownButtonFormField(
//               isExpanded: true,
//               decoration: InputDecoration(
//                 labelStyle: Theme.of(context)
//                     .textTheme
//                     .labelMedium!
//                     .copyWith(color: Colors.black),
//               ),
//               onChanged: (value) {
//                 // Not gonna support other countries for now
//               },
//               onSaved: (newValue) {
//                 // Not gonna support other countries for now
//               },
//               items: [
//                 DropdownMenuItem(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'South Africa',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(color: Theme.of(context).colorScheme.surface),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: TextFormField(
//                     controller: widget.countryCodeController,
//                     decoration: InputDecoration(
//                       prefixText: '+ ',
//                       prefixStyle: Theme.of(context)
//                           .textTheme
//                           .bodyMedium!
//                           .copyWith(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .surface
//                                   .withOpacity(0.5)),
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                     ),
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(color: Theme.of(context).colorScheme.surface),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 12,
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: TextFormField(
//                     controller: widget.numberController,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(color: Theme.of(context).colorScheme.surface),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
