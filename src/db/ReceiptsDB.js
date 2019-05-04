import { inserter, conn_pool, payloader } from '../main'
// eslint-disable-next-line no-unused-vars
import { OutgoingHeaderDAO } from './OutgoingsHeaderDB';
import { ReceiptDetailDAO, ReceiptsDetailsDB } from './ReceiptsDetailsDB';

export class ReceiptDAO {

    id = 0
    day
    supplier_id
    supplier_name
    total_nolon 
    recp_given
    comm_rate
    sale_value
    net_value
    recp_paid
    products_arr 
    total_current_rest
    total_count
    total_sell_comm
    recp_comm
    out_sale_value
    recp_expenses

  static get INIT_DAO() {
    return {
    }
  }

  parseTypes () {
    this.total_nolon = this.total_nolon? parseFloat(this.total_nolon) : 0
    this.recp_given = this.recp_given? parseFloat(this.recp_given) : null
    this.comm_rate = this.comm_rate? parseFloat(this.comm_rate) : null
    this.sale_value = this.sale_value? parseFloat(this.sale_value) : null
    this.net_value = this.net_value? parseFloat(this.net_value) : null
    this.recp_paid = this.recp_paid? parseInt(this.recp_paid) : 0
    this.recp_expenses = this.recp_expenses ? parseFloat(this.recp_expenses) : 0
  }
  /*
  calcVals() {
    this.parseTypes()
    this.net_value = this.sale_value - ( this.sale_value * ( this.comm_rate / 100 )) - this.recp_given - this.total_nolon
  }
  */
  constructor( data ){
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class ReceiptsDB {
  static TABLE_NAME = 'receipts'

  // TODO how to check if receipts is ok and well done !!
  /**@param {ReceiptDAO} data */
  static async addNew(data) {
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new ReceiptDAO())}`
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }

  static async saveById(id, payload) {
    let sets = payloader(payload, new ReceiptDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    console.log('update_q', update_q)
    await conn_pool.query(update_q)
    return 
  }

  static async initReceipt(data, payload) {
    console.log('payload', payload)
    let receipts = await this.getAll({day: data.day, supplier_id: data.supplier_id})
    let recpDAO = null

    if(receipts.length === 0){
      recpDAO = new ReceiptDAO(payload)

      let products_arr = []
      // let total_sell_comm = 0
      payload.incomings_headers_today.forEach(item =>{
        products_arr.push({
          product: item.product_name,
          total_count: item.total_count,
          rest: item.current_count}
        )
      })
      recpDAO.products_arr =  JSON.stringify(products_arr)
      delete recpDAO.incomings_headers_today
      delete recpDAO.outgoings_headers_today
      recpDAO.id = await this.addNew(recpDAO)
      //calc_receipt.total - inc_sums.c_total_inc_nolon -(calc_receipt.total * (receipt.comm_rate / 100)) - receipt.recp_given
      // Add receipt details
      
      /*
      payload.outgoings_headers_today.forEach(async item =>{
        let outDAO = item
        let recpDetailDAO = new ReceiptDetailDAO(outDAO)
        recpDetailDAO.receipt_id = recpDAO.id
        recpDetailDAO.weight = parseFloat(outDAO.total_weight)
        recpDetailDAO.count = outDAO.sold_count
        recpDetailDAO.calc_value = recpDetailDAO.weight * parseFloat(recpDetailDAO.kg_price)
        await ReceiptsDetailsDB.addNew(recpDetailDAO)
      })
      */
      for(const item of payload.outgoings_headers_today ) {
        // /** @type {OutgoingHeaderDAO} */
        let outDAO = item
        let recpDetailDAO = new ReceiptDetailDAO(outDAO)
        recpDetailDAO.receipt_id = recpDAO.id
        recpDetailDAO.weight = parseFloat(outDAO.total_weight)
        recpDetailDAO.count = outDAO.sold_count
        recpDetailDAO.calc_value = recpDetailDAO.weight * parseFloat(recpDetailDAO.kg_price)
        await ReceiptsDetailsDB.addNew(recpDetailDAO)
      }
      /*
      recpDAO.sale_value = payload.sale_value
      recpDAO.net_value = recpDAO.sale_value 
      - ( recpDAO.sale_value * ( recpDAO.comm_rate / 100 )) 
      - recpDAO.recp_given 
      - recpDAO.total_nolon
      */
    }
    else {
      recpDAO = new ReceiptDAO(receipts[0])
      // UPDATE with new data
      console.log(recpDAO.sale_value)
      if(payload.sale_value)
        recpDAO.sale_value = payload.sale_value

      recpDAO.out_sale_value = payload.out_sale_value
      recpDAO.total_nolon = payload.total_nolon
      recpDAO.recp_comm =  recpDAO.sale_value * ( recpDAO.comm_rate / 100 )
      recpDAO.net_value = recpDAO.sale_value 
      - recpDAO.recp_comm
      - recpDAO.recp_given 
      - recpDAO.total_nolon
      - recpDAO.recp_expenses

      recpDAO.total_current_rest = payload.total_current_rest
      recpDAO.total_count = payload.total_count
      let products_arr = []
      payload.incomings_headers_today.forEach(item =>{
        products_arr.push({
          product: item.product_name,
          total_count: item.total_count,
          rest: item.current_count}
        )
      })
      recpDAO.products_arr =  JSON.stringify(products_arr)
      
      await this.saveById(recpDAO.id, recpDAO)
    }

    return recpDAO
  }

  static async getAll(data) {
    // console.log(data.state, Array.isArray( data.state))
    let all = []
    let results = []

    if(data && data.day && data.supplier_id){
      let query = `SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id = ${data.supplier_id}`
      results = await conn_pool.query(query)
    }
    else if (data && data.day ) {
      let query = `SELECT * FROM ${this.TABLE_NAME} where day='${data.day}'`
      results = await conn_pool.query(query)
    }
    else if (data && data.supplier_id) {
      // only prev receipts
      let query = `SELECT * FROM ${this.TABLE_NAME} where supplier_id = ${data.supplier_id} and recp_paid > 0  order by day`
      console.log(query)
      results = await conn_pool.query(query)
    }
    else {
      // NONE
    }

    results.forEach( item => { all.push(new ReceiptDAO(item)) })
    return all
  }

  static async deleteAll(data) {
    // console.log(data.state, Array.isArray( data.state))
    if(data.day && data.supplier_id){
      let query = `DELETE FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id = ${data.supplier_id}`
       await conn_pool.query(query)
    }
  }

}