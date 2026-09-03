# 📁 Design Documentation - StatTrack

**Dernière mise à jour**: 2026-08-27  
**Version**: 1.0  
**Auteur**: Mistral Vibe  

---

## 📂 Structure du Dossier

```
docs/design/
├── README.md                  # Ce fichier
├── HOME-SCREEN.md            # Spécification complète de la page d'accueil
├── images/                   # Images générées des écrans
│   └── HOME-SCREEN-V1.png    # Image de la page d'accueil (à générer)
└── image_prompts/            # Prompts pour générateurs d'images
    └── HOME-SCREEN-PROMPT.md # Prompt pour générer HOME-SCREEN-V1.png
```

---

## 🎯 Fichiers Disponibles

| Fichier | Description | Statut |
|---------|-------------|--------|
| [HOME-SCREEN.md](./HOME-SCREEN.md) | Spécification technique complète de la page d'accueil | ✅ **Complet** |
| [image_prompts/HOME-SCREEN-PROMPT.md](./image_prompts/HOME-SCREEN-PROMPT.md) | Prompts pour générer l'image | ✅ **Complet** |
| [images/HOME-SCREEN-V1.png](./images/HOME-SCREEN-V1.png) | Image de la page d'accueil | ⏳ **À générer** |

---

## 🎨 Génération des Images

### Prérequis

Pour générer les images des écrans, vous avez besoin d'un outil de génération d'images IA:
- **DALL·E 3** (recommandé pour la qualité du texte)
- **MidJourney v6**
- **Stable Diffusion XL**

### Instructions

1. **Choisissez un écran** dans la liste ci-dessus
2. **Ouvrez le fichier de prompt** correspondant dans `image_prompts/`
3. **Copiez le prompt** adapté à votre outil
4. **Générez l'image** avec les paramètres recommandés
5. **Validez l'image** selon la checklist fournie
6. **Enregistrez l'image** dans le dossier `images/` avec le nom spécifié

### Exemple pour HOME-SCREEN-V1.png

```bash
# Avec DALL·E 3 (via API ou interface web)
1. Utilisez le prompt principal dans: image_prompts/HOME-SCREEN-PROMPT.md
2. Paramètres: Résolution 1024x2048, style "photorealistic UI"
3. Générez 4 variantes
4. Sélectionnez la meilleure
5. Enregistrez sous: docs/design/images/HOME-SCREEN-V1.png
```

---

## 📋 Checklist de Validation des Images

Avant d'ajouter une image au dépôt, vérifiez:

- [ ] **Fidélité aux spécifications**: L'image correspond exactement au fichier de spécification (ex: [HOME-SCREEN.md](./HOME-SCREEN.md))
- [ ] **Palette de couleurs**: Uniquement les couleurs définies dans le design system
- [ ] **Typographie**: Texte lisible, bonne hiérarchie
- [ ] **Résolution**: Minimum 1024x2048 pour les mockups
- [ ] **Qualité**: Net, sans flou, sans artefacts
- [ ] **Mockup**: Cadre de téléphone propre et professionnel
- [ ] **Contenu**: Pas de texte coupé ou d'éléments manquants

---

## 🔄 Workflow de Design

1. **Spécification** → Créez un fichier `.md` dans `docs/design/` avec toutes les spécifications techniques
2. **Prompt** → Créez un fichier de prompt dans `image_prompts/`
3. **Génération** → Générez l'image avec un outil IA
4. **Validation** → Vérifiez selon la checklist
5. **Stockage** → Enregistrez dans `images/`
6. **Intégration** → Mettez à jour les références dans le code

---

## 📚 Documentation Connexe

- **Design Guidelines Global**: [../DESIGN.md](../DESIGN.md)
- **Scénarios Gherkin**: [../specs/FEATURES.md](../specs/FEATURES.md)
- **Architecture Technique**: [../ARCHITECTURE.md](../ARCHITECTURE.md)

---

## 🎯 Prochaines Étapes

- [ ] Générer [HOME-SCREEN-V1.png](./images/HOME-SCREEN-V1.png)
- [ ] Valider l'image selon la checklist
- [ ] Ajouter d'autres écrans (Profile, Match, etc.)

---

**Note**: Ce dossier utilise une approche **design-first** pour garantir la cohérence visuelle avant l'implémentation.
