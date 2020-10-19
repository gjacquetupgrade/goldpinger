FROM docker-upgrade.artifactory.build.upgrade.com/go-builder:2.0.20200722.0-212.1.15.2-214 as builder

# Get dependencies

WORKDIR /w
COPY go.mod go.sum /w/
RUN go mod download

# Build goldpinger

COPY . ./
RUN make bin/goldpinger

# Build the asset container, copy over goldpinger

FROM scratch
COPY --from=builder /w/bin/goldpinger /goldpinger
COPY ./static /static
ENTRYPOINT ["/goldpinger", "--static-file-path", "/static"]
