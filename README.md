# Yuuno Workspace

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/NHibiki/workspace)

### Usage

#### 1. Fork/Clone the workspace

```bash
git clone https://github.com/YOUR_ACCOUNT/workspace.git
```

#### 2. Init essentials

If you are using docker image `nhibiki/dev:env`, please start like that:

```bash
docker run --name env --restart always -d -v $(pwd)/server:/root --network host nhibiki/dev:env
```

Then you can **skip** the following and jump to [the Third Section](#3-workspace-scripts)

Otherwise, check the following steps.

##### 1) Check Requirements

```bash
cd workspace
.PATH/lib/init-requirements.sh
```

Be sure to have them installed!

##### 2) \[Optional\] Install VRAM

If you are running this script on host machine, you can install a 2GB VRAM by launching the script:

```bash
.PATH/lib/init-config.sh
```

##### 3) Install essentials

Since the script will change the default terminal to `zsh`, so there might be a prompt for you to input your password:

```bash
.PATH/lib/init-vm.sh
```

##### 4) All done

You can reconnect to your server, or run `zsh` manually to get start.

Once you enter the `zsh`, you can use `nvm ls-remote` to install your favourate nodejs version.

```zsh
nvm install v10.17.0
```

#### 3. Workspace Scripts

There are several built-in scripts you can use in the workspace:

##### 0) use git submodule to track your working process

If you want to clone a repo from your git server, DO NOT use `git clone` unless you know what you are doing!

The smartest way to keep track of your repo is `git submodule add`. So that the info of your working repo would be kept in the workspace (and you can upload to your workspace any time).

To retrieve your work from `submodule`, you can run `git submodule update --init` instead of `git pull`.

##### 0) use rmsubmodule to remove submodules

If you want to wave a repo out from your workspace, use `rmsubmodule PATH_TO_YOUR_REPO` **inside** your workspace.

**REMEMBER**, all **unstaged** data in this submodule repo will be completely **REMOVED** and not recovered! Know what you are going to do before run this command.

After run the command, the git still keeps track the staging module data. To remove it, run `rm -rf {YOUR_WORKSPACE}/.git/modules/{PATH_TO_YOUR_REPO}`. (This cannot be undone.)

##### 1) use addsubmodule to add repo to workspace

Similarly, if you want to add a repo, instead of `git submodule add`, you can directly run `addsubmodule $URL`.

##### 2) backup/restore

It will backup your ssh keys, zsh history and config to `Temp/.checkpoint.json`, this file would not be upload to your workspace repo automaticly. If you want to keep this file in your github, remove this entry from `.gitignore`. (This might cause leak of your personal information! Be cautious!)

`backup`
`restore`

##### 3) call

This smart library call will enable you to **retrieve binary and run**, without an install process. All binaries are compiled only for linux\_amd64 and archived well to save your traffic.

Current available binaries are:

- caddy (v1)
- caddyy (v1 with YuunoAuth module)
- docker (cli only)
- pgweb (postgresql explorer)
- syncthing (world's best syncing tool)
- code (cdr/codeserver engine)
- code-alpine (above one for alpine linux build
- mc (minio cli)

Example:
```zsh
call caddy -conf ~/workspace/Server/Caddyfile
```

##### 4) vscode-server

This script will launch `caddyy` and `code` that starts a web-ide for your workspace.

Before you start, check `Server/Caddyfile` and modify the last param in `jwt` to your github mail (YuunoAuth uses github to authenticate your identity). You can also modify this `Caddyfile` to route on your own (using SSL etc.)

If you keep `$HOST` in the `Caddyfile`, you might want to launch code-server as following:

```
HOST=YOUR_HOST PASSWORD=yourpassword vscode-server
# example: HOST=ide.example.com PASSWORD=helloworld vscode-server
```
