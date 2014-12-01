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

@implementation HDLEventsViewController
{
  NSString *_date;
  NSMutableSet * _invitees;
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
  }
  return self;
}

-(void) HomeClicked
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  
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
  
  HDLEventTableViewCell * newCell;
  
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
