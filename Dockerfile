FROM ruby:2.2-onbuild
MAINTAINER Felix Seidel <felix@seidel.me>

CMD ["./if-imap-then-pushover.rb"]
