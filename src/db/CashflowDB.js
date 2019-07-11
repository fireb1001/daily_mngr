import { inserter, conn_pool, payloader } from '../main'

export class CashflowDAO {

    id = 0
    // type = ''
    day
    state = ''
    state_data = ''
    actor_id
    actor_name = ''
    d_product = ''
    outgoing_id
    incoming_id
    sum = '+'
    amount
    date_created
    notes = ''
    count 
    weight
    kg_price
    income_day
    
  static get INIT_DAO() {
    return {
    }
  }

  static get RECP_PAID_DAO() {
    return {
      sum: '-',
      state: 'recp_paid'
    }
  }

  static get COLLECTING_DAO() {
    return {
      sum: '+',
      state: 'collecting'
    }
  }

  static get SUPP_COLLECT_DAO() {
    return {
      sum: '+',
      state: 'supp_collect'
    }
  }

  static get SUPP_PAY_DAO() {
    return {
      sum: '-',
      state: 'supp_payment'
    }
  }

  static get OUT_RECEIPT_DAO() {
    return {
      sum: '-',
      state: 'out_receipt'
    }
  }

  static get PAID_DAO() {
    return {
      sum: '-',
      state: 'paid'
    }
  }

  static get CUST_TRUST_DAO() {
    return {
      sum: '+',
      state: 'cust_trust'
    }
  }

  static get REPAY_CUST_TRUST_DAO() {
    return {
      sum: '-',
      state: 'repay_cust_trust'
    }
  }

  static get REPAY_CUST_RAHN_DAO() {
    return {
      sum: '+',
      state: 'repay_cust_rahn'
    }
  }


  static INST_STATE(payload){
    let instance = new this()
    instance.state = payload.state
    instance.day = payload.day
    //if(payload.state == 'collecting')
    return instance
  }

  parseTypes () {
    this.amount = Math.abs(parseFloat(this.amount))
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

  static async deleteItem(id) {
    let query = `DELETE FROM ${this.TABLE_NAME} where id=${id}`
    await conn_pool.query(query)
  }

  static async getAll(data) {
    // console.log(data.state, Array.isArray( data.state))
    let all = []
    let results = []

    if(data.day && data.states && Array.isArray( data.states)){
      data.states = data.states.map(d => `'${d}'`).join(',')
      let query = `SELECT cashflow.*, outgoings.count, outgoings.kg_price, outgoings.weight, outgoings.income_day FROM ${this.TABLE_NAME} LEFT JOIN outgoings ON  ${this.TABLE_NAME}.outgoing_id = outgoings.id where cashflow.day='${data.day}' `
        + `and cashflow.state IN (${data.states})`
      // console.log(query)
      results = await conn_pool.query(query)
    }
    else {
      // NONE
    }

    results.forEach( item => { all.push(new CashflowDAO(item)) })
    return all
  }
}