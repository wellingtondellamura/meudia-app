import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.name,
    required this.susCard,
    required this.linkedUnit,
    required this.age,
    required this.gender,
    required this.lastRisk,
  });

  final int id;
  final String name;
  final String susCard;
  final String? linkedUnit;
  final int? age;
  final String? gender;
  final String? lastRisk;

  @override
  List<Object?> get props => [
        id,
        name,
        susCard,
        linkedUnit,
        age,
        gender,
        lastRisk,
      ];
}
