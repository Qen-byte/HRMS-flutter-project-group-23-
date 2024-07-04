class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LeaveApplicationForm(),
    );
  }
}

class LeaveApplicationForm extends StatefulWidget {
  const LeaveApplicationForm({Key? key}) : super(key: key);

  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  final List<String> _leaveTypes = ['Annual', 'Sick', 'Casual', 'Unpaid'];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Leave Type'),
                value: _leaveType,
                onChanged: (String? value) {
                  setState(() {
                    _leaveType = value;
                  });
                },
                items: _leaveTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a leave type';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _startDate = date;
                      _startDateController.text =
                          _startDate!.toLocal().toString().split(' ')[0];
                    });
                  }
                },
                validator: (String? value) {
                  if (_startDate == null) {
                    return 'Please select a start date';
                  }
                  return null;
                },
                controller: _startDateController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'End Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _endDate = date;
                      _endDateController.text =
                          _endDate!.toLocal().toString().split(' ')[0];
                    });
                  }
                },
                validator: (String? value) {
                  if (_endDate == null) {
                    return 'Please select an end date';
                  }
                  return null;
                },
                controller: _endDateController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _reason = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    // Process leave application
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Leave application submitted')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
