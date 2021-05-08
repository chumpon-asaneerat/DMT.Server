const { tree } = require('gulp')
const SFtpClient = require('ssh2-sftp-client')
const { Console } = require('winston/lib/winston/transports')

console.log('test ftp client')

let config1 = { host: '45.32.48.220', port: 22, username: 'dmtftp', password: 'uploaduser123' }
//let config1 = { host: '45.32.48.220', port: 22, username: 'dmtftp2', password: 'uploaduser123' }
let config2 = { host: '192.168.1.37', port: 22, username: 'tester', password: 'password' }

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
