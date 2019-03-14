import { dexie } from '../main'

export class DailyDAO {

    id = 0
    day = ''
    date = ''
    total_count = 0


  static get INIT_DAO() {
    return {
    }
  }

  parseTypes () {
    this.total_count = parseFloat(this.total_count)
  }

  constructor( data ){
    Object.assign(this, data)
  }
}

//////////////////////// DB ///////////////////////////////
 
export class DailyDB {
  static TABLE_NAME = 'daily'

  /**@param {DailyDAO} data */
  static async addNew(data) {
    delete data.id
    data.parseTypes()
    dexie.daily.add(data)
  }

  static async saveById(id, payload) {
    let updated = await dexie.daily.update(id, payload)
    return updated
  }

  static async getAll() {
    let all = []
    all = await dexie.daily.toArray()
    return all
  }
}