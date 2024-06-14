import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum DateTypeEnum { month, day }

extension DateExtension on DateTime {
  DateTime get toTimeZone => add(timeZoneOffset);
  //
  String formatDate(String format) => DateFormat(format).format(this);
  //
}

extension StringExtensions on String {
  Color? parseColor({double? opacity}) =>
      Color(int.parse(replaceAll('#', '0xFF'))).withOpacity(opacity ?? 1);

  String get removeEnd => endsWith("&") ? substring(0, length - 1) : this;
  DateTime get dateParse => DateTime.parse(this);

  //
}

class DateTimePickerWidget extends StatelessWidget {
  /// Support only Time Stamp Value ex: "2024-02-15 00:00:00.000"
  final DateTypeEnum dateTypeEnum;

  const DateTimePickerWidget({super.key, this.dateTypeEnum = DateTypeEnum.day});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return IconButton(
          onPressed: () async {
            String stDate = "";
            String endDate = "";

            if (dateTypeEnum == DateTypeEnum.day) {
              await showDatePicker(
                context: context,
                helpText: "From Date",
                initialDate: DateTime.now(),
                initialDatePickerMode: DatePickerMode.year,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: themeSetter,
              ).then(
                (value) {
                  if (value != null) {
                    String timeStamp = value.toString();
                    stDate = timeStamp;
                  }
                },
              );
              await showDatePicker(
                context: context,
                helpText: "To Date",
                initialDate: DateTime.now(),
                initialDatePickerMode: DatePickerMode.year,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: themeSetter,
              ).then(
                (value) {
                  if (value != null) {
                    String timeStamp = value.toString();
                    endDate = timeStamp;
                  }
                },
              );

              pro.setSalesFilterDate(stDate, endDate);
              pro.calculateTotalSalesAmountFunc();
            } else if (dateTypeEnum == DateTypeEnum.month) {
              await showDatePicker(
                context: context,
                helpText: "From Date",
                initialDate: DateTime.now(),
                initialDatePickerMode: DatePickerMode.year,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: themeSetter,
              ).then(
                (value) {
                  if (value != null) {
                    String timeStamp = value.toString();
                    stDate = timeStamp;
                  }
                },
              );
              await showDatePicker(
                context: context,
                helpText: "To Date",
                initialDate: DateTime.now(),
                initialDatePickerMode: DatePickerMode.year,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: themeSetter,
              ).then(
                (value) {
                  if (value != null) {
                    String timeStamp = value.toString();
                    endDate = timeStamp;
                  }
                },
              );

              pro.setSalesFilterDate(stDate, endDate);
              pro.calculateTotalSalesAmountFunc();
            }
          },
          icon: Icon(
            Icons.calendar_month,
            size: 30.sp,
          ));
    });
  }

  Widget themeSetter(context, child) {
    return Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
                primary: Color(0xff3F5BD9), onPrimary: Colors.white)),
        child: child!);
  }
}

// class DateTimePickerWidget extends StatelessWidget {
//   final DateTypeEnum dateTypeEnum;

//   /// Support only Time Stamp Value ex: "2024-02-15 00:00:00.000"
//   final String? initialValue;
//   final bool? filled;
//   final String? label;
//   final bool isRequired;
//   final bool enabled;
//   final DateTime? initialDate;
//   final DateTime? lastDate;
//   final String formatDate;
//   final Function(String dateTime) onSaved;
//   const DateTimePickerWidget({
//     super.key,
//     this.dateTypeEnum = DateTypeEnum.day,
//     this.filled = true,
//     this.label,
//     this.enabled = true,
//     this.isRequired = true,
//     this.initialDate,
//     this.lastDate,
//     required this.initialValue,
//     required this.onSaved,
//     required this.formatDate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final _controller = initialValue != null && initialValue!.isNotEmpty
//         ? TextEditingController(
//             text: (initialValue!).dateParse.formatDate(formatDate))
//         : TextEditingController();
//     return

//     roundedTextFormField(
//       context,
//       readOnly: true,
//       controller: _controller,
//       keyboardType: TextInputType.number,
//       validator: (value) {
//         if (value == null) {
//           return "Field is Mandatory";
//         } else if (value.isEmpty) {
//           return "Field is Mandatory";
//         } else {
//           return null;
//         }
//       },

//       hintText: "Select $label",
//       labelText: "$label",

//       filled: filled,
//       // fillColor: MyAppTheme.lightGrey,
//       isRequired: isRequired,
//       enabled: enabled,

//       // enabled: isEnabled,
//       suffixIcon: Padding(
//         padding: const EdgeInsets.all(14),
//         child: SvgPicture.asset("assets/svg/calender.svg"),
//       ),
//       // controller: dobController,
//       onTap: () async {
//         if (dateTypeEnum == DateTypeEnum.day) {
//           await showDatePicker(
//             context: context,
//             initialDate: initialDate,
//             initialDatePickerMode: DatePickerMode.year,
//             firstDate: DateTime(1900),
//             lastDate: lastDate ?? DateTime(3000),
//             initialEntryMode: DatePickerEntryMode.calendarOnly,
//             builder: themeSetter,
//           ).then(
//             (value) {
//               if (value != null) {
//                 String timeStamp = value.toString();
//                 onSaved(timeStamp);
//               }
//             },
//           );
//         } else if (dateTypeEnum == DateTypeEnum.month) {
//           await showDatePicker(
//             context: context,
//             initialDate: initialDate ?? DateTime.now(),
//             firstDate: DateTime(1900),
//             lastDate: DateTime(3000),
//             builder: themeSetter,
//           ).then((value) {
//             if (value != null) {
//               String timeStamp = value.toString();
//               onSaved(timeStamp);
//             }
//           });
//         }
//       },
//     );
//   }

//   Widget themeSetter(context, child) {
//     return Theme(
//         data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//                 primary: const Color(0xff3F5BD9), onPrimary: Colors.white)),
//         child: child!);
//   }
// }
