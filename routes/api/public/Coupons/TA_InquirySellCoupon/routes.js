//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const sqldb = require(path.join(nlib.paths.root, 'TAxTOD.db'));
const dbutils = require(path.join(rootPath, 'dmt', 'utils', 'db-utils')).DbUtils;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

// static class.
const api = class { }

//#region Implement - TA_InquirySellCoupon

api.TA_InquirySellCoupon = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        
        if (params.SAPItemCode == '') 
        {
            params.SAPItemCode = null
        }
        if (params.ShiftId == 0) 
        {
            params.ShiftId = null
        }
        if (params.ItemStatusDigit == 0) 
        {
            params.ItemStatusDigit = null
        }

        

        console.log('Coupons search sapitemcode:', params.SAPItemCode)

        return params
    }
    static async call(db, params) { 
        return db.TA_InquirySellCoupon(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.TA_InquirySellCoupon
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result)
            });
        })
    }
}

//#endregion

router.all('/', api.TA_InquirySellCoupon.entry)

const init_routes = (svr) => {
    svr.route('/api/TA/coupons/inquiry', router);
};

module.exports.init_routes = exports.init_routes = init_routes;