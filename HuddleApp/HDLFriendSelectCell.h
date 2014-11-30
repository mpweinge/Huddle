//
//  HDLFriendSelectCell.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-29.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLFriendSelectCell : UITableViewCell

-(instancetype) initWithName:(NSString *)name;

-(void) toggleCheckmark;

@end
