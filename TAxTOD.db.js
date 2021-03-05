// required to manual set require path for nlib-mssql.
const SqlServer = require('./nlib/nlib-mssql');
const schema = require('./schema/TAxTOD.schema.json');

const TAxTOD = class extends SqlServer {
    constructor() {
        super();
        // should match with nlib.config.json
        this.database = 'default'
    }
    async connect() {
        return await super.connect(this.database);
    }
    async disconnect() {
        await super.disconnect();
    }

    async GetUserLaneAttendance(pObj) {
        let name = 'GetUserLaneAttendance';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TCTSaveLaneAttendance(pObj) {
        let name = 'TCTSaveLaneAttendance';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TAGetCouponList(pObj) {
        let name = 'TAGetCouponList';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_UpdateCreditLowLimit(pObj) {
        let name = 'TA_UpdateCreditLowLimit';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetTSBLowLimit(pObj) {
        let name = 'GetTSBLowLimit';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveTACoupon(pObj) {
        let name = 'SaveTACoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateflagTACouponReceive(pObj) {
        let name = 'UpdateflagTACouponReceive';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TAGetCouponList2(pObj) {
        let name = 'TAGetCouponList2';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUserCouponList(pObj) {
        let name = 'GetUserCouponList';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TCTSoldCoupon(pObj) {
        let name = 'TCTSoldCoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_InquirySellCoupon(pObj) {
        let name = 'TA_InquirySellCoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

}

module.exports = exports = TAxTOD;
