import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum TipoComissao { percentual, valorFixo, escalonada, hibrida }

class FaixaComissao {
  final double? valorMinimo;
  final double? valorMaximo;
  final double? percentual;
  final double? valorFixo;

  FaixaComissao({
    this.valorMinimo,
    this.valorMaximo,
    this.percentual,
    this.valorFixo,
  });

  FaixaComissao copyWith({
    double? valorMinimo,
    double? valorMaximo,
    double? percentual,
    double? valorFixo,
  }) {
    return FaixaComissao(
      valorMinimo: valorMinimo ?? this.valorMinimo,
      valorMaximo: valorMaximo ?? this.valorMaximo,
      percentual: percentual ?? this.percentual,
      valorFixo: valorFixo ?? this.valorFixo,
    );
  }
}

class ComissaoTeamMember extends StatefulWidget {
  final CommissionConfigModel? initialCommissionConfig;

  const ComissaoTeamMember({super.key, this.initialCommissionConfig});

  @override
  State<ComissaoTeamMember> createState() => _ComissaoTeamMemberState();
}

class _ComissaoTeamMemberState extends State<ComissaoTeamMember> {
  bool _comissaoAtiva = false;
  TipoComissao? _tipoSelecionado;
  double _percentual = 0.0;
  double _valorFixo = 0.0;
  double _percentualHibrido = 0.0;
  double _valorFixoHibrido = 0.0;

  // Controllers para os campos de texto
  final TextEditingController _percentualCtrl = TextEditingController();
  final TextEditingController _valorFixoCtrl = TextEditingController();
  final TextEditingController _percentualHibridoCtrl = TextEditingController();
  final TextEditingController _valorFixoHibridoCtrl = TextEditingController();

  final List<FaixaComissao> _faixas = [
    FaixaComissao(valorMinimo: 0, valorMaximo: 100, percentual: 20),
    FaixaComissao(valorMinimo: 100, valorMaximo: 500, percentual: 30),
  ];

  @override
  void initState() {
    super.initState();
    _initializeFromConfig();
  }

  void _initializeFromConfig() {
    if (widget.initialCommissionConfig == null) return;

    final config = widget.initialCommissionConfig!;
    _comissaoAtiva = config.isActive;

    // Mapear tipo da API para enum local
    switch (config.type) {
      case 'PERCENTAGE':
        _tipoSelecionado = TipoComissao.percentual;
        _percentual = config.percentage ?? 0.0;
        _percentualCtrl.text = _percentual > 0 ? _percentual.toString() : '';
        break;
      case 'FIXED_VALUE':
        _tipoSelecionado = TipoComissao.valorFixo;
        _valorFixo = config.fixedAmount ?? 0.0;
        _valorFixoCtrl.text = _valorFixo > 0 ? _valorFixo.toString() : '';
        break;
      case 'TIERED':
        _tipoSelecionado = TipoComissao.escalonada;
        if (config.tiers != null && config.tiers!.isNotEmpty) {
          _faixas.clear();
          for (var tier in config.tiers!) {
            _faixas.add(
              FaixaComissao(
                valorMinimo: tier.minAmount,
                valorMaximo: tier.maxAmount,
                percentual: tier.percentage,
                valorFixo: tier.fixedAmount,
              ),
            );
          }
        }
        break;
      case 'HYBRID':
        _tipoSelecionado = TipoComissao.hibrida;
        _percentualHibrido = config.percentage ?? 0.0;
        _valorFixoHibrido = config.fixedAmount ?? 0.0;
        _percentualHibridoCtrl.text = _percentualHibrido > 0
            ? _percentualHibrido.toString()
            : '';
        _valorFixoHibridoCtrl.text = _valorFixoHibrido > 0
            ? _valorFixoHibrido.toString()
            : '';
        break;
    }
  }

