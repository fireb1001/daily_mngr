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
  total_sell_comm_value
  sell_comm_details
  kg_price
  total_weight
  total_value
  incoming_header_id
  recp_weight
  recp_kg_price
  recp_comm_rate
  recp_total
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
    if(data && data.sell_comm_value) {
      this.total_sell_comm_value = parseFloat(data.sell_comm_value)
    }
  }

  
  parseTypes() {
    this.total_count = parseInt(this.total_count)
    this.kg_price = parseFloat(this.kg_price)
    this.total_weight = parseFloat(this.total_weight)
    this.total_value = parseFloat(this.total_value)
    this.total_sell_comm_value = parseFloat(this.total_sell_comm_value)
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
        headDAO.total_sell_comm_value += data.total_sell_comm_value
        headDAO.recp_kg_price = headDAO.kg_price
        headDAO.recp_weight = headDAO.total_weight
        headDAO.recp_total = headDAO.recp_kg_price * headDAO.recp_weight

        await this.saveById(headDAO.id, {
          total_count: headDAO.total_count,
          total_weight: headDAO.total_weight,
          total_value: headDAO.total_value,
          total_sell_comm_value: headDAO.total_sell_comm_value,
          recp_kg_price: headDAO.recp_kg_price,
          recp_weight: headDAO.recp_weight,
          recp_total: headDAO.recp_total
        })
        return headDAO.id
    }
  }

  /**@param {OutgoingHeaderDAO} data */
  static async addNew(data) {
    data.parseTypes()
    data.recp_kg_price = data.kg_price
    data.recp_weight = data.total_weight
    data.recp_total = data.recp_kg_price * data.recp_weight
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new OutgoingHeaderDAO())}`
    let ok = await conn_pool.query(instert_q)
    return  ok.insertId
  }

  static async saveById(id, payload) {
    //return await dexie[this.TABLE_NAME].update(id, payload)
    let sets = payloader(payload, new OutgoingHeaderDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    console.log(update_q)
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
      else if (data.day) {
        // moves 
        results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' `)
      }
    }
    else {
      results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    }
    results.forEach( item => { all.push(new OutgoingHeaderDAO(item)) })
    return all
  }
}