// lib/features/notes/presentation/pages/note_text_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/notes/presentation/widget/ai_assistant_popup.dart';
import 'package:voice_ink/features/notes/presentation/widget/ai_chat_bottom_sheet.dart';

class NoteTextEditorScreen extends StatefulWidget {
  final String noteId;
  final String noteTitle;

  const NoteTextEditorScreen({
    super.key,
    required this.noteId,
    this.noteTitle = 'Untitled',
  });

  @override
  State<NoteTextEditorScreen> createState() => _NoteTextEditorScreenState();
}

class _NoteTextEditorScreenState extends State<NoteTextEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final GlobalKey _aiAssistantButtonKey = GlobalKey();
  bool _isSaving = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteTitle);
    _contentController = TextEditingController();

    // Simulate saving
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),
                8.verticalSpace,
                // Toolbar buttons
                _buildToolbarButtons(),
                8.verticalSpace,
                // Title input
                _buildTitleInput(),
                // Content
                Expanded(child: _buildContent()),
              ],
            ),
            // AI Chat FAB
            _buildAIChatFAB(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.backButton,
                  width: 32.w,
                  height: 32.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff04071E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          // Title and saving status
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Expanded(
                  child: Center(
                    child: Text(
                      widget.noteTitle,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        height: 22 / 17,
                        letterSpacing: -0.43,
                        color: const Color.fromRGBO(60, 60, 67, 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Saving status
                Row(
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: const BoxDecoration(
                        color: Color(0xff34C759),
                        shape: BoxShape.circle,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      _isSaving ? 'Saving...' : 'Saved',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color.fromRGBO(60, 60, 67, 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


// Update _buildToolbarButtons to add key to AI Assistant button
Widget _buildToolbarButtons() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      children: [
        // Dictate button
        Expanded(
          child: _buildToolbarButton(
            icon: AppAssets.mic,
            label: 'Dictate',
            iconColor: const Color(0xff4A59FE),
            textColor: const Color(0xff4A59FE),
            onTap: () {
              // TODO: Start dictation
            },
          ),
        ),
        8.horizontalSpace,
        // AI Assistant button
        Expanded(
          child: GestureDetector(
            key: _aiAssistantButtonKey,
            onTap: () {
              AIAssistantPopup.show(
                context,
                _aiAssistantButtonKey,
                selectedCharCount: 96, // TODO: Get actual selected text length
                onPolish: () {
                  // TODO: Polish text
                },
                onFormat: () {
                  // TODO: Format text
                },
                onSummarize: () {
                  // TODO: Summarize text
                },
              );
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffF2F2F7)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.sparkle,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff9747FF),
                      BlendMode.srcIn,
                    ),
                  ),
                  3.horizontalSpace,
                  Text(
                    'AI Assistant',
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
            ),
          ),
        ),
        8.horizontalSpace,
        // Share button
        _buildIconButton(
          icon: AppAssets.shareIos,
          onTap: () {
            // TODO: Share
          },
        ),
        8.horizontalSpace,
        // Download button
        _buildIconButton(
          icon: AppAssets.arrowDownload,
          onTap: () {
            // TODO: Download
          },
        ),
      ],
    ),
  );
}
  Widget _buildToolbarButton({
    required String icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        width: 129.w,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            3.horizontalSpace,
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff000000),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffF2F2F7))),
      ),
      child: TextField(
        controller: _titleController,
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 17.sp,
          height: 22 / 17,
          letterSpacing: -0.43,
          color: const Color(0xff000000),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Untitled',
          hintStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff000000),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        ),
      ),
    );
  }

Widget _buildContent() {
  return SelectionArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intro paragraph
          _buildIntroSection(),
          31.verticalSpace,
          // Live Dictation section
          _buildFeatureSection(
            icon: AppAssets.mic,
            title: 'Live Dictation',
            description:
                'Click the Dictate button in the toolbar to transcribe your voice in real-time. Perfect for quick notes, meeting minutes, or brainstorming sessions.',
          ),
          31.verticalSpace,
          // Upload & Organize section
          _buildFeatureSection(
            icon: AppAssets.folder,
            title: 'Upload & Organize',
            description:
                'Upload documents, images, or entire folders to create structured notes. Great for:\n• Book drafts and manuscripts\n• Research papers and documentation\n• Project notes and planning',
          ),
          31.verticalSpace,
          // Share Your Work section
          _buildFeatureSection(
            icon: AppAssets.link,
            title: 'Share Your Work',
            description:
                'Generate shareable links with one click. Share your notes with colleagues, friends, or the world - with optional password protection.',
          ),
          31.verticalSpace,
          // Nested Notes section
          _buildFeatureSection(
            icon: AppAssets.layer,
            title: 'Nested Notes',
            description:
                'Create child notes to build hierarchical structures. Perfect for organizing complex projects or creating outlines.',
          ),
          31.verticalSpace,
          // Quick Tips section
          _buildFeatureSection(
            icon: AppAssets.lightbulb,
            title: 'Quick Tips',
            description:
                '• Type / for commands and formatting options\n• Use Ctrl/Cmd + B for bold, Ctrl/Cmd + I for italic\n• Click the emoji icon to add personality to your notes 🎨\n• Pin important notes to keep them at the top',
          ),
          40.verticalSpace,
          // Footer text
          Text(
            'Start typing to replace this content and create your first note...',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              height: 21 / 16,
              letterSpacing: -0.31,
              color: const Color(0xff000000),
            ),
          ),
          100.verticalSpace, // Space for FAB
        ],
      ),
    ),);
  }

Widget _buildIntroSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Regular text (selectable via parent SelectionArea)
      Text(
        'Start capturing your thoughts, ideas, and knowledge in one place. Here\'s what you can do:',
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          height: 21 / 16,
          letterSpacing: -0.31,
          color: const Color(0xff000000),
        ),
      ),
      30.verticalSpace,
      // Divider
      Container(height: 1, color: const Color(0xffF2F2F7)),
    ],
  );
}

  Widget _buildFeatureSection({
    required String icon,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff04071E),
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        // Description
        Text(
          description,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
        ),
      ],
    );
  }

  Widget _buildAIChatFAB() {
    return Positioned(
      right: 16.w,
      bottom: 40.h,
      child: GestureDetector(
        onTap: () {
          AIChatBottomSheet.show(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xff4A59FE),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.chat,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
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
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
