const path = require("path");
//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const fileSyncService = require('./dmt/filesync/filesync');
const SFTPService = require('./dmt/ftp/nftp');

// write app version to log
logger.info('start TA Server v1.0.0 build 383 update 2022-11-01 00:30');

// start web server
const wsvr = new WebServer();
wsvr.listen();

//fileSyncService.start();
//SFTPService.start();
