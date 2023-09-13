# Blog

Code for [my blog](https://timotk.github.io/).

## Usage

Use [`just`](https://github.com/casey/just) to run commands.
Install `just` with:

```shell
cargo install just
```

Choose which command to run:

```shell
just --choose
```

Or simply use the default to serves the local site:

```shell
just
```

## Installation of themes

Install the submodules (for the theme):

```shell
git submodule update --init --recursive
```
