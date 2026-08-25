# Skill: plan-first-dev v2.0

# Plan-First Development Skill v2.0

**Workflow complet avec profils spécialisés, tests Gherkin et revue de code**

---

## 🎯 PRINCIPES FONDAMENTAUX

1. **Lire avant d'agir** : Never modify a file you haven't read in the current session
2. **Planifier avant d'exécuter** : Present a complete plan before making any changes
3. **Valider avant de changer** : Get explicit approval before executing non-trivial changes
4. **Vérifier systématiquement** : Test and confirm each step works
5. **Documenter les GAPs** : Identifier et lister les tests manquants

---

## 👥 PROFILS SPÉCIALISÉS PAR ÉTAPE

| Étape | Profile Activé | Responsabilités | Livrables |
|-------|----------------|------------------|-----------|
| 1 | **Analyste Technique** | Vérification des specs existantes | Rapport de conformité |
| 1.5 | **Product Manager** | Analyse des besoins fonctionnels | User Stories + Gherkin + Rôles |
| 2 | **UX/UI Expert** | Audit expérience utilisateur | Recommandations design |
| 3 | **Lead Developer** | Analyse technique | Plan détaillé + Architecture |
| 5 | **User** | Validation des choix | Approbation explicite |
| 6 | **Developer** | Implémentation | Code modifié |
| 7 | **QA Engineer** | Tests automatisés | Rapport de tests + GAPs |
| 8 | **Flutter Architect** | Revue de code | Checklist de conformité |

---

## 🚀 WORKFLOW COMPLET (8 ÉTAPES)

---

### Étape 0: INITIALISATION

**Actions:**
- Charger le contexte du projet (fichiers, dépendances, specs)
- Identifier le type de tâche : [✅ Nouveau Feature] [✅ Bug Fix] [✅ Refactor] [✅ Migration]

---

### Étape 1: VÉRIFICATION DES SPÉCIFICATIONS

**Profile: Analyste Technique**

**Actions:**
1. Rechercher le besoin dans :
   - `SPECIFICATIONS.md` / `FUNCTIONAL-SPECS.md`
   - `DATA-MODEL.md`
   - `DESIGN.md`
   - Issues GitHub/GitLab ouvertes
   - Documentation technique

2. **Si trouvé** :
   - Extraire : ID, Description, Priorité, Critères d'acceptation
   - Vérifier la conformité avec l'implémentation actuelle
   - **→ Passer à Étape 2**

3. **Si NON trouvé** :
   - Marquer comme **Nouveau Besoin**
   - **→ Passer à Étape 1.5**

**Template de sortie:**
```markdown
## ✅ Spécification Trouvée

- **ID:** [R-XX/US-XX]
- **Source:** [Fichier:Ligne]
- **Description:** [Texte]
- **Priorité:** [🔴/🟡/🟢]
- **Statut:** [✅ Implémenté / ⚠️ Partiel / ❌ Manquant]

**Écart identifié:** [Description si partiel/manquant]
```

---

### Étape 1.5: ANALYSE PRODUIT (Nouveau Besoin)

**Profile: Product Manager Mobile**

**Actions:**

#### 1.1 User Story
**Template:**
```
En tant que [rôle]
Je veux [fonctionnalité]
Afin de [bénéfice métier]
```

**Exemple:**
```
En tant que **utilisateur**
Je veux **ne pas pouvoir ajouter plus de 4 profils**
Afin de **respecter la limite de stockage par appareil (R-01)**
```

#### 1.2 Scénarios Gherkin (Génération Automatique)

**Template de base:**
```gherkin
@[ID] @[priorité] @[tag]
Feature: [Nom de la feature]

  Background:
    Given [Contexte initial]

  Scenario: [Nom du scénario principal]
    Given [Condition 1]
    And [Condition 2]
    When [Action]
    Then [Résultat attendu]
    
  Scenario: [Nom du scénario alternatif]
    Given [Condition]
    When [Action]
    Then [Résultat]
```

