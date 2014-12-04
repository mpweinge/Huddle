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
  
  UIImageView *_backgroundImage;
  
  UIPanGestureRecognizer *_panRecognizer;
  
  int numUserPhotos;
  
  CGPoint startPan;
  
  NSMutableArray * voterCircles;
  
  UIView *transparentRect;
  
  UIView *transparentRect2;
  
  BOOL hasShiftedForDelete;
  
  UIButton * deleteButton;
  
  int _row;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(int) getRow
{
  return _row;
}

-(instancetype) initWithStyle: (UITableViewCellStyle) style
              reuseIdentifier: (NSString *) reuseIdentifier
                   dateString: (NSString *) date
              attendingString: (NSString *)attending
             backgroundString: (NSString *)background
                          row:(int) row
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self)
  {
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, 180)];
    
    hasShiftedForDelete = false;
    
    _row = row;
    
    if ([background isEqualToString:@"Hockey"])
    {
      _backgroundImage.image = [UIImage imageNamed:@"HockeyPhoto.jpg"];
    } else if ([background isEqualToString:@"Basketball"]) {
      _backgroundImage.image = [UIImage imageNamed:@"BasketballPhoto.jpg"];
    } else if ([background isEqualToString:@"Salsa"]) {
       _backgroundImage.image = [UIImage imageNamed:@"SalsaDancing.jpg"];
    } else if ([background isEqualToString:@"Party"]){
      _backgroundImage.image = [UIImage imageNamed:@"PartyPhoto.jpg"];
    } else {
      _backgroundImage.image = [UIImage imageNamed:@"Beach_iOS.jpg"];
    }
    
    [self addSubview:_backgroundImage];
    
    _dateString = date;
    _attendingPeople = attending;
    _backgroundImageDescriptor = background;
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -20, 300, 100)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:30.0];
    _dateLabel.text = _dateString;
    _dateLabel.textColor = [UIColor whiteColor];
    
    
    _attendingPeopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 350, 100)];
    _attendingPeopleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    _attendingPeopleLabel.text = _attendingPeople;
    _attendingPeopleLabel.textColor = [UIColor whiteColor];
    //[self addSubview:_attendingPeopleLabel];
    
    //Add partially transparent rectangle for date + user photos
    transparentRect = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 350, 40)];
    transparentRect.backgroundColor = [UIColor blackColor];
    transparentRect.alpha = 0.5;
    [self addSubview:transparentRect];
    
    [self addSubview:_dateLabel];
    
    transparentRect2 = [[UIView alloc] initWithFrame:CGRectMake(0, 140, 350, 50)];
    transparentRect2.backgroundColor = [UIColor blackColor];
    transparentRect2.alpha = 0.5;
    [self addSubview:transparentRect2];
    
    //Pan event here for swipes
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedCell:)];
    _panRecognizer.delegate = self;
    [self addGestureRecognizer:_panRecognizer];
    _panRecognizer.cancelsTouchesInView = NO;
    
    numUserPhotos = 0;
    
    voterCircles = [NSMutableArray array];
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteButton setTitle:@" Leave " forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton sizeToFit];
    [deleteButton addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGRect deleteButtonFrame = deleteButton.frame;
    deleteButtonFrame.size.height += 20;
    deleteButtonFrame.origin.y -= 10;
    deleteButton.frame = deleteButtonFrame;
    
    deleteButton.center = CGPointMake(-30, 100);
    deleteButton.backgroundColor = [UIColor redColor];
    [self addSubview:deleteButton];
  }
  
  return self;
}

-(void) deleteClicked:(UIButton *)deleteButton
{
  NSLog(@"Delete Clicked");
  [_delegate deleteRowClicked:self];
}

-(void) addUserCircle:(NSString *) userImageTitle withTotalPhotos:(int) totalPhotos
{
  //Add photo for user to cell
  UIScreen * currentScreen = [UIScreen screens][0];
  int centerOffset = ([currentScreen bounds].size.width - (totalPhotos * 50)) / 2;
  
  UIImageView *circleTest = [[UIImageView alloc] initWithFrame:CGRectMake(centerOffset + 50 * numUserPhotos, 145, 40, 40)];
  circleTest.image = [UIImage imageNamed:userImageTitle];
  circleTest.layer.cornerRadius = 20;
  circleTest.layer.masksToBounds = YES;
  circleTest.layer.borderWidth = 0;
  [self addSubview:circleTest];
  
  [voterCircles addObject:circleTest];
  
  numUserPhotos++;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
    return YES;
  }
  else
    return NO;
      
}

-(void) animateBack
{
  int deleteShift = 60;
  
  [UIView animateWithDuration:0.5 animations:^{
    CGRect imageFrame = _backgroundImage.frame;
    imageFrame.origin.x -= deleteShift;
    _backgroundImage.frame = imageFrame;
    
    for (UIImageView * imageCircle in voterCircles )
    {
      CGRect imageFrame = imageCircle.frame;
      imageFrame.origin.x -= deleteShift;
      imageCircle.frame = imageFrame;
    }
    
    CGRect rectFrame = transparentRect.frame;
    rectFrame.origin.x -= deleteShift;
    transparentRect.frame = rectFrame;
    
    rectFrame = transparentRect2.frame;
    rectFrame.origin.x -= deleteShift;
    transparentRect2.frame = rectFrame;
    
    CGRect dateLabelRect = _dateLabel.frame;
    dateLabelRect.origin.x -= deleteShift;
    _dateLabel.frame = dateLabelRect;
    
    CGPoint deleteCenter = deleteButton.center;
    deleteCenter.x -= 60;
    deleteButton.center = deleteCenter;
  } completion:^(BOOL completion){
    
  }];
  
}

-(void) pannedCell:(UIPanGestureRecognizer *)panRecognizer
{
  CGPoint translation = [panRecognizer translationInView:self];
  
  if ([panRecognizer state] == UIGestureRecognizerStateBegan)
  {
    startPan = translation;
  } else if ([panRecognizer state] == UIGestureRecognizerStateEnded)
  {
    if (hasShiftedForDelete)
    {
      [_delegate donePanning:self];
      hasShiftedForDelete = false;
    }
  }
  else if ( (startPan.x - translation.x) > 50)
  {
    [_delegate isPanning: self];
    
    if (!hasShiftedForDelete) {
      
      int deleteShift = 60;
      
      hasShiftedForDelete = true;
      
      [UIView animateWithDuration:0.5 animations:^{
        CGRect imageFrame = _backgroundImage.frame;
        imageFrame.origin.x += deleteShift;
        _backgroundImage.frame = imageFrame;
        
        for (UIImageView * imageCircle in voterCircles )
        {
          CGRect imageFrame = imageCircle.frame;
          imageFrame.origin.x += deleteShift;
          imageCircle.frame = imageFrame;
        }
        
        CGRect rectFrame = transparentRect.frame;
        rectFrame.origin.x += deleteShift;
        transparentRect.frame = rectFrame;
        
        rectFrame = transparentRect2.frame;
        rectFrame.origin.x += deleteShift;
        transparentRect2.frame = rectFrame;
        
        CGRect dateLabelRect = _dateLabel.frame;
        dateLabelRect.origin.x += deleteShift;
        _dateLabel.frame = dateLabelRect;
        
        CGPoint deleteCenter = deleteButton.center;
        deleteCenter.x += 60;
        deleteButton.center = deleteCenter;
      } completion:^(BOOL completion){
        
      }];
      
    }
  }
}

@end
