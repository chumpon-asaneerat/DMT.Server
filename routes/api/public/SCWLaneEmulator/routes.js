//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const LaneActivityManager = require(path.join(rootPath, 'dmt', 'scw', 'LaneActivityManager')).LaneActivityManager;
const laneMgr = new LaneActivityManager();

const EMVTransactionManager = require(path.join(rootPath, 'dmt', 'scw', 'EMVTransactionManager')).EMVTransactionManager;
const emvMgr = new EMVTransactionManager();

const QRCodeTransactionManager = require(path.join(rootPath, 'dmt', 'scw', 'QRCodeTransactionManager')).QRCodeTransactionManager;
const qrMgr = new QRCodeTransactionManager();

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

// static class.
const api = class { }

//#region Implement - GetStaffs

api.GetAllJobs = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let list = laneMgr.getAllJobs(obj.networkId, obj.plazaId)
        let ret = { 
            list: list,
            status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - BOJ (Lane)

api.BOJ = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        laneMgr.boj(obj.networkId, obj.plazaId, obj.laneId, obj.jobNo, obj.staffId)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - EOJ (Lane)

api.EOJ = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        laneMgr.eoj(obj.networkId, obj.plazaId, obj.laneId, obj.jobNo, obj.staffId)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Remove Jobs

api.RemoveJobs = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let jobs = (null != obj) ? obj.jobs : null
        laneMgr.removeJobs(jobs)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Clear Job

api.ClearJob = class {
    static entry(req, res) {
        laneMgr.clear()
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Add EMV

api.AddEMV = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        emvMgr.add(obj.networkId, obj.plazaId, obj.laneId, 
            obj.staffId, obj.staffNameTh, obj.staffNameEn,
            obj.trxDateTime, obj.amount, obj.approvCode, obj.refNo)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Remove EMV

api.RemoveEMV = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        emvMgr.remove(obj.trxDateTime, obj.approvCode)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Clear EMV

api.ClearEMV = class {
    static entry(req, res) {
        emvMgr.clear()
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Add QRCode

api.AddQRCode = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        qrMgr.add(obj.networkId, obj.plazaId, obj.laneId, 
            obj.staffId, obj.staffNameTh, obj.staffNameEn,
            obj.trxDateTime, obj.amount, obj.approvCode, obj.refNo)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Remove QRCode

api.RemoveQRCode = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        qrMgr.remove(obj.trxDateTime, obj.approvCode)
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Clear QRCode

api.ClearQRCode = class {
    static entry(req, res) {
        qrMgr.clear()
        let ret = { status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

router.post('/boj', api.BOJ.entry)
router.post('/eoj', api.EOJ.entry)
router.post('/jobs', api.GetAllJobs.entry)
router.post('/removes', api.RemoveJobs.entry)
router.post('/cls', api.ClearJob.entry)

router.post('/emv/add', api.AddEMV.entry)
router.post('/emv/remove', api.RemoveEMV.entry)
router.post('/emv/cls', api.ClearEMV.entry)

router.post('/qrcode/add', api.AddQRCode.entry)
router.post('/qrcode/remove', api.RemoveQRCode.entry)
router.post('/qrcode/cls', api.ClearQRCode.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api/emu', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;
