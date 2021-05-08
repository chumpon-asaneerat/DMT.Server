const path = require('path');
const find = require('find');
const fs = require('fs');
const schedule = require('node-schedule');
const SFtpClient = require('ssh2-sftp-client')

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

// default confit for sftp
const defaultCfg = { 
    schedule: {
        website: {
            cron: 'https://crontab.guru/',
            nodeschedule: 'https://www.npmjs.com/package/node-schedule'
        },
        //cron: '0 2 * * *' // every at 2 am
        cron: '*/5 * * * * *' // every 5 seconds
    },
    server1: { 
        host: '203.114.69.22', port: 22, user: 'sapftp', pwd: '$apF+p', privateKeyFile: null 
    }, 
    server2: { 
        host: '192.168.1.37', port: 22, user: 'tester', pwd: 'password', privateKeyFile: null 
    },
    /*
    server2: { 
        host: '203.114.69.6', port: 22, user: 'sapftp', pwd: '$apF+p', privateKeyFile: null 
    },
    */
    downloads: [
        //{ remotePath: '', localPath: '' },
        //{ remotePath: '', localPath: '' },
        { remotePath: '/couponexp', remoteFile: '*.csv', localPath: 'D:\\samples\\' }
    ],
    uploads: [
        //{ localFiles: '', remotePath: '' },
        //{ localFiles: '', remotePath: '' },
        { localFiles: '', remotePath: '' }
    ]
};

const cfgFileName = path.join(rootPath, 'sftp.config.json');

const connect = async (client, config) => { 
    let success = false
    try {
        await client.connect({
            host: config.host,
            port: config.port,
            //privateKey: fs.readFileSync('/path/to/ssh/key'),
            username: config.user,
            password: config.pwd
        })
        success = true
    }
    catch (err) {
        logger.error(err.message)
    }
    finally {
        return success
    }
}
const download = async (client, remotePath, remoteFile, localPath) => { 
    let success = false
    try {
        let files = await client.list(remotePath, remoteFile)
        files.forEach(fileinfo => {
            console.log(fileinfo)
        })
        success = true
    }
    catch (err) {
        logger.error(err.message)
    }
    finally {
        return success
    }
}
const downloads = async (client, downloadList) => {
    let dn = [];
    dn.forEach(item => {})
    if (downloadList && downloadList.length > 0) {
        downloadList.forEach(async (item) => {            
            await download(client, item.remotePath, item.remoteFile, item.localPath)
        })
    }
} 
const disconnect = async (client) => { 
    let success = false
    try {
        await client.end()
        success = true
    }
    catch (err) {
        logger.error(err.message)
    }
    finally {
        return success
    }
}

const doFTP1 = async (config) => {
    let result = false
    let client = new SFtpClient('DMT-SFTP-Server')
    try {
        result = await connect(client, config.server1)
        if (result)
        {
            await downloads(client, config.downloads)
            await disconnect(client)
            result = true
        }        
    }
    catch (err) {
        logger.error(err.message)
        result = false
    }
    finally {
        return result
    }
}
const doFTP2 = async (config) => {
    let result = false
    let client = new SFtpClient('DMT-SFTP-Server')
    try {
        result = await connect(client, config.server2)
        if (result)
        {
            await downloads(client, config.downloads)
            await disconnect(client)
            result = true
        }        
    }
    catch (err) {
        logger.error(err.message)
        result = false
    }
    finally {
        return result
    }
}

const NSFTP = class {
    constructor() {
        this.onprocessing = false
        this.job = null
        this.config = null
        this.loadconfig()
    }
    loadconfig = () => {
        logger.info('load sftp configuration.')
    
        if (!JSONFile.exists(cfgFileName)) {
            JSONFile.save(cfgFileName, defaultCfg)
        }
        // load config
        this.config = JSONFile.load(cfgFileName)
    }
    start() {
        logger.info('start sftp service.')
        if (!this.config) {
            logger.info('sftp service config is null.')
            return;
        }
        let cron = this.config.schedule.cron
        let self = this;
        this.job = schedule.scheduleJob(cron, () => {
            self.processing()
        })
    }
    shutdown() {
        if (this.job) {
            try { this.job.cancel() }
            catch (err) { logger.error(err.message) }
        }
        this.job = null
    }
    processing() {
        if (this.onprocessing) {
            logger.info('sftp service in execute state.')
            return            
        }
        
        this.onprocessing = true

        logger.info('sftp sync process begin')
        if (!this.config) {
            logger.info('sftp service config is null.')
        }
        else {
            logger.info('download csv files.')
            doFTP1(this.config).then((s1) => 
            { 
                if (!s1) {
                    logger.info('server 1 failed.')
                    doFTP2(this.config).then((s2) => {
                        if (!s2) logger.info('server 2 failed.')
                        else this.onprocessing = false
                    })
                }
                else this.onprocessing = false
            })

            logger.info('upload txt files.')
        }
        logger.info('sftp sync process finish')
    }
}

let service = new NSFTP();

module.exports = exports = service;