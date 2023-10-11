const path = require('path');
const fs = require('fs');
const rootPath = process.env['ROOT_PATHS'];

// Recursive function to get files
const getJsonFiles = (dir, files = []) => {
    if (!fs.existsSync(dir))
        return files
    // Get an array of all files and directories in the passed directory using fs.readdirSync
    const fileList = fs.readdirSync(dir);
    // Create the full path of the file/directory by concatenating the passed directory and file/directory name
    for (const file of fileList) {
        if (path.extname(file).toLowerCase() === '.json') {
            const name = `${dir}/${file}`
            // Check if the current file/directory is a directory using fs.statSync
            if (!fs.statSync(name).isDirectory()) {
                // If it is a file, push the full path to the files array
                files.push(name)
            }
        } 
    }
    return files
  }

const NJsonFileUtils = class {
    removeFiles(pathName,  top = 5) {
        let dir = path.join(rootPath, pathName)
        let files = []
        getJsonFiles(dir, files)
        console.log(files.length)
    }
}

let fileutil = new NJsonFileUtils();

module.exports = exports = fileutil;