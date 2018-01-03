# Nicolasss

This is jekyll site template. Used for [my blog](http://nicolas.zz.mu). Based on [Exemplar](https://github.com/tybenz/exemplar)

## Getting Started

Pull all gems. In your terminal run:

    bundle install
    bourbon install --path _sass/
    neat install --path _sass/

Start running Jekyll (defaults to port 4000) and watching Sass:

    rake // 'rake watch' also works

Before deploying your site, stop `rake watch` and run `rake generate` to generate a production-ready site (no Scss comments).


