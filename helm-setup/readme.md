# Helm Guide for Kubernetes

Helm is the package manager for Kubernetes — same as Apt/Yum/Homebrew but for K8s applications.

### 📌 Why Helm?

| Without Helm                | With Helm                         |
| --------------------------- | --------------------------------- |
| Many YAML files to manage   | One reusable chart package (.tgz) |
| Manual deployment & updates | `install`, `upgrade`, `rollback`  |
| Not reusable                | Template-based, DRY configs       |
| Hard to version             | Versioned releases with history   |



### 🛠️ Install Helm
```sh
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm version
```

### 📚 Helm Essential Commands

| Action            | Command                               |
| ----------------- | ------------------------------------- |
| Search charts     | `helm search hub nginx`               |
| Install chart     | `helm install my-nginx bitnami/nginx` |
| List releases     | `helm list`                           |
| Upgrade release   | `helm upgrade my-nginx bitnami/nginx` |
| Rollback release  | `helm rollback my-nginx 1`            |
| Uninstall release | `helm uninstall my-nginx`             |


### 📦 Add Repository
**1. Adding repo**
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update
```

**2. Install Nginx using Helm**
```sh
helm install webserver bitnami/nginx -n dev --create-namespace

#verify
kubectl get pods -n dev
kubectl get svc -n dev
```

If service is not exposed, expose manually:
```sh
kubectl expose deployment webserver-nginx --type=NodePort --name=nginx-svc -n dev
```

**3. Upgrade & Rollback**
Upgrade with new values
```sh
helm upgrade webserver bitnami/nginx --set service.type=NodePort -n dev
```
Check release history
```sh
helm history webserver -n dev
```
Rollback
```sh
helm rollback webserver 1 -n dev
```

### 🛠️ Custom Charts

**1. Create Your Own Helm Chart**
```sh
helm create myapp
```

**Generated structure:**
```rust
myapp/
 ├ charts/            # dependencies
 ├ templates/         # Kubernetes YAML templates
 ├ values.yaml        # user override values
 └ Chart.yaml         # chart metadata
```

**2. Deploy Your Custom Chart**
```sh
helm install myapp-release ./myapp -n dev

kubectl get all -n dev
```

**Update changes → deploy again**
```sh
helm upgrade myapp-release ./myapp -n dev
```

**3. Change Parameters with `values.yaml`**
```yml
replicaCount: 4

image:
  repository: nginx
  tag: "1.25"

service:
  type: NodePort
  port: 80
```

**Apply with values:**
```sh
helm upgrade myapp-release ./myapp -f values.yaml -n dev
```

**4. Package & Share Your Helm Chart**
- Create distributable `.tgz` file
  ```sh
  helm package myapp/
  ```
- Install packaged chart
  ```sh
  helm install local-app myapp-0.1.0.tgz -n dev
  ```


### Helm Workflow Summary

| Step         | Command                   |
| ------------ | ------------------------- |
| Create chart | `helm create app`         |
| Edit values  | Modify `values.yaml`      |
| Install      | `helm install app ./app`  |
| Upgrade      | `helm upgrade app ./app`  |
| Rollback     | `helm rollback app <REV>` |
