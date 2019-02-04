function get_kubectl_context
    # prefer local kube config
    if test -e kube.config
        set kubeconfig "kube.config"
    else
        set kubeconfig "$HOME/.kube/config"
    end

    set -l live_context (grep current-context $kubeconfig | sed "s/current-context: //")

    echo $live_context
end