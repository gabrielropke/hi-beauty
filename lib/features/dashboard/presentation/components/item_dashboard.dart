import 'package:flutter/material.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class ItemDashboard extends StatelessWidget {
  final DashboardLoaded state;
  final Widget child;
  final String title;
  const ItemDashboard({super.key, required this.state, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                // GestureDetector(
                //   onTap: () => _showEditSheet(context: context, state: state),
                //   child: Container(
                //     width: 30,
                //     height: 35,
                //     color: Colors.transparent,
                //     child: Icon(LucideIcons.ellipsisVertical300),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}