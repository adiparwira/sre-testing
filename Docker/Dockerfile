
ARG NEXUS_VERSION=3.68.1
FROM sonatype/nexus3:${NEXUS_VERSION}

ARG PLUGIN_VERSION=0.61.0
ARG BUNDLE_NAME=nexus-blobstore-google-cloud-${PLUGIN_VERSION}-bundle.kar
ARG KAR_URL=https://repo1.maven.org/maven2/org/sonatype/nexus/plugins/nexus-blobstore-google-cloud/${PLUGIN_VERSION}/${BUNDLE_NAME}

USER root
ADD --chown=nexus:nexus ${KAR_URL} /opt/sonatype/nexus/deploy/

USER nexus