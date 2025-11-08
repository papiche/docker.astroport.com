# 💰 Guide Économique Astroport.ONE

Ce guide explique comment utiliser les calculateurs économiques pour planifier votre déploiement Astroport et comprendre le modèle économique coopératif.

## 🎯 Vue d'ensemble

Astroport.ONE fonctionne selon un **modèle économique coopératif** où :
- Les utilisateurs paient des loyers (MULTIPASS) ou achètent des parts sociales (ZEN Cards)
- Les capitaines gèrent les nœuds et collectent les revenus
- Le surplus est réparti selon la règle **3×1/3** (Trésorerie, R&D, Actifs)
- Les bénéfices financent l'acquisition de biens communs (forêts, terres)

## 📊 Calculateurs Disponibles

### 1. Simulateur Satellite (Web)

**URL** : [https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)

**Usage** : Calcul économique pour un **nœud satellite unique** (Raspberry Pi 5)

**Fonctionnalités** :
- Curseurs interactifs pour ajuster les paramètres
- Calcul automatique des revenus et coûts
- Visualisation du surplus coopératif
- Répartition 3×1/3 en temps réel

**Paramètres ajustables** :
- Nombre d'utilisateurs MULTIPASS (1 Ẑ/semaine)
- Nombre d'utilisateurs ZEN Cards (50 Ẑ/an)
- PAF (Participation Aux Frais) hebdomadaire
- Tarifs des services

### 2. Simulateur Constellation (Web)

**URL** : [https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)

**Usage** : Modélisation économique d'une **constellation complète** (réseau de nœuds)

**Fonctionnalités** :
- Modélisation de constellations (1 Hub + 24 Satellites)
- Calcul des coûts d'équipe (développeurs, community managers)
- Projection de l'impact écologique (acquisition de forêts)
- Scénarios pré-configurés
- Analyse de rentabilité réseau

**Paramètres ajustables** :
- Nombre de capitaines/nœuds
- Nombre total d'utilisateurs
- Équipe R&D (développeurs, community managers)
- Salaires de l'équipe
- Mix MULTIPASS/ZEN Cards

**Scénarios pré-configurés** :
1. **Satellite Local** : 100 utilisateurs, 1 développeur, 10 nœuds
2. **Constellation Régionale** : 500 utilisateurs, 2 développeurs, 25 nœuds
3. **Méga-Constellation** : 1500 utilisateurs, 5 développeurs, 100 nœuds

### 3. Feuilles de Calcul ODS (Offline)

**Fichiers** :
- `Satellite Economy.ods` - Modèle pour un satellite
- `SWARM Economy.ods` - Modèle pour un essaim

**Usage** : Planification avancée et analyse offline

**Avantages** :
- Formules personnalisables
- Analyse de scénarios multiples
- Export de données
- Calculs complexes

## 📖 Guide d'Utilisation

### Étape 1 : Définir votre Objectif

**Questions à se poser** :
- Voulez-vous gérer un seul satellite ou une constellation ?
- Combien d'utilisateurs ciblez-vous ?
- Avez-vous une équipe R&D à financer ?
- Quel est votre budget d'infrastructure ?

### Étape 2 : Utiliser le Simulateur Web

#### Pour un Satellite Unique

1. Ouvrez le [Simulateur Satellite](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)
2. Ajustez les curseurs :
   - Nombre d'utilisateurs MULTIPASS
   - Nombre d'utilisateurs ZEN Cards
   - PAF hebdomadaire
3. Observez les résultats :
   - Revenus totaux
   - Coûts d'infrastructure
   - Surplus coopératif
   - Répartition 3×1/3

#### Pour une Constellation

1. Ouvrez le [Simulateur Constellation](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)
2. Choisissez un scénario pré-configuré ou créez le vôtre
3. Ajustez les paramètres :
   - Nombre de capitaines/nœuds
   - Nombre d'utilisateurs
   - Équipe R&D
4. Analysez les KPIs :
   - Point mort (seuil de rentabilité)
   - Marge brute
   - Emplois créés
   - Impact écologique (m² de forêt)

### Étape 3 : Analyser les Résultats

**Indicateurs clés à surveiller** :

1. **Point mort** : Nombre d'utilisateurs minimum pour être rentable
2. **Marge brute** : Pourcentage de revenus après coûts directs
3. **Surplus coopératif** : Montant disponible pour la répartition 3×1/3
4. **Impact écologique** : Surface de forêt-jardin acquise par cycle

**Objectifs recommandés** :
- Point mort < 50% de la capacité
- Marge brute > 60%
- Surplus coopératif > 30% des revenus

### Étape 4 : Planifier avec les ODS (Optionnel)

Pour une analyse plus approfondie :

1. Téléchargez les fichiers ODS
2. Ouvrez avec LibreOffice Calc ou Google Sheets
3. Personnalisez les formules selon vos besoins
4. Créez plusieurs scénarios
5. Exportez les données pour présentation

## 💡 Exemples Concrets

### Exemple 1 : Satellite Local (Débutant)

**Configuration** :
- 1 satellite (Raspberry Pi 5)
- 50 utilisateurs MULTIPASS (1 Ẑ/semaine)
- 10 utilisateurs ZEN Cards (50 Ẑ/an)
- PAF : 14 Ẑ/semaine

