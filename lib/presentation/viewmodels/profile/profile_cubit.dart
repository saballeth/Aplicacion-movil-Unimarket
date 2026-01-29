import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Simulated user; replace with repository/usecase in domain layer.
      final user = UserModel(
        id: 'USR001',
        name: 'Diego Oñate',
        email: 'diegoonate3028@gmail.com',
        avatarUrl: null,
      );
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileFailure('No se pudo cargar el perfil'));
    }
  }
}
