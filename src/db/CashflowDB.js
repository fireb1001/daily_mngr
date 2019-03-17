import { dexie } from '../main'
// eslint-disable-next-line no-unused-vars
import Dexie from 'dexie';

export class CashflowDAO {

    id = 0
    // type = ''
    day
    state = ''
    state_data = ''
    actor_id
    actor_name = ''
    sum = '+'
    amount
    date_created
    notes = ''

  static get INIT_DAO() {
    return {
    }
  }

  parseTypes () {
    this.amount = parseFloat(this.amount)
    if(typeof this.state_data === 'object')
      this.state_data= JSON.stringify(this.state_data)
  }

  constructor( data ){
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class CashflowDB {
  static TABLE_NAME = 'cashflow'

  /**@param {CashflowDAO} data */
  static async addNew(data) {
    delete data.id
    data.parseTypes()
    return await dexie[this.TABLE_NAME].add(data)
  }

  static async saveById(id, payload) {
    let updated = await dexie[this.TABLE_NAME].update(id, payload)
    return updated
  }

  static async getAll(data) {
    // console.log(data.state, Array.isArray( data.state))
    let all = []
    /**@type {Dexie.Table} */
    let table = dexie[this.TABLE_NAME]
    if(data.state){
      if (Array.isArray( data.state)) {
        // multible 
        all = await table.where('state').anyOf(data.state).toArray()
      } 
      else {
        all = await table.where({state:data.state}).toArray()
      }
    }
    else {
      // all = await dexie.cashflow.toArray()
    }

    return all
  }
}