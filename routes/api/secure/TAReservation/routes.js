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
    let fname = 'msg.' + moment().format('YYYY.MM.DD.HH.mm.ss.SSSS') + '.requst.reservation.json'
    let filename = path.join(rootPath, 'jsonfiles', 'requst.reservation', fname)

    let params = WebServer.parseReq(req).data
    jsonFile.save(filename, params)

    // save
    Process(params).then(output => {
        res.json(output)
    })
}

router.post('/reservation/save', saveReservation)

const init_routes = (svr) => {
    svr.route('/api/secure', router); // set route name
}

module.exports.init_routes = exports.init_routes = init_routes;