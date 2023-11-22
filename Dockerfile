# Use Ubuntu as the base image
FROM ubuntu:23.10

# Avoid prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Install wget
RUN apt-get update && \
    apt-get install software-properties-common wget -y

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda && chmod -R a+rwX /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Install mamba in the base environment
RUN conda install -c conda-forge mamba

# Create the genelab-utils conda environment and install dp-tools
RUN mamba create -n genelab-utils -y -c conda-forge -c bioconda -c defaults -c astrobiomike 'genelab-utils>=1.1.02' git pip
RUN echo "source activate genelab-utils" > ~/.bashrc
ENV PATH=/opt/conda/envs/genelab-utils/bin:$PATH
RUN pip install git+https://github.com/torres-alexis/dp_tools.git@amplicon_updates

# Download and unzip the workflow files
RUN wget https://github.com/nasa/GeneLab_Data_Processing/releases/download/SW_AmpIllumina-A_1.2.0/SW_AmpIllumina-A_1.2.0.zip -O ~/SW_AmpIllumina-A_1.2.0.zip && \
    unzip ~/SW_AmpIllumina-A_1.2.0.zip && \
    rm ~/SW_AmpIllumina-A_1.2.0.zip

# Set the working directory to the workflow directory
WORKDIR ~/SW_AmpIllumina-A_1.2.0


