// import 'package:flutter/material.dart';
// import 'package:mehfilista/features/auth/model/user_model.dart';
// import 'package:mehfilista/services/user_storage.dart';

// // import 'package:vipera/model/user_model.dart';
// // import 'package:vipera/services/user_token_service.dart';
// // import 'package:vipera/services/user_storage.dart';

// class UserDetailProvider with ChangeNotifier {
//   UserModel? _userModel;
//   String? _accessToken;

//   UserModel? get userModel => _userModel;
//   String? get accessToken => _accessToken;
//   bool get isLoggedIn => _userModel != null;

//   UserDetailProvider() {
//     initUserData();
//   }

//   // Initialize user data and token from storage
//   Future<void> initUserData() async {
//     try {
//       // Fetch user and token concurrently
//       final userFuture = UserStorage().getUser();
//       // final tokenFuture = TokenStorage.getToken();
//       _userModel = await userFuture;
//       // _accessToken = await tokenFuture;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error initializing user data: $e');
//       _userModel = null;
//       // _accessToken = null;
//       notifyListeners();
//     }
//   }

//   // Save user and token
//   // Future<void> setUser(UserModel user, {String? token}) async {
//   //   try {
//   //     _userModel = user;
//   //     await UserStorage().saveUser(user);
//   //     if (token != null) {
//   //       _accessToken = token;
//   //       await TokenStorage.saveToken(token);
//   //     } else if (user.accessToken != null) {
//   //       _accessToken = user.accessToken;
//   //       await TokenStorage.saveToken(user.accessToken!);
//   //     }
//   //     notifyListeners();
//   //   } catch (e) {
//   //     debugPrint('Error saving user: $e');
//   //   }
//   // }

//   // Clear user and token
//   Future<void> clearUser() async {
//     try {
//       _userModel = null;
//       _accessToken = null;
//       await UserStorage().deleteUser();
//       // await TokenStorage.deleteToken();
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error clearing user: $e');
//     }
//   }
// }
