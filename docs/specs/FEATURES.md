# 📄 Scénarios Gherkin - Football Stat Track

## 🐛 BUG-01: Lisibilité des cartes des joueurs

@BUG-01 @high @regression @ui
Feature: Affichage lisible des cartes des joueurs

  Background:
    Given Le thème sombre est activé
    And L'application utilise AppColors.surface (0xFF1A1A1A) comme fond

  @BUG-01-1
  Scenario: Cartes invisibles sur fond identiques
    Given Je suis sur la page d'accueil
    And Il y a au moins 1 profil de joueur
    When Je regarde la grille de cartes
    Then Les cartes ne sont PAS distinctement visibles du fond
    And Le contraste entre carte et fond est de 0:1

  @BUG-01-2
  Scenario: Correction - Cartes visibles après modification
    Given Le thème sombre est activé
    And Les cartes utilisent AppColors.surfaceLight (0xFF2A2A2A)
    And Les cartes ont une elevation de 8
    And Les cartes ont une bordure de couleur primaire (alpha: 0.5)
    When Je regarde la grille de cartes
    Then Chaque carte est clairement visible et distincte du fond
    And Le contraste entre carte et fond est ≥ 3:1
    And La bordure de chaque carte est visible

---

## ✨ F-01: Création de profils (exemple)

@F-01 @medium @feature
Feature: Gestion des profils de joueurs

  Background:
    Given L'application est démarrée
    And Je suis sur la page d'accueil

  @F-01-1
  Scenario: Ajout d'un profil jusqu'à la limite
    Given Il y a 0 profils
    When Je crée un profil "Leo"
    And Je crée un profil "Max"
    And Je crée un profil "Emma"
    And Je crée un profil "Sophie"
    Then Il y a 4 profils
    And Le bouton "+" est désactivé
    And Un message indique "Limite de profils atteinte (4/4)"

---

## 🌐 LOC-01: Localisation - Libellé "Assists"

@LOC-01 @low @localization
Feature: Traduction du libellé des passes décisives

  Background:
    Given L'application est démarrée
    And Je suis sur la page d'accueil

  @LOC-01-1
  Scenario: Affichage du libellé en français
    Given La langue de l'application est française
    And Il y a au moins un profil de joueur
    When Je regarde une carte de profil
    Then Le libellé des passes décisives affiche "Passes D."

  @LOC-01-2
  Scenario: Affichage du libellé en anglais
    Given La langue de l'application est anglaise
    And Il y a au moins un profil de joueur
    When Je regarde une carte de profil
    Then Le libellé des passes décisives affiche "Assists"

---

## 🎨 DS-01: Design System - Palette Turquoise et Thème Clair

@DS-01 @high @regression @ui @design-system
Feature: Migration vers le système de design Scoreboard avec palette turquoise

  Background:
    Given Le design Claude #2b et #3a-#3c est approuvé
    And Les tokens de design sont définis dans docs/design/claude_design/README.md

  @DS-01-1
  Scenario: Application du thème clair avec fond #F3F4F3
    Given L'application est démarrée
    When Je regarde n'importe quel écran
    Then Le fond de l'application est la couleur `#F3F4F3`
    And Le texte principal utilise `#343B46`

  @DS-01-2
  Scenario: Palette de couleurs principale
    Given L'application utilise AppColors
    Then AppColors.background = `#F3F4F3`
    And AppColors.surface = `#FFFFFF`
    And AppColors.ink = `#343B46`
    And AppColors.primary = `#008A78`
    And AppColors.primaryDark = `#01584A`
    And AppColors.accent = `#2CADA3`

  @DS-01-3
  Scenario: Palette des avatars
    Given Il y a jusqu'à 4 profils possibles
    Then Le premier profil utilise `#6A71FF`
    And Le deuxième profil utilise `#6BFF9B`
    And Le troisième profil utilise `#FFE16B`
    And Le quatrième profil utilise `#FF6E6B`

  @DS-01-4
  Scenario: Typographie Archivo
    Given L'application est démarrée
    When Je regarde du texte
    Then La police par défaut est "Archivo"
    And Les nombres utilisent les chiffres tabulaires

---

## 🏠 HOME-01: Page d'Accueil - Design Scoreboard

