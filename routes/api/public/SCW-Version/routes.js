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

//#region Implement - version

api.Version = class {
    static entry(req, res) {
        res.send('version : 1.0.7 (2021-09-14)')
    }
}

//#endregion

router.get('/v1/version', api.Version.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;