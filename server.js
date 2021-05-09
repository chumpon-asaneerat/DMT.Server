const path = require("path");
//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');
const fileSyncService = require('./dmt/filesync/filesync');
const SFTPService = require('./dmt/ftp/nftp');

const wsvr = new WebServer();
wsvr.listen();

//fileSyncService.start();
//SFTPService.start();
