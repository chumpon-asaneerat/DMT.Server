//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment');

//#endregion

const jsonFileName = path.join(rootPath, 'SCW', 'joblist.json');

const LaneActivityManager = class { 
    constructor() {
        this.load()
    }    
    boj(networkId, plazaId, laneId, jobNo, staffId) {
        if (!this.data || !this.data.list) this.clear()
        let obj = {
            networkId: networkId,
            plazaId: plazaId,
            laneId: laneId,
            jobNo: jobNo,
            staffId: staffId,
            bojDateTime: moment(Date.now()).format('YYYY-MM-DDTHH:mm:ss.SSSZZ'),
            eojDateTime: null
        }
        this.data.list.push(obj) // append to array.
        this.save()
    }
    eoj(networkId, plazaId, laneId, jobNo, staffId) {
        if (!this.data || !this.data.list) this.clear()
        let list = this.filter(networkId, plazaId, laneId, jobNo, staffId)
        if (list && list.length > 0) {
            this.save()
        }
    }
    isMatch(el) {
        return el.networkId === networkId && 
            el.plazaId === plazaId && 
            el.laneId === laneId && 
            el.jobNo === jobNo && 
            el.staffId === staffId
    }
    filter() {
        let rets = []
        if (this.data && this.data.list) {
            rets = this.data.list.filter(isMatch)
        }
        return rets
    }
    clear() {
        this.data = {
            list: [],
            status : {
                code: "S200",
                message: "Success"
            }
        }
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
    get joblist() { 
        if (!this.data || !this.data.list) this.clear()
        return this.data.list
    }
}

module.exports.LaneActivityManager = exports.LaneActivityManager = LaneActivityManager;