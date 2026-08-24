import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/providers/child_profile_provider.dart';

/// Create Profile Screen - Form to add a new player profile
/// 
/// Design: Premium Sports Tech
/// - Clean form layout
/// - Gradient accent elements
/// - Validation feedback
/// - Profile avatar preview
class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthYearController = TextEditingController();
  
  String _avatarLetter = '?';
  Color _avatarColor = AppColors.primary;
  
  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_updateAvatar);
    _firstNameController.addListener(_updateAvatar);
    _lastNameController.addListener(_updateAvatar);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  /// Update avatar preview based on form input
  void _updateAvatar() {
    String text = _nicknameController.text;
    if (text.isEmpty) {
      text = _firstNameController.text;
    }
    if (text.isEmpty) {
      text = _lastNameController.text;
    }
    
    setState(() {
      _avatarLetter = text.isNotEmpty ? text[0].toUpperCase() : '?';
    });
  }

  /// Select avatar color
  void _selectAvatarColor(final Color color) {
    setState(() {
      _avatarColor = color;
    });
  }

  /// Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final profile = ChildProfile(
        nickname: _nicknameController.text.trim(),
        firstName: _firstNameController.text.trim().isEmpty 
            ? null 
            : _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim().isEmpty 
            ? null 
            : _lastNameController.text.trim(),
        birthYear: _birthYearController.text.trim().isEmpty 
            ? null 
            : int.parse(_birthYearController.text.trim()),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Add profile via provider
      final addedProfile = await ref
          .read(childProfilesProvider.notifier)
          .addProfile(profile);
      
      if (mounted) {
        Navigator.pop(context, addedProfile);
      }
    }
  }

  /// Calculate age from birth year
  String? _calculateAgeDisplay() {
    if (_birthYearController.text.isEmpty) {
      return null;
    }
    
    try {
      final birthYear = int.parse(_birthYearController.text);
      final age = DateTime.now().year - birthYear;
      return '$age years old';
    } on Exception {
      return null;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: const Text(
          'Create Profile',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar preview
                _buildAvatarPreview(),
                const SizedBox(height: 24),
                
                // Avatar color selector
                _buildColorSelector(),
                const SizedBox(height: 24),
                
                // Nickname field (required)
                _buildTextField(
                  controller: _nicknameController,
                  label: 'Nickname *',
                  hint: 'Leo, Max, Emma...',
                  icon: Icons.person,
                  validator: (final value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nickname is required';
                    }
                    if (value.trim().length > 20) {
                      return 'Max 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // First name field (optional)
                _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'Optional',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                
                // Last name field (optional)
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hint: 'Optional',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                
                // Birth year field (optional)
                _buildTextField(
                  controller: _birthYearController,
                  label: 'Birth Year',
                  hint: 'YYYY',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  suffix: _calculateAgeDisplay() != null 
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            _calculateAgeDisplay()!,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: AppColors.accent,
                            ),
                          ),
                        )
                      : null,
                  validator: (final value) {
                    if (value != null && value.isNotEmpty) {
                      final year = int.tryParse(value);
                      if (year == null) {
                        return 'Enter a valid year';
                      }
                      if (year < 1900 || year > DateTime.now().year) {
                        return 'Invalid year';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Profile limit warning
                _buildProfileLimitWarning(),
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Save button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'SAVE PROFILE',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build avatar preview
  Widget _buildAvatarPreview() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _avatarColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: _avatarColor.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _avatarLetter,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Profile Avatar',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  /// Build color selector for avatar
  Widget _buildColorSelector() {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.green,
      Colors.orange,
      Colors.pink,
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Avatar Color',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((final color) => GestureDetector(
            onTap: () => _selectAvatarColor(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _avatarColor == color 
                      ? Colors.white 
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _avatarColor == color 
                  ? const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.white,
                    )
                  : null,
            ),
          )).toList(),
        ),
      ],
    );
  }

  /// Build text field
  Widget _buildTextField({
    required final TextEditingController controller,
    required final String label,
    final String? hint,
    final IconData? icon,
    final TextInputType? keyboardType,
    final Widget? suffix,
    final String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.accent)
                : null,
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: AppColors.error,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  /// Build profile limit warning
  Widget _buildProfileLimitWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.primary,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You can create up to 4 profiles per device',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
