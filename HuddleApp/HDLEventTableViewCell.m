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
  UIImageView *_userCircle;
  
  UIImageView *_starClick;
  
  UITapGestureRecognizer *_starRecognizer;
  
  BOOL _starClicked;
  
  int numUserPhotos;
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
    
    if ([backgroundString isEqualToString:@"Beach"])
      _backgroundImage.image = [UIImage imageNamed:@"BeachPhoto.png"];
    else if ([backgroundString isEqualToString:@"Hockey"])
      _backgroundImage.image = [UIImage imageNamed:@"HockeyPhoto.jpg"];
    else if ([backgroundString isEqualToString:@"Salsa"])
      _backgroundImage.image = [UIImage imageNamed:@"SalsaDancing.jpg"];
    else if ([backgroundString isEqualToString:@"Basketball"])
      _backgroundImage.image = [UIImage imageNamed:@"BasketballPhoto.jpg"];
          
    [self addSubview:_backgroundImage];
    
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
    
    _starClick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Heart2.png"]];
    _starClick.backgroundColor = [UIColor clearColor];
    _starClick.center = CGPointMake(32, 270);
    [self addSubview:_starClick];
    
    _starRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StarClicked)];
    _starRecognizer.delegate = self;
    _starRecognizer.numberOfTapsRequired = 1;

    _starClick.userInteractionEnabled = YES;
    [_starClick addGestureRecognizer:_starRecognizer];
    
    _starClicked = false;
    
    _userCircle = [[UIImageView alloc] initWithFrame:CGRectMake(62, 250, 40, 40)];
    _userCircle.image = [UIImage imageNamed:@"Facebook_MichaelWeingert.jpg"];
    _userCircle.layer.cornerRadius = 20;
    _userCircle.layer.masksToBounds = YES;
    _userCircle.layer.borderWidth = 0;
    _userCircle.alpha = 0.0;
    [self addSubview:_userCircle];
    
    numUserPhotos = 0;
  }
  
  return self;
}

-(void) heartWasClicked
{
  _starClick.image = [UIImage imageNamed:@"Heart2RED.png"];
  _starClicked = YES;
  _userCircle.alpha = 1.0;
}

-(void) StarClicked
{
  if (!_starClicked)
  {
    _starClick.image = [UIImage imageNamed:@"Heart2RED.png"];
    _starClicked = YES;
    _userCircle.alpha = 1.0;
    
    [_delegate heartClicked:self withActive:YES];
    
  } else {
    _starClick.image = [UIImage imageNamed:@"Heart2.png"];
    _starClicked = NO;
    _userCircle.alpha = 0.0;
    
    [_delegate heartClicked:self withActive:NO];
  }
}


-(void) addUserPhoto:(NSString *)userString
{
  if ([userString rangeOfString:@"."].location != NSNotFound)
  {
    //Add photo for user to cell
    _circleTest = [[UIImageView alloc] initWithFrame:CGRectMake(112 + 50 * numUserPhotos, 250, 40, 40)];
    _circleTest.image = [UIImage imageNamed:userString];
    _circleTest.layer.cornerRadius = 20;
    _circleTest.layer.masksToBounds = YES;
    _circleTest.layer.borderWidth = 0;
    [self addSubview:_circleTest];
    
    numUserPhotos++;
  }
}

@end
