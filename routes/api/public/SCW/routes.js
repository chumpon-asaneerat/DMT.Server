//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

//const sqldb = require(path.join(nlib.paths.root, 'TAxTOD.db'));
//const dbutils = require(path.join(rootPath, 'dmt', 'utils', 'db-utils')).DbUtils;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

// static class.
const api = class { }

//#region Implement - GetJobList

api.GetUserCouponList = class {
    static entry(req, res) {
        let jsonFileName = path.join(rootPath, 'SCW', 'joblist.json')
        let joblist = require(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

router.all('/', api.GetUserCouponList.entry) // replace name

const init_routes = (svr) => {
    svr.route('/dmt-scw/api/tod/jobList', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;