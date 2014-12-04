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
#import "GlobalSettings.h"

@interface HDLCalendarViewController ()
{
  NSDate *_selectedDate;
  NSString *_selectedTime;
}

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
  if (self.calendar.currentDateSelected) {
    HDLFriendSelectViewController * friendViewController = [[HDLFriendSelectViewController alloc] initWithDate: _selectedDate selectedTime: _selectedTime];
      [self.navigationController pushViewController:friendViewController animated:YES];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Date Chosen" message:@"You can change month by swiping over the calendar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
  }
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
  
  self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  self.calendarMenuView.calendarManager = self.calendar;
  
  self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, 55, 320, 300)];
  self.calendarContentView.calendarManager = self.calendar;
  self.calendarContentView.showsHorizontalScrollIndicator = false;
  
  [self.view addSubview:self.calendarMenuView];
  [self.view addSubview:self.calendarContentView];
  
  [self.calendar setMenuMonthsView:self.calendarMenuView];
  [self.calendar setContentView:self.calendarContentView];
  [self.calendar setDataSource:self];
  
  // Add horizontal line between calendar and time of day
  UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 1)];
  separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
  [self.view addSubview:separator];
  
  // Buttons for time of day
  self.button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.button1 addTarget:self action:@selector(morningPress) forControlEvents:UIControlEventTouchUpInside];
  [self.button1 setTitle:@"Morning" forState:UIControlStateNormal];
  self.button1.frame = CGRectMake(80.0, 380.0, 160.0, 31.0);
  [self.button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  //button.layer.borderColor =
  [self.view addSubview:self.button1];
  
  self.button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.button2 addTarget:self action:@selector(afternoonPress) forControlEvents:UIControlEventTouchUpInside];
  [self.button2 setTitle:@"Afternoon" forState:UIControlStateNormal];
  self.button2.frame = CGRectMake(80.0, 410, 160.0, 31.0);
  [self.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  //button.layer.borderColor =
  [self.view addSubview:self.button2];
  
  self.button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.button3 addTarget:self action:@selector(eveningPress) forControlEvents:UIControlEventTouchUpInside];
  [self.button3 setTitle:@"Evening" forState:UIControlStateNormal];
  self.button3.frame = CGRectMake(80.0, 440, 160.0, 31.0);
  [self.button3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  //button.layer.borderColor =
  [self.view addSubview:self.button3];
  
  self.morningPressed = false;
  self.afternoonPressed = false;
  self.eveningPressed = false;
  
  
  [self.calendar reloadAppearance];
  
}

// Time of day button(s) callbacks
- (void)morningPress
{
  NSLog(@"Morning touched.");
  self.morningPressed = !self.morningPressed;
  if(!self.morningPressed) {
    [self.button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  }
  else {
    [self.button1 setTitleColor:titleHuddleColor forState:UIControlStateNormal];
   
  }
}

- (void)afternoonPress
{
  NSLog(@"Afternoon touched.");
  self.afternoonPressed = !self.afternoonPressed;
  if(!self.afternoonPressed) {
    [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  }
  else {
    [self.button2 setTitleColor:titleHuddleColor forState:UIControlStateNormal];
  }
}

- (void)eveningPress
{
  NSLog(@"Evening touched.");
  self.eveningPressed = !self.eveningPressed;
  if(!self.eveningPressed) {
    [self.button3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  }
  else {
    [self.button3 setTitleColor:titleHuddleColor forState:UIControlStateNormal];
  }
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
  return 0;//(rand() % 10) == 1;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSLog(@"Date: %@", date);
  _selectedDate = date;
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
