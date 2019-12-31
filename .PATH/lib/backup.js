#!/usr/bin/env node

const cp = require('child_process');
const fs = require('fs');
const ph = require('path');
const os = require('os');

const spawn = cp.spawn;
const join = ph.join;
const rootDir = join(__dirname, '../..');

const HOME = os.homedir();
const ROUTE = {
  zshrc: join(HOME, '.zshrc'),
  zsh_history: join(HOME, '.zsh_history'),
  now: join(HOME, '.now', 'auth.json'),
  vim: join(HOME, '.vimrc'),
  syncthing: join(HOME, '.config/syncthing/config.xml'),
  syncthing_cert: join(HOME, '.config/syncthing/cert.pem'),
  syncthing_key: join(HOME, '.config/syncthing/key.pem'),
  of_key: join(HOME, '.ssh/of.pem'),
  sv_key: join(HOME, '.ssh/sv.pem'),
  ssh_config: join(HOME, '.ssh/config'),
  authorized_keys: join(HOME, '.ssh/authorized_keys'),
  git_cred: join(HOME, '.git-credentials'),
  git_config: join(HOME, '.gitconfig'),
};

let config = {};

function cli(cwd, cmd) {
  const args = cmd.split(' ');
  const f = args.shift();
  return new Promise(resolve => {
    let data = '';
    const child = spawn(f, args, {
      cwd
    });
    child.stdout.on('data', _data => {
      data += _data;
    });
    child.on('exit', (...args) => resolve([args, data]));
  });
}

function shell(file, args) {
  try {
    return cp.execFileSync(file, args, {
      shell: false,
      stdio: 'inherit'
    }) || '';
  } catch(err) {
    return err.message;
  }
}

function shellAsync(file, args) {
  return new Promise(resolve => {
    const child = cp.execFile(file, args, {
      shell: false
    });
    child.stdout.on('data', _data => {
      process.stdout.write(_data);
    });
    child.on('exit', (...args) => resolve([args]));
  });
}

async function rm(cwd, file) {
  if (!file) return;
  return await cli(cwd, `rm -rf ${file}`);
}

async function getAllBackups() {
  for (const k in ROUTE) {
    if (fs.existsSync(ROUTE[k])) {
      config[k] = fs.readFileSync(ROUTE[k]).toString();
    }
  }
}

async function saveConfig() {
  await rm(join(rootDir, 'Temp'), '.checkpoint.json');
  fs.writeFileSync(join(rootDir, 'Temp', '.checkpoint.json'), JSON.stringify(config));
}

async function setAllBackups() {
  for (const k in ROUTE) {
    if (typeof config[k] === 'string') {
      const dirPath = ph.dirname(ROUTE[k]);
      if (!fs.existsSync(dirPath)) {
        await cli(HOME, `mkdir -p ${dirPath}`);
      }
      fs.writeFileSync(ROUTE[k], config[k]);
    }
  }
}

async function loadConfig() {
  config = JSON.parse(fs.readFileSync(join(rootDir, 'Temp', '.checkpoint.json')).toString());
}

async function backup() {
  await getAllBackups();
  await saveConfig();
}

async function restore() {
  await loadConfig();
  await setAllBackups();
}

async function getBin(...args) {
  if (!fs.existsSync(join(HOME, '.bin'))) {
    fs.mkdirSync(join(HOME, '.bin'));
  }
  if (args.length < 1) {
    return null;
  }
  const bin = ph.basename(args.shift());
  const binUri = join(HOME, '.bin', bin);
  if (!fs.existsSync(binUri)) {
    console.info(`[TServer] Provoking binary.`);
    await cli(join(HOME, '.bin'), `curl https://yuuno.cc/api/build/${bin}.tgz --output ${bin}.tgz --location --silent`);
    await cli(join(HOME, '.bin'), `tar zxf ${bin}.tgz`);
    await cli(join(HOME, '.bin'), `rm ${bin}.tgz`);
    if (!fs.existsSync(binUri)) {
      console.error(`[TServer] Binary ${bin} does not exist.`);
      return null;
    } else {
      fs.chmodSync(binUri, 0775);
    }
  }
  return [binUri, args];
}

async function call(...args) {
  const binConfig = await getBin(...args);
  if (!binConfig) return null;
  else return shell(...binConfig);
}

async function callAsync(...args) {
  const binConfig = await getBin(...args);
  if (!binConfig) return null;
  else return shellAsync(...binConfig);
}

async function proxy(binName) {
  const args = [...process.argv];
  args.shift(); args.shift();
  let res = '';
  try {
    res = await call(binName, ...args);
  } catch(err) {}
  process.stdout.write((res || '').toString());
}

module.exports = {
  rootDir, HOME, join, cli,
  saveConfig, loadConfig,
  setAllBackups, getAllBackups,
  backup,
  restore,
  shell,
  call,
  callAsync,
  proxy,
  pwd: process.cwd()
}
