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
                     inviteeString: (NSString *)invitees;

-(NSDate *)date;

-(NSArray *)invitees;

-(NSArray *)votes;

-(NSArray *)events;

-(NSString *)dateString;

-(NSString *)inviteesString;

@end
