# Use Ubuntu as the base image
FROM ubuntu:latest

# Use bash for all commands
SHELL ["/bin/bash", "-c"]

# Avoid prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && chmod -R a+rwX /opt/conda

# Add Conda to PATH
ENV PATH=$CONDA_DIR/bin:$PATH

# Initialize Conda
RUN /opt/conda/bin/conda init bash

# Install mamba
RUN conda install -y -c conda-forge mamba

# Create genelab-utils environment and install dependencies
RUN mamba create -n genelab-utils -y -c conda-forge -c bioconda -c defaults -c astrobiomike 'genelab-utils>=1.3.35'

# Activate genelab-utils environment and make it the default
RUN echo "conda activate genelab-utils" >> ~/.bashrc

# Install additional dependencies within the environment
RUN /opt/conda/bin/conda run -n genelab-utils pip install --upgrade pyOpenSSL
RUN /opt/conda/bin/conda run -n genelab-utils pip install git+https://github.com/torres-alexis/dp_tools.git@amplicon_updates

# Download and unzip the workflow files
RUN wget https://github.com/nasa/GeneLab_Data_Processing/releases/download/SW_AmpIllumina-B_1.2.3/SW_AmpIllumina-B_1.2.3.zip -O /tmp/SW_AmpIllumina-B_1.2.3.zip && \
    unzip /tmp/SW_AmpIllumina-B_1.2.3.zip -d /opt && \
    rm /tmp/SW_AmpIllumina-B_1.2.3.zip

# Set the working directory to the workflow directory
WORKDIR /opt/SW_AmpIllumina-B_1.2.3

# Default shell ensures the Conda environment is active
CMD ["bash"]


