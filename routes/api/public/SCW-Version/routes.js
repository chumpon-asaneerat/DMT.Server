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

//#region Implement - version

api.Version = class {
    static entry(req, res) {
        if (testMode) {
            // for test long operation
            let timeout = 1000 * 5
            
            // example 1
            // (async () => { 
            //     await sleep(timeout) 
            //     res.send('version : 1.0.7 (2021-09-14)')
            // })()

            // example 2
            sleep(timeout).then(() => {
                res.send('version : 1.0.7 (2021-09-14)') 
            })
        }
        else {
            // original emulator code
            res.send('version : 1.0.7 (2021-09-14)')
        }
    }
}

//#endregion

router.get('/v1/version', api.Version.entry)

const init_routes = (svr) => {
    svr.route('/dmt-scw/api', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;