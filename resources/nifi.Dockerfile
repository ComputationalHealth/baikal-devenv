# Dockerfile from mkobit/nifi

FROM java:9

ENV NIFI_VERSION=0.4.0 \
        NIFI_HOME=/opt/nifi

# Picked recommended mirror from Apache for the distribution.
# Import the Apache NiFi release keys
RUN set -x \
        && curl -Lf https://dist.apache.org/repos/dist/release/nifi/KEYS -o /tmp/nifi-keys.txt \
        && gpg --import /tmp/nifi-keys.txt \
        && curl -Lf https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz -o /tmp/nifi-bin.tar.gz \
        && curl -Lf https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz.asc -o /tmp/nifi-bin.tar.gz.asc \
        && curl -Lf https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz.md5 -o /tmp/nifi-bin.tar.gz.md5 \
        && curl -Lf https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz.sha1 -o /tmp/nifi-bin.tar.gz.sha1 \
        && gpg --verify /tmp/nifi-bin.tar.gz.asc /tmp/nifi-bin.tar.gz \
        && echo "$(cat /tmp/nifi-bin.tar.gz.md5) /tmp/nifi-bin.tar.gz" | md5sum -c - \
        && echo "$(cat /tmp/nifi-bin.tar.gz.sha1) /tmp/nifi-bin.tar.gz" | sha1sum -c - \
        && mkdir -p $NIFI_HOME \
        && tar -z -x -f /tmp/nifi-bin.tar.gz -C $NIFI_HOME --strip-components=1 \
        && rm /tmp/nifi-bin.tar.gz /tmp/nifi-bin.tar.gz.asc /tmp/nifi-bin.tar.gz.md5 /tmp/nifi-bin.tar.gz.sha1 \
        && rm /tmp/nifi-keys.txt

RUN groupadd nifi \
        && useradd -r -g nifi nifi \
        && bash -c "mkdir -p $NIFI_HOME/{database_repository,flowfile_repository,content_repository,provenance_repository}" \
        && chown nifi:nifi -R $NIFI_HOME

# These are the volumes (in order) for the following:
# 1) user access and flow controller history
# 2) FlowFile attributes and current state in the system
# 3) content for all the FlowFiles in the system
# 4) information related to Data Provenance
# You can find more information about the system properties here - https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#system_properties
VOLUME ["$NIFI_HOME/database_repository", "$NIFI_HOME/flowfile_repository", "$NIFI_HOME/content_repository", "$NIFI_HOME/provenance_repository"]

# Open port 8081 for the HTTP listen
USER nifi
WORKDIR $NIFI_HOME
EXPOSE 8080 8081
ENTRYPOINT ["bin/nifi.sh"]
CMD ["run"]