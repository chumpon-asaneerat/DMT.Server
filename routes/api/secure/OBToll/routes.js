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
    let headers = params.HEADER
    let db = new sqldb()
    await db.connect()
    let spParams = await CouponOBParams(headers)
    let output = await SaveOBCoupons(db, spParams)
    await db.disconnect()
    return output
}

const CouponOBParams = async (headers) => {
    let iSlipCnt = 0
    let iItemCnt = 0
    let results = []
    if (headers) {
        for (let header of headers) {
            if (header) {
                let items = header.ITEM
                for (let item of items) {
                    if (item) {
                        let pObj = {
                            postingdate: header.POSTING_DATE,
                            mat_slip: header.MAT_SLIP,
                            headertext: header.HEADER_TXT,
                            itemnumber: item.ITEM_NUMBER,
                            materialnum: item.MATERIAL_NUM,
                            quantity: item.QUANTITY,
                            unit: item.UNIT_OF_MEASURE,
                            plant: item.PLANT,
                            location: item.STORAGE_LOCATION,
                            goodsrecipient: item.GOODS_RECIPIENT,
                            matdescription: item.MATERIAL_DESCRIPTION,
                            books: []
                        }
                        // load serial numbers
                        let serials = item.ZSERIAL_NO
                        if (serials) {
                            for (let serial of serials) {
                                if (serial) {
                                    let book = {
                                        materialnum: item.MATERIAL_NUM,
                                        location: item.STORAGE_LOCATION,
                                        SerialNo: serial.SERIAL_NO,
                                        mat_slip: header.MAT_SLIP,
                                        matdescription: item.MATERIAL_DESCRIPTION
                                    }
                                    pObj.books.push(book)
                                }
                            }
                        }
                        results.push(pObj)
                        // increase item count
                        iItemCnt++
                    }
                }
                // increase slip count
                iSlipCnt++
            }
        }
    }
    console.log(`Total Process MAT_SLIPS: ${iSlipCnt}, TOTAL ITEMS: ${iItemCnt}`)

    return results
}
const SaveOBCoupons = async (db, spParams) => {
    const output = {
        Return: []
    }
    for await (const spParam of spParams) {
        // save to db
        const dbResult = await db.SaveCouponReservationHead(spParam)
        const dbResult2 = await db.SaveCouponReservationItem(spParam)

        if (spParam && spParam.books) {
            for await (const book of spParam.books) {
                const dbResult3 = await SaveReceivedCoupon(db, book)
                if (dbResult3) {

                }
            }
        }

        let slipId = spParam.mat_slip
        let map = output.Return.map(slip => slip['MAT_SLIP'])
        let idx = map.indexOf(slipId)

        let type = ''
        let msg = ''
        if (dbResult.out && dbResult.out.errNum)
        {
            type = (dbResult.out.errNum == 0) ? 'S' : 'E'
            
        }
        else {
            type = 'E'
        }
        if (dbResult.out && dbResult.out.errMsg) {
            msg = (dbResult.out.errNum == 0) ? 'Successfull' : dbResult.out.errMsg
        }
        else {
            msg = 'UNKNOWN ERROR!'
        }


        let ret;

        if (idx === -1) {
            ret = {
                MAT_SLIP: slipId,
                TYPE: type,
                MESSAGE: msg
            }
            output.Return.push(ret)
        }
        else {
            ret = output.Return[idx]
        }
    }
    return output
}
const SaveOBCouponItem = async (db, pObj) => {
    let ret = await db.SaveCouponReservationItem(pObj) 
    if (ret) {
        console.log(ret)
    }
    await db.disconnect()
    return ret
}
const SaveReceivedCoupon = async (db, pObj) => {
    let ret = await db.SaveReceivedCoupon(pObj) 
    if (ret) {
        console.log(ret)
    }
    return ret
}

const saveOBToll = (req, res, next) => {
    let sDateTime = moment().format('YYYY.MM.DD.HH.mm.ss.SSSS')
    let req_fname = 'msg.' + sDateTime + '.req.reservation.json'
    let res_fname = 'msg.' + sDateTime + '.res.reservation.json'
    
    let req_filename = path.join(rootPath, 'jsonfiles', 'OBToll', req_fname)
    let res_filename = path.join(rootPath, 'jsonfiles', 'OBToll', res_fname)

    let params = WebServer.parseReq(req).data
    jsonFile.save(req_filename, params) // save to file

    Process(params).then(output => {
        jsonFile.save(res_filename, output) // save to file
        res.json(output)
    })
}

router.post('/ob_toll/save', saveOBToll)

const init_routes = (svr) => {
    svr.route('/api/secure', router); // set route name
};

module.exports.init_routes = exports.init_routes = init_routes;
