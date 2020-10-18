const moment = require('moment')

// The moment custom date formats.
const dateFormats = [
    'YYYY-MM-DD HH.mm.ss.SSSZ',
    'YYYY/MM/DD HH.mm.ss.SSSZ',
    'YYYY-MM-DD HH:mm:ss.SSSZ',
    'YYYY/MM/DD HH:mm:ss.SSSZ',
    'YYYY-MM-DD HH.mm.ss.SSS',
    'YYYY/MM/DD HH.mm.ss.SSS',
    'YYYY-MM-DD HH:mm:ss.SSS',
    'YYYY/MM/DD HH:mm:ss.SSS'
]

const formatDateTime = (value) => {
    let ret = null;
    try {
        let dt = moment(value, dateFormats, true).local();
        //ret = (dt.isValid()) ? new Date(dt.utc()) : null;
        let isValid = dt.isValid();
        ret = (isValid) ? dt.toDate() : null;
        // fixed timezone offset (need to check if has problem)
        if (null !== ret) {
            ret = new Date(ret.getTime() - (ret.getTimezoneOffset() * 60 * 1000))
        }
        else {
            ret = new Date(value);
        }
        //console.log('OTHER DATE (try to used moment.js):', ret);
    }
    catch (ex) {
        console.log(ex);
        console.log('OTHER DATE (try to used moment.js): failed.');
    }

    return ret;
}

//let value = '2020-10-09'; // OK
let value = '2020-10-09T07:00:00.511Z'; // OK due to Z is utc time.
//let value = '2020-10-15T20:00:02.000+07:00'; // OK

let mObj = moment(value, dateFormats)
//let mObj = moment(value)
//let mObj = moment(value, dateFormats, false).local();

console.log(mObj)

let isValid = mObj.isValid();
console.log(isValid)

let dt = mObj.toDate();
console.log(dt)

let time = dt.getTime()
let tz = dt.getTimezoneOffset() * 60 * 1000;
console.log(time)
console.log(tz)

let dt2 = new Date(time + tz)
console.log(dt2)

let dt3 = new Date(Date.parse(value))
console.log(dt3.toJSON())
