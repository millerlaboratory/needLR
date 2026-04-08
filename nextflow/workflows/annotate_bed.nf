process run_needLR_bed {
    publishDir "${params.publish_dir}/${sample_id}", mode: 'copy'
    label 'needLR'

    cpus: 1
    
    input:
        path( bed )
        val( sample_id )
        val( region )
        val( annotations )

    output:
        path "${sample_id}_needLR_bed_v4.0", emit: results_folder

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
        needLR bed \${argstopass[@]} ${bed}
        """
}