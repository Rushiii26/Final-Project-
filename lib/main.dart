import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blood Pressure Monitor',
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatelessWidget {
  final BloodPressureController bpController = Get.put(BloodPressureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Blood Pressure'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Systolic Pressure',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => bpController.systolic.value = int.tryParse(value) ?? 0,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Diastolic Pressure',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => bpController.diastolic.value = int.tryParse(value) ?? 0,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                bpController.validateAndNavigate();
              },
              child: const Text('Check Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class BloodPressureController extends GetxController {
  var systolic = 0.obs;
  var diastolic = 0.obs;

  void validateAndNavigate() {
    if (systolic.value > 0 && diastolic.value > 0) {
      Get.to(InformationScreen(), arguments: {
        'systolic': systolic.value,
        'diastolic': diastolic.value,
      });
    } else {
      Get.snackbar(
        'Error',
        'Please enter valid blood pressure values',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> bpValues = Get.arguments;
    final category = determineCategory(bpValues['systolic']!, bpValues['diastolic']!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your blood pressure is $category', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(DetailsScreen());
              },
              child: Text('Show Details',),
            ),
          ],
        ),
      ),
    );
  }

  String determineCategory(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 'Normal';
    } else if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      return 'Elevated';
    } else if (systolic >= 130 && systolic <= 139 || diastolic >= 80 && diastolic <= 89) {
      return 'High Blood Pressure (Stage 1)';
    } else if (systolic >= 140 || diastolic >= 90) {
      return 'High Blood Pressure (Stage 2)';
    } else if (systolic > 180 || diastolic > 120) {
      return 'Hypertensive Crisis';
    } else {
      return 'Unknown';
    }
  }
}

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Additional details will be shown here.',style:TextStyle(color: Color.fromARGB(255, 4, 56, 98), fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            DataTable(
             columns: [
                DataColumn(
                  label: Text('Systolic Blood Pressure', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                ),
                DataColumn(
                  label: Text('Diastolic Blood Pressure', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                ),
                DataColumn(
                  label: Text('Blood Pressure Stage', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                ),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('40-90')),
                  DataCell(Text('40-60')),
                  DataCell(Text('Low')),
                ]),
                DataRow(cells: [
                  DataCell(Text('90-120')),
                  DataCell(Text('60-80')),
                  DataCell(Text('Normal')),
                ]),
                DataRow(cells: [
                  DataCell(Text('120-140')),
                  DataCell(Text('80-90')),
                  DataCell(Text('Prehypertension')),
                ]),
                DataRow(cells: [
                  DataCell(Text('140-160')),
                  DataCell(Text('90-100')),
                  DataCell(Text('High-Stage 1 Hypertension')),
                ]),
                DataRow(cells: [
                  DataCell(Text('160-180+')),
                  DataCell(Text('100-120+')),
                  DataCell(Text('High-Stage 2 Hypertension')),
                ]),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
