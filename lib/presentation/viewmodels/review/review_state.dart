part of 'review_cubit.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  ReviewsLoaded(this.reviews);
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitted extends ReviewState {
  final ReviewModel review;
  ReviewSubmitted(this.review);
}

class ReviewFailure extends ReviewState {
  final String message;
  ReviewFailure(this.message);
}
