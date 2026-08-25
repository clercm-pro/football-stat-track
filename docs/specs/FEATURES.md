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
