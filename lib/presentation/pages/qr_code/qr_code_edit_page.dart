// lib/presentation/pages/qr_code/qr_code_edit_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/presentation/bloc/qr_code/qr_code_bloc.dart';

class QRCodeEditPage extends StatefulWidget {
  final QRCodeEntity qrCode;

  const QRCodeEditPage({super.key, required this.qrCode});

  @override
  State<QRCodeEditPage> createState() => _QRCodeEditPageState();
}

class _QRCodeEditPageState extends State<QRCodeEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _ownerContactInfoController;
  late TextEditingController _rewardController;
  late List<String> _tags;
  late final TextEditingController _tagController;
  late bool _isActive;
  String? _imageUrl; // Will be implemented with Firebase Storage

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing QR code data
    _itemNameController = TextEditingController(text: widget.qrCode.itemName);
    _itemDescriptionController = TextEditingController(
      text: widget.qrCode.itemDescription,
    );
    _ownerContactInfoController = TextEditingController(
      text: widget.qrCode.ownerContactInfo,
    );
    _rewardController = TextEditingController(text: widget.qrCode.reward);
    _tagController = TextEditingController();
    _tags = widget.qrCode.tags?.toList() ?? [];
    _isActive = widget.qrCode.isActive;
    _imageUrl = widget.qrCode.imageUrl;
  }

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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<QRCodeBloc>().add(
        UpdateQRCodeEvent(
          qrCodeId: widget.qrCode.id,
          itemName: _itemNameController.text,
          itemDescription: _itemDescriptionController.text,
          ownerContactInfo: _ownerContactInfoController.text,
          reward:
              _rewardController.text.isNotEmpty ? _rewardController.text : null,
          isActive: _isActive,
          tags: _tags.isNotEmpty ? _tags : null,
          imageUrl: _imageUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit QR Code')),
      body: BlocListener<QRCodeBloc, QRCodeState>(
        listener: (context, state) {
          if (state is QRCodeUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR Code updated successfully')),
            );
            Navigator.pop(context);
          } else if (state is QRCodeError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
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
                child:
                    _imageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey.shade600,
                              );
                            },
                          ),
                        )
                        : Column(
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

            // Active status toggle
            SwitchListTile(
              title: const Text('QR Code Status'),
              subtitle: Text(_isActive ? 'Active' : 'Inactive'),
              value: _isActive,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const Divider(),
            const SizedBox(height: 16),

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
                    onPressed: isLoading ? null : _submitForm,
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
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
