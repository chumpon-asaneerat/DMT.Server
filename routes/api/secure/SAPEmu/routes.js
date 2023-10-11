//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const jsonFile = nlib.JSONFile

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

const moment = require('moment')
let counter = 0

const sendToSAPEmu = (req, res, next) => {
    /*
    let fname = 'sap.response.json'
    let filename = path.join(rootPath, 'jsonfiles', 'emu', fname)
    if (!jsonFile.exists(filename)) {
        let value = {
            "RETURN": [
                {
                    "TYPE": "E",
                    "MESSAGE": "No material found",
                    "GOODS_RECIPIENT": "TADD20230001",
                    "RESERVATION_NO" : ""
                },
                {
                    "TYPE": "S",
                    "MESSAGE": "Successfull",
                    "GOODS_RECIPIENT": "TADD20230002",
                    "RESERVATION_NO" : ""
                },
            ]
        }
        jsonFile.save(filename, value)
    }
    let obj = jsonFile.load(filename)
    res.send(obj)
    */

    let value = req.body
    let obj = {
        RETURN: {
            results: []
        }
}
    try {
        counter++
        if (counter > 100) counter = 0
        let type = 'S'
        let msg = 'Successfull'
        console.log(`counter ${counter}`)
        if (counter % 5 == 0) {
            type = 'E'
            msg = 'No material found'
            console.log(`error at: ${counter}`)
        }
        var item = {
            TYPE: type,
            MESSAGE: msg,
            GOODS_RECIPIENT: value.GOODS_RECIPIENT,
            RESERVATION_NO: ''
        }
        obj.RETURN.results.push(item)
    }
    catch (err) {
        console.error(err)
    }

    res.send(obj)
}

router.post('/emu/sap', sendToSAPEmu)

const init_routes = (svr) => {
    svr.route('/api/secure', router); // set route name
}

module.exports.init_routes = exports.init_routes = init_routes;