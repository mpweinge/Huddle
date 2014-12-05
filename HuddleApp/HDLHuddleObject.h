//
//  HDLHuddleObject.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-30.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLHuddleObject : NSObject

-(instancetype) initWithDateString: (NSString *)date
                        voteString: (NSString *)votes
                       eventString: (NSString *)events
                     inviteeString: (NSString *)invitees
                        timeString: (NSString *)time;

-(NSDate *)date;

-(NSArray *)invitees;

-(NSArray *)votes;

-(NSArray *)events;

-(NSString *)dateString;

-(NSString *)eventString;

-(NSString *)voteString;

-(NSString *)inviteesString;

-(NSString *)timeString;

@end
