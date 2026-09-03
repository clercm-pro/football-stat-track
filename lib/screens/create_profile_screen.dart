import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/providers/child_profile_provider.dart';

/// Create Profile Screen - Form to add a new player profile with Scoreboard design (#3c)
/// 
/// Design: Scoreboard - Create Profile
/// - Header: arrow_back + "New player" 16px/700 #343B46
/// - Avatar block: 76px circle with first letter, "AVATAR COLOUR" label, 4 color swatches
/// - Fields: Nickname*, First name, Last name (side by side), Birth year
/// - Info note: profile limit indicator
/// - Bottom: Cancel (110×56 outlined) and Save player (flex, #01584A) buttons
///
/// @gherkin
/// @BUG-BY-01 @high @regression @runtime
/// Feature: Birth year parsing validation
///
///   Background:
///     Given User enters birth year in create profile form
///
///   @BUG-BY-01-1
///   Scenario: FormatException with invalid characters
///     Given I enter "&^" in birthYear field
///     When I tap "Save player"
///     Then I get FormatException with "Invalid radix-10 number"
///
///   @BUG-BY-01-2
///   Scenario: Successful save with valid birth year
///     Given I enter "2016" in birthYear field
///     And Nickname field is filled
///     When I tap "Save player"
///     Then Profile is saved with birthYear = 2016
///     And No exception is thrown
class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();

}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthYearController = TextEditingController();

  // Avatar color: default to first avatar color (#6A71FF)
  Color _avatarColor = AppColors.avatar1;
  // Selected color index for swatches
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_updateState);
    _firstNameController.addListener(_updateState);
    _lastNameController.addListener(_updateState);
    _birthYearController.addListener(_updateState);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  /// Update state when form changes
  void _updateState() {
    setState(() {});
  }

  /// Select avatar color by index (0-3)
  void _selectAvatarColor(final int index) {
    final colors = [
      AppColors.avatar1,
      AppColors.avatar2,
      AppColors.avatar3,
      AppColors.avatar4,
    ];
    
    setState(() {
      _selectedColorIndex = index;
      _avatarColor = colors[index];
    });
  }

  /// Calculate age from birth year
  String? _calculateAgeDisplay() {
    if (_birthYearController.text.isEmpty) {
      return null;
    }

    final birthYear = int.tryParse(_birthYearController.text);
    if (birthYear == null) {
      return null;
    }
    final age = DateTime.now().year - birthYear;
    return '$age years old';
  }

  /// Get first letter for avatar
  String _getAvatarLetter() {
    String text = _nicknameController.text;
    if (text.isEmpty) {
      text = _firstNameController.text;
    }
    if (text.isEmpty) {
      text = _lastNameController.text;
    }

    return text.isNotEmpty ? text[0].toUpperCase() : '?';
  }

  /// Check if form is valid
  bool _isFormValid() {
    if (_nicknameController.text.trim().isEmpty) {
      return false;
    }
    if (_nicknameController.text.trim().length > 20) {
      return false;
    }
    // Check if birth year is valid (if provided)
    if (_birthYearController.text.trim().isNotEmpty) {
      final birthYear = int.tryParse(_birthYearController.text.trim());
      if (birthYear == null) {
        return false;
      }
      // Check year range
      if (birthYear < 1900 || birthYear > DateTime.now().year) {
        return false;
      }
    }
    return true;
  }

  /// Submit form
  Future<void> _submitForm() async {
    if (!_isFormValid()) {
      return;
    }

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
          : int.tryParse(_birthYearController.text.trim()),
      avatarColor: _avatarColor.toARGB32(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add profile via provider
    final addedProfile = await ref
        .read(childProfilesProvider.notifier)
        .addProfile(profile);

    if (mounted && addedProfile != null) {
      Navigator.pop(context, addedProfile);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final localization = AppLocalizations.of(context);
    final profiles = ref.watch(childProfilesProvider);
    final usedCount = profiles.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // App bar with back button and title
            SliverAppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, size: 24),
                onPressed: () => Navigator.pop(context),
                color: AppColors.ink,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              title: Text(
                localization.newPlayerTitle,
                style: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  height: 1.0,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              forceMaterialTransparency: true,
              pinned: false,
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar block
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar circle + color swatches
                        Row(
                          children: [
                            // 76px circle with first letter
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: _avatarColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _getAvatarLetter(),
                                  style: const TextStyle(
                                    fontFamily: 'Archivo',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 18),
                            
                            // AVATAR COLOUR label and 4 color swatches
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // "AVATAR COLOUR" 11px/700 letter-spacing 1.5px rgba(52,59,70,.45)
                                  Text(
                                    localization.avatarColour,
                                    style: const TextStyle(
                                      fontFamily: 'Archivo',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink60,
                                      letterSpacing: 1.5,
                                      height: 1.0,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // 4 color swatches, 32px, 8px gap
                                  Row(
                                    children: [
                                      _buildColorSwatch(0, AppColors.avatar1),
                                      const SizedBox(width: 8),
                                      _buildColorSwatch(1, AppColors.avatar2),
                                      const SizedBox(width: 8),
                                      _buildColorSwatch(2, AppColors.avatar3),
                                      const SizedBox(width: 8),
                                      _buildColorSwatch(3, AppColors.avatar4),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 26),
                  
                  // Form fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Nickname * field
                          _buildTextField(
                            context,
                            controller: _nicknameController,
                            label: localization.nicknameLabel,
                            hint: localization.nicknameHint,
                            placeholder: '',
                            isRequired: true,
                            validator: (final value) {
                              if (value == null || value.trim().isEmpty) {
                                return localization.nicknameRequired;
                              }
                              if (value.trim().length > 20) {
                                return localization.nicknameMaxLength;
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 18),
                          
                          // First name and Last name fields side by side
                          Row(
                            children: [
                              // First name field
                              Expanded(
                                child: _buildTextField(
                                  context,
                                  controller: _firstNameController,
                                  label: localization.firstNameLabel,
                                  hint: localization.optional,
                                  placeholder: localization.optional,
                                  isRequired: false,
                                  validator: null,
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Last name field
                              Expanded(
                                child: _buildTextField(
                                  context,
                                  controller: _lastNameController,
                                  label: localization.lastNameLabel,
                                  hint: localization.optional,
                                  placeholder: localization.optional,
                                  isRequired: false,
                                  validator: null,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 18),
                          
                          // Birth year field with age display
                          Row(
                            children: [
                              // Birth year field
                              Expanded(
                                child: _buildTextField(
                                  context,
                                  controller: _birthYearController,
                                  label: localization.birthYearLabel,
                                  hint: localization.birthYearHint,
                                  placeholder: '',
                                  isRequired: false,
                                  validator: (final value) {
                                    if (value != null && value.isNotEmpty) {
                                      final year = int.tryParse(value);
                                      if (year == null) {
                                        return localization.birthYearInvalid;
                                      }
                                      if (year < 1900 || year > DateTime.now().year) {
                                        return localization.birthYearRange;
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              
                              // Age display
                              if (_calculateAgeDisplay() != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  _calculateAgeDisplay()!,
                                  style: const TextStyle(
                                    fontFamily: 'Archivo',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Profile limit info note
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              '${localization.profileLimitInfo}. $usedCount ${localization.usedPeriod}',
                              style: const TextStyle(
                                fontFamily: 'Archivo',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryDark,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bottom buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel button: 110×56, outlined
                        SizedBox(
                          width: 110,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              localization.cancel,
                              style: const TextStyle(
                                fontFamily: 'Archivo',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink60,
                                height: 1.0,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink60,
                              backgroundColor: AppColors.surface,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: const BorderSide(
                                color: AppColors.hairlineLight,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        
                        // Save player button: flex, height 56, #01584A
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isFormValid() ? _submitForm : null,
                              child: Text(
                                localization.savePlayerButton,
                                style: const TextStyle(
                                  fontFamily: 'Archivo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid()
                                    ? AppColors.primaryDark
                                    : AppColors.hairlineLight,
                                foregroundColor: _isFormValid()
                                    ? Colors.white
                                    : AppColors.ink30,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                minimumSize: const Size.fromHeight(56),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build color swatch for avatar color selection
  Widget _buildColorSwatch(final int index, final Color color) {
    return GestureDetector(
      onTap: () => _selectAvatarColor(index),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColorIndex == index ? AppColors.ink : Colors.transparent,
            width: 2.5,
          ),
        ),
      ),
    );
  }

  /// Build text field
  Widget _buildTextField(
    final BuildContext context,
    {
      required final TextEditingController controller,
      required final String label,
      final String? hint,
      final String? placeholder,
      required final bool isRequired,
      final String? Function(String?)? validator,
      final TextInputType? keyboardType,
    }) {
    final localization = AppLocalizations.of(context);
    
    // Build label with asterisk for required fields
    final labelText = isRequired
        ? RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontFamily: 'Archivo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1.0,
                  ),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontFamily: 'Archivo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          )
        : Text(
            label,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.0,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        labelText,
        
        const SizedBox(height: 6),
        
        // Text field
        SizedBox(
          height: 52,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.ink,
              height: 1.0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.hairline,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.hairline,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Archivo',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.ink30,
                height: 1.0,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            validator: (final value) {
              if (validator != null) {
                return validator(value);
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}