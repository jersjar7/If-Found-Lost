// lib/presentation/pages/qr_code/qr_code_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/presentation/bloc/qr_code/qr_code_bloc.dart';
import 'package:if_found_lost/presentation/pages/qr_code/qr_code_edit_page.dart';
import 'package:if_found_lost/presentation/pages/qr_code/qr_scan_history_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeDetailPage extends StatefulWidget {
  final String qrCodeId;

  const QRCodeDetailPage({super.key, required this.qrCodeId});

  @override
  State<QRCodeDetailPage> createState() => _QRCodeDetailPageState();
}

class _QRCodeDetailPageState extends State<QRCodeDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadQRCode();
  }

  void _loadQRCode() {
    context.read<QRCodeBloc>().add(
      LoadQRCodeByIdEvent(qrCodeId: widget.qrCodeId),
    );
  }

  void _generateQRCode() {
    context.read<QRCodeBloc>().add(
      GenerateQRCodeContentEvent(qrCodeId: widget.qrCodeId),
    );
  }

  void _deleteQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete QR Code'),
            content: const Text(
              'Are you sure you want to delete this QR code? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<QRCodeBloc>().add(
                    DeleteQRCodeEvent(qrCodeId: widget.qrCodeId),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final state = context.read<QRCodeBloc>().state;
              if (state is QRCodeLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeEditPage(qrCode: state.qrCode),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteQRCode(context),
          ),
        ],
      ),
      body: BlocConsumer<QRCodeBloc, QRCodeState>(
        listener: (context, state) {
          if (state is QRCodeDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR code deleted successfully')),
            );
            Navigator.pop(context);
          } else if (state is QRCodeError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is QRCodeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QRCodeLoaded) {
            return _buildQRCodeDetails(context, state.qrCode);
          } else if (state is QRCodeContentGenerated) {
            return _buildQRCodeWithContent(context, state);
          } else if (state is QRCodeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading QR code',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadQRCode,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildQRCodeDetails(BuildContext context, QRCodeEntity qrCode) {
    final dateFormat = DateFormat('MMMM d, yyyy');

    // Generate QR code content if not already generated
    if (context.read<QRCodeBloc>().state is! QRCodeContentGenerated) {
      _generateQRCode();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QR Code display placeholder
          const Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Card(
                elevation: 4,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Item details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    qrCode.itemName ?? 'Unnamed Item',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (qrCode.itemDescription != null) ...[
                    Text(
                      qrCode.itemDescription!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Contact info
                  const Text(
                    'Contact Information:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    qrCode.ownerContactInfo ??
                        'No contact information provided',
                  ),
                  const SizedBox(height: 16),

                  // Reward if any
                  if (qrCode.reward != null) ...[
                    const Text(
                      'Reward:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(qrCode.reward!),
                    const SizedBox(height: 16),
                  ],

                  // Creation date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text('Created on ${dateFormat.format(qrCode.createdAt)}'),
                    ],
                  ),

                  // Active status
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        qrCode.isActive ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: qrCode.isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        qrCode.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: qrCode.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tags
          if (qrCode.tags != null && qrCode.tags!.isNotEmpty) ...[
            Text('Tags', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  qrCode.tags!.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.shade50,
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Scan history button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScanHistoryPage(qrCodeId: qrCode.id),
                ),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('View Scan History'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeWithContent(
    BuildContext context,
    QRCodeContentGenerated state,
  ) {
    return BlocBuilder<QRCodeBloc, QRCodeState>(
      builder: (context, qrState) {
        QRCodeEntity? qrCode;
        if (qrState is QRCodeLoaded) {
          qrCode = qrState.qrCode;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // QR Code with generated content
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      QrImageView(
                        data: state.content,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text('Scan this QR code to help return the item'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              state.content,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: state.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied to clipboard'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy URL'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Share functionality would be implemented here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share functionality coming soon'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('Share QR Code'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Item details section
              if (qrCode != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          qrCode.itemName ?? 'Unnamed Item',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (qrCode.itemDescription != null) ...[
                          const SizedBox(height: 8),
                          Text(qrCode.itemDescription!),
                        ],
                        // Other QR code details
                        // ...
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Scan history button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                QRScanHistoryPage(qrCodeId: widget.qrCodeId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('View Scan History'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
