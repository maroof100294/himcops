import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:himcops/authservice.dart';
import 'package:himcops/config.dart';
import 'package:himcops/pages/cgridhome.dart';
import 'package:himcops/pages/logsplash.dart';
import 'package:http/io_client.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SSOPage extends StatefulWidget {
  const SSOPage({super.key});

  @override
  State<SSOPage> createState() => _SSOPageState();
}

class _SSOPageState extends State<SSOPage> {
  late final WebViewController _controller;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  bool isLoading = true;
  String errorMessage = '';
  String? loginId;
  String? firstName;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? tehsil;
  String? village;
  int? mobile2;
  int? stateCd;
  int? districtCd;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (url.startsWith('http://164.100.138.203:8080/logincallback')) {
              _handleCallbackUrl(url);
            }
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://sso.hp.gov.in/login-iframe?service_id=10000106'));
  }

  Future<void> _handleCallbackUrl(String url) async {
    final Uri uri = Uri.parse(url);
    final token = uri.queryParameters['token'];
    print('token: $token');
    if (token != null) {
      const int statusCode = 200;
      if (statusCode == 200) {
        _navigateToLoadPage();
        await _validateToken(token);
      }
    }
  }

  void _navigateToLoadPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LogSplashScreen(),
      ),
    );
  }

  Future<void> _validateToken(String token) async {
    const String apiUrl = 'https://sso.hp.gov.in/nodeapi/validate-token';
    const String secretKey =
        'ee327e49def7c1abe0afb9337226fb34501918f3d66f08811892d3fd168662a5';
    const String serviceId = '10000106';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'secret_key': secretKey,
          'service_id': serviceId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('API Response: $responseData');
        await validateLogin(responseData);
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> validateLogin(Map<String, dynamic> responseData) async {
    final token = await AuthService.getAccessToken(); // Fetch the token

    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to retrieve access token.';
      });
      _showErrorDialog('Technical Problem, Please Try again later');
      return;
    }

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioc);
      final logintUrl = '$baseUrl/androidapi/service/savessouser';

      final loginResponse = await client.post(
        Uri.parse(logintUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(responseData),
      );
      if (loginResponse.statusCode == 200) {
        final loginResponseData = jsonDecode(loginResponse.body);
        if (loginResponseData['messages'] == 'Success') {
          final userData = loginResponseData['data'][0];

          // Save only non-null values
          await storage.write(key: 'loginId', value: userData['loginId']);
          await storage.write(
              key: 'firstName', value: userData['firstName'] ?? '');
          await storage.write(key: 'email', value: userData['email'] ?? '');
          await storage.write(
              key: 'addressLine1', value: userData['addressLine1'] ?? '');
          await storage.write(
              key: 'addressLine2', value: userData['addressLine2'] ?? '');
          await storage.write(
              key: 'addressLine3', value: userData['addressLine3'] ?? '');
          await storage.write(key: 'tehsil', value: userData['tehsil'] ?? '');
          await storage.write(key: 'village', value: userData['village'] ?? '');
          await storage.write(
              key: 'mobile2', value: (userData['mobile2']?.toString() ?? ''));
          await storage.write(
              key: 'stateCd', value: (userData['stateCd']?.toString() ?? ''));
          await storage.write(
              key: 'districtCd',
              value: (userData['districtCd']?.toString() ?? ''));

          print('User Data Saved successfully');
        } else {
          print("Please Fill the Details");
        }
      } else {
        print('User Data failed: ${loginResponse.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Image.asset(
                'asset/images/hp_logo.png',
                height: 50,
              ),
              const SizedBox(height: 8),
              const Text(
                'Himachal Pradesh',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Citizen Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CitizenGridPage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CitizenGridPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Single Sign On",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
//Exception encountered java.lang.NullPointerException: Attempt to invoke interface method 'byte[] com.it_nomads.fluttersecurestorage.ciphers.StorageCipher.encrypt(byte[])' on a null object reference
	// at com.it_nomads.fluttersecurestorage.FlutterSecureStorage.write(FlutterSecureStorage.java:114)
	// at com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin$MethodRunner.run(FlutterSecureStoragePlugin.java:137)
	// at android.os.Handler.handleCallback(Handler.java:958)
	// at android.os.Handler.dispatchMessage(Handler.java:99)
	// at android.os.Looper.loopOnce(Looper.java:205)
	// at android.os.Looper.loop(Looper.java:294)
	// at android.os.HandlerThread.run(HandlerThread.java:67)
/* PlatformException (PlatformException(Exception encountered, write, java.lang.NullPointerException: Attempt to invoke interface method 'byte[] com.it_nomads.fluttersecurestorage.ciphers.StorageCipher.encrypt(byte[])' on a null object reference
	at com.it_nomads.fluttersecurestorage.FlutterSecureStorage.write(FlutterSecureStorage.java:114)
	at com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin$MethodRunner.run(FlutterSecureStoragePlugin.java:137)
	at android.os.Handler.handleCallback(Handler.java:958)
	at android.os.Handler.dispatchMessage(Handler.java:99)
	at android.os.Looper.loopOnce(Looper.java:205)
	at android.os.Looper.loop(Looper.java:294)
	at android.os.HandlerThread.run(HandlerThread.java:67)
, null)) */