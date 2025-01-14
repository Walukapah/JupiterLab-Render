# Use the latest Ubuntu image
FROM ubuntu:latest

# Update and install required packages
# RUN apt-get update && apt-get install python3 -y && apt-get install python3-pip -y && pip3 install jupyterlab

# Set the working directory
WORKDIR /app

# Install JupyterLab
RUN pip3 install jupyterlab

# Expose port 8080
EXPOSE 8080

# Start JupyterLab on port 8080 without authentication
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
