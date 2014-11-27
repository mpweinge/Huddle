//
//  HDLEventsViewController.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLEventsViewController : UIViewController < UITableViewDataSource, UITableViewDelegate>

-(instancetype) initWithDate:(NSString *)date huddleNum:(int) huddleNum;

@end