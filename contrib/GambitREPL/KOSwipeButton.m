//
//  SwipeButton.m
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

#import "KOSwipeButton.h"
#import "KOKeyboardRow.h"
#import "KOProtocol.h"

#import "CreateButton.h"

@interface KOSwipeButton ()
@end

#define TIME_INTERVAL_FOR_DOUBLE_TAP 1.0f

@implementation KOSwipeButton
{
	BOOL			didSetup;
	
	NSMutableArray	*labels;
	CGPoint			touchBeginPoint;
	UILabel			*selectedLabel;
	UIImageView		*bgView;
	UIImageView		*foregroundView;
	BOOL			trackPoint;
	BOOL			tabButton;
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

	CreateButton *b = [CreateButton new];
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
    
    int labelWidth = 20;
    int labelHeight = 25;
    int leftInset = 7;
    int rightInset = 7;
    int topInset = -2;
    int bottomInset = 3;
    
    labels = [[NSMutableArray alloc] init];
    
    UIFont *f = [UIFont systemFontOfSize:15];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(leftInset, topInset, labelWidth, labelHeight)];
    l.textAlignment = NSTextAlignmentLeft;
    l.text = @"1";
    l.font = f;
    [self addSubview:l];
    [l setHighlightedTextColor:[UIColor blueColor]];
    l.backgroundColor = [UIColor clearColor];
    [labels addObject:l];
    
    l = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWidth - rightInset, topInset, labelWidth, labelHeight)];
    l.textAlignment = NSTextAlignmentRight;
    l.text = @"2";
    l.font = f;
    l.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:l];
    [l setHighlightedTextColor:[UIColor blueColor]];
    l.backgroundColor = [UIColor clearColor];
    [labels addObject:l];
    
    l = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake((self.frame.size.width - labelWidth - leftInset - rightInset) / 2 + leftInset, (self.frame.size.height - labelHeight - topInset - bottomInset) / 2 + topInset, labelWidth, labelHeight))];
    l.textAlignment = NSTextAlignmentCenter;
    l.text = @"3";
    l.font = f;
    l.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin; // UIViewAutoresizingFlexibleWidth;
    [self addSubview:l];
    [l setHighlightedTextColor:[UIColor blueColor]];
    l.backgroundColor = [UIColor clearColor];
    [labels addObject:l];
    
    l = [[UILabel alloc] initWithFrame:CGRectMake(leftInset, (self.frame.size.height - labelHeight - bottomInset), labelWidth, labelHeight)];
    l.textAlignment = NSTextAlignmentLeft;
    l.text = @"4";
    l.font = f;
    [self addSubview:l];
    [l setHighlightedTextColor:[UIColor blueColor]];
    l.backgroundColor = [UIColor clearColor];
    [labels addObject:l];
    
    l = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWidth - rightInset, (self.frame.size.height - labelHeight - bottomInset), labelWidth, labelHeight)];
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

