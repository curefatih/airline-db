import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @Get()
  getSegments() {
    return this.appService.getSegments();
  }

  @Get('/user-defined')
  getUserQueryResult(@Query('query') query: string) {
    return this.appService.getUserDefinedQuery(query);
  }

}
