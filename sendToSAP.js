const path = require("path");
const rootPath = process.env['ROOT_PATHS'];

const WebServer = require('./nlib/nlib-express');
// init logger
const logger = require('./nlib/nlib-logger').logger;

const schedule = require('node-schedule')

const nlib = require("./nlib/nlib");
const jsonFile = nlib.JSONFile

const sqldb = require(path.join(nlib.paths.root, 'TAxTOD.db'));
const dbutils = require(path.join(rootPath, 'dmt', 'utils', 'db-utils')).DbUtils;

const JsonQueue = require('./dmt/utils/jsonqueue').JsonQueue;

const reserveQueue = new JsonQueue(path.join('Queues', 'ToSAP'))

const SendToSAP = class {
    constructor() {
        this.Processing = false
    }

    async getUnsendData() {
        // save to db
        let db = new sqldb()
        await db.connect()
        const dbResult = await db.Sap_GetUnsendReservationHead()
        if (dbResult && dbResult.data) {
            let heads = dbResult.data
            for await (let head of heads) {
                let doc = {
                    BASE_DATE: head.BASE_DATE,
                    MOVEMENT_TYPE: head.MOVEMENT_TYPE,
                    GOODS_RECIPIENT: head.GOODS_RECIPIENT,
                    RECEIVING_STOR: head.RECEIVING_STOR,
                    ITEM: [],
                    RETURN: []
                }
                let pObj = {
                    goodsrecipient: head.GOODS_RECIPIENT
                }
                const dbResult2 = await db.Sap_GetReservationItem(pObj)
                if (dbResult2 && dbResult2.data) {
                    let items = dbResult2.data
                    for await (let item of items) { 
                        let docItem = {
                            ITEM_NUMBER: item.ITEM_NUMBER,
                            MATERIAL_NUM: item.MATERIAL_NUM,
                            MATERIAL_DESCRIPTION: item.MATERIAL_DESCRIPTION,
                            QUANTITY: item.QUANTITY,
                            UNIT_OF_MEASURE: item.UNIT_OF_MEASURE,
                            PLANT: item.PLANT,
                            FROM_STOR: item.FROM_STOR
                        }
                        doc.ITEM.push(docItem)
                    }
                }
                // write file
                reserveQueue.writeFile(doc, null, doc.GOODS_RECIPIENT)
                // mark send to SAP
                var pObj2 = {
                    goodsrecipient: head.GOODS_RECIPIENT
                }
                await db.Sap_UpdateSendReservation(pObj2)
            }
        }
        await db.disconnect()
    }

    start() {
        schedule.scheduleJob('*/5 * * * * *', () => {
            if (!this.Processing) {
                this.Processing = true
                // auto send reserve in every 5 seconds
                this.getUnsendData().then(_ => { 
                    //reserveQueue.Url = 'https://api.restful-api.dev/objects'
                    //reserveQueue.Url = 'https://172.16.202.138:44380/sap/opu/odata/SAP/ZOD_MM_INTERFACE_SRV/RESERVHSet'
                    // Note: 2023-10-10 
                    // changes vhdmptwdwd01.sap.tollway.co.th:44380 เป็น sapdev.tollway.co.th:443
                    reserveQueue.Url = 'https://sapdev.tollway.co.th:443/sap/opu/odata/SAP/ZOD_MM_INTERFACE_SRV/RESERVHSet'
                    reserveQueue.processFiles()
                })
                
                this.Processing = false
            }
        })
    }
}

let service = new SendToSAP();

module.exports = exports = service;