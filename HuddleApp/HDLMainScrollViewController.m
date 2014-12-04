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
  BOOL hasPanned;
  BOOL donePanning;
  
  NSDate *_donePanTime;
  
  UITableView * mainTableView;
}

-(id) init {
  self = [super init];
  UIScreen * mainScreen = [UIScreen mainScreen];
  mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, [mainScreen bounds].size.height - 75)];
  [self.view addSubview:mainTableView];
  mainTableView.dataSource = self;
  mainTableView.delegate = self;
  self.title = @"Huddle";
  
  hasPanned = false;
  donePanning = false;
  
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
  
    NSArray * _voteOne = [votes[0] componentsSeparatedByString:@":"];
    
    NSArray *_voteTwo = [votes[1] componentsSeparatedByString:@":"];
    
    NSArray *_voteThree = [votes[2] componentsSeparatedByString:@":"];
    
    int voteOneCount = [votes[0] rangeOfString:@"."].location == NSNotFound ? 0 : _voteOne.count;
    int voteTwoCount = [votes[1] rangeOfString:@"."].location == NSNotFound ? 0 : _voteTwo.count;
    int voteThreeCount = [votes[2] rangeOfString:@"."].location == NSNotFound ? 0 : _voteThree.count;
    
    NSString * backgroundString;
    
    if (voteOneCount > voteTwoCount)
    {
      if (voteThreeCount > voteOneCount)
      {
        backgroundString = @"Basketball";
      } else {
        backgroundString = @"Salsa";
      }
    } else {
      if (voteThreeCount > voteTwoCount)
      {
        backgroundString = @"Basketball";
      } else {
        backgroundString = @"Hockey";
      }
    }
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:[currHuddle dateString]
                                       attendingString: [currHuddle inviteesString]
                                      backgroundString: backgroundString
                                                   row:[indexPath row]];
  } else {
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:[currHuddle dateString]
                                       attendingString: [currHuddle inviteesString]
                                      backgroundString: @"Beach"
                                                   row:[indexPath row]];
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
  
  return newCell;
}

-(void) isPanning: (HDLHomeScreenCell *)cell
{
  hasPanned = true;
  donePanning = false;
}

-(void) donePanning: (HDLHomeScreenCell *)cell
{
  donePanning = true;
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
  
  if (hasPanned)
  {
    if (donePanning)
    {
      NSLog(@" cell clicked");
      HDLHomeScreenCell * homeCell = [tableView cellForRowAtIndexPath:indexPath];
      [homeCell animateBack];
      donePanning = false;
      hasPanned = false;
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
}

-(void) viewWillAppear:(BOOL)animated
{
  //Time to read from database
  _huddles = [[HDLDatabaseManager getSharedInstance] loadHuddles];
}

@end
