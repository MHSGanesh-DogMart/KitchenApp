import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../auth/_auth_widgets.dart';

/// Mockup 62 — Cook · Earnings (Earnings tab).
class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Earnings',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.6,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 110.h),
                children: [
                  // Hero withdraw card
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF16150F), Color(0xFF3A2419)],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: .25),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available to withdraw',
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            color: Colors.white.withValues(alpha: .65),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '₹3,240',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -.5,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        AuthButton(
                          label: 'Withdraw to bank',
                          icon: Icons.account_balance_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Small stats
                  Row(
                    children: [
                      Expanded(child: _SmallStat(big: '₹960', sub: 'This week')),
                      SizedBox(width: 10.w),
                      Expanded(child: _SmallStat(big: '42', sub: 'Orders')),
                    ],
                  ),
                  // Payouts
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 22.h, 0, 10.h),
                    child: Text(
                      'Payouts',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  _PayoutRow(
                    title: 'This week',
                    sub: '42 orders · HDFC •• 8842',
                    amount: '+ ₹960',
                  ),
                  SizedBox(height: 8.h),
                  _PayoutRow(
                    title: 'Last week',
                    sub: '51 orders · HDFC •• 8842',
                    amount: '+ ₹1,180',
                  ),
                  SizedBox(height: 8.h),
                  _PayoutRow(
                    title: '2 weeks ago',
                    sub: '48 orders · HDFC •• 8842',
                    amount: '+ ₹1,100',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.big, required this.sub});
  final String big;
  final String sub;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            big,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutRow extends StatelessWidget {
  const _PayoutRow({
    required this.title,
    required this.sub,
    required this.amount,
  });
  final String title;
  final String sub;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
