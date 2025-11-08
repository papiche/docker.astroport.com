# Astroport.ONE Docker - Quick Start Guide

## 🚀 Installation en une commande

```bash
docker-compose up -d
```

C'est tout ! Astroport.ONE est maintenant installé et fonctionne.

## 📋 Vérification

```bash
# Voir les logs
docker-compose logs -f

# Vérifier que les services tournent
docker-compose ps

# Vérifier la santé du container
docker-compose exec astroport pgrep -f "12345.sh"
```

## 🔧 Services disponibles

Une fois démarré, les services suivants sont accessibles :

- **uSPOT API** : http://localhost:54321
  - Upload/download de fichiers via UPlanet File Contract
  - API REST pour la gestion de fichiers

- **IPFS Gateway** : http://localhost:8080
  - Accès au contenu IPFS
  - Navigation dans le réseau IPFS

- **NOSTR Relay** : ws://localhost:7777
  - Relay NOSTR pour les événements décentralisés
  - Synchronisation constellation (N² protocol)

- **Astroport SYNC** : http://localhost:12345
  - API de synchronisation swarm
  - Gestion du nœud Astroport

- **Prometheus** : http://localhost:9090
  - Métriques système
  - Monitoring

## 🔄 Fonctionnement automatique

### Synchronisation horaire (N² Protocol)

Le système synchronise automatiquement les événements NOSTR toutes les heures :

```
12345.sh → _12345.sh → backfill_constellation.sh (chaque heure)
```

### Maintenance quotidienne

Le script `20h12.process.sh` s'exécute automatiquement chaque jour à 20h12 :

- Mise à jour des dépôts Git
- Nettoyage des caches
- Redémarrage des services
- Analyse du système (heartbox_analysis.sh)

## 📁 Persistance des données

Toutes les données sont stockées dans des volumes Docker :

- `astroport-data` : Configuration et données (`~/.zen`)
- `astroport-workspace` : Dépôts Git (`~/.zen/workspace`)
- `astroport-ipfs` : Données IPFS (`~/.ipfs`)

**Important** : Les données persistent même si vous arrêtez le container.

## 🛠️ Commandes utiles

```bash
# Arrêter les services
docker-compose down

# Redémarrer les services
docker-compose restart

# Voir les logs d'un service spécifique
docker-compose logs -f astroport

# Accéder au shell du container
docker-compose exec astroport bash

# Exécuter une commande dans le container
docker-compose exec astroport ipfs swarm peers
```

## 🔍 Dépannage

### Les services ne démarrent pas

```bash
# Vérifier les logs
docker-compose logs

# Vérifier l'espace disque
df -h

# Vérifier les ports utilisés
netstat -tulpn | grep -E '54321|8080|7777|12345'
```

### IPFS ne se connecte pas

```bash
# Vérifier le daemon IPFS
docker-compose exec astroport ipfs daemon --version

# Vérifier les peers
docker-compose exec astroport ipfs swarm peers
```

### Constellation sync ne fonctionne pas

```bash
# Vérifier que backfill_constellation.sh existe
docker-compose exec astroport ls -la ~/.zen/workspace/NIP-101/backfill_constellation.sh

# Vérifier les logs de _12345.sh
docker-compose exec astroport tail -f ~/.zen/logs/12345.log
```

## 📚 Documentation complète

- `README.md` : Documentation complète du projet
- `ARCHITECTURE_ANALYSIS.md` : Analyse approfondie de l'architecture
- `DOCKER_IMPROVEMENTS.md` : Détails des améliorations Docker
- `README.DOCKER.md` : Documentation spécifique Docker

## 🎯 Prochaines étapes

1. **Configuration Captain** (optionnel) :
   ```bash
   docker-compose exec astroport ~/.zen/Astroport.ONE/captain.sh
   ```

2. **Upload de fichiers** :
   ```bash
   curl -X POST http://localhost:54321/api/fileupload \
        -F "file=@yourfile.jpg" \
        -F "npub=your_nostr_public_key"
   ```

3. **Vérifier la synchronisation** :
   ```bash
   docker-compose exec astroport ~/.zen/Astroport.ONE/tools/dashboard.sh
   ```

## ⚠️ Notes importantes

- Le container nécessite au moins 2GB de RAM
- L'installation initiale peut prendre plusieurs minutes
- Les ports 54321, 8080, 7777, 12345 doivent être libres
- Pour la production, configurez un reverse proxy (nginx) pour HTTPS

## 🆘 Support

En cas de problème :
- Vérifiez les logs : `docker-compose logs`
- Consultez la documentation : `README.md`
- Contact : support@qo-op.com

