// import { conn_pool } from '../main'
import { conn_pool, payloader } from '../main'

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
  }
}

//////////////////////// DB ///////////////////////////////
 
export class SuppliersDB {
  static TABLE_NAME = 'suppliers'

  /**@param {SupplierDAO} data */
  static async addNew(data) {
    let instert_q = ` INSERT INTO ${this.TABLE_NAME} 
    (name, phone, address, notes, active) 
    VALUES ('${data.name}','${data.phone}','${data.address}','${data.notes}', ${data.active} )`
    // console.log(instert_q)
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }

  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new SupplierDAO())
    let update_q = ` UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
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

  static async getDAOById(id) {
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    return new SupplierDAO(row[0])
  }

  static async getAll(data) {
    let all = []
    let results = []
    if(data) {
      if (Array.isArray(data)){
        // TODO change
        // all = await dexie[this.TABLE_NAME].where('id').anyOf(data).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id IN ( ${data.join(',')} )`)
      }
      if(data.active === 1) {
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where active = 1`)
      }
    }
    else {
      results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME}`)
    }
    results.forEach( item => {
      console.log(item)
      all.push(new SupplierDAO(item))
    })
    return all
  }
}