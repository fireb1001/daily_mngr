import { dexie } from '../main'

export class AdminDB {
     
    static async removeDaily() {
        dexie.incomings.clear()
        dexie.incomings_header.clear()
        dexie.outgoings.clear()
        dexie.outgoings_header.clear()
        dexie.cashflow.clear()
    }

    static async removeAll() {
        return await dexie.delete()
    }
  }