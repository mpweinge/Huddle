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
  
  UIButton * createHuddleButton;
}

-(instancetype) initWithDate: (NSDate *) date selectedTime: (NSString *)time
{
  self = [super init];
  UIScreen * mainScreen = [UIScreen mainScreen];
  UITableView * mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, [mainScreen bounds].size.height - 85)];
  [self.view addSubview:mainTableView];
  mainTableView.dataSource = self;
  mainTableView.delegate = self;
  self.title = @"Friends";
  
  createHuddleButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [createHuddleButton setTitle:@"      Go Solo      " forState:UIControlStateNormal];
  [createHuddleButton sizeToFit];
  createHuddleButton.center = CGPointMake([mainScreen bounds].size.width / 2, [mainScreen bounds].size.height - 90);
  
  createHuddleButton.layer.borderWidth = 1.0;
  createHuddleButton.layer.borderColor = [UIColor blackColor].CGColor;
  
  [createHuddleButton addTarget:self action:@selector(createClicked:) forControlEvents:UIControlEventTouchUpInside];
  //[self.view addSubview:createHuddleButton];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"ForwardIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(createClicked:)];
  
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
  HDLHuddleObject *_currHuddle = [[HDLDatabaseManager getSharedInstance] saveHuddle:_selectedDate withVotes:@[@"", @"", @""] withEvents:@[@"Salsa", @"Hockey", @"Basketball"] withInvitees:_selectedRows];
  
  HDLEventsViewController * calendarSelectView = [[HDLEventsViewController alloc] initWithHuddle:_currHuddle];
  [self.navigationController pushViewController:calendarSelectView animated:YES];
}

-(void) viewDidLoad
{
  self.navigationController.navigationBar.topItem.title = @"";
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
  
  if ([_selectedRows containsObject:[currCell name]] ) {
    [_selectedRows removeObject:[currCell name] ];
    if ([_selectedRows count] == 0)
    {
      UIScreen * mainScreen = [UIScreen mainScreen];
      [createHuddleButton setTitle:@"     Go Solo     " forState:UIControlStateNormal];
      createHuddleButton.center = CGPointMake([mainScreen bounds].size.width / 2, [mainScreen bounds].size.height - 90);
    }
  } else {
    [_selectedRows addObject:[currCell name] ];
    
    UIScreen * mainScreen = [UIScreen mainScreen];
    [createHuddleButton setTitle:@"Send Invites" forState:UIControlStateNormal];
    createHuddleButton.center = CGPointMake([mainScreen bounds].size.width / 2, [mainScreen bounds].size.height - 90);
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
      name = @"Nadav Lidor";
      break;
    case 1:
      name = @"Michael Weingert";
      break;
    case 2:
      name = @"Joe Polin";
      break;
    case 3:
      name = @"Brandon Evans";
      break;
    case 4:
      name = @"James Stir";
      break;
    case 5:
      name = @"James Bond";
      break;
    case 6:
      name = @"Miley Cyrus";
      break;
    default:
      name = @"Obama";
      break;
  }

  newCell = [[HDLFriendSelectCell alloc] initWithName: name];
  
  return newCell;
}

@end
