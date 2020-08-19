# Build the go application into a binary
FROM golang:alpine as builder
WORKDIR /app
ADD . ./
RUN CGO_ENABLED=0 GOOS=linux go build -mod vendor -a -installsuffix cgo -o aws-eks-auto-tagger .
RUN apk --update add ca-certificates

# Run the binary on an empty container
FROM scratch
COPY --from=builder /app/aws-eks-auto-tagger .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/aws-eks-auto-tagger"]
