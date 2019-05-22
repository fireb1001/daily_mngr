import { AdminDB } from "../db/AdminDB";

export class AdminCTRL {
  static async getShaderConfigs(){
    return await AdminDB.getShaderConfigs()
  }
}  
