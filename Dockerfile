#
# JupyterLab installation on Ubuntu, with Python and R kernels
#
FROM ubuntu:17.10

ENV JL_DATA /var/jupyterlab/data
ENV JL_PORT 8888

# Install Python
RUN apt-get update 
RUN  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip

# Install Python 2 and Jupyter 
RUN python2 -m pip install ipykernel && \
    python2 -m ipykernel install --user && \
    ipython kernel install

# Install Python 3 and Jupyter 3
RUN apt-get update
RUN apt-get install -y python3 python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install -U ipython[all] jupyter && \
    ipython2 kernelspec install-self

# Install JupyterLab
RUN pip3 install jupyterlab && \
    jupyter serverextension enable --py jupyterlab --sys-prefix

# Install R and IRKernel
ENV CRANKEY 51716619E084DAB9
RUN apt-get install -y dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${CRANKEY}

#RUN gpg â€“keyserver keyserver.ubuntu.com â€“recv-key ${CRANKEY} &&\
#    gpg -a â€“export ${CRANKEY} | sudo apt-key add â€“
#RUN echo "deb http://cran.ms.unimelb.edu.au/bin/linux/ubuntu artful/" |\
#    tee -a /etc/apt/sources.list
RUN apt-get update 
RUN apt-get install -y libcurl4-openssl-dev libssl-dev
RUN apt-get install -y --allow-unauthenticated r-base 
COPY irkernel.R /tmp/
RUN R CMD BATCH /tmp/irkernel.R

# Install Folium and Plotly
RUN apt-get -y install pandoc
RUN pip3 install folium plotly pandas matplotlib bokeh numpy scipy shapely

# Create the Jupyter configuration file
RUN jupyter notebook --generate-config

# Expose Jupyter port and start Jupyter
EXPOSE ${JL_PORT}
COPY startup.sh /tmp/
RUN mkdir -p ${JL_DATA} && chmod a+x /tmp/startup.sh
CMD /tmp/startup.sh
