FROM ruby:2.2-onbuild
MAINTAINER Felix Seidel <felix@seidel.me>

RUN useradd -u 500 core
USER core
CMD ["./if-imap-then-pushover.rb"]
