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
@property (nonatomic, strong) UISegmentedControl *timeOfDaySelection;


@property (strong, nonatomic) JTCalendar *calendar;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;
@property bool morningPressed;
@property bool afternoonPressed;
@property bool eveningPressed;

@end
