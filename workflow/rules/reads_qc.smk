
### automatically trimming adapters for single-end reads
rule trim_galore_se:
    input:
        get_raw_fastq
    output:
        temp("trimmed_fq/{sample}_trimmed.fq.gz"),
        "trimmed_fq/{sample}.fastq.gz_trimming_report.txt",
    params:
        ## path needs to be full path: failed to recognize space
        path= config["workdir"] + "/trimmed_fq/"
    log:
        "trimmed_fq/{sample}.log",
    shell:
        "trim_galore -q 20 --stringency 3 --length 20 "
        "-o {params.path} {input}"


### automatically trimming adapters for paied-end reads
rule trim_galore_pe:
    input:
        get_raw_fastq
    output:
        temp("trimmed_fq/{sample}_R1_val_1.fq.gz"),
        temp("trimmed_fq/{sample}_R2_val_2.fq.gz"),
        "trimmed_fq/{sample}_R1.fastq.gz_trimming_report.txt",
        "trimmed_fq/{sample}_R2.fastq.gz_trimming_report.txt",
    params:
        ## path needs to be full path: failed to recognize space
        path= config["workdir"] + "/trimmed_fq/"
    log:
        "trimmed_fq/{sample}.log",
    shell:
        "trim_galore -q 20 --stringency 3 --length 20 "
        "--paired -o {params.path} {input}"

### FASTQC for raw and trimmed single-end reads
rule fastqc_se:
    input:
        get_raw_fastq,
        get_trimmed_fastq
    output:
        "qc/se/{sample}_fastqc.html",
        "qc/se/{sample}_trimmed_fastqc.html"
    run:
        for fq in input:
            shell("fastqc {} --outdir qc/se/".format(fq))

### FASTQC for raw and trimmed paired-end reads
rule fastqc_pe:
    input:
        get_raw_fastq,
        get_trimmed_fastq
    output:
        "qc/pe/{sample}_R1_fastqc.html",
        "qc/pe/{sample}_R2_fastqc.html",
        "qc/pe/{sample}_R1_val_1_fastqc.html",
        "qc/pe/{sample}_R2_val_2_fastqc.html",
    run:
        for fq in input:
            shell("fastqc {} --outdir qc/pe/".format(fq))