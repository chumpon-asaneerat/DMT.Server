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
    remove(trxDateTime, approvalCode) {
        this.load()
        if (this.data && this.data.list) {
            // loop to find match job attributes.
            let i = this.data.list.length
            while (i--) {
                let el = this.data.list[i]
                if (el.trxDateTime === trxDateTime && 
                    el.approvalCode === approvalCode) {
                        this.data.list.splice(i, 1) // remove from list
                }
            }
            this.save()
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
            rets = this.data.list.filter((el) => {
                return el.networkId === networkId && 
                    el.plazaId === plazaId && 
                    el.staffId === staffId && 
                    el.trxDateTime >= startDateTime &&
                    el.trxDateTime <= endDateTime
            })
        }
        return rets
    }
}

module.exports.QRCodeTransactionManager = exports.QRCodeTransactionManager = QRCodeTransactionManager;