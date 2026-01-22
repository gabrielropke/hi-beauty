import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/core/services/notifications_service.dart';
import 'package:hibeauty/theme/app_colors.dart';

class HomeTop extends StatelessWidget {
  final ScrollController? scrollController;
  final bool? businessInfoView;
  const HomeTop({
    super.key,
    this.scrollController,
    this.businessInfoView = true,
  });

  @override
  Widget build(BuildContext context) {
    final businessName = BusinessData.name;
    final businessInitial = (businessName.isNotEmpty ? businessName[0] : '?')
        .toUpperCase();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Avatar + nome do negócio
            if (businessInfoView == true) ...[
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                backgroundImage:
                    BusinessData.logoUrl != null &&
                        BusinessData.logoUrl!.isNotEmpty
                    ? NetworkImage(BusinessData.logoUrl!)
                    : null,
                child:
                    BusinessData.logoUrl == null ||
                        BusinessData.logoUrl!.isEmpty
                    ? Text(
                        businessInitial,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            Row(
              spacing: 8,
              children: [
                NotificationsService().notificationGlobalWidget(context),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.user),
                  child: Container(
                    padding: const EdgeInsets.all(2), // blue border width
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondary, width: 1),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(1), // white border width
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black12,
                        backgroundImage: UserData.profileImageUrl.isNotEmpty
                            ? NetworkImage(UserData.profileImageUrl)
                            : null,
                        child: UserData.profileImageUrl.isEmpty
                            ? Text(
                                (UserData.name.isNotEmpty
                                        ? UserData.name[0]
                                        : '?')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
