import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/services/add_service.dart';
import 'package:hibeauty/features/customers/presentation/components/customer_tile.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ServicesDetailsScreen extends StatelessWidget {
  final ServicesModel service;
  final CatalogBloc? bloc;

  const ServicesDetailsScreen({super.key, required this.service, this.bloc});

  @override
  Widget build(BuildContext context) {
    final catalogBloc =
        bloc ?? BlocProvider.of<CatalogBloc>(context, listen: false);

    return BlocProvider.value(
      value: catalogBloc,
      child: ServicesView(service: service),
    );
  }
}

class ServicesView extends StatefulWidget {
  final ServicesModel service;
  const ServicesView({super.key, required this.service});
  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  final ScrollController _scrollController = ScrollController();
  bool _serviceExists = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCustomerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            // reduz padding geral
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // botão fechar com menos padding
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => context.pop(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Icon(LucideIcons.x200),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // opção Editar sem efeito de toque
                OptionItem(
                  label: 'Editar',
                  onTap: () {
                    context.pop(); // Fechar modal primeiro

                    // Pegar o estado atual para acessar team data
                    final currentState = context.read<CatalogBloc>().state;
                    if (currentState is CatalogLoaded) {
                      showAddService(
                        context: context,
                        state: currentState,
                        l10n: AppLocalizations.of(context)!,
                        service: widget.service, // Passar o serviço para edição
                      );
                    }
                  },
                ),
                const SizedBox(height: 4),
                // opção Deletar sem efeito de toque
                OptionItem(
                  label: 'Deletar',
                  destructive: true,
                  onTap: () {
                    context.pop(); // Fechar modal primeiro
                    context.read<CatalogBloc>().add(
                      DeleteService(widget.service.id),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state is CatalogLoaded) {
          // Verifica se o serviço ainda existe na lista
          final serviceExists = state.services.any(
            (s) => s.id == widget.service.id,
          );
          if (_serviceExists && !serviceExists) {
            // Serviço foi removido, volta para a tela anterior
            context.pop();
          }
          _serviceExists = serviceExists;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) => switch (state) {
            CatalogLoading _ => const AppLoader(),
            CatalogLoaded s => _loaded(s, l10n, context), // passar context
            CatalogState() => const AppLoader(),
          },
        ),
      ),
    );
  }

  Widget _loaded(
    CatalogLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final service = widget.service;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: service.name,
            controller: _scrollController,
            backgroundColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        _image(service.coverImageUrl ?? ''),
                        SizedBox(height: 16),
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (widget.service.category != null) ...[
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(
                                  widget.service.category!.color.replaceFirst(
                                    '#',
                                    '0xff',
                                  ),
                                ),
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 12,
                              ),
                              child: Text(
                                widget.service.category!.name,
                                style: TextStyle(
                                  color: Color(
                                    int.parse(
                                      widget.service.category!.color
                                          .replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 12),
                        AppButton(
                          label: 'Ações',
                          fillColor: Colors.transparent,
                          labelColor: Colors.black87,
                          borderColor: Colors.black12,
                          function: () => _showCustomerOptions(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[50],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Informações básicas',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final currentState = context
                                    .read<CatalogBloc>()
                                    .state;
                                if (currentState is CatalogLoaded) {
                                  showAddService(
                                    context: context,
                                    state: currentState,
                                    l10n: AppLocalizations.of(context)!,
                                    service: widget
                                        .service, // Passar o serviço para edição
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              child: const Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _PreviewTile(
                          label: 'Nome do serviço',
                          value: service.name,
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Descrição',
                          value: service.description ?? '-',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Duração',
                          value: '${service.duration} min',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Preço',
                          value:
                              'R\$ ${service.price.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Tipo de local',
                          value: mapLocationType(
                            service.locationType.toLowerCase(),
                          ),
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Visibilidade',
                          value: mapVisibility(
                            service.visibility.toLowerCase(),
                          ),
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Status',
                          value: service.isActive ? 'Ativo' : 'Inativo',
                        ),
                        if (service.teamMembers.isNotEmpty) ...[
                          SizedBox(height: 20),
                          Divider(color: Colors.grey[400], thickness: 0),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Membros da equipe',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ...service.teamMembers.map(
                            (member) => Column(
                              children: [
                                _TeamMemberTile(member: member),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),

                          SizedBox(height: 80),
                        ],
                      ],
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
}

class _PreviewTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onAdd;
  // ignore: unused_element_parameter
  const _PreviewTile({required this.label, required this.value, this.onAdd});
  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;
    return Row(
      spacing: 64,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (!isEmpty)
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          )
        else
          TextButton(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: Colors.blue,
            ),
            child: const Text(
              'Adicionar',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  final TeamMemberModel member;

  const _TeamMemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Color(
            int.parse(member.themeColor.replaceAll('#', '0xff')),
          ),
          backgroundImage: member.profileImageUrl != null
              ? CachedNetworkImageProvider(member.profileImageUrl!)
              : null,
          child: member.profileImageUrl == null
              ? Text(
                  member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                )
              : null,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                member.email,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _mapRole(member.role.toLowerCase()),
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

String _mapRole(String role) {
  switch (role) {
    case 'owner':
      return 'Proprietário';
    case 'manager':
      return 'Gerente';
    case 'employee':
      return 'Funcionário';
    case 'freelancer':
      return 'Freelancer';
    default:
      return role;
  }
}

_image(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: url.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Icon(
                LucideIcons.scissors300,
                color: Colors.black12,
                size: 40,
              ),
            ),
          )
        : Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: Icon(
              LucideIcons.scissors300,
              color: Colors.black12,
              size: 40,
            ),
          ),
  );
}

String mapLocationType(String value) {
  switch (value) {
    case 'in_person':
      return 'Presencial';
    case 'online':
      return 'Remoto';
    case 'to_be_arranged':
      return 'A combinar';
    default:
      return value;
  }
}

String mapVisibility(String value) {
  switch (value) {
    case 'public':
      return 'Público';
    case 'private':
      return 'Privado';
    default:
      return value;
  }
}
