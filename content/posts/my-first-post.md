---
title: "Creating a static site with Hugo"
date: 2021-06-27T16:38:34+02:00
draft: true
---

# What is Hugo?
Hugo is a static site generator, used for this website. A static site can be hosted almost anywhere, since the server does not have to do any processing. It simply serves the files to you and your browser will do most processing. These sites are built in html, css and javscript. Hugo transforms markdown files and a theme into a static website.

# Setup
For basic setup, use the excellent [quickstart](https://gohugo.io/getting-started/quick-start/) from Hugo's own documentation.

# Adding a theme
At the time of posting, this site uses the theme [Noteworthy](https://themes.gohugo.io/hugo-theme-noteworthy/). Follow its instructions to install it.

# Configuration
For a basic site, use the following configuration. It adds a menu bar with the sections about, tags and archives, some author information and optionally, links to your other (social) accounts.

Use the following config:
```toml
baseURL = "http://example.org/"
languageCode = "en-us"
title = "Timo"
theme = "noteworthy"


[author]
    name = "Timo"

[params]
linkedin = ""
github = ""

[[menu.main]]  # Set up the menu links
    identifier = "about"
    name = "About"
    url = "/about/"
    weight = 1 # Weight for sorting, from low (top) to high (bottom).

[[menu.main]]
    identifier = "tags"
    name = "Tags"
    url = "/tags/"
    weight = 2

[[menu.main]]
    name = "Archives"
    identifier = "archives"
    url = "/archives/"
    weight = 3
```

# Local development
To see the current version of your website, run `hugo serve -D`. This will serve your current version on your local machine.

# Hosting your site through Github Pages
You can host your site almost anywhere. In this case we will be using Github Pages.

1. Initialize your git repo with `git init`, if not already done so.
2. Create your repo through Github's web UI, or through the [Github cli](https://github.com/cli/cli): `gh repo reate`.
3. Add your remote: `git remote add origin git@github.com:timotk/timotk.github.io.git`
4. Add your files: `git add .`
5. Commit: `git commit -m 'Create my site with Hugo'`.
6. Push: `git push -u origin main`.
7.