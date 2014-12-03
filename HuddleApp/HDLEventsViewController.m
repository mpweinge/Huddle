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

#include <stdlib.h>

const int MAX_VOTES = 5;

@implementation HDLEventsViewController
{
  NSString *_date;
  NSMutableSet * _invitees;
  
  NSTimer *_voteTimer;
  
  NSMutableDictionary *_cells;
  
  int _numVotes;
}

-(instancetype) initWithDate:(NSString *)date invitees:(NSMutableSet *) invitees;
{
  self = [super init];
  if (self)
  {
    _date = date;
    _invitees = invitees;
    
    UIScreen * mainScreen = [UIScreen mainScreen];
    UITableView * mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, [mainScreen bounds].size.height - 100)];
    [self.view addSubview:mainTableView];
    self.title = @"Huddle";
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(AddClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(EditClicked)];
    
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"HomeButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HomeClicked)];
    
    //Create a timer here
    _voteTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(simulateVote)
                                            userInfo:nil
                                             repeats:YES];
    
    _cells = [NSMutableDictionary dictionary];
    
    _numVotes = 0;
  }
  return self;
}

-(void) simulateVote
{
  //Pick a random cell
  int randCell = arc4random_uniform(3);
  HDLEventTableViewCell * currCell = [_cells objectForKey:[NSNumber numberWithInt:randCell]];
  
  switch (_numVotes)
  {
    case 0:
      [currCell addUserPhoto:@"Facebook_RandomGuy.jpg"];
      break;
    case 1:
      [currCell addUserPhoto:@"Facebook_RandomGuy2.jpg"];
      break;
    case 2:
      [currCell addUserPhoto:@"Facebook_BrandonEvans.jpg"];
      break;
    case 3:
      [currCell addUserPhoto:@"Facebook_JoePolin.jpg"];
      break;
    case 4:
      [currCell addUserPhoto:@"Facebook_NadavLidor.jpg"];
      break;
    default:
      assert(0);
  }
  
  _numVotes++;
  if (_numVotes > 4)
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
  
  if ([indexPath row] == 0)
  {
    //First one is the salsa dancing
    //Date = Friday, 11/14
    //Attending is Michael Weingert, Brandon Evans, Joe Polin, Justin Stir, good enough
    newCell = [[HDLEventTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            title:@"Salsa Dancing"
                                               location: @"Mango Bar"
                                          attendingList: @[@"MW", @"BE", @"JP", @"JL"]
                                      backgroundString: @"Salsa"];
    
  } else if ([indexPath row] == 1) {
    //Second one is some ferris wheel
    newCell = [[HDLEventTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier:tableViewIdentifier
                                                  title:@"Sharks vs. Canucks"
                                               location: @"SAP Center"
                                          attendingList: @[@"MW", @"BE", @"JP", @"JL"]
                                       backgroundString: @"Hockey"];
  } else {
    //Third one is beach
    newCell = [[HDLEventTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier:tableViewIdentifier
                                                  title:@"Pickup Basketball"
                                               location: @"Rains Courts"
                                          attendingList: @[@"MW", @"BE", @"JP", @"JL"]
                                       backgroundString: @"Basketball"];
  }
  
  [_cells setObject:newCell forKey:[NSNumber numberWithInt:[indexPath row]]];
  
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

@end
