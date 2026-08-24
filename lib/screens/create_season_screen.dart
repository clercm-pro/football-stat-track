import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/providers/season_provider.dart';

/// Create Season Screen - Form to add a new sports season
/// 
/// Design: Premium Sports Tech
/// - Clean, focused form
/// - Season format validation (YYYY/YYYY+1)
/// - Current year auto-selection
/// - Visual feedback
class CreateSeasonScreen extends ConsumerStatefulWidget {
  const CreateSeasonScreen({super.key});

  @override
  ConsumerState<CreateSeasonScreen> createState() => _CreateSeasonScreenState();
}

class _CreateSeasonScreenState extends ConsumerState<CreateSeasonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _seasonController = TextEditingController();
  
  int? _startYear;
  int? _endYear;
  
  // Current year for default selection
  final int _currentYear = DateTime.now().year;
  final int _nextYear = DateTime.now().year + 1;

  @override
  void initState() {
    super.initState();
    // Set default season
    _seasonController.text = '$_currentYear/$_nextYear';
    _startYear = _currentYear;
    _endYear = _nextYear;
  }

  @override
  void dispose() {
    _seasonController.dispose();
    super.dispose();
  }

  /// Parse season string into start and end years
  void _parseSeason(final String value) {
    // Remove all non-digit characters
    final digits = value.replaceAll(RegExp('[^0-9]'), '');
    
    if (digits.length >= 4) {
      // Try to extract first 4 digits as start year
      final startYear = int.tryParse(digits.substring(0, 4));
      
      if (startYear != null) {
        // End year is startYear + 1
        setState(() {
          _startYear = startYear;
          _endYear = startYear + 1;
        });
      }
    }
  }

  /// Format season as YYYY/YYYY+1
  String _formatSeason() {
    if (_startYear != null && _endYear != null) {
      return '$_startYear/$_endYear';
    }
    return _seasonController.text;
  }

  /// Validate season format
  String? _validateSeason(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Season is required';
    }
    
    // Try to parse
    final digits = value.replaceAll(RegExp('[^0-9]'), '');
    if (digits.length != 4 && digits.length != 8) {
      return 'Invalid format';
    }
    
    int? startYear;
    if (digits.length >= 4) {
      startYear = int.tryParse(digits.substring(0, 4));
    }
    
    if (startYear == null) {
      return 'Invalid year';
    }
    
    if (startYear < 2000 || startYear > _currentYear + 5) {
      return 'Year must be between 2000 and ${_currentYear + 5}';
    }
    
    return null;
  }

  /// Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final season = Season(
        name: _formatSeason(),
        startYear: _startYear!,
        endYear: _endYear!,
        createdAt: DateTime.now(),
      );
      
      // Add season via provider
      final addedSeason = await ref.read(seasonsProvider.notifier).addSeason(season);
      
      if (mounted) {
        Navigator.pop(context, addedSeason);
      }
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
          'Create Season',
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
                // Season selector header
                _buildHeader(),
                const SizedBox(height: 24),
                
                // Season input field
                _buildSeasonField(),
                const SizedBox(height: 16),
                
                // Season preview
                _buildSeasonPreview(),
                const SizedBox(height: 24),
                
                // Quick select options
                _buildQuickSelect(),
                const SizedBox(height: 24),
                
                // Season info
                _buildSeasonInfo(),
                const SizedBox(height: 32),
                
                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
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
                          'SAVE SEASON',
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

  /// Build header
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_today,
            size: 40,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sports Season',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Organize your data by season',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build season input field
  Widget _buildSeasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Season Name',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _seasonController,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            hintText: 'YYYY/YYYY+1',
            hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: AppColors.error,
            ),
          ),
          validator: _validateSeason,
          onChanged: _parseSeason,
        ),
      ],
    );
  }

  /// Build season preview
  Widget _buildSeasonPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Preview',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatSeason(),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_startYear ?? '??'} - ${_endYear ?? '??'}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick select options
  Widget _buildQuickSelect() {
    final years = List.generate(5, (final index) => _currentYear - index);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick Select',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: years.map((final year) => ElevatedButton(
            onPressed: () {
              setState(() {
                _startYear = year;
                _endYear = year + 1;
                _seasonController.text = '$year/${year + 1}';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _startYear == year 
                  ? AppColors.primary 
                  : AppColors.surfaceLight,
              foregroundColor: _startYear == year 
                  ? Colors.white 
                  : AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '$year/${year + 1}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  /// Build season info
  Widget _buildSeasonInfo() {
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
              'A season runs from September to June. Format: YYYY/YYYY+1',
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
