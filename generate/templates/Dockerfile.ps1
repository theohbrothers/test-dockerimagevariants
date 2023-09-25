@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN echo Installing package $( $VARIANT['_metadata']['package_version'] )

"@

foreach ($c in $VARIANT['components']) {
    if ($c -eq 'curl') {
@"
RUN apk add --no-cache curl

"@
    }
    if ($c -eq 'git') {
@"
RUN apk add --no-cache git

"@
    }
}
