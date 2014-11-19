//
//  HDLMainScrollView.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-18.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLMainScrollView.h"

@implementation HDLMainScrollView

- (UITableViewCell *) tableView: (UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *myIdentifier = @"HomeCells";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
  }
  return cell;
}

@end
