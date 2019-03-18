FROM alpine:3.9
LABEL maintainer="Eldar Iskhakov <iskhakov.eldar95@gmail.com>"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV POSTGRES_URL **None**
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PATH 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV SCHEDULE **None**

ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]
