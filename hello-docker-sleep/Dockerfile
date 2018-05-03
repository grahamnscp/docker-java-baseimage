FROM alpine:latest
COPY hello-docker-sleep.c /
RUN apk add --no-cache gcc build-base
RUN gcc hello-docker-sleep.c -o hello-docker-sleep

FROM alpine:latest
COPY --from=0 /hello-docker-sleep /
COPY hello-docker-ascii.txt /
CMD ["/hello-docker-sleep"]
