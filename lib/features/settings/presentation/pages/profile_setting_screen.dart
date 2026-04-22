import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  // Sample user data - replace with actual data
  String _userName = 'Eyosiyas Ketema';
  String _userEmail = 'eyosiyasketema@gmail.com';
  String _userPhone = '+1234567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,
                    // Profile picture section
                    _buildProfilePicture(),
                    48.verticalSpace,
                    // User info card
                    _buildUserInfoCard(),
                    24.verticalSpace,
                    // Preferences section
                    _buildPreferencesSection(),
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
            // Save button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 54.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
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
            // Title
            Text(
              'Profile Setting',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
            ),
            // Spacer for alignment
            SizedBox(width: 32.w),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: SizedBox(
        width: 104.w,
        height: 100.h,
        child: Stack(
          children: [
            // Profile image
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffD9D9D9),
                image: DecorationImage(
                  image: AssetImage(AppAssets.user),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Camera button
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  // TODO: Handle change profile picture
                },
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff4A59FE),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.camera,
                      width: 20.w,
                      height: 20.h,
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

  Widget _buildUserInfoCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Name row
          _buildInfoRow(
            value: _userName,
            showBorder: true,
            isEditable: true,
            onEdit: () => _showEditDialog('Name', _userName, (newValue) {
              setState(() => _userName = newValue);
            }),
          ),
          // Email row
          _buildInfoRow(value: _userEmail, showBorder: true, isEditable: false),
          // Phone row
          _buildInfoRow(
            value: _userPhone,
            showBorder: false,
            isEditable: true,
            onEdit: () => _showEditDialog('Phone', _userPhone, (newValue) {
              setState(() => _userPhone = newValue);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String value,
    required bool showBorder,
    required bool isEditable,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(bottom: BorderSide(color: Color(0xffF2F2F7)))
            : null,
      ),
      child: Row(
        children: [
          // Value
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
            ),
          ),
          // Edit icon
          GestureDetector(
            onTap: isEditable ? onEdit : null,
            child: SizedBox(
              width: 44.w,
              height: 44.h,
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.edit,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    isEditable
                        ? const Color(0xff404040)
                        : const Color(0xffD9D9D9),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'Preferences',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        // Preferences card
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF2F2F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              // Email notifications
              _buildToggleRow(
                title: 'Email notifications',
                value: _emailNotifications,
                showBorder: true,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                },
              ),
              // Push notifications
              _buildToggleRow(
                title: 'Push notifications',
                value: _pushNotifications,
                showBorder: false,
                onChanged: (value) {
                  setState(() => _pushNotifications = value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String title,
    required bool value,
    required bool showBorder,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(bottom: BorderSide(color: Color(0xffF2F2F7)))
            : null,
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
            ),
          ),
          // Custom toggle switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: value
                    ? const Color(0xff4A59FE)
                    : const Color(0xffE9E9EB),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  width: 39.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            // TODO: Handle save changes
            Navigator.pop(context);
          },
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xff4A59FE),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                'Save Changes',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    String field,
    String currentValue,
    ValueChanged<String> onSave,
  ) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Edit $field',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
            color: const Color(0xff000000),
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.dmSans(
            fontSize: 16.sp,
            color: const Color(0xff000000),
          ),
          decoration: InputDecoration(
            hintText: 'Enter $field',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 16.sp,
              color: const Color(0xff999999),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xffF2F2F7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xffF2F2F7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xff4A59FE)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                color: const Color(0xff999999),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                color: const Color(0xff4A59FE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
