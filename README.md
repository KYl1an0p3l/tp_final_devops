# TP DevOps : Infrastructure Automatisée, Orchestration et CI/CD

Ce projet présente une chaîne de production logicielle complète, incluant le développement d'une API Node.js, son packaging Docker, et son déploiement orchestré sur un cluster K3s via une infrastructure automatisée.

## Architecture du Projet

Le projet repose sur une approche Infrastructure as Code (IaC) structurée en trois couches :

1. Infrastructure et Provisioning :
   * Vagrant : Déploiement d'une machine virtuelle Debian Bullseye.
   * Ansible : Automatisation de l'installation de K3s et des dépendances système (curl, iptables).

2. Orchestration (Kubernetes / K3s) :
   * Deployment : Gestion de la haute disponibilité de l'API et de la base de données.
   * Service (ClusterIP) : Exposition interne des composants pour la communication inter-services.
   * HPA (Horizontal Pod Autoscaler) : Mise à l'échelle automatique basée sur la consommation CPU pour garantir la robustesse.

3. Pipeline CI/CD :
   * GitHub Actions : Build automatisé de l'image Docker à chaque modification du code.
   * Docker Hub : Stockage et versioning de l'image (hamustra/api-test).

## Instructions de Déploiement

Lancer le fichier deploy.sh depuis un terminal Linux. Ce fichier se charge de l'intégralité du déploiement sur la machine.

### Pré-requis
* Vagrant et VirtualBox installés.
* Un environnement compatible (Linux ou WSL).

### Procédure

Au cours du premier déploiement, il y a des chances que les pods ne soient pas de suite en "Running" (affiché à la fin du déploiement), pour vérifier leur bon fonctionnement vous pouvez faire cette commande dans le terminal en vous plaçant dans le dossier vmfiles :
```bash
vagrant ssh -c "sudo k3s kubectl get pods"
```

### Membres 
  * Kylian OPEL
  * Logan COMBLE
  * Lucas MONNEHAY
  * Audrey VASSEUR
