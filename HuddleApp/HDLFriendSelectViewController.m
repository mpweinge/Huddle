//
//  HDLFriendSelectViewController.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLFriendSelectViewController.h"
#import "HDLEventsViewController.h"
#import "HDLFriendSelectCell.h"

@implementation HDLFriendSelectViewController

-(id) init
{
  self = [super init];
  UIScreen * mainScreen = [UIScreen mainScreen];
  UITableView * mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, 350)];
  [self.view addSubview:mainTableView];
  mainTableView.dataSource = self;
  mainTableView.delegate = self;
  self.title = @"Friends";
  
  UIButton * createHuddleButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [createHuddleButton setTitle:@"Send Invites" forState:UIControlStateNormal];
  [createHuddleButton sizeToFit];
  createHuddleButton.center = CGPointMake([mainScreen bounds].size.width / 2, 375);
  
  [createHuddleButton addTarget:self action:@selector(createClicked:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:createHuddleButton];
  
  //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(BackClicked)];
  //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(EditClicked)];
  
  return self;
}

-(void) BackClicked
{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void) createClicked: (UIResponder *) responder
{
  HDLEventsViewController * calendarSelectView = [[HDLEventsViewController alloc] initWithDate:@"TEST" huddleNum:0];
  [self.navigationController pushViewController:calendarSelectView animated:YES];
}

-(void) viewDidLoad
{
  
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Hardcoded here
  return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell* currCell = [tableView cellForRowAtIndexPath:indexPath];
  [(HDLFriendSelectCell *)currCell toggleCheckmark];
}

- (UITableViewCell *) tableView: (UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *tableViewIdentifier = @"HomeTableCells";
  
  HDLFriendSelectCell * newCell;
  
  int i = [indexPath row];
  NSString *name;
  
  switch (i) {
    case 0:
      name = @"James Landay";
      break;
    case 1:
      name = @"Michael Weingert";
      break;
    case 2:
      name = @"Joe Polin";
      break;
    case 3:
      name = @"Nicole Zhu";
      break;
    case 4:
      name = @"Nadav Lidor";
      break;
    case 5:
      name = @"James Bond";
      break;
    case 6:
      name = @"Miley Cyrus";
      break;
    default:
      name = @"Brandon Evans";
      break;
  }

  newCell = [[HDLFriendSelectCell alloc] initWithName: name];
  
  return newCell;
}

@end
