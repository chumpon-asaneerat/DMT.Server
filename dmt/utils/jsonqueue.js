const path = require('path');
const fs = require('fs');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment')

// Recursive function to get files
function getFiles(dir, recursive = false) {
    let files = []
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true })
    }
    // Get an array of all files and directories in the passed directory using fs.readdirSync
    const fileList = fs.readdirSync(dir)
    // Create the full path of the file/directory by concatenating the passed directory and file/directory name
    for (const file of fileList) {
      const name = `${dir}/${file}`;
      // Check if the current file/directory is a directory using fs.statSync
      if (recursive && fs.statSync(name).isDirectory()) {
        // If it is a directory, recursively call the getFiles function with the directory path and the files array
        let childs = getFiles(name, files);
        files.push(...childs)
      } else {
        // If it is a file, push the full path to the files array
        files.push(name);
      }
    }
    return files;
  }

class JsonQueue {
    //#region  Constructor

    constructor(path) {
        this._path = path
        this._processing = false
    }

    //#endregion

    //#region Public Methods

    processJson(fileName) {
        console.log('process file: ' + fileName)
    } 

    writeFile(fileName, pObj) {

    }

    moveTo(fileName, subFolder) {

    }

    moveToBackup(fileName) {
        
    }

    moveToError(fileName) {
        
    }

    processFiles() {
        let files = getFiles(this._path, false)
        if (files && files.length > 0) {
            processJson()
        }
    }

    //#endregion

    //#region Public Properties

    get() { return this._path }
    set(path) { this._path = path }

    //#endregion
}

module.exports.JsonQueue = exports.JsonQueue = JsonQueue;