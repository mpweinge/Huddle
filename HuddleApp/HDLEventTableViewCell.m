//
//  HDLEventTableViewCell.m
//  HuddleApp
//
//  Created by Michael Weingert on 2014-11-26.
//  Copyright (c) 2014 Michael Weingert. All rights reserved.
//

#import "HDLEventTableViewCell.h"

@implementation HDLEventTableViewCell
{
  NSString *_title;
  NSString *_location;
  
  UILabel *_titleLabel;
  UILabel *_locationLabel;
  UIScrollView * _attendingScrollView;
  NSArray * _attendingList;
  
  UIImageView *_backgroundImage;
  
  UIImageView *_circleTest;
  
  UIImageView *_starClick;
  
  UITapGestureRecognizer *_starRecognizer;
  
  BOOL _starClicked;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle) style
              reuseIdentifier:(NSString *) reuseIdentifier
                        title:(NSString *) title
                     location:(NSString *) location
                attendingList:(NSArray *) attendingList
             backgroundString:(NSString *)backgroundString
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 300, 180)];
    _backgroundImage.image = [UIImage imageNamed:@"Beach_iOS.jpg"];
    [self addSubview:_backgroundImage];
    
    _circleTest = [[UIImageView alloc] initWithFrame:CGRectMake(82, 250, 40, 40)];
    _circleTest.image = [UIImage imageNamed:@"Beach_iOS.jpg"];
    _circleTest.layer.cornerRadius = 20;
    _circleTest.layer.masksToBounds = YES;
    _circleTest.layer.borderWidth = 0;
    [self addSubview:_circleTest];
    
    _title = title;
    _location = location;
    _attendingList = attendingList;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 00, 300, 50)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19.0];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 300, 50)];
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    _locationLabel.text = _location;
    _locationLabel.textColor = [UIColor blackColor];
    [self addSubview:_locationLabel];
    
    _starClick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarButton.png"]];
    _starClick.backgroundColor = [UIColor clearColor];
    _starClick.center = CGPointMake(32, 270);
    [self addSubview:_starClick];
    
    _starRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StarClicked)];
    _starRecognizer.delegate = self;
    _starRecognizer.numberOfTapsRequired = 1;

    _starClick.userInteractionEnabled = YES;
    [_starClick addGestureRecognizer:_starRecognizer];
    
    _starClicked = false;
  }
  
  return self;
}

-(void) StarClicked
{
  if (!_starClicked)
  {
    _starClick.backgroundColor = [UIColor yellowColor];
    _starClicked = YES;
  } else {
    _starClick.backgroundColor = [UIColor clearColor];
    _starClicked = NO;
  }
}

@end