**Exemple pour R-01:**
```gherkin
@R-01 @high @regression
Feature: Limite de profils par appareil

  Background:
    Given L'application est démarrée
    And Je suis sur la page d'accueil

  @R-01-1
  Scenario: Ajout de profils jusqu'à la limite
    Given Il y a 0 profils
    When Je crée un profil "Leo"
    And Je crée un profil "Max"
    And Je crée un profil "Emma"
    And Je crée un profil "Sophie"
    Then Il y a 4 profils
    And Le bouton "+" est désactivé
    And Le tooltip indique "Limite de profils atteinte (4/4)"

  @R-01-2
  Scenario: Tentative de dépasser la limite
    Given Il y a 4 profils
    When Je clique sur le bouton "+"
    Then Aucun menu ne s'affiche
    And Le bouton reste gris

  @R-01-3
  Scenario: Libération d'un slot après suppression
    Given Il y a 4 profils
    When Je supprime un profil
    Then Il reste 3 profils
    And Le bouton "+" est réactivé
    And Je peux créer un nouveau profil

  @R-01-4
  Scenario: Affichage du compteur de profils
    Given Il y a 2 profils sur 4 possibles
    When Je suis sur la page d'accueil
    Then J'ai un indicateur visuel "2/4 profils"
```

#### 1.3 Matrice Rôles/Accès

**Template:**
```markdown
| Rôle | Accès | Permissions | Restrictions |
|------|-------|-------------|--------------|
| User | CRUD | Créer/Modifier/Supprimer ses profils | Max 4 profils |
| Guest | Aucun | - | - |
```

#### 1.4 Priorisation (MoSCoW)
- **Must have** : Sans ça, l'application ne fonctionne pas
- **Should have** : Important mais pas bloquant
- **Could have** : Nice-to-have
- **Won't have** : Hors scope

---

### Étape 2: ANALYSE UX/UI

**Profile: Expert Design Front-End + Graphiste**

**Checklist d'audit:**

```markdown
## 🎨 AUDIT UX/UI

### ⚠️ Problèmes Actuels
- [ ] Élément non conforme aux guidelines Material/Cupertino
- [ ] Couleur non accessible (contraste < 4.5:1)
- [ ] Taille de touche < 48x48dp
- [ ] Texte illisible sur fond coloré
- [ ] Hiérarchie visuelle peu claire
- [ ] Feedback utilisateur manquant

### ✅ Améliorations Proposées
- [ ] Appliquer la palette `AppColors`
- [ ] Ajouter `padding: EdgeInsets.all(16)`
- [ ] Remplacer `Icon` par `IconButton` pour accessibilité
- [ ] Utiliser `Tooltip` sur les éléments interactifs
- [ ] Ajouter animations de feedback

### 📏 Métriques
| Métrique | Valeur Actuelle | Valeur Cible | Statut |
|----------|-----------------|--------------|--------|
| Contraste | [X:1] | ≥ 4.5:1 | [✅/❌] |
| Touch Target | [Xdp] | ≥ 48dp | [✅/❌] |
| Densité | [X] | Cohérente | [✅/❌] |
```

**Exemple pour R-01:**
```markdown
## 🎨 Recommandations UX pour R-01

### ⚠️ Problèmes
- Bouton FAB reste cliquable visuellement (couleur primaire)
- Aucun feedback visuel sur la limite atteinte

### ✅ Solutions
1. **FAB Désactivé:**
   - Couleur: `Colors.grey` au lieu de `AppColors.primary`
   - Tooltip: "Limite de profils atteinte (4/4)"
   - `onPressed: null`

2. **Indicateur Visuel:**
   - Ajouter dans AppBar: `Text("${profiles.length}/4 profils")`
   - Ou dans footer: `LinearProgressIndicator(value: profiles.length/4)`

3. **Feedback Sonore:**
   - Vibration légère quand tentative de clic sur FAB désactivé
```

