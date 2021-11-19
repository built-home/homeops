
install_cluster:
	docker run \
    	-d --restart=always \
		-p "127.0.0.1:5000:5000" \
		--name registry registry:2
	kind create cluster --config ./kubernetes/cluster/kind.yaml
	# docker network connect kind registry
	kubectl apply -f ./kubernetes/cluster/registry.yaml

install_ops:
	kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.crds.yaml
	helm install homeops kubernetes/system/ops

install_flux:
	fluxctl install --git-user=teaglebuilt \
		--git-email=dillan.teagle.va@gmail.com \
		--git-path=kubernetes/apps/base \
		--git-url=git@github.com:teaglebuilt/homelab \
		--namespace=flux | kubectl apply -f -
	fluxctl identity --k8s-fwd-ns flux
	
upgrade_ops:
	helm upgrade homeops kubernetes/system/ops