import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/files/presentation/pages/files_screen.dart';
import 'package:voice_ink/features/home/presentation/pages/home_screen.dart';
import 'package:voice_ink/features/notes/presentation/pages/notes_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/settings_screen.dart';

class HomeNavbar extends StatefulWidget {
  const HomeNavbar({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<HomeNavbar> createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {
  late int currentTab;
  late PageController pageController;

  final List<Widget> screens = const [
    HomeScreen(),
    FilesScreen(),
    NotesScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentTab = widget.initialIndex;
    pageController = PageController(initialPage: currentTab);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentTab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && currentTab != 0) {
          setState(() => currentTab = 0);
          pageController.jumpToPage(0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          backgroundColor: Colors.white,
          iconSize: 24.h,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color(0xff6B7280),
          selectedItemColor: const Color(0xff6366F1), // your primary color
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12.h,
          ),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.h,
          ),
          onTap: (index) {
            setState(() => currentTab = index);
            pageController.jumpToPage(index);
          },
          items: [
            _buildNavItem(
              icon: AppAssets.home,
              activeIcon: AppAssets.homeS,
              label: "Home",
            ),
            _buildNavItem(
              icon: AppAssets.folder,
              activeIcon: AppAssets.folderS,
              label: "Files",
            ),
            _buildNavItem(
              icon: AppAssets.note,
              activeIcon: AppAssets.noteS,
              label: "Notes",
            ),
            _buildNavItem(
              icon: AppAssets.settings,
              activeIcon: AppAssets.settingsS,
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String icon,
    required String activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(icon, height: 24.h),
      activeIcon: SvgPicture.asset(activeIcon, height: 24.h),
      label: label,
    );
  }
}