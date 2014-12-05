//
//  HDLFriendSelectCell.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-29.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLFriendSelectCell.h"

@implementation HDLFriendSelectCell
{
  UILabel *_nameLabel;
  NSString *_name;
  NSString *_photoURL;
  
  UIImageView *_checkmarkView;
  
  BOOL bIsCheckSelected;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithName:(NSString *)name
                    photoURL:(NSString *)photoURL;
{
  self = [super init];
  if (self)
  {
    _name = name;
    _photoURL = photoURL;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 350, 50)];
    _nameLabel.text = name;
    _nameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:19.0];
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    
    _checkmarkView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 25, 25)];
    _checkmarkView.image = [UIImage imageNamed:@"CheckmarkIcon.png"];
    _checkmarkView.alpha = 0.0;
    [self addSubview:_checkmarkView];
    
    bIsCheckSelected = false;
  }
  return self;
}

-(void) toggleCheckmark
{
  if (bIsCheckSelected)
  {
    _checkmarkView.alpha = 0.0;
    bIsCheckSelected = false;
  } else {
    bIsCheckSelected = true;
    _checkmarkView.alpha = 1.0;
  }
}

-(NSString *)name
{
  return _name;
}

-(NSString *)photoURL
{
  return _photoURL;
}

@end
