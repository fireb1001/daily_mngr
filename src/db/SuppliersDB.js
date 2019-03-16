// import { conn_pool } from '../main'
import { dexie } from '../main'

export class SupplierDAO {

  id = 0
  name = ''
  date_created = ''
  last_incoming_date 
  last_incoming_day
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
    dexie.suppliers.add(data)
  }

  static async saveById(id, payload) {
    return await dexie.suppliers.update(id, payload)
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
    supplierDAO.last_incoming_date = payload.last_incoming_date
    supplierDAO.last_incoming_day = payload.last_incoming_day
    return await dexie.suppliers.update(id, supplierDAO)
  }

  static async getDAOById(id) {
    let supplierObj = await dexie.suppliers.get(id)
    return new SupplierDAO(supplierObj)
  }

  static async getAll(data) {
    let all = []
    if(data) {
      if(data.active === 1)
        all = await dexie.suppliers.where({active: 1}).toArray()
      if(data.last_incoming_day)
        all = await dexie.suppliers.where({last_incoming_day: data.last_incoming_day}).toArray()
    }
    else {
      all = await dexie.suppliers.toArray()
    }
    return all
  }
}