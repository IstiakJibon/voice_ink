// lib/features/notes/presentation/widget/ai_chat_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class AIChatBottomSheet extends StatefulWidget {
  const AIChatBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => const AIChatBottomSheet(),
      ),
    );
  }

  @override
  State<AIChatBottomSheet> createState() => _AIChatBottomSheetState();
}

class _AIChatBottomSheetState extends State<AIChatBottomSheet> {
  final TextEditingController _messageController = TextEditingController();

  final List<String> _quickSuggestions = [
    'Summarize the main points',
    'What are the key takeaways?',
    'List any action items mentioned',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 75,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Grabber
          _buildGrabber(),
          // Toolbar
          _buildToolbar(),
          // Empty state
          Expanded(
            child: _buildEmptyState(),
          ),
          // Quick suggestions
          _buildQuickSuggestions(),
          // Input field
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildGrabber() {
    return Container(
      padding: EdgeInsets.only(top: 5.h),
      child: Container(
        width: 50.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: const Color(0xffCFCFCF),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // AI Chat label
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.chat,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff9747FF),
                  BlendMode.srcIn,
                ),
              ),
              4.horizontalSpace,
              Text(
                'AI CHAT',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: const Color(0xff9747FF),
                ),
              ),
            ],
          ),
          // Clear and Hide Chat buttons
          Row(
            children: [
              // Clear button
              GestureDetector(
                onTap: () {
                  // TODO: Clear chat
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.dismiss,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff000000),
                        BlendMode.srcIn,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      'Clear',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              // Hide Chat button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.chat,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff000000),
                        BlendMode.srcIn,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      'Hide Chat',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Chat icon container
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: const Color(0xff9747FF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.chat,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff9747FF),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        16.verticalSpace,
        // Text
        Text(
          'Start a conversation about your note',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickSuggestions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Quick suggestions',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              height: 20 / 15,
              letterSpacing: -0.23,
              color: const Color.fromRGBO(60, 60, 67, 0.6),
            ),
          ),
          16.verticalSpace,
          // Suggestion chips
          ...List.generate(_quickSuggestions.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _buildSuggestionChip(_quickSuggestions[index]),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        // TODO: Send message
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff000000),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h, right: 8.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff9747FF),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            // Text input
            Expanded(
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: const Color(0xff000000),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ask anything about your note...',
                  hintStyle: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff4A59FE),
                  ),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                maxLines: 2,
                minLines: 1,
              ),
            ),
            8.horizontalSpace,
            // Send button
            GestureDetector(
              onTap: () {
                // TODO: Send message
                if (_messageController.text.isNotEmpty) {
                  // Send message logic
                }
              },
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xff9747FF),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -1.5708, // -90 degrees in radians
                    child: SvgPicture.asset(
                      AppAssets.send,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}