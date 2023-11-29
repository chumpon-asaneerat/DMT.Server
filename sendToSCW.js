const path = require("path");
const rootPath = process.env['ROOT_PATHS'];

const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const schedule = require('node-schedule')

const nlib = require("./nlib/nlib");
const moment = require('moment');

const sqldb = require(path.join(nlib.paths.root, 'TAxTOD.db'));
const dbutils = require(path.join(rootPath, 'dmt', 'utils', 'db-utils')).DbUtils;

const SendToSCW = class {
    constructor() {
        this.Processing = false
    }

    async sendCouponToSCW() {
        let tdate = moment().format();
        // call sp
        let db = new sqldb()
        await db.connect()
        let params = {
            transactiondate: tdate
        }
        logger.info('call SP "TA_SendCouponToSCW":')
        logger.info(JSON.stringify(params))

        const dbResult = await db.TA_SendCouponToSCW(params)
        if (dbResult && dbResult.errors && dbResult.errors.hasError == false) {
            logger.info('sync coupon to scw success')
        }
        else {
            logger.info('sync coupon to scw failed')
        }
        await db.disconnect()
    }

    start() {
        schedule.scheduleJob('*/30 * * * * *', () => {
            if (!this.Processing) {
                this.Processing = true
                // auto send reserve in every 30 seconds
                this.sendCouponToSCW().then(_ => { 

                })
                
                this.Processing = false
            }
        })
    }
}

let service = new SendToSCW();

module.exports = exports = service;