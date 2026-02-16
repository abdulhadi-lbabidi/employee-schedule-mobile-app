import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/core/widget/shimmer_widget.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_event.dart';
import '../../../../admin/data/models/workshop_models/workshop_model.g.dart';
import '../../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../../admin/presentation/bloc/workshops/workshops_state.dart';
import '../../bloc/Cubit_dropdown/dropdown_cubit.dart';
import '../../bloc/Cubit_dropdown/dropdown_state.dart';

class DropdownView extends StatefulWidget {
  const DropdownView({super.key});

  @override
  _DropdownViewState createState() => _DropdownViewState();
}

class _DropdownViewState extends State<DropdownView> {
  @override
  void initState() {
    super.initState();
    context.read<WorkshopsBloc>().add(GetAllWorkShopEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkshopsBloc, WorkshopsState>(
      // listener: _onWorkshopStateChanged,
      builder: (context, workshopState) {
        return workshopState.getAllWorkshopData.builder(
          onSuccess: (workshops) {
            if (workshops!.data!.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد ورشات متاحة",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return _buildDropdown(workshops.data!);
          },
          loadingWidget: ShimmerWidget(
            borderRadius: BorderRadius.circular(12),
            width: double.infinity,
            height: 45.h,
          ),
          failedWidget: _buildErrorWidget(
            workshopState.getAllWorkshopData.errorMessage,
          ),
        );
      },
    );
  }

  // void _onWorkshopStateChanged(BuildContext context, WorkshopsState state) {
  //   // if (state is WorkshopsLoaded && state.workshops.isNotEmpty) {
  //   //   final dropdownCubit = context.read<DropdownCubit>();
  //   //   final currentValue = dropdownCubit.state.selectedValue;
  //   //
  //   //   if (currentValue == null || currentValue.isEmpty) {
  //   //     dropdownCubit.changeValue(state.workshops.first.name);
  //   //   }
  //   // }
  // }

  Widget _buildDropdown(List<WorkshopModel> workshops) {
    return BlocBuilder<DropdownCubit, DropdownState>(
      builder: (context, dropdownState) {
        final WorkshopModel? selected =
            dropdownState.selectedValue == null
                ? null
                : workshops.cast<WorkshopModel?>().firstWhere((e) {
                  return e?.id == dropdownState.selectedValue!.id;
                }, orElse: () => null);
        bool enable =
            !(selected != null && dropdownState.localeAttendanceModel != null);

        return DropdownButton2<WorkshopModel?>(
          underline: const SizedBox.shrink(),
          value: selected,
          isExpanded: true,
          hint: const Text(
            'اختر ورشة',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          buttonStyleData: ButtonStyleData(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enable ? Colors.grey.shade300 : Colors.grey.shade200,
              ),
              color: Colors.white,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
          ),
          onChanged:
              enable
                  ? (value) => context.read<DropdownCubit>().changeValue(value!)
                  : null,
          items:
              workshops
                  .map(
                    (workshop) => DropdownMenuItem<WorkshopModel>(
                      value: workshop,
                      child: Text(
                        workshop.name!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              selected?.id == workshop.id
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color: enable ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          selectedItemBuilder: (context) {
            return workshops
                .map(
                  (workshop) => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      workshop.name!,
                      style: TextStyle(
                        color: enable ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList();
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "خطأ: $message",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.red),
            onPressed:
                () => context.read<WorkshopsBloc>().add(GetAllWorkShopEvent()),
          ),
        ],
      ),
    );
  }
}
