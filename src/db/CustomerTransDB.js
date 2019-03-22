import { conn_pool, payloader ,inserter } from '../main'

export class CustomerTransDAO {

  id
  day
  customer_id
  outgoing_id
  cashflow_id
  amount
  trans_type = ''
  debt_after = 0

  constructor(data) {
    Object.assign(this, data)
  }

  static get COLLECTING_DAO() {
    return {
      trans_type: 'collecting'
    }
  }

  parseTypes () {
    this.amount = parseFloat(this.amount)
  }
}

export class CustomerTransDB {

  static TABLE_NAME = 'customer_trans'

  static async addNew(data) {
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new CustomerTransDAO())}`
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }

  static async saveById(id, payload) {
    //let updated = await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new CustomerTransDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return
  }

  static async getAll(data) {
    let all = []
    let results = []

    if(data) {
      if(data.customer_id) {
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where customer_id=${data.customer_id}`)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }

    results.forEach( item => { all.push(new CustomerTransDAO(item)) })
    return all
  }
}