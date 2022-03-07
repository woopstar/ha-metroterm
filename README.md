# ha-metroterm



Home Assistant script to change "Komfort drift" on Metroterm using the API from MyUpWay.com.


## Requirements
You need subscribtion on myupway.com to change settings on your Metrotherm for this script to work.


# Installation
Go to your `config` folder for your Home Assistant installation, and download the script:

```shell
wget https://raw.githubusercontent.com/woopstar/ha-metroterm/main/metrotherm.sh
```

## How to find your metro id
...

## Configuration - Script
You need to provide your login detials in the script. Put in your email, password and metro id in the script, in lines 9, 10 and 11.
You can test the script by executing `bash metrotherm.sh 0` to see if it switches to `Økonomi` mode on myupway.com

## Configuration - Home Assistant
You need to enable the script and be visible inside Home Assistant. To do so, edit your `configuration.yaml` file inside the `config` folder for your Home Assistant installation. Add the following to the file, or extend the list of shell commands:

```yaml
shell_command:
  metroterm_komfort_okonomi: /config/metrotherm.sh 0
  metroterm_komfort_normal: /config/metrotherm.sh 1
  metroterm_komfort_luksus: /config/metrotherm.sh 2
```
