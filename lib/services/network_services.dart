// import 'dart:developer';

// import 'package:dio/dio.dart';
// // import 'package:get/get.dart';
// // import 'package:vipera/services/user_token_service.dart';
// // import 'package:your_project/services/token_storage.dart';  // Import the token storage service

// class NetworkService {
//   static final NetworkService _instance = NetworkService._internal();
//   factory NetworkService() => _instance;

//   late Dio dio;

//   NetworkService._internal() {
//     dio = Dio(
//       BaseOptions(
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: {"Content-Type": "application/json"},
//       ),
//     );

//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // Get the Bearer token from secure storage
//           // final token = await TokenStorage.getToken();
//           // print("🔐 Injecting Bearer Token: $token");

//           // if (token != null) {
//           //   // Add Bearer token as Authorization header
//           //   options.headers['Authorization'] = 'Bearer $token';
//           // }

//           print("📤 Request:");
//           print("➡️ [${options.method}] ${options.baseUrl}${options.path}");
//           print("📦 Data: ${options.data}");
//           print("🧾 Headers: ${options.headers}");
//           print("🔎 Query Params: ${options.queryParameters}");

//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print("✅ Response [${response.statusCode}]");
//           print("📨 Data: ${response.data}");
//           return handler.next(response);
//         },

//         onError: (DioException e, handler) {
//           print("❌ Error: ${e.message}");
//           if (e.response != null) {
//             print("🚨 Response Status: ${e.response?.statusCode}");
//             print("💥 Response Data: ${e.response?.data}");
//           }
//           return handler.next(e);
//         },
//       ),
//     );
//   }

//   // GET request
// }
