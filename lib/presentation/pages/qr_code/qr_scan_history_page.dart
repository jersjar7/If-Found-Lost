// lib/presentation/pages/qr_code/qr_scan_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:if_found_lost/domain/repositories/qr_code_repository.dart';
import 'package:if_found_lost/presentation/bloc/qr_code/qr_code_bloc.dart';
import 'package:intl/intl.dart';

class QRScanHistoryPage extends StatefulWidget {
  final String qrCodeId;

  const QRScanHistoryPage({super.key, required this.qrCodeId});

  @override
  State<QRScanHistoryPage> createState() => _QRScanHistoryPageState();
}

class _QRScanHistoryPageState extends State<QRScanHistoryPage> {
  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  void _loadScanHistory() {
    context.read<QRCodeBloc>().add(
      LoadQRCodeScanHistoryEvent(qrCodeId: widget.qrCodeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan History')),
      body: BlocBuilder<QRCodeBloc, QRCodeState>(
        builder: (context, state) {
          if (state is QRCodeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QRCodeScanHistoryLoaded) {
            final scanHistory = state.scanHistory;

            if (scanHistory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No scan history yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your QR code has not been scanned yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scanHistory.length,
              itemBuilder: (context, index) {
                final scan = scanHistory[index];
                return _buildScanHistoryItem(context, scan, index);
              },
            );
          } else if (state is QRCodeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading scan history',
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
                    onPressed: _loadScanHistory,
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

  Widget _buildScanHistoryItem(
    BuildContext context,
    QRScanEntity scan,
    int index,
  ) {
    final dateFormat = DateFormat('MMM d, yyyy - h:mm a');
    final formattedDate = dateFormat.format(scan.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'IP: ${scan.scannerIp}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (scan.scannerLocation != null) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scan.scannerLocation!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
            if (scan.message != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Message:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(scan.message!, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
