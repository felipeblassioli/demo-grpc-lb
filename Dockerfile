FROM golang:1.12-alpine AS build

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

WORKDIR /app
ADD greeter_server /app/greeter_server
ADD greeter_client /app/greeter_client
ADD greeter_client_dns /app/greeter_client_dns
ADD go.mod .
ADD go.sum .

RUN go mod download 

RUN go build -o /go/bin/greeter_server /app/greeter_server/main.go
RUN go build -o /go/bin/greeter_client /app/greeter_client/main.go
RUN go build -o /go/bin/greeter_client_dns /app/greeter_client_dns/main.go

FROM alpine

COPY --from=build /go/bin/greeter_server /bin/greeter_server
COPY --from=build /go/bin/greeter_client /bin/greeter_client
COPY --from=build /go/bin/greeter_client_dns /bin/greeter_client_dns
