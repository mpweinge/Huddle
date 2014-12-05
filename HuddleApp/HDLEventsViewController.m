//
//  HDLEventsViewController.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLEventsViewController.h"
#import "HDLEventDetailViewController.h"
#import "HDLEventTableViewCell.h"
#import "HDLDatabaseManager.h"

#include <stdlib.h>

const int MAX_VOTES = 5;

@implementation HDLEventsViewController 
{
  HDLHuddleObject *_huddle;
  
  NSTimer *_voteTimer;
  
  NSMutableDictionary *_cells;
  
  int _numVotes;
  
  //Need to store votes here and then update the database
  NSMutableArray *_votes; // Cell # -> String of voters
  NSMutableArray *_events;
  
  NSArray *_voteOne;
  NSArray *_voteTwo;
  NSArray *_voteThree;
  
  UITableView * mainTableView;
  
  int _numInvitees;
}

-(instancetype) initWithHuddle:(HDLHuddleObject *)huddle
{
  self = [super init];
  if (self)
  {
    _huddle = huddle;
    
    UIScreen * mainScreen = [UIScreen mainScreen];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, [mainScreen bounds].size.height - 100)];
    [self.view addSubview:mainTableView];
    self.title = @"Huddle";
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(AddClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(EditClicked)];
    
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"HomeButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HomeClicked)];
    
    //Create a timer here
    _voteTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(simulateVote)
                                            userInfo:nil
                                             repeats:YES];
    
    _cells = [NSMutableDictionary dictionary];
    
    //3 empty strings
    _votes = [NSMutableArray array];
    
    //Initialize this with the objects parsed from the votestring
    NSArray *votes = [huddle votes];
    
    _voteOne = [votes[0] componentsSeparatedByString:@":"];
    
    _voteTwo = [votes[1] componentsSeparatedByString:@":"];
    
    _voteThree = [votes[2] componentsSeparatedByString:@":"];
    
    
    int voteOneCount = [votes[0] rangeOfString:@"."].location == NSNotFound ? 0 : _voteOne.count;
    int voteTwoCount = [votes[1] rangeOfString:@"."].location == NSNotFound ? 0 : _voteTwo.count;
    int voteThreeCount = [votes[2] rangeOfString:@"."].location == NSNotFound ? 0 : _voteThree.count;
    
    _numVotes = voteOneCount + voteTwoCount + voteThreeCount;
    
    _numInvitees = [[huddle invitees] count];
    
    if (_numVotes > _numInvitees)
    {
      [_voteTimer invalidate];
      _voteTimer = nil;
    }
    
    [_votes addObject:votes[0]];
    [_votes addObject:votes[1]];
    [_votes addObject:votes[2]];
    
     NSArray *events = [huddle events];
    
    _events = [NSMutableArray array];
    [_events addObject:events[0]];
    [_events addObject:events[1]];
    [_events addObject:events[2]];
    
  }
  return self;
}

