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
1. Open https://myupway.com/Systems using Chrome!
2. Activate developer mode in Chrome
<img width="819" alt="image" src="https://user-images.githubusercontent.com/2997782/157058576-e227c86f-e5ce-46c6-8fad-7f9c86eea466.png">
3. Go to change Komfort drift on you system. <img width="2549" alt="image" src="https://user-images.githubusercontent.com/2997782/157058744-cd864558-c0c4-4991-817a-a63fc3ed62ca.png">
4. In filter in the developer tools, write 2.2 and make sure you have selected the network tab. <img width="2547" alt="image" src="https://user-images.githubusercontent.com/2997782/157058960-571b6211-b7eb-4476-963d-9d941d8133f7.png">

5. Change mode and inspect the HTTP call, to find your metro id. Mine is 47041 <img width="2546" alt="image" src="https://user-images.githubusercontent.com/2997782/157059127-971c6b9e-2ed8-41b4-8ed7-a62d90763bef.png">


## Configuration - Script
You need to provide your login detials in the script. Put in your email, password and metro id in the script, in lines 9, 10 and 11.
You can test the script by executing `bash metrotherm.sh 0` to see if it switches to `Økonomi` mode on myupway.com

## Configuration - Home Assistant
You need to enable the script and be visible inside Home Assistant. To do so, edit your `configuration.yaml` file inside the `config` folder for your Home Assistant installation. Add the following to the file, or extend the list of shell commands:

```yaml
shell_command:
  metroterm_komfort_okonomi: "bash /config/metrotherm.sh 0"
  metroterm_komfort_normal: "bash /config/metrotherm.sh 1"
  metroterm_komfort_luksus: "bash /config/metrotherm.sh 2"
```
