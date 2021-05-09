require('events').EventEmitter.defaultMaxListeners = 100

const path = require('path');
const find = require('find');
const fs = require('fs');
const schedule = require('node-schedule');
const SFtpClient = require('ssh2-sftp-client');
const { ClientHttp2Session } = require('http2');

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

const testConnection = async (ftpCfg) => {
    let client = new SFtpClient('test-ftp-server')
    let success = false
    try {
        await client.connect({
            host: ftpCfg.host,
            port: ftpCfg.port,
            //privateKey: fs.readFileSync('/path/to/ssh/key'),
            username: ftpCfg.user,
            password: ftpCfg.pwd
        })

        logger.info(`success connect to host: ${ftpCfg.host}, port: ${ftpCfg.port}`)
        success = true
        client.end()
    }
    catch (err) {
        logger.error(`failed connect to host: ${ftpCfg.host}, port: ${ftpCfg.port}`)
        logger.error(err.message)
        success = false
    }
    return success
}
const selectFTPServer = async (config) => {
    let success = false
    let ftpCfg;
    // Use server 1 config
    try {
        ftpCfg = config.server1
        logger.info(`attemp to connect host: ${ftpCfg.host}, port: ${ftpCfg.port}`)
        success = await testConnection(ftpCfg)
    }
    catch (err) {
        success = false
        ftpCfg = null
    }
    if (success) return ftpCfg
    // Use server 2 config
    try {
        ftpCfg = config.server2
        logger.info(`attemp to connect host: ${ftpCfg.host}, port: ${ftpCfg.port}`)
        success = await testConnection(ftpCfg)
    }
    catch (err) {
        success = false
        ftpCfg = null
    }
    return ftpCfg
}

const checkLocalDir = (localFileName) => {
    try {
        let dirName = path.dirname(localFileName)
        if (!fs.existsSync(dirName)) {
            logger.info(`local path ${dirName} not exits create new one.`)
            fs.mkdirSync(dirName)
        }
    }
    catch (err) {
        logger.error(err.message)
    }
}

const removeDownloadList = (client, entries, callback) => {
    if (!entries || entries.length <= 0) {
        callback({error: 'no download list'})
        return
    }
    let icnt = 0;
    let imax = entries.length;
    entries.forEach(entry => {
        let remoteFileName = entry.remoteFileName
        let localFileName = entry.localFileName

        logger.info(`  ==> delete ${remoteFileName}`)
        let fstat = fs.statSync(localFileName)
        let fsize = fstat.size
        if (fsize == entry.fileSize) {
            client.delete(remoteFileName)
                .then(() => {
                    icnt++
                    if (icnt >= imax) {
                        callback({error: null})
                    }
                })
                .catch((err) => {
                    logger.error(err.message)
                    callback({error: err})
                })
        }
        else {
            icnt++
            if (icnt >= imax) {
                callback({error: null})
            }
        }
    })
}

const processDownloadList = (client, entries, callback) => {
    if (!entries || entries.length <= 0) {
        callback({error: 'no download list'})
        return
    }
    let icnt = 0;
    let imax = entries.length;
    entries.forEach(entry => {
        let remoteFileName = entry.remoteFileName
        let localFileName = entry.localFileName
        checkLocalDir(localFileName) // check is local dir exists (auto create if not).
        let dst = fs.createWriteStream(localFileName)

        logger.info(`  ==> download ${remoteFileName}`)
        client.get(remoteFileName, dst)
            .then((stream) => {
                //stream.on('end', () => { })
                icnt++
                if (icnt >= imax) {
                    //callback({error: null})
                    removeDownloadList(client, entries, (obj) => {
                        callback(obj)
                    })
                }
            })
            .catch((err) => {
                logger.error(err.message)
                callback({error: err})
            })
    })
}

const processRemoteFiles = (client, root, config, callback) => {
    if (!config || !config.downloads || config.downloads.length <= 0) {
        callback({error: 'no download config'})
        return
    }

    let entries = []
    let icnt = 0;
    let imax = config.downloads.length
    config.downloads.forEach(entry => { 
        //let fullRemotePath = path.join(root, remotePath)
        client.realPath(entry.remotePath).then((realDir) => {
            let remotePath = realDir
            let remotePattern = entry.remoteFile
            let localPath = entry.localPath
            client.list(remotePath, remotePattern)
                .then(remoteItems => {
                    if (remoteItems && remoteItems.length > 0) {
                        logger.info(' ** prepare download files ** ')
                        remoteItems.forEach(remoteItem => {
                            let item = {
                                remoteFileName: path.join(remotePath, remoteItem.name),
                                localFileName: path.join(localPath, remoteItem.name),
                                fileSize: remoteItem.size
                            }
                            logger.info(`  # ${item.remoteFileName} -> ${item.localFileName} (size: ${item.fileSize})`)
                            entries.push(item) // push to list
                        })
                    }
                    else {
                        logger.info(` ** no files in ${remotePath} ** `)
                    }
                    // increate next index of download config
                    icnt++
                    if (icnt >= imax) {
                        // all remote files prepared
                        processDownloadList(client, entries, (obj) => {
                            callback(obj)
                        })
                    }
                })
                .catch(err => {
                    logger.error(err.message)
                    callback({error: err})
                })
        })
    })
}

const downloadFiles = async (config, callback) => {
    selectFTPServer(config).then(async (ftpCfg) => {
        let client = new SFtpClient('DMT-SFTP-Server')
        try {
            // connect
            await client.connect({
                host: ftpCfg.host, port: ftpCfg.port,
                //privateKey: fs.readFileSync('/path/to/ssh/key'),
                username: ftpCfg.user, password: ftpCfg.pwd
            })
            // get current root remote dir
            let root = await client.cwd()
            logger.info(`** root: ${root}`)

            // loop all download paths.
            processRemoteFiles(client, root, config, () => {
                // disconnect
                client.end() 
                // notify caller that operation is end.
                callback({data: null})
            })
        }
        catch (err) {
            logger.error(err.message)
            callback({error: err})
        }
    }).catch(err => {
        // both host is not avaliable.
        logger.error('both host is not avaliable')
        logger.error(err.message)
        callback({error: err})
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
            this.onprocessing = false
        }
        else {
            let self = this
            logger.info('download csv files.')
            downloadFiles(this.config, () => {
                self.onprocessing = false
            })
        }
        logger.info('sftp sync process finish')
    }
}

let service = new NSFTP();

module.exports = exports = service;