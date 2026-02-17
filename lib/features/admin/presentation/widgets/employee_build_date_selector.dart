import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/employee model/get_employee_details_hours_details_response.dart';

class EmployeeBuildDateSelector extends StatefulWidget {
  final ThemeData theme;
  final ValueNotifier<Week?> selectedWeek ;
  final List<Week> weeks;

  const EmployeeBuildDateSelector({super.key, required this.theme, required this.selectedWeek, required this.weeks});

  @override
  State<EmployeeBuildDateSelector> createState() => _EmployeeBuildDateSelectorState();
}

class _EmployeeBuildDateSelectorState extends State<EmployeeBuildDateSelector> {

  @override
  void initState() {
    if( widget.weeks.isNotEmpty ){
      widget.selectedWeek.value=widget.weeks[0];

    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.weeks.isEmpty?
          Text('لا يوحد سجلات لعرضها')
          :
      Column(
      children: [
        Row(
          children: [
            Icon(Icons.filter_alt_outlined, size: 18.sp,
                color: widget.theme.primaryColor),
            SizedBox(width: 8.w),
            Text(
              "تصفية النتائج",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: widget.theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: widget.theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: widget.theme.dividerColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: widget.selectedWeek,
                  builder: (context, value, child) {
                    return _buildDropdown<Week?>(
                      value: value,
                      items:widget.weeks,
                      onChanged: (val) =>  widget.selectedWeek.value = val!,
                      label: "حسب الاسبوع",
                      theme: widget.theme,
                      itemLabel: (val){
                        return val!.weekRange!;
                      }

                    );
                  }
                ),
              ),
              // SizedBox(width: 12.w),
              // Expanded(
              //   child: _buildDropdown<int>(
              //     value: selectedMonth,
              //     items: List.generate(12, (index) => index + 1),
              //     itemLabel: (m) => DateHelper.getMonthName(m),
              //     onChanged: (val) => setState(() => selectedMonth = val!),
              //     label: "الشهر",
              //     theme: theme,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildDropdown<T>({
  required T value,
  required List<T> items,
  required ValueChanged<T?> onChanged,
  required String label,
  required ThemeData theme,
  String Function(T)? itemLabel,

}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 6.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            dropdownColor: theme.cardColor,
            icon: Icon(Icons.keyboard_arrow_down, color: theme.primaryColor),
            items:
            items
                .map(
                  (T item) =>
                  DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel != null
                          ? itemLabel(item)
                          : item.toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
            )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}