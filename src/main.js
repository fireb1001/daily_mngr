import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import BootstrapVue from 'bootstrap-vue'
//import { Outgoing, Product} from './sql_classes'
//import { IncomingsDB } from './db/IncomingsDB'
import Dexie from 'dexie'

Vue.use(BootstrapVue)
console.log(process.versions.electron)

import Datetime from 'vue-datetime'
// You need a specific loader for CSS files
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(Datetime)
import { Settings, DateTime } from 'luxon'

Settings.defaultLocale = 'ar'
console.log( DateTime.local().locale)

Vue.config.productionTip = false

export const appConfig = {
  db_engine: 'mysql' // dexie / mysql 
}

export const APP_LABELS = {
  given: 'وهبة',
  nolon: 'نولون',
  outgoing_cash: 'بيع كاش',
  trans: {
    outgoing: 'بيع اجل',
    collecting: 'تحصيل',
    init: 'رصيد مديونية'
  }
}

export const dexie = new Dexie('daily_mngr')
export { store, DateTime }
// TODO collect all todos !
// TODO clear daily_mngr data from bedos // rename !
// TODO go mysql go
// TODO cashflow text detailed && cashflow after

dexie.version(1).stores({
  
  incomings: '++id, product_id, supplier_id, day',
  outgoings: '++id, product_id, supplier_id, customer_id, day',
  suppliers: '++id, balance, active',
  products: '++id, active',
  customers: '++id, debt, active',
  customer_trans: '++id, debt_after, customer_id',
  supplier_trans: '++id, balance_after',
  incomings_header: '++id, supplier_id, product_id, day, total_count, current_count',
  outgoings_header: '++id, supplier_id, product_id, total_count, sell_com, total_weight, kg_price, incoming_header_id, day, total_value',
  cashflow: '++id, amount, state, day'
  // benefit of a compound index [day+product_id+supplier_id]
})


export const payloader = function(payload, object) {
  let sets = []
  Object.keys(payload).forEach( key => {
    if (object.hasOwnProperty(key)) {
      // console.log(key, typeof payload[key], payload[key])
      let value = typeof payload[key] == 'string' ? `'${payload[key]}'`: payload[key]
      sets.push(key + '=' + value)
    }
  })
  return sets
}

export const inserter = function(object, empty_obj) {
  let cols_vals = ''
  let pairs = {}
  delete object.id

  Object.keys(empty_obj).forEach( key => {
    if(object[key] || object[key] === 0 || object[key] === '0')
      pairs[key] = object[key]
  })

  cols_vals = `(${Object.keys(pairs)}) VALUES ` + 
   `(${Object.values(pairs).map( val => {
    if(typeof val === 'string')
      return  "'" + val + "'"
    else
      return val
  })})`

  return cols_vals
}
/*
export const SupplierDX = dexie.suppliers.defineClass({
  id: Number,
  balance: Number
})

SupplierDX.prototype.save = function () {
  return db_config.suppliers.put(this)
}
*/

var mysql      = require('mysql')
var util = require('util')

var db_config = {
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  database: 'daily_mngr',
}

/*
function create_db () {
  db_config.database=''
  var conn = mysql.createConnection(db_config)
  conn.connect()
  conn.query(
    'CREATE DATABASE IF NOT EXISTS daily_mngr CHARACTER SET UTF8 COLLATE utf8_general_ci ;' 
    , (error)=>console.error(error)
  )
  conn.changeUser({database: 'daily_mngr'}, (error)=>console.error(error))
  conn.query(IncomingsDB.createTableQ() ,(error)=>console.error(error))
  conn.query(Outgoing.createTableQ() ,(error)=>console.error(error))
  conn.query(Product.createTableQ() ,(error)=>console.error(error))
}
*/
var pool = mysql.createPool(db_config)

pool.getConnection((err, connection) => {
  if (err) {
      if (err.code === 'PROTOCOL_CONNECTION_LOST') {
          console.error('Database connection was closed.')
      }
      if (err.code === 'ER_CON_COUNT_ERROR') {
          console.error('Database has too many connections.')
      }
      if (err.code === 'ECONNREFUSED') {
          console.error('Database connection was refused.')
      }
      if(err.code === 'ER_BAD_DB_ERROR') {
        // Init DB First
        console.error('ER_BAD_DB_ERROR', 'NO DB , Create DB')
        // create_db()
      }
  }
  if (connection) connection.release()
  return
})

pool.query = util.promisify(pool.query)

export const conn_pool = pool

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

Vue.prototype.vue_window = window
Vue.prototype.vue_document = document
