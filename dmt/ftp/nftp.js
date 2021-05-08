const path = require('path');
const find = require('find');
const fs = require('fs');
const schedule = require('node-schedule');
const SFtpClient = require('ssh2-sftp-client');
const { cli } = require('winston/lib/winston/config');
const { CLIENT_RENEG_WINDOW } = require('tls');

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

const ftp = class {
    static connect(client, config) {
        return client.connect({
            host: config.host,
            port: config.port,
            //privateKey: fs.readFileSync('/path/to/ssh/key'),
            username: config.user,
            password: config.pwd
        })
    }
    static cwd(client) {
        return client.cwd()
    }
    static list(client, remptePath, remotePattern) {
        return client.list(remptePath, remotePattern)
    }
    static gets(client, remotePath, localPath, files, callback) {
        if (files && files.length > 0) {
            let icnt = 0;
            let imax = files.length;
            files.forEach(file =>  {
                let remoteFileName = path.join(remotePath, fileName)
                let localFileName = path.join(localPath, fileName)
                let dst = fs.createWriteStream(localFileName)
                client.get(remoteFileName, dst).then(() => {
                    icnt++
                    if (icnt >= imax) {
                        client.end() // all file downloaded so close connection.
                        if (callback) callback()
                    }
                })
            })
        }        
    }
}

const CreatePromiseFileList = (files) => {
    return new Promise(() => {
        return files;
    })
}

const downloadFiles = (serverConfig, downloadCondig, callback) => {
    let client = new SFtpClient('DMT-SFTP-Server')
    ftp.connect(client, serverConfig)
        .then(() => { return ftp.cwd(client) }) // get root directory
        .then((rootDir) => { 
            let files = []
            let icnt = 0;
            let imax = downloadCondig.length
            // set remote file search pattern to get list of files to download.
            downloadCondig.forEach(entry => {
                let remotePath = entry.remotePath
                let remotePattern = entry.remoteFile
                let fullRemotePath = path.join(rootDir, remotePath)
                ftp.list(client, fullRemotePath. remotePattern).then((files) => {
                    files.push(...files)
                    icnt++
                    if (icnt >= imax) return CreatePromiseFileList(files)
                })
            })
        })
        .then((files) => {
            let remotePath = downloadConfig.remotePath
            let localPath = downloadConfig.localPath
            ftp.gets(client, remotePath, localPath, files, callback)
        })
        .catch((err) => {
            logger.error(err.message)
            client.end()
            if (callback) callback()
        })
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
            /*
            let self = this
            downloadFiles(this.config.server2, this.config.downloads, () => {
                self.onprocessing = false
            })
            */
        }
        logger.info('sftp sync process finish')
    }
}

let service = new NSFTP();

module.exports = exports = service;