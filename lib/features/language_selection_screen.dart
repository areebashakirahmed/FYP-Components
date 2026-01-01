// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mehfilista/components/custom_button.dart';
// import 'package:mehfilista/features/onboarding/views/onboarding_screen.dart';
// import 'package:mehfilista/services/local_provider.dart';
// import 'package:mehfilista/utils/constants/colors.dart';
// import 'package:mehfilista/utils/helpers/localization_extension.dart';
// import 'package:provider/provider.dart';

// class LanguageSelectionScreen extends StatelessWidget {
//   const LanguageSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final langProvider = Provider.of<LocaleProvider>(context);
//     final currentLocale = langProvider.locale;

//     return Scaffold(
//       // appBar: AppBar(title: Text(context.loc.welcome)),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               SizedBox(height: 60.h),
//               Text(
//                 context.loc.chooselanguage,
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                 ),
//               ),
//               SizedBox(height: 30.h),

//               _buildLangCard(
//                 context,
//                 langProvider,
//                 locale: const Locale('en'),
//                 title: "English",
//                 subtitle: "Tap to switch",
//                 isSelected: currentLocale.languageCode == 'en',
//               ),
//               const SizedBox(height: 16),
//               _buildLangCard(
//                 context,
//                 langProvider,
//                 locale: const Locale('fr'),
//                 title: "Français",
//                 subtitle: "Appuyez pour changer",
//                 isSelected: currentLocale.languageCode == 'fr',
//               ),

//               SizedBox(height: 32),
//               CustomButton(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//                   );
//                 },
//                 btnText: context.loc.getstarted,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLangCard(
//     BuildContext context,
//     LocaleProvider provider, {
//     required Locale locale,
//     required String title,
//     required String subtitle,
//     required bool isSelected,
//   }) {
//     return GestureDetector(
//       onTap: () => provider.setLocale(locale),
//       child: Card(
//         color: AppColors.primary.withOpacity(0.2),

//         elevation: isSelected ? 0 : 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: BorderSide(
//             color: isSelected ? AppColors.primary : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: ListTile(
//           title: Text(title, style: const TextStyle(fontSize: 18)),
//           subtitle: Text(subtitle),
//           trailing: isSelected
//               ? const Icon(Icons.check_circle, color: AppColors.primary)
//               : null,
//         ),
//       ),
//     );
//   }
// }
