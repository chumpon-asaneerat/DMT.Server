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

//#region Implement - Acc_SaveCreditApproveTrans

api.Acc_SaveCreditApproveTrans = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        return params
    }
    static async call(db, params) { 
        return db.Acc_SaveCreditApproveTrans(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.Acc_SaveCreditApproveTrans
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

router.all('/', api.Acc_SaveCreditApproveTrans.entry)

const init_routes = (svr) => {
    svr.route('/api/account/appcredit/savetrans', router);
};

module.exports.init_routes = exports.init_routes = init_routes;