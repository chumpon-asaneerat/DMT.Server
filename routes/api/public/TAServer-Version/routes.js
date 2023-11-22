//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

let sleep = ms => new Promise(resolve => setTimeout(resolve, ms))
// test mode flag. set to false when run in production mode.
let testMode = false

// static class.
const api = class { }

const sVersion = "TA Server v1.1.0 build 455 update 2023-11-22 23:50"

//#region Implement - GetTAServerVersion

api.GetTAServerVersion = class {
    static entry(req, res) {
        if (testMode) {
            // for test long operation
            let timeout = 1000 * 5
            
            // example 1
            // (async () => { 
            //     await sleep(timeout) 
            //     res.send(sVersion)
            // })()

            // example 2
            sleep(timeout).then(() => {
                res.send(sVersion) 
            })
        }
        else {
            // original emulator code
            res.send(sVersion)
        }
    }
}

//#endregion

router.get('/version', api.GetTAServerVersion.entry)

const init_routes = (svr) => {
    svr.route('/api/taa', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;