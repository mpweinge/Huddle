//
//  HDLMainScrollViewController.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLMainScrollViewController.h"
#import "HDLCalendarViewController.h"
#import "HDLHomeScreenCell.h"
#import "HDLEventsViewController.h"
#import "HDLHuddleObject.h"
#import "HDLDatabaseManager.h"

@implementation HDLMainScrollViewController
{
  NSMutableArray *_huddles;
  NSMutableArray *_hasPanned;
  NSMutableArray *_donePanning;
  
  NSDate *_donePanTime;
  
  UITableView * mainTableView;
  
  BOOL bShowFirstNew;
}

-(id) init {
  self = [super init];
  UIScreen * mainScreen = [UIScreen mainScreen];
  mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, [mainScreen bounds].size.height - 75)];
  [self.view addSubview:mainTableView];
  mainTableView.dataSource = self;
  mainTableView.delegate = self;
  self.title = @"Huddle";
  
  bShowFirstNew = YES;
  
  NSNumber * noObj = [NSNumber numberWithBool:NO];
  _hasPanned = [NSMutableArray arrayWithObjects:noObj, noObj, noObj, nil];
  _donePanning = [NSMutableArray arrayWithObjects:noObj, noObj, noObj, nil];;
  
  /*UIButton * createHuddleButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [createHuddleButton setTitle:@"Create Huddle" forState:UIControlStateNormal];
  [createHuddleButton sizeToFit];
  createHuddleButton.center = CGPointMake([mainScreen bounds].size.width / 2, [mainScreen bounds].size.height - 100);

  [createHuddleButton addTarget:self action:@selector(createClicked:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:createHuddleButton];*/
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"PlusNavButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(createClicked:)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(EditClicked)];
  
  return self;
}

- (UITableViewCell *) tableView: (UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *tableViewIdentifier = @"HomeTableCells";
  
  HDLHomeScreenCell * newCell;
  
  HDLHuddleObject * currHuddle = (HDLHuddleObject *)_huddles[[indexPath row]];
  
  //Read in the huddles here to see which event has the most votes
  NSArray * votes = [currHuddle votes];
  
  if ([votes count] > 1)
  {
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:[currHuddle dateString]
                                       attendingString: [currHuddle inviteesString]
                                      backgroundString: ([[currHuddle events][0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
                                                   row:[indexPath row]
                                                 isNew:(bShowFirstNew && ([indexPath row] == 0))];
  } else {
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:[currHuddle dateString]
                                       attendingString: [currHuddle inviteesString]
                                      backgroundString: @"Beach"
                                                   row:[indexPath row]
                                                 isNew:NO];
  }
  
  //TODO: Add user photos here
  if ([indexPath row] == 0) {
    [newCell addUserCircle:@"Facebook_NadavLidor.png" withTotalPhotos:2];
    [newCell addUserCircle:@"Facebook_RandomGuy2.jpg" withTotalPhotos:2];
  } else if ([indexPath row] == 1) {
    [newCell addUserCircle:@"Facebook_RandomGuy.jpg" withTotalPhotos:4];
    [newCell addUserCircle:@"Facebook_RandomGuy2.jpg" withTotalPhotos:4];
    [newCell addUserCircle:@"Facebook_JoePolin.jpg" withTotalPhotos:4];
    [newCell addUserCircle:@"Facebook_MichaelWeingert.jpg" withTotalPhotos:4];
  }
  
  newCell.delegate = self;
  newCell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  if (bShowFirstNew)
    bShowFirstNew = false;
  
  return newCell;
}

-(void) isPanning: (HDLHomeScreenCell *)cell
{
  _hasPanned[[cell getRow]] = [NSNumber numberWithBool:YES];
  _donePanning[[cell getRow] ] = [NSNumber numberWithBool:NO];
}

-(void) donePanning: (HDLHomeScreenCell *)cell
{
  _donePanning[[cell getRow] ] = [NSNumber numberWithBool:YES];
  _donePanTime = [NSDate date];
}

-(void) deleteRowClicked: (HDLHomeScreenCell *)cell
{
  //Get the huddle corresponding to the cell
  int row = [cell getRow];
  [[HDLDatabaseManager getSharedInstance] deleteHuddle: _huddles[row]];
  [_huddles removeObjectAtIndex:row];
  
  NSArray *paths = [mainTableView indexPathsForVisibleRows];
  
  for (NSIndexPath *path in paths) {
        if ([mainTableView cellForRowAtIndexPath:path] == cell) {
          [mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        }
  }
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Hardcoded here
  return [_huddles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDate * currentTime = [NSDate date];
  NSTimeInterval elapsedTouchTime = [currentTime timeIntervalSinceDate:_donePanTime];
  
  if (elapsedTouchTime < 0.3)
    return;
  
  if ([_hasPanned[[indexPath row]] boolValue])
  {
    if ([_donePanning[[indexPath row] ] boolValue])
    {
      NSLog(@" cell clicked");
      HDLHomeScreenCell * homeCell = [tableView cellForRowAtIndexPath:indexPath];
      [homeCell animateBack];
      _donePanning[[indexPath row] ] = [NSNumber numberWithBool:NO];
      _hasPanned[[indexPath row] ] = [NSNumber numberWithBool:NO];
      return;
    }
  }
  
  //From here load the huddle specific view (events view controller)
  HDLEventsViewController* huddleViewController;
  
  int i = [indexPath row];
  
  HDLHuddleObject * currHuddle = (HDLHuddleObject *)_huddles[i];
  
  NSDate * currDate = [currHuddle date];
  NSArray * invitees = [currHuddle invitees];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  
  huddleViewController = [[HDLEventsViewController alloc]
                          initWithHuddle:_huddles[i]];
  
  [self.navigationController pushViewController:huddleViewController animated:YES];
}

-(void) createClicked: (UIResponder *) responder
{
  HDLCalendarViewController * calendarSelectView = [[HDLCalendarViewController alloc] init];
  [self.navigationController pushViewController:calendarSelectView animated:YES];
}

-(void) viewDidLoad
{
  //Time to read from database
  _huddles = [[HDLDatabaseManager getSharedInstance] loadHuddles];
  
  //Sort the huddles by date
  [_huddles sortUsingComparator:^NSComparisonResult(HDLHuddleObject * obj1, HDLHuddleObject * obj2){
    return [obj1.date compare:obj2.date];
  }];
}

-(void) viewWillAppear:(BOOL)animated
{
  //Time to read from database
  _huddles = [[HDLDatabaseManager getSharedInstance] loadHuddles];
  
  //Sort the huddles by date
  [_huddles sortUsingComparator:^NSComparisonResult(HDLHuddleObject * obj1, HDLHuddleObject * obj2){
    return [obj1.date compare:obj2.date];
  }];
  
  [mainTableView reloadData];
}

@end
