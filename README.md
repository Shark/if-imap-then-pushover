# if-imap-then-pushover

Ruby app which subscribes to an IMAP mailbox, waits for new messages to arrive using [IMAP IDLE](https://tools.ietf.org/html/rfc2177) and sends a notification for all new messages using [Pushover](https://www.pushover.net).

## Installation

To use locally:
```
git clone https://github.com/Shark/if-imap-then-pushover.git
bundle install
./if-imap-then-pushover.rb
```

To build a Docker image and run it in a container:
```
git clone https://github.com/Shark/if-imap-then-pushover.git
./docker_build.sh
docker run -d -v $(pwd)/config:/usr/src/app/config:ro sh4rk/if-imap-then-pushover
```
## Usage

1. Put your configuration file in `config/config.yml`. When using the docker container remember to map the local config directory into the container using the above command.

2. Run `./if-imap-then-pushover.rb` or create a Docker container as outlined above.

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request! :)

## History
- v0.1.0 (2015-10-14): initial version

## Credits
https://github.com/tjtg/imap-pushover served as an inspiration. :)

## License

This project is licensed under the Apache 2.0 License. See LICENSE for details.
