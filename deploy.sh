#!/bin/bash
PARENT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
cd "$PARENT_PATH/vmfiles"

export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1

echo "--- Étape 1 : Provisioning de la VM ---"
vagrant up --provider=virtualbox

echo "--- Étape 2 : Récupération de l'IP ---"
chmod +x setup_inventory.sh
./setup_inventory.sh

if [ -f "inventory.ini" ]; then
    echo "--- Étape 3 : Configuration K3s avec Ansible ---"
    sleep 5
    ansible-playbook -i inventory.ini install_k3s.yml
else
    echo "L'inventaire n'a pas pu être généré."
    exit 1
fi

echo "--- Étape 4 : Déploiement de l'Application sur K3s ---"
# On utilise le nouveau chemin où Ansible a copié les fichiers
vagrant ssh -c "sudo k3s kubectl apply -f /home/vagrant/k8s/"

echo "------------------------------------------------"
echo "Infrastructure et Application prêtes !"
echo "Vérification des pods :"
vagrant ssh -c "sudo k3s kubectl get pods"