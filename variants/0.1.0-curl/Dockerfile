FROM alpine:3.15
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN echo Installing package 0.1.0
RUN apk add --no-cache curl
