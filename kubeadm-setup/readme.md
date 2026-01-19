#  Kubernetes Setup using kubeadm (Ubuntu 24.04)

**This guide sets up:**
- 1 Control Plane
- 2 Worker Nodes
- CNI: `Flannel`
- K8s version: `1.34`

### 1. Install Container Runtime [Master & Worker]
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

### 2. Install Kubernetes Packages [Master & Worker]
```bash
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

### 3. Enable Networking Prerequisites [Master & Worker]
```sh
# Load required kernel module
sudo modprobe br_netfilter

# Verify module loaded
lsmod | grep br_netfilter

# Enable IP forwarding & bridge traffic to iptables
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply settings
sudo sysctl --system

# Verify
sysctl net.ipv4.ip_forward
sysctl net.bridge.bridge-nf-call-iptables

# restart containerd
sudo systemctl restart containerd
```

### 4. Initialize Control Plane [Only Master]
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

**Configure kubectl:**
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 5. Install Flannel CNI [Only Master]
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

### 6. Join Worker Nodes [On Workers]
**Run the command shown after kubeadm init:**
```bash
sudo kubeadm join <MASTER_IP>:6443 \
 --token xxxx \
 --discovery-token-ca-cert-hash sha256:xxxx
```

### 7. Verify Cluster
```bash
kubectl get nodes -o wide

# Verify networking
kubectl get pods -n kube-system  -o wide
kubectl get pods -n kube-flannel  -o wide

# Test pod
kubectl run nginx --image=nginx
kubectl get pods -o wide
```

### 8. Common Checks
```bash
ls /run/flannel
cat /run/flannel/subnet.env
journalctl -u kubelet -f
```
