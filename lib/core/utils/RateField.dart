// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class RateField extends StatelessWidget {
//   final TextEditingController controller;
//   final RxList<String> ratesList;
//   final Function(String) onRateSelected;
//   final RxString selectedRate;
//
//   const RateField({
//     Key? key,
//     required this.controller,
//     required this.ratesList,
//     required this.onRateSelected,
//     required this.selectedRate,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       style: const TextStyle(fontSize: 14, height: 1.4),
//       onChanged: (value) {
//         onRateSelected(value);
//       },
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Yeh fix karega niche ka cut issue
//         labelText: 'Rate',
//         labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//         suffixIcon: IconButton(
//           icon: const Icon(Icons.arrow_drop_down),
//           onPressed: () {
//             if (ratesList.isNotEmpty) {
//               Get.bottomSheet(
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                   child: ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: ratesList.length,
//                     separatorBuilder: (_, __) => const Divider(),
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(ratesList[index]),
//                         onTap: () {
//                           onRateSelected(ratesList[index]);
//                           Get.back();
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 backgroundColor: Colors.white,
//               );
//             }
//           },
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//           borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//           borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//           borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//           borderSide: const BorderSide(color: Colors.redAccent),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RateField extends StatelessWidget {
  final TextEditingController controller;
  final RxList<String> ratesList;
  final Function(String) onRateSelected;
  final RxString selectedRate;
  final bool readOnly; // 👈 Optional parameter add kiya

  const RateField({
    Key? key,
    required this.controller,
    required this.ratesList,
    required this.onRateSelected,
    required this.selectedRate,
    this.readOnly = false, // 👈 Default false rakha
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      readOnly: readOnly, // 👈 ReadOnly mode set kiya
      style: const TextStyle(fontSize: 13.5),
      onChanged: (value) {
        if (!readOnly) onRateSelected(value);
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelText: 'Rate',
        labelStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF666666)),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.arrow_drop_down,
            color: readOnly ? Colors.grey : const Color(0xFF666666),
          ),
          onPressed: readOnly ? null : () { // 👈 ReadOnly mein button disable
            if (ratesList.isNotEmpty) {
              Get.bottomSheet(
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: ratesList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text(ratesList[index], style: const TextStyle(fontSize: 14)),
                        onTap: () {
                          onRateSelected(ratesList[index]);
                          Get.back();
                        },
                      );
                    },
                  ),
                ),
                backgroundColor: Colors.white,
              );
            }
          },
        ),
        // Premium Borders matching your other fields
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E3192), width: 2)), // Replace primaryDark if different
      ),
    );
  }
}