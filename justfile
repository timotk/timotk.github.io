default: serve

install:
    # Install hugo
    brew install hugo

hugo_exists:
    # Check if hugo is installed
    type hugo

serve: hugo_exists
    # Serve local site, and open in browser, but keep logging to terminal
    hugo serve -D | tee /dev/tty |  grep --line-buffered "http://\S*" --only-matching -m 1 | xargs open

new +title:
    #!/usr/bin/env bash
    # Create a new post with the given title. Usage: just new Hello World
    title=$(echo {{title}} | tr " " "-" | tr "[:upper:]" "[:lower:]")
    hugo new posts/${title}.md
