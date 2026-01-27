// lib/presentation/viewmodels/onboarding/onboarding_state.dart
part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingComplete extends OnboardingState {
  final bool hasSeenOnboarding;
  
  const OnboardingComplete(this.hasSeenOnboarding);
  
  @override
  List<Object> get props => [hasSeenOnboarding];
}