part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    required this.status,
    this.profile,
    this.failure,
  });

  const ProfileState.initial() : this(status: ProfileStatus.initial);

  final ProfileStatus status;
  final ProfileEntity? profile;
  final Failure? failure;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, profile, failure];
}
