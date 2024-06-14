import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget staticDropDown(context,
    {required String labelText,
    bool isRequired = false,
    Widget? prefix,
    required String? dropdownvalue,
    bool setBorderColorRed = false,
    required List<String> list,
    bool enabled = true,
    required Function(String?) onCallBack}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelText != ""
          ? Text.rich(TextSpan(
              text: labelText,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              children: <InlineSpan>[
                TextSpan(
                  text: isRequired ? '*' : "",
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                )
              ],
            ))
          : const SizedBox(),
      labelText != "" ? const SizedBox(height: 10) : const SizedBox(),
      FormField<String>(
        enabled: enabled,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              enabled: enabled,
              prefixIcon: prefix,
              contentPadding: const EdgeInsets.only(
                  top: 18, bottom: 18, left: 23, right: 10),
              errorStyle:
                  const TextStyle(color: Colors.redAccent, fontSize: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    width: 1, style: BorderStyle.solid, color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          setBorderColorRed ? Colors.red : Colors.grey.shade200,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: setBorderColorRed
                          ? Colors.red
                          : Colors.grey.shade200)),
            ),
            isEmpty: list == [],
            child: enabled == false
                ? Text(dropdownvalue ?? "")
                : DropdownButtonHideUnderline(
                    child: SizedBox(
                      height: 25,
                      child: DropdownButton<String>(
                        value: dropdownvalue,
                        isDense: false,
                        isExpanded: false,
                        borderRadius: BorderRadius.circular(15.r),
                        onChanged: onCallBack,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black,
                        ),
                        items: list.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          );
        },
      ),
      const SizedBox(
        height: 15,
      )
    ],
  );
}
