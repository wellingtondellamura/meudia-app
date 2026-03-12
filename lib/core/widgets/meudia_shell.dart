import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MeuDiaShell extends StatelessWidget {
  const MeuDiaShell({required this.child, super.key});

  final Widget child;

  static const _tabs = [
    ('/dashboard', 'Início', Icons.home_rounded),
    ('/glycemia', 'Glicemia', Icons.monitor_heart_outlined),
    ('/consultations', 'Consultas', Icons.calendar_month_outlined),
    ('/profile', 'Perfil', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.$1));

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.$3),
                label: tab.$2,
              ),
            )
            .toList(),
        onDestinationSelected: (value) => context.go(_tabs[value].$1),
      ),
    );
  }
}
