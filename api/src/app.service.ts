import { Injectable } from '@nestjs/common';
import { Connection } from 'typeorm';

@Injectable()
export class AppService {

  constructor(private connection: Connection) { }


  async getSegments() {

    // KMEANS ? 
    // 
    const ffc = await this.connection.query(`
          SELECT * FROM FFC
          INNER JOIN FFC_ACTIVITY FA ON FA.Customer_PN = FFC.Customer_PN
        `)

    return ffc;
  }

  async getUserDefinedQuery(query: string) {

    const result = await this.connection.query(query);

    return result;

  }


}