---

### Étape 3: ANALYSE TECHNIQUE

**Profile: Lead Developer**

**Livrables:**

#### 3.1 Architecture Actuelle
```
┌─────────────────────────┐
│         Screens          │ ← UI Layer
├─────────────────────────┤
│       Providers          │ ← Business Logic (Riverpod)
├─────────────────────────┤
│        Models            │ ← Data Layer (Isar)
├─────────────────────────┤
│      Database            │ ← Persistence (Isar)
└─────────────────────────┘
```

#### 3.2 Points d'Intégration
```markdown
| Composant | Fichier | Méthode | Impact |
|-----------|--------|---------|--------|
| FAB | home_screen.dart | _buildAddButton | ⚠️ Modification |
| Provider | child_profile_provider.dart | addProfile | ✅ Déjà conforme |
```

#### 3.3 Dépendances Impactées
```yaml
# Dépendances directes
isar: ^3.1.0+1
flutter_riverpod: ^2.6.1

# Dépendances indirectes
- Aucun impact identifié
```

#### 3.4 Risques Techniques
```markdown
| Risque | Probabilité | Impact | Atténuation |
|--------|-------------|--------|-------------|
| Incompatibilité Isar | Faible | Élevé | Vérifier version |
| Conflit de merge | Moyenne | Moyen | Revoir avant fusion |
| Régression | Moyenne | Élevé | Tests complets |
```

---

### Étape 4: PLAN DE DÉVELOPPEMENT

**Template Amélioré:**

```markdown
## 🎯 [ID] - [Nom de la Feature]

---

### 📊 Metadata

| Propriété | Valeur |
|-----------|--------|
| **ID** | R-01 |
| **Spécification** | [FUNCTIONAL-SPECS.md:137](link) |
| **Type** | Règle Métier |
| **Priorité** | 🔴 Haute |
| **Complexité** | ⭐⭐ (Faible) |
| **Estimation** | 1h |
| **Assigné à** | [Dev] |

---

### 📋 Contexte

**Problème:** Le bouton "+" permet toujours d'ouvrir le menu même quand 4 profils sont atteints.

**Solution:** Désactiver complètement le FAB quand la limite R-01 est atteinte.

---

### 📁 Fichiers Impactés

| Fichier | Type | Lignes | Description | Statut |
|---------|------|--------|-------------|--------|
| lib/l10n/app_localizations.dart | Modification | +6 | Ajout traductions | ✅ À faire |
| lib/screens/home_screen.dart | Modification | 198-209 | FAB désactivé | ✅ À faire |

---

### 🔧 Changements Techniques

#### 1. Traductions (app_localizations.dart)
```dart
// AVANT: Traductions manquantes

// APRÈS: Ajout des clés
_en: {
  'profileLimitReachedMessage': 'Maximum profiles reached (4/4)',
  'addProfileTooltip': 'Add a new profile',
}

_fr: {
  'profileLimitReachedMessage': 'Limite de profils atteinte (4/4)',
  'addProfileTooltip': 'Ajouter un nouveau profil',
}

// Getters
String get profileLimitReachedMessage => translate('profileLimitReachedMessage');
String get addProfileTooltip => translate('addProfileTooltip');
```

#### 2. FAB Désactivé (home_screen.dart)
```dart
// AVANT
FloatingActionButton(
  onPressed: () => _showCreateMenu(context),
  backgroundColor: AppColors.primary,
)

