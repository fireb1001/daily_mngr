import { store, inserter, conn_pool, payloader } from '../main'
import { CustomerTransDB, CustomerTransDAO} from './CustomerTransDB'

export class CustomerDAO {

  id = 0
  name = ''
  date_created = ''
  debt 
  phone = ''
  address = ''
  notes = ''
  active = 1
  is_self = 0

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
    
    // init with amount or zero
    data.debt = data.debt ? data.debt : 0
    data.parseTypes()
    //let id = await dexie[this.TABLE_NAME].add(data)
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new CustomerDAO())}`
    let ok = await conn_pool.query(instert_q)
    
    if(data.debt >=0 ) {
      let customerTransDao = new CustomerTransDAO()
      customerTransDao.customer_id = ok.insertId
      customerTransDao.trans_type = 'init'
      customerTransDao.day = store.state.day.iso
      customerTransDao.amount = data.debt
      customerTransDao.debt_after = data.debt
      await CustomerTransDB.addNew(customerTransDao)
    }
    return ok.insertId
  }

  static async addCustomerTrans() { }

  static async saveById(id, payload) {
    //let updated = await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new CustomerDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return
  }

  static async discard( transDAO ) {

    let customerDAO = await this.getDAOById(transDAO.customer_id)
    customerDAO.parseTypes()
    let amount = parseFloat(transDAO.amount)

    if(transDAO.sum === '+') {
      customerDAO.debt = parseFloat(customerDAO.debt) - amount
    } else {
      customerDAO.debt = parseFloat(customerDAO.debt) + amount
    }

    await this.saveById(customerDAO.id , {debt: customerDAO.debt})
    await CustomerTransDB.removeById(transDAO.id)
  }

  static async updateDebt(id, payload) {
    console.log(payload)
    let customerDAO = await this.getDAOById(id)
    if( payload.amount ){
      customerDAO.parseTypes()
      let amount = parseFloat(payload.amount)
      let customerTransDao = new CustomerTransDAO(payload)
      // Collecting cashflow
      if( payload.state ) { 
        console.log(payload, "payload")
        // payload.amount < 0 && payload.cashflow_id &&
        customerTransDao.cashflow_id = payload.id
        customerTransDao.trans_type = payload.state
        // collecting
        if(payload.sum === '+')
          amount = - Math.abs(amount)
      }
      
      // updating debt after
      customerDAO.debt = customerDAO.debt ? customerDAO.debt : 0
      customerDAO.debt += parseFloat(amount)

      customerTransDao.amount = amount
      customerTransDao.customer_id = id

      customerTransDao.debt_after = customerDAO.debt
      await CustomerTransDB.addNew(customerTransDao)
    }

    await this.saveById(id, {debt: customerDAO.debt})
    return 
  }

  static async updateDebtOnly(id, amount) {

    let customerDAO = await this.getDAOById(id)
    customerDAO.parseTypes()
    // updating debt after
    if (! customerDAO.debt) {
      customerDAO.debt = 0
    }
    customerDAO.debt += parseFloat(amount)
    await this.saveById(id, {debt: customerDAO.debt})
    return 
  }

  static async getDAOById(id) {
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    console.log(row)
    if (row[0])
      return new CustomerDAO(row[0])
    else
      return
  }

  static async getAll(data) {
    let all = []
    let results = []
    if(data) {
      if (Array.isArray(data) && data.length ){
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id IN ( ${data.join(',')} )`)
      }
      if(data.active ) {
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where active = 1`)
      }
    }
    else {
      results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME}`)
    }

    results.forEach( item => { all.push(new CustomerDAO(item)) })
    return all
  }
}