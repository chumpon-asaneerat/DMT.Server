//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

//const sqldb = require(path.join(nlib.paths.root, 'TAxTOD.db'));
const LaneActivityManager = require(path.join(rootPath, 'dmt', 'scw', 'LaneActivityManager')).LaneActivityManager;
const laneMgr = new LaneActivityManager();

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
        WebServer.sendJson(req, res, joblist)
    }
}

//#endregion

router.post('/boj', api.BOJ.entry)
router.post('/eoj', api.EOJ.entry)
router.post('/removes', api.RemoveJobs.entry)
router.post('/cls', api.ClearJob.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api/emu', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;
