// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mehfilista/components/custom_button.dart';
// import 'package:mehfilista/features/add-people/add_people_screen.dart';
// import 'package:mehfilista/features/edit_profile/edit_profile_screen.dart';
// import 'package:mehfilista/features/groups/group_screen.dart';
// import 'package:mehfilista/features/library/library_screen.dart';
// import 'package:mehfilista/features/notifications/notification_screen.dart';
// import 'package:mehfilista/features/profile/profile_screen.dart';
// import 'package:mehfilista/features/subscription/manage_subscription_screen.dart';
// import 'package:mehfilista/features/subscription/my_subscriptions.dart';
// import 'package:mehfilista/utils/constants/colors.dart';

// // import 'custom_list_tile.dart';

// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topRight: Radius.circular(20),
//         bottomRight: Radius.circular(20),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.sp),
//         width: 300.w,
//         decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               // Custom header without DrawerHeader
//               Container(
//                 height: 220.h, // Increased height for custom header
//                 padding: EdgeInsets.only(top: 20.h),
//                 margin: EdgeInsets.only(top: 20.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => EditProfileScreen(),
//                           ),
//                         );
//                       },
//                       child: SizedBox(
//                         width: 106.w,
//                         height: 106.h,
//                         child: Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 55.r,
//                               backgroundImage: AssetImage(
//                                 "assets/images/person.jpg",
//                               ),
//                               // backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image URL
//                             ),
//                             Positioned(
//                               right: 0,
//                               bottom: 0,
//                               child: Container(
//                                 width: 34.w,
//                                 height: 34.h,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8.sp),
//                                   color: AppColors.redColor,
//                                 ),
//                                 child: Center(
//                                   child: Icon(
//                                     Icons.edit,
//                                     color: AppColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Williams Son',
//                             style: TextStyle(
//                               color: AppColors.white,
//                               fontSize: 22.sp,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: -0.25.sp,
//                             ),
//                           ),
//                           Text(
//                             'williams@gmail.com',
//                             style: TextStyle(
//                               color: AppColors.greyText,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(),
//                   ],
//                 ),
//               ),
//               CustomListTile(
//                 icon: Icons.person_outline,
//                 title: 'Profile',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => ProfileScreen()),
//                   );
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.library_books,
//                 title: 'Library',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => LibraryScreen()),
//                   );
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.group,
//                 title: 'Groups',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => GroupScreen()),
//                   );
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.person_add,
//                 title: 'Add People',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => AddPeopleScreen()),
//                   );
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.notifications_none,
//                 title: 'Notifications',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => NotificationScreen()),
//                   );
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.manage_accounts,
//                 title: 'Manage Subscription',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => MySubscription()),
//                   );
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.description,
//                 title: 'Terms & Conditions',
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               CustomListTile(
//                 icon: Icons.privacy_tip,
//                 title: 'Privacy Policy',
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               CustomButton(
//                 onTap: () {},
//                 btnText: "LogOut",
//                 width: 250.w,
//                 mainColor: [AppColors.redColor, AppColors.redColor],
//                 borderColor: AppColors.redColor,
//                 txtColor: AppColors.white,
//               ),
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomListTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const CustomListTile({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: AppColors.white),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: AppColors.white,
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w500,
//           letterSpacing: -0.25.sp,
//         ),
//       ),
//       onTap: onTap,
//       contentPadding: EdgeInsets.only(bottom: 20.0),
//     );
//   }
// }
