import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/meudia_button.dart';
import '../../../core/widgets/meudia_card.dart';
import '../../../core/widgets/meudia_text_field.dart';
import '../domain/glycemia_entities.dart';
import 'glycemia_bloc.dart';

class GlycemiaRegisterPage extends StatefulWidget {
  const GlycemiaRegisterPage({super.key});

  @override
  State<GlycemiaRegisterPage> createState() => _GlycemiaRegisterPageState();
}

class _GlycemiaRegisterPageState extends State<GlycemiaRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _dateController = TextEditingController();
  String _moment = 'jejum';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = _selectedDate.toIso8601String().substring(0, 16);
  }

  @override
  void dispose() {
    _valueController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _dateController.text = _selectedDate.toIso8601String().substring(0, 16);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova glicemia')),
      body: BlocConsumer<GlycemiaBloc, GlycemiaState>(
        listener: (context, state) {
          if (state.feedbackMessage != null && state.status == GlycemiaStatus.success) {
            context.pop();
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              MeuDiaCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registre sua leitura com calma. O valor deve ficar entre 20 e 600 mg/dL.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      MeuDiaTextField(
                        controller: _valueController,
                        label: 'Valor (mg/dL)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final parsed = int.tryParse(value ?? '');
                          if (parsed == null) {
                            return 'Digite um valor válido.';
                          }
                          if (parsed < 20 || parsed > 600) {
                            return 'A glicemia deve estar entre 20 e 600.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _moment,
                        items: const [
                          DropdownMenuItem(value: 'jejum', child: Text('Jejum')),
                          DropdownMenuItem(
                            value: 'pos_prandial',
                            child: Text('Após refeição'),
                          ),
                          DropdownMenuItem(value: 'aleatorio', child: Text('Aleatório')),
                        ],
                        onChanged: (value) => setState(() => _moment = value ?? 'jejum'),
                        decoration: const InputDecoration(labelText: 'Momento'),
                      ),
                      const SizedBox(height: 16),
                      MeuDiaTextField(
                        controller: _dateController,
                        label: 'Data e hora',
                        readOnly: true,
                        onTap: _pickDate,
                        validator: (_) {
                          if (_selectedDate.isAfter(DateTime.now())) {
                            return 'A data do registro não pode estar no futuro.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      MeuDiaButton(
                        label: 'Salvar leitura',
                        icon: Icons.save_outlined,
                        isLoading: state.isSubmitting,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<GlycemiaBloc>().add(
                                  GlycemiaSubmitted(
                                    GlycemiaInput(
                                      value: int.parse(_valueController.text),
                                      moment: _moment,
                                      recordedAt: _selectedDate,
                                    ),
                                  ),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
