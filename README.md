# macmake

A collection of utilities and commands designed to streamline
development-related tasks on macOS. This Makefile-based project provides a set
of targets to perform various actions, from installing configuration files to
generating passwords.

## Getting Started

Make sure you don't have any existing Makefile in your home directory. The
Makefile will overwrite any existing files with the same name.
Backup of old `~/Makefile` will be created as `~/Makefile.<datetime>.bak`
though.
To get started, clone the repository and use the provided Makefile to execute
different targets. The Makefile includes several targets to help you with common
development tasks.

```bash
git clone git@github.com:udovichenko/macmake.git
cd macmake
make install
```

## Help

```bash
make
```

Display a list of available targets along with their descriptions.

## install

Copy the `Makefile` and `./macmake` from the MacMake project to your home
directory.

```bash
make install
```

## base-auth-gen

Generate an Apache htpasswd file for basic authentication.

```bash
make base-auth-gen u=<username>
```

## clean-annas-filenames

Clean filenames in a directory by removing specific patterns such as ISBNs, hash strings, 
"Anna's Archive" text, and redundant separators.

```bash
make clean-annas-filenames d=path/to/dir
```

The command will:
1. Show preview of changes
2. Ask for confirmation
3. Rename files if confirmed

## Development

Test password generation:

```bash
make test-passwd-gen
```

## TODO:

- Docs for the rest of the targets

