# devenv

## Usage

### Run script

```shell
# Print usage
sh run.sh -h

# Mount ~/.ssh folder and a workdir
sh run.sh -s .ssh -w "./target"
```

### Direct container usage

Run `docker run -it ghcr.io/deifyed/devenv` to enter the development environment.

Add `--volume type=bind,source=<path/to/your/project>,destination=/home/dev/project` to mount your project directory
into the container.

## Motivation

Github codespaces are cool. Chromebooks are cool. I like it simple.
