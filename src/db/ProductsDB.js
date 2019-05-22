import { conn_pool } from '../main'

export class ProductDAO {
    id = 0
    name = ''
    date_created
    active = 1
    notes = ''
    // season 
    // collection = ''

  static get INIT_DAO() {
    return {
      active: 1
    }
  }

  constructor( data ){
    if (data) Object.assign(this, data)
    if(data && data.active == '0') this.active = 0
  }
}

/*
ProductDAO.prototype.id = Number
ProductDAO.prototype.name = String

Object.(ProductDAO.prototype, 'id',{

})
*/
//////////////////////// DB ///////////////////////////////
 
export class ProductsDB {
  static TABLE_NAME = 'products'

  /**@param {ProductDAO} data */
  static async addNew(data) {
    // return await dexie[this.TABLE_NAME].add(data)
    let instert_q = `INSERT INTO ${this.TABLE_NAME} 
      (name, notes, active) 
      VALUES ('${data.name}','${data.notes}','${data.active}')
`
    console.log(instert_q)
    let ok = await conn_pool.query(instert_q)
    return ok.insertId
  }


  static async saveById(id, payload) {

    // return await dexie[this.TABLE_NAME].update(id, payload)
    // Helper if is set payload. name = '${payload.name}'
    console.log(Object.getOwnPropertyNames(new ProductDAO()))

    let update_q = ` UPDATE ${this.TABLE_NAME} SET 
    active = '${payload.active}' WHERE id = ${id}`
    let ok = await conn_pool.query(update_q)
    console.log(ok)
  }

  static async getAll(data) {
    let all = []
    //  all = await dexie[this.TABLE_NAME].toArray()

    var results = await conn_pool.query('SELECT * FROM '+this.TABLE_NAME)
    results.forEach( item => {
      // console.log(item)
      if (data && data.active ){
        // check if item.active
        if(parseInt(item.active) == 1)
          all.push(new ProductDAO(item))
      }
      else { // all
        all.push(new ProductDAO(item))
      }
    })
    
    return all
  }

}