import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/meudia_button.dart';
import '../../../core/widgets/meudia_card.dart';
import '../domain/dashboard_entities.dart';
import 'dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MeuDia')),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const DashboardLoaded());
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.loading ||
                state.status == DashboardStatus.initial) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  LoadingSkeleton(height: 150),
                  SizedBox(height: 16),
                  LoadingSkeleton(height: 120),
                  SizedBox(height: 16),
                  LoadingSkeleton(height: 96),
                ],
              );
            }

            if (state.status == DashboardStatus.failure) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  MeuDiaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Não foi possível carregar o dashboard.',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(state.failure?.message ?? ''),
                        const SizedBox(height: 16),
                        MeuDiaButton(
                          label: 'Tentar novamente',
                          icon: Icons.refresh_rounded,
                          onPressed: () => context
                              .read<DashboardBloc>()
                              .add(const DashboardLoaded()),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final dashboard = state.dashboard!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Header(dashboard: dashboard),
                const SizedBox(height: 16),
                if (dashboard.nextConsultation != null)
                  _SectionCard(
                    title: 'Próxima consulta',
                    icon: Icons.calendar_month_outlined,
                    child: Text(
                      '${dashboard.nextConsultation!.data} • '
                      '${dashboard.nextConsultation!.horaInicio} com '
                      '${dashboard.nextConsultation!.professional}\n'
                      '${dashboard.nextConsultation!.unit}',
                    ),
                  ),
                const SizedBox(height: 16),
                if (dashboard.latestGlycemia != null)
                  _SectionCard(
                    title: 'Última glicemia',
                    icon: Icons.monitor_heart_outlined,
                    child: Text(
                      '${dashboard.latestGlycemia!.value} mg/dL • '
                      '${dashboard.latestGlycemia!.momentLabel}\n'
                      '${dashboard.latestGlycemia!.recordedAt} • '
                      '${dashboard.latestGlycemia!.origin}',
                    ),
                  ),
                const SizedBox(height: 16),
                if (dashboard.carePlan != null)
                  _SectionCard(
                    title: 'Plano de cuidados',
                    icon: Icons.assignment_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dashboard.carePlan!.diagnoses
                          .take(2)
                          .map(
                            (diagnosis) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                '${diagnosis.title}\n'
                                '${diagnosis.plans.join(' • ')}',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Alertas clínicos',
                  icon: Icons.notifications_active_outlined,
                  child: dashboard.alerts.isEmpty
                      ? const Text('Nenhum alerta ativo no momento.')
                      : Column(
                          children: dashboard.alerts
                              .map((alert) => _AlertTile(alert: alert))
                              .toList(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.dashboard});

  final DashboardEntity dashboard;

  @override
  Widget build(BuildContext context) {
    final risk = dashboard.risk ?? 'sem classificação';
    return MeuDiaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que merece sua atenção hoje',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            dashboard.alerts.isEmpty
                ? 'Seu painel está estável. Continue acompanhando seus registros.'
                : dashboard.alerts.first.message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Chip(
            label: Text('Risco atual: $risk'),
            avatar: Icon(
              Icons.shield_outlined,
              color: risk == 'alto' ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MeuDiaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final ClinicalAlertEntity alert;

  @override
  Widget build(BuildContext context) {
    final color = alert.level == 'vermelho' ? AppColors.error : AppColors.warning;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(alert.message),
    );
  }
}
