FROM python:3.7

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends build-essential git-core \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 5000

LABEL org.opencontainers.image.source=https://github.com/dhayab/moa-docker
LABEL org.opencontainers.image.description="Cross post between Mastodon and Twitter"
LABEL org.opencontainers.image.licenses=MIT

CMD ["./entrypoint.sh"]
