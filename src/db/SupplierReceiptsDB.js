/*
import { conn_pool, inserter, payloader } from '../main'

export class SupplierReceiptDAO {

  id = 0
  supplier_id = 0
  day = ''
  date_created
  amount = 0
  total_nolon = 0
  receipt_given = 0
  comm_rate

  static get INIT_DAO() {
    return { }
  }

  constructor(data) {
    Object.assign(this, data)
  }

  parseTypes () {
    this.amount = parseFloat(this.amount)
  }

}

//////////////////////// DB ///////////////////////////////
 
export class SupplierReceiptsDB {

  static TABLE_NAME = 'supplier_receipts'

  static async addNew(data) {
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new SupplierReceiptDAO())}`
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }


  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new SupplierReceiptDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }

  static async getDAOById(id) {
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    return new SupplierReceiptDAO(row[0])
  }

  static async getAll(data) {
    let all = []
    let results = []

    if(data) {
      if(data.supplier_id) {
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where supplier_id=${data.supplier_id}`)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }

    results.forEach( item => { all.push(new SupplierReceiptDAO(item)) })
    return all
  }
}
*/