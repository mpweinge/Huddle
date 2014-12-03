//
//  HDLEventsViewController.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDLHuddleObject.h"

@interface HDLEventsViewController : UIViewController < UITableViewDataSource, UITableViewDelegate>

-(instancetype) initWithHuddle:(HDLHuddleObject *)huddle;

@end
