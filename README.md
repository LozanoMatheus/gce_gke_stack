# Deploy GKE cluster

The intention for this project is to deploy a Google Cloud GKE Stack configured, with auto-scaler, over TLS and fully automated. Also, it will deploy the dashboard and Joomla/MariaDB.

## How to use

You can run the initial Bash script, it will look for dependencies (terraform, helm, etc) and you can choose between Deploy, Destroy and just deploy the apps.

Example:

```text
./deploy_eks_stack.sh
2019-07-14 19:07:24 Checking for dependencies
What action you want to execute?
1) Deploy
2) Destroy
3) Deploy apps
Default: Deploy
-> 1
```

or

```text
./deploy_eks_stack.sh Deploy
2019-07-21 21:37:45 Checking for dependencies
2019-07-21 21:37:46 Starting to deploy the Google Cloud GKE Stack
2019-07-21 21:37:46 Runnning terraform init
```

## Getting my Token

By default, this automation will create two users. One is `mlozano-admin` (Cluster admin) and another `mlozano-user` (For default namespace).

To get the token, you can run this command.

```bash
my_user=mlozano
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/'"${my_user}"'/ { rc = 1; print $NF }; END { exit !rc }' || echo "user not found")
```

## Endpoints

All endpoints will be exposed via sidecar, via HTTP over TLS.

* Kubernetes Dashboard - https://kubernetes-dashboard.lozanomatheus.com
* Joomla app - https://joomla.lozanomatheus.com
