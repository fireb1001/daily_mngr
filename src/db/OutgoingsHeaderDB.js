import { conn_pool, inserter, payloader } from '../main'

export class OutgoingHeaderDAO {

  id = 0
  product_id = 0
  supplier_id = 0
  product_name
  supplier_name
  day 
  date_created
  total_count
  total_sell_com
  sell_com_details
  kg_price
  total_weight
  total_value
  incoming_header_id

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
        this.total_count = parseInt(data.count)
    }
    if(data && data.weight) {
      this.total_weight = parseFloat(data.weight)
    }
    if(data && data.value_calc) {
      this.total_value = parseFloat(data.value_calc)
    }
  }

  
  parseTypes() {
    this.total_count = parseInt(this.total_count)
    this.total_weight = parseFloat(this.total_weight)
    this.total_value = parseFloat(this.total_value)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class OutgoingsHeaderDB {

  static TABLE_NAME = 'outgoings_header'

  /** @param {OutgoingHeaderDAO} data */
  static async addPlus(data) {
    let headDAO = await this.getDayHeader(data)
    if ( ! headDAO ) {
        let header_id = await this.addNew(data)
        return header_id
    } // else update
    else {
        console.log(headDAO)
        headDAO.total_count += data.total_count
        headDAO.total_weight += data.total_weight
        headDAO.total_value += data.total_value
        this.saveById(headDAO.id, headDAO)
        return headDAO.id
    }
  }

  
  static async addNew(data) {
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new OutgoingHeaderDAO())}`
    let ok = await conn_pool.query(instert_q)
    return  ok.insertId
  }

  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new OutgoingHeaderDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }

  static async getDAOById(id) {
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
    return new OutgoingHeaderDAO(row[0])
  }


  static async getDayHeader(data) {
    // console.log(data)
    let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and incoming_header_id=${data.incoming_header_id} and kg_price=${data.kg_price}`)
    if(row.length)
      return new OutgoingHeaderDAO(row[0])
    else 
      return
  }

  static async getAll(data) {
    let all = []
    let results = []
    if(data) {
      if(data.day && data.supplier_id) {
        // all = await dexie[this.TABLE_NAME].where({day:data.day, supplier_id: data.supplier_id}).toArray()
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and supplier_id= ${data.supplier_id}`)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }
    results.forEach( item => { all.push(new OutgoingHeaderDAO(item)) })
    return all
  }
}