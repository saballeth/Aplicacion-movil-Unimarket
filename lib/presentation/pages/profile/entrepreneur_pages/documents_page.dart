import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/entrepreneur/documents_cubit.dart';
import 'package:unimarket/presentation/viewmodels/entrepreneur/documents_state.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DocumentsCubit>()..loadDocuments(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Documentos'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<DocumentsCubit, DocumentsState>(
          listener: (context, state) {
            if (state is DocumentsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is DocumentUploaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Documento cargado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<DocumentsCubit>().loadDocuments();
            }
          },
          builder: (context, state) {
            if (state is DocumentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DocumentsLoaded) {
              final documents = state.documents;
              final verificationProgress = context
                  .read<DocumentsCubit>()
                  .getVerificationProgress();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B2AAD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF4B2AAD).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: const Color(0xFF4B2AAD),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Todos los documentos son verificados de forma segura',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF4B2AAD),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: verificationProgress / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation(
                              verificationProgress == 100
                                  ? Colors.green
                                  : const Color(0xFF4B2AAD),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Verificación: $verificationProgress%',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...documents.map((doc) => _buildDocumentCard(context, doc)),
                ],
              );
            }

            if (state is DocumentsError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, DocumentModel document) {
    late Color statusColor;
    late IconData statusIcon;

    if (document.isVerified) {
      statusColor = Colors.green;
      statusIcon = Icons.verified;
    } else if (document.isRejected) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.schedule;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                document.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      document.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Cargado: ${document.uploadedAt.toString().split(' ')[0]}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          if (document.isRejected && document.rejectReason != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Motivo del rechazo: ${document.rejectReason}',
                    style: TextStyle(fontSize: 11, color: Colors.red[700]),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showViewDocumentDialog(context, document),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Ver'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4B2AAD),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showUploadDocumentDialog(context, document),
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Cargar'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showViewDocumentDialog(BuildContext context, DocumentModel document) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(document.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: document.fileUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        document.fileUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Estado: ${document.status}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (document.verifiedAt != null)
              Text(
                'Verificado: ${document.verifiedAt.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showUploadDocumentDialog(BuildContext context, DocumentModel document) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cargar ${document.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload, size: 40, color: Colors.grey[600]),
                  const SizedBox(height: 12),
                  Text(
                    'Selecciona o arrastra tu archivo aquí',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Formatos soportados: PDF, JPG, PNG',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              context.read<DocumentsCubit>().uploadDocument(
                documentName: document.name,
                filePath: 'mock_file_path',
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Cargar'),
          ),
        ],
      ),
    );
  }
}
