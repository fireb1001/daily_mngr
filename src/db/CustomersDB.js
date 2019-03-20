// import { conn_pool } from '../main'
import { dexie, store } from '../main'
import { CustomerTransDB, CustomerTransDAO} from './CustomerTransDB'

export class CustomerDAO {

  id = 0
  name = ''
  date_created = ''
  curr_incoming_day
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
    // init with amount or zero
    data.debt = data.debt ? data.debt : 0
    data.parseTypes()
    let id = await dexie[this.TABLE_NAME].add(data)
    if(data.debt >=0 ) {
      let customerTransDao = new CustomerTransDAO()
      customerTransDao.customer_id = id
      customerTransDao.trans_type = 'init'
      customerTransDao.day = store.state.day.iso
      customerTransDao.amount = data.debt
      customerTransDao.debt_after = data.debt
      CustomerTransDB.addNew(customerTransDao)
    }
  }

  static async addCustomerTrans() { }

  static async saveById(id, payload) {
    let updated = await dexie[this.TABLE_NAME].update(id, payload)
    return updated
  }

  static async updateDebt(id, payload) {
    let customerDAO = await this.getDAOById(id)
    if( payload.amount ){
      customerDAO.parseTypes()
      // updating debt after
      if (! customerDAO.debt) customerDAO.debt = 0
      customerDAO.debt += parseFloat(payload.amount)

      if ( payload.constructor && payload.constructor.name == 'CashflowDAO'){
        let customerTransDao = new CustomerTransDAO(CustomerTransDAO.COLLECTING_DAO)
        customerTransDao.customer_id = id
        customerTransDao.cashflow_id = payload.id
        customerTransDao.amount = payload.amount
        customerTransDao.day = payload.day
        customerTransDao.debt_after = customerDAO.debt
        CustomerTransDB.addNew(customerTransDao)
      }
      else if( payload.trans_type === 'collecting') { 
        // payload.amount < 0 && payload.cashflow_id &&
        let customerTransDao = new CustomerTransDAO(CustomerTransDAO.COLLECTING_DAO)
        customerTransDao.customer_id = id
        customerTransDao.cashflow_id = payload.cashflow_id
        customerTransDao.amount = payload.amount
        customerTransDao.day = payload.day
        customerTransDao.debt_after = customerDAO.debt
        CustomerTransDB.addNew(customerTransDao)
      }
      else if( payload.trans_type === 'outgoing') { 
        let customerTransDao = new CustomerTransDAO()
        customerTransDao.customer_id = id
        customerTransDao.trans_type = payload.trans_type
        customerTransDao.outgoing_id = payload.outgoing_id
        customerTransDao.amount = payload.amount
        customerTransDao.day = payload.day
        customerTransDao.debt_after = customerDAO.debt
        CustomerTransDB.addNew(customerTransDao)
      }
    }
    if (payload.curr_incoming_day) {
      customerDAO.curr_incoming_day = payload.curr_incoming_day
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
      if (Array.isArray(data))
        all = await dexie[this.TABLE_NAME].where('id').anyOf(data).toArray()
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