- (void)setKeys:(NSString *)newKeys
{
	_keys = newKeys;

    for (int i = 0; i < MIN(newKeys.length, 5); i++) {
        [[labels objectAtIndex:i] setText:[newKeys substringWithRange:NSMakeRange(i, 1)]];
        //[[labels objectAtIndex:i] setFont:[UIFont systemFontOfSize:20]];
        if (i == 2)
          [[labels objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:24]];
        else
          [[labels objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:14]];

        if ([[newKeys substringToIndex:1] isEqualToString:@"◉"] || [[newKeys substringToIndex:1] isEqualToString:@"T"]) {
            
            trackPoint = [[newKeys substringToIndex:1] isEqualToString:@"◉"];
            tabButton = [[newKeys substringToIndex:1] isEqualToString:@"T"];
            
            if (i != 2) {
                [[labels objectAtIndex:i] setHidden:YES];
            } else {
                if (trackPoint) {
                    [[labels objectAtIndex:i] setHidden:YES];
                    //[[labels objectAtIndex:i] setFont:[UIFont systemFontOfSize:20]];
                    UIImage *bgImg1 = [UIImage imageNamed:@"hal-black.png"];
					//bgImg1 = [bgImg1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    foregroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
                    foregroundView.frame = CGRectMake(((self.bounds.size.width - 19) / 2), ((self.bounds.size.height - 19) / 2), 19, 19);
                    [foregroundView setImage:bgImg1];
					//foregroundView.tintColor = [UIColor redColor];

                    [foregroundView setHighlightedImage:pressedFgImage];
                    foregroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                    [self addSubview:foregroundView];
                } else {
                    [[labels objectAtIndex:i] setText:@"TAB"];
                    [[labels objectAtIndex:i] setFrame:self.bounds];
                }
            }
        }
    }
	
	UIKeyboardAppearance app = [self isTrackingPoint] ? UIKeyboardAppearanceDark : UIKeyboardAppearanceLight;
	CreateButton *b = [CreateButton new];
	UIImage *b1 = [b buttonImage:CGSizeMake(41, 41) type:app];
    UIImage *bgImg1	= [b1 resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [bgView setImage:bgImg1];
}

- (void)selectLabel:(NSInteger)idx
{
    selectedLabel = nil;
    
    for (NSInteger i = 0; i < labels.count; i++) {
        UILabel *l = [labels objectAtIndex:i];
        l.highlighted = (idx == i);
        
        if (idx == i)
            selectedLabel = l;
    }
    
    bgView.highlighted = selectedLabel != nil;
    foregroundView.highlighted = selectedLabel != nil;
}

- (BOOL)isTrackingPoint
{
	return trackPoint;
}

#if 0
- (void)finderDown:(CGPoint)pt inView:(UIView *)view
{
NSLog(@"finderDown=%@", NSStringFromCGPoint(pt));
}

- (void)finderMoved:(CGPoint)pt inView:(UIView *)view
{
NSLog(@"finderMoved=%@", NSStringFromCGPoint(pt));
}

- (void)finderReleased:(CGPoint)pt inView:(UIView *)view
{
NSLog(@"finderReleased=%@", NSStringFromCGPoint(pt));
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    touchBeginPoint = [t locationInView:self];
    
    if (trackPoint) {
        if (fabs([firstTapDate timeIntervalSinceNow]) < TIME_INTERVAL_FOR_DOUBLE_TAP) {
            bgView.highlightedImage = blueImage;
            foregroundView.highlightedImage = blueFgImage;
            selecting = YES;
        } else {
            bgView.highlightedImage = pressedImage;
            foregroundView.highlightedImage = pressedFgImage;
            selecting = NO;
        }
        firstTapDate = [NSDate date];
        
        [_delegate trackPointStarted];
    } else {
		[_delegate finderDown:t inView:self];
	}
    
    [self selectLabel:2];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint touchMovePoint = [t locationInView:self];
    
    CGFloat xdiff = touchBeginPoint.x - touchMovePoint.x;
    CGFloat ydiff = touchBeginPoint.y - touchMovePoint.y;
    CGFloat distance = sqrt(xdiff * xdiff + ydiff * ydiff);
    
    if (trackPoint) {
        [_delegate trackPointMovedX:xdiff Y:ydiff selecting:selecting];
        return;
    }
    
	NSInteger idx = 2;
    if (distance > 250) {
		idx = -1;
    } else if (!tabButton && (distance > 20)) {
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
	[_delegate finderMoved:t inView:self selectedLabel:idx];
	[self selectLabel:idx];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (selectedLabel) {
		if (tabButton) {
			[_delegate insertText:@"\t"];
		} else if (!trackPoint) {
			NSString *textToInsert = selectedLabel.text;
			[_delegate insertText:textToInsert];
		}
	}
	[self selectLabel:-1];

	if (trackPoint) {
		if(selecting) {
			[_delegate trackPointEnded];
		}
	} else {
		UITouch *t = [touches anyObject];
		[_delegate finderUp:t inView:self];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectLabel:-1];

	if (!trackPoint) {
		UITouch *t = [touches anyObject];
		[_delegate finderUp:t inView:self];
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return (self.hidden) ? NO : [super pointInside:point withEvent:event];
}

@end
