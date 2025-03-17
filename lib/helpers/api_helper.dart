import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:viajanteapp/models/models.dart';
import 'constants.dart';

class ApiHelper {
  static Future<Response> put(
      String controller, String id, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> post(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true, result: response.body);
  }

//---------------------------------------------------------------------------
  static Future<Response> delete(String controller, String id) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCustomers() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Customers/GetCustomers');

    try {
      var response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );
      var body = response.body;

      if (response.statusCode >= 400) {
        return Response(isSuccess: false, message: body);
      }

      List<Customer> list = [];
      var decodedJson = jsonDecode(body);
      if (decodedJson != null) {
        for (var item in decodedJson) {
          list.add(Customer.fromJson(item));
        }
      }
      return Response(isSuccess: true, result: list);
    } catch (e) {
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  //---------------------------------------------------------------------------
  static Future<Response> getBills() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Bills');

    try {
      var response = await http.get(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );
      var body = response.body;

      if (response.statusCode >= 400) {
        return Response(isSuccess: false, message: body);
      }

      List<Bill> list = [];
      var decodedJson = jsonDecode(body);
      if (decodedJson != null) {
        for (var item in decodedJson) {
          list.add(Bill.fromJson(item));
        }
      }
      return Response(isSuccess: true, result: list);
    } catch (e) {
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }
}
