const path = require("path");

//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const schedule = require('node-schedule')
const JsonQueue = require('./dmt/utils/jsonqueue').JsonQueue;
const sendToSAP = require('./sendToSAP');
const sendToSCW = require('./sendToSCW');

//const jsonFileUtils = require('./dmt/utils/json-file-utils');

// write app version to log
logger.info('start TA Server v1.1.0 build 455 update 2023-11-22 23:50');

// start web server
const wsvr = new WebServer();
wsvr.listen();

// set global schedule exit process
process.on('SIGINT', () => { 
    schedule.gracefulShutdown().then(() => process.exit(0))
})

sendToSAP.start() // start monitor data send to SAP
sendToSCW.start() // start monitor data send to SCW

//jsonFileUtils.removeFiles(path.join('Queues', 'ToSAP', 'backup'), 5)
