// eslint-disable-next-line no-unused-vars
import { CashflowDB, CashflowDAO } from "../db/CashflowDB";

export class CashflowCTRL {

  /**@param {CashflowDAO} data */
  static async addNew(cashflowDAO) {
    cashflowDAO.parseTypes()
    if(cashflowDAO.amount > 0 || cashflowDAO.amount < 0 ) {
      let newID = await CashflowDB.addNew(cashflowDAO)
      return newID
    }
    else {
      return 0
    }
  }
}