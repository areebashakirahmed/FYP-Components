// import 'package:dio/dio.dart';
// import 'package:mehfilista/services/network_services.dart';

// class ApiServices {
//   final Dio dio = NetworkService().dio;
//   final int maxRetries = 3;
//   final Duration retryDelay = Duration(seconds: 2);

//   Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
//     return _retry(() => dio.get(endpoint, queryParameters: params));
//   }

//   Future<Response> post(
//     String endpoint, {
//     Map<String, dynamic>? data,
//     bool useFormData = false,
//   }) async {
//     final requestData = useFormData ? FormData.fromMap(data ?? {}) : data;

//     return _retry(
//       () => dio.post(
//         endpoint,
//         data: requestData,
//         options: Options(
//           headers: {
//             "Content-Type": useFormData
//                 ? "multipart/form-data"
//                 : "application/json",
//           },
//         ),
//       ),
//     );
//   }

//   Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
//     FormData formData = FormData.fromMap(data ?? {});
//     return _retry(() => dio.put(endpoint, data: formData));
//   }

//   Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) async {
//     FormData formData = FormData.fromMap(data ?? {});
//     return _retry(() => dio.delete(endpoint, data: formData));
//   }

//   Future<Response> getwithOptions(
//     String endpoint, {
//     Map<String, dynamic>? params,
//     Options? options,
//   }) async {
//     return _retry(
//       () => dio.get(endpoint, queryParameters: params, options: options),
//     );
//   }

//   Future<Response> _retry(Future<Response> Function() request) async {
//     int attempt = 0;
//     while (true) {
//       try {
//         return await request();
//       } on DioException catch (e) {
//         attempt++;
//         final shouldRetry = _isRetryableError(e);
//         if (attempt >= maxRetries || !shouldRetry) {
//           throw _handleError(e);
//         }
//         await Future.delayed(retryDelay);
//       }
//     }
//   }

//   bool _isRetryableError(DioException error) {
//     return error.type == DioExceptionType.connectionTimeout ||
//         error.type == DioExceptionType.receiveTimeout ||
//         error.type == DioExceptionType.sendTimeout ||
//         error.type == DioExceptionType.connectionError;
//   }

//   dynamic _handleError(DioException error) {
//     if (error.response != null) {
//       return error.response?.data;
//     } else {
//       return 'Unexpected error: ${error.message}';
//     }
//   }
// }
