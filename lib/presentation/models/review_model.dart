class ReviewModel {
  final String id;
  final String productId;
  final String productName;
  final String sellerName;
  final int rating; // 1-5 estrellas
  final String title;
  final String comment;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final bool isVisible; // True = visible públicamente

  ReviewModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sellerName,
    required this.rating,
    required this.title,
    required this.comment,
    required this.userId,
    required this.userName,
    required this.createdAt,
    this.isVisible = true,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
    id: map['id'] as String,
    productId: map['productId'] as String,
    productName: map['productName'] as String,
    sellerName: map['sellerName'] as String,
    rating: map['rating'] as int,
    title: map['title'] as String,
    comment: map['comment'] as String,
    userId: map['userId'] as String,
    userName: map['userName'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    isVisible: map['isVisible'] as bool? ?? true,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'sellerName': sellerName,
    'rating': rating,
    'title': title,
    'comment': comment,
    'userId': userId,
    'userName': userName,
    'createdAt': createdAt.toIso8601String(),
    'isVisible': isVisible,
  };

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Hace 1 día';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return 'Hace $weeks semana${weeks > 1 ? 's' : ''}';
    } else {
      final months = difference.inDays ~/ 30;
      return 'Hace $months mes${months > 1 ? 'es' : ''}';
    }
  }

  double get averageRating => rating.toDouble();
}
