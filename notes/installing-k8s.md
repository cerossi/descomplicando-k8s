# INSTALLING KUBERNETES

## Prerequistes
* 3 VMs with 2 CPUs and 2Gb of RAM

## Steps

NOTE: Repeate the steps in all VM instances

1. Turn off the swap:
    ```bash
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
    ```

1. Make sure that the following network modules are enabled in the kernel:
    ```bash
    sudo modprobe overlay
    sudo modprobe br_netfilter

    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
    ```

1. Configure the kernel:
    ```bash
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

    sudo sysctl --system
    ```

1. Install docker:
    ```bash
    curl -fsSL https://get.docker.com | bash
    ```

1. Edit `etc/docker/daemon.json` and add the following content:
    ```json
    {
        "exec-opts": ["native.cgroupdriver=systemd"],
        "log-driver": "json-file",
        "log-opts": {
            "max-size": "100m"
        },
        "storage-driver": "overlay2"
    }
    ```

1. Define docker systemctl settings:
    ```bash
    mkdir -p /etc/systemd/system/docker.service.d
    systemctl daemon-reload
    systemctl restart docker
    docker info | grep -i cgroup #should prompt Cgroup Driver: systemd
    ```

1. Setup kubernetes apt repo:
    ```bash
    
    
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    apt-get update
    ```

1. Install kubernetes:
    ```bash
    apt-get install -y kubeadm kubelet kubectl
    apt-mark hold kubelet kubeadm kubectl
    ```

## Master Node settings
1. In the cluster master node, pull the admin images and init kubeadm:
    ```bash
    curl -fsSLO https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.16/cri-dockerd_0.3.16.3-0.ubuntu-jammy_amd64.deb
    dpkg -i cri-dockerd_0.3.16.3-0.ubuntu-jammy_amd64.deb

    kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock
    kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock
    ```

1. Create the home folder for kubernetes:
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chwon $(id -u):$(id -g) $HOME/.kube/config
    ```



1. Deploy the wave net to allows pods from different nodes to connect to each other:
    ```bash
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    ```

1. Check the pods used by cluster to manage itself:
    ```bash
    kubectl get pods -n kube-system 
    ```

## Worker Node settings
1. In the worker master node, run the following command to join the kubernetes cluster:
    ```bash
    kubeadm join IP:port --token --discovery-token-ca-cert-hash
    kubeadm join 10.10.1.6:6443 --token mezxpb.sxcnyrlsagmadaqe \
	--discovery-token-ca-cert-hash sha256:40148b5bfc4ca5781c94565fbd85850ae8be9093730c6695070e014f19215a1c 
    ```

1. Go back to the master node and check if the workes node has successfully joined the cluster:
    ```bash
    kubectl get nodes
    ```