@HOME-01 @high @regression @ui
Feature: Nouvelle page d'accueil avec design Scoreboard

  Background:
    Given Je suis sur la page d'accueil
    And Le design #2b est approuvé

  @HOME-01-1
  Scenario: En-tête avec eyebrow et titre dynamique
    Given Il y a 3 profils de joueurs
    When Je regarde l'en-tête
    Then Je vois l'eyebrow "STATTRACK" en `#008A78`, 11px, 700, letter-spacing 2px
    And Je vois le titre "Three players this season" en `#343B46`, 34px, 800, letter-spacing -1px
    And Le titre est en anglais

  @HOME-01-2
  Scenario: Carte de joueur avec barre de couleur
    Given Il y a un profil "Leo" avec 12 matchs, 25 buts, 8 passes
    And Leo a l'avatar couleur `#6A71FF`
    When Je regarde la carte de Leo
    Then La carte a un fond blanc
    And La carte a un border-radius de 18
    And La carte a un padding de 18
    And La carte a une ombre `0 1px 2px rgba(52,59,70,.08)`
    And Je vois une barre de couleur `#6A71FF` (8px × 36px, radius 4) en haut à gauche
    And Le nom "Leo" est affiché en 19px, 700, `#343B46`
    And La ligne secondaire affiche "12 matches · 2026/2027" en 12px, `rgba(52,59,70,.5)`

  @HOME-01-3
  Scenario: Affichage des statistiques sur la carte
    Given Le profil Leo a 25 buts et 8 passes
    When Je regarde les stats sur sa carte
    Then Le compteur de buts affiche "25" en 44px, 800, `#008A78`, tabular figures
    And Le libellé "GOALS" est en 11px, 600, letter-spacing 1px, `rgba(52,59,70,.5)`
    And Le compteur de passes affiche "8" en 44px, 800, `#343B46`
    And Le libellé "ASSISTS" est en 11px, 600, letter-spacing 1px, `rgba(52,59,70,.5)`
    And Je vois un sparkline avec 6 barres, hauteur proportionnelle aux buts par match
    And Les barres du sparkline sont `#2CADA3` sauf la dernière qui est `#01584A`

  @HOME-01-4
  Scenario: Section d'ajout de profil et saison
    When Je regarde le bas de la page d'accueil
    Then Je vois un bouton principal "Add player" avec icône `person_add`
    And Le bouton a un fond `#01584A`, hauteur 52, radius 14
    And Le texte est blanc, 15px, 700
    And Je vois un bouton secondaire carré 52×52, radius 14
    And Le bouton secondaire a une bordure 1.5px `rgba(52,59,70,.15)`
    And Le bouton secondaire a l'icône `calendar_today` 22px `#343B46`

  @HOME-01-5
  Scenario: État vide - Aucun profil
    Given Il n'y a aucun profil
    When Je suis sur la page d'accueil
    Then Je vois "No profiles yet" en 20px, 700, `#343B46`
    And Je vois "Tap + to add your first player" en 14px, `rgba(52,59,70,.5)`
    And Les textes sont centrés

  @HOME-01-6
  Scenario: Limite de profils atteinte
    Given Il y a déjà 4 profils
    When Je regarde la page d'accueil
    Then Le bouton "Add player" est désactivé
    And Le tooltip indique "Maximum profiles reached (4/4)"

---

## 👤 PROFILE-01: Page de Profil - Design Scoreboard

