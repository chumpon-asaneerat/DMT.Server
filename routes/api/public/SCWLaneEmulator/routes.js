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

//#region Implement - BOJ (Lane)

api.BOJ = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data

        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - EOJ (Lane)

api.EOJ = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data

        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

//#region Implement - Clear Job

api.EOJ = class {
    static entry(req, res) {
        let obj = WebServer.parseReq(req).data
        
        let joblist = nlib.JSONFile.load(jsonFileName)
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

router.post('/boj', api.BOJ.entry)
router.post('/eoj', api.EOJ.entry)
router.post('/cls', api.ClearJob.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api/emu', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;
