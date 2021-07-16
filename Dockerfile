FROM docker-upgrade.artifactory.build.upgrade.com/go-builder:2.0.20210617.0-15.1.16.5-6 as builder

# Get dependencies

WORKDIR /w
COPY --chown=upgrade:upgrade go.mod go.sum /w/
RUN go mod download

# Build goldpinger

COPY --chown=upgrade:upgrade . ./
RUN make bin/goldpinger

# Build the asset container, copy over goldpinger

FROM scratch
COPY --from=builder /w/bin/goldpinger /goldpinger
COPY ./static /static
ENTRYPOINT ["/goldpinger", "--static-file-path", "/static"]
