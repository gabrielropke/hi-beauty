import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/hi_mobile.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_popup.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/user/presentation/bloc/user_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(context)..add(UserLoadRequested()),
      child: const UserView(),
    );
  }
}

class UserView extends StatefulWidget {
  const UserView({super.key});
  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => switch (state) {
          UserLoading _ => const AppLoader(),
          UserLoaded s => _loaded(s, l10n, context),
          UserState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _loaded(
    UserLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Bar
        _buildAppBar(l10n),

        // Main Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                _ProfileSection(),

                // Incomplete Data Banner
                _IncompleteDataBanner(),

                // Menu Options
                _MenuOptionsSection(
                  onLogout: () async {
                    // Clear all user data
                    await SecureStorage.clearAll();
                    UserService().clearUser();
                    BusinessService().clearBusiness();
                    SubscriptionService().resetService();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    // Navigate to login
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return CustomAppBar(
      title: l10n.businessData,
      controller: _scrollController,
      backgroundColor: Colors.white,
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildUserInfo(), _buildUserAvatar()],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Área pessoal', style: TextStyle(color: Colors.grey)),
        Text(
          UserData.name,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Container(
        padding: const EdgeInsets.all(1), // white border width
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black12,
          backgroundImage: UserData.profileImageUrl.isNotEmpty
              ? NetworkImage(UserData.profileImageUrl)
              : null,
          child: UserData.profileImageUrl.isEmpty
              ? Text(
                  (UserData.name.isNotEmpty ? UserData.name[0] : '?')
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _IncompleteDataBanner extends StatelessWidget {
  const _IncompleteDataBanner();

  @override
  Widget build(BuildContext context) {
    if (isConfigurationComplete()) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [const SizedBox(height: 16), _buildBanner(context)],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.businessConfig),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF7DC),
          border: Border.all(width: 1, color: const Color(0xFFFFE8A2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: _buildBannerContent()),
            const Icon(LucideIcons.chevronRight300, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete seu cadastro',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          'Seus dados estão incompletos',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}

class _MenuOptionsSection extends StatefulWidget {
  final VoidCallback onLogout;

  const _MenuOptionsSection({required this.onLogout});

  @override
  State<_MenuOptionsSection> createState() => _MenuOptionsSectionState();
}

class _MenuOptionsSectionState extends State<_MenuOptionsSection> {
  String terms = '';
  String privacy = '';

  @override
  void initState() {
    loadingBranding();
    super.initState();
  }

  void loadingBranding() async {
    final Map<String, dynamic> brandMap = await BrandLoader.load();
    terms = brandMap['terms'];
    privacy = brandMap['privacy'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Column(children: _buildMenuOptions(context)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Column(children: _buildSecondMenuOptions(context)),
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Column(children: _buildThirdMenuOptions(context)),
        ),
      ],
    );
  }

  List<Widget> _buildThirdMenuOptions(BuildContext context) {
    final options = [
      _MenuOption(
        icon: LucideIcons.trash2300,
        label: 'Deletar minha conta',
        onTap: () => AppPopup.show(
          context: context,
          type: AppPopupType.delete,
          title: 'Tem certeza?',
          description: 'Não podemos reativar e nem recuperar esta conta depois de deletada. Será necessário criar uma nova conta para utilizar o aplicativo novamente.',
          onConfirm: widget.onLogout,
        ),
        color: Colors.red,
      ),
    ];

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      return Column(
        children: [
          if (index > 0) const SizedBox(height: 24),
          _buildOptionTile(option),
        ],
      );
    }).toList();
  }

  List<Widget> _buildSecondMenuOptions(BuildContext context) {
    final options = [
      _MenuOption(
        icon: LucideIcons.handshake300,
        label: 'Termos de Uso',
        onTap: () => launchUrl(Uri.parse(terms)),
      ),
      _MenuOption(
        icon: LucideIcons.shieldCheck300,
        label: 'Políticas de privacidade',
        onTap: () => launchUrl(Uri.parse(privacy)),
      ),
      _MenuOption(
        icon: LucideIcons.logOut300,
        label: 'Sair',
        onTap: widget.onLogout,
      ),
    ];

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      return Column(
        children: [
          if (index > 0) const SizedBox(height: 24),
          _buildOptionTile(option),
        ],
      );
    }).toList();
  }

  List<Widget> _buildMenuOptions(BuildContext context) {
    final options = [
      _MenuOption(
        icon: LucideIcons.bell300,
        label: 'Notificações',
        onTap: () => context.push(AppRoutes.notifications),
      ),
      _MenuOption(
        icon: LucideIcons.circleQuestionMark300,
        label: 'Ajuda e suporte',
        onTap: () async {
          final Map<String, dynamic> brandMap = await BrandLoader.load();
          final String supportNumber = brandMap['social']['whatsapp'];
          const message = 'Olá! Preciso de ajuda com o sistema.';
          final url =
              'https://wa.me/$supportNumber?text=${Uri.encodeComponent(message)}';
          launchUrl(Uri.parse(url));
        },
      ),
    ];

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      return Column(
        children: [
          if (index > 0) const SizedBox(height: 24),
          _buildOptionTile(option),
        ],
      );
    }).toList();
  }

  Widget _buildOptionTile(_MenuOption option) {
    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Icon(option.icon, size: 22, color: option.color ?? Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              option.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: option.color ?? Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: option.color ?? Colors.black.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _MenuOption {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
