const path = require('path');
const find = require('find');
const fs = require('fs');

const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
// init logger
const logger = require(path.join(rootPath, 'nlib', 'nlib-logger'));

const JSONFile = nlib.JSONFile;

// default confit for file sync
const defaultCfg = { 
    import: {},
    export: {}
};

const cfgFileName = path.join(rootPath, 'SAP.files.config.json');

const NFileSync = class {
    constructor() {
        this.config = null
        this.loadconfig()
    }

    loadconfig = () => {
        console.log('load SAP files processing configuration.');
    
        if (!JSONFile.exists(cfgFileName)) {
            JSONFile.save(cfgFileName, defaultCfg)
        }
        this.config = JSONFile.load(cfgFileName)
    }

    start() {
        console.log('start file sync service.');
    }
}

let service = new NFileSync();

module.exports = exports = service;