// import { conn_pool } from '../main'
import { dexie } from '../main'

export class ProductDAO {

    id = 0
    name = ''
    season 
    date_created
    active = 1
    notes = ''
    collection = ''

  static get INIT_DAO() {
    return {
      active: 1
    }
  }

  constructor( data ){
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class ProductsDB {
  static TABLE_NAME = 'products'

  static async addNew(data) {
    delete data.id
    return await dexie[this.TABLE_NAME].add(data)
    /*
          let instert_q = ` INSERT INTO ${Product.table_name} 
      (name, supplier, unit, price, notes, active) 
      VALUES ('${values.name}',${values.supplier},'${values.unit}',${values.price},'${values.notes}','${values.active}')
`
      try {
        console.log(instert_q)
        await conn_pool.query(instert_q)
        this.refresh_products_arr()
      } catch (error) {
        console.error("SQL error", error)
        this.products_arr.push(new Product(values))
      }
    */
  }

  static async saveById(id, payload) {
    return await dexie[this.TABLE_NAME].update(id, payload)
  }

  static async getAll() {
    let all = []
    all = await dexie[this.TABLE_NAME].toArray()
    return all
  }
}