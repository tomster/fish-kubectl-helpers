function clear_kubectl_context
    rm $context_cache 
    rm $cluster_cache 
    rm $namespace_cache 
end