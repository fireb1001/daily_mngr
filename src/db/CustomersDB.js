// import { conn_pool } from '../main'
import { dexie } from '../main'

export class CustomerDAO {

  id = 0
  name = ''
  date_created = ''
  balance = 0
  phone = ''
  notes = ''
  active = 1

  static get INIT_DAO() {
    return {
      active: 1,
    }
  }

  parseTypes() {
    this.balance = parseFloat(this.balance)
  }

  constructor (data) {
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class CustomersDB {
  static TABLE_NAME = 'customers'

  static async addNew(data) {
    delete data.id
    dexie.customers.add(data)
  }

  static async saveById(id, payload) {
    let updated = await dexie.customers.update(id, payload)
    return updated
  }

  static async updateBalance(id, payload) {
    let customerDAO = await this.getDAOById(id)
    if(payload.amount && customerDAO.balance){
      customerDAO.parseTypes()
      customerDAO.balance += parseInt(payload.amount)
    }
    else {
      customerDAO.balance = parseFloat(payload.amount)
    }
    this.saveById(id, customerDAO)
  }

  static async getDAOById(id) {
    let obj = await dexie.customers.get(id)
    return new CustomerDAO(obj)
  }

  static async getAll() {
    let all = []
    all = await dexie.customers.toArray()
    return all
  }
}