import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // File Type
  int _selectedFileTypeIndex = 0;
  final List<String> _fileTypes = ['Audio', 'PDF', 'Docs', 'Video'];

  // Tags
  List<int> _selectedTagIndices = [5]; // "Personal" selected by default
  final List<String> _tags = [
    'Meetings',
    'Interviews',
    'Ideas',
    'Important',
    'Shared',
    'Personal',
  ];

  // Date Range
  DateTime? _fromDate;
  DateTime? _toDate;

  // Duration
  double _minDuration = 0;
  double _maxDuration = 60;
  RangeValues _durationRange = const RangeValues(5, 30);

  // Starred only
  bool _starredOnly = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(38.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 75,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toolbar
          _buildToolbar(),
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // File Type
                _buildFileTypeSection(),
                // Tags
                _buildTagsSection(),
                // Date Range
                _buildDateRangeSection(),
                // Duration
                _buildDurationSection(),
                // Starred Only
                _buildStarredOnlySection(),
                // Apply Button
                _buildApplyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xffF2F2F7), width: 1),
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(38.r)),
      ),
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          // Grabber
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Container(
              width: 36.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xffCFCFCF),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
          16.verticalSpace,
          // Title and Close button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 44.h,
              child: Row(
                children: [
                  // Spacer for centering
                  SizedBox(width: 44.w),
                  // Title
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Filter & Sort',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            height: 25 / 20,
                            letterSpacing: -0.45,
                            color: const Color(0xff333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(120, 120, 128, 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 20.w,
                          color: const Color(0xff999999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTypeSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FILE TYPE',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: const Color(0xff8C8C8C),
            ),
          ),
          8.verticalSpace,
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: List.generate(_fileTypes.length, (index) {
              final isSelected = _selectedFileTypeIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFileTypeIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff4A59FE) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xff4A59FE)
                          : const Color(0xffF2F2F7),
                    ),
                    borderRadius: BorderRadius.circular(1000.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffC9C9C9).withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _fileTypes[index],
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TAGS',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: const Color(0xff8C8C8C),
            ),
          ),
          8.verticalSpace,
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: List.generate(_tags.length, (index) {
              final isSelected = _selectedTagIndices.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTagIndices.remove(index);
                    } else {
                      _selectedTagIndices.add(index);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff4A59FE) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xff4A59FE)
                          : const Color(0xffF2F2F7),
                    ),
                    borderRadius: BorderRadius.circular(1000.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffC9C9C9).withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _tags[index],
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATE RANGE',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: const Color(0xff8C8C8C),
            ),
          ),
          8.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                // From
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: Colors.black,
                        ),
                      ),
                      8.verticalSpace,
                      GestureDetector(
                        onTap: () => _selectDate(true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF2F2F7)),
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _fromDate != null
                                    ? _formatDate(_fromDate!)
                                    : 'Select date',
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  height: 20 / 15,
                                  letterSpacing: -0.23,
                                  color: const Color(0xff8C8C8C),
                                ),
                              ),
                              8.horizontalSpace,
                              SvgPicture.asset(
                                AppAssets.calendar,
                                width: 24.w,
                                height: 24.h,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xff04071E),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: SvgPicture.asset(
                    AppAssets.arrowRight,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff8C8C8C),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                // To
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: Colors.black,
                        ),
                      ),
                      8.verticalSpace,
                      GestureDetector(
                        onTap: () => _selectDate(false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF2F2F7)),
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _toDate != null
                                    ? _formatDate(_toDate!)
                                    : 'Select date',
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  height: 20 / 15,
                                  letterSpacing: -0.23,
                                  color: const Color(0xff8C8C8C),
                                ),
                              ),
                              8.horizontalSpace,
                              SvgPicture.asset(
                                AppAssets.calendar,
                                width: 24.w,
                                height: 24.h,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xff04071E),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DURATION',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: const Color(0xff8C8C8C),
            ),
          ),
          8.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                // Min/Max buttons
                Row(
                  children: [
                    // Min
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xffF2F2F7)),
                          borderRadius: BorderRadius.circular(1000.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffC9C9C9).withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Min',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                height: 20 / 15,
                                letterSpacing: -0.23,
                                color: const Color(0xff8C8C8C),
                              ),
                            ),
                            4.horizontalSpace,
                            Text(
                              '${_durationRange.start.toInt()}',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                height: 20 / 15,
                                letterSpacing: -0.23,
                                color: Colors.black,
                              ),
                            ),
                            4.horizontalSpace,
                            Text(
                              'min',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                height: 20 / 15,
                                letterSpacing: -0.23,
                                color: const Color(0xff8C8C8C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Dash
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Container(
                        width: 12.w,
                        height: 2.h,
                        color: const Color(0xff404040),
                      ),
                    ),
                    // Max
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xff4A59FE)),
                          borderRadius: BorderRadius.circular(1000.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffC9C9C9).withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Max',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                height: 20 / 15,
                                letterSpacing: -0.23,
                                color: const Color(0xff8C8C8C),
                              ),
                            ),
                            4.horizontalSpace,
                            Text(
                              '${_durationRange.end.toInt()}',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                height: 20 / 15,
                                letterSpacing: -0.23,
                                color: Colors.black,
                              ),
                            ),
                            4.horizontalSpace,
                            Text(
                              'min',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                height: 20 / 15,
                                letterSpacing: -0.23,
                                color: const Color(0xff8C8C8C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                // Slider
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 12.h,
                    activeTrackColor: const Color(0xff4A59FE),
                    inactiveTrackColor: Colors.white,
                    thumbColor: Colors.white,
                    overlayColor: const Color(0xff4A59FE).withOpacity(0.1),
                    thumbShape: _CustomThumbShape(),
                    rangeThumbShape: _CustomRangeThumbShape(),
                    trackShape: _CustomTrackShape(),
                  ),
                  child: RangeSlider(
                    values: _durationRange,
                    min: _minDuration,
                    max: _maxDuration,
                    onChanged: (values) {
                      setState(() {
                        _durationRange = values;
                      });
                    },
                  ),
                ),
                8.verticalSpace,
                // Duration labels
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '0 Min',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff8C8C8C),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '30 Min',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff8C8C8C),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '60 Min',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff8C8C8C),
                        ),
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

  Widget _buildStarredOnlySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F7),
          borderRadius: BorderRadius.circular(1000.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Star icon
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFDC50),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.star,
                    ),
                  ),
                ),
                16.horizontalSpace,
                Text(
                  'Favorites Only',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  _starredOnly = !_starredOnly;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: _starredOnly
                      ? const Color(0xff4A59FE)
                      : const Color(0xffE5E5EA),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment:
                      _starredOnly ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
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
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GestureDetector(
        onTap: () {
          // TODO: Apply filters and close
          Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xff4A59FE),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff808080).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Apply Filters',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Custom Slider Thumb Shape
class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(16.w, 16.h);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Shadow
    canvas.drawCircle(
      center,
      12.w,
      Paint()
        ..color = const Color(0xffA1A1AA).withOpacity(0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );

    // White circle
    canvas.drawCircle(
      center,
      8.w,
      Paint()..color = Colors.white,
    );

    // Blue border
    canvas.drawCircle(
      center,
      8.w,
      Paint()
        ..color = const Color(0xff4A59FE)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}

// Custom Range Thumb Shape
class _CustomRangeThumbShape extends RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(16.w, 16.h);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    // Shadow
    canvas.drawCircle(
      center,
      12.w,
      Paint()
        ..color = const Color(0xffA1A1AA).withOpacity(0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );

    // White circle
    canvas.drawCircle(
      center,
      8.w,
      Paint()..color = Colors.white,
    );

    // Blue border
    canvas.drawCircle(
      center,
      8.w,
      Paint()
        ..color = const Color(0xff4A59FE)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}

// Custom Track Shape
class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 12;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}