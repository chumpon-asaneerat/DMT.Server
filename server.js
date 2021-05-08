const path = require("path");
//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');

const NFileSync = require('./dmt/filesync/filesync').NFileSync;
const NSFTP = require('./dmt/ftp/nftp').NSFTP;

const wsvr = new WebServer();
wsvr.listen();

const fileSync = new NFileSync();
fileSync.start();

const ftp = new NSFTP();
ftp.start();
