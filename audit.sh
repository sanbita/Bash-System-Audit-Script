#!/bin/bash

# -------------------------------------------------
# Script: audit.sh
# Description: Génère un rapport d'audit système interactif
# -------------------------------------------------

# Couleurs
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # Pas de couleur

# Création du dossier audit_logs
LOG_DIR="./audit_logs"
mkdir -p "$LOG_DIR"
REPORT="$LOG_DIR/audit_report_$(date +%Y%m%d_%H%M%S).txt"

# Affichage de la bannière
echo -e "${CYAN}==============================================="
echo -e "               AUDIT SYSTÈME                  "
echo -e "Date : $(date)"
echo -e "Utilisateur : $(whoami)"
echo -e "===============================================${NC}"

# Menu interactif
echo -e "${YELLOW}Choisissez les vérifications à effectuer :${NC}"
echo "1) Informations système"
echo "2) Utilisateurs"
echo "3) Permissions SUID"
echo "4) Processus les plus gourmands en mémoire"
echo "5) Ports ouverts"
echo "6) Fichiers sensibles"
echo "7) Tout"
read -p "Entrez votre choix (1-7) : " choice

# Fonction pour informations système
info_systeme() {
    echo -e "${BLUE}--- INFORMATIONS SYSTÈME ---${NC}"
    echo "Nom du système : $(uname -n)" | tee -a "$REPORT"
    echo "Version du noyau : $(uname -r)" | tee -a "$REPORT"
    echo "Espace disque :" | tee -a "$REPORT"
    df -h | tee -a "$REPORT"
    echo "" | tee -a "$REPORT"
}

# Fonction pour utilisateurs
users_info() {
    echo -e "${BLUE}--- UTILISATEURS ---${NC}"
    echo "Utilisateurs locaux (UID > 1000) :" | tee -a "$REPORT"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd | tee -a "$REPORT"
    echo "" | tee -a "$REPORT"
    echo "Derniers utilisateurs connectés :" | tee -a "$REPORT"
    last -n 10 | tee -a "$REPORT"
    echo "" | tee -a "$REPORT"
}

# Fonction fichiers SUID
suid_info() {
    echo -e "${BLUE}--- FICHIERS AVEC BIT SUID ---${NC}"
    find / -type f -perm -4000 -exec ls -l {} \; 2>/dev/null | tee -a "$REPORT"
    echo "" | tee -a "$REPORT"
}

# Fonction processus
process_info() {
    echo -e "${BLUE}--- TOP 5 PROCESSUS PAR MEMOIRE ---${NC}"
    ps aux --sort=-%mem | head -n 6 | tee -a "$REPORT"
    echo "" | tee -a "$REPORT"
}

# Fonction ports ouverts
ports_info() {
    echo -e "${BLUE}--- PORTS OUVERTS (ss -tuln) ---${NC}"
    ss -tuln | tee -a "$REPORT"
    echo "" | tee -a "$REPORT"
}

# Fonction fichiers sensibles
sensitive_files() {
    echo -e "${BLUE}--- VERIFICATION FICHIERS SENSIBLES ---${NC}"
    for file in /etc/shadow /etc/passwd /etc/sudoers; do
        if [ -e "$file" ]; then
            if [ -r "$file" ]; then
                echo -e "${RED}[ALERTE] $file est lisible par $(whoami)${NC}" | tee -a "$REPORT"
            else
                echo -e "${GREEN}[OK] $file protégé${NC}" | tee -a "$REPORT"
            fi
        else
            echo -e "${YELLOW}[INFO] $file n'existe pas${NC}" | tee -a "$REPORT"
        fi
    done
    echo "" | tee -a "$REPORT"
}

# Exécution en fonction du choix
case $choice in
    1) info_systeme ;;
    2) users_info ;;
    3) suid_info ;;
    4) process_info ;;
    5) ports_info ;;
    6) sensitive_files ;;
    7)
        info_systeme
        users_info
        suid_info
        process_info
        ports_info
        sensitive_files
        ;;
    *)
        echo -e "${RED}Choix invalide${NC}"
        exit 1
        ;;
esac

echo -e "${CYAN}Audit terminé. Rapport enregistré dans : $REPORT${NC}"
