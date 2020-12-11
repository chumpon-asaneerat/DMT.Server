//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment');
const { Console } = require('console');

//#endregion

const jsonFileName = path.join(rootPath, 'SCW', 'joblist.json');

const LaneActivityManager = class { 
    constructor() {
        this.load()
    }    
    boj(networkId, plazaId, laneId, jobNo, staffId) {
        this.load()
        if (!this.data || !this.data.list) this.clear()
        let list = this.getOpendJobs(networkId, plazaId, laneId, jobNo, staffId)
        let obj = {
            networkId: networkId,
            plazaId: plazaId,
            laneId: laneId,
            jobNo: jobNo,
            staffId: staffId,
            bojDateTime: moment(Date.now()).format('YYYY-MM-DDTHH:mm:ss.SSSZZ'),
            eojDateTime: null
        }
        // Check no open job on current landId
        if (list && list.length === 0) {
            console.log('no opened job on current lane. ADD NEW!!')
            this.data.list.push(obj) // append to array.
            this.save()
        }
        else {
            console.log('has opened job on current lane.')
        }
    }
    eoj(networkId, plazaId, laneId, jobNo, staffId) {
        this.load()
        if (!this.data || !this.data.list) this.clear()
        let list = this.getOpendJobs(networkId, plazaId, laneId, jobNo, staffId)
        if (list && list.length > 0) {
            console.log('has opened job count:', list.length)
            list[0].eojDateTime = moment(Date.now()).format('YYYY-MM-DDTHH:mm:ss.SSSZZ')
            this.save()
        }
    }
    removeJobs(jobs) {
        if (jobs && jobs.length > 0) {
            let networkId, plazaId, laneId, jobNo, staffId, bojDateTime
            if (this.data && this.data.list) {
                jobs.forEach(job => {
                    // extract each item data.
                    networkId = job.networkId
                    plazaId = job.plazaId
                    laneId = job.laneId
                    jobNo = job.jobNo
                    staffId = job.staffId
                    bojDateTime = job.bojDateTime
                    // remove one by one.
                    this.removeJob(networkId, plazaId, laneId, jobNo, staffId, bojDateTime)
                })
            }
        }
    }
    removeJob(networkId, plazaId, laneId, jobNo, staffId, bojDateTime) {
        this.load()
        if (this.data && this.data.list) {
            // loop to find match job attributes.
            let i = this.data.list.length
            while (i--) {
                let el = this.data.list[i]
                if (el.networkId === networkId && 
                    el.plazaId === plazaId && 
                    el.laneId === laneId && 
                    el.jobNo === jobNo && 
                    el.staffId === staffId &&
                    el.bojDateTime === bojDateTime) {
                        this.data.list.splice(i, 1) // remove from list
                }
            }
            this.save()
        }
    }
    getOpendJobs(networkId, plazaId, laneId, jobNo, staffId) {
        let rets = []
        this.load()
        if (this.data && this.data.list) {
            rets = this.data.list.filter((el) => {
                return el.networkId === networkId && 
                    el.plazaId === plazaId && 
                    el.laneId === laneId && 
                    el.jobNo === jobNo && 
                    el.staffId === staffId &&
                    el.eojDateTime === null
            })
        }
        return rets
    }
    getStaffJobs(networkId, plazaId, staffId) {
        let rets = []
        this.load()
        if (this.data && this.data.list) {
            rets = this.data.list.filter((el) => {
                return el.networkId === networkId && 
                    el.plazaId === plazaId && 
                    el.staffId === staffId
            })
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