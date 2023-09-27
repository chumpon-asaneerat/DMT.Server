const path = require("path");
//const nlib = require("./nlib/nlib");
const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const schedule = require('node-schedule')
const JsonQueue = require('./dmt/utils/jsonqueue').JsonQueue;
const sendToSAP = require('./sendToSAP');

// write app version to log
logger.info('start TA Server v1.1.0 build 400 update 2023-09-26 14:30');

// start web server
const wsvr = new WebServer();
wsvr.listen();

// set global schedule exit process
process.on('SIGINT', () => { 
    schedule.gracefulShutdown().then(() => process.exit(0))
})

sendToSAP.start() // start monitor data send to SAP