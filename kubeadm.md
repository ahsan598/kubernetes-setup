#  Setup Kubernetes using kubeadm [Version --> 1.34]

### 1. Install containerd runtime[On Master & Worker Nodes]
```bash
sudo apt-get update
sudo apt install -y containerd

# create cgroupfs system driver for runtime
sudo mkdir -p /etc/containerd/

# Update the cgroup to 'true'
containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml

# Verify the changes
cat /etc/containerd/config.toml | grep -i SystemdCgroup -B 50

# restart containerd
sudo systemctl restart containerd
```

### 2. Install Required Dependencies for Kubernetes[On Master & Worker Nodes]
```bash
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
```

### 3. Add Kubernetes Repository and GPG Key[On Master & Worker Nodes]
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

### 4. Install Kubernetes Components[On Master & Worker Nodes]
```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

### 5. Initialize Kubernetes Master Node [On MasterNode]
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

### 6. Configure Kubernetes Cluster [On MasterNode]
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 7. Deploy Networking Solution (Flannel) [On MasterNode]
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
