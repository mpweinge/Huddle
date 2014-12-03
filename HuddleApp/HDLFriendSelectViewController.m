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
#import "HDLDatabaseManager.h"

@implementation HDLFriendSelectViewController
{
  NSDate *_selectedDate;
  NSString *_selectedTime;
  
  NSMutableSet *_selectedRows;
}

-(instancetype) initWithDate: (NSDate *) date selectedTime: (NSString *)time
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
  
  _selectedDate = date;
  _selectedTime = time;
  _selectedRows = [NSMutableSet set];
  
  return self;
}

-(id) init
{
  assert(0);
  
  return self;
}

-(void) BackClicked
{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void) createClicked: (UIResponder *) responder
{
  //Add into SQL database here
  HDLHuddleObject *_currHuddle = [[HDLDatabaseManager getSharedInstance] saveHuddle:_selectedDate withVotes:@[] withEvents:@[] withInvitees:_selectedRows];
  
  
  HDLEventsViewController * calendarSelectView = [[HDLEventsViewController alloc] initWithHuddle:_currHuddle];
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
  HDLFriendSelectCell * currCell = (HDLFriendSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
  [currCell toggleCheckmark];
  
  if ([_selectedRows containsObject:currCell]) {
    [_selectedRows removeObject:[currCell name] ];
  } else {
    [_selectedRows addObject:[currCell name] ];
  }
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
