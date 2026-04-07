nextflow.enable.dsl=2

log.info    """
NeedLR v 4.0 Nextflow Wrapper
-----------------------------

This wrapper assists in running needLR v4.0 on more than one sample concurrently

// Input parameters:
Control Reference Dataset: ${params.control_vcf}
Region of Interest: ${params.region}
CPUS: ${params.cpus}
Per Run CPUs: ${params.taskcpus}
Merged VCFS:    ${params.merged}


// Run type: ${params.subcommand}

// Annotations:
Genes:  TRUE
OMIM:                       ${params.omim}
GenCC:                      ${params.gencc}
HPO Terms:                  ${params.hpo}
pLI:                        ${params.pli}
UTR:                        ${params.utr}
CDS:                        ${params.cds}
ORegAnno:                   ${params.oreganno}
Mapping Flags:              ${params.mapflags}
High Confidence Regions:    ${params.hiconf}
"""

include { run_needLR_bed } from "${launchDir}/workflows/annotate_bed.nf"
include { run_needLR_annotate; run_needLR_annotate_custom_controls } from "${launchDir}/workflows/annotate_svs.nf"
include { run_needLR_duo; run_needLR_duo_custom_controls; run_needLR_trio; run_needLR_trio_custom_controls } from "${launchDir}/workflows/comparators.nf"

workflow {
    ch_inputs=Channel.fromPath(params.fileList)
                        .splitText()
                        .map {file(it.trim()) }
                        .set { file_list }
    def id_list = file(params.fileList).readLines().each { line -> line.split('\\/')[-1]}
    ch_ids=Channel.fromList(id_list)
    if(params.subcommand=="annotate"){. 
        if(params.control_vcf=="")
        {
            run_needLR_annotate(
                ch_inputs,
                ch_ids,
                params.region,
                annotation_string,
                params.merged
            )
        }

    } else if(params.subcommand=="comparator"){

    } else if(params.subcommand=="bed"){

    } else {
        throw new IllegalArgumentException("Invalid subcommand: ${params.subcommand}")
    }

}