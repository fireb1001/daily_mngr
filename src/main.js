import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import BootstrapVue from 'bootstrap-vue'

Vue.use(BootstrapVue)
console.log(process.versions.electron)

import Datetime from 'vue-datetime'
// You need a specific loader for CSS files
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(Datetime)

Vue.config.productionTip = false

export const APP_LABELS = {
  given: 'وهبة',
  nolon: 'نولون',
  outgoing_cash: 'بيع نقدي',
  expenses: 'مصروفات',
  paid: 'سلفة',
  acc_rest: 'باقي حساب',
  collecting: 'تحصيل',
  supp_collect: 'داخل من العميل',
  recp_paid: 'فاتورة صرف',
  cust_trust: 'امانة بائع',
  repay_cust_trust: 'رد امانة بائع',
  men_account: 'حساب الرجالة',
  act_pymnt: 'دفعات لا تخصم من الايراد',
  repay_cust_rahn: 'رد رهن لبائع',
  cust_rahn: 'رهن من بائع',
  supp_payment: 'دفعة نقدية',
  out_receipt: 'مصاريف فاتورة',
  inc_collect: 'نقدية داخل',
  trans: {
    repay_cust_rahn: 'رد رهن لبائع',
    cust_rahn: 'رهن من بائع',
    outgoing: 'بيع اجل',
    collecting: 'تحصيل',
    init: 'رصيد مديونية',
    paid: 'سلفة',
    acc_rest: 'باقي حساب',
    cust_trust: 'امانة بائع',
    repay_cust_trust: 'رد امانة بائع'
  },
  payments: {
    payment: 'دفعة',
    nolon: 'نولون',
    supp_collect: 'داخل من العميل',
    receipt_1: 'فاتورة رصد',
    out_receipt: 'مصاريف فاتورة'
  },
  menu: {
    incomings: 'الوارد',
    outgoings: 'المبيعات',
    daily_moves: 'حركات اليومية',
    suppliers_receipts: 'عملاء اليوم',
    customers_accounts: 'بائعين اليوم',
    expenses: 'مخرجات',
    collecting: 'مدخلات'
  },
  recps: {
    0: 'حفظ',
    1: 'رصد',
    2: 'صرف'
  }
}

export { store }
// TODO collect all todos !
// TODO cashflow text detailed && cashflow after
/*
export const dexie = new Dexie('daily_mngr')
dexie.version(1).stores({
  
  incomings: '++id, product_id, supplier_id, day',
  outgoings: '++id, product_id, supplier_id, customer_id, day',
  suppliers: '++id, balance, active',
  products: '++id, active',
  customers: '++id, debt, active',
  customer_trans: '++id, debt_after, customer_id',
  supplier_trans: '++id, balance_after',
  incomings_header: '++id, supplier_id, product_id, day, total_count, current_count',
  outgoings_header: '++id, supplier_id, product_id, total_count, sell_comm, total_weight, kg_price, income_head_id, day, total_value',
  cashflow: '++id, amount, state, day'
  // benefit of a compound index [day+product_id+supplier_id]
})
*/

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
  // console.log(cols_vals)

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

export const appConfigs = {
  db_engine: 'mysql', // dexie / mysql ,
  shader_name: 'nada'
}

var mysql      = require('mysql')
var util = require('util')

var db_config = {
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  database: 'shader_demo',
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

function roundOf(n, p) {
  const n1 = n * Math.pow(10, p + 1);
  const n2 = Math.floor(n1 / 10);
  if (n1 >= (n2 * 10 + 5)) {
      return (n2 + 1) / Math.pow(10, p);
  }
  return n2 / Math.pow(10, p);
}

export const getShaderConfigValue = function (state, config_name) {
  if(state.shader_configs && state.shader_configs[config_name])
    return state.shader_configs[config_name].config_value
  else return null
}

Vue.filter('round2' , function(number) {
  let rounded = number? parseFloat(number) : 0
  return roundOf(rounded,2)
})

Vue.filter('round', function(value, decimals) {
  if(!value) 
    value = 0;

  if(!decimals) 
    decimals = 0;

  value = Math.round(value * Math.pow(10, decimals)) / Math.pow(10, decimals);
  return value;
});

const moment = require('moment')
moment.locale('ar')

export { moment }

Vue.filter('arDate' , function(date) {
  return moment(date).format('LL')
})

String.prototype.toAR= function() {
  return this.replace(/\d/g, d =>  '٠١٢٣٤٥٦٧٨٩'[d])
}

Vue.filter('toAR' , function(number) {
  /*
  let num = parseFloat(number).toString()
  return num.toAR()
  */
  let num = ( number || number === 0 ) ? parseFloat(number) : '--'
  return num.toLocaleString('ar-EG')
})

function testJSON(text){
  if (typeof text!=="string"){
      return false;
  }
  try{
      JSON.parse(text);
      return true;
  }
  catch (error){
      return false;
  }
}

Vue.filter('productsFilter' , function(products, separator) {

  separator = separator? separator : ' , '
  if(testJSON(products)) {
    let only_prod_names = []
    let all_products = JSON.parse(products)
    all_products.forEach(prod => {
      only_prod_names.push(prod.product)
    });
    return only_prod_names.join(separator)
  } else {
    return products
  }
})

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

Vue.prototype.vue_window = window
Vue.prototype.vue_document = document