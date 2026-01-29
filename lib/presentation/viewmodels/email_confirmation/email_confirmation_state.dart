abstract class EmailConfirmationState {}

class EmailConfirmationInitial extends EmailConfirmationState {}

class EmailConfirmationLoading extends EmailConfirmationState {}

class EmailConfirmationResent extends EmailConfirmationState {
  final String message;
  EmailConfirmationResent(this.message);
}

class EmailConfirmationFailure extends EmailConfirmationState {
  final String message;
  EmailConfirmationFailure(this.message);
}
