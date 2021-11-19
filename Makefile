
install_cluster:
	kind create cluster --config ./kubernetes/cluster/kind.yaml
	kubectl apply -f ./kubernetes/cluster/registry.yaml

install_ops:
	kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.crds.yaml
	helm install homeops kubernetes/system/ops

install_flux:
	flux bootstrap github 
		--owner teaglebuilt \
		--repository homelab \
		--branch master \
		--path ./kubernetes/system \
		--namespace homeops \
		--secret-name homeops

upgrade_ops:
	helm upgrade homeops kubernetes/system/ops