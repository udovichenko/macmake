# macmake

A collection of utilities and commands designed to streamline
development-related tasks on macOS. This Makefile-based project provides a set
of targets to perform various actions, from installing configuration files to
generating passwords.

## Getting Started

If you already have a Makefile in your home directory, the install step creates
a backup as `~/Makefile.<datetime>.bak` before replacing it.
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
directory. Files in `~/macmake/bin` are made executable and the install step
adds `~/macmake/bin` to your zsh `PATH` when it is not already available, so
you can run commands like `png-png-webp` from any directory.

```bash
make install
```

## base-auth-gen

Generate an Apache htpasswd file for basic authentication.

```bash
make base-auth-gen u=<username>
```

## calc

Calculate responsive CSS value using viewport width formula. The output is automatically copied to clipboard.

```bash
make calc v=10,20,380,1440
```

Example output: `calc(6px + 0.9vw); /* 380:10 - 1440:20 */`

Parameters (comma-separated):
- `size1,size2` - sizes at breakpoints (required)
- `breakpoint1,breakpoint2` - breakpoints in pixels (optional, defaults to 393:1440)

Examples:
```bash
make calc v=10,20,380,1440   # Custom breakpoints
make calc v=16,24             # Default breakpoints (393:1440)
```

## calc-limit

Calculate responsive CSS value with a maximum limit using `min()`. The output is automatically copied to clipboard.

```bash
make calc-limit v=100,150,380,1440
```

Example output: `min(calc(82px + 4.7vw), 150px); /* 380:100 - 1440:150 */`

Parameters (comma-separated):
- `size1,size2` - sizes at breakpoints (required)
- `breakpoint1,breakpoint2` - breakpoints in pixels (optional, defaults to 393:1440)

Examples:
```bash
make calc-limit v=100,150,380,1440   # Custom breakpoints
make calc-limit v=50,80               # Default breakpoints (393:1440)
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

## Image utilities

All commands accept one or more files. Resize and conversion commands support
`-w <width>`, `-h <height>`, and `-Q` for maximum quality.

### img-info

```bash
img-info 1.jpg
# 1.jpg: 882 x 1177, 252 KB
```

### img-resize

```bash
img-resize -w 300 1.jpg
# Creates 1-w300.jpg

img-resize -w 300 -h 400 2.png
# Creates 2-w300h400.png

img-resize -Q -w 1200 3.webp
# Creates 3-w1200.webp with maximum quality
```

Aspect ratio is preserved. With both dimensions, the image is fitted inside the
specified area.

### Format conversion

```bash
img-png photo.jpg
# Creates photo.png

img-webp photo.png
# Creates photo.webp

img-jpg photo.png
# Creates photo.jpg

img-webp -w 300 photo.jpg
# Creates photo-w300.webp
```

Same-format conversion adds `-s`; use `-f` to overwrite the source:

```bash
img-png photo.png     # Creates photo-s.png
img-png -f photo.png  # Replaces photo.png
```

### PNG conversion sets

```bash
png-webp icon.png
# Creates icon.webp

png-png-webp icon.png
# Creates icon-s.png and icon.webp

png-webp-jpg image.png
# Creates image-s.png, image.webp, and image.jpg

png-webp-jpg -w 300 -Q image.png
# Creates image-w300.png, image-w300.webp, and image-w300.jpg
```

### img-trim

```bash
img-trim image.png
# Creates image-trim.png

img-trim -t -b image.png
# Trims only the top and bottom
```

Side options: `-t` top, `-r` right, `-b` bottom, `-l` left.

## Development

Test password generation:

```bash
make test-passwd-gen
```

## TODO:

- Docs for the rest of the targets
