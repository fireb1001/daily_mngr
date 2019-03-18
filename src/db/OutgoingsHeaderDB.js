// import { conn_pool } from '../main'
import { dexie } from '../main'

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
    if(data.count) {
        this.total_count = parseInt(data.count)
    }
    if(data.weight) {
      this.total_weight = parseFloat(data.weight)
    }
    if(data.value_calc) {
      this.total_value = parseFloat(data.value_calc)
    }
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

/** @param {OutgoingHeaderDAO} data */
  static async addNew(data) {
    delete data.id
    return await dexie[this.TABLE_NAME].add(data)
  }

  static async saveById(id, payload) {
    return await dexie[this.TABLE_NAME].update(id, payload)
  }

  static async getById(id) {
    /**@type {Dexie.Table} */
    let table = dexie[this.TABLE_NAME]
    return await table.get(id)
  }

  static async getDayHeader(data) {
    console.log(data)
    let head = await dexie[this.TABLE_NAME].get({
      day:data.day,
      incoming_header_id: data.incoming_header_id,
      kg_price: data.kg_price,
    })
    if (head)
      return new OutgoingHeaderDAO(head)
    else 
      return null
  }

  static async getAll(data) {
    let all = []
    if(data) {
      if(data.day && data.supplier_id)
        all = await dexie[this.TABLE_NAME].where({day:data.day, supplier_id: data.supplier_id}).toArray()
    }
    else {
      all = await dexie[this.TABLE_NAME].toArray()
    }
    return all
  }
}