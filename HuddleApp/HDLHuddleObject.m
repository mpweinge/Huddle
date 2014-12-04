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
  
  NSMutableArray * mutableVotes = [NSMutableArray arrayWithArray:_votes];
  NSMutableArray * mutableEvents = [NSMutableArray arrayWithArray:_events];
  
  NSArray * _voteOne = [_votes[0] componentsSeparatedByString:@":"];
  
  NSArray * _voteTwo = [_votes[1] componentsSeparatedByString:@":"];
  
  NSArray * _voteThree = [_votes[2] componentsSeparatedByString:@":"];
  
  int voteOneCount = [_votes[0] rangeOfString:@"."].location == NSNotFound ? 0 : _voteOne.count;
  int voteTwoCount = [_votes[1] rangeOfString:@"."].location == NSNotFound ? 0 : _voteTwo.count;
  int voteThreeCount = [_votes[2] rangeOfString:@"."].location == NSNotFound ? 0 : _voteThree.count;
  
  if (voteOneCount > voteTwoCount)
  {
    if (voteOneCount > voteThreeCount)
    {
      if (voteThreeCount > voteTwoCount)
      {
        //1, 3, 2
        NSString * firstElement = mutableVotes[0];
        NSString * secondElement = mutableVotes[1];
        NSString * thirdElement = mutableVotes[2];
        mutableVotes[0] = firstElement;
        mutableVotes[1] = thirdElement;
        mutableVotes[2] = secondElement;
        
        NSString * firstEvent = mutableEvents[0];
        NSString * secondEvent = mutableEvents[1];
        NSString * thirdEvent = mutableEvents[2];
        mutableEvents[0] = firstEvent;
        mutableEvents[1] = thirdEvent;
        mutableEvents[2] = secondEvent;
        
      } else {
        //1, 2, 3
        //Do nothing here
      }
    } else {
      //3, 1, 2
      NSString * firstElement = mutableVotes[0];
      NSString * secondElement = mutableVotes[1];
      NSString * thirdElement = mutableVotes[2];
      mutableVotes[0] = thirdElement;
      mutableVotes[1] = firstElement;
      mutableVotes[2] = secondElement;
      
      NSString * firstEvent = mutableEvents[0];
      NSString * secondEvent = mutableEvents[1];
      NSString * thirdEvent = mutableEvents[2];
      mutableEvents[0] = thirdEvent;
      mutableEvents[1] = firstEvent;
      mutableEvents[2] = secondEvent;
    }
  } else {
    if (voteTwoCount > voteThreeCount)
    {
      if ( voteThreeCount > voteOneCount)
      {
        //2, 3, 1
        NSString * firstElement = mutableVotes[0];
        NSString * secondElement = mutableVotes[1];
        NSString * thirdElement = mutableVotes[2];
        mutableVotes[0] = secondElement;
        mutableVotes[1] = thirdElement;
        mutableVotes[2] = firstElement;
        
        NSString * firstEvent = mutableEvents[0];
        NSString * secondEvent = mutableEvents[1];
        NSString * thirdEvent = mutableEvents[2];
        mutableEvents[0] = secondEvent;
        mutableEvents[1] = thirdEvent;
        mutableEvents[2] = firstEvent;
      } else {
        //2, 1, 3
        NSString * firstElement = mutableVotes[0];
        NSString * secondElement = mutableVotes[1];
        NSString * thirdElement = mutableVotes[2];
        mutableVotes[0] = secondElement;
        mutableVotes[1] = firstElement;
        mutableVotes[2] = thirdElement;
        
        NSString * firstEvent = mutableEvents[0];
        NSString * secondEvent = mutableEvents[1];
        NSString * thirdEvent = mutableEvents[2];
        mutableEvents[0] = secondEvent;
        mutableEvents[1] = firstEvent;
        mutableEvents[2] = thirdEvent;
      }
    } else {
      //3, 2, 1
      NSString * firstElement = mutableVotes[0];
      NSString * secondElement = mutableVotes[1];
      NSString * thirdElement = mutableVotes[2];
      mutableVotes[0] = thirdElement;
      mutableVotes[1] = secondElement;
      mutableVotes[2] = firstElement;
      
      NSString * firstEvent = mutableEvents[0];
      NSString * secondEvent = mutableEvents[1];
      NSString * thirdEvent = mutableEvents[2];
      mutableEvents[0] = thirdEvent;
      mutableEvents[1] = secondEvent;
      mutableEvents[2] = firstEvent;
    }
  }
  
  _votes = mutableVotes;
  _events = mutableEvents;
  
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
