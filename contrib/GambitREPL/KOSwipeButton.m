//
//  KOSwipeButton.m
//  KeyboardTest
//
//  Created by Kuba on 28.06.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOKeyboard
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <AudioToolbox/AudioToolbox.h>

#import "KOSwipeButton.h"
#import "KOKeyboardRow.h"
#import "KOProtocol.h"

#import "KOCreateButton.h"

#import "ViewController.h"

extern ViewController *theViewController;

@interface UILabelWithAction : UILabel
{
@public
  NSString *action;
#define STOP_ACTION @"S"
#define RUN_ACTION  @"R"
#define EDIT_ACTION @"E"
#define NOTE_ACTION @"N"
#define USER_ACTION @"U"
}
@end

@implementation UILabelWithAction
@end

@interface KOSwipeButton ()
@end

#define TIME_INTERVAL_FOR_DOUBLE_TAP 1.0f

@implementation KOSwipeButton
{
	BOOL			didSetup;
	
	NSMutableArray	*labels;
	CGPoint			touchBeginPoint;
	UILabelWithAction	*selectedLabel;
	UIImageView		*bgView;
	UIImageView		*foregroundView;
	NSDate			*firstTapDate;
	BOOL			selecting;
	UIImage			*blueImage;
	UIImage			*pressedImage;
	UIImage			*blueFgImage;
	UIImage			*pressedFgImage;
}

- (instancetype)init
{
	if((self = [super init])) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if((self = [super initWithFrame:frame])) {
    [self setup];
  }
  return self;
}

- (void)setup
{
  if(didSetup) {
    NSLog(@"YIKES: did setup!");
    return;
  }
  didSetup = YES;

  blueFgImage		= [UIImage imageNamed:@"hal-white.png"];
  pressedFgImage	= [UIImage imageNamed:@"hal-blue.png"];

  KOCreateButton *b = [KOCreateButton new];
  UIImage *b2 = [b buttonImage:CGSizeMake(41, 41) color:[UIColor colorWithWhite:0.66 alpha:1]];
  UIImage *b3 = [b buttonImage:CGSizeMake(41, 41) color:[UIColor blueColor]];
	
  pressedImage	= [b2 resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
  blueImage		= [b3 resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];

  //UIImage *bgImg1 = [[UIImage imageNamed:@"key.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
  //UIImage *bgImg2 = [[UIImage imageNamed:@"key-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 9, 9)];

  bgView = [[UIImageView alloc] initWithFrame:self.bounds];
  [bgView setHighlightedImage:pressedImage];
  bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self addSubview:bgView];
  // NSLog(@"IMAGE FRAME: %@", NSStringFromCGRect(bgView.frame));
    
  int middleLabelWidth = 29;
  int middleLabelHeight = 29;
  int labelWidth = 20;
  int labelHeight = 20;
  int leftInset = 4;
  int rightInset = 4;
  int topInset = 3;
  int bottomInset = 3;
    
  labels = [[NSMutableArray alloc] init];
    
  UIFont *f = [UIFont systemFontOfSize:15];
    
  UILabelWithAction *l = [[UILabelWithAction alloc] initWithFrame:CGRectMake(leftInset, topInset, labelWidth, labelHeight)];
  l->action = @"";
  l.textAlignment = NSTextAlignmentLeft;
  l.text = @"1";
  l.font = f;
  [self addSubview:l];
  [l setHighlightedTextColor:[UIColor blueColor]];
  l.backgroundColor = [UIColor clearColor];
  [labels addObject:l];
    
  l = [[UILabelWithAction alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWidth - rightInset, topInset, labelWidth, labelHeight)];
  l->action = @"";
  l.textAlignment = NSTextAlignmentRight;
  l.text = @"2";
  l.font = f;
  l.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [self addSubview:l];
  [l setHighlightedTextColor:[UIColor blueColor]];
  l.backgroundColor = [UIColor clearColor];
  [labels addObject:l];

  l = [[UILabelWithAction alloc] initWithFrame:CGRectIntegral(CGRectMake((self.frame.size.width - middleLabelWidth - leftInset - rightInset) / 2 + leftInset, (self.frame.size.height - middleLabelHeight - topInset - bottomInset) / 2 + topInset, middleLabelWidth, middleLabelHeight))];
  l->action = @"";
  l.textAlignment = NSTextAlignmentCenter;
  l.text = @"3";
  l.font = f;
  l.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin; // UIViewAutoresizingFlexibleWidth;
  [self addSubview:l];
  [l setHighlightedTextColor:[UIColor blueColor]];
  l.backgroundColor = [UIColor clearColor];
  [labels addObject:l];

  l = [[UILabelWithAction alloc] initWithFrame:CGRectMake(leftInset, (self.frame.size.height - labelHeight - bottomInset), labelWidth, labelHeight)];
  l->action = @"";
  l.textAlignment = NSTextAlignmentLeft;
  l.text = @"4";
  l.font = f;
  [self addSubview:l];
  [l setHighlightedTextColor:[UIColor blueColor]];
  l.backgroundColor = [UIColor clearColor];
  [labels addObject:l];

  l = [[UILabelWithAction alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWidth - rightInset, (self.frame.size.height - labelHeight - bottomInset), labelWidth, labelHeight)];
  l->action = @"";
  l.textAlignment = NSTextAlignmentRight;
  l.text = @"5";
  l.font = f;
  l.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [self addSubview:l];
  [l setHighlightedTextColor:[UIColor blueColor]];
  l.backgroundColor = [UIColor clearColor];
  [labels addObject:l];

  firstTapDate = [[NSDate date] dateByAddingTimeInterval:-1];
}

