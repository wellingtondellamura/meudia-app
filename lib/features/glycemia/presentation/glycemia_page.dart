import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/meudia_button.dart';
import '../../../core/widgets/meudia_card.dart';
import '../domain/glycemia_entities.dart';
import 'glycemia_bloc.dart';

class GlycemiaPage extends StatelessWidget {
  const GlycemiaPage({super.key});

  static const _periods = ['7d', '30d', '90d'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlycemiaBloc, GlycemiaState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage ||
          previous.failure != current.failure,
      listener: (context, state) {
        final message = state.feedbackMessage ?? state.failure?.message;
        if (message != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Glicemia'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () => context.go('/glycemia/register'),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<GlycemiaBloc>()
                .add(GlycemiaPeriodChanged(context.read<GlycemiaBloc>().state.selectedPeriod));
          },
          child: BlocBuilder<GlycemiaBloc, GlycemiaState>(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Wrap(
                    spacing: 8,
                    children: _periods
                        .map(
                          (period) => ChoiceChip(
                            label: Text(period),
                            selected: state.selectedPeriod == period,
                            onSelected: (_) => context
                                .read<GlycemiaBloc>()
                                .add(GlycemiaPeriodChanged(period)),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  if (state.status == GlycemiaStatus.loading &&
                      state.history.isEmpty) ...const [
                    LoadingSkeleton(height: 220),
                    SizedBox(height: 16),
                    LoadingSkeleton(height: 88),
                  ] else ...[
                    _ChartCard(state: state),
                    const SizedBox(height: 16),
                    MeuDiaButton(
                      label: 'Registrar nova leitura',
                      icon: Icons.edit_outlined,
                      onPressed: () => context.go('/glycemia/register'),
                    ),
                    const SizedBox(height: 16),
                    ...state.history.map(_HistoryTile.new),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.state});

  final GlycemiaState state;

  @override
  Widget build(BuildContext context) {
    final chart = state.chart;
    return MeuDiaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Evolução', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Média ${chart.average} mg/dL • mínimo ${chart.min} • máximo ${chart.max}',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              duration: const Duration(milliseconds: 600),
              LineChartData(
                minY: 20,
                maxY: 300,
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= chart.labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            chart.labels[index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: chart.values
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                        .toList(),
                    isCurved: true,
                    color: AppColors.glucose,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(y: 130, color: AppColors.success.withValues(alpha: 0.4)),
                    HorizontalLine(y: 250, color: AppColors.warning.withValues(alpha: 0.4)),
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

class _HistoryTile extends StatelessWidget {
  const _HistoryTile(this.item);

  final GlycemiaEntity item;

  Color _background() {
    final value = item.value;
    if (value < 70 || value > 250) {
      return AppColors.error.withValues(alpha: 0.1);
    }
    if (value > 130) {
      return AppColors.warning.withValues(alpha: 0.12);
    }
    return AppColors.success.withValues(alpha: 0.12);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MeuDiaCard(
        child: MergeSemantics(
          child: Container(
            decoration: BoxDecoration(
              color: _background(),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.value} mg/dL\n${item.momentLabel} • ${item.recordedAt}',
                  ),
                ),
                Text(item.origin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