  @override
  void dispose() {
    _percentualCtrl.dispose();
    _valorFixoCtrl.dispose();
    _percentualHibridoCtrl.dispose();
    _valorFixoHibridoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(LucideIcons.trendingUp, size: 20),
            Text(
              'Configurações de comissão',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Opcional: Configure comissão para este colaborador',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: _comissaoAtiva ? 'Desativar comissões' : 'Ativar comissões',
          fillColor: _comissaoAtiva ? Colors.red.shade50 : Colors.white,
          borderColor: _comissaoAtiva ? Colors.red : Colors.black,
          labelStyle: TextStyle(
            color: _comissaoAtiva ? Colors.red : Colors.black,
          ),
          function: () {
            setState(() {
              _comissaoAtiva = !_comissaoAtiva;
              if (!_comissaoAtiva) {
                _tipoSelecionado = null;
              }
            });
          },
        ),
        if (_comissaoAtiva) ...[
          const SizedBox(height: 20),
          _buildTipoComissaoSection(),
          if (_tipoSelecionado != null) ...[
            const SizedBox(height: 20),
            _buildConfiguracoesComissao(),
            const SizedBox(height: 16),
            _buildPreviewComissao(),
          ],
        ],
      ],
    );
  }

  Widget _buildTipoComissaoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tipo de Comissão',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text('*', style: const TextStyle(fontSize: 12, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildTipoComissaoCard(
              TipoComissao.percentual,
              'Percentual',
              'Comissão baseada em porcentagem sobre o valor',
              LucideIcons.percent,
            ),
            const SizedBox(height: 8),
            _buildTipoComissaoCard(
              TipoComissao.valorFixo,
              'Valor Fixo',
              'Valor fixo por serviço/venda',
              LucideIcons.dollarSign,
            ),
            const SizedBox(height: 8),
            _buildTipoComissaoCard(
              TipoComissao.escalonada,
              'Escalonada',
              'Diferentes comissões por faixas de valor',
              LucideIcons.chartColumn,
            ),
            const SizedBox(height: 8),
            _buildTipoComissaoCard(
              TipoComissao.hibrida,
              'Híbrida',
              'Combinação de percentual e valor fixo',
              LucideIcons.calculator,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipoComissaoCard(
    TipoComissao tipo,
    String titulo,
    String descricao,
    IconData icone,
  ) {
    final isSelected = _tipoSelecionado == tipo;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoSelecionado = tipo;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.withValues(alpha: 0.0) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? Colors.blue : Colors.grey.shade100,
              ),
              child: Icon(
                icone,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfiguracoesComissao() {
    switch (_tipoSelecionado!) {
      case TipoComissao.percentual:
        return _buildPercentualConfig();
      case TipoComissao.valorFixo:
        return _buildValorFixoConfig();
      case TipoComissao.escalonada:
        return _buildEscalonadaConfig();
      case TipoComissao.hibrida:
        return _buildHibridaConfig();
    }
  }

  Widget _buildPercentualConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Percentual de Comissão (%)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        AppTextformfield(
          controller: _percentualCtrl,
          keyboardType: TextInputType.number,
          textInputFormatter: FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d*'),
          ),
          hintText: '0.0',
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: Text('%', style: TextStyle(color: Colors.black)),
          ),
          onChanged: (value) {
            setState(() {
              _percentual = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        const SizedBox(height: 4),
        const Text(
          'Entre 0.1% e 100%',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildValorFixoConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Valor Fixo (R\$)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppTextformfield(
          controller: _valorFixoCtrl,
          keyboardType: TextInputType.number,
          textInputFormatter: FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d*'),
          ),
          hintText: '50.0',
          prefixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: Text('R\$', style: TextStyle(color: Colors.black)),
          ),
          onChanged: (value) {
            setState(() {
              _valorFixo = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        const SizedBox(height: 4),
        const Text(
          'Valor em reais por serviço/venda',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildEscalonadaConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Faixas de Comissão',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _faixas.add(FaixaComissao());
                });
              },
              icon: const Icon(LucideIcons.plus, size: 14),
              label: Text('Adicionar', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _faixas.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _buildFaixaCard(index),
        ),
      ],
    );
  }

  Widget _buildFaixaCard(int index) {
    final faixa = _faixas[index];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Faixa ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (_faixas.length > 1)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _faixas.removeAt(index);
                    });
                  },
                  icon: const Icon(
                    LucideIcons.trash300,
                    size: 18,
                    color: Colors.red,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: const EdgeInsets.all(4),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valor Mínimo (R\$)',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    AppTextformfield(
                      keyboardType: TextInputType.number,
                      textInputFormatter: FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                      hintText: '0.0',
                      onChanged: (value) {
                        setState(() {
                          _faixas[index] = faixa.copyWith(
                            valorMinimo: double.tryParse(value) ?? 0.0,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valor Máximo (R\$)',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    AppTextformfield(
                      keyboardType: TextInputType.number,
                      textInputFormatter: FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                      hintText: index == _faixas.length - 1
                          ? 'Sem limite'
                          : '100.0',
                      onChanged: (value) {
                        setState(() {
                          _faixas[index] = faixa.copyWith(
                            valorMaximo: double.tryParse(value),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Percentual (%)',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    AppTextformfield(
                      keyboardType: TextInputType.number,
                      textInputFormatter: FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                      hintText: '20.0',
                      suffixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('%', style: TextStyle(color: Colors.black)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _faixas[index] = faixa.copyWith(
                            percentual: double.tryParse(value),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valor Fixo (R\$)',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    AppTextformfield(
                      keyboardType: TextInputType.number,
                      textInputFormatter: FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                      hintText: '0.0',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'R\$',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _faixas[index] = faixa.copyWith(
                            valorFixo: double.tryParse(value),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHibridaConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Percentual (%)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextformfield(
                    controller: _percentualHibridoCtrl,
                    keyboardType: TextInputType.number,
                    textInputFormatter: FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d*'),
                    ),
                    hintText: '20.0',
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('%', style: TextStyle(color: Colors.black)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _percentualHibrido = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Valor Fixo (R\$)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextformfield(
                    controller: _valorFixoHibridoCtrl,
                    keyboardType: TextInputType.number,
                    textInputFormatter: FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d*'),
                    ),
                    hintText: '25.0',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('R\$', style: TextStyle(color: Colors.black)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _valorFixoHibrido = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewComissao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.background,
        border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    LucideIcons.info,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 8)),
                const TextSpan(
                  text: 'Preview da Configuração',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Tipo: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: _getTipoNome(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Comissão: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: _getComissaoTexto(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTipoNome() {
    switch (_tipoSelecionado!) {
      case TipoComissao.percentual:
        return 'Percentual';
      case TipoComissao.valorFixo:
        return 'Valor Fixo';
      case TipoComissao.escalonada:
        return 'Escalonada';
      case TipoComissao.hibrida:
        return 'Híbrida';
    }
  }

  String _getComissaoTexto() {
    switch (_tipoSelecionado!) {
      case TipoComissao.percentual:
        return '${_percentual.toStringAsFixed(1)}% sobre o valor';
      case TipoComissao.valorFixo:
        return 'R\$ ${_valorFixo.toStringAsFixed(2)} por serviço';
      case TipoComissao.escalonada:
        return 'Configuração por faixas de valor';
      case TipoComissao.hibrida:
        return '${_percentualHibrido.toStringAsFixed(1)}% + R\$ ${_valorFixoHibrido.toStringAsFixed(2)}';
    }
  }

  /// Método público para obter a configuração de comissão atual
  CommissionConfigModel? getCommissionConfig() {
    if (!_comissaoAtiva || _tipoSelecionado == null) return null;

    switch (_tipoSelecionado!) {
      case TipoComissao.percentual:
        return CommissionConfigModel(
          type: 'PERCENTAGE',
          percentage: _percentual,
          isActive: true,
        );
      case TipoComissao.valorFixo:
        return CommissionConfigModel(
          type: 'FIXED_VALUE',
          fixedAmount: _valorFixo,
          isActive: true,
        );
      case TipoComissao.escalonada:
        final tiers = _faixas
            .map(
              (faixa) => CommissionTierModel(
                minAmount: faixa.valorMinimo,
                maxAmount: faixa.valorMaximo,
                percentage: faixa.percentual,
                fixedAmount: faixa.valorFixo,
              ),
            )
            .toList();
        return CommissionConfigModel(
          type: 'TIERED',
          tiers: tiers,
          isActive: true,
        );
      case TipoComissao.hibrida:
        return CommissionConfigModel(
          type: 'HYBRID',
          percentage: _percentualHibrido,
          fixedAmount: _valorFixoHibrido,
          isActive: true,
        );
    }
  }
}
