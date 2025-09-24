    FROM debian:stable-slim

# Install dependencies (curl)
RUN apt update && apt install --no-install-recommends -y curl ripgrep jq ca-certificates

# Make script directory
RUN mkdir /scripts

# Directory to watch
WORKDIR /watch

COPY watch.sh /scripts/watch.sh
RUN chmod +x /scripts/watch.sh
CMD ["/scripts/watch.sh"]