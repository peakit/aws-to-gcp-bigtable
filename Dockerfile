FROM google/cloud-sdk:504.0.1-slim

# Install AWS CLI
RUN apt-get install -y unzip google-cloud-cli-cbt

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Copy AWS credentials and config files from local directory
COPY credentials /credentials
COPY config /config
COPY service_account_key.json /service_account_key.json

ENV GOOGLE_CLOUD_PROJECT=astute-synapse-444610-f6
ENV BIGTABLE_INSTANCE_ID=test123
ENV GOOGLE_APPLICATION_CREDENTIALS=/service_account_key.json

# Ensure cbt is in the PATH (Important!)
ENV PATH="${PATH}:/google-cloud-sdk/bin"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]