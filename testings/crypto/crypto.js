var crypto = require('crypto');
var name = '123456';
var hash = crypto.createHash('md5').update(name).digest('hex');
console.log(hash); // 9b74c9897bac770ffc029102a200c5de

/*

{
    "staffId": "00333",
    "password": "e10adc3949ba59abbe56e057f20f883e",
    "newPassword": "e10adc3949ba59abbe56e057f20f883e",
    "confirmNewPassword": "e10adc3949ba59abbe56e057f20f883e"
}

*/