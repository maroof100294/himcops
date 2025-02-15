import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
// import 'package:himcops/config.dart';
import '../SDKResponseHandler.dart';
import 'package:billDeskSDK/sdk.dart';
// ignore: unused_import
import 'dart:math';

class PaymentPage extends StatefulWidget {
  final String mercid;
  final String bdorderid;
  final String rdata;
  final String token;

  const PaymentPage({
    super.key,
    required this.mercid,
    required this.bdorderid,
    required this.rdata,
    required this.token,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? validateReturnURL(String value) {
    if (!RegExp(
            r"^(https?)://[-a-zA-Z0-9+&@#/%?=_|!:,.;]*[-a-zA-Z0-9+&@#/%=_|]{1,2000}$")
        .hasMatch(value)) {
      return null;
    }
    return value;
  }

  void _launchSDK(String value) {
    final validReturnURL = validateReturnURL(value);
    if (validReturnURL == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Return URL')),
      );
      return;
    }

    final flowConfig = {
      "merchantId": widget.mercid,
      "bdOrderId": widget.bdorderid,
      "childWindow": false,
      "returnUrl": validReturnURL,
      "authToken": widget.token,
    };
    print(
        'mercId :- ${widget.mercid}, borderId :- ${widget.bdorderid}, token :- ${widget.token}, RU :- $validReturnURL');
    final sdkConfigMap = {
      "flowConfig": flowConfig,
      "flowType": "payments",
      "merchantLogo": ""
    };

    ResponseHandler responseHandler = SdkResponseHandler();
    final sdkConfig = SdkConfig(
      sdkConfigJson: SdkConfiguration.fromJson(sdkConfigMap),
      responseHandler: responseHandler,
      // isUATEnv: true,
      // isDevModeAllowed: true,
      // isJailBreakAllowed: true,
    );

    SDKWebView.openSDKWebView(sdkConfig);

    print("Invoked Billdesk SDK with: $sdkConfig");
    print("flowConfig : $flowConfig");
  }
  

  @override
  Widget build(BuildContext context) {
    String returnURL =
       "https://citizenportal.hppolice.gov.in/androidapi/service/pcrcallback"; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
        backgroundColor: const Color(0xFFB9DA6B),
      ),
      body: Center(
        child: Text('mercId :- ${widget.mercid},\nborderId :- ${widget.bdorderid}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchSDK(returnURL),
        tooltip: 'Launch SDK demo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
