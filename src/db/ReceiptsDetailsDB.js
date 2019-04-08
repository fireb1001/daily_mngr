import { conn_pool, inserter, payloader } from '../main'

export class ReceiptDetailDAO {

    id = 0
    receipt_id
    supplier_id
    supplier_name =''
    product_id
    product_name = ''
    day = ''
    count
    kg_price
    weight
    calc_value
    incoming_header_id
    date_created

  static get INIT_DAO() {
    return {
    }
  }

  parseTypes () {
    this.count = this.count? parseFloat(this.count) : 0
    this.kg_price = this.kg_price? parseFloat(this.kg_price) : null
    this.weight = this.weight? parseFloat(this.weight) : null
  }

  constructor( data ){
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class ReceiptsDetailsDB {
  static TABLE_NAME = 'receipts_details'
  
  /**@param {ReceiptDetailDAO} data */
  static async addNew(data) {
    delete data.id

    //console.log("addNew", data)
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new ReceiptDetailDAO())}`
    let ok = await conn_pool.query(instert_q)
    return  ok.insertId
  }

  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new ReceiptDetailDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    console.log(update_q)
    await conn_pool.query(update_q)
    return 
  }

  static async getAll(data) {
    let all = []
    let results = []
    if(data) {
      
      if(data.day && data.supplier_id) {
        // all = await dexie[this.TABLE_NAME].where({day:data.day, supplier_id: data.supplier_id}).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id= ${data.supplier_id} order by product_id`)
      }
      else if (data.day) {
        // moves 
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' order by product_id`)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }
    results.forEach( item => { all.push(new ReceiptDetailDAO(item)) })
    return all
  }

  static async deleteAll(data) {
    // console.log(data.state, Array.isArray( data.state))
    if(data.day && data.supplier_id){
      let query = `DELETE FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id = ${data.supplier_id}`
      await conn_pool.query(query)
    }
    else if(data && data.id) {
      let query = `DELETE FROM ${this.TABLE_NAME} where id = ${data.id} `
      await conn_pool.query(query)
    }
  }
}