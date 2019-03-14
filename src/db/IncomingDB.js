// import { conn_pool } from '../main'
import { dexie } from '../main'
import { IncomingsHeaderDB, IncomingsHeaderDAO } from './IncomingsHeaderDB'
import { CashflowDB, CashflowDAO} from './CashflowDB'
import { SuppliersDB } from './SuppliersDB';

// console.log(IncomingsHeaderDAO.EMPTY_FORM())

export class IncomingDAO {

  id = 0
  date = ''
  date_created = 0

  supplier_select = {}
  supplier_id = 0
  supplier_name = ''
  
  product_select = {}
  product_id = 0
  product_name = ''

  count // null
  nolon // null
  given // null
  notes = ''

  // Constant member
  static get INIT_DAO() {
    return {
      date_created: Date.now() ,
      //nolon: 0,given: 0,
    }
  }

  constructor (data) {
    Object.assign(this, data)
    /*
    this.id = data.id!== null ? data.id : this.id
    this.date = data.date!== null ? data.date : this.date
    this.supplier_id = data.supplier_id!== null ? data.supplier_id : this.supplier_id
    this.product_id = data.product_id!== null ? data.product_id : this.product_id
    this.count = data.count!== null ? data.count : this.count
    this.given = data.given!== null ? data.given : this.given
    this.nolon = data.nolon!== null ? data.nolon : this.nolon
    this.notes = data.notes!== null ? data.notes : this.notes
    */
  }

  parseTypes() {
    this.count = parseInt(this.count)
    this.nolon = this.nolon? parseFloat(this.nolon): 0
    this.given = this.given? parseFloat(this.given): 0
  }

  selectFromObjects() {
    this.supplier_id = this.supplier_select.id
    this.supplier_name = this.supplier_select.name
    this.product_id = this.product_select.id
    this.product_name = this.product_select.name
    
    delete this.supplier_select
    delete this.product_select
  }
}

export class IncomingDB {

  static TABLE_NAME = 'incoming'
  /*
  data = {
    id: 0,
    date: '',
    supplier_id: '',
    product_id: 0,
    count: 0,
    notes: ''
  }

  constructor (data) {
    this.data.id = data.id!== null ? data.id : this.data.id
    this.data.date = data.date!== null ? data.date : this.data.date
    this.data.supplier_id = data.supplier_id!== null ? data.supplier_id : this.data.supplier_id
    this.data.count = data.count!== null ? data.count : this.data.count
    this.data.product_id = data.product_id!== null ? data.product_id : this.data.product_id
    this.data.notes = data.notes!== null ? data.notes : this.data.notes
  }
  */

  static sql_types () {
    var instance = new this({})
    var keys = Object.keys(instance.data)
    var create_sql_cols = ''
    keys.forEach(col =>{
      if(col =='id')
        create_sql_cols += 'id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,'
      else if(instance.data[col] === 0)
        create_sql_cols += col+ ' INT ,'
      else 
        create_sql_cols += col+ ' VARCHAR(256),'
    })
    return create_sql_cols.replace(/,\s*$/, "")
  }

  static createTableQ () {
    return `CREATE TABLE ${this.TABLE_NAME} ( ${this.sql_types()}) ;`
  }
  
  /**@param {IncomingDAO} data */
  static async addNew(data) {
    // console.log(data)
    delete data.id
    data.selectFromObjects()
    data.parseTypes()

    let incoming_id = await dexie.incomings.add(data)
    data.day= data.date
    let incDAO = new IncomingsHeaderDAO(data)

    // update Incoming Header  let header_id = 
    await IncomingsHeaderDB.addPlus(incDAO)

    // Update Cashflow
    if(data.nolon) {
      let cashDAO = new CashflowDAO()
      cashDAO.amount = data.nolon
      cashDAO.sum = '-'
      cashDAO.state = 'nolon'
      cashDAO.state_data = {
        incoming_id: incoming_id,
        supplier_id: data.supplier_id,
        supplier_name: data.supplier_name
      }
      cashDAO.actor_id = data.supplier_id
      await CashflowDB.addNew(cashDAO)
    }

    if(data.given) {
      let cashDAO = new CashflowDAO()
      cashDAO.amount = data.given
      cashDAO.sum = '-'
      cashDAO.state = 'given'
      cashDAO.state_data = {
        incoming_id: incoming_id,
        supplier_id: data.supplier_id,
        supplier_name: data.supplier_name
      }
      cashDAO.actor_id = data.supplier_id
      cashDAO.actor_name = data.supplier_name
      await CashflowDB.addNew(cashDAO)
    }

    // Update Supplier Info
    await SuppliersDB.updateCounts(data.supplier_id, {count: data.count})

    /*
      let instert_q = 
` INSERT INTO ${this.TABLE_NAME} (date, supplier, count, product, notes) 
  VALUES ('${values.date}',${values.supplier},${values.count},${values.product},'${values.notes}')`

    try {
      await conn_pool.query(instert_q)
    } catch (error) {
      console.error("instert_q error", instert_q)
      console.error("SQL error", error)
      // this.incomings_arr.push(new this(values))
    }
    */

  }

  static async saveById(id, payload) {
    let updated = await dexie.incomings.update(id, payload)

    return updated
  }

  static async getAll() {
    let all = []
    all = await dexie.incomings.toArray()
    /*
    try {
      var results = await conn_pool.query('SELECT * FROM '+IncomingDB.TABLE_NAME)
      this.incomings_arr = []
      results.forEach( item => {
        all.push(new IncomingDAO(item))
      })
    } catch(err) {
        throw new Error(err)
    }
    */
    return all
  }
}

