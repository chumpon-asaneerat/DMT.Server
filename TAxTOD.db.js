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

    async Acc_getReqDetail(pObj) {
        let name = 'Acc_getReqDetail';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_getTSBBalance(pObj) {
        let name = 'Acc_getTSBBalance';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_getUserOnJobCredit(pObj) {
        let name = 'Acc_getUserOnJobCredit';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_SaveAppExchangeDetial(pObj) {
        let name = 'Acc_SaveAppExchangeDetial';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_SaveTSBCreditBalance(pObj) {
        let name = 'Acc_SaveTSBCreditBalance';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ESellingToTA(pObj) {
        let name = 'ESellingToTA';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetAR_Head(pObj) {
        let name = 'GetAR_Head';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetAR_Line(pObj) {
        let name = 'GetAR_Line';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetAR_Serial(pObj) {
        let name = 'GetAR_Serial';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetAR_SerialtoTACoupon(pObj) {
        let name = 'GetAR_SerialtoTACoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetSumTASell(pObj) {
        let name = 'GetSumTASell';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetSumTASellByRunNo(pObj) {
        let name = 'GetSumTASellByRunNo';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetTASell(pObj) {
        let name = 'GetTASell';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetTASellByRunNo(pObj) {
        let name = 'GetTASellByRunNo';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetTSBLowLimit(pObj) {
        let name = 'GetTSBLowLimit';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUserCouponList(pObj) {
        let name = 'GetUserCouponList';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUserLaneAttendance(pObj) {
        let name = 'GetUserLaneAttendance';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SAP_GetInquirySellCoupon(pObj) {
        let name = 'SAP_GetInquirySellCoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveTACoupon(pObj) {
        let name = 'SaveTACoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_GetAccAppReqDetail(pObj) {
        let name = 'TA_GetAccAppReqDetail';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_GetExchangeData(pObj) {
        let name = 'TA_GetExchangeData';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_getSAPCustomer(pObj) {
        let name = 'TA_getSAPCustomer';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_getTSBlist(pObj) {
        let name = 'TA_getTSBlist';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_GetUpdateReqData(pObj) {
        let name = 'TA_GetUpdateReqData';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_SaveExchangeTransaction(pObj) {
        let name = 'TA_SaveExchangeTransaction';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_SaveReqExchangeDetial(pObj) {
        let name = 'TA_SaveReqExchangeDetial';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_UpdateCreditLowLimit(pObj) {
        let name = 'TA_UpdateCreditLowLimit';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_UpdateSapFlagCoupon(pObj) {
        let name = 'TA_UpdateSapFlagCoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TAGetCouponList(pObj) {
        let name = 'TAGetCouponList';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TAGetCouponList2(pObj) {
        let name = 'TAGetCouponList2';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TCTSaveLaneAttendance(pObj) {
        let name = 'TCTSaveLaneAttendance';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TCTSoldCoupon(pObj) {
        let name = 'TCTSoldCoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateAR_Head(pObj) {
        let name = 'UpdateAR_Head';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateAR_Line(pObj) {
        let name = 'UpdateAR_Line';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateAR_Serial(pObj) {
        let name = 'UpdateAR_Serial';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateflagAR_Head(pObj) {
        let name = 'UpdateflagAR_Head';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateflagAR_Line(pObj) {
        let name = 'UpdateflagAR_Line';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateflagAR_Serial(pObj) {
        let name = 'UpdateflagAR_Serial';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async UpdateflagTACouponReceive(pObj) {
        let name = 'UpdateflagTACouponReceive';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_getSelltoInterface(pObj) {
        let name = 'TA_getSelltoInterface';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveAR(pObj) {
        let name = 'SaveAR';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_getReqDatabyStatus(pObj) {
        let name = 'Acc_getReqDatabyStatus';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_getTSBCreditAppList(pObj) {
        let name = 'Acc_getTSBCreditAppList';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_SaveCreditApproveTrans(pObj) {
        let name = 'Acc_SaveCreditApproveTrans';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_getTSBCreditAppTrans(pObj) {
        let name = 'Acc_getTSBCreditAppTrans';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TOD_SaveUserShift(pObj) {
        let name = 'TOD_SaveUserShift';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TOD_SaveRevenueEntry(pObj) {
        let name = 'TOD_SaveRevenueEntry';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TCTCheckTODBoj(pObj) {
        let name = 'TCTCheckTODBoj';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_SaveUserCreditOnJob(pObj) {
        let name = 'Acc_SaveUserCreditOnJob';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TOD_SaveTSBShift(pObj) {
        let name = 'TOD_SaveTSBShift';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async TA_InquirySellCoupon(pObj) {
        let name = 'TA_InquirySellCoupon';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Acc_SaveExchangeReceiveDetial(pObj) {
        let name = 'Acc_SaveExchangeReceiveDetial';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

}

module.exports = exports = TAxTOD;
