const path = require('path');
const fs = require('fs');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const moment = require('moment');
const fetch = require('node-fetch')
const https = require('https')

const httpsAgent = new https.Agent({
    rejectUnauthorized: false,
})

const SendToSAP = async (url, pObj, callback) => {
    let cfg = nlib.Config;
    var auth = cfg.get('webserver.basicAuth')
    let username = auth.user
    let pwd = auth.password
    let sAuth = Buffer.from(username + ":" + pwd).toString('base64')
    let request = async () => {
        try {
            const response = await fetch(url, { 
                method: 'POST',
                body: JSON.stringify(pObj),
                agent: httpsAgent,
                headers: {
                    'Content-Type': 'application/json',
                    'SAP-Client': 300,
                    'Authorization': 'Basic ' + sAuth
                }
            })
            const data = await response.json()
            if (callback) callback(request, response, data)
        }
        catch (err) {
            console.error(err)
            if (callback) callback(request, null, null, err)
        }    
    }

    request()
}

// Recursive function to get files
function getJsonFiles(dir) {
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
        let ext = path.extname(name)
        if (ext == '.json') {
            // If it is a file, push the full path to the files array
            files.push(name);
        }
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
        this.Url = ''
    }

    //#endregion

    //#region Public Methods

    processJson(fileName) {
        let fname = path.basename(fileName)
        let sourceFile = path.join(this._path, fname)

        console.log('process file: ' + sourceFile)
        let pObj = nlib.JSONFile.load(sourceFile)
        if (pObj) {
            SendToSAP(this.Url).then((req, res, data, err) => {
                if (err) {
                    this.moveToError(sourceFile)
                }
                else {
                    this.moveToBackup(sourceFile)
                }
            })
        }
    } 
    writeFile(pObj, objName, fileNameOnly) {
        if (!fileNameOnly) {
            fileNameOnly = 'msg.' + moment().format('YYYY.MM.DD.HH.mm.ss.SSSS')
        }
        let sName = (objName) ? objName.toString().toLowerCase().trim() : ''
        if (sName.length > 0) {
            fileNameOnly = fileNameOnly + '.' + objName.toString().toLowerCase()
        }
        fileNameOnly = fileNameOnly + '.json'
        let fileName = path.join(this._path, fileNameOnly)
        nlib.JSONFile.save(fileName, pObj)
    }
    moveToBackup(fileName) {
        let backupPath = path.join(this._path, 'backup')
        let fname = path.basename(fileName)
        let sourceFile = path.join(this._path, fname)
        let targetFile = path.join(backupPath, fname)
        moveFile(sourceFile, targetFile)
    }
    moveToError(fileName) {
        let errorPath = path.join(this._path, 'error')
        let fname = path.basename(fileName)
        let sourceFile = path.join(this._path, fname)
        let targetFile = path.join(errorPath, fname)
        moveFile(sourceFile, targetFile)
    }

    processFiles() {
        if (this._processing) 
            return
        let files = getJsonFiles(this._path)
        this._processing = true
        if (files) {
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