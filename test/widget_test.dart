import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  testWidgets('Search textfield test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyHomePage(
      title: "Test case Demo",
    ));

    // Wait for data to be fetched
    await tester.pumpAndSettle();

    // Find the TextField for searching
    final searchTextField = find.byType(TextField);

    expect(searchTextField, findsOneWidget);
  });

  testWidgets('Search Username test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyHomePage(
      title: "Test case Demo",
    ));

    // Wait for data to be fetched
    await tester.pumpAndSettle();

    // Find the TextField for searching
    final searchTextField = find.byType(TextField);

    await tester.enterText(searchTextField, 'Tiger');

    // Wait for the widget to rebuild
    await tester.pumpAndSettle();

    expect(find.text('Tiger Nixon'), findsOneWidget);
    expect(find.text('Garrett Winters'), findsNothing);
  });

  testWidgets('test cases for salary check', (WidgetTester tester) async {
    final Dio dio = Dio();
    late DioAdapterMock dioAdapterMock;

    setUp(() {
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
    });

    // Mock response payload
    final responsePayload = jsonEncode({
      "status": "success",
      "data": [
        {
          "id": 1,
          "employee_name": "Tiger Nixon",
          "employee_salary": 320800,
          "employee_age": 61,
          "profile_image": ""
        },
      ],
    });

    final httpResponse = ResponseBody.fromString(
      responsePayload,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

    when(dioAdapterMock.fetch(RequestOptions(), any, any)).thenAnswer((_) async {
      return httpResponse;
    });

    final response = await dio.get("https://dummy.restapiexample.com/api/v1/employees");

    final salary = response.data[0]["employee_salary"] as int;

    expect(salary, greaterThan(40000));
  });
}
