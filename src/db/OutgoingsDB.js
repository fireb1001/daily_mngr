import { dexie, store } from '../main'
import { IncomingsHeaderDB } from './IncomingsHeaderDB'
import { CashflowDB, CashflowDAO } from './CashflowDB'
import { CustomersDB } from './CustomersDB'
// eslint-disable-next-line no-unused-vars
import Dexie from 'dexie';

export class OutgoingDAO {

  id = 0
  day = ''
  date_created = 0
  
  supplier_id = 0
  supplier_name
  product_id = 0
  product_name
  incoming_id = 0

  customer_select = {}
  customer_id = 0
  customer_name

  sell_type = ''
  sell_com // null
  sell_com_value
  kg_price // null
  weight // null
  count // null
  value_calc = 0
  collecting
  notes = ''
  
  parseTypes () {
    this.count = parseInt(this.count)
    this.sell_com = parseFloat(this.sell_com)
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
    return {}
    /*
    return {
      product_id: 0,
      count: 0,
      supplier_id: 0,
      incoming_header_id: 0,
      customer_id: 0,
      sell_type: '',
      weight: 0,
      kg_price: 0,
      sell_com: 0,
      notes: ''
    }
    */
  }

  constructor (data) {
    Object.assign(this, data)
    /*
    this.id = data.id !== null ? data.id : this.id
    this.date = data.date !== null ? data.date : this.date
    this.supplier_id = data.supplier_id !== null ? data.supplier_id : this.supplier_id
    this.incoming_header_id = data.incoming_header_id !== null ? data.incoming_header_id : this.incoming_header_id
    this.customer_id = data.customer_id !== null ? data.customer_id : this.customer_id
    this.sell_type = data.sell_type !== null ? data.sell_type : this.sell_type
    this.weight = data.weight !== null ? data.weight : this.weight
    this.kg_price = data.kg_price !== null ? data.kg_price : this.kg_price
    this.sell_com = data.sell_com !== null ? data.sell_com : this.sell_com
    this.product_id = data.product_id !== null ? data.product_id : this.product_id
    this.count = data.count !== null ? data.count : this.count
    this.notes = data.notes !== null ? data.notes : this.notes
    */
  }
}

//////////////////////// DB ///////////////////////////////
 
export class OutgoingsDB {
    static TABLE_NAME = 'outgoings'
    /**@type {Dexie.Table} */
    //static TABLE = dexie['outgoings']

    /**@param {OutgoingDAO} data*/
    static async addNew(data) {
      delete data.id
      // console.log(data)

      data.parseTypes()
      data.selectFromObjects()

      data.sell_com_value = data.count * data.sell_com
      let outgoing_id = await dexie[this.TABLE_NAME].add(data)
      // decrease Incoming 
      let inc_header = await IncomingsHeaderDB.getById(data.incoming_header_id)
      inc_header.current_count -= parseInt(data.count)
      await IncomingsHeaderDB.saveById(inc_header.id, inc_header)

      // Update debit
      if(data.customer_id) {
        await CustomersDB.updateDebt(data.customer_id, {
          amount: data.value_calc,
          outgoing_id: outgoing_id,
          trans_type: 'outgoing',
          curr_incoming_day : store.state.day.formated
        })
      }
      else {
        let cashDAO = new CashflowDAO()
        cashDAO.amount = data.value_calc
        cashDAO.sum = '+'
        cashDAO.state = 'outgoing_cash'
        cashDAO.state_data = {
          outgoing_id: outgoing_id
        }
        await CashflowDB.addNew(cashDAO)
      }

      // cashflow part
      if(data.collecting) {
        let cashDAO = new CashflowDAO()
        cashDAO.amount = data.collecting
        cashDAO.sum = '+'
        cashDAO.state = 'collecting'
        cashDAO.state_data = {
          outgoing_id: outgoing_id,
          customer_id: data.customer_id,
          customer_name: data.customer_name
        }
        cashDAO.actor_id = data.customer_id
        cashDAO.actor_name = data.customer_name
        let cashflow_id = await CashflowDB.addNew(cashDAO)
        await CustomersDB.updateDebt(data.customer_id, {
          amount: - parseFloat(data.collecting),
          trans_type: 'collecting',
          cashflow_id: cashflow_id
        })
      }
    }
  
    static async saveById(id, payload) {
      let updated = await dexie[this.TABLE_NAME].update(id, payload)
      return updated
    }

    static async getDailyCustomers(data) {
      let all_obj = {}
      /**@type {Dexie.Table} */
      let table = dexie['outgoings']
      await table.where({day:data.day}).each( item => {
        if(item.customer_id){
          all_obj[item.customer_id] = item.customer_id
        }
      })
      return Object.values(all_obj)
    }
  
    static async getAll() {
      let all = []
      all = await dexie[this.TABLE_NAME].toArray()
      return all
    }
  }