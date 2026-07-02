# Build image
docker build -t nexus3-gcs:3.68.1 .

# Run docker
docker run -d \
  -p 8081:8081 \
  --name my-nexus \
  -v ./gcp-service-account.json:/opt/sonatype/nexus/etc/gcp-creds.json \
  -e GOOGLE_APPLICATION_CREDENTIALS=/opt/sonatype/nexus/etc/gcp-creds.json \
  nexus3-gcs:3.68.1

# Get default Password admin
docker exec my-nexus cat /nexus-data/admin.password

