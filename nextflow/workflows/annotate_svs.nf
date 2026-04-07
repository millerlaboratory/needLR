process run_needLR_annotate {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'
    
    input:
        path( vcf )
        val( sample_id )
        val( region )
        val( annotations )
        val( isMerged )

    output:
        path "${sample_id}_needLR_1k_v4.0", emit: results_folder

    script:
        """
        argstopass=()
        annotationString=${annotations}
        annotationList=( $( echo \${annotationString}| tr ',' ' ') )
        if [[ \${annotationString} ~= "all" ]]
        then
            for anno in \${annotationList[@]}
            do
                argstopass+=('--'\$anno)
            done
        fi
        if [[ ${region} != "none" ]]
        then
            argstopass+=( -R ${region} )
        fi
        if [[ ${isMerged} == TRUE ]]
        then
            needLR annotate -T ${task.cpus} -Q ${vcf} \${argstopass[@]}
        else
            needLR annotate -T ${task.cpus} \${argstopass[@]} ${vcf}
        """
}

process run_needLR_annotate_custom_controls {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'
    
    input:
        path( vcf )
        path( control_vcf )
        val( sample_id )
        val( region )
        val( annotations )
        val( isMerged )

    output:
        path "${sample_id}_needLR_customControl_v4.0", emit: results_folder

    script:
        """
        argstopass=()
        annotationString=${annotations}
        annotationList=( $( echo \${annotationString}| tr ',' ' ') )
        if [[ \${annotationString} ~= "all" ]]
        then
            for anno in \${annotationList[@]}
            do
                argstopass+=('--'\$anno)
            done
        fi
        if [[ ${region} != "none" ]]
        then
            argstopass+=( -R ${region} )
        fi
        if [[ ${isMerged} == TRUE ]]
        then
            needLR annotate -T ${task.cpus} -Q ${vcf} -C ${control_vcf} \${argstopass[@]}
        else
            needLR annotate -T ${task.cpus} -C ${control_vcf} \${argstopass[@]} ${vcf}
        """
}





