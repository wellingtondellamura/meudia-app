import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/auth_remote_data_source.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/login_use_case.dart';
import '../../features/auth/domain/logout_use_case.dart';
import '../../features/auth/presentation/auth_bloc.dart';
import '../../features/consultations/data/consultation_remote_data_source.dart';
import '../../features/consultations/data/consultation_repository_impl.dart';
import '../../features/consultations/domain/consultation_repository.dart';
import '../../features/consultations/domain/consultation_use_cases.dart';
import '../../features/consultations/presentation/consultation_bloc.dart';
import '../../features/dashboard/data/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/dashboard_repository.dart';
import '../../features/dashboard/domain/get_dashboard_use_case.dart';
import '../../features/dashboard/presentation/dashboard_bloc.dart';
import '../../features/glycemia/data/glycemia_remote_data_source.dart';
import '../../features/glycemia/data/glycemia_repository_impl.dart';
import '../../features/glycemia/domain/glycemia_repository.dart';
import '../../features/glycemia/domain/glycemia_use_cases.dart';
import '../../features/glycemia/presentation/glycemia_bloc.dart';
import '../../features/profile/data/profile_remote_data_source.dart';
import '../../features/profile/data/profile_repository_impl.dart';
import '../../features/profile/domain/profile_repository.dart';
import '../../features/profile/domain/profile_use_case.dart';
import '../../features/profile/presentation/profile_bloc.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../network/session_storage.dart';
import '../router/app_router.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await getIt.reset();
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton(sharedPreferences)
    ..registerSingleton(const FlutterSecureStorage())
    ..registerLazySingleton(
      () => SessionStorage(getIt<FlutterSecureStorage>(), getIt<SharedPreferences>()),
    )
    ..registerSingleton(
      Dio(
        BaseOptions(
          baseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://meudia.uenp.edu.br/api/v1/paciente',
          ),
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: const {'Accept': 'application/json'},
        ),
      ),
    );

  getIt<Dio>().interceptors.add(
    AuthInterceptor(
      sessionStorage: getIt<SessionStorage>(),
      onUnauthorized: () async {
        await getIt<SessionStorage>().clear();
        getIt<AuthBloc>().add(const AuthSessionExpired());
        return false;
      },
    ),
  );

  getIt
    ..registerLazySingleton(() => ApiClient(getIt<Dio>()))
    ..registerLazySingleton(() => AuthRemoteDataSource(getIt<ApiClient>()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<SessionStorage>()),
    )
    ..registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()))
    ..registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()))
    ..registerSingleton(AuthBloc(getIt<LoginUseCase>(), getIt<LogoutUseCase>()))
    ..registerLazySingleton(() => DashboardRemoteDataSource(getIt<ApiClient>()))
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(getIt<DashboardRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetDashboardUseCase(getIt<DashboardRepository>()))
    ..registerFactory(() => DashboardBloc(getIt<GetDashboardUseCase>()))
    ..registerLazySingleton(() => GlycemiaRemoteDataSource(getIt<ApiClient>()))
    ..registerLazySingleton<GlycemiaRepository>(
      () => GlycemiaRepositoryImpl(getIt<GlycemiaRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetGlycemiaHistoryUseCase(getIt<GlycemiaRepository>()))
    ..registerLazySingleton(() => GetGlycemiaChartUseCase(getIt<GlycemiaRepository>()))
    ..registerLazySingleton(() => RegisterGlycemiaUseCase(getIt<GlycemiaRepository>()))
    ..registerFactory(
      () => GlycemiaBloc(
        getIt<GetGlycemiaHistoryUseCase>(),
        getIt<GetGlycemiaChartUseCase>(),
        getIt<RegisterGlycemiaUseCase>(),
      ),
    )
    ..registerLazySingleton(
      () => ConsultationRemoteDataSource(getIt<ApiClient>()),
    )
    ..registerLazySingleton<ConsultationRepository>(
      () => ConsultationRepositoryImpl(getIt<ConsultationRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetConsultationsUseCase(getIt<ConsultationRepository>()))
    ..registerLazySingleton(() => ConfirmConsultationUseCase(getIt<ConsultationRepository>()))
    ..registerLazySingleton(() => CancelConsultationUseCase(getIt<ConsultationRepository>()))
    ..registerLazySingleton(
      () => RescheduleConsultationUseCase(getIt<ConsultationRepository>()),
    )
    ..registerFactory(
      () => ConsultationBloc(
        getIt<GetConsultationsUseCase>(),
        getIt<ConfirmConsultationUseCase>(),
        getIt<CancelConsultationUseCase>(),
        getIt<RescheduleConsultationUseCase>(),
      ),
    )
    ..registerLazySingleton(() => ProfileRemoteDataSource(getIt<ApiClient>()))
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetProfileUseCase(getIt<ProfileRepository>()))
    ..registerFactory(() => ProfileBloc(getIt<GetProfileUseCase>()))
    ..registerLazySingleton(() => AppRouter(getIt<AuthBloc>()));
}