**Calculs** :
- Revenus MULTIPASS : 50 × 1 Ẑ/semaine = 50 Ẑ/semaine = 2600 Ẑ/an
- Revenus ZEN Cards : 10 × 50 Ẑ/an = 500 Ẑ/an
- Revenus totaux : 3100 Ẑ/an
- Coûts PAF : 14 Ẑ/semaine = 728 Ẑ/an
- Rémunération Capitaine : 2× PAF = 28 Ẑ/semaine = 1456 Ẑ/an
- Surplus : 3100 - 728 - 1456 = 916 Ẑ/an
- Répartition 3×1/3 : ~305 Ẑ pour chaque fonds (Trésorerie, R&D, Actifs)

**Résultat** : Satellite viable avec surplus modeste mais positif.

### Exemple 2 : Constellation Régionale

**Configuration** :
- 25 nœuds (1 Hub + 24 Satellites)
- 400 utilisateurs MULTIPASS
- 100 utilisateurs ZEN Cards
- 2 développeurs (4340 Ẑ/mois chacun)
- 1 community manager (1360 Ẑ/mois)

**Calculs** (utilisez le [Simulateur Constellation](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)) :
- Revenus récurrents : ~208k Ẑ/an
- Achat parts sociales : 50k Ẑ/an
- Point mort : ~180 utilisateurs
- Marge brute : ~85%
- Impact écologique : ~400 m² de forêt/mois

**Résultat** : Constellation très viable avec équipe R&D complète.

### Exemple 3 : Méga-Constellation

**Configuration** :
- 100 nœuds (4 Hubs + 96 Satellites)
- 1200 utilisateurs MULTIPASS
- 300 utilisateurs ZEN Cards
- 5 développeurs
- 3 community managers

**Résultats attendus** :
- Point mort : ~220 utilisateurs
- Marge brute : ~90%
- Impact : Écosystème R&D complet
- Écologie : ~1500 m² de forêt/mois

## 🎯 Conseils pour Optimiser votre Modèle

### 1. Mix Utilisateurs Optimal

**Recommandation** : 80% MULTIPASS + 20% ZEN Cards

**Pourquoi** :
- MULTIPASS : Revenus récurrents stables
- ZEN Cards : Capital initial + revenus récurrents
- Équilibre entre stabilité et croissance

### 2. Dimensionnement Infrastructure

**Capacité par station** :
- **250 MULTIPASS** maximum par satellite
- **24 ZEN Cards** maximum par satellite

**Calcul du nombre de nœuds** :
```
Nœuds nécessaires = MAX(
  (MULTIPASS / 250),
  (ZEN Cards / 24)
)
```

### 3. Équipe R&D

**Recommandations** :
- **1 développeur** pour 10-15 nœuds
- **1 community manager** pour 200-300 utilisateurs
- Salaires : Développeur 3080-5600 Ẑ/mois, CM 1100-1620 Ẑ/mois

### 4. PAF Optimal

**Valeur par défaut** : 14 Ẑ/semaine

**Ajustements** :
- Raspberry Pi 5 : 10-14 Ẑ/semaine
- PC Gamer : 20-30 Ẑ/semaine
- Selon coûts réels (électricité, internet)

## 📈 Interprétation des Résultats

### Point Mort (Seuil de Rentabilité)

**Définition** : Nombre d'utilisateurs minimum pour couvrir tous les coûts.

**Interprétation** :
- < 50% de capacité : Excellent
- 50-70% de capacité : Bon
- > 70% de capacité : À améliorer

### Marge Brute

**Définition** : Pourcentage de revenus après coûts directs.

**Interprétation** :
- > 80% : Excellent
- 60-80% : Bon
- < 60% : À optimiser

### Surplus Coopératif

**Définition** : Montant disponible pour la répartition 3×1/3.

**Répartition** :
- 1/3 Trésorerie (liquidité)
- 1/3 R&D (innovation)
- 1/3 Actifs (forêts, terres)

### Impact Écologique

**Définition** : Surface de forêt-jardin acquise grâce au fonds Actifs.

**Calcul** : Basé sur 1/3 du surplus alloué aux Actifs.

## 🔗 Ressources Complémentaires

- [ZEN.ECONOMY.readme.md](https://github.com/papiche/Astroport.ONE/blob/master/RUNTIME/ZEN.ECONOMY.readme.md) - Documentation complète du modèle économique
- [UPlanet Cooperative](https://ipfs.copylaradio.com/ipns/copylaradio.com/entrance.html) - Site de la coopérative
- [Simulateur Satellite](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html) - Calculateur web pour satellite
- [Simulateur Constellation](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html) - Calculateur web pour constellation

## ❓ Questions Fréquentes

### Puis-je modifier les tarifs ?

Oui, les tarifs sont ajustables dans les simulateurs. Cependant, les valeurs par défaut (1 Ẑ/semaine pour MULTIPASS, 50 Ẑ/an pour ZEN Card) sont recommandées pour la cohérence du réseau.

### Comment calculer mon ROI ?

Utilisez les simulateurs web pour projeter sur 12 mois. Le ROI dépend de :
- Investissement initial (matériel)
- Nombre d'utilisateurs
- Coûts d'infrastructure
- Surplus généré

### Quelle est la capacité maximale d'un satellite ?

- **250 MULTIPASS** (uDRIVE 10GB chacun)
- **24 ZEN Cards** (NextCloud 128GB chacun)

### Comment rejoindre l'équipe R&D ?

Consultez les offres d'emploi sur le forum Monnaie Libre. Les postes sont financés par le fonds R&D (1/3 du surplus coopératif).

---

**Dernière mise à jour** : Basé sur les simulateurs web UPlanet et la documentation ZEN.ECONOMY.readme.md

