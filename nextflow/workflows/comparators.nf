process run_needLR_duo {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'
    
    input:
        path( vcf )
        path( parental_vcf )
        val( sample_id )
        val( region )
        val( annotations )

    output:
        path "${sample_id}_needLR_DUO_1k_v4.0", emit: results_folder

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
        needLR comparator -P ${parental_vcf} -T ${task.cpus} \${argstopass[@]} ${vcf}
        """
}

process run_needLR_duo_custom_controls {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'
    
    input:
        path( vcf )
        path( parental_vcf )
        path( control_vcf )
        val( sample_id )
        val( region )
        val( annotations )
    output:
        path "needLR_output/${sample_id}_needLR_DUO_customControl_v4.0", emit: results_folder

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
        needLR comparator -P ${parental_vcf} -T ${task.cpus} -C ${control_vcf} \${argstopass[@]} ${vcf}
        """
}

process run_needLR_trio {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'
    
    input:
        path( vcf )
        path( maternal_vcf )
        path( paternal_vcf )
        val( sample_id )
        val( region )
        val( annotations )

    output:
        path "${sample_id}_needLR_TRIO_1k_v4.0", emit: results_folder

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
        needLR comparator -P ${maternal_vcf},${parental_vcf} -T ${task.cpus} \${argstopass[@]} ${vcf}
        """
}

process run_needLR_trio_custom_controls {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'
    
    input:
        path( vcf )
        path( parental_vcf )
        path( control_vcf )
        val( sample_id )
        val( region )
        val( annotations )
    output:
        path "needLR_output/${sample_id}_needLR_TRIO_customControl_v4.0", emit: results_folder

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
        needLR comparator -P ${maternal_vcf},${parental_vcf} -T ${task.cpus} -C ${control_vcf} \${argstopass[@]} ${vcf}
        """
}