@PROFILE-01 @high @regression @ui
Feature: Nouvelle page de profil avec héro et stats de saison

  Background:
    Given Je suis sur la page de profil d'un joueur
    And Le design #2b est approuvé

  @PROFILE-01-1
  Scenario: Bloc héro avec informations du joueur
    Given Le profil est "Leo", saison "2026/2027"
    And Leo a firstName "Leonardo", lastName "Clerc", birthYear 2016
    When Je regarde le bloc héro
    Then Le fond est `#01584A`
    And Je vois l'icône `arrow_back` 24px et `home` 24px en haut
    And L'eyebrow affiche "2026/2027" en `#2CADA3`, 11px, 700, letter-spacing 2px
    And Le nom "Leo" est en 40px, 800, letter-spacing -1.2px, blanc
    And La ligne secondaire affiche "Leonardo Clerc · 10 years old" en 13px, `rgba(243,244,243,.6)`

  @PROFILE-01-2
  Scenario: Totaux de saison dans le bloc héro
    Given Leo a joué 13 matchs, marqué 25 buts, fait 8 passes en 2026/2027
    When Je regarde les totaux dans le héro
    Then Je vois 3 colonnes: GOALS, ASSISTS, MATCHES
    And Les valeurs sont 25, 8, 13 en 38px, 800, tabular, blanc
    And Les libellés sont en 11px, 600, letter-spacing 1px, `rgba(243,244,243,.55)`

  @PROFILE-01-3
  Scenario: Section Match Log avec sélecteur de saison
    When Je regarde la section Match Log
    Then Je vois l'en-tête "Match log" en 16px, 700, `#343B46`
    And Je vois le sélecteur de saison "2026/2027" avec icône `expand_more`
    And Le texte du sélecteur est en 12px, 600, `#008A78`

  @PROFILE-01-4
  Scenario: Lignes de log de matchs
    Given Leo a un match le 23 Août, 90 min, 3 buts, 1 passe
    When Je regarde la ligne de match
    Then La ligne a un fond blanc, radius 14, padding `14px 16px`
    And Le libellé affiche "23 Aug · 90 min" en 12px, `rgba(52,59,70,.5)`
    And Les compteurs affichent "3" (buts) et "1" (passes) en 22px, 800, tabular
    And Le compteur de buts est en `#008A78`
    And Le compteur de passes est en `#343B46`
    And Les unités "G" et "A" sont en 10px, letter-spacing 0.5px, `rgba(52,59,70,.45)`
    And Si le compteur est à 0, il est en `rgba(52,59,70,.3)`

  @PROFILE-01-5
  Scenario: Bouton Start a Match avec garde
    Given Leo n'a pas de match en cours
    When Je regarde le bas de la page
    Then Je vois le bouton "Start a match" avec icône `play_arrow` 22px
    And Le bouton a un fond `#008A78`, hauteur 56, radius 16
    And Le texte est blanc, 16px, 700

  @PROFILE-01-6
  Scenario: Erreur si match déjà en cours
    Given Leo a déjà un match en cours
    When Je clique sur "Start a match"
    Then Un snackbar affiche le message d'erreur
    And Je reste sur la page de profil

---

## ⚽ MATCH-01: Match en Direct - Design Scoreboard

@MATCH-01 @high @regression @ui
Feature: Écran de match en direct avec compteurs style scoreboard

  Background:
    Given Je suis sur l'écran de match en direct pour Leo
    And Le design #3a est approuvé

  @MATCH-01-1
  Scenario: En-tête avec badge LIVE
    When Je regarde l'en-tête
    Then Je vois l'icône `arrow_back` 24px `#343B46`
    And Je vois le badge LIVE: point 8px `#008A78` + "LIVE" 11px, 700, letter-spacing 1.5px, `#008A78`
    And Je vois l'icône `stop_circle` 22px `rgba(52,59,70,.35)`

  @MATCH-01-2
  Scenario: Bloc timer avec contexte
    Given Le match est en cours depuis 12 minutes et 34 secondes
    When Je regarde le bloc timer
    Then Je vois "Leo · 2026/2027" en 13px, 600, `rgba(52,59,70,.5)`
    And Le timer affiche "12:34" en 76px, 800, letter-spacing -3px, tabular, `#343B46`

  @MATCH-01-3
  Scenario: Cartes de compteurs Buts et Passes
    Given Le match a 3 buts et 1 passe
    When Je regarde les cartes de compteurs
    Then La carte Buts a un fond `#008A78`, radius 22, padding 22
    And La carte Buts a une ombre `0 2px 6px rgba(1,88,74,.25)`
    And Le libellé "GOALS" est en 12px, 700, letter-spacing 1.5px, `rgba(243,244,243,.7)`
    And Le hint "Tap to add" est en 15px, `rgba(243,244,243,.6)`
    And La valeur "3" est en 92px, 800, line-height 0.85, tabular, blanc, alignée à droite
    And La carte Passes a un fond blanc, bordure 1.5px `rgba(52,59,70,.1)`, radius 22
    And La carte Passes a une ombre `0 1px 3px rgba(52,59,70,.07)`
    And Le libellé et hint sont en `rgba(52,59,70,.45)`
    And La valeur "1" est en `#343B46`

  @MATCH-01-4
  Scenario: Instructions de contrôle
    When Je regarde les instructions
    Then Je vois "Short press = +1 • Long press = −1" en 12px, `rgba(52,59,70,.45)`, centré

  @MATCH-01-5
  Scenario: Boutons Cancel et End match
    When Je regarde le bas de l'écran
    Then Je vois le bouton "Cancel" 110×56, radius 16, bordure 1.5px `rgba(52,59,70,.15)`
    And Le texte "Cancel" est en 15px, 600, `rgba(52,59,70,.6)`
    And Je vois le bouton "End match" flex, hauteur 56, radius 16, fond `#01584A`
    And Le texte "End match" est en 16px, 700, blanc avec icône `check` 22px

  @MATCH-01-6
  Scenario: Interaction avec les compteurs
    Given Le compteur de buts est à 3
    When Je fais un tap court sur la carte Buts
    Then Le compteur passe à 4
    And J'entends une vibration haptique de 30ms
    And La valeur anime avec scale/fade sur 150ms

  @MATCH-01-7
  Scenario: Interaction long press sur les compteurs
    Given Le compteur de buts est à 3
    When Je fais un long press sur la carte Buts
    Then Le compteur passe à 2
    And J'entends une vibration haptique de 30ms
    And La valeur anime avec scale/fade sur 150ms
    And Le compteur ne va pas en dessous de 0

