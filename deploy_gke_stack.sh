#!/usr/bin/env bash

declare -xr PROJECT_BASEDIR="$(dirname "${BASH_SOURCE[0]}" | pwd)"
declare -xr CONFIG_DIR="${PROJECT_BASEDIR}/config_files"
declare -r  TERRAFORM_VERSION="${TERRAFORM_VERSION:-'0.12.4'}"
declare -r  LOG_FILE="/tmp/${0//.sh/}_$(date +'%Y%m%d').log"
declare -rl KERNEL_NAME="$(uname -s)"
declare -xr PROJECT_NAME="${PROJECT_NAME:-"kubernetes-learning-232815"}"
declare -xr GCP_REGION="${GCP_REGION:-"europe-west1"}"
declare -xr CLUSTER_NAME="${CLUSTER_NAME:-"mlozano"}"
declare -xr TF_VAR_my_public_ip="${MY_PUBLIC_IP:-"$(curl -s ifconfig.co)"}"
declare -xr TF_VAR_ssh_key_name="${SSH_KEY_NAME:-"ssh_key_eks_workers"}"
declare -xr TF_VAR_ssh_key_path="${SSH_KEY_PATH:-"${PROJECT_BASEDIR}/keys"}"

function log_msg() {
  echo "$(date +'%Y-%m-%d %T')" $@ | tee -a "${LOG_FILE}"
}

for i in bash_scripts/*.shinc ; do
  . "${i}"
done

log_msg "Checking for dependencies"
check_prereqs

if [[ -z "${1}" ]]; then
  declare -r TERRAFORM_QUESTION="What action you want to execute?
  1) Deploy
  2) Destroy
  3) App_deploy
  Default: Deploy
  -> "

  read -ep "${TERRAFORM_QUESTION}" terraform_action
  declare -lr TERRAFORM_ACTION="${terraform_action:-"Deploy"}"
else
  declare -lr TERRAFORM_ACTION="${1:-"Deploy"}"
fi

case "${TERRAFORM_ACTION}" in
  1|deploy)
    log_msg "Starting to deploy the Google Cloud GKE Stack"
    cd terraform_automation/
    terraform_deploy
    setup_kubectl
    setup_helm
    terraform_wait_nodes
    log_msg "Deploying apps"
    sleep 60s
    setup_cluster
    deploy_apps
    exit
    ;;
  2|destroy)
    log_msg "Starting to destroy the Google Cloud GKE Stack"
    cd terraform_automation/
    terraform_destroy
    [[ $? -eq 0 ]] && rm -rf *tfstate* .terraform/
    exit
    ;;
  3|app_deploy)
    log_msg "Deploying apps"
    sleep 60s
    setup_cluster
    deploy_apps
    exit
    ;;
  *)
    log_msg "The action \"${TERRAFORM_ACTION}\" is not known"
    exit
    ;;
esac
