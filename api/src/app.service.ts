import { Injectable } from '@nestjs/common';
import { Connection } from 'typeorm';

@Injectable()
export class AppService {

  constructor(private connection: Connection) { }


  async getSegments() {

    // KMEANS ? 
    // 
    const ffc = await this.connection.query(`
          SELECT 
          *,
          (SELECT COUNT(*) FROM FFC_ACTIVITY WHERE FFC.Customer_PN = FFC_ACTIVITY.Customer_PN)::INTEGER
          FROM FFC
          INNER JOIN CUSTOMER C ON C.Passport_number = FFC.Customer_PN
        `)

    return ffc;
  }

  async getUserDefinedQuery(query: string) {

    const result = await this.connection.query(query);

    return result;

  }


}
