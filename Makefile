
install_cluster:
	kind create cluster --config ./kubernetes/kind/cluster.yaml
	kubectl apply -f ./kubernetes/kind/registry.yaml

install_ops:
	flux bootstrap github \
    	--owner=teaglebuilt \
     	--repository=homelab \
     	--branch=master \
     	--path=./clusters/dev \
     	--network-policy=false \
     	--watch-all-namespaces=true \
		--namespace=flux-system

upgrade_ops:
	helm upgrade homeops kubernetes/system/ops