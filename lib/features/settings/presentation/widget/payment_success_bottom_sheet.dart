import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class PaymentSuccessBottomSheet extends StatelessWidget {
  final String amount;
  final String date;
  final String serviceName;
  final String invoiceNumber;
  final String paymentMethod;
  final String subtotal;
  final String tax;
  final String totalPaid;

  const PaymentSuccessBottomSheet({
    super.key,
    required this.amount,
    required this.date,
    required this.serviceName,
    required this.invoiceNumber,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.totalPaid,
  });

  static void show(
    BuildContext context, {
    required String amount,
    required String date,
    required String serviceName,
    required String invoiceNumber,
    required String paymentMethod,
    required String subtotal,
    required String tax,
    required String totalPaid,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentSuccessBottomSheet(
        amount: amount,
        date: date,
        serviceName: serviceName,
        invoiceNumber: invoiceNumber,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        tax: tax,
        totalPaid: totalPaid,
      ),
    );
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          _buildGrabber(),
          24.verticalSpace,
          // Success icon and header
          _buildSuccessHeader(),
          8.verticalSpace,
          // Amount and date
          _buildAmountSection(),
          8.verticalSpace,
          // Details section with dashed border
          _buildDetailsSection(),
          // Action buttons
          _buildActionButtons(context),
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
        ],
      ),
    );
  }

  Widget _buildGrabber() {
    return Container(
      padding: EdgeInsets.only(top: 10.h),
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

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        // Success icon
        Container(
          width: 48.w,
          height: 48.h,
          decoration: const BoxDecoration(
            color: Color(0xffC6FCE4),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.checkmark,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff009C62),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        8.verticalSpace,
        // Payment Success text
        Text(
          'PAYMENT SUCCESS',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff3C3C43).withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      children: [
        // Amount
        Text(
          amount,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp,
            height: 34 / 28,
            letterSpacing: 0.38,
            color: const Color(0xff000000),
          ),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        // Date
        Text(
          date,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff3C3C43).withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.15),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: CustomPaint(
        painter: DashedTopBorderPainter(),
        child: Column(
          children: [
            // Service
            _buildDetailRow('Service', serviceName, isBold: true),
            16.verticalSpace,
            // Invoice #
            _buildDetailRow('Invoice #', invoiceNumber, isBold: true),
            16.verticalSpace,
            // Payment Method
            _buildPaymentMethodRow(),
            16.verticalSpace,
            // Status
            _buildStatusRow(),
            16.verticalSpace,
            // Divider
            Container(
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            16.verticalSpace,
            // Subtotal
            _buildDetailRow('Subtotal', subtotal),
            16.verticalSpace,
            // Tax
            _buildDetailRow('Tax (0%)', tax),
            16.verticalSpace,
            // Total Paid
            _buildTotalRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              AppAssets.payment,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff999999),
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            Text(
              paymentMethod,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: const Color(0xff000000),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xffC6FCE4),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'Paid',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: const Color(0xff009C62),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Paid',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            height: 25 / 20,
            letterSpacing: -0.45,
            color: const Color(0xff000000),
          ),
        ),
        Text(
          totalPaid,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            height: 25 / 20,
            letterSpacing: -0.45,
            color: const Color(0xff000000),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Share button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Handle share
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffF2F2F7)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.shareIos,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff04071E),
                        BlendMode.srcIn,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      'Share',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        height: 22 / 17,
                        letterSpacing: -0.43,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          8.horizontalSpace,
          // Download Receipt button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Handle download receipt
              },
              child: Container(
                height: 52.h,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.arrowDownload,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      'Download Receipt',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        height: 22 / 17,
                        letterSpacing: -0.43,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashed top border
class DashedTopBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}