-(void) heartClicked:(HDLEventTableViewCell *)tableCell withActive:(BOOL) isActive
{
  //Need to add it to the votes for that cell
  int i;
  for (i = 0; i < 3; i++)
  {
    HDLEventTableViewCell * currCell = [_cells objectForKey:[NSNumber numberWithInt:i]];
    if (currCell == tableCell)
    {
      break;
    }
  }
  
  NSMutableString * currCellVotes = [NSMutableString stringWithString:_votes[i]];
  currCellVotes = [NSMutableString stringWithString:[currCellVotes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
  if (isActive)
  {
    //Add ": me"
    if (currCellVotes.length > 0)
    {
      [currCellVotes appendString:@": me.png"];
    } else
    {
      [currCellVotes appendString:@"me.png"];
    }
  } else {
    //Search for ": me" and then remove it
    NSRange meRange = [currCellVotes rangeOfString:@": me.png"];
    
    //If ": me" not found, then remove "me"
    if (meRange.location == NSNotFound)
    {
      meRange = [currCellVotes rangeOfString:@"me.png"];
    }
    
    [currCellVotes deleteCharactersInRange:meRange];
  }
  _votes[i] = currCellVotes;
}

-(void) simulateVote
{
  //Pick a random cell
  int randCell = arc4random_uniform(3);
  HDLEventTableViewCell * currCell = [_cells objectForKey:[NSNumber numberWithInt:randCell]];
  NSMutableString * currCellVotes = [NSMutableString stringWithString:_votes[randCell]];
  currCellVotes = [NSMutableString stringWithString:[currCellVotes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
  
  if (currCellVotes.length > 0)
  {
    [currCellVotes appendString:@": "];
  }
  
  NSString * photoURL = [_huddle invitees][_numVotes];
  photoURL = [photoURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  [currCell addUserPhoto:photoURL];
  [currCellVotes appendString:photoURL];
  
  _votes[randCell] = currCellVotes;
  
  _numVotes++;
  if (_numVotes >= _numInvitees)
  {
    [_voteTimer invalidate];
    _voteTimer = nil;
  }
}

-(void) HomeClicked
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  
  //Invalidate the timer
  [_voteTimer invalidate];
  _voteTimer = nil;
  
  //Save the thing (well update it)
  [[HDLDatabaseManager getSharedInstance] updateHuddle:_huddle withDate:[_huddle date] withVotes:_votes withEvents:_events ];
}

-(id) init {
  self = [super init];
  //Not the initializer we want to use here
  assert(0);
  return self;
}

-(void) viewDidLoad
{

}

- (UITableViewCell *) tableView: (UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *tableViewIdentifier = @"HomeTableCells";
  
  HDLEventTableViewCell * newCell = [_cells objectForKey:[NSNumber numberWithInt:[indexPath row]]];
  
  if (newCell)
    return newCell;
  
  NSString * titleString;
  NSString * locationString;
  
  if ( [_events[[indexPath row]] rangeOfString:@"Salsa"].location != NSNotFound)
  {
    titleString = @"Salsa Dancing";
    locationString = @"Mango Bar";
  } else if ([_events[[indexPath row]] rangeOfString:@"Basketball"].location != NSNotFound)
  {
    titleString = @"Pickup Basketball";
    locationString = @"Rains Courts";
  } else {
    titleString = @"Sharks vs. Canucks";
    locationString = @"SAP Center";
  }
  
  if ([indexPath row] == 0)
  {
    newCell = [[HDLEventTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            title:titleString
                                               location: locationString
                                          attendingList: @[@"MW", @"BE", @"JP", @"JL"]
                                      backgroundString: [_events[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]];
    
    for ( NSString * voteOneStrings in _voteOne)
    {
      NSRange meRange = [voteOneStrings rangeOfString:@"me"];
      if (meRange.location == NSNotFound)
      {
        [newCell addUserPhoto: [voteOneStrings stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
      } else {
        [newCell heartWasClicked];
      }
    }
    
  } else if ([indexPath row] == 1) {
    //Second one is some ferris wheel
    newCell = [[HDLEventTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier:tableViewIdentifier
                                                  title:titleString
                                               location: locationString
                                          attendingList: @[@"MW", @"BE", @"JP", @"JL"]
                                       backgroundString: [_events[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]];
    
    for ( NSString * voteOneStrings in _voteTwo)
    {
      NSRange meRange = [voteOneStrings rangeOfString:@"me"];
      if (meRange.location == NSNotFound)
      {
        [newCell addUserPhoto: [voteOneStrings stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
      } else {
        [newCell heartWasClicked];
      }
    }
    
  } else {
    //Third one is beach
    newCell = [[HDLEventTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier:tableViewIdentifier
                                                  title:titleString
                                               location: locationString
                                          attendingList: @[@"MW", @"BE", @"JP", @"JL"]
                                       backgroundString: [_events[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]];
    
    for ( NSString * voteOneStrings in _voteThree)
    {
      NSRange meRange = [voteOneStrings rangeOfString:@"me"];
      if (meRange.location == NSNotFound)
      {
        [newCell addUserPhoto: [voteOneStrings stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
      } else {
        [newCell heartWasClicked];
      }
    }
  }
  
  [_cells setObject:newCell forKey:[NSNumber numberWithInt:[indexPath row]]];
  
  newCell.delegate = self;
  newCell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return newCell;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Hardcoded here
  return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //From here load the huddle specific view (events view controller)
  /*HDLEventsViewController* huddleViewController;
  if ([indexPath row] == 0) {
    huddleViewController = [[HDLEventDetailViewController alloc] initWithDate:@"Friday (11/14)" huddleNum:0];
  } else if ([indexPath row] == 1) {
    huddleViewController = [[HDLEventDetailViewController alloc] initWithDate:@"Saturday (11/15)" huddleNum:1];
  } else {
    huddleViewController = [[HDLEventDetailViewController alloc] initWithDate:@"Sunday (11/16)" huddleNum:2];
  }
  
  [self.navigationController pushViewController:huddleViewController animated:YES];*/
}

-(void) viewWillAppear:(BOOL)animated
{
  [mainTableView setNeedsDisplay];
}

@end
