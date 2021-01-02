//#region requires

const moment = require('moment');
const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

// static class.
const api = class { }

//#region Implement - IsAlive

api.IsAlive = class {
    static entry(req, res) {
        let obj = {
            timeStamp: new moment().format('YYYY-MM-DDTHH:mm:ss.SSSZZ')
        }
        let result = nlib.NResult.data(obj)
        WebServer.sendJson(req, res, result)
    }
}

//#endregion

router.post('/isalive', api.IsAlive.entry)

const init_routes = (svr) => {
    svr.route('/api/taa', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;