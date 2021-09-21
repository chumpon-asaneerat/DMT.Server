const path = require("path");
//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const fileSyncService = require('./dmt/filesync/filesync');
const SFTPService = require('./dmt/ftp/nftp');

// write app version to log
logger.info('start TA Server v1.0..0 build 360 update 2021-09-21 17:45');

// start web server
const wsvr = new WebServer();
wsvr.listen();

//fileSyncService.start();
//SFTPService.start();