UIImage *scaleToSize(UIImage *img, CGSize size)
{
  UIGraphicsBeginImageContext(size);
  [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

- (void)setKeys:(NSString *)newKeys
{
  _keys = newKeys;

  for (int i = 0; i < MIN(newKeys.length, 5); i++) {

    UILabelWithAction *lab = [labels objectAtIndex:i];
    NSString *chr = [newKeys substringWithRange:NSMakeRange(i, 1)];
#if !__has_feature(objc_arc)
    [chr retain];
#endif
    lab->action = chr;
    [lab setText:@""];

    if (i != 2 && [chr isEqualToString:[newKeys substringWithRange:NSMakeRange(2, 1)]])
      continue;

    NSString *imgFilename = nil;

    if ([chr isEqualToString:STOP_ACTION])
      imgFilename = @"stop.png";
    else if ([chr isEqualToString:RUN_ACTION])
      imgFilename = @"rocket.png";
    else if ([chr isEqualToString:EDIT_ACTION])
      imgFilename = @"edit.png";
    else if ([chr isEqualToString:NOTE_ACTION])
      imgFilename = @"note.png";
    else if ([chr isEqualToString:USER_ACTION])
      imgFilename = @"user.png";
    else if ([chr isEqualToString:@"a"])
      imgFilename = @"f1.png";
    else if ([chr isEqualToString:@"b"])
      imgFilename = @"f2.png";
    else if ([chr isEqualToString:@"c"])
      imgFilename = @"f3.png";
    else if ([chr isEqualToString:@"d"])
      imgFilename = @"f4.png";
    else if ([chr isEqualToString:@"e"])
      imgFilename = @"f5.png";
    else if ([chr isEqualToString:@"f"])
      imgFilename = @"f6.png";
    else if ([chr isEqualToString:@"g"])
      imgFilename = @"f7.png";
    else if ([chr isEqualToString:@"h"])
      imgFilename = @"f8.png";
    else if ([chr isEqualToString:@"i"])
      imgFilename = @"f9.png";
    else if ([chr isEqualToString:@"j"])
      imgFilename = @"f10.png";

    if (imgFilename != nil) {
      UIImage *img = scaleToSize([UIImage imageNamed:imgFilename], lab.frame.size);
      lab.backgroundColor = [UIColor colorWithPatternImage:img];
    } else {

      [lab setText:chr];

      if (i == 2) {
        [[labels objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:28]];
      } else {
        [[labels objectAtIndex:i] setFont:[UIFont systemFontOfSize:18]];
      }
    }
  }
	
  UIKeyboardAppearance app = UIKeyboardAppearanceLight;
  KOCreateButton *b = [KOCreateButton new];
  UIImage *b1 = [b buttonImage:CGSizeMake(41, 41) type:app];
  UIImage *bgImg1	= [b1 resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
  [bgView setImage:bgImg1];
}

- (void)selectLabel:(NSInteger)idx
{
  selectedLabel = nil;
    
  for (NSInteger i = 0; i < labels.count; i++) {
    UILabelWithAction *l = [labels objectAtIndex:i];
    l.highlighted = (idx == i);

    if (idx == i)
      selectedLabel = l;
  }
    
  bgView.highlighted = selectedLabel != nil;
  foregroundView.highlighted = selectedLabel != nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *t = [touches anyObject];
  touchBeginPoint = [t locationInView:self];
    
  [self selectLabel:2];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *t = [touches anyObject];
  CGPoint touchMovePoint = [t locationInView:self];
    
  CGFloat xdiff = touchBeginPoint.x - touchMovePoint.x;
  CGFloat ydiff = touchBeginPoint.y - touchMovePoint.y;
  CGFloat distance = sqrt(xdiff * xdiff + ydiff * ydiff);
    
  NSInteger idx = 2;
  if (distance > 250) {
    idx = -1;
  } else if (distance > 20) {
    CGFloat angle = atan2(xdiff, ydiff);

    if (angle >= 0 && angle < M_PI_2) {
      idx = 0;
    } else if (angle >= 0 && angle >= M_PI_2) {
      idx = 3;
    } else if (angle < 0 && angle > -M_PI_2) {
      idx = 1;
    } else if (angle < 0 && angle <= -M_PI_2) {
      idx = 4;
    }
  }

  [self selectLabel:idx];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (selectedLabel) {

    NSString *action = selectedLabel->action;

    if (action == nil) return;

    static int keyboardSounds = -1;

    if (keyboardSounds != 0)
      {
        if (keyboardSounds == -1) // delayed check of user preferences?
          {
            Boolean exists_and_valid;
            keyboardSounds =
              CFPreferencesGetAppBooleanValue(CFSTR("keyboard"),
                                              CFSTR("/var/mobile/Library/Preferences/com.apple.preferences.sounds"),
                                              &exists_and_valid);
            if (!exists_and_valid)
              keyboardSounds = true; // by default turn on keyboard clicks
          }

        if (keyboardSounds != 0)
          AudioServicesPlaySystemSound(1104); // keyboard "tock" sound
      }

    if ([action isEqualToString:@"a"]) {
      [theViewController send_key:@"F1"];
    } else if ([action isEqualToString:@"b"]) {
      [theViewController send_key:@"F2"];
    } else if ([action isEqualToString:@"c"]) {
      [theViewController send_key:@"F3"];
    } else if ([action isEqualToString:@"d"]) {
      [theViewController send_key:@"F4"];
    } else if ([action isEqualToString:@"e"]) {
      [theViewController send_key:@"F5"];
    } else if ([action isEqualToString:@"f"]) {
      [theViewController send_key:@"F6"];
    } else if ([action isEqualToString:@"g"]) {
      [theViewController send_key:@"F7"];
    } else if ([action isEqualToString:@"h"]) {
      [theViewController send_key:@"F8"];
    } else if ([action isEqualToString:@"i"]) {
      [theViewController send_key:@"F9"];
    } else if ([action isEqualToString:@"j"]) {
      [theViewController send_key:@"F10"];
    } else if ([action isEqualToString:RUN_ACTION]) {
      [theViewController send_key:@"F11"];
    } else if ([action isEqualToString:STOP_ACTION]) {
      [theViewController send_key:@"F12"];
    } else if ([action isEqualToString:EDIT_ACTION]) {
      [theViewController send_key:@"F13"];
    } else {
      [theViewController send_key:action];
    }
  }

  [self selectLabel:-1];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self selectLabel:-1];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
  return (self.hidden) ? NO : [super pointInside:point withEvent:event];
}

@end
