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

@implementation HDLMainScrollViewController
{
  
}

-(id) init {
  self = [super init];
  UIScreen * mainScreen = [UIScreen mainScreen];
  UITableView * mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [mainScreen bounds].size.width, [mainScreen bounds].size.height - 75)];
  [self.view addSubview:mainTableView];
  mainTableView.dataSource = self;
  mainTableView.delegate = self;
  self.title = @"Huddle";
  
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
  
  if ([indexPath row] == 0)
  {
    //First one is the salsa dancing
    //Date = Friday, 11/14
    //Attending is Michael Weingert, Brandon Evans, Joe Polin, Justin Stir, good enough
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:@"Friday (11/14)"
                                       attendingString: @"Michael Weingert, Brandon Evans, Joe Polin, Justin Stir"
                                      backgroundString: @"Salsa"];
    
  } else if ([indexPath row] == 1) {
    //Second one is some ferris wheel
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:@"Saturday (11/15)"
                                       attendingString: @"James Bond, Harry Potter, Nicole Zhu"
                                      backgroundString: @"Wheel"];
  } else {
    //Third one is beach
    newCell = [[HDLHomeScreenCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:tableViewIdentifier
                                            dateString:@"Sunday (11/16)"
                                       attendingString: @"Solo"
                                      backgroundString: @"Beach"];
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
  return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //From here load the huddle specific view (events view controller)
  HDLEventsViewController* huddleViewController;
  if ([indexPath row] == 0) {
    huddleViewController = [[HDLEventsViewController alloc] initWithDate:@"Friday (11/14)" huddleNum:0];
  } else if ([indexPath row] == 1) {
    huddleViewController = [[HDLEventsViewController alloc] initWithDate:@"Saturday (11/15)" huddleNum:1];
  } else {
    huddleViewController = [[HDLEventsViewController alloc] initWithDate:@"Sunday (11/16)" huddleNum:2];
  }
  
  [self.navigationController pushViewController:huddleViewController animated:YES];
}

-(void) createClicked: (UIResponder *) responder
{
  HDLCalendarViewController * calendarSelectView = [[HDLCalendarViewController alloc] init];
  [self.navigationController pushViewController:calendarSelectView animated:YES];
}

-(void) viewDidLoad
{

}

@end
