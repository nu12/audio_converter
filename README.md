# Audio Converter

Featuring redis-server as cache database, ActionCable implementation and ffmpeg  tool.

## Production: Docker
```shell
$ git clone https://github.com/nu12/audio_converter.git
$ SECRET_KEY_BASE=your_secret_key_base_here docker-compose up
```

## Development: Vagrant

Install `redis-server` and `ffmpeg` in the development environment. 

```shell
$ git clone https://github.com/nu12/audio_converter.git
$ vagrant up && vagrant ssh
```