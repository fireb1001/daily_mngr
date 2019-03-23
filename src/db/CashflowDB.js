import { inserter, conn_pool, payloader } from '../main'

export class CashflowDAO {

    id = 0
    // type = ''
    day
    state = ''
    state_data = ''
    actor_id
    actor_name = ''
    outgoing_id
    incoming_id
    sum = '+'
    amount
    date_created
    notes = ''

  static get INIT_DAO() {
    return {
    }
  }

  static get COLLECTING_DAO() {
    return {
      sum: '+',
      state: 'collecting'
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
    data.parseTypes()
    let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new CashflowDAO())}`
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }

  static async saveById(id, payload) {
    let sets = payloader(payload, new CashflowDAO())
    let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
    await conn_pool.query(update_q)
    return 
  }

  static async getAll(data) {
    // console.log(data.state, Array.isArray( data.state))
    let all = []
    let results = []

    if(data.day && data.states && Array.isArray( data.states)){
      data.states = data.states.map(d => `'${d}'`).join(',')
      let query = `SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' `
        + `and state IN (${data.states})`
      // console.log(query)
      results = await conn_pool.query(query)
      // all = await table.where({ day: data.day}).and( row => states_arr.includes(row.state) ).toArray()      
      // else NONE
      // all = await table.where({state:data.state, day: data.day}).toArray()
    }
    else {
      // NONE
    }

    results.forEach( item => { all.push(new CashflowDAO(item)) })
    return all
  }
}