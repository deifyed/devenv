# devenv

## Usage

### Run script

```shell
# See usage
sh run.sh -h

# To mount .ssh folder and a certain workdir
sh run.sh -s .ssh -w "."
```

### Direct container usage

Run `docker run -it ghcr.io/deifyed/devenv` to enter the development environment.

Add `--volume <path/to/your/project>:/home/dev/project` to mount your project directory into the container.

## Motivation

Github codespaces are cool. Chromebooks are cool. I like it simple.
