//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

//const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));
//const secure = require(path.join(rootPath, 'edl', 'rater-secure')).RaterSecure;
//const RaterStorage = require(path.join(rootPath, 'edl', 'rater-secure')).RaterStorage;

//const dbutils = require(path.join(rootPath, 'edl', 'utils', 'db-utils')).DbUtils;
//const cookies = require(path.join(rootPath, 'edl', 'utils', 'cookie-utils')).CookieUtils;
//const urls = require(path.join(rootPath, 'edl', 'utils', 'url-utils')).UrlUtils;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//const fs = require('fs')
//const mkdirp = require('mkdirp')
//const sfs = require(path.join(rootPath, 'edl', 'server-fs'));

const low = require('lowdb')
const FileSync = require('lowdb/adapters/FileSync')
const adapter = new FileSync('db.json')
const db = low(adapter)

//#endregion

// static class.
const api = class {}

api.users = [
    { staffId: '17155', staffName: 'นาย สมบูรณ์ สบายดี', pwd: '1234', role: 'supervisor' },
    { staffId: '12522', staffName: 'นาย องอาจ สยามวารี', pwd: '1234', role: 'supervisor' },
    { staffId: '11082', staffName: 'นาย พัชรพล อล่างพานิช', pwd: '1234', role: 'supervisor' },
    { staffId: '17081', staffName: 'นาย ผจญ สุดศิริ', pwd: '1234', role: 'collector' },
    { staffId: '22503', staffName: 'นวย วิรชัย ขำหิรัญ', pwd: '1234', role: 'collector' },
    { staffId: '14566', staffName: 'นาย สมชาย ตุยเอียว', pwd: '1234', role: 'collector' },
    { staffId: '14566', staffName: 'นางสาว สุณิสา อีนูน', pwd: '1234', role: 'collector' },
    { staffId: '11045', staffName: 'นาย บุญส่ง บุญปลื้ม', pwd: '1234', role: 'collector' }
]
api.getusers = class {
    static all(req, res) {
        let data = api.users
        let ret = nlib.NResult.data(data);
        WebServer.sendJson(req, res, ret);
    }
    static byId(req, res) {
        let map = api.users.map((user) => user.staffId)
        let params = (req.method === 'GET') ? req.params : req.body
        let idx = map.indexOf(params['staffId'])
        let data = (idx !== -1) ? api.users[idx] : null
        let ret = (data) ? nlib.NResult.data(data) : nlib.NResult.error(-100, 'No data found.');
        WebServer.sendJson(req, res, ret);
    }
}

//#region users

//#endregion

router.get('/users', api.getusers.all)
router.get('/users/:staffId', api.getusers.byId)
router.post('/users', api.getusers.byId)

const init_routes = (svr) => {
    // init database
    // Set some defaults (required if your JSON file is empty)
    db.defaults({ users: [] })
        .write()

    // For performance, use .value() instead of .write() if you're only reading from db
    let users = db.get('users')
        //.find({ staffId: '14566' })
        .value()

    // Add a users
    if (!users || users.length <= 0) {
        api.users.forEach(user => {
            db.get('users')
            .push(user)
            .write()
        })
    }

    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;