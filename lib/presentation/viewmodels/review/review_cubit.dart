import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  Future<void> loadReviews(String productId) async {
    emit(ReviewLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = prefs.getStringList('reviews_$productId') ?? [];
      final reviews = reviewsJson
          .map((e) => ReviewModel.fromMap(jsonDecode(e) as Map<String, dynamic>))
          .toList();
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewFailure('Error cargando reseñas'));
    }
  }

  Future<void> submitReview(ReviewModel review) async {
    emit(ReviewSubmitting());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final prefs = await SharedPreferences.getInstance();
      final key = 'reviews_${review.productId}';
      final reviewsJson = prefs.getStringList(key) ?? [];
      reviewsJson.add(jsonEncode(review.toMap()));
      await prefs.setStringList(key, reviewsJson);
      emit(ReviewSubmitted(review));
    } catch (e) {
      emit(ReviewFailure('Error enviando reseña'));
    }
  }
}
