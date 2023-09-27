const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment')

class JsonQueue {
    //#region  Constructor

    constructor(path) {
        this._path = path
    }

    //#endregion

    //#region Public Methods

    processJson() {

    } 

    writeFile(fileName, pObj) {

    }

    moveTo(fileName, subFolder) {

    }

    moveToBackup(fileName) {
        
    }

    moveToError(fileName) {
        
    }

    //#endregion

    //#region Public Properties

    get() { return this._path }
    set(path) { this._path = path }

    //#endregion
}

module.exports.JsonQueue = exports.JsonQueue = JsonQueue;