import 'package:flutter/material.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeTile extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;

  const EmployeeTile({super.key, required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 360;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          radius: isSmallScreen ? 20 : 24,
          // ✅ Null safety for imageUrl
          backgroundImage: NetworkImage(employee.user?.profileImageUrl ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOKIvbFjH7NUlqwrnkImuF_k2tGLS3wwSDCw&s'),
          backgroundColor: Colors.grey[100],
        ),
        title: Text(
          employee.user?.fullName ?? 'Unknown Employee', // ✅ Null safety
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
        // subtitle: Text(
        //   employee.workshopName ?? 'N/A', // ✅ Null safety
        //   style: TextStyle(
        //     fontSize: isSmallScreen ? 12 : 13,
        //     color: Colors.grey[600],
        //   ),
        // ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: isSmallScreen ? 14 : 16,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
