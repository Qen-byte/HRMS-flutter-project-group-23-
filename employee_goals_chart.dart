import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeGoalsChart extends StatelessWidget {
  const EmployeeGoalsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('employee_goals').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No goals found'));
        }

        List<GoalData> chartData = snapshot.data!.docs
            .map((doc) {
              var data = doc.data() as Map<String, dynamic>;

              // Check for the presence of necessary fields
              if (data.containsKey('title') &&
                  data.containsKey('target') &&
                  data.containsKey('current_progress')) {
                return GoalData(
                  title: data['title'],
                  target: data['target'].toDouble(),
                  progress: data['current_progress'].toDouble(),
                );
              } else {
                // Handle the case where required fields are missing
                return null;
              }
            })
            .where((element) => element != null)
            .toList()
            .cast<GoalData>();

        return Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: chartData.fold<double>(
                          0,
                          (max, data) =>
                              data.target > max ? data.target : max) *
                      1.2,
                ),
                series: <CartesianSeries>[
                  ColumnSeries<GoalData, String>(
                    dataSource: chartData,
                    xValueMapper: (GoalData data, _) => data.title,
                    yValueMapper: (GoalData data, _) => data.target,
                    name: 'Target',
                    color: Colors.grey,
                  ),
                  ColumnSeries<GoalData, String>(
                    dataSource: chartData,
                    xValueMapper: (GoalData data, _) => data.title,
                    yValueMapper: (GoalData data, _) => data.progress,
                    name: 'Progress',
                    color: Colors.blue,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(isVisible: true),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 20, height: 20, color: Colors.grey),
                const SizedBox(width: 5),
                const Text('Target'),
                const SizedBox(width: 20),
                Container(width: 20, height: 20, color: Colors.blue),
                const SizedBox(width: 5),
                const Text('Progress'),
              ],
            ),
          ],
        );
      },
    );
  }
}

class GoalData {
  final String title;
  final double target;
  final double progress;

  GoalData({required this.title, required this.target, required this.progress});
}
