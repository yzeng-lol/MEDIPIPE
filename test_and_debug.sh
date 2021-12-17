##################################################
##### conda_env.yaml and conda_env_r.yaml  #######

## conda_env.ymal
conda install -c anaconda graphviz

conda env export -c bioconda  --from-history | grep -v "^prefix" >  conda_env.yaml


## conda_env_r.yaml

conda install -c bioconda bioconductor-medips

conda env export -c bioconda  --from-history | grep -v "^prefix" >  conda_env_r.yaml


## export environment


###############################
##### test run on H4H  #######

conda activate cfmedip-seq-pipeline

## generate the DGA plots ####
## dot -Tsvg

################################################################################
## for paired-end inputs
snakemake --snakefile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/Snakefile \
          --configfile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/config/config_pe_template.yaml \
          -p --dag | dot -Tpng > /cluster/home/yzeng/cfmedip-seq-pipeline/figures/dag_pe.png

## for single-end inputs
snakemake --snakefile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/Snakefile \
          --configfile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/config/config_se_template.yaml \
          -p --dag | dot -Tpng > /cluster/home/yzeng/cfmedip-seq-pipeline/figures/dag_se.png


#### test run on H4H without sbatch
snakemake --snakefile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/Snakefile \
          --configfile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/config/config_pe_template.yaml \
          --use-conda -np

#### test run on H4H with sbatch
snakemake --snakefile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/Snakefile \
          --configfile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/config/config_pe_template.yaml \
          --use-conda -np --core 2 --cluster "sbatch -p all " --jobs 8



################################################################################
#### test run with cfmeDIP-seq data
snakemake --snakefile /cluster/home/yzeng/cfmedip-seq-pipeline/workflow/Snakefile \
          --configfile /cluster/projects/tcge/cell_free_epigenomics/test_run/config_test.yaml \
          --use-conda -np


## run on cluster by sbatch  :: multiple jobs will submitted
snakemake --snakefile /cluster/projects/tcge/script/snakemake/test/Snakefile \
          --configfile /cluster/projects/tcge/cell_free_epigenomics/test_run/config_test.yaml \
          --use-conda --cores 2 --cluster "sbatch -p all" --jobs 8
