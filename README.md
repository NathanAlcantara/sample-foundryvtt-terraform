# Requirements

* [Foundry License](https://foundryvtt.com)
* [AWS Account](https://aws.amazon.com)
* [Terraform CLI](https://www.terraform.io)
* [jq](https://stedolan.github.io/jq)

# Creating a new Instance

First you have to create inside the `files` folder, a file called `aws.json` with a value about your aws account, something like this:

```json
{
    "accessKeyId": "...",
    "secretAccessKey": "...",
    "region": "..."
}
```

And at the same folder you have to put the foundryvtt.zip that you can download using your license (This is a temporary mesure).

After this you just initialize terraform: `terraform init`
And then you can `plan` and/or `apply` to your account and see the magic working! :tada: 

<!-- terraform output foundry_dns -->

# Migrating of a existent instance

If you already has a foundry instance in other place you can migrate easily to aws, you just need install the [Forien's Copy Environment](https://foundryvtt.com/packages/forien-copy-environment) module at your existent foundry and then you can save both the environment as JSON and export de settings.

`foundry-environment.json` -> Contains the infos of the system and modules that you are using in your instance; 

`foundry-settings-export.json` -> Contains **every** settings of that world (default ones, of modules, including players settings);

After get this two files you just need to create a new instance with those few differences of your choice:

* To install the system and the modules on your new instance just put the `foundry-environment.json` at folder `files`;

* To import your(s) world(s) you have to create a file called `set_worlds_dirs.sh` at folder `scripts` which will set a variable `WORLDS_DIRS` that will contain one or more paths of worlds, something like this:
    ```sh
    #!/bin/bash

    # single directory

    WORLDS_DIRS=~/Documents/Foundry/worlds/skt

    # multi directories

    WORLDS_DIRS=(~/Documents/Foundry/worlds/skt ~/Documents/Foundry/worlds/lmop)

    # You can even download from some place

    git clone https://git/repository.git world

    WORLDS_DIRS=world
    ```

* To import the settings of the worlds just turn on the [Forien's Copy Environment](https://foundryvtt.com/packages/forien-copy-environment) module and import your `foundry-settings-export.json` file.