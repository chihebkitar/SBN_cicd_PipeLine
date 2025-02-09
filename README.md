# Vue d’Ensemble du Pipeline CI/CD

Ce dépôt utilise un pipeline GitHub Actions pour **compiler**, **tester**, **analyser la sécurité**, **containeriser** et **déployer** notre application Spring Boot sur **Railway**. Les principales étapes sont :

## 1. Build, Test, Couverture

- Utilise Maven (`mvn clean verify`) pour compiler et exécuter les tests unitaires/intégration.
- Génère un **rapport de couverture** de code (JaCoCo).
- Lance **OWASP Dependency Check** pour identifier les bibliothèques vulnérables.

## 2. Analyse Statique (CodeQL)

- Analyse le code pour détecter les failles de sécurité (ex. injections SQL).
- Fait échouer le pipeline si des vulnérabilités critiques sont découvertes.

## 3. Build & Scan Docker

- Construit une image Docker via un **Dockerfile multi-stage**, pour un résultat plus léger.
- Analyse l’image avec **Trivy** pour les vulnérabilités critiques.
- Pousse l’image approuvée sur **Docker Hub**.

## 4. Déploiement sur Railway

- Le pipeline utilise la CLI Railway pour redéployer un **service Docker**.
- Railway récupère l’image Docker sur Docker Hub et l’exécute dans un environnement hébergé.

## Détails du Workflow

- **Fichier** : [`.github/workflows/backend-ci-cd.yml`](.github/workflows/backend-ci-cd.yml)
- **Déclencheurs** : `push` et `pull_request` sur les branches `main` ou `master`.
- Échec rapide si les tests, scans ou checks de sécurité échouent.
- Conserve les **artifacts** (résultats de tests, couverture) pour consultation dans GitHub Actions.

## Dockerfile

- Un **Dockerfile multi-stage** garantit un runtime Java minimal + un JAR compilé.
- **Stage 1** (builder) : `maven:3.9.2-eclipse-temurin-17` pour compiler.
- **Stage 2** (runtime) : `eclipse-temurin:17-jre` pour une image plus légère.

## Secrets & Identifiants

- Les identifiants Docker Hub sont stockés comme **GitHub Secrets** (`DOCKER_HUB_USERNAME`, `DOCKER_HUB_PASSWORD`).
- Railway utilise un **jeton de projet** (`RAILWAY_TOKEN`) pour le déploiement en mode non interactif.

Avec cette configuration CI/CD, chaque commit est validé par des **tests**, des **scans de sécurité** et un **scan de container**, avant de déployer automatiquement la nouvelle image Docker sur notre service Railway.
