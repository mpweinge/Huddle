//
//  HDLEventTableViewCell.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-26.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDLEventTableViewCell;

@protocol HDLEventTableViewCellDelegate

@required
-(void) heartClicked:(HDLEventTableViewCell *)table withActive:(BOOL) isActive;

@end

@interface HDLEventTableViewCell : UITableViewCell

@property (nonatomic, retain) id<HDLEventTableViewCellDelegate> delegate;

-(instancetype) initWithStyle:(UITableViewCellStyle) style
              reuseIdentifier:(NSString *) reuseIdentifier
                        title:(NSString *) title
                     location:(NSString *) location
                attendingList:(NSArray *) attendingList
             backgroundString:(NSString *)backgroundString;

-(void) addUserPhoto:(NSString *)userString;

-(void) heartWasClicked;

@end
