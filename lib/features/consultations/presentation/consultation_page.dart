import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/meudia_card.dart';
import '../../../core/widgets/meudia_text_field.dart';
import '../domain/consultation_entity.dart';
import 'consultation_bloc.dart';

class ConsultationPage extends StatelessWidget {
  const ConsultationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConsultationBloc, ConsultationState>(
      listener: (context, state) {
        final message = state.feedbackMessage ?? state.failure?.message;
        if (message != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Consultas')),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ConsultationBloc>().add(const ConsultationsRequested());
          },
          child: BlocBuilder<ConsultationBloc, ConsultationState>(
            builder: (context, state) {
              if (state.status == ConsultationStatus.loading &&
                  state.consultations.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    LoadingSkeleton(height: 104),
                    SizedBox(height: 16),
                    LoadingSkeleton(height: 104),
                  ],
                );
              }
              if (state.consultations.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    MeuDiaCard(
                      child: Text('Nenhuma consulta futura disponível no momento.'),
                    ),
                  ],
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: state.consultations
                    .map((item) => _ConsultationTile(item: item))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ConsultationTile extends StatelessWidget {
  const _ConsultationTile({required this.item});

  final ConsultationEntity item;

  Future<void> _cancel(BuildContext context) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar consulta'),
        content: MeuDiaTextField(
          controller: controller,
          label: 'Motivo (opcional)',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      context
          .read<ConsultationBloc>()
          .add(ConsultationCancelled(item.id, reason: controller.text.trim()));
    }
    controller.dispose();
  }

  Future<void> _reschedule(BuildContext context) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reagendar consulta'),
        content: MeuDiaTextField(
          controller: controller,
          label: 'Novo slot ID',
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Fechar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reagendar'),
          ),
        ],
      ),
    );
    final slotId = int.tryParse(controller.text);
    if ((confirmed ?? false) && slotId != null && context.mounted) {
      context.read<ConsultationBloc>().add(ConsultationRescheduled(item.id, slotId));
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MeuDiaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.data} • ${item.horaInicio} - ${item.horaFim}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text('${item.professional}\n${item.unit}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: item.status == 'agendado'
                      ? () => context
                          .read<ConsultationBloc>()
                          .add(ConsultationConfirmed(item.id))
                      : null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirmar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _cancel(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancelar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _reschedule(context),
                  icon: const Icon(Icons.schedule),
                  label: const Text('Reagendar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
