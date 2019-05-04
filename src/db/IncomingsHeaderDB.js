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
  inc_total_nolon
  recp_comm // join
  notes

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
    if(data && data.nolon)
      this.inc_total_nolon = parseFloat(data.nolon)
  }

  parseTypes() {
    this.total_count = parseInt(this.total_count)
    this.current_count = parseInt(this.current_count)
    this.inc_total_nolon = this.inc_total_nolon? parseFloat(this.inc_total_nolon) : 0
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
      head.inc_total_nolon += data.inc_total_nolon? parseFloat(data.inc_total_nolon) : 0
      await this.saveById(head.id, {
        total_count: head.total_count,
        current_count: head.current_count,
        inc_total_nolon: head.inc_total_nolon
      })
      return head.id
    }
  }
  /*
  static async addTotals(id, payload) {
    console.log("addTotals", id, payload)
  }
  */

  /** @param {IncomingsHeaderDAO} data */
  static async addNew(data) {
    delete data.id
    delete data.recp_comm
    console.log("addNew", data)
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new IncomingsHeaderDAO())}`
    let ok = await conn_pool.query(instert_q)
    return  ok.insertId
  }

  static async saveById(id, payload) {
    delete payload.recp_comm
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new IncomingsHeaderDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    console.log('update_q', update_q)
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

  static async getDailySuppliers(data) {
    let all_obj = {}
    /*
    await dexie[this.TABLE_NAME].where({day:data.day}).each( item => {
      if(item.supplier_id){
        all_obj[item.supplier_id] = item.supplier_id
      }
    })
    */
    let all = await this.getAll(data)
    console.log(all)
    all.forEach( item => {
      if(item.supplier_id) {
        if(! all_obj[item.supplier_id]) {
          all_obj[item.supplier_id] = 0
        }
        all_obj[item.supplier_id] += parseInt(item.current_count)
      }
        
    })

    return all_obj
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
      if(data.current_count == '> 0') { //  && data.day
        //all = await dexie[this.TABLE_NAME].where({day:data.day}).and( row => row.current_count > 0 ).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where current_count > 0  `) // old and day='${data.day}'
      }
      else if(data.day && data.supplier_id) {
        //all = await dexie[this.TABLE_NAME].where({day:data.day, supplier_id: data.supplier_id}).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id= ${data.supplier_id}`)
      }
      else if(data.day) {
        // results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}'`)
        results = await conn_pool.query(`SELECT PT.*,(SELECT SUM(CT.recp_comm_value ) FROM outgoings_header AS CT WHERE CT.income_head_id = PT.id  ) as recp_comm FROM incomings_header AS PT where PT.day='${data.day}' order by PT.supplier_id`)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }

    results.forEach( item => { all.push(new IncomingsHeaderDAO(item)) })
    return all
  }
}