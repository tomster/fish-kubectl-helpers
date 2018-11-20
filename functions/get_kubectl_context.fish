set -g kubectl_context_cache "$HOME/.kube/current_context"
set -g kubectl_cluster_cache "$HOME/.kube/current_cluster"
set -g kubectl_namespace_cache "$HOME/.kube/current_namespace"

# a caching implementation that examines the current kubectl context
# to return the current cluster and namespace
# it avoids querying the kubectl database unnecessarily by doing only so
# if the current context (which it greps from the config file) is different
# than the cached context 
function get_kubectl_context
    set -l live_context (grep current-context ~/.kube/config | sed "s/current-context: //")

    if not test -e $kubectl_context_cache 
        echo $live_context > $kubectl_context_cache
    end

    read -x cached_context < $kubectl_context_cache

    if [ $cached_context != $live_context ] ; or not test -e $kubectl_namespace_cache ; or not test -e $kubectl_cluster_cache 
        set namespace (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$live_context\")].context.namespace}")
        set cluster (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$live_context\")].context.cluster}")
        [ -z $namespace ]; and set namespace 'default'
        echo $live_context > $kubectl_context_cache
        echo $namespace > $kubectl_namespace_cache
        echo $cluster > $kubectl_cluster_cache
    else
        read -x cluster < $kubectl_cluster_cache
        read -x namespace < $kubectl_namespace_cache
    end

    echo $cluster
    echo $namespace
end