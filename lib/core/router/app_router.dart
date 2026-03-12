import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/auth_bloc.dart';
import '../../features/consultations/presentation/consultation_bloc.dart';
import '../../features/consultations/presentation/consultation_page.dart';
import '../../features/dashboard/presentation/dashboard_bloc.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/glycemia/presentation/glycemia_bloc.dart';
import '../../features/glycemia/presentation/glycemia_page.dart';
import '../../features/glycemia/presentation/glycemia_register_page.dart';
import '../../features/profile/presentation/profile_bloc.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../di/injection.dart';
import '../widgets/meudia_shell.dart';

class AppRouter {
  AppRouter(this._authBloc);

  final AuthBloc _authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: (context, state) {
      final isAuthenticated =
          _authBloc.state.status == AuthStatus.authenticated;
      final goingToLogin = state.matchedLocation == '/login';
      if (!isAuthenticated && !goingToLogin) {
        return '/login';
      }
      if (isAuthenticated && goingToLogin) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: BlocProvider.value(
            value: getIt<AuthBloc>(),
            child: const LoginPage(),
          ),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MeuDiaShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => _slidePage(
              state: state,
              child: BlocProvider(
                create: (_) => getIt<DashboardBloc>()..add(const DashboardLoaded()),
                child: const DashboardPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/glycemia',
            pageBuilder: (context, state) => _slidePage(
              state: state,
              child: BlocProvider(
                create: (_) => getIt<GlycemiaBloc>()..add(const GlycemiaStarted()),
                child: const GlycemiaPage(),
              ),
            ),
            routes: [
              GoRoute(
                path: 'register',
                pageBuilder: (context, state) => _slidePage(
                  state: state,
                  child: BlocProvider(
                    create: (_) => getIt<GlycemiaBloc>(),
                    child: const GlycemiaRegisterPage(),
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/consultations',
            pageBuilder: (context, state) => _slidePage(
              state: state,
              child: BlocProvider(
                create: (_) =>
                    getIt<ConsultationBloc>()..add(const ConsultationsRequested()),
                child: const ConsultationPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => _slidePage(
              state: state,
              child: BlocProvider(
                create: (_) => getIt<ProfileBloc>()..add(const ProfileRequested()),
                child: const ProfilePage(),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _slidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, widget) {
      final tween = Tween<Offset>(
        begin: const Offset(0.08, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: widget);
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
