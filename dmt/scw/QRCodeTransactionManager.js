//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment');
const { Console } = require('console');

//#endregion

const jsonFileName = path.join(rootPath, 'SCW', 'qrcodeTransactionList.json');

const QRCodeTransactionManager = class {
    constructor() {
        this.load()
    }    
    add(networkId, plazaId, laneId, staffId, staffNameTh, staffNameEn, trxDateTime, amount, approvCode, refNo) {
        this.load()
        if (!this.data || !this.data.list) this.clear()
        let list = this.data.list
        let obj = {
            networkId: networkId,
            plazaId: plazaId,
            laneId: laneId,
            staffId: staffId,
            staffNameTh: staffNameTh,
            staffNameEn: staffNameEn,
            trxDateTime: trxDateTime,
            amount: amount,
            approvCode: approvCode,
            refNo: refNo
        }
        // Check no open job on current landId
        if (list) {
            console.log('ADD NEW!!')
            this.data.list.push(obj) // append to array.
            this.save()
        }
    }
    remove(trxDateTime, approvCode) {
        this.load()
        if (this.data && this.data.list) {
            // loop to find match job attributes.
            let i = this.data.list.length
            while (i--) {
                let el = this.data.list[i]
                // make sure in same format.
                let dt1 = moment(el.trxDateTime).format('YYYY-MM-DDTHH:mm:ss.SSSZZ')
                let dt2 = moment(trxDateTime).format('YYYY-MM-DDTHH:mm:ss.SSSZZ')
                if (dt1 === dt2 && 
                    el.approvCode.trim() === approvCode.trim()) {
                        this.data.list.splice(i, 1) // remove from list
                }
            }
            this.save()
        }
    }
    removes(list) {
        if (list && list.length > 0) {
            let trxDateTime, approvCode
            if (this.data && this.data.list) {
                list.forEach(item => {
                    // extract each item data.
                    trxDateTime = item.trxDate
                    approvCode = item.approvalCode
                    // remove one by one.
                    this.remove(trxDateTime, approvCode)
                })
            }
        }
    }
    clear() {
        this.data = {
            list: [],
            status : {
                code: "S200",
                message: "Success"
            }
        }
        this.save();
    }
    load() {
        try {
            // load from file.
            this.data = nlib.JSONFile.load(jsonFileName)
        }
        catch {
            // error load file.
            this.clear() // init new one.
        }
    }
    save() {
        if (!this.data) this.clear() // if no data create new one.
        // save to file.
        nlib.JSONFile.save(jsonFileName, this.data)
    }
    getQRCodeTrans(networkId, plazaId, staffId, startDateTime, endDateTime) {
        let rets = []
        this.load()
        if (this.data && this.data.list) {
            if (staffId) {
                if (!startDateTime && ! endDateTime) {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.staffId === staffId
                    })
                }
                else if (startDateTime && !endDateTime) {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.staffId === staffId && 
                            el.trxDateTime >= startDateTime
                    })
                }
                else if (!startDateTime && endDateTime) {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.staffId === staffId && 
                            el.trxDateTime <= endDateTime
                    })
                }
                else {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.staffId === staffId && 
                            el.trxDateTime >= startDateTime &&
                            el.trxDateTime <= endDateTime
                    })
                }
            }
            else {
                if (!startDateTime && ! endDateTime) {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId
                    })
                }
                else if (startDateTime && !endDateTime) {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.trxDateTime >= startDateTime
                    })
                }
                else if (!startDateTime && endDateTime) {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.trxDateTime <= endDateTime
                    })
                }
                else {
                    rets = this.data.list.filter((el) => {
                        return el.networkId === networkId &&
                            el.plazaId === plazaId &&
                            el.trxDateTime >= startDateTime &&
                            el.trxDateTime <= endDateTime
                    })
                }
            }
        }
        return rets
    }
}

module.exports.QRCodeTransactionManager = exports.QRCodeTransactionManager = QRCodeTransactionManager;