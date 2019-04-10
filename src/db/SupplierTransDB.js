import { conn_pool, inserter, payloader } from '../main'

export class SupplierTransDAO {

  id = 0
  supplier_id = 0
  incoming_id = 0
  day = ''
  date_created
  d_product 
  cashflow_id
  amount = 0
  trans_type = ''
  sum = '+'
  balance_after = 0
  notes

  static get INIT_DAO() {
    return { }
  }

  static get PAYMENT_DAO() {
    return {
      trans_type: 'payment',
      sum: '-'
    }
  }

  static get COLLECT_DAO() {
    return {
      trans_type: 'supp_collect'
    }
  }

  static get NOLON_DAO() {
    return {
      trans_type: 'nolon',
      sum: '-'
    }
  }

  constructor(data) {
    Object.assign(this, data)
  }

  parseTypes () {
    this.amount = parseFloat(this.amount)
  }

}

//////////////////////// DB ///////////////////////////////
 
export class SupplierTransDB {

  static TABLE_NAME = 'supplier_trans'

  static async addNew(data) {
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new SupplierTransDAO())}`
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }


  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new SupplierTransDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }

  static async getDAOById(id) {
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    return new SupplierTransDAO(row[0])
  }

  /**@param {SupplierTransDAO} data */
  static async getAll(data) {
    let all = []
    let results = []

    if(data) {
      if(data.supplier_id) {
        // order by day
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where supplier_id=${data.supplier_id} `)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }

    results.forEach( item => { all.push(new SupplierTransDAO(item)) })
    return all
  }
}