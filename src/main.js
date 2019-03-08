import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import BootstrapVue from 'bootstrap-vue'
import {Incoming, Outgoing, Product} from './sql_classes'

Vue.use(BootstrapVue);
console.log(process.versions.electron)
Vue.config.productionTip = false

var mysql      = require('mysql');
var util = require('util')
/*
var conn = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '',
  database : 'bitnami_opencart'
})
*/
var db_config = {
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  database: 'daily_mngr',
}


function create_db () {
  db_config.database=''
  var conn = mysql.createConnection(db_config)
  conn.connect()
  conn.query(
    'CREATE DATABASE IF NOT EXISTS daily_mngr CHARACTER SET UTF8 COLLATE utf8_general_ci ;' 
    , (error)=>console.error(error)
  )
  conn.changeUser({database: 'daily_mngr'}, (error)=>console.error(error))
  conn.query(Incoming.createTableQ() ,(error)=>console.error(error))
  conn.query(Outgoing.createTableQ() ,(error)=>console.error(error))
  conn.query(Product.createTableQ() ,(error)=>console.error(error))
}

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
        console.error('Creating DB')
        create_db()
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
