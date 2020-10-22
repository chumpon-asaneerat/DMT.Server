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

//#region Implement - SaveTACoupon

api.SaveTACoupon = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        
        if (params.userid == '') 
        {
            params.userid = null
        }

        if (params.userreceivedate == '') 
        {
            params.userreceivedate = null
        }

        if (params.solddate == '') 
        {
            params.solddate = null
        }

        if (params.soldby == '') 
        {
            params.soldby = null
        }

        //console.log('TA Save coupon TSBId:', params.tsbid)

        return params;
    }
    static async call(db, params) { 
        return db.SaveTACoupon(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.SaveTACoupon
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

router.all('/', api.SaveTACoupon.entry)

const init_routes = (svr) => {
    svr.route('/api/users/coupons/save', router);

    //svr.route('/api/users/coupons/sold', router);

    //svr.route('/api/rto/coupons/sold', router);
    //svr.route('/api/rto/coupons/search', router);

    // Attendance login/logout (Used later for TOD)
    //svr.route('/api/rto/attendances/begin', router);
    //svr.route('/api/rto/attendances/end', router);
};

module.exports.init_routes = exports.init_routes = init_routes;

