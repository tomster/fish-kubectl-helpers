# a helper function to clear the context caches
# only needed during development or when the definition of a context has changed
function clear_kubectl_context
    rm $kubectl_context_cache 
    rm $kubectl_cluster_cache 
    rm $kubectl_namespace_cache 
end