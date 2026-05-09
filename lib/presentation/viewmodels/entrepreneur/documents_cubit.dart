import 'package:flutter_bloc/flutter_bloc.dart';
import 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit() : super(const DocumentsInitial());

  // Sample data - replace with backend API calls
  final List<DocumentModel> _documents = [
    DocumentModel(
      id: 1,
      name: 'Cédula de Identidad',
      status: 'Verificado',
      fileUrl: 'https://example.com/cedula.pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 20)),
      verifiedAt: DateTime.now().subtract(const Duration(days: 18)),
    ),
    DocumentModel(
      id: 2,
      name: 'RUC/NIT',
      status: 'Pendiente de revisión',
      fileUrl: 'https://example.com/ruc.pdf',
      uploadedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    DocumentModel(
      id: 3,
      name: 'Certificado Bancario',
      status: 'Rechazado',
      fileUrl: 'https://example.com/certificado.pdf',
      rejectReason:
          'Documento no válido o expirado. Por favor, carga nuevamente.',
      uploadedAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
  ];

  /// Load all documents
  void loadDocuments() {
    emit(const DocumentsLoading());
    try {
      // TODO: Replace with actual API call
      // final documents = await entrepreneurRepository.getDocuments();
      emit(DocumentsLoaded(_documents));
    } catch (e) {
      emit(DocumentsError('Error al cargar documentos: ${e.toString()}'));
    }
  }

  /// Upload document
  void uploadDocument({
    required String documentName,
    required String filePath,
  }) {
    emit(const DocumentsLoading());
    try {
      // TODO: Replace with actual API call and file upload
      // Simulate file upload progress
      final existingIndex = _documents.indexWhere(
        (doc) => doc.name == documentName,
      );

      if (existingIndex != -1) {
        _documents[existingIndex] = _documents[existingIndex].copyWith(
          status: 'Pendiente de revisión',
          uploadedAt: DateTime.now(),
          rejectReason: null,
        );
      }

      emit(DocumentUploaded(_documents[existingIndex]));
      loadDocuments();
    } catch (e) {
      emit(DocumentsError('Error al cargar documento: ${e.toString()}'));
    }
  }

  /// Get document by name
  DocumentModel? getDocumentByName(String name) {
    try {
      return _documents.firstWhere((doc) => doc.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Check if all documents are verified
  bool allDocumentsVerified() {
    return _documents.every((doc) => doc.isVerified);
  }

  /// Get verification progress
  int getVerificationProgress() {
    final verified = _documents.where((doc) => doc.isVerified).length;
    return ((verified / _documents.length) * 100).toInt();
  }
}
