import 'dart:convert';
import 'dart:io';
import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:himcops/citizen/searchstaus/pccviewpage.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';

class SdkResponseHandler implements ResponseHandler {
  @override
  void onError(SdkError sdkError) {
    Get.defaultDialog(
      title: 'SDK Internal Error',
      middleText: sdkError.toString(),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Dismiss'),
      ),
    );
  }

  String addPadding(String base64UrlString) {
    int missingPadding = 4 - (base64UrlString.length % 4);
    if (missingPadding != 4) {
      return base64UrlString + '=' * missingPadding;
    }
    return base64UrlString;
  }

  @override
  Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
    print('Transaction map :  $txnInfoMap');
    String merchantId = '${txnInfoMap.txnInfoMap["merchantId"]}';
    String orderId = '${txnInfoMap.txnInfoMap["orderId"]}';
    var payloa = {
      "mercid": merchantId,
      "orderid": orderId,
    };

    var head = {
      "alg": "HS256",
      "clientid": "uathpcopos",
    };
    const accountUrl =
        'https://uat1.billdesk.com/u2/payments/ve1_2/transactions/get';

    String encodedHeader = base64Url.encode(utf8.encode(jsonEncode(head)));
    String encodedPayload = base64Url.encode(utf8.encode(jsonEncode(payloa)));
    String encodedHeaderPayload = '$encodedHeader.$encodedPayload';
    String secretKey =
        'Xv5BmIa50ewwFHZxDZ8SkLsUpVgej3Nh'; // Production: 'wtM0jJUPhueSKJ56T0VOUKq0GcMLwvwA'
    final key = utf8.encode(secretKey);
    final hmacSha256 = Hmac(sha256, key);
    final hmacSignature = hmacSha256.convert(utf8.encode(encodedHeaderPayload));
    String encodedSignature = base64Url.encode(hmacSignature.bytes);
    String jwt = '$encodedHeaderPayload.$encodedSignature';
    int epochTimestamp = DateTime.now().millisecondsSinceEpoch;
    Map<String, String> headers = {
      'Content-Type': 'application/jose',
      'bd-timestamp': epochTimestamp.toString(),
      'Accept': 'application/jose',
      'bd-traceid': '$orderId$epochTimestamp',
    };

    String thirdPartyUrl = accountUrl;

    final response = await http
        .post(
      Uri.parse(thirdPartyUrl),
      headers: headers,
      body: utf8.encode(jwt),
    )
        .timeout(const Duration(seconds: 30), onTimeout: () {
      print("Request timeout");
      return http.Response('Timeout', 408);
    });
    print("Request Headers: $headers");
    print("Request Body: $jwt");

    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<String> responseLines = LineSplitter.split(responseBody).toList();
      StringBuffer responseBuffer = StringBuffer();
      for (var line in responseLines) {
        responseBuffer.writeln(line);
      }

      print(
          "Response Body (Buffered-like processing): ${responseBuffer.toString()}");

      // POST the responseBuffer.toString() to the new API
      try {
        final ioc = HttpClient();
        ioc.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final client = IOClient(ioc);
        final saveResponse = await client.post(
          Uri.parse('$baseUrl/androidapi/service/saveBillDeskResponse'),
          headers: {
            'Content-Type': 'application/json',
          },
          body:
              jsonEncode({'encryptedResponse': "${responseBuffer.toString()}"}),
        );

        if (saveResponse.statusCode == 200) {
          print('Response successfully saved: ${saveResponse.body}');
        } else {
          print('Error saving response: ${saveResponse.statusCode}');
          print('Error Response: ${saveResponse.body}');
        }
      } catch (e) {
        print('Exception while saving response: $e');
      }

      // Process the JWT parts
      List<String> jwtParts = responseBuffer.toString().split('.');
      String payload = jwtParts[1];
      payload = addPadding(payload);
      String decodedPayload = utf8.decode(base64Url.decode(payload));
      Map<String, dynamic> jsonPayload = jsonDecode(decodedPayload);
      print("Decoded Payload: $jsonPayload");

      // Handle response and show dialog
      String authStatus = jsonPayload['amount'];
      // String oid = jsonPayload['orderid'];
      String tran = jsonPayload['transactionid'];
      String trans = jsonPayload['transaction_error_desc'];
      Map<String, String> resultMap = {
        'Amount Paid': authStatus,
        'Transaction Id': tran,
        'Transaction Status': trans,
      };

      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${resultMap.isNotEmpty ? resultMap.toString() : 'No Data'}"), //resultMap.isNotEmpty ? resultMap.toString() :
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.offAll(CitizenGridPage());
                        },
                        child: const Text('Go to Home'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      print(resultMap);
    } else {
      print('Error: ${response.statusCode}');
      print('Error Response: ${response.body}');

      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Error: ${response.statusCode}\nError Response: ${response.body}'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.offAll(PoliceClearanceCertificateViewPage());
                        },
                        child: const Text('Go to Home'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

// const String callbackSimulatorUrl =
//           'https://uat1.billdesk.com/u2/websimulator/upi/callbackSimulator';

//       Map<String, dynamic> requestBody = {
//         "bankId": "HD5",
//         "requestId": "$tran",
//         "requestType": "Transaction Creation",
//         "status": "SUCCESS",c
//         "txnType": "Collect",
//         "payerVpa": "testvpa@icici",
//         "payerName": "",
//         "payerMobile": ""
//       };

//       try {
//         final response = await http.post(
//           Uri.parse(callbackSimulatorUrl),
//           headers: {
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(requestBody),
//         );

//         if (response.statusCode == 200) {
//           print('UPI Callback Simulation Successful: ${response.body}');
//         } else {
//           print('Error: ${response.statusCode}');
//           print('Response: ${response.body}');
//         }
//       } catch (e) {
//         print('Exception: $e');
//       }
