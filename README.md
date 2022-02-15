# jinja2-cli

This is containerized jinja2-cli built on top of Alpine Linux.

## To Use

A convenience wrapper, `jinja2-cli` is provided to simplify use.

```bash
./jinja2-cli template.j2 data.json > output_file
```

By default, the current directory is bind-mounted to the container
so files (and subdirectories) located in the current directory are
available to the container.  So, for example, this will work:

```bash
./jinja2-cli templates/foo.j2.txt data.json > foo.txt
```

However, this will not:

```bash
./jinja2-cli ../templates/foo.j2.txt data.json > foo.txt
```

### Specifying a Directory

In situations like those, the environment variable `directory`
will need to used to indicate a directory that contains all
of the files and directories:

```bash
directory=../ bin/jinja2-cli templates/foo.j2.txt data/data.json > foo.txt
```

### Specifying a Username

By default, the container runs with the UID of the current user.  This
ought not be major concern as `jinja2-cli` does not write to the filesystem
by default; it may, however, be an issue if a template or data file isn't
readable by the current user.

### Command Line Arguments

Arguments passed to jinja2-cli will be passed to the container; these
may include files in the container, CLI options, etc..

```bash
./jinja2-cli template.j2.txt data.json --format=json
```

[Jinja2-cli Usage](https://raw.githubusercontent.com/mattrobenolt/jinja2-cli/main/README.md#Usage)

### Data Format Support

The containerized application supports the following data formats:

- ini
- json
- querystring
- yaml
- yml
- toml
- auto

## To Build

```bash
docker build -t tagname .
```
