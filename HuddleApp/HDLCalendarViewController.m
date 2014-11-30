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
  
  self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  self.calendarMenuView.calendarManager = self.calendar;
  
  self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, 55, 320, 300)];
  self.calendarContentView.calendarManager = self.calendar;
  
  [self.view addSubview:self.calendarMenuView];
  [self.view addSubview:self.calendarContentView];
  
  [self.calendar setMenuMonthsView:self.calendarMenuView];
  [self.calendar setContentView:self.calendarContentView];
  [self.calendar setDataSource:self];
  
  // Add horizontal line between calendar and time of day
  UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 1)];
  separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
  [self.view addSubview:separator];
  
  // Buttons to choose time of day
  CGRect myFrame = CGRectMake(110.0f, 310.0f, 100.0f, 240.0f); // Will be rotated
  NSArray *mySegments = [[NSArray alloc] initWithObjects: @"Morning", @"Afternoon", @"Evening", nil];
  self.timeOfDaySelection = [[UISegmentedControl alloc] initWithItems:mySegments];
  [self.timeOfDaySelection setMultipleTouchEnabled:TRUE];
  self.timeOfDaySelection.frame = myFrame;
  [self.timeOfDaySelection addTarget:self action:@selector(chooseTimeOfDay:)
                    forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.timeOfDaySelection];
  
  // Make it a vertical list
  self.timeOfDaySelection.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
  NSArray *arr = [self.timeOfDaySelection subviews];
  for (int i = 0; i < [arr count]; i++) {
    UIView *v = (UIView*) [arr objectAtIndex:i];
    NSArray *subarr = [v subviews];
    for (int j = 0; j < [subarr count]; j++) {
      if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]]) {
        UILabel *l = (UILabel*) [subarr objectAtIndex:j];
        l.transform = CGAffineTransformMakeRotation(- M_PI / 2.0);
      }
    }
  }
  
  
  [self.calendar reloadAppearance];
  
}

// Callback for time of day selection
- (void) chooseTimeOfDay:(UISegmentedControl *)paramSender{
  
  //check if its the same control that triggered the change event
  if ([paramSender isEqual:self.timeOfDaySelection]){
    
    //get index position for the selected control
    NSInteger selectedIndex = [paramSender selectedSegmentIndex];
    
    //get the Text for the segmented control that was selected
    NSString *myChoice =
    [paramSender titleForSegmentAtIndex:selectedIndex];
    //let log this info to the console
    NSLog(@"Segment at position %li with %@ text is selected", (long)selectedIndex, myChoice);
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