// APRÈS
FloatingActionButton(
  onPressed: isLimitReached ? null : () => _showCreateMenu(context),
  backgroundColor: isLimitReached ? Colors.grey : AppColors.primary,
  tooltip: isLimitReached 
      ? AppLocalizations.of(context).profileLimitReachedMessage
      : AppLocalizations.of(context).addProfileTooltip,
)
```

---

### ✅ Critères de Validation

- [ ] `flutter analyze` → No issues
- [ ] `flutter pub get` → Success
- [ ] Bouton FAB désactivé à 4 profils
- [ ] Tooltip affiché correctement
- [ ] Menu "Créer un profil" désactivé
- [ ] Tests Gherkin passent (R-01-1, R-01-2, R-01-3)

---

### ⚠️ Risques/Inconnus

| ID | Description | Probabilité | Impact | Atténuation |
|----|-------------|-------------|--------|-------------|
| RISK-01 | FAB désactivé mais menu toujours accessible | Faible | Moyen | Tester manuellement |
| RISK-02 | Traductions non chargées | Faible | Élevé | Vérifier build |

---

### ❓ Validation Explicite

**Souhaitez-vous que j'exécute ce plan pour [ID] - [Nom] ?**

[ **Oui** / **Non** / **À ajuster** ]

*Réponse attendue: "Oui" pour démarrer l'exécution*
```

---

### Étape 5: VALIDATION EXPLICITE

**Règles strictes:**

| Réponse | Action |
|---------|--------|
| ✅ **"Oui"** / **"Yes"** / **"Go"** / **"OK"** | → **Exécution autorisée** |
| ❌ **"Non"** / **"No"** | → **Annuler le plan** |
| ⚠️ **"À ajuster"** / **"Modifier"** | → **Revenir à l'étape 4** |
| 💬 **Question** | → **Répondre puis re-demander** |
| ⏳ **Silence** | → **Attendre la réponse** |

**Format de demande:**
```
❓ **Souhaitez-vous que j'exécute ce plan ?**
[ Oui / Non / À ajuster ]
```

---

### Étape 6: EXÉCUTION PAR ÉTAPES

**Règles:**
1. **1 fichier à la fois** (sauf grouping explicite et validé)
2. **Re-lire le fichier** après modification
3. **Vérifier la compilation** (`flutter analyze`)
4. **Valider avec l'utilisateur** avant étape suivante

**Format d'exécution:**
```
🔄 **ÉTAPE 1/4: Ajout des traductions**

📝 **Fichier:** lib/l10n/app_localizations.dart
📌 **Modification:** Ajout de 2 clés + 2 getters
📊 **Lignes:** 99-100, 208-209, 330-331

→ **Modification appliquée** ✅
→ **Relecture du fichier**... ✅ OK
→ **Compilation** (`flutter analyze`)... ✅ No issues

✅ **Étape 1 terminée**

🔄 **ÉTAPE 2/4: Modification du FAB**

📝 **Fichier:** lib/screens/home_screen.dart  
📌 **Modification:** Désactiver FAB quand limite atteinte
📊 **Lignes:** 198-210

→ **Modification appliquée** ✅
→ **Relecture du fichier**... ✅ OK  
→ **Compilation**... ✅ No issues

✅ **Étape 2 terminée**

🔄 **ÉTAPE 3/4: Vérification des imports**

→ **Vérification**... ✅ Tous les imports nécessaires

✅ **Étape 3 terminée**

🔄 **ÉTAPE 4/4: Test manuel**

→ **Test:** Création de 4 profils...
→ **Résultat:** Bouton FAB désactivé ✅
→ **Test:** Tentative de clic...
→ **Résultat:** Aucun menu ne s'affiche ✅

✅ **Étape 4 terminée**

🎉 **TOUTES LES ÉTAPES TERMINÉES**

**Souhaitez-vous que je procède à la phase de tests automatisés (Étape 7) ?**
[ Oui / Non ]
```

---

### Étape 7: TESTS AUTOMATISÉS (GHERKIN)

**Profile: QA Engineer**

**Règles:**
- ✅ **Seulement les scénarios Gherkin** sont testés
- ❌ **Fonctionnalités non couverts par Gherkin** → **Listées comme GAPs**

