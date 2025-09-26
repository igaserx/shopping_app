
import 'package:shopping_app/features/profile/models/profile_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  
  const ProfileLoaded(this.profile);
}
class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
}