const path = require('path');
const fs = require('fs');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment');
const { tree } = require('gulp');

// Recursive function to get files
function getFiles(dir) {
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
      if (!fs.statSync(name).isDirectory()) {
        // If it is a file, push the full path to the files array
        files.push(name);
      }
    }
    return files;
  }

  function moveFile(oldFile, newFile) {
    try {
        let newPath = path.dirname(newFile)
        if (!fs.existsSync(newPath)) {
            // create target path if not exists
            fs.mkdirSync(newPath, { recursive: true })
        }
        if (fs.existsSync(oldFile)) {
            fs.renameSync(oldFile, newFile)
        }
        else {
            console.log('file not found')
        }
    }
    catch (err) {
        console.log(err)
    }
}

class JsonQueue {
    //#region  Constructor

    constructor(queuePath) {
        this._path = path.join(rootPath, queuePath)
        this._processing = false
    }

    //#endregion

    //#region Public Methods

    processJson(fileName) {
        console.log('process file: ' + fileName)
        let backupPath = path.join(this._path, 'backup')
        //let errorPath = path.join(this._path, 'error')
        let fname = path.basename(fileName)
        let sourceFile = path.join(this._path, fname)
        let targetFile = path.join(backupPath, fname)
        moveFile(sourceFile, targetFile)
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
        if (this._processing) 
            return
        let files = getFiles(this._path)
        this._processing = true
        if (files && files.length > 0) {
            for (let file of files) {
                this.processJson(file)
            }
        }
        this._processing = false
    }

    //#endregion

    //#region Public Properties

    get() { return this._path }
    set(path) { this._path = path }

    //#endregion
}

module.exports.JsonQueue = exports.JsonQueue = JsonQueue;