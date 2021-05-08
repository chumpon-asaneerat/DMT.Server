const { tree } = require('gulp')
const SFtpClient = require('ssh2-sftp-client')
const fs = require('fs')
const path = require('path')
const { Console } = require('winston/lib/winston/transports')

console.log('test ftp client')

//let config1 = { host: '45.32.48.220', port: 22, username: 'dmtftp', password: 'uploaduser123' }
let config1 = { host: '45.32.48.220', port: 22, username: 'dmtftp2', password: 'uploaduser123' }
let config2 = { host: '192.168.1.37', port: 22, username: 'tester', password: 'password' }

/*
const doftp = async (config) => { 
    let client = new SFtpClient('DMT-SFTP-Server')
    let success = false
    try
    {
        await client.connect({
            host: config.host,
            port: config.port,
            //privateKey: fs.readFileSync('/path/to/ssh/key'),
            username: config.username,
            password: config.password
        })

        let cd = await client.cwd()
        console.log('current dir:', cd)

        let remptePath = '/couponexp';
        let localPath = 'D:\\samples\\';
        let files = await client.list(remptePath, '*.csv')
        files.forEach(async item => {
            console.log(`Type: ${item.type}, Name: ${item.name}, Size: ${item.size}`)
            let remoteFileName = remptePath + '/' + item.name
            let localFileName = path.join(localPath, item.name)
            console.log('  + remote file ' + remoteFileName)
            console.log('  + local file ' + localFileName)

            let dst = fs.createWriteStream(localFileName)

            client.get(remoteFileName, dst).then(data => {
                console.log(data)
            })
        })

        success = true
    }
    catch (err) {
        console.log(err.message)
    }
    finally {
        console.log('close connection.')
        await client.end()
    }
    return success
}

let isOK = false
doftp(config1).catch(e1 => {     
    isOK = false
    console.log('host1 operation failed.')
    doftp(config2).catch(e2 => {
        isOK = false
        console.log('host2 operation failed.')
    })
    console.log('end program')
})
*/

const doftp = (config) => { 
    let remptePath = '/couponexp';
    let client = new SFtpClient('DMT-SFTP-Server')
    client.connect({
        host: config.host,
        port: config.port,
        //privateKey: fs.readFileSync('/path/to/ssh/key'),
        username: config.username,
        password: config.password
    }).then(() => {
        return client.list(remptePath, '*.csv')
    }).then((files) => {
        let localPath = 'D:\\samples\\';
        let icnt = 0;
        let imax = files.length;
        files.forEach(item => {
            console.log(`Type: ${item.type}, Name: ${item.name}, Size: ${item.size}`)
            let remoteFileName = remptePath + '/' + item.name
            let localFileName = path.join(localPath, item.name)
            console.log('  + remote file ' + remoteFileName)
            console.log('  + local file ' + localFileName)

            let dst = fs.createWriteStream(localFileName)
            client.get(remoteFileName, dst).then(data => {
                //console.log(data)
                icnt++
                if (icnt >= imax) client.end()
            })
        })
    })
}

doftp(config2)