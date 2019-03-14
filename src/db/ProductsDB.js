// import { conn_pool } from '../main'
import { dexie } from '../main'

export class ProductDAO {

    id = 0
    name = ''
    season = ''
    active = 0
    notes = ''
    collection = ''

  static get INIT_DAO() {
    return {
      date_created: '',
      active: 1,
      name: '',
      notes: ''
    }
  }

  constructor( data ){
    this.id = data.id!== null ? data.id : this.id
    this.name = data.name !== null ? data.name : this.name
    this.active = data.active !== null ? data.active : this.active
    this.notes = data.notes !== null ? data.notes : this.notes
    this.collection = data.collection !== null ? data.collection : this.collection
  }
}

//////////////////////// DB ///////////////////////////////
 
export class ProductsDB {
  static TABLE_NAME = 'products'

  static async addNew(data) {
    dexie.products.add(data)
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
    let updated = await dexie.products.update(id, payload)
    return updated
  }

  static async getAll() {
      /*
      try {
        var results = await conn_pool.query('SELECT * FROM '+Product.table_name)

        this.products_arr = []
        results.forEach( item => {
          this.products_arr.push(new Product(item))
        })

      } catch(err) {
          throw new Error(err)
      }
      */
    let all = []
    all = await dexie.products.toArray()
    return all
  }
}