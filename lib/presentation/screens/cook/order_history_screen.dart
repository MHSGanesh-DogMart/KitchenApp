import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../discover/_discover_widgets.dart';

/// Mockup 60 — Cook · Order history.
class CookOrderHistoryScreen extends StatefulWidget {
  const CookOrderHistoryScreen({super.key});
  @override
  State<CookOrderHistoryScreen> createState() =>
      _CookOrderHistoryScreenState();
}

class _CookOrderHistoryScreenState extends State<CookOrderHistoryScreen> {
  int _f = 0;
  static const _filters = ['All', 'Delivered', 'Cancelled'];

  static const _orders = <_OrderRow>[
    _OrderRow(
      id: '#PD4821',
      customer: 'Priya M.',
      time: 'Today, 11:48',
      amount: '₹120',
      status: 'Out',
      statusBg: AppColors.primarySoft,
      statusFg: AppColors.primaryDark,
    ),
    _OrderRow(
      id: '#PD4818',
      customer: 'Anita P.',
      time: 'Today, 11:02',
      amount: '₹240',
      status: 'Delivered',
      statusBg: AppColors.secondarySoft,
      statusFg: AppColors.secondary,
    ),
    _OrderRow(
      id: '#PD4805',
      customer: 'Rohit',
      time: 'Yesterday',
      amount: '₹90',
      status: 'Delivered',
      statusBg: AppColors.secondarySoft,
      statusFg: AppColors.secondary,
    ),
    _OrderRow(
      id: '#PD4790',
      customer: 'Meera',
      time: 'Yesterday',
      amount: '₹60',
      status: 'Cancelled',
      statusBg: AppColors.violetSoft,
      statusFg: AppColors.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlainAppBar(title: 'Order history'),
            // Filter chips
            SizedBox(
              height: 38.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _filters.length,
                itemBuilder: (_, i) {
                  final item = FilterChip2(
                    label: _filters[i],
                    selected: _f == i,
                    onTap: () => setState(() => _f = i),
                  );
                  if (i == _filters.length - 1) return item;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: item,
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 110.h),
                itemCount: _orders.length,
                itemBuilder: (_, i) {
                  final o = _orders[i];
                  final item = Container(
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${o.id} · ${o.customer}',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                o.time,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              o.amount,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            FlatChip(
                              label: o.status,
                              bg: o.statusBg,
                              fg: o.statusFg,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                  if (i == _orders.length - 1) return item;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: item,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderRow {
  const _OrderRow({
    required this.id,
    required this.customer,
    required this.time,
    required this.amount,
    required this.status,
    required this.statusBg,
    required this.statusFg,
  });
  final String id;
  final String customer;
  final String time;
  final String amount;
  final String status;
  final Color statusBg;
  final Color statusFg;
}
