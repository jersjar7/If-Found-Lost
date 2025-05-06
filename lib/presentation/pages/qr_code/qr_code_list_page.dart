// lib/presentation/pages/qr_code/qr_code_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/presentation/bloc/auth/auth_bloc.dart';
import 'package:if_found_lost/presentation/bloc/qr_code/qr_code_bloc.dart';
import 'package:if_found_lost/presentation/pages/qr_code/qr_code_create_page.dart';
import 'package:if_found_lost/presentation/pages/qr_code/qr_code_detail_page.dart';
import 'package:if_found_lost/presentation/widgets/qr_code/qr_code_list_item.dart';

class QRCodeListPage extends StatelessWidget {
  const QRCodeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          // Load user's QR codes when authenticated
          context.read<QRCodeBloc>().add(
            LoadUserQRCodesEvent(userId: authState.user.id),
          );

          return Scaffold(
            appBar: AppBar(title: const Text('My QR Codes')),
            body: BlocBuilder<QRCodeBloc, QRCodeState>(
              builder: (context, state) {
                if (state is QRCodeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is QRCodesLoaded) {
                  final qrCodes = state.qrCodes;

                  if (qrCodes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.qr_code_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No QR codes yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create your first QR code sticker',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _navigateToCreatePage(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Create QR Code'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<QRCodeBloc>().add(
                        LoadUserQRCodesEvent(userId: authState.user.id),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: qrCodes.length,
                      itemBuilder: (context, index) {
                        final qrCode = qrCodes[index];
                        return QRCodeListItem(
                          qrCode: qrCode,
                          onTap: () => _navigateToDetailPage(context, qrCode),
                        );
                      },
                    ),
                  );
                } else if (state is QRCodeError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading QR codes',
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
                          onPressed: () {
                            context.read<QRCodeBloc>().add(
                              LoadUserQRCodesEvent(userId: authState.user.id),
                            );
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _navigateToCreatePage(context),
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('My QR Codes')),
            body: const Center(
              child: Text('You need to be logged in to view your QR codes'),
            ),
          );
        }
      },
    );
  }

  void _navigateToDetailPage(BuildContext context, QRCodeEntity qrCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeDetailPage(qrCodeId: qrCode.id),
      ),
    );
  }

  void _navigateToCreatePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRCodeCreatePage()),
    );
  }
}
