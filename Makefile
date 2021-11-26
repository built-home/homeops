
install_cluster:
	kind create cluster --config ./kubernetes/kind/cluster.yaml
	kubectl apply -f ./kubernetes/kind/registry.yaml
	

.PHONY: install_secrets	
install_secrets:
	kubectl create secret generic cloudfare --from-literal=token=${CLOUDFARE}

install_ops: install_secrets
	flux bootstrap github \
    	--owner=teaglebuilt \
     	--repository=homelab \
     	--branch=master \
     	--path=clusters/dev \
     	--network-policy=false \
     	--watch-all-namespaces=true \
		--namespace=flux-system \
		--personal

upgrade_ops:
	helm upgrade homeops kubernetes/system/ops