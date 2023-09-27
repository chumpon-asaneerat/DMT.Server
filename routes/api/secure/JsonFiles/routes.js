//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

const moment = require('moment')

const saveJsonFile = (req, res, next) => {
    let fname = 'req.' + moment().format('YYYY.MM.DD.HH.mm.ss.SSSS') + '.json'
    let filename = path.join(rootPath, 'jsonfiles', 'req', fname)

    let obj = {
        value: 'file ' + fname + ' saved.'
    }
    res.send(obj)
}

router.post('/json/save', saveJsonFile)

const init_routes = (svr) => {
    svr.route('/api/secure', router); // set route name
}

module.exports.init_routes = exports.init_routes = init_routes;