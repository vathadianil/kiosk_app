// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class PhonePeController extends GetxController {
//   final String merchantId = "MERCHANTUAT";
//   final String saltKey = "9b0664b8-d369-4d2b-88f4-65114653cf00";
//   final int saltIndex = 1;
//   final String baseUrl = "https://mercury-uat.phonepe.com/enterprise-sandbox";

//   var isLoading = false.obs; // Observable to track API loading state

//   Future<void> initiatePayment() async {
//     isLoading.value = true;
//     final String apiEndPoint = "/v1/edc/transaction/init";

//     final orderId = "KSKPURORD${DateTime.now().millisecondsSinceEpoch}";
//     final transactionId = "KSKPURTXN${DateTime.now().millisecondsSinceEpoch}";
//     final Map<String, dynamic> requestBody = {
//       "merchantId": "MERCHANTUAT",
//       "storeId": "MS2403212004046998204201",
//       "orderId": orderId,
//       "terminalId": "MST2405301213090857163565",
//       "transactionId": transactionId,
//       "amount": 200,
//       "paymentModes": ["CARD", "DQR"],
//       "timeAllowedForHandoverToTerminalSeconds": 60,
//       "integrationMappingType": "ONE_TO_ONE"
//     };

//     try {
//       // Step 1: Encode request body as Base64
//       String base64Body = base64Encode(utf8.encode(jsonEncode(requestBody)));
//       print('-------------------------------');
//       print('base64Body: $base64Body');
//       // Step 2: Generate X-VERIFY Signature
//       String stringToHash = base64Body + apiEndPoint + saltKey;
//       String sha256Hash = sha256.convert(utf8.encode(stringToHash)).toString();
//       String xVerify = "$sha256Hash###$saltIndex";
//       print('-------------------------------');
//       print('xVerify: $xVerify');
//       // Step 3: Set headers
//       Map<String, String> headers = {
//         "X-VERIFY": xVerify,
//         "Content-Type": "application/json",
//         "X-PROVIDER-ID": "EVITALRXPROVIDER"
//       };

//       // Step 4: Make API Call
//       Uri url = Uri.parse("$baseUrl$apiEndPoint");
//       http.Response response = await http.post(
//         url,
//         headers: headers,
//         body: json.encode({"request": base64Body}),
//       );
//       print('------------------------------------');
//       print(response);
//       // Step 5: Handle response
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         print("Payment Init Success: ${response.body}");
//       } else {
//         print("Payment Init Failed: ${response.body}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
