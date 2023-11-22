# Use Miniconda as the base image
FROM conda/miniconda3

# Install mamba in the base environment
RUN conda install -c conda-forge mamba

# Create the genelab-utils conda environment
RUN mamba create -n genelab-utils -c conda-forge -c bioconda -c defaults -c astrobiomike 'genelab-utils>=1.1.02' git pip

# Activate the genelab-utils environment and install dp-tools
RUN echo "source activate genelab-utils" > ~/.bashrc
ENV PATH /opt/conda/envs/genelab-utils/bin:$PATH
RUN pip install git+https://github.com/torres-alexis/dp_tools.git@amplicon_updates

# Download and unzip the workflow files
RUN wget https://github.com/nasa/GeneLab_Data_Processing/releases/download/SW_AmpIllumina-A_1.2.0/SW_AmpIllumina-A_1.2.0.zip -O workflow.zip && \
    unzip workflow.zip && \
    rm workflow.zip

# Set the working directory to the workflow directory
WORKDIR /SW_AmpIllumina-A_1.2.0

# Set the default command to activate the genelab-utils environment
CMD ["/bin/bash"]
