# Kubernetes
Practical exercises and tasks related to Kubernetes fundamentals covered in the CSCE certification course are provided below.

## Table of Contents
- [Kubernetes](#kubernetes)
  - [Table of Contents](#table-of-contents)
  - [Kubernetes Resources](#kubernetes-resources)
  - [Kubernetes Networking](#kubernetes-networking)
  - [Storage](#storage)

## Kubernetes Resources

**Task**

*Create a Kubernetes deployment from a manifest (available in [manifests/deployment.yaml](./manifests/deployment.yaml)).*

```bash
kubectl apply -f manifests/deployment.yaml
```

*Create service from a manifest (available in [manifests/service.yaml](./manifests/service.yaml)).*

```bash
kubectl apply -f manifests/service.yaml
```

*Verify that the deployment and service resources have been created.*

```bash
$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
demo-deployment-77f55749dd-8gzh6   1/1     Running   0          38s
demo-deployment-77f55749dd-cf77x   1/1     Running   0          37s
demo-deployment-77f55749dd-czn59   1/1     Running   0          38s

$ kubectl get svc
NAME           TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
demo-service   ClusterIP   10.111.35.3   <none>        80/TCP    61s
```

*Clean Up*

```bash
$ kubectl delete deploy demo-deployment
$ kubectl delete svd demo-service
```

**Task**

*Create a Kubernetes Secret with this key-value pair: `password: secretpassword`.*

```bash
$ kubectl create secret generic postgres-pw -n demo-namespace --from-literal password=secretpassword
```
*Include the Secret in the StatefulSet.*

The created secret `postgres-pw` is included accordingly in the Stateful manifest available in [manifests/stateful-set.yaml](./manifests/stateful-set.yaml). 

*Include the Secret as an environment variable POSTGRES_PASSWORD in the StatefulSet.*

Secret is added as environment variable in the [manifest](./manifests/stateful-set.yaml).

*Change the number of replicas to 2.*

Replicas are entered accordingly in the [manifest](./manifests/stateful-set.yaml).

*Verify*

```bash
$ kubectl get po -n demo-namespace -w
NAME         READY   STATUS    RESTARTS   AGE
postgres-0   1/1     Running   0          86s
postgres-1   1/1     Running   0          73s
```

*Clean up*

```bash
$ kubectl delete ns demo-namespace
```

**Task**

*Adjust the following manifest so that you can apply it in your cluster without error.*

```yaml
apiVersion: aps/v1
kind: Deployment
metadata:
  name: faulty-deployment
spec:
  replicas: "two"
  selector:
    matchLabels:
      app: faulty-app
  template:
    metadata:
      labels:
        app: faulty-app
    spec:
      containers:
      - name: faulty-container
        img: nginx:laaaaaaaaaaaaaaaaaaatest
```

Correct manifest is available in [manifests/correct-deployment.yaml](./manifests/correct-deployment.yaml).

*Verify*

```bash
$ kubectl create -f manifests/correct-deployment.yaml
deployment.apps/correct-deployment created
$ kubectl get deploy
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
correct-deployment   2/2     2            2           12s
$ kubectl get po -o wide
NAME                                  READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
correct-deployment-7d48bbfdbc-s7qwf   1/1     Running   0          17s   10.244.1.8   minikube-m02   <none>           <none>
correct-deployment-7d48bbfdbc-zn6fh   1/1     Running   0          17s   10.244.0.8   minikube       <none>           <none>
```

*Clean up*

```bash
kubectl delete deploy correct-deployment
```

## Kubernetes Networking

**Task**

*Expose an example application via a NodePort Service and check its accessibility in the browser.*

```bash
# Create deployment
$ kubectl create deployment nginx --image=nginx
# Create Service (NodePort)
$ kubectl expose deployment nginx --port=80 --type=NodePort
# Determine Port
$ kubectl get svc nginx -o wide
NAME    TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE   SELECTOR
nginx   NodePort   10.101.193.179   <none>        80:31515/TCP   69s   app=nginx
```

*Verify the service*

```bash
# Determine node
$ kubectl get po -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
nginx-5869d7778c-6rbrp   1/1     Running   0          2m50s   10.244.0.5   minikube   <none>           <none>
# Determine node IP
$ kubectl get no -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION                     CONTAINER-RUNTIME
minikube       Ready    control-plane   9d    v1.32.0   192.168.49.2   <none>        Ubuntu 22.04.5 LTS   6.6.87.2-microsoft-standard-WSL2   docker://27.4.1
# Access http://<NodeIP>:<NodePort>
$ curl http://192.168.49.2:31515
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Storage

**Task**

*Equip a Pod with persistent storage so that data under /usr/share/nginx/html is preserved.*

**Solution**

1. Create appropriate persistent volume (PV) and persistent volume claim (PVC) resources using manifests in [manifests/pv.yaml](./manifests/pv.yaml) and [manifests/pvc.yaml](./manifests/pvc.yaml).
```bash
$ kubectl create -f manifests/pv.yaml
$ kubectl create -f manifests/pvc.yaml
```
2. Create pod with manifest in [manifests/pod-with-pv.yaml](./manifests/pod-with-pv.yaml).
```bash
$ kubectl create -f manifests/pod-with-pv.yaml
```
3. Verify
```bash
# store a temp file in the attached volume
$ kubectl exec -it demo-pod -- bin/bash
root@demo-pod:/# touch /usr/share/nginx/html/data.txt
root@demo-pod:/# echo test data > /usr/share/nginx/html/data.txt
root@demo-pod:/# cat /usr/share/nginx/html/data.txt
test data
root@demo-pod:/# exit
# delete the pod
$ kubectl delete pod demo-pod
# recreate the pod and check if the previously stored data is persisted
$ kubectl create -f manifests/pod-with-pv.yaml
$ kubectl exec -it demo-pod -- cat /usr/share/nginx/html/data.txt
test data
```