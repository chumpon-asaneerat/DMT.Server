const moment = require('moment')

// The moment custom date formats.
const dateFormats = [
    // Json Object Format Styles.
    'YYYY-MM-DDTHH.mm.ss.SSSZ',
    'YYYY/MM/DDTHH.mm.ss.SSSZ',
    'YYYY-MM-DDTHH:mm:ss.SSSZ',
    'YYYY/MM/DDTHH:mm:ss.SSSZ',
    // SQL Server Format Styles.
    'YYYY-MM-DD HH.mm.ss.SSS',
    'YYYY/MM/DD HH.mm.ss.SSS',
    'YYYY-MM-DD HH:mm:ss.SSS',
    'YYYY/MM/DD HH:mm:ss.SSS'
]

const formatDateTime = (value) => {
    let ret = null;
    try {
        let mObj = moment(value, dateFormats);
        let isValid = mObj.isValid();
        let dt = (isValid) ? dt.toDate() : null;
        // fixed timezone offset (need to check if has problem)
        if (null !== dt) {
            let time = dt.getTime();
            let tz = dt.getTimezoneOffset() * 60 * 1000;
            ret = new Date(time + tz);
        }
        else {
            console.log('Invalid date fomat : ', value);
            ret = new Date(value);
        }
    }
    catch (ex) {
        console.log(ex);
    }

    return ret;
}

//let value = '2020-10-09'; // Json Date OK
let value = '2020-10-09T07:00:00.511Z'; // Json Date OK due to Z is utc time.
//let value = '2020-10-15T20:00:02.342+07:00'; // Json Date OK
//let value = '2020/10/15 20:00:02.342'; // SQL Style OK

//let mObj = moment(value, dateFormats)
let mObj = moment(value)
console.log('local datetime:', mObj)

let isValid = mObj.isValid();
console.log(isValid)

let dt = mObj.toDate();
console.log('local datetime: ', dt)

let time = new Date(dt.toUTCString()).getTime()
let tz = dt.getTimezoneOffset() * 60 * 1000;
console.log(time)
console.log(tz)

let dt2 = new Date(time - tz)
console.log(dt2)
console.log(dt2.toJSON())

let dt3 = new Date(Date.parse(value))
console.log(dt3.toJSON())
