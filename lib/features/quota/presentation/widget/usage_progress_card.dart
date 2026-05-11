import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/quota/domain/entities/quota_entity.dart';
import 'package:voice_ink/features/quota/presentation/cubit/quota_cubit.dart';
import 'package:voice_ink/features/quota/presentation/cubit/quota_state.dart';

class UsageProgressCard extends StatelessWidget {
  const UsageProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuotaCubit, QuotaState>(
      builder: (context, state) {
        if (state.apiState == NormalApiState.loading ||
            state.apiState == NormalApiState.initial) {
          return _buildSkeleton();
        }
        if (state.apiState == NormalApiState.failure) {
          return const SizedBox.shrink();
        }
        final minutes = state.transcriptionMinutes;
        if (minutes == null) return const SizedBox.shrink();
        return _buildCard(minutes);
      },
    );
  }

  Widget _buildSkeleton() {
    return Container(
      height: 84.h,
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }

  Widget _buildCard(QuotaEntity quota) {
    final consumed = quota.totalConsumed.toInt();
    final allocated = quota.totalAllocated.toInt();
    final percent = (quota.progress * 100).round();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16.sp,
                    color: const Color(0xff4A59FE),
                  ),
                  6.horizontalSpace,
                  Text(
                    'Transcription Minutes',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      color: const Color(0xff1E222B),
                    ),
                  ),
                ],
              ),
              Text(
                '$percent%',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  height: 16 / 12,
                  letterSpacing: -0.08,
                  color: const Color(0xff8C8C8C),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            child: LinearProgressIndicator(
              value: quota.progress,
              minHeight: 6.h,
              backgroundColor: const Color(0xffE5E5EA),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xff4A59FE),
              ),
            ),
          ),
          8.verticalSpace,
          Text(
            '${_format(consumed)} of ${_format(allocated)} minutes used',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              height: 16 / 12,
              letterSpacing: -0.08,
              color: const Color(0xff8C8C8C),
            ),
          ),
        ],
      ),
    );
  }

  String _format(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    if (remaining == 0) return '${hours}h';
    return '${hours}h ${remaining}m';
  }
}