---

## 📊 SUMMARY-01: Résumé de Match - Bottom Sheet

@SUMMARY-01 @high @regression @ui
Feature: Bottom sheet de résumé de match remplaçant l'AlertDialog

  Background:
    Given J'ai terminé un match
    And Le design #3b est approuvé

  @SUMMARY-01-1
  Scenario: Affichage du bottom sheet
    When Le match se termine
    Then Un bottom sheet apparaît sur l'écran de match (assombri avec `rgba(52,59,70,.55)`)
    And Le sheet a un fond `#F3F4F3`, radius 26, padding `28px 24px 24px`
    And Le sheet a une ombre `0 -6px 30px rgba(52,59,70,.3)`
    And Le sheet a une marge externe de 16px

  @SUMMARY-01-2
  Scenario: Contenu du header du sheet
    Given Le match était pour Leo le 23 Août
    When Je regarde le header du sheet
    Then Je vois l'eyebrow "MATCH COMPLETED" en `#008A78`, 11px, 700, letter-spacing 2px
    And Je vois le titre "Leo · 23 Aug" en `#343B46`, 30px, 800, letter-spacing -0.8px

  @SUMMARY-01-3
  Scenario: Tuiles de statistiques
    Given Le match a duré 90 minutes, 3 buts, 1 passe
    When Je regarde les tuiles de stats
    Then Je vois 3 tuiles avec gap 10px, radius 16, padding `18px 14px`
    And La tuile DURATION a un fond blanc, valeur "90:00" en 36px, 800, `#343B46`
    And La tuile GOALS a un fond `#008A78`, valeur "3" en 36px, 800, blanc
    And La tuile ASSISTS a un fond blanc, valeur "1" en 36px, 800, `#343B46`
    And Tous les libellés sont en 11px, 600, letter-spacing 1px

  @SUMMARY-01-4
  Scenario: Ligne de confirmation
    Given Leo avait 22 buts en 12 matchs avant ce match
    And Ce match ajoute 3 buts
    When Je regarde la ligne de confirmation
    Then Je vois "Saved to season 2026/2027. Leo will be at 25 goals in 13 matches."
    And Le texte est en 13px, `rgba(52,59,70,.5)`

  @SUMMARY-01-5
  Scenario: Boutons Save match et Resume timer
    When Je regarde les boutons
    Then Je vois le bouton "Save match" hauteur 56, radius 16, fond `#01584A`
    And Le texte est blanc, 16px, 700
    And Je vois le bouton "Resume timer" comme bouton texte, hauteur 52
    And Le texte est en 15px, 600, `#008A78`

  @SUMMARY-01-6
  Scenario: Sauvegarde et retour
    Given J'ai terminé un match avec 3 buts, 1 passe
    When Je clique sur "Save match"
    Then Le match est sauvegardé avec durée, buts et passes
    And Je retourne à la page de profil de Leo

  @SUMMARY-01-7
  Scenario: Reprise du timer
    Given J'ai pause le match
    When Je clique sur "Resume timer"
    Then Le timer repart
    And Je retourne à l'écran de match en direct

---

