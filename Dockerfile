FROM public.ecr.aws/lambda/provided:al2023.2024.11.22.14-x86_64

# Install required dependencies
RUN dnf install -y tar gzip unzip && \
    dnf clean all

# Create directory for Google Cloud SDK
RUN mkdir -p /opt

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Google Cloud SDK
WORKDIR /opt

# Install Google Cloud SDK
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-504.0.0-linux-x86_64.tar.gz && \
    tar -xf google-cloud-cli-504.0.0-linux-x86_64.tar.gz && \
    ./google-cloud-sdk/install.sh --quiet && \
    rm google-cloud-cli-504.0.0-linux-x86_64.tar.gz

# Add Google Cloud SDK to PATH
ENV PATH=$PATH:/opt/google-cloud-sdk/bin

# Install cbt tool
RUN gcloud components install cbt --quiet

# Clean up
RUN dnf clean all && \
    rm -rf /var/cache/dnf

# Set working directory to Lambda task root
WORKDIR ${LAMBDA_TASK_ROOT}

# Copy AWS credentials and config files from local directory
COPY credentials .
COPY config .
COPY service_account_key.json .

ENV GOOGLE_CLOUD_PROJECT=astute-synapse-444610-f6
ENV BIGTABLE_INSTANCE_ID=test123
ENV GOOGLE_APPLICATION_CREDENTIALS=service_account_key.json

# Copy bootstrap to the correct location
COPY bootstrap.sh /var/runtime/bootstrap.sh
RUN chmod +x /var/runtime/bootstrap.sh

# Set the handler
ENTRYPOINT [ "/var/runtime/bootstrap.sh" ]