//
//  HDLCalendarViewController.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLCalendarViewController.h"
#import "HDLFriendSelectViewController.h"

@implementation HDLCalendarViewController

-(id) init
{
  self = [super init];
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

-(void) viewDidLoad
{
  UILabel * calendarLabel = [[UILabel alloc] init];
  calendarLabel.text = @"I'm a Calendar";
  calendarLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
  calendarLabel.center = CGPointMake(50, 150);
  calendarLabel.textColor = [UIColor blackColor];
  [calendarLabel sizeToFit];
  [self.view addSubview:calendarLabel];
}

@end
