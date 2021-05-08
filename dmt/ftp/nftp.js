const path = require('path');
const find = require('find');
const fs = require('fs');

const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
// init logger
const logger = require(path.join(rootPath, 'nlib', 'nlib-logger'));

const JSONFile = nlib.JSONFile;

// default confit for sftp
const defaultCfg = { 
    server1: { 
        host: '', port: 22, user: '', pwd: '', privateKeyFile: null 
    },
    server2: { 
        host: '', port: 22, user: '', pwd: '', privateKeyFile: null 
    }
};

const cfgFileName = path.join(rootPath, 'sftp.config.json');

const NSFTP = class {
    constructor() {
        this.config = null
        this.loadconfig()
    }

    loadconfig = () => {
        console.log('load sftp configuration.');
    
        if (!JSONFile.exists(cfgFileName)) {
            JSONFile.save(cfgFileName, defaultCfg)
        }
        // load config
        this.config = JSONFile.load(cfgFileName)
    }

    start() {
        console.log('start sftp service.');
    }
}

let service = new NSFTP();

module.exports = exports = service;