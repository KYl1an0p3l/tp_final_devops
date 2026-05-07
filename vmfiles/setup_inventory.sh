#!/bin/bash
echo "Démarrage de la récupération de l'IP..."

# 1. Récupération de l'IP interne de la VM (eth1)
VM_IP=""
for i in {1..10}; do
    VM_IP=$(vagrant ssh -c "ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'" 2>/dev/null | tr -d '\r')
    [ -n "$VM_IP" ] && break
    echo "Attente IP... ($i/10)"
    sleep 3
done

if [ -z "$VM_IP" ]; then echo "Erreur IP"; exit 1; fi

# 2. Détection de l'environnement (WSL ou Natif)
# Si "Microsoft" ou "wsl" apparaît dans la version du noyau, on est sur WSL
IS_WSL=$(grep -iE "(microsoft|wsl)" /proc/version)

if [ -n "$IS_WSL" ]; then
    echo "Détection : Environnement WSL."
    GATEWAY_IP=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
    SSH_PORT=$(vagrant ssh-config | grep 'Port ' | awk '{print $2}')

    # On vérifie si 127.0.0.1 répond sur le port 2222
    if nc -z -w 2 127.0.0.1 $SSH_PORT >/dev/null 2>&1; then
        SSH_HOST="127.0.0.1"
        echo "Localhost (127.0.0.1) répond. Utilisation du chemin direct."
    else
        SSH_HOST="$GATEWAY_IP"
        echo "Localhost ne répond pas. Passage par la passerelle Windows ($SSH_HOST)."
    fi
else
    # Code pour Linux natif
    SSH_HOST="$VM_IP"
    SSH_PORT="22"
fi

# 3. Génération de l'inventaire dynamique
cat <<EOF > inventory.ini
[k3s_nodes]
$VM_IP ansible_host=$SSH_HOST ansible_port=$SSH_PORT ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "Inventaire généré pour $SSH_HOST:$SSH_PORT"