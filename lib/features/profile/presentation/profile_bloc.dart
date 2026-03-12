import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../domain/profile_entity.dart';
import '../domain/profile_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getProfileUseCase) : super(const ProfileState.initial()) {
    on<ProfileRequested>(_onRequested);
  }

  final GetProfileUseCase _getProfileUseCase;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearFailure: true));
    final result = await _getProfileUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.failure, failure: failure)),
      (profile) => emit(state.copyWith(status: ProfileStatus.success, profile: profile)),
    );
  }
}
