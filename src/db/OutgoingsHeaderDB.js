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
  }

}

//////////////////////// DB ///////////////////////////////
 
export class OutgoingsHeaderDB {

  static TABLE_NAME = 'outgoings_header'

/** @param {OutgoingHeaderDAO} data */

  static async addPlus(data) {
    let head = await this.getDayHeader(data)
    if ( ! head ) {
        let added = await this.addNew(data)
        console.log(added)
    } // else update
    else {
        console.log(head)
        head.total_count += data.total_count
        this.saveById(head.id, head)
    }
  }

/** @param {OutgoingHeaderDAO} data */
  static async addNew(data) {
    delete data.id
    dexie.outgoings_header.add(data)
  }

  static async saveById(id, payload) {
    return await dexie.outgoings_header.update(id, payload)
  }

  static async getById(id) {
    /**@type {Dexie.Table} */
    let table = dexie.outgoings_header
    return await table.get(id)
  }

  static async getDayHeader(data) {
    console.log(data)
    let head = await dexie.outgoings_header.get({
      day:data.day,
      incoming_header_id: data.incoming_header_id,
      kg_price: data.kg_price,
    })
    return head
  }

  static async getAll() {
    let all = []
    all = await dexie.outgoings_header.toArray()
    return all
  }
}