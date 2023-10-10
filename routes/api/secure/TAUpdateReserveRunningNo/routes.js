//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const jsonFile = nlib.JSONFile

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

const sqldb = require(path.join(nlib.paths.root, 'TAxTOD.db'));
const dbutils = require(path.join(rootPath, 'dmt', 'utils', 'db-utils')).DbUtils;

//#endregion

const moment = require('moment')

const Process = async (params) => {
    let rets = []
    // save to db
    let db = new sqldb()
    await db.connect()
    let dbResult = await db.TA_UpdateRunningNo(params)
    if (dbResult && dbResult.data) {
        rets = dbResult.data
    }
    await db.disconnect()

    // update result
    let result = nlib.NResult.data(rets)
    return result
}

const updateTAreservationRunningNo = (req, res, next) => {
    let params = WebServer.parseReq(req).data
    Process(params).then(output => {
        res.json(output)
    })
}

router.post('/reservation/runningno/save', updateTAreservationRunningNo)

const init_routes = (svr) => {
    svr.route('/api/secure', router); // set route name
}

module.exports.init_routes = exports.init_routes = init_routes;