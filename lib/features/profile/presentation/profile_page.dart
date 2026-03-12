import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/meudia_card.dart';
import '../presentation/profile_bloc.dart';
import '../../auth/presentation/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () => getIt<AuthBloc>().add(const AuthLogoutRequested()),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(const ProfileRequested());
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading ||
                state.status == ProfileStatus.initial) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [LoadingSkeleton(height: 180)],
              );
            }
            if (state.status == ProfileStatus.failure) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  MeuDiaCard(child: Text(state.failure?.message ?? 'Erro ao carregar perfil.')),
                ],
              );
            }
            final profile = state.profile!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MeuDiaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text('Cartão SUS: ${profile.susCard}'),
                      Text('Unidade vinculada: ${profile.linkedUnit ?? 'Não informada'}'),
                      Text('Idade: ${profile.age ?? '-'}'),
                      Text('Sexo: ${profile.gender ?? '-'}'),
                      Text('Último risco estratificado: ${profile.lastRisk ?? '-'}'),
                    ],
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
