import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

enum SortOption { name, date, duration }

class SortOptionsPopup extends StatelessWidget {
  final SortOption selectedOption;
  final Function(SortOption) onOptionSelected;

  const SortOptionsPopup({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  static void show(
    BuildContext context,
    GlobalKey buttonKey, {
    required SortOption selectedOption,
    required Function(SortOption) onOptionSelected,
  }) {
    final RenderBox? button =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    final Offset position = button.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          // Invisible barrier to detect taps outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            right: 16.w,
            top: position.dy + button.size.height + 8.h,
            child: SortOptionsPopup(
              selectedOption: selectedOption,
              onOptionSelected: (option) {
                onOptionSelected(option);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 220.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 13,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 24,
              offset: const Offset(0, 24),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 33,
              offset: const Offset(0, 55),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            // Divider
            Container(height: 1, color: const Color(0xffF2F2F7)),
            8.verticalSpace,
            // Sort by Name
            _buildSortOption(label: 'Sort by Name', option: SortOption.name),
            // Sort by Date
            _buildSortOption(label: 'Sort by Date', option: SortOption.date),
            // Sort by Duration
            _buildSortOption(
              label: 'Sort by Duration',
              option: SortOption.duration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(8.w),
      alignment: Alignment.centerLeft,
      child: Text(
        'SORT OPTIONS',
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          height: 21 / 16,
          letterSpacing: -0.31,
          color: const Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildSortOption({required String label, required SortOption option}) {
    final isSelected = selectedOption == option;

    return GestureDetector(
      onTap: () => onOptionSelected(option),
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
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: const Color(0xff333333),
              ),
            ),
            if (isSelected)
              SvgPicture.asset(
                AppAssets.checkmark,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff4A59FE),
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }
}