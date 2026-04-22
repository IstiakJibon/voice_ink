
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class LanguageOption {
  final String code;
  final String name;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}

class LanguagePopup extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguagePopup({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  static const List<LanguageOption> languages = [
    LanguageOption(code: 'en', name: 'English', flag: AppAssets.flagUs),
    LanguageOption(code: 'fr', name: 'François', flag: AppAssets.flagFr),
    LanguageOption(code: 'pt', name: 'Portugues', flag: AppAssets.flagPt),
    LanguageOption(code: 'de', name: 'Deutsch', flag: AppAssets.flagDe),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(top: 100.h, right: 16.w),
      alignment: Alignment.topRight,
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 6),
              blurRadius: 13,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
            BoxShadow(
              offset: Offset(0, 24),
              blurRadius: 24,
              color: Color.fromRGBO(0, 0, 0, 0.09),
            ),
            BoxShadow(
              offset: Offset(0, 55),
              blurRadius: 33,
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
            BoxShadow(
              offset: Offset(0, 97),
              blurRadius: 39,
              color: Color.fromRGBO(0, 0, 0, 0.01),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              8.verticalSpace,
              Container(height: 1, color: const Color(0xffF2F2F7)),
              8.verticalSpace,
              ...languages.map((lang) => _buildLanguageOption(context, lang)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.globe,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff333333),
              BlendMode.srcIn,
            ),
          ),
          8.horizontalSpace,
          Text(
            'Select Language',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              height: 21 / 16,
              letterSpacing: -0.31,
              color: const Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, LanguageOption language) {
    final isSelected = selectedLanguage == language.code;

    return GestureDetector(
      onTap: () {
        onLanguageSelected(language.code);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff4A59FE).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(language.flag, width: 24.w, height: 24.h),
                8.horizontalSpace,
                Text(
                  language.name,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    height: 21 / 16,
                    letterSpacing: -0.31,
                    color: isSelected
                        ? const Color(0xff4A59FE)
                        : const Color(0xff333333),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (isSelected)
                  SvgPicture.asset(
                    AppAssets.checkmark,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff4A59FE),
                      BlendMode.srcIn,
                    ),
                  )
                else
                  SizedBox(width: 24.w),
                8.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff4A59FE)
                        : const Color(0xff787878).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    language.code.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff333333),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
