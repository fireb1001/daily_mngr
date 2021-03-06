import { conn_pool, payloader } from '../main'
import { SupplierTransDAO, SupplierTransDB } from './SupplierTransDB';

export class SupplierDAO {

  id = 0
  name = ''
  date_created
  // curr_incoming_day
  // date_updated
  total_count = 0
  balance = 0
  address = ''
  notes = ''
  phone = ''
  active = 1

  static get INIT_DAO() {
    return {
      active: 1
    }
  }

  constructor(data) {
    Object.assign(this, data)
    if(data && data.active === '0') this.active = 0
  }

  parseTypes () {
    this.total_count = parseInt(this.total_count)
    this.balance = parseFloat(this.balance)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class SuppliersDB {
  static TABLE_NAME = 'suppliers'

  /**@param {SupplierDAO} data */
  static async addNew(data) {
    let instert_q = `INSERT INTO ${this.TABLE_NAME} 
    (name, phone, address, notes, active) 
    VALUES ('${data.name}','${data.phone}','${data.address}','${data.notes}', ${data.active} )`
    // console.log(instert_q)
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }

  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new SupplierDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
  }

  static async updateIncomings(id, payload) {
    let supplierDAO = await this.getDAOById(id)
    if(payload.count && supplierDAO.total_count){
      supplierDAO.parseTypes()
      supplierDAO.total_count += parseInt(payload.count)
    }
    else {
      supplierDAO.total_count = parseInt(payload.count)
    }
    // supplierDAO.curr_incoming_day = payload.curr_incoming_day
    //return await dexie[this.TABLE_NAME].update(id, supplierDAO)
    await this.saveById(id, {total_count: supplierDAO.total_count})
  }

  static async updateBalance(id, payload) {
    // CREATE Supplier Trans Row
    console.log("updateBalance payload", payload)    

    let supplierDAO = await this.getDAOById(id)
    if(payload.amount){
      let amount = parseFloat(payload.amount) // minus
      supplierDAO.parseTypes()
      supplierDAO.balance = supplierDAO.balance ? supplierDAO.balance + amount : amount
      
      let suppTransDAO = null
      
      if(payload.state && payload.state=== 'nolon'){
        // Not Working now --debrecated--
        suppTransDAO = new SupplierTransDAO(SupplierTransDAO.NOLON_DAO)
        suppTransDAO.cashflow_id = payload.id
        suppTransDAO.d_product = payload.d_product
      }
      else if (payload.trans_type && payload.trans_type == 'receipt_1') {
        suppTransDAO = new SupplierTransDAO(payload)
      }
      else { 
        // if trans_form or from details page
        if(payload.sum && payload.sum === '-') {
          suppTransDAO = new SupplierTransDAO(SupplierTransDAO.PAYMENT_DAO)
        }
        else if (payload.sum && payload.sum === '+' && payload.cashflow_id){
          suppTransDAO = new SupplierTransDAO(SupplierTransDAO.COLLECT_DAO)
        }
        else if (payload.sum && payload.sum === '--' && payload.cashflow_id){
          suppTransDAO = new SupplierTransDAO(SupplierTransDAO.PAYMENT_DAO)
        }
        else if (payload.sum && payload.sum === '-r' && payload.cashflow_id){
          suppTransDAO = new SupplierTransDAO(SupplierTransDAO.OUT_RECEIPT_DAO)
        }
      }

      suppTransDAO.amount = amount
      suppTransDAO.day = payload.day
      suppTransDAO.notes = payload.notes
      suppTransDAO.supplier_id = id
      suppTransDAO.balance_after = supplierDAO.balance
      
      await SupplierTransDB.addNew(suppTransDAO)
    }
    
    if(payload.sum && payload.sum != '-r')
      await this.saveById(id, {balance: supplierDAO.balance})
  }

  static async getDAOById(id) {
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    if (row[0])
      return new SupplierDAO(row[0])
    else
      return
  }

  static async getAll(data) {
    let all = []
    let results = []
    if(data) {
      // console.log(data)
      if (Array.isArray(data) && data.length ){
        // all = await dexie[this.TABLE_NAME].where('id').anyOf(data).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id IN ( ${data.join(',')} )`)
      }
      if(data.active) {
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where active = 1`)
      }
    }
    else {
      results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME}`)
    }

    results.forEach( item => { all.push(new SupplierDAO(item)) })
    return all
  }
}