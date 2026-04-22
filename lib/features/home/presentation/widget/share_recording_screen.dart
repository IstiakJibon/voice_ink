// lib/features/home/presentation/pages/share_recording_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class SharedUser {
  final String id;
  final String name;
  final String role;
  final String? initial;
  final bool isOwner;
  final bool isLink;

  const SharedUser({
    required this.id,
    required this.name,
    required this.role,
    this.initial,
    this.isOwner = false,
    this.isLink = false,
  });
}

class ShareRecordingScreen extends StatefulWidget {
  final String fileName;

  const ShareRecordingScreen({super.key, required this.fileName});

  @override
  State<ShareRecordingScreen> createState() => _ShareRecordingScreenState();
}

class _ShareRecordingScreenState extends State<ShareRecordingScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _selectedPermission = 'Can view';
  final String _shareLink = 'https://voiceink.app/s/file-26';

  final List<SharedUser> _sharedUsers = const [
    SharedUser(id: '1', name: 'You (Owner)', role: 'Owner', isOwner: true),
    SharedUser(
      id: '2',
      name: 'Anyone with the link',
      role: 'Can View',
      isLink: true,
    ),
    SharedUser(id: '3', name: 'Sarah John', role: 'Can View', initial: 'SJ'),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    // Invite people section
                    _buildInvitePeopleSection(),
                    24.verticalSpace,
                    // Copy link section
                    _buildCopyLinkSection(),
                    24.verticalSpace,
                    // Who has access section
                    _buildWhoHasAccessSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 59.h,
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
          // Title
          8.horizontalSpace,
          Center(
            child: Text(
              'Share Recording',
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
    );
  }

  Widget _buildInvitePeopleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share this recording with others or manage access',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff999999),
          ),
        ),

        25.verticalSpace,
        Text(
          'Invite people',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff333333),
          ),
        ),
        8.verticalSpace,
        // Email input and permission dropdown
        Row(
          children: [
            // Email input
            Expanded(
              child: TextFormField(
                controller: _emailController,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: const Color(0xff333333),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF2F2F7),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
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
                  hintText: 'Email address',
                  hintStyle: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff999999),
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            // Permission dropdown
            GestureDetector(
              onTap: () => _showPermissionPicker(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xff8C8C8C)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedPermission,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff333333),
                      ),
                    ),
                    8.horizontalSpace,
                    SvgPicture.asset(
                      AppAssets.chevronDown,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff333333),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        // Invite button
        GestureDetector(
          onTap: () {
            // TODO: Send invite
            if (_emailController.text.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Invitation sent to ${_emailController.text}',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: const Color(0xff333333),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
              _emailController.clear();
            }
          },
          child: Container(
            width: double.infinity,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xff4A59FE),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                'Invite',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyLinkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Copy Link',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff333333),
          ),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F7),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              // Link icon and URL
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.link,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff333333),
                        BlendMode.srcIn,
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        _shareLink,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff999999),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              16.horizontalSpace,
              // Copy button
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _shareLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Link copied to clipboard',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color(0xff333333),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Copy',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
              8.horizontalSpace,
              // Share icon
              GestureDetector(
                onTap: () {
                  // TODO: Native share
                },
                child: SvgPicture.asset(
                  AppAssets.shareIos,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff04071E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhoHasAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who has access',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff333333),
          ),
        ),
        8.verticalSpace,
        // Shared users list
        ...List.generate(_sharedUsers.length, (index) {
          return _buildSharedUserItem(_sharedUsers[index]);
        }),
      ],
    );
  }

  Widget _buildSharedUserItem(SharedUser user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xffECF4FE),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: user.initial != null
                  ? Text(
                      user.initial!,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        height: 22 / 17,
                        letterSpacing: -0.43,
                        color: const Color(0xff4A59FE),
                      ),
                    )
                  : SvgPicture.asset(
                      user.isLink ? AppAssets.shareIos : AppAssets.person,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff4A59FE),
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
          8.horizontalSpace,
          // Name and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff333333),
                  ),
                ),
                4.verticalSpace,
                Text(
                  user.role,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          // Permission or Owner label
          if (user.isOwner)
            Text(
              'Owner',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xffD9D9D9),
              ),
            )
          else
            GestureDetector(
              onTap: () => _showPermissionPickerForUser(user),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xff8C8C8C)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Can view',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff333333),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPermissionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPermissionOption('Can view'),
            _buildPermissionOption('Can edit'),
          ],
        ),
      ),
    );
  }

  void _showPermissionPickerForUser(SharedUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPermissionOption('Can view', forUser: true),
            _buildPermissionOption('Can edit', forUser: true),
            16.verticalSpace,
            // Remove access option
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // TODO: Remove access
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Center(
                  child: Text(
                    'Remove access',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xffFF383C),
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

  Widget _buildPermissionOption(String permission, {bool forUser = false}) {
    final isSelected = _selectedPermission == permission;

    return GestureDetector(
      onTap: () {
        if (!forUser) {
          setState(() {
            _selectedPermission = permission;
          });
        }
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              permission,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xff333333),
              ),
            ),
            if (isSelected && !forUser)
              SvgPicture.asset(
                AppAssets.checkmark,
                width: 20.w,
                height: 20.h,
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
