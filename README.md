# moa-docker

Moa is a service that cross posts between Mastodon and Twitter.

This repository specifically focuses on providing an easy-to-use Docker container for Moa. It is based on https://gitlab.com/fedstoa/moa and [this blog post](https://vitobotta.com/2022/11/12/setting-up-a-mastodon-twitter-crossposter/) from Vito Botta.

```
                 _ __ ___   ___   __ _
                | '_ ` _ \ / _ \ / _` |
                | | | | | | (_) | (_| |
                |_| |_| |_|\___/ \__,_|

┌─────────────┐     ╔═════════════╗     ┌─────────────┐
│  Mastodon   │◀───▶║     moa     ║◀───▶│   Twitter   │
└─────────────┘     ╚═════════════╝     └─────────────┘
```

## Application setup

Before running the container, you'll need to set up a Twitter application and define a few configuration variables.

### Twitter application setup

> **Note**
>
> It is noticeably harder to create new Twitter applications these days, due to a shift in the strategy brought by the new Twitter direction. It is preferable  to edit existing applications or be patient during the "review" period. Of course, refering to a Mastodon crossposter in the application details will not help at all, be advised.

Once you have a Twitter application available, make sure you have **User authentication set up** with the following details:

- App permissions: **Read and write**
- Type of App: **Web App, Automated App or Bot**
- App info > Callback URI / Redirect URL: `<MOA_BASE_URL>/twitter_oauthorized`

Then, retrieve your **Consumer Keys** and keep them on hand for the next step.

### Moa configuration

Create a `config.py` file with the following content:

```python
from defaults import DefaultConfig

class ProductionConfig(DefaultConfig):
    SECRET_KEY = '...' # head -c32 /dev/urandom | base64

    SQLALCHEMY_DATABASE_URI = 'sqlite:////data/moa.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    TWITTER_CONSUMER_KEY = '...'
    TWITTER_CONSUMER_SECRET = '...'

class DevelopmentConfig(DefaultConfig):
    DEBUG = True
    DEVELOPMENT = True
    SEND = False

class TestingConfig(DefaultConfig):
    TESTING = True

```

Generate a random `SECRET_KEY`, and copy your Twitter application credentials into `TWITTER_CONSUMER_KEY` and `TWITTER_CONSUMER_SECRET`.

You can check out a number of other configuration variables in [defaults.py](./defaults.py).

## Usage

Here are some examples snippets to help you get started creating a container.

**docker-compose**

```yaml
---
version: "2.1"
services:
  sonarr:
    image: ghcr.io/dhayab/moa:latest
    container_name: moa
    environment:
      - MOA_CONFIG=ProductionConfig
    volumes:
      - /path/to/data:/data
      - /path/to/config.py:/config.py
    ports:
      - 5000:5000
    restart: unless-stopped
```

**docker cli**

```bash
docker run -d \
  --name=moa \
  -e MOA_CONFIG=ProductionConfig \
  -p 5000:5000 \
  -v /path/to/data:/data \
  -v /path/to/config.py:/config.py \
  --restart unless-stopped \
  ghcr.io/dhayab/moa:latest
```

You can now go to `http://<YOUR_IP>:5000` to access the web UI.
