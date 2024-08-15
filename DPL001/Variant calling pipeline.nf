#!/usr/bin/env nextflow

nextflow.enable.dsl=2


/*
 *
========================================================================================
                             Variant Calling Pipeline 
========================================================================================
 
# Homepage / Documentation
 GitHub - CLARITY [Variant calling project]
 # Authors
 Setshaba Taukobong <setshaba.taukobong@diplomics.org.za> <sc.taukobong@gmail.com>

---------------------------------------------------------------------------------------
 *
 */

/*
========================================================================================
                        Define parameters, channels and processes
========================================================================================
*/


/*
 * Define the default parameters
 */ 

params.podsF = '/home/staukobong/fastq/'
params.genome = '/home/staukobong/human.fasta'
pods_ch = Channel.fromPath(params.podsF, checkIfExists: true)


/*
 * Convert fastq files to bam files and concatenate the files
 */


process CONCAT {

    debug true

    input:
    path sample_id

    output:
    path 'sample_id.fastq', emit: fastq_files

    script:
    """
    cat $sample_id > sample_id.fastq
    """
}


/*
 * Check quality of sequencing reads using FASTQC
 */

process FASTQC1 {

    module 'FastQC'
    debug true

    input:
    path sample_id

    output:
    path 'sample_id_fastqc.html', emit: fastqc_files

    script:
    """
    fastqc $sample_id -t 4
    """

}


/*
 * Trim fastq files after base calling using Nanofilt
 */

process TRIM {

    module 'nanofilt'
    debug true

    input:
    path sample_id

    output:
    path 'sample_id.trimmed.fastq', emit: trimmed_fastq

    script:
    """
    NanoFilt -l 200 -q 20 --headcrop 50 --tailcrop 6000 $sample_id > sample_id.trimmed.fastq
    """
}


/*
 * Check quality of sequencing reads using FASTQC
 */

process FASTQC2 {

    module 'FastQC'
    debug true

    input:
    path sample_id

    output:
    path 'sample_id.trimmed_fastqc.html', emit: fastqc_files2

    script:
    """
    fastqc $sample_id -t 4
    """

}


/*
 * Mapping the reads using minimap2
 */

process MAPPINGS {
    module 'minimap2'
    debug true

    input:
    path sample_id

    output:
    path 'sample_id.sam', emit: Mapped_files

    script:
    """
    minimap2 -ax map-ont -t 4 $sample_id ${genome} > sample_id.sam
    """

}


/*
 * Convert from sam to bam and sort using samtools
 */

process CONVERT_SAM {
    module 'samtools/1.9'
    debug true

    input:
    path sample_id

    output:
    path 'sample_id.aligned.sorted.bam', emit: Converted_files

    script:
    """
    samtools view -S -b $sample_id | samtools sort -o sample_id.aligned.sorted.bam
    """

}


/*
 * Indexing BAM file using samtools
 */

process IND-FILE {
    module 'samtools/1.9'
    debug true

    input:
    path sample_id

    output:
    path 'indexed', emit: indexed_files

    script:
    """
    samtools index $sample_id
    """
}


/*
 * Variant calling using BCFtools
 */

process BCF {
    module 'BCFtools'
    debug true

    input:
    path sample_id

    output:
    path 'calls.bcf', emit: calls_files

    script:
    """
    bcftools mpileup -Ou -f $genome $sample_id | bcftools call -mv -Ob -o calls.bcf
    """
}


/*
 * Filter and report the SNVs in VCF (variant calling format
 */

process VCF {
    module 'BCFtools'
    debug true

    input:
    path sample_id

    output:
    path 'final_variants', emit: vcf_files

    script:
    """
    vcfutils.pl varFilter $sample_id > final_variants
    """
}


/*
========================================================================================
                                Create default workflow
========================================================================================
*/

workflow {
    CONCAT(pods_ch)
    FASTQC1(CONCAT.out.fastq_files)
    TRIM(CONCAT.out.fastq_files)
    FASTQC2(TRIM.out.trimmed_fastq)
    MAPPINGS(TRIM.out.trimmed_fastq)
    CONVERT_SAM(MAPPINGS.out.Mapped_files)
    IND-FILE(CONVERT_SAM.out.Converted_files)
    BCF(CONVERT_SAM.out.Converted_files)
    VCF(BCF.out.calls_files)


}
