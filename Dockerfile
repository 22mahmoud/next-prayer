# First stage - build the app
FROM alpine:3.15.2 AS builder

RUN apk add --update --no-cache \
    'bash=5.1.16-r0' \
    'make=4.3-r0' \
    'g++=10.3.1_git20211027-r0' \
    'python3=3.9.7-r4' \
    'py3-pip=20.3.4-r1' && \
    pip3 install --no-cache-dir --upgrade 'pip==22.0.4' &&   \
    pip3 install --no-cache-dir 'requests==v2.27.1'

WORKDIR /app
COPY . .
RUN make clean install

# Second stage - run the app
FROM alpine:3.15.2 AS run

RUN apk add --update --no-cache \
    'g++=10.3.1_git20211027-r0' && \
    mkdir -p /root/.local/share/next-prayer

COPY --from=builder /root/.local/bin/* /usr/bin/
COPY --from=builder /root/.local/share/next-prayer /root/.local/share/next-prayer

CMD ["np_main", "--hybrid"]
