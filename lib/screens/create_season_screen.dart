import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/providers/season_provider.dart';

/// Create Season Screen - Form to add a new sports season with Scoreboard design
/// 
/// Design: Scoreboard-compatible
/// - Header: arrow_back + "New season" 16px/700 #343B46
/// - Season field with validation
/// - Info note with season explanation
/// - Bottom: Cancel and Create season buttons
///
/// @gherkin
/// @BUG-COM-01 @high @regression @compilation
/// Feature: CreateSeasonScreen compilation without debug methods
///
///   @BUG-COM-01-3
///   Scenario: Compilation fails with debugFillProperties in CreateSeasonScreen
///     Given CreateSeasonScreen contains debugFillProperties method
///     When Running flutter build apk
///     Then Compilation fails with "DiagnosticPropertiesBuilder not found"
///
///   @BUG-COM-01-4
///   Scenario: Compilation succeeds without debug methods in CreateSeasonScreen
///     Given CreateSeasonScreen has no debugFillProperties method
///     When Running flutter build apk
///     Then Compilation succeeds
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
    final localization = AppLocalizations.of(context);
    
    if (value == null || value.trim().isEmpty) {
      return localization.seasonRequired;
    }

    // Try to parse
    final digits = value.replaceAll(RegExp('[^0-9]'), '');
    if (digits.length != 4 && digits.length != 8) {
      return localization.seasonInvalid;
    }

    int? startYear;
    if (digits.length >= 4) {
      startYear = int.tryParse(digits.substring(0, 4));
    }

    if (startYear == null) {
      return localization.seasonInvalid;
    }

    if (startYear < 1900 || startYear > _currentYear + 5) {
      return localization.seasonYearRange;
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
      final addedSeason = await ref
          .read(seasonsProvider.notifier)
          .addSeason(season);

      if (mounted) {
        Navigator.pop(context, addedSeason);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final localization = AppLocalizations.of(context);

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
                localization.createSeasonTitle,
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
                  const SizedBox(height: 24),
                  
                  // Season field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Label: "Season *" with asterisk in #008A78
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: localization.seasonLabel,
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
                          ),
                          
                          const SizedBox(height: 6),
                          
                          // Season input field: 52px height, white background, 14 radius
                          SizedBox(
                            height: 52,
                            child: TextFormField(
                              controller: _seasonController,
                              style: const TextStyle(
                                fontFamily: 'Archivo',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.ink,
                                height: 1.0,
                              ),
                              textAlign: TextAlign.center,
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
                                hintText: localization.seasonHint,
                                hintStyle: const TextStyle(
                                  fontFamily: 'Archivo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.ink30,
                                  height: 1.0,
                                ),
                                errorStyle: const TextStyle(
                                  fontFamily: 'Archivo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.error,
                                  height: 1.0,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              validator: _validateSeason,
                              onChanged: _parseSeason,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Season info note
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
                              localization.seasonInfo,
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
                  
                  // Quick select options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // "Quick select" label: 12px/700 rgba(52,59,70,.45)
                        Text(
                          localization.quickSelect,
                          style: const TextStyle(
                            fontFamily: 'Archivo',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink60,
                            height: 1.0,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Quick select buttons
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.start,
                          children: List.generate(5, (final index) {
                            final year = _currentYear - index;
                            final isSelected = _startYear == year;
                            
                            return SizedBox(
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _startYear = year;
                                    _endYear = year + 1;
                                    _seasonController.text = '$year/${year + 1}';
                                  });
                                },
                                child: Text(
                                  '$year/${year + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Archivo',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected 
                                        ? Colors.white 
                                        : AppColors.ink,
                                    height: 1.0,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected 
                                      ? AppColors.primaryDark 
                                      : AppColors.surface,
                                  foregroundColor: isSelected 
                                      ? Colors.white 
                                      : AppColors.ink,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: isSelected 
                                        ? AppColors.primaryDark 
                                        : AppColors.hairline,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
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
                        
                        // Create season button: flex, height 56, #01584A
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _startYear != null ? _submitForm : null,
                              child: Text(
                                localization.createSeasonButton,
                                style: const TextStyle(
                                  fontFamily: 'Archivo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _startYear != null
                                    ? AppColors.primaryDark
                                    : AppColors.hairlineLight,
                                foregroundColor: _startYear != null
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
}