//
//  HDLDatabaseManager.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-30.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLDatabaseManager : NSObject

+(HDLDatabaseManager*)getSharedInstance;

- (BOOL) saveHuddle: (NSDate *)date
          withVotes: (NSMutableArray *)votes
         withEvents: (NSMutableArray *)events
       withInvitees: (NSMutableSet *)invitees;

- (NSMutableArray *) loadHuddles;

@end
