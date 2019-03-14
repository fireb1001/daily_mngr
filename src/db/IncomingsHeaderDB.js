// import { conn_pool } from '../main'
import { dexie } from '../main'

export class IncomingsHeaderDAO {

  id = 0
  product_id = 0
  product_name
  supplier_id = 0
  supplier_name
  day = ''
  notes = ''
  total_count = 0
  current_count = 0

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
        this.total_count = this.current_count = parseInt(data.count)
    }
  }


}

//////////////////////// DB ///////////////////////////////
 
export class IncomingsHeaderDB {

  static TABLE_NAME = 'incomings_header'

/** @param {IncomingsHeaderDAO} data */

  static async addPlus(data) {
    let head = await this.getDayHeader(data)
    if ( ! head ) {
        let header_id = await this.addNew(data)
        return header_id
    } // else update
    else {
        head.total_count += data.total_count
        head.current_count += data.total_count
        this.saveById(head.id, head)
        return head.id
    }
  }

/** @param {IncomingsHeaderDAO} data */
  static async addNew(data) {
    delete data.id
    return await dexie.incomings_header.add(data)
  }

  static async saveById(id, payload) {
    return await dexie.incomings_header.update(id, payload)
  }

  static async getById(id) {
    /**@type {Dexie.Table} */
    let table = dexie.incomings_header
    return await table.get(id)
  }

  static async getDayHeader(data) {
    // console.log(data)
    let head = await dexie.incomings_header.get({day:data.day, product_id: data.product_id, supplier_id: data.supplier_id})
    return head
  }

  static async getAll(data) {
    let all = []
    if(data.current_count == '> 0')
        all = await dexie.incomings_header.where('current_count').above(0).toArray()
    else
        all = await dexie.incomings_header.toArray()
    return all
  }
}