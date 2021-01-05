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

//#region Implement - cardAllowList

api.GetCarcAllowList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'cardAllowList.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - couponList

api.GetCouponList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'couponList.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - couponBookList

api.GetCouponBookList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'couponBookList.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - currencyDenomList

api.GetCurrencyDenomList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'currencyList.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - LoginAudit

api.LoginAudit = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data

        let jsonFileName = path.join(rootPath, 'SCW', 'loginAudit.json')
        nlib.JSONFile.save(jsonFileName, obj)

        WebServer.sendJson(req, res, {
                status: {
                    code: 'S200',
                    message: 'Success'
                }
            })
    }
}

//#endregion

//#region Implement - SaveCheifDuty

api.SaveCheifDuty = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data

        let jsonFileName = path.join(rootPath, 'SCW', 'saveCheifDuty.json')
        nlib.JSONFile.save(jsonFileName, obj)

        WebServer.sendJson(req, res, {
                status: {
                    code: 'S200',
                    message: 'Success'
                }
            })
    }
}

//#endregion

//#region Implement - GetCheifOnDuty

api.GetCheifOnDuty = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let jsonFileName = path.join(rootPath, 'SCW', 'saveCheifDuty.json')
        let data = nlib.JSONFile.load(jsonFileName)
        let ret = {
            networkId: obj.networkId,
            plazaId: obj.plazaId,
            staffId: null,
            staffNameTh: null,
            staffNameEn: null,
            staffTypeId: obj.staffTypeId,
            beginDateTime: null,
            status: {
                code: 'S200',
                message: 'Success'
            }
        }
        if (null !== data) {
            ret.staffId = data.staffId,
            ret.staffNameTh = 'Sim User',
            ret.staffNameEn = 'Sim User',
            ret.beginDateTime = data.beginDateTime
        }

        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - SaveCheifDuty

api.ChangePassword = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data

        let jsonFileName = path.join(rootPath, 'SCW', 'changePassword.json')
        nlib.JSONFile.save(jsonFileName, obj)

        WebServer.sendJson(req, res, {
                status: {
                    code: 'S200',
                    message: 'Success'
                }
            })
    }
}

//#endregion

//#region Implement - passwordExpiresDays

api.PasswordExpiresDays = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'passwordExpiresDays.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - GetJobList

api.GetUserJobList = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let jobs = laneMgr.getStaffJobs(obj.networkId, obj.plazaId, obj.staffId)
        let ret = { 
            list: jobs,
            status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - emvTransactionList

api.GetEMVTransactionList = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let emvs = emvMgr.getEMVTrans(obj.networkId, obj.plazaId, obj.staffId, 
            obj.startDateTime, obj.endDateTime)
        let results = []
        if (emvs && emvs.length > 0) {
            emvs.forEach(item => {
                results.push({
                    trxDateTime: item.trxDateTime,
                    amount: item.amount,
                    approvCode: item.approvCode,
                    refNo: item.refNo,
                    staffId: item.staffId,
                    staffNameTh: item.staffNameTh,
                    staffNameEn: item.staffNameEn,
                    laneId: item.laneId
                })
            }) 
        }
        let ret = { 
            list: results,
            status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - qrcodeTransactionList

api.GetQRCodeTransactionList = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let qrcodes = qrMgr.getQRCodeTrans(obj.networkId, obj.plazaId, obj.staffId, 
            obj.startDateTime, obj.endDateTime)
        let results = []            
        if (qrcodes && qrcodes.length > 0) {
            qrcodes.forEach(item => {
                results.push({
                    trxDateTime: item.trxDateTime,
                    amount: item.amount,
                    approvCode: item.approvCode,
                    refNo: item.refNo,
                    staffId: item.staffId,
                    staffNameTh: item.staffNameTh,
                    staffNameEn: item.staffNameEn,
                    laneId: item.laneId
                })
            }) 
        }
        let ret = { 
            list: results,
            status : {
            code: "S200",
            message: "Success"
        }}
        WebServer.sendJson(req, res, ret)
    }
}

//#endregion

//#region Implement - Declare

api.Declare = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        // extract job list        
        let jobs = (null != obj) ? obj.jobList : null
        let emvs = (null != obj) ? obj.emvList : null
        let qrs = (null != obj) ? obj.qrcodeList : null

        let jsonFileName = path.join(rootPath, 'SCW', 'declare.json')
        nlib.JSONFile.save(jsonFileName, obj)

        laneMgr.removeJobs(jobs) // remove job from list.
        emvMgr.removes(emvs) // remove emv from list.
        qrMgr.removes(qrs) // remove qrcode from list.

        WebServer.sendJson(req, res, {
                status: {
                    code: 'S200',
                    message: 'Success'
                }
            })
    }
}

//#endregion

// Master
router.post('/cardAllowList', api.GetCarcAllowList.entry)
router.post('/couponList', api.GetCouponList.entry)
router.post('/couponBookList', api.GetCouponBookList.entry)
router.post('/currencyDenomList', api.GetCurrencyDenomList.entry)
// Security
router.post('/loginAudit', api.LoginAudit.entry)
router.post('/saveCheifDuty', api.SaveCheifDuty.entry)
router.post('/cheifOnDuty', api.GetCheifOnDuty.entry)
router.post('/changePassword', api.ChangePassword.entry)
router.post('/passwordExpiresDays', api.PasswordExpiresDays.entry)
// TOD
router.post('/jobList', api.GetUserJobList.entry)
//router.post('/jobList2', api.GetUserJobList2.entry) // not implements.
router.post('/emvTransactionList', api.GetEMVTransactionList.entry)
router.post('/qrcodeTransactionList', api.GetQRCodeTransactionList.entry)
router.post('/declare', api.Declare.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api/tod', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;