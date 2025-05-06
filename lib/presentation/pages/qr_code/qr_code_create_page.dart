// lib/presentation/pages/qr_code/qr_code_create_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:if_found_lost/presentation/bloc/auth/auth_bloc.dart';
import 'package:if_found_lost/presentation/bloc/qr_code/qr_code_bloc.dart';

class QRCodeCreatePage extends StatefulWidget {
  const QRCodeCreatePage({super.key});

  @override
  State<QRCodeCreatePage> createState() => _QRCodeCreatePageState();
}

class _QRCodeCreatePageState extends State<QRCodeCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _ownerContactInfoController = TextEditingController();
  final _rewardController = TextEditingController();
  final List<String> _tags = [];
  final _tagController = TextEditingController();
  String? _imageUrl; // Will be implemented with Firebase Storage

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _ownerContactInfoController.dispose();
    _rewardController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty &&
        !_tags.contains(_tagController.text)) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm(String userId) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<QRCodeBloc>().add(
        CreateQRCodeEvent(
          userId: userId,
          itemName: _itemNameController.text,
          itemDescription: _itemDescriptionController.text,
          ownerContactInfo: _ownerContactInfoController.text,
          reward:
              _rewardController.text.isNotEmpty ? _rewardController.text : null,
          tags: _tags.isNotEmpty ? _tags : null,
          imageUrl: _imageUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create QR Code')),
      body: BlocListener<QRCodeBloc, QRCodeState>(
        listener: (context, state) {
          if (state is QRCodeCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR Code created successfully')),
            );
            Navigator.pop(context);
          } else if (state is QRCodeError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return _buildForm(context, authState.user.id);
            } else {
              return const Center(
                child: Text('You need to be logged in to create QR codes'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, String userId) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image selector (placeholder for now)
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add Item Photo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Item name
            TextFormField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                labelText: 'Item Name*',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the item name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Item description
            TextFormField(
              controller: _itemDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Item Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Owner contact info
            TextFormField(
              controller: _ownerContactInfoController,
              decoration: const InputDecoration(
                labelText: 'Your Contact Information*',
                border: OutlineInputBorder(),
                hintText: 'Phone number or email where someone can reach you',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact information';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Reward
            TextFormField(
              controller: _rewardController,
              decoration: const InputDecoration(
                labelText: 'Reward (optional)',
                border: OutlineInputBorder(),
                hintText: 'e.g., \$20 reward if found',
              ),
            ),
            const SizedBox(height: 24),
            // Tags
            Text('Tags', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      hintText:
                          'Add a tag (e.g., "keys", "pet", "electronics")',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add_circle),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeTag(tag),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 32),
            // Submit button
            BlocBuilder<QRCodeBloc, QRCodeState>(
              builder: (context, state) {
                final isLoading = state is QRCodeLoading;

                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _submitForm(userId),
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Create QR Code'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
