//
//  HDLEventsViewController.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLEventsViewController.h"

@implementation HDLEventsViewController

-(id) init {
  self = [super init];
  UIScreen * mainScreen = [UIScreen mainScreen];
  UITableView * mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, 300)];
  [self.view addSubview:mainTableView];
  self.title = @"Huddle";
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(AddClicked)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(EditClicked)];
  
  return self;
}

-(void) viewDidLoad
{
  
}

@end
