kubectl apply -f jenkins-namespace.yml
kubectl apply -f jenkins-pv.yml
kubectl apply -f jenkins-pvc.yml
kubectl apply -f jenkins.yml
kubectl apply -f jenkins-service.yml
kubectl apply -f slave-deploy.yml
kubectl apply -f slave-svc.yml