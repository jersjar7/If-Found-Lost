// lib/presentation/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:if_found_lost/presentation/bloc/auth/auth_bloc.dart';
import 'package:if_found_lost/presentation/bloc/user/user_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateProfile(String userId) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UserBloc>().add(
        UpdateUserProfileEvent(
          userId: userId,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            // Load user profile when authenticated
            context.read<UserBloc>().add(
              LoadUserProfileEvent(userId: authState.user.id),
            );

            return BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserProfileUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                    ),
                  );
                } else if (state is UserError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserProfileLoaded) {
                  final profile = state.userProfile;

                  // Initialize controllers with current values
                  if (_nameController.text.isEmpty) {
                    _nameController.text = profile.name ?? '';
                    _phoneController.text = profile.phone ?? '';
                    _addressController.text = profile.address ?? '';
                  }

                  return _buildProfileForm(authState.user.id);
                } else if (state is UserProfileNotFound) {
                  return Center(
                    child: Text(
                      'Profile not found. Please update your profile.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                } else {
                  return _buildProfileForm(authState.user.id);
                }
              },
            );
          } else {
            return const Center(
              child: Text('You need to be logged in to view your profile'),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileForm(String userId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  final isLoading = state is UserLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => _updateProfile(userId),
                      child:
                          isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Save Profile'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
