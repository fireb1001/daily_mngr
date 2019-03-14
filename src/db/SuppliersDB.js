// import { conn_pool } from '../main'
import { dexie } from '../main'

export class SupplierDAO {

  id = 0
  name = ''
  date_created = ''
  date_updated
  total_count = 0
  balance = 0
  notes = ''
  phone = ''
  active = 1

  static get INIT_DAO() {
    return {
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

  static async updateCounts(id, payload) {
    let supplierDAO = await this.getDAOById(id)
    if(payload.count && supplierDAO.total_count){
      supplierDAO.parseTypes()
      supplierDAO.total_count += parseInt(payload.count)
    }
    else {
      supplierDAO.total_count = parseInt(payload.count)
    }
      
    return await dexie.suppliers.update(id, supplierDAO)
  }

  static async getDAOById(id) {
    let supplierObj = await dexie.suppliers.get(id)
    return new SupplierDAO(supplierObj)
  }

  static async getAll() {
    let all = []
    all = await dexie.suppliers.toArray()
    return all
  }
}