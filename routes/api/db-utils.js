const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

class DbUtils {
    static async exec(db, callback) {
        let ret;
        let connected = await db.connect();
        if (connected) {
            ret = await callback();
            await db.disconnect();
        }
        else {
            ret = db.error(db.errorNumbers.CONNECT_ERROR, 'No database connection.');
        }
        return ret;
    }
    static validate(db, data) {
        let result = data;
        if (!result) {
            result = db.error(db.errorNumbers.NO_DATA_ERROR, 'No data returns');
        }
        else {
            result = DbUtils.checkForError(data);
        }
        return result;
    }
    static checkForError(data) {
        let result = data;
        if (result.out && result.out.errNum && result.out.errNum !== 0) {
            result.errors.hasError = true;
            result.errors.errNum = result.out.errNum;
            result.errors.errMsg = result.out.errMsg;
        }
        return result;
    }
    static hasData (result) {
        return !result.errors.hasError && result.data && result.data.length > 0 && result.data[0];
    }
    static buildTree(result, idFld, mapFieldsCallback) {
        let ret = TreeResultBuilder.buildTree(result, idFld, mapFieldsCallback)
        return ret;
    }
    static buildTree2(result, idFld, idFld2, mapFieldsCallback) {
        let ret = TreeResultBuilder2.buildTree(result, idFld, idFld2, mapFieldsCallback)
        return ret;
    }
    static buildTreeSlides(result, idFld, idFld2, mapFieldsCallback) {
        let ret = TreeSlideBuilder.buildTree(result, idFld, idFld2, mapFieldsCallback)
        return ret;
    }
}
class TreeResultBuilder {
    static buildTree(result, idFld, mapFieldsCallback) {
        let ret = {}
        if (result && result.data) {
            let records = result.data
            TreeResultBuilder.processRecords(ret, records, idFld, mapFieldsCallback)
        }
        return ret;
    }
    static processRecords(ret, records, idFld, mapFieldsCallback) {
        records.forEach((record) => {
            if (!ret[record.langId]) {
                // no array for target language so create it.
                ret[record.langId] = []
            }
            let langObj = ret[record.langId]
            TreeResultBuilder.processRecord(langObj, record, idFld, mapFieldsCallback)
        })
}
    static processRecord(langObj, record, idFld, mapFieldsCallback) {
        let map = langObj.map(c => c[idFld])
        let idx = map.indexOf(record[idFld])
        let nobj
        if (idx === -1) {
            nobj = {} // create new object.
            nobj[idFld] = record[idFld] // set id
            langObj.push(nobj) // keep to array
        }
        else {
            nobj = langObj[idx]
        }
        if (mapFieldsCallback) mapFieldsCallback(nobj, record)
    }
}
class TreeResultBuilder2 {
    static buildTree(result, idFld, idFld2, mapFieldsCallback) {
        let ret = {}
        if (result && result.data) {
            let records = result.data
            TreeResultBuilder2.processRecords(ret, records, idFld, idFld2, mapFieldsCallback)
        }
        return ret;
    }
    static processRecords(ret, records, idFld, idFld2, mapFieldsCallback) {
        records.forEach((record) => {
            if (!ret[record.langId]) {
                // no array for target language so create it.
                ret[record.langId] = []
            }
            let langObj = ret[record.langId]
            TreeResultBuilder2.processRecord(langObj, record, idFld, idFld2, mapFieldsCallback)
        })
}
    static processRecord(langObj, record, idFld, idFld2, mapFieldsCallback) {
        let map = langObj.map(c => c[idFld])
        let idx = map.indexOf(record[idFld])
        let nobj
        if (idx === -1) {
            nobj = {} // create new object.
            nobj.items = []
            langObj.push(nobj) // keep to array
        }
        else {
            nobj = langObj[idx]
        }
        // process nest level 2
        TreeResultBuilder2.processRecord2(langObj, record, nobj, idFld, idFld2, mapFieldsCallback)
    }
    static processRecord2(langObj, record, nobj, idFld, idFld2, mapFieldsCallback) {
        let map2 = nobj.items.map(item => item[idFld2])
        let idx2 = map2.indexOf(record[idFld2])
        let nobj2;
        if (idx2 === -1) {
            nobj2 = {}
            nobj2[idFld2] = record[idFld2]
            nobj.items.push(nobj2)
        }
        else {
            nobj2 = nobj.items[idx2]
        }
        if (mapFieldsCallback) mapFieldsCallback(nobj2, record)
    }
}
class TreeSlideBuilder {
    static buildTree(result, idFld, idFld2, mapFieldsCallback) {
        let ret = {}
        if (result && result.data) {
            let records = result.data
            TreeSlideBuilder.processRecords(ret, records, idFld, idFld2, mapFieldsCallback)
        }
        return ret;
    }
    static processRecords(ret, records, idFld, idFld2, mapFieldsCallback) {
        records.forEach((record) => {
            if (!ret[record.langId]) {
                // no array for target language so create it.
                ret[record.langId] = []
            }
            let langObj = ret[record.langId]
            TreeSlideBuilder.processRecord(langObj, record, idFld, idFld2, mapFieldsCallback)
        })
}
    static processRecord(langObj, record, idFld, idFld2, mapFieldsCallback) {
        let map = langObj.map(c => c[idFld])
        let idx = map.indexOf(record[idFld])
        let nobj
        if (idx === -1) {
            nobj = {} // create new object.
            nobj[idFld] = record[idFld]
            nobj.slides = []
            langObj.push(nobj) // keep to array
        }
        else {
            nobj = langObj[idx]
        }
        // process nest level 2
        TreeSlideBuilder.processRecord2(langObj, record, nobj, idFld, idFld2, mapFieldsCallback)
    }
    static processRecord2(langObj, record, nobj, idFld, idFld2, mapFieldsCallback) {
        let map2 = nobj.slides.map(item => item[idFld2])
        let idx2 = map2.indexOf(record[idFld2])
        let nobj2;
        if (idx2 === -1) {
            nobj2 = {}
            nobj2[idFld2] = record[idFld2]
            nobj.slides.push(nobj2)
        }
        else {
            nobj2 = nobj.slides[idx2]
        }
        if (mapFieldsCallback) mapFieldsCallback(nobj2, record)
    }
}

module.exports.DbUtils = exports.DbUtils = DbUtils;
