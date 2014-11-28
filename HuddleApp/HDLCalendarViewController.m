//
//  HDLCalendarViewController.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLCalendarViewController.h"
#import "HDLFriendSelectViewController.h"
#import "JTCalendarMenuView.h"

@interface HDLCalendarViewController ()

@end

@implementation HDLCalendarViewController


-(id) init
{
    //self = [super init];
    if (self)
    {
        self.title = @"Calendar";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextClicked:)];
    }
    return self;
}

-(void) nextClicked:(UIResponder *)responder
{
    HDLFriendSelectViewController * friendViewController = [[HDLFriendSelectViewController alloc] init];
    [self.navigationController pushViewController:friendViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
  
  self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
  self.calendarMenuView.calendarManager = self.calendar;
  
  self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, 50, 300, 200)];
  self.calendarContentView.calendarManager = self.calendar;
  
  [self.view addSubview:self.calendarMenuView];
  [self.view addSubview:self.calendarContentView];
  
  [self.calendar setMenuMonthsView:self.calendarMenuView];
  [self.calendar setContentView:self.calendarContentView];
  [self.calendar setDataSource:self];
  
  [self.calendar reloadAppearance];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return (rand() % 10) == 1;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSLog(@"Date: %@", date);
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    /*[UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];*/
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

@end
