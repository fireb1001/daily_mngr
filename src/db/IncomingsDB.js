import { payloader, inserter, conn_pool, store } from '../main'
import { IncomingsHeaderDB, IncomingsHeaderDAO } from './IncomingsHeaderDB'
import { CashflowDB, CashflowDAO} from './CashflowDB'
import { SuppliersDB } from './SuppliersDB';

export class IncomingDAO {

  id = 0
  day
  date_created

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
      //date_created: Date.now() ,
      //nolon: 0,given: 0,
    }
  }

  constructor (data) {
    Object.assign(this, data)
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

export class IncomingsDB {

  static TABLE_NAME = 'incomings'

  static sql_types () {
    var instance = new IncomingDAO({})
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

  static async discard(id) {
    let incDAO = await this.getDAOById(id)
    console.log("incDAO", incDAO)
    let incHeaderDAO = await IncomingsHeaderDB.getDayHeader(incDAO)
    console.log("incHeaderDAO", incHeaderDAO)
    if(incDAO.count == incHeaderDAO.total_count && incHeaderDAO.total_count == incHeaderDAO.current_count) {
      await IncomingsHeaderDB.removeById(incHeaderDAO.id)
      await this.removeById(id)
      return true
    } 
    else {
      return false
    }
    
  }
  
  /**@param {IncomingDAO} data */
  static async addNew(data) {
    // console.log(data)
    data.selectFromObjects()
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new IncomingDAO())}`
    // let incoming_id = await dexie[this.TABLE_NAME].add(data)
    let ok = await conn_pool.query(instert_q)
    let incoming_id = ok.insertId
    let incHeadDAO = new IncomingsHeaderDAO(data)

    // update Incoming Header  let header_id = 
    await IncomingsHeaderDB.addPlus(incHeadDAO)

    // Update Cashflow
    if(data.nolon) {
      let cashDAO = new CashflowDAO()
      cashDAO.amount = data.nolon
      cashDAO.sum = '-'
      cashDAO.state = 'nolon'
      cashDAO.incoming_id = incoming_id
      cashDAO.state_data = {
        incoming_id: incoming_id,
        supplier_id: data.supplier_id,
        supplier_name: data.supplier_name
      }
      cashDAO.day = store.state.day.iso
      cashDAO.actor_id = data.supplier_id
      cashDAO.actor_name = data.supplier_name
      cashDAO.d_product = data.product_name
      await CashflowDB.addNew(cashDAO)

      // await SuppliersDB.updateBalance(data.supplier_id, cashDAO)
    }

    if(data.given) {
      let cashDAO = new CashflowDAO()
      cashDAO.amount = data.given
      cashDAO.day = store.state.day.iso
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
    await SuppliersDB.updateIncomings(data.supplier_id, {
      count: data.count,
      curr_incoming_day : store.state.day.iso
    })

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

  static async getDAOById(id) {
    // return await dexie[this.TABLE_NAME].get(id)
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    return new IncomingDAO(row[0])
  }

  static async saveById(id, payload) {
    let sets = payloader(payload, new IncomingDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }

  static async removeById(id) {
    let update_q = `DELETE FROM  ${this.TABLE_NAME} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }


  static async getAll(data) {
    let all = []
    let results = []

    if(data) {
      if(data.day) {
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}'`)
        //all = await dexie[this.TABLE_NAME].where({day: data.day}).toArray()
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }

    results.forEach( item => { all.push(new IncomingDAO(item)) })
    return all
  }
}

