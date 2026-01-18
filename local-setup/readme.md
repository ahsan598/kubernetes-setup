# Kubernetes Local Setup using KIND

**KIND (Kubernetes IN Docker)** is a tool that runs Kubernetes clusters inside Docker containers. It is ideal for local DevOps practice, CI testing, and learning Kubernetes.


### 🛠️ Prerequisites
Before you start, make sure you have installed:

| Tool        | Purpose                             | Documentation |
|-------------|-------------------------------------|---------------|
| **kubectl** | Interact with Kubernetes API server | [Install kubectl](https://kubernetes.io/docs/tasks/tools/)       |
| **Docker**  | Build and test container images locally | [Install Docker](https://docs.docker.com/engine/install/)     |


### 🔧 Installtion Steps

**1. Install Kind**
```sh
curl -Lo kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64

chmod +x kind
sudo mv kind /usr/local/bin/kind

# Verify with version
kind version
```

**2. Create a Single-Node Kubernetes Cluster using config**
```sh
kind create cluster --name dev-cluster --config kind-config.yaml

# Verify cluster details
kubectl cluster-info
kubectl get nodes
```

**3. Switch kubectl Context**
```sh
# list all contexts
kubectl config get-contexts

# switch to active cluster
kubectl config use-context kind-dev-cluster

# verify context
kubectl config current-context
```

> **NOTE:**
> `use-context` = switch the context
> `set-context` = modify context properties (does NOT switch)


**4. Delete Cluster (Full Reset)**
```sh
kind delete cluster --name dev-cluster
```

---

### 🧩 KIND Image Management
```sh
# List kind clusters and nodes
kind get clusters
kind get nodes --name <cluster-name>

# View images inside KIND node (containerd images)
docker exec -it <node-name> crictl images

# Load local Docker image into KIND cluster
kind load docker-image <image-name>:<tag> --name <cluster-name>

# (Optional but Recommended) Verify image inside KIND
docker exec -it <node-name> crictl images | grep <image-name>:<tag>

# Login into KIND node (shell)
docker exec -it <node-name> bash

# List or Remove images (inside KIND)
crictl images
crictl rmi <IMAGE_ID>

# Remove unused images inside KIND
crictl rmi --prune
```
