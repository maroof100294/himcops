import 'dart:convert';
import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SdkResponseHandler implements ResponseHandler {
  @override
  void onError(SdkError sdkError) {
    Get.defaultDialog(
      title: 'SDK Internal Error',
      middleText: sdkError.toString(),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close the dialog
        },
        child: const Text('Dismiss'),
      ),
    );
  }

  String _timestamp() {
    DateTime now = DateTime.now();
    int timestampInMilliseconds = now.millisecondsSinceEpoch;
    print('BD-timestamp: $timestampInMilliseconds');
    return timestampInMilliseconds.toString();
  }

  String _encryptAES(String plainText, String key, String iv) {
    final keyBytes =
        encrypt.Key.fromUtf8(key); // Use 'encrypt.Key' instead of 'Key'
    final ivBytes = encrypt.IV.fromUtf8(iv); // No conflict with 'IV'
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: ivBytes);
    return encrypted.base64; // Return the encrypted text as a base64 string
  }

  @override
  Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
    print('Transaction map :  $txnInfoMap');
    String merchantId = '${txnInfoMap.txnInfoMap["merchantId"]}';
    String orderId = '${txnInfoMap.txnInfoMap["orderId"]}';
    String transactionid = 'U4560001099939';

    const accountUrl =
        'https://uat1.billdesk.com/u2/payments/ve1_2/transactions/get';

    final encryptionKey = 'your-32-character-encryption-key';
    final encryptionIV = 'your-16-character-IV';

    final requestBody = {
      'mercid': merchantId,
      'orderid': orderId,
      'transactionid': transactionid,
    };
    final encryptedBody =
        _encryptAES(json.encode(requestBody), encryptionKey, encryptionIV);

    final encryptedTraceId = _encryptAES(orderId, encryptionKey, encryptionIV);
    final encryptedTimestamp =
        _encryptAES(_timestamp(), encryptionKey, encryptionIV);

    try {
      final accountResponse = await http.post(
        Uri.parse(accountUrl),
        body: encryptedBody,
        headers: {
          'Content-Type': 'application/jose',
          'accept': 'application/jose',
          'BD-Timestamp': encryptedTimestamp,
          'BD-Traceid': encryptedTraceId,
        },
      );

      print(
          'BD-traceId: $orderId, mercid : $merchantId, orderid: $orderId, transactionId: $transactionid');

      if (accountResponse.statusCode == 200) {
        final decryptedResponse = jsonDecode(accountResponse.body);
        print('Decrypted response: $decryptedResponse');
      } else {
        print('Failed to fetch transaction details: ${accountResponse.body}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }

    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merchant ID: $merchantId'),
                Text('Order ID: $orderId'),
                // Text('Transaction Data: ${accountResponse.body}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:billDeskSDK/sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';

// class SdkResponseHandler implements ResponseHandler {
//   @override
//   void onError(SdkError sdkError) {
//     Get.defaultDialog(
//       title: 'SDK Internal Error',
//       middleText: sdkError.toString(),
//       confirm: ElevatedButton(
//         onPressed: () {
//           Get.back(); 
//         },
//         child: const Text('Dismiss'),
//       ),
//     );
//   }

//   @override
//   Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
//     print('Transaction map :  $txnInfoMap');
//     String merchantId = '${txnInfoMap.txnInfoMap["merchantId"]}';
//     String orderId = '${txnInfoMap.txnInfoMap["orderId"]}';
//     const accountUrl =
//         'https://uat1.billdesk.com/u2/payments/ve1_2/transactions/get';
//     final String bdTimestamp =DateTime.now().millisecondsSinceEpoch.toString();
//     Map<String, dynamic>? accountResponseData;

//     try {
//       final accountResponse = await http.post(
//         Uri.parse(accountUrl),
//         body: json.encode({'mercid': merchantId, 'orderid': orderId}),
//         headers: {
//           'BD-Traceid': orderId,
//           'BD-Timestamp': bdTimestamp,
//           'Content-Type': 'application/jose',
//           'Accept': 'application/jose',
//         },
//       );
//       print('BD-traceId: $orderId, BD-Timestamp: $bdTimestamp, mercid : $merchantId, orderid: $orderId');

//       if (accountResponse.statusCode == 200) {
//         accountResponseData = jsonDecode(accountResponse.body);
//       } else {
//         print('Failed to fetch transaction details: ${accountResponse.body}');
//       }
//     } catch (e) {
//       print('Error during HTTP request: $e');
//     }

//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Merchant ID: $merchantId'),
//                 Text('Order ID: $orderId'),
//                 Text('Transaction Data: ${accountResponseData ?? "No Data"}'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.back(); 
//                   },
//                   child: const Text('Dismiss'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











// String _timestamp() {
//   // Get the current system time
//   DateTime now = DateTime.now();

//   // Convert to milliseconds since epoch
//   int timestampInMilliseconds = now.millisecondsSinceEpoch;
//   print('BD-timestamop: $timestampInMilliseconds');
//   return timestampInMilliseconds.toString();
// }

//   @override
//   Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
//     print('Transaction map :  $txnInfoMap');
//     String merchantId = '${txnInfoMap.txnInfoMap["merchantId"]}';
//     String orderId = '${txnInfoMap.txnInfoMap["orderId"]}';
//     String transactionid ='U4560001099939'; //X4560477641875
//     // print('mercId :  $merchantId , order ID: $orderId');
//     const accountUrl =
//         'https://uat1.billdesk.com/u2/payments/ve1_2/transactions/get';

//     Map<String, dynamic>? accountResponseData;

//     try {
//       final accountResponse = await http.post(
//         Uri.parse(accountUrl),
//         body: json.encode({'mercid': merchantId, 'orderid': orderId, 'transactionid': transactionid}),
//         headers: {
//           'Content-Type': 'application/json',
//           'accept':'application/json',
//           'BD-Timestamp': _timestamp(),
//           'BD-Traceid': orderId
//         },
        
//       );
//       print('BD-traceId: $orderId, mercid : $merchantId, orderid: $orderId, transactionId: $transactionid');

//       if (accountResponse.statusCode == 200) {
//         accountResponseData = jsonDecode(accountResponse.body);
//       } else {
//         print('Failed to fetch transaction details: ${accountResponse.body}');
//       }
//     } catch (e) {
//       print('Error during HTTP request: $e');
//     } 