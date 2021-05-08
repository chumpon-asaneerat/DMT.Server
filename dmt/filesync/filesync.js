const path = require('path');
const find = require('find');
const fs = require('fs');
const schedule = require('node-schedule');

const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
// init logger
const logger = require(path.join(rootPath, 'nlib', 'nlib-logger')).logger;

const JSONFile = nlib.JSONFile;

/*
Cron-style Scheduling
The cron format consists of:

*    *    *    *    *    *
┬    ┬    ┬    ┬    ┬    ┬
│    │    │    │    │    │
│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
│    │    │    │    └───── month (1 - 12)
│    │    │    └────────── day of month (1 - 31)
│    │    └─────────────── hour (0 - 23)
│    └──────────────────── minute (0 - 59)
└───────────────────────── second (0 - 59, OPTIONAL)
*/

// default confit for file sync
const defaultCfg = { 
    schedule: {
        website: {
            cron: 'https://crontab.guru/',
            nodeschedule: 'https://www.npmjs.com/package/node-schedule'
        },
        //cron: '0 2 * * *' // every at 2 am
        cron: '*/5 * * * * *' // every 5 seconds
    },
    import: {},
    export: {}
};

const cfgFileName = path.join(rootPath, 'SAP.files.config.json');

const NFileSync = class {
    constructor() {
        this.job = null;
        this.config = null
        this.loadconfig()
    }

    loadconfig = () => {
        logger.info('load SAP files processing configuration.')
    
        if (!JSONFile.exists(cfgFileName)) {
            JSONFile.save(cfgFileName, defaultCfg)
        }
        this.config = JSONFile.load(cfgFileName)
    }

    start() {
        logger.info('start file sync service.')
        if (!this.config) {
            logger.info('file sync service config is null.')
            return;
        }
        let cron = this.config.schedule.cron
        this.job = schedule.scheduleJob(cron, () => {
            logger.info('file sync process begin')
        })
    }
    shutdown() {
        if (this.job) {
            try { this.job.cancel() }
            catch (err) { logger.error(err.message) }
        }
        this.job = null;
    }
}

let service = new NFileSync();

module.exports = exports = service;