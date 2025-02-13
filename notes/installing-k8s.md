# INSTALLING KUBERNETES

## Prerequistes
3 VMs with 2 cores and 2Gb of RAM

## Steps

NOTE: Repeate the steps in all VM instances

1. Install docker:
```bash
curl -fsSL https://get.docker.com | bash
```

2. Edit `etc/docker/daemon.json` and add the following content:
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

mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
docker info | grep -i cgroup #should prompt Cgroup Driver: systemd

curl a apt gpg key repositorio kubernetes
echo repo k8s
apt-get update

apt get install -y kubeadm kubelet kubectl


#no node master
kubeadm config images pull

kubeadm init 

mkdir -p $HOME/.KUBE
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chwon $(id -u):$(id -g) $HOME/.kube/config

modeprobe br_netfilter ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack_ipv4 ip_vs
kubectl apply -f "" #wave net, allows pod from different nodes do connect to each other

kubectl get pods -n kube-system # list pods used by cluster to manage itself

# on worker nodes
kubeadm join IP:port --token --discovery-token-ca-cert-hash #to add a node to the cluster

#on master node
kubectl get nodes #check if nodes are ready to be used