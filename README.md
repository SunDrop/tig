# Example Docker Compose project for Telegraf, InfluxDB and Grafana

This an example project to show the TIG (Telegraf, InfluxDB and Grafana) stack.

![Example Screenshot](./example.png?raw=true "Example Screenshot")

## Setup env configuration

Set up correct IP value for PROJECT_HOSTNAME env var, for instance `PROJECT_HOSTNAME=127.0.0.5`

Link this IP in /etc/hosts with your local domain:
```bash
$ cat /etc/hosts

##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
# ...
127.0.0.5 tig.local
```

<details><summary>4.1. Mac users only</summary>
Inside the docker-compose file, we are using the internal network with a lo0 interface (127.x.x.x)
It's automatically supported on *nix machine, but for MacOS, you need some additional steps.

* Copy content bellow into /Library/LaunchDaemons/com.docker_127005_alias.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.docker_127005_alias</string>
    <key>ProgramArguments</key>
    <array>
        <string>ifconfig</string>
        <string>lo0</string>
        <string>alias</string>
        <string>127.0.0.5</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

* Reload LaunchDaemons by restarting the computer or run follow command

```bash
sudo launchctl load /Library/LaunchDaemons/com.docker_127005_alias.plist
```
</details>

## Start the stack with docker compose

```bash
$ docker-compose up
OR
$ make up
```

## Services and Ports

### Grafana
- URL: http://tig.local:3000 
- User: admin 
- Password: admin 

### Telegraf
- Port: 8125 UDP (StatsD input)

### InfluxDB
- Port: 8086 (HTTP API)
- User: admin 
- Password: admin 
- Database: influx


Run the influx client:

```bash
$ docker-compose exec influxdb influx -execute 'SHOW DATABASES'
OR
$ make influx-cli
```

Run the influx interactive console:

```bash
$ docker-compose exec influxdb influx
OR
$ make influx-console

Connected to http://localhost:8086 version 1.8.0
InfluxDB shell version: 1.8.0
>
```

[Import data from a file with -import](https://docs.influxdata.com/influxdb/v1.8/tools/shell/#import-data-from-a-file-with-import)

```bash
$ docker-compose exec -w /imports influxdb influx -import -path=data.txt -precision=s
OR
$ make influx-import
```

## Run the PHP Example

The PHP example generates random example metrics. The random metrics are beeing sent via UDP to the telegraf agent using the StatsD protocol.

The telegraf agents aggregates the incoming data and perodically persists the data into the InfluxDB database.

Grafana connects to the InfluxDB database and is able to visualize the incoming data.

```bash
$ docker-compose exec php bash
$ php /var/www/html/example.php
OR
$ make php-run

Sending Random metrics. Use Ctrl+C to stop.
..........................^C
Runtime:	0.88382697105408 Seconds
Ops:		27 
Ops/s:		30.548965899738 
Killed by Ctrl+C
```

## Monotoring
![Run load](/docs/tig-up.png?raw=true "Run load")
![Stop load](/docs/tig-down.png?raw=true "Stop load")
1) make php-run - load on php-cli
2) http://tig.local/ - open the local Nginx in the browser. There, in an endless loop, connections to MongoDB are created.

In picture No. 1 - we gave the load, in picture No. 2 - the load was removed.

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
