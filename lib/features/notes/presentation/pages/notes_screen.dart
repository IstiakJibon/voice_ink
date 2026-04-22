// lib/features/notes/presentation/pages/notes_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/notes/presentation/pages/note_text_editor_screen.dart';
import 'package:voice_ink/features/notes/presentation/widget/note_options_popup.dart';
import 'package:voice_ink/features/notes/presentation/widget/upload_document_dialog.dart';

class NoteItem {
  final String id;
  final String title;
  final String timeAgo;
  final bool hasChildren;
  final bool isChild;
  final List<NoteItem>? children;

  const NoteItem({
    required this.id,
    required this.title,
    required this.timeAgo,
    this.hasChildren = false,
    this.isChild = false,
    this.children,
  });
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Demo notes data
  final Map<String, List<NoteItem>> _notesByDate = {
    'TODAY': [
      const NoteItem(id: '1', title: 'Untitled', timeAgo: '2 hours ago'),
      NoteItem(
        id: '2',
        title: 'Untitled',
        timeAgo: '2 hours ago',
        hasChildren: true,
        children: [
          const NoteItem(
            id: '2-1',
            title: 'Untitled Child',
            timeAgo: '2 hours ago',
            isChild: true,
          ),
        ],
      ),
    ],
    'YESTERDAY': [
      const NoteItem(id: '3', title: 'Untitled', timeAgo: '2 hours ago'),
    ],
    'OLDER': [
      const NoteItem(id: '4', title: 'Untitled', timeAgo: '2 hours ago'),
      const NoteItem(id: '5', title: 'Untitled', timeAgo: '2 hours ago'),
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              // Header
              _buildHeader(),
              24.verticalSpace,
              // Search bar
              _buildSearchBar(),
              24.verticalSpace,
              // Start Capturing section
              _buildStartCapturingSection(),
              48.verticalSpace,
              // All Notes section
              _buildAllNotesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            height: 25 / 20,
            letterSpacing: -0.45,
            color: const Color(0xff000000),
          ),
        ),
        // Placeholder for potential action buttons (hidden in design)
        SizedBox(width: 88.w),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      controller: _searchController,
      style: GoogleFonts.dmSans(
        fontWeight: FontWeight.w400,
        fontSize: 17.sp,
        height: 22 / 17,
        letterSpacing: -0.43,
        color: const Color(0xff333333),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF2F2F7),
        contentPadding: EdgeInsets.all(11.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        hintText: 'Search',
        hintStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          fontSize: 17.sp,
          height: 22 / 17,
          letterSpacing: -0.43,
          color: const Color(0xff999999),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 11.w, right: 8.w),
          child: SvgPicture.asset(
            AppAssets.search,
            width: 21.w,
            height: 22.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff999999),
              BlendMode.srcIn,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 21.w, minHeight: 22.h),
      ),
    );
  }

  Widget _buildStartCapturingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and subtitle
        Text(
          'Start Capturing',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            height: 18 / 16,
            letterSpacing: -0.08,
            color: const Color(0xff000000),
          ),
        ),
        8.verticalSpace,
        Text(
          'Choose how you\'d like to create your first note',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff999999),
          ),
        ),
        24.verticalSpace,
        // Action cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionCard(
              icon: AppAssets.scratchpad,
              label: 'Dictate',
              onTap: () {
                // TODO: Open dictate
              },
            ),
            _buildActionCard(
              icon: AppAssets.cloudUpload,
              label: 'Upload',
              onTap: () {
                UploadDocumentDialog.show(
                  context,
                  onTapBrowse: () {
                    // TODO: Open file picker
                  },
                );
              },
            ),
            _buildActionCard(
              icon: AppAssets.noteD,
              label: 'New note',
              onTap: () {
                // TODO: Create new note
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 118.w,
        height: 118.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xffECF4FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff4A59FE),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.verticalSpace,
            // Label
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Notes',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 18 / 16,
                letterSpacing: -0.08,
                color: const Color(0xff000000),
              ),
            ),
            // Sort button
            GestureDetector(
              onTap: () {
                // TODO: Show sort options
              },
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffF2F2F7)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.textSort,
                    width: 20.w,
                    height: 20.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff999999),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        // Notes grouped by date
        ..._notesByDate.entries.map((entry) {
          return _buildDateGroup(entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildDateGroup(String dateLabel, List<NoteItem> notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssets.calendar,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  const Color(0xff3C3C43).withOpacity(0.6),
                  BlendMode.srcIn,
                ),
              ),
              8.horizontalSpace,
              Text(
                dateLabel,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  height: 18 / 16,
                  letterSpacing: -0.08,
                  color: const Color(0xff8C8C8C),
                ),
              ),
            ],
          ),
        ),
        8.verticalSpace,
        // Notes list
        ...notes.map(
          (note) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildNoteCard(note),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }


Widget _buildNoteCard(NoteItem note) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteTextEditorScreen(
            noteId: note.id,
            noteTitle: note.title,
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          // Main note row
          _buildNoteRow(note),
          // Children notes (if any)
          if (note.hasChildren && note.children != null) ...[
            16.verticalSpace,
            ...note.children!.map((child) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _buildChildNoteRow(child),
                )),
          ],
        ],
      ),
    ),
  );
}

  // Update _buildNoteRow in notes_screen.dart

  Widget _buildNoteRow(NoteItem note) {
    final GlobalKey moreButtonKey = GlobalKey();

    return Column(
      children: [
        // Title row
        Row(
          children: [
            // Chevron (for expandable notes)
            if (note.hasChildren) ...[
              SvgPicture.asset(
                AppAssets.chevronDown,
                width: 16.w,
                height: 16.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff8C8C8C),
                  BlendMode.srcIn,
                ),
              ),
              8.horizontalSpace,
            ],
            // Document icon
            SvgPicture.asset(
              AppAssets.documentText,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff8C8C8C),
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            // Title
            Expanded(
              child: Text(
                note.title,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            // More button
            GestureDetector(
              key: moreButtonKey,
              onTap: () {
                NoteOptionsPopup.show(
                  context,
                  moreButtonKey,
                  onAddChildNote: () {
                    // TODO: Add child note
                  },
                  onDuplicate: () {
                    // TODO: Duplicate note
                  },
                  onPin: () {
                    // TODO: Pin note
                  },
                  onDelete: () {
                    // TODO: Delete note
                  },
                );
              },
              child: SvgPicture.asset(
                AppAssets.more,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff1E222B),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        // Time row
        Row(
          children: [
            SvgPicture.asset(
              AppAssets.clock,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff8E8E93),
                BlendMode.srcIn,
              ),
            ),
            6.horizontalSpace,
            Text(
              note.timeAgo,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                height: 18 / 13,
                letterSpacing: -0.08,
                color: const Color(0xff333333),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChildNoteRow(NoteItem note) {
    return Padding(
      padding: EdgeInsets.only(left: 32.w),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              // Document icon
              SvgPicture.asset(
                AppAssets.documentText,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff8C8C8C),
                  BlendMode.srcIn,
                ),
              ),
              8.horizontalSpace,
              // Title
              Expanded(
                child: Text(
                  note.title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 21 / 16,
                    letterSpacing: -0.31,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          // Time row
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.clock,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff8E8E93),
                  BlendMode.srcIn,
                ),
              ),
              6.horizontalSpace,
              Text(
                note.timeAgo,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  height: 18 / 13,
                  letterSpacing: -0.08,
                  color: const Color(0xff333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
