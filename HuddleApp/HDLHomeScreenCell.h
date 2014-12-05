//
//  HDLHomeScreenCell.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-26.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDLHomeScreenCell;

@protocol HDLHomeScreenCellDelegate

@required
  -(void) isPanning: (HDLHomeScreenCell *)cell;
  -(void) donePanning: (HDLHomeScreenCell *)cell;
  -(void) deleteRowClicked: (HDLHomeScreenCell *)cell;
@end

@interface HDLHomeScreenCell : UITableViewCell

@property (nonatomic, retain) id<HDLHomeScreenCellDelegate> delegate;

-(instancetype) initWithStyle: (UITableViewCellStyle) style
              reuseIdentifier: (NSString *) reuseIdentifier
                   dateString: (NSString *) date
              attendingString: (NSString *) attending
             backgroundString: (NSString *) background
                          row: (int) row
                        isNew: (BOOL) isNew
                   timeString: (NSString *)time;

-(void) addUserCircle:(NSString *) userImageTitle withTotalPhotos:(int) totalPhotos;

-(void) animateBack;

-(int) getRow;

@end
