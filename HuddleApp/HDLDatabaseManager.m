//
//  HDLDatabaseManager.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-30.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLDatabaseManager.h"
#import "HDLHuddleObject.h"

#import <sqlite3.h>

static HDLDatabaseManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

static NSString* kHuddleDatabaseName = @"Huddle";

@implementation HDLDatabaseManager
{
  NSMutableDictionary* tableValues;
  NSString *databasePath;
  NSArray* _huddleFieldNames;
}

+(HDLDatabaseManager*)getSharedInstance
{
  if (!sharedInstance) {
    sharedInstance = [[super allocWithZone:NULL]init];
  }
  return sharedInstance;
}

- (id) init
{
  self = [super init];
  tableValues = [[NSMutableDictionary alloc] init];
  
  [self SetupDatabase];
  return self;
}


-(void) SetupDatabase
{
  NSArray *huddleFields = @[ @"Date text", @"Votes text", @"Events text", @"Invitees text"];
  _huddleFieldNames = @[ @"Date", @"Votes", @"Events", @"Invitees"];
  [self createTable:kHuddleDatabaseName withFields:huddleFields];
}

-(BOOL)createTable:(NSString *)tableName withFields: (NSArray *)fields
{
  NSString *docsDir;
  NSArray *dirPaths;
  // Get the documents directory
  dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  docsDir = dirPaths[0];
  
  // Build the path to the database file
  databasePath = [[NSString alloc] initWithString:
                  [docsDir stringByAppendingPathComponent: @"huddle.db"]];
  
  BOOL isSuccess = YES;
  //NSFileManager *filemgr = [NSFileManager defaultManager];
  
  //if ([filemgr fileExistsAtPath: databasePath ] == NO)
  {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      char *errMsg;
      //const char *sql_stmt =
      //"create table if not exists studentsDetail (regno integer, primary key, name text, department text, year text)";
      
      NSMutableString *sql_stmt = [NSMutableString string];
      [sql_stmt appendString:@"CREATE TABLE IF NOT EXISTS "];
      
      [sql_stmt appendString:tableName];
      
      NSMutableString *values = [NSMutableString string];
      NSMutableString *valueNames = [NSMutableString string];
      
      [values appendString:@"("];
      [valueNames appendString:@"("];
      
      int numFields = [fields count];
      
      for (int i = 0; i < numFields; i++)
      {
        [values appendString:fields[i]];
        
        NSRange currRange = [fields[i] rangeOfString:@" "];
        currRange.length = currRange.location;
        currRange.location = 0;
        
        [valueNames appendString:[fields[i] substringWithRange:currRange]];
        
        if (i != numFields - 1) {
          [values appendString:@","];
          [valueNames appendString:@","];
        }
      }
      
      [values appendString:@")"];
      [valueNames appendString:@")"];
      
      [sql_stmt appendString:values];
      
      [tableValues setValue:valueNames forKey:tableName];
      
      if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg)
          != SQLITE_OK)
      {
        isSuccess = NO;
      }
      sqlite3_close(database);
      return  isSuccess;
    }
    else {
      isSuccess = NO;
    }
  }
  return isSuccess;
}

- (BOOL) saveHuddle: (NSDate *)date
          withVotes: (NSMutableArray *)votes
         withEvents: (NSMutableArray *)events
       withInvitees: (NSMutableSet *)invitees
{
  //Check to make sure the serialized object has the same number of properties
  const char *dbpath = [databasePath UTF8String];
  
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    //Serialize the object
    NSMutableString *insertSQL = [NSMutableString string];
    [insertSQL appendString:@"INSERT INTO "];
    [insertSQL appendString: kHuddleDatabaseName];
    [insertSQL appendString: tableValues[kHuddleDatabaseName]];
    [insertSQL appendString: @" VALUES ("];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    [insertSQL appendString:@"\""];
    [insertSQL appendString:dateString];
    [insertSQL appendString:@"\""];
    [insertSQL appendString:@", "];
    
    NSMutableString *voteString = [NSMutableString string];
    for (NSString * voteSequence in votes)
    {
      [voteString appendString: voteSequence];
      [voteString appendString:@", "];
    }
    
    [insertSQL appendString:@"\""];
    [insertSQL appendString:voteString];
    [insertSQL appendString:@"\""];
    [insertSQL appendString:@", "];
    
    NSMutableString *eventString = [NSMutableString string];
    for (NSString * eventStrings in events)
    {
      [eventString appendString: eventStrings];
      [eventString appendString:@", "];
    }
    
    [insertSQL appendString:@"\""];
    [insertSQL appendString:eventString];
    [insertSQL appendString:@"\""];
    [insertSQL appendString:@", "];
    
    NSMutableString *inviteeString = [NSMutableString string];
    for (NSString * inviteStrings in invitees)
    {
      [inviteeString appendString: inviteStrings];
      [inviteeString appendString:@", "];
    }
    
    [insertSQL appendString:@"\""];
    [insertSQL appendString:inviteeString];
    [insertSQL appendString:@"\""];
    
    [insertSQL appendString:@")"];
    
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      
      return YES;
    }
    else {
      return NO;
    }
    sqlite3_reset(statement);
  }
  //INSERT INTO DATABASENAME(x, x, x) VALUES(x, x, x)
  return NO;
}

- (NSMutableArray *) loadHuddles
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@", kHuddleDatabaseName];
    //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ ", kDataPointDatabaseName];
    const char *query_stmt = [querySQL UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
      while (sqlite3_step(statement) == SQLITE_ROW)
      {
        NSString *dates = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
        NSString *votes = [[NSString alloc] initWithUTF8String:
                               (const char *) sqlite3_column_text(statement, 1)];
        NSString *events = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 2)];
        NSString *invitees = [[NSString alloc] initWithUTF8String:
                            (const char *) sqlite3_column_text(statement, 3)];
        
        [resultArray addObject:[[HDLHuddleObject alloc] initWithDateString:dates
                                                                voteString:votes
                                                               eventString:events
                                                             inviteeString:invitees]];
      }
      return resultArray;
      sqlite3_reset(statement);
    }
  }
  return nil;
}

@end
