// lib/presentation/viewmodels/onboarding/onboarding_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  static const String _onboardingKey = 'has_seen_onboarding';
  
  final SharedPreferences preferences;
  
  OnboardingCubit(this.preferences) : super(OnboardingInitial()) {
    checkOnboardingStatus();
  }
  
  Future<void> checkOnboardingStatus() async {
    emit(OnboardingLoading());
    
    final hasSeen = preferences.getBool(_onboardingKey) ?? false;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(OnboardingComplete(hasSeen));
  }
  
  Future<void> markOnboardingAsSeen() async {
    await preferences.setBool(_onboardingKey, true);
    emit(OnboardingComplete(true));
  }
  
  Future<void> resetOnboarding() async {
    await preferences.setBool(_onboardingKey, false);
    emit(OnboardingComplete(false));
  }
}