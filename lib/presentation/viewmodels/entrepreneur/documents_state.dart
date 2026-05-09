import 'package:equatable/equatable.dart';

/// Estados para el manejo de documentos
abstract class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object?> get props => [];
}

class DocumentsInitial extends DocumentsState {
  const DocumentsInitial();
}

class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

class DocumentsLoaded extends DocumentsState {
  final List<DocumentModel> documents;

  const DocumentsLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}

class DocumentUploading extends DocumentsState {
  final String documentName;
  final double progress;

  const DocumentUploading({required this.documentName, required this.progress});

  @override
  List<Object?> get props => [documentName, progress];
}

class DocumentUploaded extends DocumentsState {
  final DocumentModel document;

  const DocumentUploaded(this.document);

  @override
  List<Object?> get props => [document];
}

class DocumentsError extends DocumentsState {
  final String message;

  const DocumentsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Modelo de documento
class DocumentModel extends Equatable {
  final int id;
  final String name; // 'Cédula', 'RUC', 'Certificado Bancario'
  final String status; // 'Verificado', 'Pendiente', 'Rechazado'
  final String? fileUrl;
  final String? rejectReason;
  final DateTime uploadedAt;
  final DateTime? verifiedAt;

  const DocumentModel({
    required this.id,
    required this.name,
    required this.status,
    this.fileUrl,
    this.rejectReason,
    required this.uploadedAt,
    this.verifiedAt,
  });

  bool get isVerified => status == 'Verificado';
  bool get isPending => status == 'Pendiente de revisión';
  bool get isRejected => status == 'Rechazado';

  DocumentModel copyWith({
    int? id,
    String? name,
    String? status,
    String? fileUrl,
    String? rejectReason,
    DateTime? uploadedAt,
    DateTime? verifiedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
      rejectReason: rejectReason ?? this.rejectReason,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    fileUrl,
    rejectReason,
    uploadedAt,
    verifiedAt,
  ];
}
