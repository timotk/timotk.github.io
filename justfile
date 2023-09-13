default: serve

install:
    brew install hugo

hugo_exists:
    type hugo

serve: hugo_exists
    # Serve local site, and open in browser, but keep logging to terminal
    hugo serve -D | tee /dev/tty |  grep --line-buffered "http://\S*" --only-matching -m 1 | xargs open