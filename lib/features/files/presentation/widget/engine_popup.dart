import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EngineSelection {
  final String provider;
  final String displayName;

  const EngineSelection({required this.provider, required this.displayName});
}

class _Engine {
  final String displayName;
  final String provider;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final int accuracy;
  final int speed;
  final int speakers;
  final List<String> strengths;
  final List<String> bestFor;

  const _Engine({
    required this.displayName,
    required this.provider,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.accuracy,
    required this.speed,
    required this.speakers,
    required this.strengths,
    required this.bestFor,
  });
}

const List<_Engine> _engines = [
  _Engine(
    displayName: 'Precision',
    provider: 'assemblyai',
    subtitle: 'Maximum Accuracy',
    description:
        'Industry-leading 95-98% accuracy on clean audio. Built for situations where every word matters—legal testimony, medical diagnoses, research interviews.',
    icon: Icons.gps_fixed,
    bgColor: Color(0xFFDBEAFE),
    iconColor: Color(0xFF1E40AF),
    accuracy: 98,
    speed: 85,
    speakers: 90,
    strengths: [
      'Word Error Rate: 7-9% (industry-leading)',
      'Professional punctuation & formatting',
    ],
    bestFor: [
      'Legal depositions & court proceedings',
      'Medical consultations & diagnoses',
    ],
  ),
  _Engine(
    displayName: 'Velocity',
    provider: 'deepgram',
    subtitle: 'Lightning Fast',
    description:
        'Processes audio 40-200x faster than real-time. Get 1 hour of audio transcribed in just 90 seconds. Perfect for live meetings and high-volume processing.',
    icon: Icons.bolt,
    bgColor: Color(0xFFDCFCE7),
    iconColor: Color(0xFF166534),
    accuracy: 95,
    speed: 98,
    speakers: 88,
    strengths: [
      '40-200x real-time speed (1hr = 90 seconds)',
      'Real-time streaming: ~200ms latency',
    ],
    bestFor: [
      'Live meeting transcription & captions',
      'Podcast transcription (clear audio)',
    ],
  ),
  _Engine(
    displayName: 'Clarity',
    provider: 'speechmatics',
    subtitle: 'Balanced Performance',
    description:
        'Optimized balance of speed and accuracy. Best for everyday transcription needs with consistent results across different audio conditions.',
    icon: Icons.layers,
    bgColor: Color(0xFFFFEDD5),
    iconColor: Color(0xFF9A3412),
    accuracy: 93,
    speed: 92,
    speakers: 88,
    strengths: [
      'Consistent 90-95% accuracy',
      'Fast processing (2-3 minutes per hour)',
    ],
    bestFor: [
      'General meetings & calls',
      'Interviews & focus groups',
    ],
  ),
  _Engine(
    displayName: 'Universal',
    provider: 'whisper',
    subtitle: 'Multi-Language Support',
    description:
        'Supports 90+ languages with automatic language detection. Ideal for international content, multilingual meetings, and global teams.',
    icon: Icons.language,
    bgColor: Color(0xFFF3E8FF),
    iconColor: Color(0xFF6B21A8),
    accuracy: 90,
    speed: 88,
    speakers: 85,
    strengths: [
      'Supports 90+ languages',
      'Automatic language detection',
    ],
    bestFor: [
      'International meetings',
      'Multilingual content',
    ],
  ),
];

class EnginePopup extends StatefulWidget {
  const EnginePopup({super.key});

  @override
  State<EnginePopup> createState() => _EnginePopupState();
}

class _EnginePopupState extends State<EnginePopup> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: _engines.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return _buildEngineCard(
                      engine: _engines[index],
                      isSelected: _selectedIndex == index,
                      onTap: () => setState(() => _selectedIndex = index),
                    );
                  },
                ),
              ),
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFCFCFCF),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineCard({
    required _Engine engine,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A59FE).withValues(alpha: 0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A59FE)
                : const Color(0xFFE5E5EA),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: engine.bgColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    engine.icon,
                    size: 24.sp,
                    color: engine.iconColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        engine.displayName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                          letterSpacing: -0.31,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        engine.subtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4A59FE),
                          letterSpacing: -0.08,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A59FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 16.sp, color: Colors.white),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              engine.description,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4B5563),
                height: 1.45,
              ),
            ),
            SizedBox(height: 12.h),
            _buildStatBar('Accuracy', engine.accuracy, const Color(0xFF3B82F6)),
            SizedBox(height: 6.h),
            _buildStatBar('Speed', engine.speed, const Color(0xFF10B981)),
            SizedBox(height: 6.h),
            _buildStatBar(
                'Speaker Detection', engine.speakers, const Color(0xFFA855F7)),
            SizedBox(height: 12.h),
            Text(
              'KEY STRENGTHS',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 4.h),
            ...engine.strengths.map((s) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(
                    '✓ $s',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                )),
            SizedBox(height: 10.h),
            Text(
              'BEST FOR',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: engine.bestFor
                  .map((tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 5.h,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF2F2F7))),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                    letterSpacing: -0.23,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                final engine = _engines[_selectedIndex];
                Navigator.pop(
                  context,
                  EngineSelection(
                    provider: engine.provider,
                    displayName: engine.displayName,
                  ),
                );
              },
              child: Container(
                height: 48.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A59FE),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.23,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
