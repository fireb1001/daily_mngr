// import { conn_pool } from '../main'
import { dexie } from '../main'

export class CustomerTransDAO {

  id
  customer_id
  outgoing_id
  cashflow_id
  amount
  trans_type = ''
  debt_after = 0

  constructor(data) {
    Object.assign(this, data)
  }

  parseTypes () {
    // this.total_count = parseInt(this.total_count)
  }
}

export class CustomerTransDB {

  static TABLE_NAME = 'customer_trans'

  static async saveById(id, payload) {
    return await dexie.customer_trans.update(id, payload)
  }

  static async addNew(data) {
    delete data.id
    return await dexie[this.TABLE_NAME].add(data)
  }

  static async getAll() {
    let all = []
    all = await dexie[this.TABLE_NAME].toArray()
    return all
  }
}