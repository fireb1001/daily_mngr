import { dexie } from '../main'

export class CashflowDAO {

    id = 0
    type = ''
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
    dexie.cashflow.add(data)
  }

  static async saveById(id, payload) {
    let updated = await dexie.cashflow.update(id, payload)
    return updated
  }

  static async getAll(data) {

    let all = []
    if(data.state){
      all = await dexie.cashflow.where({state:data.state}).toArray()
    }
    else {
      all = await dexie.cashflow.toArray()
    }

    return all
  }
}