const SFtpClient = require('ssh2-sftp-client')

/*
let commonOpts {
  host: 'localhost', // string Hostname or IP of server.
  port: 22, // Port number of the server.
  forceIPv4: false, // boolean (optional) Only connect via IPv4 address
  forceIPv6: false, // boolean (optional) Only connect via IPv6 address
  username: 'donald', // string Username for authentication.
  password: 'borsch', // string Password for password-based user authentication
  agent: process.env.SSH_AGENT, // string - Path to ssh-agent's UNIX socket
  privateKey: fs.readFileSync('/path/to/key'), // Buffer or string that contains
  passphrase: 'a pass phrase', // string - For an encrypted private key
  readyTimeout: 20000, // integer How long (in ms) to wait for the SSH handshake
  strictVendor: true // boolean - Performs a strict server vendor check
  debug: myDebug // function - Set this to a function that receives a single
                // string argument to get detailed (local) debug information.
  retries: 2 // integer. Number of times to retry connecting
  retry_factor: 2 // integer. Time factor used to calculate time between retries
  retry_minTimeout: 2000 // integer. Minimum timeout between attempts
}
*/
let config = {
    host: '45.32.48.220',
    port: 22,
    username: 'dmtftp',
    password: 'uploaduser123'
}

const sftp = new SFtpClient('DMT-SFTP-Server')

sftp.connect(config)
    .then(() => {
        return sftp.cwd()
    })
    .then(p => {
        console.log(`Remote working directory is ${p}`)
        return sftp.list(p)
    })
    .then(data => {
        console.log(data)
    })
    .then(() => {
        console.log('disconnected.')
        return sftp.end()
    })
    .catch(err => {
        // error message will include 'DMT-SFTP-Server'
        console.log(`Error: ${err.message}`)
    })