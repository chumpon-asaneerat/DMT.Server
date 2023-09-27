const path = require("path");
//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const JsonQueue = require('./dmt/utils/jsonqueue').JsonQueue;

//const fileSyncService = require('./dmt/filesync/filesync');
//const SFTPService = require('./dmt/ftp/nftp');

// write app version to log
logger.info('start TA Server v1.1.0 build 400 update 2023-09-26 14:30');

// start web server
const wsvr = new WebServer();
wsvr.listen();

//fileSyncService.start();
//SFTPService.start();
const reserveQueue = new JsonQueue(path.join('Queues', 'Reserve'))
reserveQueue.processFiles()
