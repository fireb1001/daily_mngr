// import { conn_pool } from '../main'
import { dexie } from '../main'
import { CustomerTransDB, CustomerTransDAO} from './CustomerTransDB'

export class CustomerDAO {

  id = 0
  name = ''
  date_created = ''
  last_outgoing_day
  last_outgoing_date
  debt 
  phone = ''
  address = ''
  notes = ''
  active = 1

  static get INIT_DAO() {
    return {
      active: 1
    }
  }

  parseTypes() {
    this.debt = parseFloat(this.debt)
  }

  constructor (data) {
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class CustomersDB {
  static TABLE_NAME = 'customers'
  
  /**@param {CustomerDAO} data */
  static async addNew(data) {
    delete data.id
    data.parseTypes()
    let id = await dexie[this.TABLE_NAME].add(data)
    if(data.debt) {
      let customerTransDao = new CustomerTransDAO()
      customerTransDao.customer_id = id
      customerTransDao.trans_type = 'init'
      customerTransDao.amount = data.debt
      customerTransDao.debt_after = data.debt
      CustomerTransDB.addNew(customerTransDao)
    }
  }

  static async saveById(id, payload) {
    let updated = await dexie[this.TABLE_NAME].update(id, payload)
    return updated
  }

  static async updateDebt(id, payload) {
    let customerDAO = await this.getDAOById(id)
    if(payload.amount && customerDAO.debt){
      customerDAO.parseTypes()
      customerDAO.debt += parseInt(payload.amount)
    }
    else {
      customerDAO.debt = parseFloat(payload.amount)
    }
    this.saveById(id, customerDAO)
  }

  static async getDAOById(id) {
    let obj = await dexie[this.TABLE_NAME].get(id)
    return new CustomerDAO(obj)
  }

  static async getAll(data) {
    let all = []
    if(data) {
      console.log(data)
      if(data.active === 1)
        all = await dexie[this.TABLE_NAME].where({active: 1}).toArray()
      if(data.last_outgoing_day)
        all = await dexie[this.TABLE_NAME].where({last_outgoing_day: data.last_outgoing_day}).toArray()
    }
    else {
      all = await dexie[this.TABLE_NAME].toArray()
    }
    return all
  }
}