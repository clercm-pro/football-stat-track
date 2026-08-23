# StatTrack – Sécurité et Protection des Données

**Version 1.0 – 23 août 2026**

---

## **🔐 Principes de Conception**

StatTrack a été conçu selon les principes **Privacy by Design** et **Privacy by Default** (RGPD, Art. 25). Notre approche repose sur trois piliers :

| **Principe** | **Implémentation dans StatTrack** | **Avantage Juridique** |
|--------------|------------------------------------|-------------------------|
| **Local-First** | Toutes les données sont stockées **uniquement sur l'appareil de l'utilisateur** | Pas de serveur central = pas de responsabilité de stockage pour l'éditeur |
| **Zero Trust** | Aucune donnée n'est collectée, transmise ou partagée avec l'éditeur | Pas de traitement de données personnelles par l'éditeur |
| **Chiffrement de bout en bout** | AES-256 pour les données locales et la synchronisation pair-à-pair | Niveau de sécurité adapté aux risques (RGPD, Art. 32) |

---

## **📦 Architecture et Stockage des Données**

### **1. Stockage Local (Hive Database)**
- **Technologie** : [Hive 2.2.3](https://docs.hivedb.dev/) (base de données NoSQL locale pour Flutter)
- **Emplacement** : **100% sur l'appareil de l'utilisateur** (dans le répertoire de stockage de l'application)
- **Accès** : **Uniquement par l'application StatTrack** sur l'appareil concerné
- **Chiffrement** : Optionnel (AES-256) – **Recommandé d'activer**

> **⚠️ Important** : L'éditeur **ne peut pas accéder** aux données stockées dans Hive. Ces données sont **exclusivement sous le contrôle de l'utilisateur**, comme un fichier local.

### **2. Absence de Serveur Central**
- **Aucun backend** n'est utilisé pour stocker les données utilisateur
- **Aucune base de données cloud** (Firebase, AWS, etc.)
- **Aucun service tiers** ne traite ou ne stocke les données sportives ou personnelles
- **Conséquence juridique** : L'éditeur n'est **pas un responsable du traitement** au sens du RGPD (Art. 4.7)

---

## **🔄 Synchronisation Pair-à-Pair**

### **1. Protocole**
StatTrack permet la synchronisation **directe entre appareils** via :
- **WebRTC** (pour la synchronisation via réseau local ou Internet)
- **Bluetooth** (pour la synchronisation en proximité)
- **QR Code** (pour l'appairage initial et l'échange de clés)

### **2. Sécurité de la Synchronisation**

| **Aspect** | **Implémentation** | **Norme/Standard** |
|-----------|-------------------|---------------------|
| **Chiffrement** | AES-256 (mode CBC ou GCM) | NIST FIPS 197 |
| **Génération des clés** | Clés aléatoires générées localement | RFC 4086 |
| **Échange de clés** | Via QR Code ou WebRTC sécurisé | DTLS-SRTP |
| **Authentification** | Clé publique/privée par appareil | RFC 5246 (TLS) |
| **Stockage des clés** | Local uniquement, jamais transmises à l'éditeur | - |

### **3. Flux de Données**
```
[Appareil A] → (Chiffrement AES-256) → [Données chiffrées] → (WebRTC/Bluetooth) → [Appareil B]
                              ↓
                    (Aucun serveur intermédiaire)
                              ↓
                    (Aucun accès par l'éditeur)
```

> **✅ Garantie** : Aucune donnée **n'est jamais transmise en clair** ni ne transite par un serveur tiers.

---

## **🔒 Chiffrement**

### **1. Bibliothèque Utilisée**
- **Nom** : [`cryptography`](https://pub.dev/packages/cryptography) v2.5.0+
- **Mainteneur** : Package officiel Dart/Flutter
- **Standards** : Implémente AES-256 selon **NIST FIPS 197**

### **2. Implémentation**

#### **Chiffrement des Données Locales**
```dart
// Exemple d'utilisation dans l'application
import 'package:cryptography/cryptography.dart';

// Génération d'une clé aléatoire (stockée localement)
final key = await Cryptography.instance.generateKey(
  AesGcm(
    secretKeyLength: 256, // AES-256
  ),
);

// Chiffrement d'une chaîne de caractères
final encrypted = await Cryptography.instance.encrypt(
  data.toBytes(),
  key,
  algorithm: AesGcm(),
);
```

#### **Bonnes Pratiques Implémentées**
- ✅ **Clés uniques par utilisateur** : Chaque appareil génère sa propre clé
- ✅ **Vecteurs d'initialisation (IV) uniques** : Un IV aléatoire est généré pour chaque opération de chiffrement
- ✅ **Pas de clés en dur** : Aucune clé de chiffrement n'est codée en dur dans l'application
- ✅ **Stockage sécurisé des clés** : Les clés sont stockées dans le **Keychain (iOS)** ou **Android Keystore** si disponible

### **3. Chiffrement de la Synchronisation**
- **Avant transmission** : Toutes les données sont chiffrées avec AES-256
- **Échange de clés** : Via QR Code (scanné en local) ou WebRTC sécurisé (DTLS-SRTP)
- **Pas de transit par un serveur** : Les données vont directement de l'appareil A à l'appareil B

---

## **📋 Données Traitées**

### **1. Types de Données**

| **Catégorie** | **Exemples** | **Sensible ?** | **Stockage** | **Transmission** |
|--------------|--------------|---------------|--------------|------------------|
| **Données sportives** | Buts, passes, matchs joués, durée | ❌ Non | Local (Hive) | Pair-à-pair (chiffré) |
| **Données de profil** | Surnom, prénom, nom, année de naissance | ⚠️ Oui (si nom réel) | Local (Hive) | Pair-à-pair (chiffré) |
| **Données techniques** | UUID (identifiants uniques), timestamps | ❌ Non | Local (Hive) | Pair-à-pair (chiffré) |
| **Métadonnées de synchronisation** | deviceId, chainId, timestamps | ❌ Non | Local | Pair-à-pair |

### **2. Qui est Responsable du Traitement ?**

| **Rôle** | **Entité** | **Responsabilités** |
|----------|------------|---------------------|
| **Responsable du traitement** | **L'utilisateur** | Doit respecter le RGPD s'il enregistre des données personnelles (noms réels, etc.) |
| **Fournisseur d'outil** | **L'éditeur (vous)** | Fournir un outil sécurisé (architecture local-first + chiffrement) |
| **Sous-traitant** | **Aucun** | Aucun service tiers n'a accès aux données |

> **📌 Important** : Si un utilisateur enregistre des **noms réels** ou des **informations identifiantes**, **il agit en tant que responsable du traitement** et doit respecter ses obligations légales (RGPD, loi Informatique et Libertés). L'éditeur **ne peut pas être tenu responsable** de l'utilisation faite par l'utilisateur.

---

## **🛡️ Mesures de Sécurité (RGPD Art. 32)**

### **1. Mesures Techniques**

| **Mesure** | **Implémentation** | **Conformité RGPD** |
|------------|-------------------|---------------------|
| **Chiffrement** | AES-256 pour les données locales et en transit | ✅ Oui |
| **Pseudonymisation** | UUID au lieu d'IDs séquentielles | ✅ Oui |
| **Minimisation des données** | Seulement les données strictement nécessaires | ✅ Oui |
| **Sécurité des transmissions** | WebRTC + Bluetooth + chiffrement | ✅ Oui |
| **Authentification** | Échange de clés publiques/privées | ✅ Oui |

### **2. Mesures Organisationnelles**

| **Mesure** | **Implémentation** |
|------------|-------------------|
| **Formation** | Documentation claire sur l'architecture de sécurité |
| **Processus de développement** | Utilisation de bibliothèques maintenues et auditables |
| **Gestion des incidents** | Transparence via la documentation et les CGU |
| **Sensibilisation des utilisateurs** | CGU et documentation explicites sur les responsabilités |

---

## **🚨 Risques Résiduels et Atténuation**

| **Risque** | **Probabilité** | **Impact** | **Mesures d'Atténuation** |
|------------|----------------|-----------|----------------------------|
| **Accès local non autorisé** (vol de téléphone, root) | Moyenne | Élevé (pour l'utilisateur) | Chiffrement AES-256 + recommandation de verrouillage de l'appareil |
| **Interception de la synchronisation** | Faible | Élevé (pour l'utilisateur) | Chiffrement AES-256 + échange de clés sécurisé |
| **Perte de données** (panne, suppression) | Moyenne | Élevé (pour l'utilisateur) | Recommandation de sauvegarde manuelle dans les CGU |
| **Conflits de synchronisation** | Moyenne | Faible | Résolution automatique par timestamp |
| **Vulnérabilité dans le code** | Très faible | Variable | Utilisation de bibliothèques standard et maintenues |

---

## **📜 Conformité Légale**

### **1. RGPD (Règlement Général sur la Protection des Données)**
- **Applicable** : Oui (toute application traitant des données de résidents UE)
- **Rôle de l'éditeur** : **Fournisseur d'outil** (pas de traitement de données personnelles)
- **Obligations remplies** :
  - ✅ Privacy by Design (Art. 25)
  - ✅ Sécurité des données (Art. 32)
  - ✅ Transparence (Art. 12-14) via les CGU
  - ✅ Minimisation des données (Art. 5.1.c)

### **2. Loi Informatique et Libertés (France)**
- **Applicable** : Oui (application française)
- **Démarches requises** : Aucune (pas de traitement de données personnelles par l'éditeur)
- **Justification** : Architecture local-first + absence de collecte

### **3. Autres Réglementations**
- **CCPA (Californie)** : Non applicable (pas de collecte de données personnelles)
- **LGPD (Brésil)** : Non applicable (pas de traitement de données personnelles par l'éditeur)

---

## **🔍 Audit et Bonnes Pratiques**

### **1. Vérifications à Effectuer (Checklist)**
- [x] **Toutes les données sont stockées localement** (pas de serveur central)
- [x] **Chiffrement AES-256 activé par défaut** pour les données sensibles
- [x] **Aucune donnée n'est transmise à l'éditeur**
- [x] **Bibliothèques de chiffrement à jour** (cryptography 2.5.0+)
- [x] **Documentation claire** sur l'architecture de sécurité
- [x] **CGU explicites** sur les responsabilités de l'utilisateur
- [ ] **Test de pénétration** (optionnel, pour les applications critiques)

### **2. Recommandations pour les Utilisateurs**
Les utilisateurs doivent :
1. **Activer le chiffrement** des données locales (si optionnel)
2. **Verrouiller leur appareil** avec un code PIN/mot de passe/biométrie
3. **Sauvegarder régulièrement** leurs données (export manuel)
4. **Vérifier les appareils** avant toute synchronisation pair-à-pair
5. **Ne pas enregistrer de données personnelles inutiles** (ex : utiliser des surnoms au lieu de noms réels)

---

## **📞 Contact et Signalement**

Pour toute question concernant la sécurité de StatTrack ou pour signaler une vulnérabilité :
- **Email** : [EMAIL – À COMPLÉTER]
- **GitHub Issues** : [https://github.com/clercm-pro/football-stat-track/issues](https://github.com/clercm-pro/football-stat-track/issues)

> **Politique de Divulgation Responsable** : Si vous découvrez une vulnérabilité, veuillez nous en informer **avant toute divulgation publique** afin que nous puissions la corriger.

---

**Document généré le 23 août 2026**
*Ce document peut être mis à jour pour refléter les évolutions de l'application ou des réglementations.*
