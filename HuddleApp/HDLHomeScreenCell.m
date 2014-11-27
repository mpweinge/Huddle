//
//  HDLHomeScreenCell.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-26.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLHomeScreenCell.h"

@implementation HDLHomeScreenCell
{
  NSString * _dateString;
  NSString * _attendingPeople;
  NSString * _backgroundImageDescriptor;
  
  UILabel * _dateLabel;
  UILabel *_attendingPeopleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle: (UITableViewCellStyle) style
              reuseIdentifier: (NSString *) reuseIdentifier
                   dateString: (NSString *) date
              attendingString: (NSString *)attending
             backgroundString: (NSString *)background
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self)
  {
    _dateString = date;
    _attendingPeople = attending;
    _backgroundImageDescriptor = background;
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -20, 300, 100)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0];
    _dateLabel.text = _dateString;
    [self addSubview:_dateLabel];
    
    _attendingPeopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 350, 100)];
    _attendingPeopleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    _attendingPeopleLabel.text = _attendingPeople;
    [self addSubview:_attendingPeopleLabel];
  }
  
  return self;
}

@end
