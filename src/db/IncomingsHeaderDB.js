import { conn_pool, inserter, payloader } from '../main'

export class IncomingsHeaderDAO {

  id = 0
  product_id = 0
  product_name
  supplier_id = 0
  supplier_name
  day = ''
  date_created
  total_count = 0
  current_count = 0
  notes = ''

  static get INIT_DAO() {
    return {
      id: 0
    }
  }

  static EMPTY_FORM () {
    return new this(this.INIT_DAO)
  }

  constructor(data) {
    // this.id = data.id !== null ? data.id : this.id
    Object.assign(this, data)
    if(data && data.count) {
        this.total_count = this.current_count = parseInt(data.count)
    }
  }

  parseTypes() {
    this.total_count = parseInt(this.total_count)
    this.current_count = parseInt(this.current_count)
  }

}

//////////////////////// DB ///////////////////////////////
 
export class IncomingsHeaderDB {

  static TABLE_NAME = 'incomings_header'

/** @param {IncomingsHeaderDAO} data */

  static async addPlus(data) {
    console.log("addPlus", data)
    let head = await this.getDayHeader(data)
    if ( ! head ) {
      let header_id = await this.addNew(data)
      return header_id
    } // else update
    else {
      head.total_count += parseInt(data.total_count)
      head.current_count += parseInt(data.total_count)
      await this.saveById(head.id, {total_count: head.total_count, current_count: head.current_count})
      return head.id
    }
  }

  /** @param {IncomingsHeaderDAO} data */
  static async addNew(data) {
    // console.log("addNew", data)
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new IncomingsHeaderDAO())}`
    let ok = await conn_pool.query(instert_q)
    return  ok.insertId
  }

  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new IncomingsHeaderDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }

  static async getDAOById(id) {
    // return await dexie[this.TABLE_NAME].get(id)
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    return new IncomingsHeaderDAO(row[0])
  }

  /** @param {IncomingsHeaderDAO} data */
  static async getDayHeader(data) {
    // console.log(data)
    // let head = await dexie[this.TABLE_NAME].get({day:data.day, product_id: data.product_id, supplier_id: data.supplier_id})
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and product_id=${data.product_id} and supplier_id=${data.supplier_id}`)
    if(row.length)
      return new IncomingsHeaderDAO(row[0])
    else 
      return
  }

  static async getAll(data) {
    let all = []
    let results = []
    if(data) {
      if(data.current_count == '> 0' && data.day){
        //all = await dexie[this.TABLE_NAME].where({day:data.day}).and( row => row.current_count > 0 ).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and current_count > 0`)
      }
      if(data.day && data.supplier_id) {
        //all = await dexie[this.TABLE_NAME].where({day:data.day, supplier_id: data.supplier_id}).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id= ${data.supplier_id}`)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }

    results.forEach( item => { all.push(new IncomingsHeaderDAO(item)) })
    return all
  }
}