**Livrable:**
```markdown
## 🧪 RAPPORT DE TESTS - [ID]

### ✅ Tests Passés
| ID | Scénario | Statut | Durée |
|----|----------|--------|-------|
| @R-01-1 | Ajout jusqu'à la limite | ✅ PASSED | 2.3s |
| @R-01-2 | Tentative de dépassement | ✅ PASSED | 1.8s |
| @R-01-3 | Suppression libère slot | ✅ PASSED | 2.1s |

### ⚠️ GAPs Identifiés (Tests Manquants)
| ID | Description | Priorité | Action |
|----|-------------|----------|--------|
| GAP-01 | Vérification du tooltip | Moyenne | Ajouter scénario |
| GAP-02 | Test sur plusieurs devices | Faible | Backlog |

### 📊 Statistiques
- **Total Scénarios:** 3
- **Passés:** 3 (100%)
- **Échoués:** 0
- **GAPs:** 2

**Souhaitez-vous que je crée les scénarios manquants (GAPs) ?**
[ Oui / Non / Plus tard ]
```

**Format de scénario Gherkin manquant:**
```gherkin
@R-01 @gap @low
Scenario: Vérification du tooltip sur FAB désactivé
  Given Il y a 4 profils
  When Je survole le bouton "+"
  Then Un tooltip "Limite de profils atteinte (4/4)" est affiché
```

---

### Étape 8: REVUE DE CODE

**Profile: Flutter Architect**

**Checklist Complète:**

```markdown
## 🏗️ REVUE DE CODE - [ID]

### 📋 Checklist de Conformité

#### ✅ **Conventions de Code**
| Critère | Statut | Commentaire |
|---------|--------|-------------|
| ✅ Lignes ≤ 80 caractères | [✅/❌] | Vérifié avec `flutter analyze --line-length 80` |
| ✅ `const` pour widgets immutables | [✅/❌] | Tous les widgets statiques |
| ✅ `final` pour variables non modifiables | [✅/❌] | Aucune variable modifiable sans `final` |
| ✅ `await` sur toutes les Futures | [✅/❌] | Aucune Future sans `await` |
| ✅ Pas de `print()` | [✅/❌] | Utilisation de `debugPrint` ou logger |

#### ✅ **Architecture**
| Critère | Statut | Commentaire |
|---------|--------|-------------|
| ✅ Respect des patterns Riverpod | [✅/❌] | Providers séparés de la UI |
| ✅ Séparation des responsabilités | [✅/❌] | UI ↔ Logic ↔ Data |
| ✅ Pas de logique métier dans les widgets | [✅/❌] | Logique dans les providers |
| ✅ Transactions Isar pour toutes les écritures | [✅/❌] | `writeTxn` utilisé systématiquement |

#### ✅ **Gestion des Erreurs**
| Critère | Statut | Commentaire |
|---------|--------|-------------|
| ✅ `try/catch` ou `Result` pour les opérations async | [✅/❌] | Toutes les opérations risquées couvertes |
| ✅ Messages d'erreur clairs | [✅/❌] | Messages localisés et informatifs |
| ✅ Pas de crash silencieux | [✅/❌] | Toutes les erreurs traitées |

#### ✅ **Bonnes Pratiques Flutter**
| Critère | Statut | Commentaire |
|---------|--------|-------------|
| ✅ `BuildContext` non stocké | [✅/❌] | Pas de `final ctx = context` |
| ✅ `mounted` vérifié avant `setState` après async | [✅/❌] | Toutes les vérifications présentes |
| ✅ `Key` pour les listes dynamiques | [✅/❌] | `key:` utilisé pour ListView.builder |
| ✅ `SafeArea` pour les écrans full-screen | [✅/❌] | Tous les écrans protégés |

#### ✅ **Accessibilité**
| Critère | Statut | Commentaire |
|---------|--------|-------------|
| ✅ `Semantics` pour éléments personnalisés | [✅/❌] | Boutons/icônes interactifs |
| ✅ `Tooltip` sur les éléments interactifs | [✅/❌] | Tous les icônes ont des tooltips |
| ✅ Contraste ≥ 4.5:1 | [✅/❌] | Vérifié avec outils WCAG |
| ✅ Touch targets ≥ 48x48dp | [✅/❌] | Tous les éléments cliquables |

---

### 📝 Commentaires du Reieur

**Points positifs:**
- ✅ Respect des bonnes pratiques
- ✅ Code bien structuré
- ✅ Documentation claire

**Améliorations suggérées:**
- ⚠️ Extraire la logique de limite dans une méthode dédiée
- ⚠️ Utiliser des constantes pour les valeurs magiques (4)

---

### ✅ Approbation

| Statut | Décision | Prochaine Étape |
|--------|----------|----------------|
| ✅ **Approuvé** | Merge dans main | Déploiement |
| ⚠️ **À corriger** | Liste des corrections | Re-revue |
| ❌ **Rejeté** | Motivations détaillées | Retour à l'étape 4 |

**Décision:** [✅ Approuvé / ⚠️ À corriger / ❌ Rejeté]

**Commentaires:**
[Détails des corrections nécessaires]

---

**Souhaitez-vous que j'applique ces corrections ?**
[ Oui / Non ]
```

