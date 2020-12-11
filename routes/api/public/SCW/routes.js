//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const LaneActivityManager = require(path.join(rootPath, 'dmt', 'scw', 'LaneActivityManager')).LaneActivityManager;
const laneMgr = new LaneActivityManager();

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

// static class.
const api = class { }

//#region Implement - currencyDenomList

api.GetCurrencyDenomList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'currencyList.json')
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

//#region Implement - cardAllowList

api.GetCarcAllowList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'cardAllowList.json')
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
        let jsonFileName = path.join(rootPath, 'SCW', 'emvTransactionList.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - qrcodeTransactionList

api.GetQRCodeTransactionList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'qrcodeTransactionList.json')
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - Declare

api.Declare = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        let jsonFileName = path.join(rootPath, 'SCW', 'declare.json')
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

router.post('/currencyDenomList', api.GetCurrencyDenomList.entry)
router.post('/couponList', api.GetCouponList.entry)
router.post('/cardAllowList', api.GetCarcAllowList.entry)
router.post('/jobList', api.GetUserJobList.entry)
router.post('/declare', api.Declare.entry)
router.post('/emvTransactionList', api.GetEMVTransactionList.entry)
router.post('/qrcodeTransactionList', api.GetQRCodeTransactionList.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api/tod', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;