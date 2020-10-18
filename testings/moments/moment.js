const { json } = require('body-parser');
const moment = require('moment')

// The moment custom date formats.
const dateFormats = [
    // SQL Server Format Styles.
    'YYYY-MM-DD HH.mm.ss.SSS',
    'YYYY/MM/DD HH.mm.ss.SSS',
    'YYYY-MM-DD HH:mm:ss.SSS',
    'YYYY/MM/DD HH:mm:ss.SSS'
]

const formatDateTime = (value) => {
    let ret = null;
    try {
        if (null !== value) {
            // make sure convert parameter to string.
            let sVal = JSON.stringify(value);
            // create moment object (default assume its local time).
            let mObj = moment(sVal, dateFormats);
            let isValid = mObj.isValid();
            let dt = (isValid) ? mObj.toDate() : null;
            if (null !== dt) {
                let time = dt.getTime();
                let tz = dt.getTimezoneOffset() * 60 * 1000;
                ret = new Date(time - tz);
            }
            else {
                console.log('Invalid moment date fomat : ', value);
                ret = new Date(value);
            }
        }
    }
    catch (ex) {
        console.log('Error convert date : ', value);
        console.log(ex);
        ret = null;
    }
    return ret;
}

let value = null;
//let value = '2020-10-09'; // Json Date OK
//let value = '2020-10-09T07:00:00.511Z'; // Json Date OK due to Z is utc time.
//let value = '2020-10-15T20:00:02.342+07:00'; // Json Date OK
//let value = '2020/10/15 20:00:02.342'; // SQL Style OK

let dt = formatDateTime(value)
console.log((null != dt) ? dt.toJSON() : null);

//let mObj = moment(value, dateFormats)
//let mObj = moment(value)
//console.log('local datetime:', mObj)

//let isValid = mObj.isValid();
//console.log(isValid)

//let dt = mObj.toDate();
//console.log('local datetime: ', dt)

//let time = new Date(dt.toUTCString()).getTime()
//let tz = dt.getTimezoneOffset() * 60 * 1000;
//console.log(time)
//console.log(tz)

//let dt2 = new Date(time - tz)
//console.log(dt2)
//console.log(dt2.toJSON())

//let dt3 = new Date(Date.parse(value))
//console.log(dt3.toJSON())

//console.log(JSON.stringify(value))
//console.log(JSON.stringify(dt3))

