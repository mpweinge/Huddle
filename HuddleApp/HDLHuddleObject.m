//
//  HDLHuddleObject.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-30.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLHuddleObject.h"

@implementation HDLHuddleObject
{
  NSDate * _date;
  NSArray * _votes;
  NSArray * _events;
  NSArray *_invitees;
  
  NSString *_dateString;
  NSString *_inviteesString;
  NSString *_voteString;
  NSString *_eventString;
}

-(instancetype) initWithDateString: (NSString *)date
                        voteString: (NSString *)votes
                       eventString: (NSString *)events
                     inviteeString: (NSString *)invitees
{
  self = [super init];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  
  _dateString = date;
  _eventString = events;
  _voteString = votes;
  _inviteesString = invitees;
  
  _date = [dateFormatter dateFromString:date];
  
  _votes = [votes componentsSeparatedByString: @","];
  
  _events = [events componentsSeparatedByString: @","];
  
  _invitees = [events componentsSeparatedByString:@","];
  
  return self;
}

-(NSString *)dateString
{
  return _dateString;
}

-(NSDate *)date
{
  return _date;
}

-(NSString *)voteString
{
  return _voteString;
}

-(NSArray *)votes
{
  return _votes;
}

-(NSString *)eventString
{
  return _eventString;
}

-(NSArray *)events
{
  return _events;
}

-(NSArray *)invitees
{
  return _invitees;
}

-(NSString *)inviteesString
{
  return _inviteesString;
}

@end
