# Multi-stage dockerfile

# Stage 1
# Use Golang base image
FROM golang:1.24 as base

# Set working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum (dependencies) into working directory
COPY go.mod ./

# Download all dependencies
RUN go mod Download

# Copy the source code into working directory
COPY . .

# Build the application binary (main) from working/current directory
RUN go build -o main .


# Stage 2
# Reduce the image size using a distroless image to run application
FROM gcr.io/distroless/static:nonroot
# gcr.io/distroless/static: is for statically compilled apps (most Go apps are by default). 
nonroot: safer, runs as non-root

# Copy binary from previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]