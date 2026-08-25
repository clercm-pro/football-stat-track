import 'package:flutter/material.dart';

/// Supported locales for the application
const supportedLocales = [
  Locale('en', 'US'),
  Locale('fr', 'FR'),
];

/// Localizations delegate for AppLocalizations
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(final Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(final Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant final LocalizationsDelegate<AppLocalizations> old) => false;
}

/// Main localization class
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(final BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  /// Helper to get the current language code
  String get _lang => locale.languageCode;

  /// All English translations
  static const Map<String, String> _en = {
    // App
    'appTitle': 'StatTrack',
    
    // Common
    'ok': 'OK',
    'cancel': 'Cancel',
    'save': 'Save',
    'back': 'Back',
    'home': 'Home',
    'createdByDeerflow': 'Created By Deerflow',
    
    // Errors
    'errorTitle': 'An error occurred',
    'errorMessage': 'Sorry. Please restart the application.',
    'restartButton': 'Restart',
    
    // Home Screen
    'statTrackTitle': 'STATTRACK',
    'noProfiles': 'No profiles yet',
    'addFirstPlayer': 'Tap + to add your first player',
    
    // Profile Screen
    'recentMatches': 'Recent Matches',
    'selectSeason': 'Select Season',
    'matchesLabel': 'Matches',
    'goalsLabel': 'Goals',
    'assistsLabel': 'Assists',
    'startMatchButton': 'START A MATCH',
    'matchInProgressError': 'A match is already in progress for this profile',
    
    // Create Profile Screen
    'createProfileTitle': 'Create Profile',
    'nicknameLabel': 'Nickname *',
    'nicknameHint': 'Leo, Max, Emma...',
    'nicknameRequired': 'Nickname is required',
    'nicknameMaxLength': 'Max 20 characters',
    'firstNameLabel': 'First Name',
    'firstNameHint': 'Optional',
    'lastNameLabel': 'Last Name',
    'lastNameHint': 'Optional',
    'birthYearLabel': 'Birth Year',
    'birthYearHint': 'YYYY',
    'birthYearInvalid': 'Enter a valid year',
    'birthYearRange': 'Invalid year',
    'profileAvatar': 'Profile Avatar',
    'avatarColor': 'Avatar Color',
    'cancelButton': 'CANCEL',
    'saveProfileButton': 'SAVE PROFILE',
    'profileLimitWarning': 'You can create up to 4 profiles per device',
    
    // Create Season Screen
    'createSeasonTitle': 'Create Season',
    'seasonLabel': 'Season',
    'seasonHint': 'YYYY/YYYY+1',
    'seasonRequired': 'Season is required',
    'seasonInvalid': 'Enter a valid season (YYYY/YYYY+1)',
    'seasonStartBeforeEnd': 'Start year must be before end year',
    'seasonYearRange': 'Year must be between 1900 and 2100',
    'createSeasonButton': 'CREATE SEASON',
    
    // Match Screen
    'matchTitle': 'Match',
    'startMatch': 'Start Match',
    'endMatch': 'End Match',
    'pauseMatch': 'Pause',
    'resumeMatch': 'Resume',
    'matchEnded': 'Match Ended',
    'matchInProgress': 'Match in Progress',
    'noMatchInProgress': 'No match in progress',
    'goals': 'Goals',
    'assists': 'Assists',
    'matchDuration': 'Duration',
    'matchStats': 'Match Stats',
    'endMatchConfirmation': 'End this match?',
    'endMatchWarning': 'This cannot be undone',
    'yes': 'Yes',
    'no': 'No',
    'minutes': 'min',
    
    // Validation Messages
    'requiredField': 'This field is required',
    'invalidFormat': 'Invalid format',
    'valueTooLow': 'Value is too low',
    'valueTooHigh': 'Value is too high',
    
    // Dialog Messages
    'deleteProfileTitle': 'Delete Profile',
    'deleteProfileConfirmation': 'Are you sure you want to delete',
    'actionCannotBeUndone': 'This action cannot be undone',
    'delete': 'Delete',
    
    // Footer
    'builtWithFlutter': 'Built with Flutter',
    
    // Placeholders
    'enterNickname': 'Enter nickname',
    'enterFirstName': 'Enter first name',
    'enterLastName': 'Enter last name',
    'enterBirthYear': 'Enter birth year',
    'enterSeason': 'Enter season',
  };

  /// All French translations
  static const Map<String, String> _fr = {
    // App
    'appTitle': 'StatTrack',
    
    // Common
    'ok': 'OK',
    'cancel': 'Annuler',
    'save': 'Enregistrer',
    'back': 'Retour',
    'home': 'Accueil',
    'createdByDeerflow': 'Créé par Deerflow',
    
    // Errors
    'errorTitle': 'Une erreur est survenue',
    'errorMessage': 'Désolé. Veuillez redémarrer l\'application.',
    'restartButton': 'Redémarrer',
    
    // Home Screen
    'statTrackTitle': 'STATTRACK',
    'noProfiles': 'Aucun profil pour l\'instant',
    'addFirstPlayer': 'Appuyez sur + pour ajouter votre premier joueur',
    
    // Profile Screen
    'recentMatches': 'Matchs récents',
    'selectSeason': 'Sélectionner la saison',
    'matchesLabel': 'Matchs',
    'goalsLabel': 'Buts',
    'assistsLabel': 'Passes décisives',
    'startMatchButton': 'DÉMARRER UN MATCH',
    'matchInProgressError': 'Un match est déjà en cours pour ce profil',
    
    // Create Profile Screen
    'createProfileTitle': 'Créer un Profil',
    'nicknameLabel': 'Surnom *',
    'nicknameHint': 'Léo, Max, Emma...',
    'nicknameRequired': 'Le surnom est requis',
    'nicknameMaxLength': 'Maximum 20 caractères',
    'firstNameLabel': 'Prénom',
    'firstNameHint': 'Facultatif',
    'lastNameLabel': 'Nom',
    'lastNameHint': 'Facultatif',
    'birthYearLabel': 'Année de naissance',
    'birthYearHint': 'AAAA',
    'birthYearInvalid': 'Entrez une année valide',
    'birthYearRange': 'Année invalide',
    'profileAvatar': 'Avatar du Profil',
    'avatarColor': 'Couleur de l\'Avatar',
    'cancelButton': 'ANNULER',
    'saveProfileButton': 'ENREGISTRER LE PROFIL',
    'profileLimitWarning': 'Vous pouvez créer jusqu\'à 4 profils par appareil',
    
    // Create Season Screen
    'createSeasonTitle': 'Créer une Saison',
    'seasonLabel': 'Saison',
    'seasonHint': 'AAAA/AAAA+1',
    'seasonRequired': 'La saison est requise',
    'seasonInvalid': 'Entrez une saison valide (AAAA/AAAA+1)',
    'seasonStartBeforeEnd': 'L\'année de début doit être avant l\'année de fin',
    'seasonYearRange': 'L\'année doit être entre 1900 et 2100',
    'createSeasonButton': 'CRÉER LA SAISON',
    
    // Match Screen
    'matchTitle': 'Match',
    'startMatch': 'Démarrer le match',
    'endMatch': 'Terminer le match',
    'pauseMatch': 'Pause',
    'resumeMatch': 'Reprendre',
    'matchEnded': 'Match terminé',
    'matchInProgress': 'Match en cours',
    'noMatchInProgress': 'Aucun match en cours',
    'goals': 'Buts',
    'assists': 'Passes',
    'matchDuration': 'Durée',
    'matchStats': 'Statistiques du match',
    'endMatchConfirmation': 'Terminer ce match ?',
    'endMatchWarning': 'Cette action est irréversible',
    'yes': 'Oui',
    'no': 'Non',
    'minutes': 'min',
    
    // Validation Messages
    'requiredField': 'Ce champ est requis',
    'invalidFormat': 'Format invalide',
    'valueTooLow': 'La valeur est trop basse',
    'valueTooHigh': 'La valeur est trop élevée',
    
    // Dialog Messages
    'deleteProfileTitle': 'Supprimer le profil',
    'deleteProfileConfirmation': 'Êtes-vous sûr de vouloir supprimer',
    'actionCannotBeUndone': 'Cette action est irréversible',
    'delete': 'Supprimer',
    
    // Footer
    'builtWithFlutter': 'Développé avec Flutter',
    
    // Placeholders
    'enterNickname': 'Entrez le surnom',
    'enterFirstName': 'Entrez le prénom',
    'enterLastName': 'Entrez le nom',
    'enterBirthYear': 'Entrez l\'année de naissance',
    'enterSeason': 'Entrez la saison',
  };

  /// Get the current translations map
  Map<String, String> get _strings {
    switch (_lang) {
      case 'fr':
        return _fr;
      default:
        return _en;
    }
  }

  /// Helper method to get localized string
  String translate(final String key) {
    return _strings[key] ?? key;
  }

  // App
  String get appTitle => translate('appTitle');

  // Common
  String get ok => translate('ok');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get back => translate('back');
  String get home => translate('home');
  String get createdByDeerflow => translate('createdByDeerflow');

  // Errors
  String get errorTitle => translate('errorTitle');
  String get errorMessage => translate('errorMessage');
  String get restartButton => translate('restartButton');

  // Home Screen
  String get statTrackTitle => translate('statTrackTitle');
  String get noProfiles => translate('noProfiles');
  String get addFirstPlayer => translate('addFirstPlayer');

  // Profile Screen
  String get recentMatches => translate('recentMatches');
  String get selectSeason => translate('selectSeason');
  String get matchesLabel => translate('matchesLabel');
  String get goalsLabel => translate('goalsLabel');
  String get assistsLabel => translate('assistsLabel');
  String get startMatchButton => translate('startMatchButton');
  String get matchInProgressError => translate('matchInProgressError');

  // Create Profile Screen
  String get createProfileTitle => translate('createProfileTitle');
  String get nicknameLabel => translate('nicknameLabel');
  String get nicknameHint => translate('nicknameHint');
  String get nicknameRequired => translate('nicknameRequired');
  String get nicknameMaxLength => translate('nicknameMaxLength');
  String get firstNameLabel => translate('firstNameLabel');
  String get firstNameHint => translate('firstNameHint');
  String get lastNameLabel => translate('lastNameLabel');
  String get lastNameHint => translate('lastNameHint');
  String get birthYearLabel => translate('birthYearLabel');
  String get birthYearHint => translate('birthYearHint');
  String get birthYearInvalid => translate('birthYearInvalid');
  String get birthYearRange => translate('birthYearRange');
  String get profileAvatar => translate('profileAvatar');
  String get avatarColor => translate('avatarColor');
  String get cancelButton => translate('cancelButton');
  String get saveProfileButton => translate('saveProfileButton');
  String get profileLimitWarning => translate('profileLimitWarning');

  // Create Season Screen
  String get createSeasonTitle => translate('createSeasonTitle');
  String get seasonLabel => translate('seasonLabel');
  String get seasonHint => translate('seasonHint');
  String get seasonRequired => translate('seasonRequired');
  String get seasonInvalid => translate('seasonInvalid');
  String get seasonStartBeforeEnd => translate('seasonStartBeforeEnd');
  String get seasonYearRange => translate('seasonYearRange');
  String get createSeasonButton => translate('createSeasonButton');

  // Match Screen
  String get matchTitle => translate('matchTitle');
  String get startMatch => translate('startMatch');
  String get endMatch => translate('endMatch');
  String get pauseMatch => translate('pauseMatch');
  String get resumeMatch => translate('resumeMatch');
  String get matchEnded => translate('matchEnded');
  String get matchInProgress => translate('matchInProgress');
  String get noMatchInProgress => translate('noMatchInProgress');
  String get goals => translate('goals');
  String get assists => translate('assists');
  String get matchDuration => translate('matchDuration');
  String get matchStats => translate('matchStats');
  String get endMatchConfirmation => translate('endMatchConfirmation');
  String get endMatchWarning => translate('endMatchWarning');
  String get yes => translate('yes');
  String get no => translate('no');
  String get minutes => translate('minutes');

  // Validation Messages
  String get requiredField => translate('requiredField');
  String get invalidFormat => translate('invalidFormat');
  String get valueTooLow => translate('valueTooLow');
  String get valueTooHigh => translate('valueTooHigh');

  // Dialog Messages
  String get deleteProfileTitle => translate('deleteProfileTitle');
  String get deleteProfileConfirmation => translate('deleteProfileConfirmation');
  String get actionCannotBeUndone => translate('actionCannotBeUndone');
  String get delete => translate('delete');

  // Footer
  String get builtWithFlutter => translate('builtWithFlutter');

  // Placeholders
  String get enterNickname => translate('enterNickname');
  String get enterFirstName => translate('enterFirstName');
  String get enterLastName => translate('enterLastName');
  String get enterBirthYear => translate('enterBirthYear');
  String get enterSeason => translate('enterSeason');
}
