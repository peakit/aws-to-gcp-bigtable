# To deploy as container in AWS Lambda
- `docker buildx build --platform linux/amd64 --provenance false -t 323021871338.dkr.ecr.us-east-1.amazonaws.com/bigtable-spike/aws-to-gcp-transfer:latest .`
- `aws ecr get-login-password --region us-east-1 --profile dev | docker login --username AWS --password-stdin 323021871338.dkr.ecr.us-east-1.amazonaws.com`
- `docker push 323021871338.dkr.ecr.us-east-1.amazonaws.com/bigtable-spike/aws-to-gcp-transfer:latest`
