# sinusbot-raspi
Sinusbot for Raspberry Pi (aarch64)

Trying to run Raspberry PI with Sinusbot turned out to be non-trivial. This repo mostly exists
to document this for myself in the future- and to help others trying to achieve the same.

There is no existing Sinusbot instance running on Raspberry Pi, looking through various forums.
Note that using this still requires you to be compliant with Sinusbot's license.

## Instructions

1. `docker run --privileged --rm tonistiigi/binfmt --install amd64` (installs Qemu and registers in binfmt)
2. Clone repo
3. `docker build . -t <name>`
4. Create a `docker-compose.yml` somewhere, with the following content
5. Create two folders relative to the file. `scripts` and `data`.
6. Make sure a host group with the id `5000` can access it. e.g. `chown -R pi:5000 scripts`
7. Run `docker compose up` in the directory.

```yml
services:
  sinusbot:
   image: <name>
   user: bot
   volumes:
     - "./scripts:/opt/sinusbot/scripts"
     - "./data:/opt/sinusbot/data"
   ports:
     - "8087:8087"
```
