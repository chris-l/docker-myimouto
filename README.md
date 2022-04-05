Repository: [docker-myimouto](https://github.com/chris-l/docker-myimouto)

MyImouto is a booru image board, a clone of Moebooru for PHP. It was abandoned by its creator, but its still usable.

This is a Docker image based on Ubuntu 16.04 with the nginx server.

## Features

* It uses a fork of MyImouto with the last version released by its creator.
* Based on Ubuntu LTS Xenial Xerus - 16.04
* Nginx server installed and configured.
* It only requires a MySQL server.
* It includes a docker-compose.yaml file to install it along with a mysql:5.6 container.
* The admin username and password, along with the base settings can be set using environment variables
* The `config` folder contains the `config.php`, where more settings can be configured.

## How to build

```shell
git clone https://github.com/chris-l/docker-myimouto.git
cd docker-myimouto

docker build -t myimouto .
```

## Environment variables

### General

* `TZ`: The timezone assigned to the container (default `UTC`)
* `MAX_FILESIZE`: The max file size used for Nginx and php (default "50M")
* `POST_MAX_SIZE`: The max post size used for PHP (default "250M")
* `DISPLAY_ERRORS`: PHP's option to display errors (default "On")
* `MYSQL_SERVER`: The address of the MySQL server (default "172.17.0.1")
* `MYSQL_PORT`: The port used by the MySQL server (default "3306")
* `MYSQL_DATABASE`: The name of the database used by myimouto  (default "myimouto")
* `MYSQL_USERNAME`: The name of the mysql user (default "root")
* `MYSQL_PASSWORD`: The name of the mysql user (default "mysqlpassword")

### MyImouto

* `APP_NAME`: The name of this booru. (default "my.imouto")
* `SERVER_HOST`: Host name. Must not include scheme (http(s)://) nor trailing slash. (default "127.0.0.1:3000")
* `URL_BASE`: This is the same as `SERVER_HOST` but includes scheme. (default "http://127.0.0.1:3000")
* `ADMIN_USERNAME`: The username for the admin (default "admin")
* `ADMIN_PASSWORD`: The password for the admin (default "password")


## Volumes

* `/srv/myimouto/public/data`: Images, thumbnail, etc.
* `/config`: Path for the dir containing the config.php file.

## Port

* `3000`: Default web port used by MyImouto

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. It will also install a mysql:5.6 container. Edit the [docker-compose.yaml](https://github.com/chris-l/docker-myimouto/blob/master/docker-compose.yaml) with your preferences and run the
following command:

```shell
docker-compose up -d
```

### Command line

You can also use the following command:

```shell
mkdir data config
docker run -d --name myimouto \
  -p 3000:3000 \
  -v $(pwd)/data:/srv/myimouto/public/data \
  -v $(pwd)/config:/config \
  -e MYSQL_SERVER=<your mysql server> \
  -e MYSQL_USERNAME=root \
  -e MYSQL_PASSWORD=<put the mysql password here> \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=<put the myimouto admin password here> \
  -e TZ=UTC \
  -e SERVER_HOST=127.0.0.1:3000 \
  -e URL_BASE=http://127.0.0.1:3000/ \
  chrll/myimouto:latest
```

### License

MIT
