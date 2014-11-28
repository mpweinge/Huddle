//
//  HDLCalendarViewController.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "JTCalendar.h"

@interface HDLCalendarViewController : UIViewController<JTCalendarDataSource>

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;

@end
