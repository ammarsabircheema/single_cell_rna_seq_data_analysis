FROM rocker/tidyverse:3.6.1

# #########
# Ubuntu 
##########

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y libudunits2-dev \
        openssl \
        make \
        liblzo2-dev \
        zlib1g-dev \ 
        libz-dev \
        g++ \
        bzip2 \
        libbz2-1.0 \
        libbz2-dev \
        libbz2-ocaml \
        libbz2-ocaml-dev \
        liblzma-dev \
        libssh2-1-dev \
	libgdal-dev \
	libgeos-dev \
	libproj-dev \
	libcurl4-gnutls-dev \
	libgit2-dev \
        tk-dev \
        tcl-dev \
        tcl8.5-dev \
        tk8.5-dev \
        libedit-dev \
        build-essential






# ##########
# R PACKAGES 
# ##########

#### Figures & layout management
# ggplot2
RUN Rscript -e 'install.packages( "ggplot2")'
RUN Rscript -e 'install.packages( "cowplot")'        # plot_grid, themes, ...
RUN Rscript -e 'install.packages( "ggpubr")'         # add_summary, geom_signif, ...
RUN Rscript -e 'install.packages( "ggrepel")'        # geom_text_repel, geom_label_repel
RUN Rscript -e 'install.packages( "gridExtra")'      # grid.arrange, ...
RUN Rscript -e 'BiocManager::install( "patchwork")'  # +/ operators for ggplots

# plotly
RUN Rscript -e 'install.packages( "plotly")'

# general
RUN Rscript -e 'install.packages( "gplots")'         # heatmap.2
RUN Rscript -e 'install.packages( "heatmaply")'      # heatmaply (interactive)
RUN Rscript -e 'BiocManager::install( "iheatmapr")'  # iheatmap (interactive, uses plotly), dependencies OK with BiocManager
RUN Rscript -e 'install.packages( "pheatmap")'       # pheatmap



#### Reporting
RUN Rscript -e 'install.packages( "DT")'             # datatable
RUN Rscript -e 'install.packages( "pander")'         # pander


#### General
RUN Rscript -e 'install.packages( "funr")'           # get_script_path
RUN Rscript -e 'install.packages( "reshape")'        # melt


#### Technology specific
RUN Rscript -e 'BiocManager::install( "Seurat")'     # Dependencies OK with BiocManager (https://github.com/satijalab/seurat/issues/2409)
RUN Rscript -e 'install.packages( "umap")'


RUN Rscript -e 'BiocManager::install("Rhtslib")'
RUN Rscript -e 'BiocManager::install("Rsamtools")'
RUN Rscript -e 'BiocManager::install("GenomicAlignments")'
RUN Rscript -e 'BiocManager::install("rtracklayer")'
RUN Rscript -e 'BiocManager::install("GenomicFeatures")'
RUN Rscript -e 'BiocManager::install("bumphunter")'

### Monocle3
RUN Rscript -e 'BiocManager::install(c( "minfi", "BiocGenerics", "DelayedArray", "DelayedMatrixStats", "limma", "S4Vectors", "SingleCellExperiment", "SummarizedExperiment", "batchelor"))'
RUN Rscript -e 'install.packages( "devtools")'
RUN Rscript -e 'devtools::install_github("cole-trapnell-lab/leidenbase")'
RUN Rscript -e 'devtools::install_github("cole-trapnell-lab/monocle3")'
RUN Rscript -e 'install.packages("dplyr")'
RUN Rscript -e 'install.packages("reshape2")'
RUN Rscript -e 'install.packages("igraph")'
RUN Rscript -e 'install.packages("VGAM")'


### Enrichr
RUN Rscript -e 'install.packages("enrichR")'


#### Custom
RUN wget https://cran.r-project.org/src/contrib/sm_2.2-5.6.tar.gz
RUN Rscript -e 'install.packages( "sm_2.2-5.6.tar.gz")'

# COPY test.txt /







# RUN R CMD INSTALL /opt/test.txt

# ##################
# OTHER DEPENDENCIES
# ##################

#### Python
# pip
RUN apt-get update && apt-get install -y \
    python3-pip \
    && pip3 install --upgrade --user pip

RUN apt-get install -y --no-install-recommends libedit-dev build-essential
RUN apt-get install -y --no-install-recommends  llvm-7 llvm-7-dev

RUN LLVM_CONFIG=/usr/bin/llvm-config-7 pip3 install enum34 llvmlite



# miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#Presumes aceptance of the license
RUN bash Miniconda3-latest-Linux-x86_64.sh -b

# Umap processing library (python)
RUN python3 -m pip install 'umap-learn==0.3.10'






###############################################################################
################## PROJECT VARIABLES AND DOCKER DECLARATIONS ##################
###############################################################################

# #################################################
# DECLARE EXPECTED VOLUMES TO BE MOUNTED
# #################################################

# Workspace cannot be declared because it depends on $USER
# Container typically started with `-v /home/$USER/workspace:/home/$USER/workspace`

# Shared disks are accessible from '/mnt' on all machines, so we can embed paths in environment variables for scripts
# Container typically started with `-v /mnt:/mnt`
VOLUME /mnt



# #################################################
# DECLARE EXPECTED PORTS TO BE EXPOSED
# #################################################

# Rstudio listens on port 8787 by default
# Container typically started with `-p 8787:8787`
EXPOSE 8585
