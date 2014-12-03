//
//  HDLDatabaseManager.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-30.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDLHuddleObject.h"

@interface HDLDatabaseManager : NSObject

+(HDLDatabaseManager*)getSharedInstance;

- (HDLHuddleObject *) saveHuddle: (NSDate *)date
          withVotes: (NSMutableArray *)votes
         withEvents: (NSMutableArray *)events
       withInvitees: (NSMutableSet *)invitees;

- (NSMutableArray *) loadHuddles;

-(BOOL) updateHuddle: (HDLHuddleObject *) huddle
            withDate: (NSDate *) date
           withVotes: (NSMutableArray *) votes
          withEvents: (NSMutableArray *) events;

@end
