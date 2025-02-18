# INSTALLING KUBERNETES

## Prerequistes
* 3 VMs with 2 CPUs and 2Gb of RAM

## Steps

NOTE: Repeate the steps in all VM instances

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
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -  # Download the kubernetes repo apt-key
    echo "deb http://api.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list # Writes the kubernetes repo address
    apt-get update
    ```

1. Install kubernetes:
    ```bash
    apt get install -y kubeadm kubelet kubectl
    ```

## Master Node settings
1. In the cluster master node, pull the admin images and init kubeadm:
    ```bash
    kubeadm config images pull
    kubeadm init 
    ```

1. Create the home folder for kubernetes:
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chwon $(id -u):$(id -g) $HOME/.kube/config
    ```

1. Make sure that the following network modules are enabled in the kernel:
    ```bash
    modeprobe br_netfilter ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack_ipv4 ip_vs
    ```

1. Deploy the wave net to allows pods from different nodes to connect to each other:
    ```bash
    kubectl apply -f "" #
    ```

1. Check the pods used by cluster to manage itself:
    ```bash
    kubectl get pods -n kube-system 
    ```

## Worker Node settings
1. In the worker master node, run the following command to join the kubernetes cluster:
    ```bash
    kubeadm join IP:port --token --discovery-token-ca-cert-hash
    ```

1. Go back to the master node and check if the workes node has successfully joined the cluster:
    ```bash
    kubectl get nodes
    ```