## 🆕 CREATE-01: Création de Profil - Design Scoreboard

@CREATE-01 @high @regression @ui
Feature: Écran de création de profil avec sélecteur de couleur d'avatar

  Background:
    Given Je suis sur l'écran de création de profil
    And Le design #3c est approuvé

  @CREATE-01-1
  Scenario: En-tête de la page
    When Je regarde l'en-tête
    Then Je vois l'icône `arrow_back` 24px
    And Je vois le titre "New player" en 16px, 700, `#343B46`

  @CREATE-01-2
  Scenario: Bloc de sélection d'avatar
    When Je regarde le bloc avatar
    Then Je vois un cercle de 76px avec la première lettre du nickname
    And Le cercle a la couleur sélectionnée comme fond
    And La lettre est en 32px, 800, `#343B46`
    And Je vois le libellé "AVATAR COLOUR" en 11px, 700, letter-spacing 1.5px, `rgba(52,59,70,.45)`
    And Je vois 4 échantillons de couleur carrés, 32px, gap 8px
    And Les couleurs sont: `#6A71FF`, `#6BFF9B`, `#FFE16B`, `#FF6E6B`
    And L'échantillon sélectionné a une bordure 2.5px `#343B46` (inset)

  @CREATE-01-3
  Scenario: Champs du formulaire
    When Je regarde les champs
    Then Je vois le champ "Nickname *" en premier
    And Le libellé est en 12px, 700, `#343B46`
    And Le champ a un astérisque `*` en `#008A78`
    And Le champ a une hauteur de 52px, fond blanc, radius 14
    And Le champ a un padding horizontal de 16px
    And La valeur est en 16px, `#343B46`
    And Le placeholder est en `rgba(52,59,70,.35)`
    And La bordure est 1.5px `rgba(52,59,70,.12)`
    And La bordure devient 1.5px `#008A78` quand focused ou filled-and-required
    And Je vois les champs "First name" et "Last name" côte à côte avec gap 12px
    And Les deux sont optionnels avec placeholder "Optional"
    And Je vois le champ "Birth year" avec validation numérique
    And Le champ birth year a l'âge dérivé affiché à droite: "10 years old" en 13px, 600, `#008A78`

  @CREATE-01-4
  Scenario: Indicateur de limite de profils
    Given Il y a déjà 2 profils sur 4
    When Je regarde l'indicateur
    Then Je vois un fond `rgba(0,138,120,.08)`, radius 14, padding `14px 16px`
    And Je vois l'icône `info` 20px `#008A78`
    And Le texte indique "You can create up to 4 players on this device. 2 used."
    And Le texte est en 13px, `#01584A`

  @CREATE-01-5
  Scenario: Boutons Cancel et Save player
    When Je regarde le bas de la page
    Then Je vois le bouton "Cancel" 110×56, outline, radius 16
    And Je vois le bouton "Save player" flex, hauteur 56, radius 16, fond `#01584A`
    And Le texte "Save player" est en 16px, 700, blanc

  @CREATE-01-6
  Scenario: Validation du formulaire
    Given Je n'ai pas rempli le nickname
    When Je regarde le bouton Save
    Then Le bouton Save est désactivé

  @CREATE-01-7
  Scenario: Validation birth year
    Given Je saisis "2030" comme birth year
    When Je quitte le champ
    Then Un message d'erreur apparaît sous le champ
    And Le message est en 12px, couleur erreur

---

## 🌐 LOC-02: Localisation - Nouvelles Chaînes de Caractères

