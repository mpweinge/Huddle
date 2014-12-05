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
  HDLHuddleObject *_currHuddle = [[HDLDatabaseManager getSharedInstance] saveHuddle:_selectedDate withVotes:@[@"", @"", @""] withEvents:@[@"Salsa", @"Hockey", @"Basketball"] withInvitees:_selectedRows withTimePeriod:_selectedTime];
  
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
  return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  HDLFriendSelectCell * currCell = (HDLFriendSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
  [currCell toggleCheckmark];
  
  if ([_selectedRows containsObject:[currCell photoURL]] ) {
    [_selectedRows removeObject:[currCell photoURL] ];
    if ([_selectedRows count] == 0)
    {
      UIScreen * mainScreen = [UIScreen mainScreen];
      [createHuddleButton setTitle:@"     Go Solo     " forState:UIControlStateNormal];
      createHuddleButton.center = CGPointMake([mainScreen bounds].size.width / 2, [mainScreen bounds].size.height - 90);
    }
  } else {
    [_selectedRows addObject:[currCell photoURL] ];
    
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
  NSString *namePhotoURL;
  
  switch (i) {
    case 0:
      name = @"Nadav Lidor";
      namePhotoURL = @"Facebook_NadavLidor.png";
      break;
    case 1:
      name = @"Joe Polin";
      namePhotoURL = @"Facebook_JoePolin.jpg";
      break;
    case 2:
      name = @"Brandon Evans";
      namePhotoURL = @"Facebook_BrandonEvans.jpg";
      break;
    case 3:
      name = @"James Stir";
      namePhotoURL = @"Facebook_RandomGuy.jpg";
      break;
    case 4:
      name = @"James Bond";
      namePhotoURL = @"Facebook_JamesBond.png";
      break;
    case 5:
      name = @"Miley Cyrus";
      namePhotoURL = @"Facebook_Miley.png";
      break;
    case 6:
      name = @"President Obama";
      namePhotoURL = @"Facebook_Obama.png";
      break;
    case 7:
      name = @"Brad Pitt";
      namePhotoURL = @"Facebook_BradPitt.png";
      break;
    case 8:
      name = @"Ban Ki-Moon";
      namePhotoURL = @"Facebook_BanKiMoon.png";
      break;
    case 9:
      name = @"Macklemore";
      namePhotoURL = @"Facebook_Macklemore.png";
      break;
    case 10:
      name = @"Amy Winehouse";
      namePhotoURL = @"Facebook_AmyWinehouse.png";
      break;
    case 11:
      name = @"John Hennessy";
      namePhotoURL = @"Facebook_JohnHennessy.png";
      break;
    default:
      assert(0);
      //name = @"President Obama";
      break;
  }

  newCell = [[HDLFriendSelectCell alloc] initWithName: name photoURL: namePhotoURL];
  
  return newCell;
}

@end
