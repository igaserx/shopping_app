
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shopping_app/features/profile/cubit/profile_state.dart';
import 'package:shopping_app/features/profile/models/profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  static const String _profileKey = 'user_profile';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  ProfileCubit() : super(ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const ProfileError('User not authenticated'));
        return;
      }

   
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      UserProfileModel profile;
      
      if (profileJson != null) {
        
        final profileMap = jsonDecode(profileJson);
        profile = UserProfileModel.fromMap(profileMap);
      } else {
        
        profile = UserProfileModel(
          email: user.email ?? '',
          createdAt: user.metadata.creationTime,
          
        );
        await _saveProfile(profile);
      }
      
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }
  Future<void> _saveProfile(UserProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toMap());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      throw Exception('Failed to save profile');
    }
  }

  //! Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError('Failed to sign out: $e'));
    }
  }
}