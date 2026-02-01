import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../admin/domain/entities/workshop_entity.dart';
import '../../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../../admin/presentation/bloc/workshops/workshops_event.dart';
import '../../../../admin/presentation/bloc/workshops/workshops_state.dart';
import '../../bloc/Cubit_dropdown/dropdown_cubit.dart';
import '../../bloc/Cubit_dropdown/dropdown_state.dart';

class DropdownView extends StatefulWidget {
  final bool isEnabled;

  const DropdownView({
    super.key,
    this.isEnabled = true,
  });

  @override
  _DropdownViewState createState() => _DropdownViewState();
}

class _DropdownViewState extends State<DropdownView> {
  @override
  void initState() {
    super.initState();
    final state = context.read<WorkshopsBloc>().state;
    if (state is! WorkshopsLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WorkshopsBloc>().add(LoadWorkshopsEvent());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkshopsBloc, WorkshopsState>(
      listener: _onWorkshopStateChanged,
      child: BlocBuilder<WorkshopsBloc, WorkshopsState>(
        builder: (context, workshopState) {
          if (workshopState is WorkshopsLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (workshopState is WorkshopsError) {
            return _buildErrorWidget(workshopState.message);
          }

          if (workshopState is WorkshopsLoaded) {
            final workshops = workshopState.workshops; // هذه القائمة من نوع WorkshopEntity
            if (workshops.isEmpty) {
              return const Center(child: Text("لا توجد ورشات متاحة", style: TextStyle(color: Colors.grey)));
            }

            return _buildDropdown(workshops);
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }

  void _onWorkshopStateChanged(BuildContext context, WorkshopsState state) {
    if (state is WorkshopsLoaded && state.workshops.isNotEmpty) {
      final dropdownCubit = context.read<DropdownCubit>();
      final currentValue = dropdownCubit.state.selectedValue;

      if (currentValue == null || currentValue.isEmpty) {
        dropdownCubit.changeValue(state.workshops.first.name);
      }
    }
  }

  Widget _buildDropdown(List<WorkshopEntity> workshops) {
    return BlocBuilder<DropdownCubit, DropdownState>(
      builder: (context, dropdownState) {
        final bool isValid = workshops.any((w) => w.name == dropdownState.selectedValue);
        final String? effectiveValue = isValid ? dropdownState.selectedValue : null;

        return DropdownButton2<String>(
          value: effectiveValue,
          isExpanded: true,
          hint: const Text('اختر ورشة', style: TextStyle(color: Colors.grey, fontSize: 14)),
          buttonStyleData: ButtonStyleData(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.isEnabled ? Colors.grey.shade300 : Colors.grey.shade200),
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
          onChanged: widget.isEnabled 
              ? (value) => context.read<DropdownCubit>().changeValue(value!)
              : null,
          items: workshops.map((workshop) => DropdownMenuItem<String>(
            value: workshop.name,
            child: Text(
              workshop.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: effectiveValue == workshop.name ? FontWeight.bold : FontWeight.normal,
                color: widget.isEnabled ? Colors.black : Colors.grey,
              ),
            ),
          )).toList(),
          selectedItemBuilder: (context) {
            return workshops.map((workshop) => Align(
              alignment: Alignment.centerRight,
              child: Text(
                workshop.name,
                style: TextStyle(
                  color: widget.isEnabled ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList();
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text("خطأ: $message", style: const TextStyle(color: Colors.red, fontSize: 12))),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.red),
            onPressed: () => context.read<WorkshopsBloc>().add(LoadWorkshopsEvent()),
          )
        ],
      ),
    );
  }
}