@LOC-02 @high @localization
Feature: Traduction des nouvelles chaînes de caractères du design Scoreboard

  Background:
    Given L'application utilise le système de localisation Flutter
    And Les nouvelles chaînes doivent être disponibles en anglais et français

  @LOC-02-1
  Scenario: Nouvelles chaînes en anglais
    Given La langue est anglaise
    When Je regarde les différents écrans
    Then "STATTRACK" est affiché tel quel
    And "Three players this season" est affiché avec le nombre dynamique
    And "GOALS", "ASSISTS", "MATCHES" sont affichés tel quel
    And "Match log" est affiché tel quel
    And "Start a match" est affiché tel quel
    And "LIVE" est affiché tel quel
    And "Tap to add" est affiché tel quel
    And "Short press = +1 • Long press = −1" est affiché tel quel
    And "Cancel", "End match" sont affichés tel quel
    And "MATCH COMPLETED" est affiché tel quel
    And "Saved to season 2026/2027. Leo will be at 25 goals in 13 matches." est affiché
    And "Save match", "Resume timer" sont affichés tel quel
    And "New player" est affiché tel quel
    And "AVATAR COLOUR" est affiché tel quel
    And "Nickname", "First name", "Last name", "Birth year" sont affichés tel quel
    And "You can create up to 4 players on this device. 3 used." est affiché
    And "Save player" est affiché tel quel

  @LOC-02-2
  Scenario: Traduction française complète
    Given La langue est française
    When Je regarde les différents écrans
    Then "STATTRACK" reste "STATTRACK"
    And "Three players this season" devient "X joueurs cette saison" (X dynamique)
    And "GOALS" devient "BUTS"
    And "ASSISTS" devient "PASS. D."
    And "MATCHES" devient "MATCHS"
    And "Match log" devient "Historique des matchs"
    And "Start a match" devient "Démarrer un match"
    And "LIVE" devient "EN DIRECT"
    And "Tap to add" devient "Appuyez pour ajouter"
    And "Short press = +1 • Long press = −1" devient "Appui court = +1 • Appui long = -1"
    And "Cancel" devient "Annuler"
    And "End match" devient "Terminer le match"
    And "MATCH COMPLETED" devient "MATCH TERMINÉ"
    And "Saved to season 2026/2027." devient "Enregistré dans la saison 2026/2027."
    And "Leo will be at 25 goals in 13 matches." devient "Leo aura 25 buts en 13 matchs."
    And "Save match" devient "Sauvegarder le match"
    And "Resume timer" devient "Reprendre le chrono"
    And "New player" devient "Nouveau joueur"
    And "AVATAR COLOUR" devient "COULEUR AVATAR"
    And "Nickname" devient "Surnom"
    And "First name" devient "Prénom"
    And "Last name" devient "Nom"
    And "Birth year" devient "Année de naissance"
    And "You can create up to 4 players on this device. 3 used." devient "Vous pouvez créer jusqu'à 4 joueurs sur cet appareil. 3 utilisés."
    And "Save player" devient "Sauvegarder le joueur"
    And "Maximum profiles reached (4/4)" devient "Nombre maximal de profils atteint (4/4)"

---

## 🐛 BUG-AND-01: Android Crash - SafeArea Surface Control

@BUG-AND-01 @high @regression @android @crash
Feature: Prévention du crash Android lors du démarrage de match

  Background:
    Given Je suis sur Android 14+
    And J'utilise un device avec IME (clavier logiciel)

  @BUG-AND-01-1
  Scenario: Crash avec SafeArea(bottom: false)
    Given Je suis sur l'écran de match
    When L'IME apparaît/disparaît
    Then L'application crash avec "InteractionJankMonitor surface control error"

  @BUG-AND-01-2
  Scenario: Correction - SafeArea(bottom: true)
    Given Je suis sur l'écran de match avec SafeArea(bottom: true)
    When L'IME apparaît/disparaît
    Then L'application ne crash pas
    And L'UI reste stable

---

## 🐛 BUG-COM-01: Compilation - DiagnosticPropertiesBuilder

@BUG-COM-01 @high @regression @compilation
Feature: Correction de l'erreur de compilation dans ProfileScreen

  Background:
    Given Le projet utilise Flutter 3.x+

  @BUG-COM-01-1
  Scenario: Erreur de compilation avec debugFillProperties
    Given ProfileScreen contient debugFillProperties avec DiagnosticPropertiesBuilder
    When Je lance `flutter build apk`
    Then La compilation échoue avec "Type 'DiagnosticPropertiesBuilder' not found"

  @BUG-COM-01-2
  Scenario: Correction - Suppression des méthodes de debug inutiles
    Given ProfileScreen n'a plus debugFillProperties
    When Je lance `flutter build apk`
    Then La compilation réussit
    And Aucune régression fonctionnelle

---

## 🐛 BUG-COM-02: Compilation - Offset non-constant

