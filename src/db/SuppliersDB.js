// import { conn_pool } from '../main'
import { dexie } from '../main'

export class SupplierDAO {

  id = 0
  name = ''
  date_created
  curr_incoming_day
  date_updated
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
  }

  parseTypes () {
    this.total_count = parseInt(this.total_count)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class SuppliersDB {
  static TABLE_NAME = 'suppliers'

  static async addNew(data) {
    delete data.id
    dexie[this.TABLE_NAME].add(data)
  }

  static async saveById(id, payload) {
    return await dexie[this.TABLE_NAME].update(id, payload)
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
    supplierDAO.curr_incoming_day = payload.curr_incoming_day
    return await dexie[this.TABLE_NAME].update(id, supplierDAO)
  }

  static async getDAOById(id) {
    let supplierObj = await dexie[this.TABLE_NAME].get(id)
    return new SupplierDAO(supplierObj)
  }

  static async getAll(data) {
    let all = []
    if(data) {
      if(data.active === 1)
        all = await dexie[this.TABLE_NAME].where({active: 1}).toArray()

    }
    else {
      all = await dexie[this.TABLE_NAME].toArray()
    }
    return all
  }
}