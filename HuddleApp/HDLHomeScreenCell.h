//
//  HDLHomeScreenCell.h
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-26.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLHomeScreenCell : UITableViewCell

-(instancetype) initWithStyle: (UITableViewCellStyle) style
              reuseIdentifier: (NSString *) reuseIdentifier
                   dateString: (NSString *) date
              attendingString: (NSString *)attending
             backgroundString: (NSString *)background;

@end
