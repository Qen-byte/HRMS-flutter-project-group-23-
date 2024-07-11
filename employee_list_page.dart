import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import 'employee_profile_page.dart';

class EmployeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<EmployeeProvider>(context).employees;

    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (ctx, index) {
          final employee = employees[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(employee.profilePicture),
            ),
            title: Text(employee.name),
            subtitle: Text(employee.position),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeProfilePage(employeeId: employee.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
