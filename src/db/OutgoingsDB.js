import { conn_pool, payloader, inserter, store } from '../main'
import { IncomingsHeaderDB } from './IncomingsHeaderDB'
import { CashflowDB, CashflowDAO } from './CashflowDB'
import { CustomersDB } from './CustomersDB'
import { OutgoingsHeaderDB, OutgoingHeaderDAO } from './OutgoingsHeaderDB';

export class OutgoingDAO {

  id = 0
  day = ''
  income_day = ''
  date_created = 0
  
  supplier_id = 0
  supplier_name
  product_id = 0
  product_name

  income_head_id

  customer_select = {}
  customer_id = 0
  customer_name

  sell_type = ''
  sell_comm // null
  sell_comm_value
  kg_price // null
  weight // null
  count // null
  value_calc = 0
  collecting
  notes = ''
  sum_count
  sum_weight
  
  parseTypes () {
    this.count = parseInt(this.count)
    this.sell_comm = parseFloat(this.sell_comm)
    this.kg_price = parseFloat(this.kg_price)
    this.weight = parseFloat(this.weight)
    this.value_calc = parseFloat(this.value_calc)
  }

  selectFromObjects() {
    if(this.customer_select && this.customer_select.id) {
      this.customer_id = this.customer_select.id
      this.customer_name = this.customer_select.name
    }
    delete this.customer_select
  }

  // Constant member
  static get INIT_DAO() {
    return {
      sell_comm: 6
    }
  }

  constructor (data) {
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class OutgoingsDB {
    static TABLE_NAME = 'outgoings'

    /**@param {OutgoingDAO} data*/
    static async addNew(data) {
      delete data.id
      // console.log(data)

      data.parseTypes()
      data.selectFromObjects()

      data.sell_comm_value = data.count * data.sell_comm
      
      let instert_q = `INSERT INTO ${this.TABLE_NAME} ${inserter(data, new OutgoingDAO())}`
      // console.log('instert_q', instert_q)
      let ok = await conn_pool.query(instert_q)
      let outgoing_id = ok.insertId

      // decrease Incoming 
      let inc_header = await IncomingsHeaderDB.getDAOById(data.income_head_id)
      inc_header.parseTypes()
      inc_header.current_count -= parseInt(data.count)

      await IncomingsHeaderDB.saveById(inc_header.id, inc_header)

      // Add outgoing header according to price
      let outHeadDAO = new OutgoingHeaderDAO(data)
      // تاريخ الوارد وليس البيع
      outHeadDAO.day = data.income_day
      // console.log("outHeadDAO", outHeadDAO)
      await OutgoingsHeaderDB.addPlus(outHeadDAO)

      // Update debit
      if(data.customer_id) {
        await CustomersDB.updateDebt(data.customer_id, {
          amount: data.value_calc,
          outgoing_id: outgoing_id,
          trans_type: 'outgoing',
          product_id: data.product_id,
          product_name: data.product_name,
          count: data.count,
          day: store.state.day.iso,
          curr_incoming_day : store.state.day.iso
        })
      }
      else {
        let cashDAO = new CashflowDAO()
        cashDAO.amount = data.value_calc
        cashDAO.sum = '+'
        cashDAO.state = 'outgoing_cash'
        cashDAO.outgoing_id = outgoing_id
        cashDAO.day = store.state.day.iso
        cashDAO.d_product = data.product_name
        await CashflowDB.addNew(cashDAO)
      }

      // cashflow part
      if(data.collecting) {
        let cashDAO = new CashflowDAO(CashflowDAO.COLLECTING_DAO)
        cashDAO.amount = data.collecting
        cashDAO.day = store.state.day.iso
        cashDAO.state_data = {
          outgoing_id: outgoing_id,
          customer_id: data.customer_id,
          customer_name: data.customer_name
        }
        cashDAO.actor_id = data.customer_id
        cashDAO.actor_name = data.customer_name
        cashDAO.id = await CashflowDB.addNew(cashDAO)
        // TODO SO NO OBJECT PAYLOAD !!!!

        cashDAO.amount = - (cashDAO.amount)
        cashDAO.d_product = data.product_name
        // TODO check later y3n
        await CustomersDB.updateDebt(data.customer_id, cashDAO)
      }
    }
  
    static async discard(id) {
      let outDAO = await this.getDAOById(id)
      console.log(outDAO)

      let incHeaderDAO = await IncomingsHeaderDB.getDAOById(outDAO.income_head_id)
      console.log("incHeaderDAO", incHeaderDAO)

      incHeaderDAO.current_count += parseInt(outDAO.count)

      await IncomingsHeaderDB.saveById(incHeaderDAO.id, {
        current_count: incHeaderDAO.current_count
      })
      
      await this.removeById(id)
      return true
    }

    static async removeById(id) {
      let update_q = `DELETE FROM  ${this.TABLE_NAME} WHERE id = ${id}`
      await conn_pool.query(update_q)
      return 
    }

    static async saveById(id, payload) {
      //let updated = await dexie[this.TABLE_NAME].update(id, payload)
      let sets = payloader(payload, new OutgoingDAO())
      let update_q = `UPDATE ${this.TABLE_NAME} SET ${sets.join(',')} WHERE id = ${id}`
      await conn_pool.query(update_q)
      return
    }

    static async getDailyCustomers(data) {
      let all_obj = {}
      let all = await this.getAll(data)
      all.forEach( item => {
        if(item.customer_id)
          all_obj[item.customer_id] = item.customer_id
      })
      return Object.values(all_obj)
    }

    static async getGroupedSums(data) {
      let all = []
let sql_query = `SELECT income_day,
supplier_id,
product_id as product_id,
product_name as product_name,
kg_price,
income_head_id,
sell_comm as sell_comm,
sum(weight) as sum_weight,
sum(count) as sum_count FROM ${this.TABLE_NAME} 
where supplier_id =${data.supplier_id} and income_day='${data.income_day}'
GROUP BY income_head_id, kg_price 
order by kg_price desc ;
`     
      console.log('sql_query', sql_query)
      let results = await conn_pool.query(sql_query)
      results.forEach( item => { all.push(new OutgoingDAO(item)) })
      console.log(all)
      return all
    }

    static async getTotalSellComm(data){
      let row = await conn_pool.query(`SELECT sum(sell_comm_value) as total_sell_comm_sum FROM ${this.TABLE_NAME} where supplier_id = ${data.supplier_id} and income_day='${data.income_day}'`)
      return row[0].total_sell_comm_sum ? row[0].total_sell_comm_sum : 0
    }

    static async getDAOById(id) {
      // return await dexie[this.TABLE_NAME].get(id)
      let row = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where id=${id}`)
      return new OutgoingDAO(row[0])
    }
  
    static async getAll(data) {
      let all = []
      let results = []
  
      if(data) {
        if(data.day && data.customer && data.customer == '> 0' ) {
          results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}' and customer_id > 0`)
        }
        else if(data.day) {
          results = await conn_pool.query(`SELECT * FROM ${this.TABLE_NAME} where day='${data.day}'`)
        }
      }
      else {
        results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
      }
  
      results.forEach( item => { all.push(new OutgoingDAO(item)) })
      return all
    }
  }