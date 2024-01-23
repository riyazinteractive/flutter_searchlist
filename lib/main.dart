import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Employee> employees = [];
  List<Employee> filterList = [];

  late TextEditingController _editController;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchData();
    _editController = TextEditingController();
  }

  Future<void> fetchData() async {
    final Dio dio = Dio();
    final response = await dio.get('https://dummy.restapiexample.com/api/v1/employees');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      final List<dynamic> employeeData = data['data'];
      employees = employeeData
          .map((e) => Employee(
                id: e['id'],
                name: e['employee_name'],
                salary: e['employee_salary'],
                age: e['employee_age'],
                profileImage: e['profile_image'],
              ))
          .toList();
      setState(() {
        // Update the employees list with the data from the API
        filterList = employees;
      });
    }
  }

  void searchFromList(String value) {
    print('text field: $value');
    filterList = employees
        .where((e) =>
            e.name.toLowerCase().contains(value.toLowerCase()) ||
            e.salary.toString().contains(value))
        .toList();
    print('filterList::::' + filterList.length.toString());
    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 200,
                height: 50,
                child: TextField(
                  controller: _editController,
                  onChanged: (value) {
                    searchFromList(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search by Name or Salary',
                    border: OutlineInputBorder(),
                  ),
                )),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                key: const Key('employee_list'),
                itemCount: filterList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filterList[index].name),
                    subtitle: Text('Salary: ${filterList[index].salary}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
