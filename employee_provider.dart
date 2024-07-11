import 'package:flutter/foundation.dart';
import '../models/employee.dart';

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [
    // Sample data
    Employee(
      id: '1',
      name: 'John Doe',
      position: 'Software Engineer',
      department: 'Development',
      email: 'john.doe@example.com',
      phoneNumber: '123-456-7890',
      profilePicture: 'assets/profile_pictures/john_doe.png',
    ),
    // Add more employees
  ];

  List<Employee> get employees => _employees;

  Employee getEmployeeById(String id) {
    return _employees.firstWhere((employee) => employee.id == id);
  }
}