@BUG-COM-02 @high @regression @compilation
Feature: Correction de l'expression non-constante pour Offset

  Background:
    Given Le projet utilise Flutter 3.x+

  @BUG-COM-02-1
  Scenario: Erreur de compilation avec Offset ternaire
    Given match_screen.dart contient Offset avec expression ternaire
    When Je lance `flutter build apk`
    Then La compilation échoue avec "Not a constant expression"

  @BUG-COM-02-2
  Scenario: Correction - Extraction de la valeur avant Offset
    Given Les valeurs Y sont extraites avant BoxShadow
    When Je lance `flutter build apk`
    Then La compilation réussit

---

## 🐛 BUG-BY-01: Runtime - FormatException birthYear

@BUG-BY-01 @high @regression @runtime
Feature: Correction du parsing de l'année de naissance

  Background:
    Given L'utilisateur saisie une année de naissance

  @BUG-BY-01-1
  Scenario: FormatException avec caractères invalides
    Given Je saisis "&^" dans le champ birthYear
    When Je clique sur "Save player"
    Then J'obtiens FormatException: Invalid radix-10 number

  @BUG-BY-01-2
  Scenario: Correction - Validation et tryParse
    Given Le champ utilise int.tryParse et validation
    When Je saisis "&^" dans birthYear
    Then Je vois un message d'erreur sous le champ
    And Le bouton Save reste désactivé
    When Je saisis "2016"
    Then La validation passe
    And Le profil est sauvegardé avec birthYear = 2016


---



---


---

## 🔧 Code-Embedded Gherkin Scenarios

*Auto-generated from `@gherkin` annotations in code*

| Metric | Value |
|--------|-------|
| **Scenarios** | 4 |
| **Features** | 3 |
| **Generated** | 2026-09-03T14:01:51.739705 |


@BUG-BY-01 @high @regression @runtime
Feature: Birth year parsing validation

Background:
Given User enters birth year in create profile form

@BUG-BY-01-1
Scenario: FormatException with invalid characters
Given I enter "&^" in birthYear field
When I tap "Save player"
Then I get FormatException with "Invalid radix-10 number"

@BUG-BY-01-2
Scenario: Successful save with valid birth year
Given I enter "2016" in birthYear field
And Nickname field is filled
When I tap "Save player"
Then Profile is saved with birthYear = 2016
And No exception is thrown


@BUG-COM-01 @high @regression @compilation
Feature: CreateSeasonScreen compilation without debug methods

@BUG-COM-01-3
Scenario: Compilation fails with debugFillProperties in CreateSeasonScreen
Given CreateSeasonScreen contains debugFillProperties method
When Running flutter build apk
Then Compilation fails with "DiagnosticPropertiesBuilder not found"

@BUG-COM-01-4
Scenario: Compilation succeeds without debug methods in CreateSeasonScreen
Given CreateSeasonScreen has no debugFillProperties method
When Running flutter build apk
Then Compilation succeeds


@BUG-COM-01 @high @regression @compilation
Feature: ProfileScreen compilation without debug methods

Background:
Given Flutter 3.x+ project

@BUG-COM-01-1
Scenario: Compilation fails with DiagnosticPropertiesBuilder
Given ProfileScreen contains debugFillProperties method
When Running flutter build apk
Then Compilation fails with "DiagnosticPropertiesBuilder not found"

@BUG-COM-01-2
Scenario: Compilation succeeds without debug methods
Given ProfileScreen has no debugFillProperties method
When Running flutter build apk
Then Compilation succeeds


@BUG-AND-01 @high @regression @android @crash
Feature: SafeArea Android IME compatibility

Background:
Given Android 14+ device
And IME (soft keyboard) is enabled

@BUG-AND-01-1
Scenario: Application crashes with SafeArea bottom false
Given MatchScreen uses SafeArea(bottom: false)
When IME appears or disappears
Then Application crashes with "InteractionJankMonitor surface control error"

@BUG-AND-01-2
Scenario: Application stable with SafeArea bottom true
Given MatchScreen uses SafeArea(bottom: true)
When IME appears or disappears
Then Application remains stable

@BUG-COM-02 @high @regression @compilation
Feature: Non-constant Offset expression in BoxShadow

Background:
Given Flutter 3.x+ project

@BUG-COM-02-1
Scenario: Compilation fails with non-constant Offset
Given BoxShadow contains Offset with ternary expression
When Running flutter build apk
Then Compilation fails with "Not a constant expression"

@BUG-COM-02-2
Scenario: Compilation succeeds with extracted values
Given Offset values are extracted before BoxShadow
When Running flutter build apk
Then Compilation succeeds


