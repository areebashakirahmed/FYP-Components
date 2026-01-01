// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:glass_kit/glass_kit.dart';
// import 'package:mehfilista/components/custom_drawer.dart';
// import 'package:mehfilista/features/dashboard/dashboard_screen.dart';
// import 'package:mehfilista/features/groups/group_screen.dart';
// import 'package:mehfilista/features/library/library_screen.dart';
// import 'package:mehfilista/features/profile/profile_screen.dart';
// import 'package:mehfilista/features/record_video/record_video_screen.dart';
// import 'package:mehfilista/utils/constants/colors.dart';

// class CustomNavbarScreen extends StatefulWidget {
//   const CustomNavbarScreen({Key? key}) : super(key: key);

//   @override
//   _CustomNavbarScreenState createState() => _CustomNavbarScreenState();
// }

// class _CustomNavbarScreenState extends State<CustomNavbarScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _selectedIndex = 0;
//   bool _showPopup = false;

//   late final List<Widget> _screens;

//   @override
//   void initState() {
//     super.initState();
//     _screens = [
//       DashboardScreen(onDrawerTap: _openDrawer),
//       LibraryScreen(),
//       GroupScreen(),
//       ProfileScreen(),
//     ];
//   }

//   void _openDrawer() {
//     _scaffoldKey.currentState?.openDrawer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       extendBody: true,
//       drawer: CustomDrawer(),
//       body: Stack(
//         children: [
//           // Active screen
//           _screens[_selectedIndex],

//           // Custom navbar
//           Positioned(
//             left: 20.sp,
//             right: 20.sp,
//             bottom: 40.h,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 70.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100.sp),
//                       color: Colors.transparent,
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(100.sp),
//                       child: BackdropFilter(
//                         filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.black.withOpacity(0.2),
//                                 AppColors.black.withOpacity(0.2),
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               _buildNavItem("assets/svgs/1.svg", 0),
//                               _buildNavItem("assets/svgs/2.svg", 1),
//                               _buildNavItem("assets/svgs/3.svg", 2),
//                               _buildNavItem("assets/svgs/4.svg", 3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 10.sp),
//                   child: GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         fullscreenDialog: true,
//                         builder: (context) => _buildPopupMenu(context),
//                       ).then((_) => setState(() => _showPopup = false));
//                       setState(() => _showPopup = true);
//                     },
//                     child: Container(
//                       width: 60.sp,
//                       height: 60.sp,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xffCC1E27), Color(0xff801318)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 10,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Icon(Icons.add, color: Colors.white, size: 40),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(String icon, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() => _selectedIndex = index);
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.all(18.sp),
//         decoration: BoxDecoration(
//           color: _selectedIndex == index
//               ? Colors.red.withOpacity(0.7)
//               : Colors.grey.withOpacity(0.1),
//           gradient: _selectedIndex == index
//               ? LinearGradient(
//                   colors: [Color(0xffCC1E27), Color(0xff801318)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//               : null,
//           shape: BoxShape.circle,
//         ),
//         child: SvgPicture.asset(icon, width: 25.sp),
//       ),
//     );
//   }

//   Widget _buildPopupMenu(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {}, // Prevent background taps from closing the dialog
//         child: Stack(
//           children: [
//             // Position the menu above the navbar button
//             Positioned(
//               bottom: 60.h, // Position above the navbar
//               right: 20.w,
//               child: Container(
//                 width: 230.w,
//                 constraints: BoxConstraints(maxHeight: 150.h, maxWidth: 230.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.sp),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: GlassContainer.clearGlass(
//                     blur: 5.sp,
//                     color: AppColors.grey.withOpacity(0.3),
//                     borderColor: Colors.transparent,
//                     borderRadius: BorderRadius.circular(16.sp),
//                     child: Container(
//                       padding: EdgeInsets.all(10.sp),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16.sp),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               Navigator.of(context, rootNavigator: true).pop();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => RecordVideoScreen(),
//                                 ),
//                               );
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.all(8.sp),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.fiber_manual_record_outlined,
//                                     color: AppColors.white,
//                                     size: 20.sp,
//                                   ),
//                                   SizedBox(width: 8.w),
//                                   Text(
//                                     'Record Video',
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w400,
//                                       letterSpacing: -0.25.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               Navigator.of(context, rootNavigator: true).pop();
//                               // Handle upload file
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.all(8.sp),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.file_upload_outlined,
//                                     color: AppColors.white,
//                                     size: 20.sp,
//                                   ),
//                                   SizedBox(width: 8.w),
//                                   Text(
//                                     'Upload from gallery',
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w400,
//                                       letterSpacing: -0.25.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               Navigator.of(context, rootNavigator: true).pop();
//                               // Handle create new folder
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.all(8.sp),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.folder_open,
//                                     color: AppColors.white,
//                                     size: 20.sp,
//                                   ),
//                                   SizedBox(width: 8.w),
//                                   Text(
//                                     'Create new folder',
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w400,
//                                       letterSpacing: -0.25.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