---
---

## 📌 TEMPLATES RAPIDES

---

### Template: Bug Fix
```markdown
## 🐛 [ID] - Correction de [Description]

### 📌 Objectif
Corriger [problème] identifié dans [contexte]

### 🐞 Reproduction
1. [Étape 1]
2. [Étape 2]
3. [Étape 3]
→ **Résultat:** [Erreur]

### 🔧 Solution
[Description de la correction]

### 🧪 Scénarios de Regression
```gherkin
@bugfix @regression
Scenario: Vérifier que le bug est corrigé
  Given [Condition initiale]
  When [Action qui déclenchait le bug]
  Then [Résultat attendu]
```
```

---

### Template: New Feature
```markdown
## ✨ [ID] - Nouvelle Fonctionnalité: [Nom]

### 📌 Objectif
Ajouter [fonctionnalité] pour [bénéfice]

### 🎯 User Story
En tant que [rôle]
Je veux [action]
Afin de [bénéfice]

### 🧪 Scénarios Gherkin
```gherkin
@feature @new
Feature: [Nom]
  Scenario: [Scénarios principaux]
```
```

---

### Template: Refactor
```markdown
## 🔄 [ID] - Refactor: [Composant]

### 📌 Objectif
Améliorer [aspect] de [composant]

### ⚡ Motivations
- [ ] Performance
- [ ] Lisibilité
- [ ] Maintenabilité
- [ ] Extensibilité

### 📊 Métriques
| Métrique | Avant | Après | Amélioration |
|----------|-------|-------|--------------|
| Lignes de code | X | Y | (Y-X)% |
| Complexité cyclomatique | X | Y | (Y-X)% |
```

---

## 🔧 COMMANDES UTILES

```bash
# Analyser le code
flutter analyze
flutter analyze --line-length 80

# Build
flutter pub get
flutter pub run build_runner build

# Tests
flutter test
flutter test --tags @R-01

# Format
flutter format .
dart format .

# Lint
flutter pub run dart_code_metrics:metrics analyze lib/
```

---

## 📚 RÉFÉRENCES

- [Flutter Best Practices](https://flutter.dev/docs/development/tools/sdk/lints)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Gherkin Documentation](https://cucumber.io/docs/gherkin/)
- [WCAG Accessibility](https://www.w3.org/WAI/WCAG21/quickref/)

---

**Version:** 2.0  
**Dernière mise à jour:** 2026-08-25  
**Auteur:** Mistral Vibe (avec contributions utilisateur)  
**Compatibilité:** Flutter 3.x+, Dart 3.x+
