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
    let header = params
    // save to db
    let db = new sqldb()
    await db.connect()
    const hdrResult = await db.SaveCouponReservationHead(header)
    let result = dbutils.validate(db, hdrResult)
    let items = header.items
    if (items) {
        for await (let item of items) {
            let pObj = {
                itemnumber: item.itemnumber,
                materialnum: item.materialnum,
                quantity: item.quantity,
                unit: item.unit,
                plant: item.plant,
                goodsrecipient: header.goodsrecipient // save as header
            }
            let itemResult = await db.SaveCouponReservationItem(pObj)
        }
    }
    await db.disconnect()

    return result
}

const saveReservation = (req, res, next) => {
    let sDateTime = moment().format('YYYY.MM.DD.HH.mm.ss.SSSS')
    let req_fname = 'msg.' + sDateTime + '.req.reservation.json'
    let res_fname = 'msg.' + sDateTime + '.res.reservation.json'
    
    let req_filename = path.join(rootPath, 'jsonfiles', 'TAReservation', req_fname)
    let res_filename = path.join(rootPath, 'jsonfiles', 'TAReservation', res_fname)

    let params = WebServer.parseReq(req).data
    jsonFile.save(req_filename, params) // save to file

    Process(params).then(output => {
        jsonFile.save(res_filename, output) // save to file
        res.json(output)
    })
}

router.post('/reservation/save', saveReservation)

const init_routes = (svr) => {
    svr.route('/api/secure', router); // set route name
}

module.exports.init_routes = exports.init_routes = init_routes;