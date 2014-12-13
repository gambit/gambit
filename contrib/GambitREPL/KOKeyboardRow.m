//
//  ExtraKeyboardRow.m
//  KeyboardTest
//
//  Created by Kuba on 28.06.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOKeyboard
//  Twitter: http://twitter.com/becomekodiak
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
//  Modified by David Hoerl on 28.10.2013
//  Copyright (c) 2013 David Hoerl
//

#import "KOKeyboardRow.h"

#import "KOSwipeButton.h"
#import "KOProtocol.h"
#import "KOCreateButton.h"

#import "ViewController.h"

@interface UIKeyboard : UIView

+ (UIKeyboard *)activeKeyboard;
- (id)_typeCharacter:(id)arg1 withError:(CGPoint)arg2 shouldTypeVariants:(BOOL)arg3 baseKeyForVariants:(BOOL)arg4;

@end

@interface KOKeyboardRow () <KOProtocol, UIInputViewAudioFeedback>
@end

static BOOL isPhone;
static BOOL isRetina;

static CGRect    bounds;
static NSInteger barWidth;
static NSInteger barHeight;
static NSInteger buttonHeight;
static NSInteger horzMargin;
static NSInteger buttonSpacing;

@implementation KOKeyboardRow
{
  NSMutableArray *buttonViews;
  NSInteger pButtonCount;
  NSInteger lButtonCount;

  CGRect               startLocation; // cursor control

  KOSwipeButton        *originalSnapButton;
  KOSwipeButton        *snapButton;
  CGRect               snapbackPosition;  // button animation
  CGFloat              minX, maxX, minY, maxY; // defines where the button can move
  CGPoint              originalTouchPt;  // finger hit this spot originally
  CGPoint              originalViewPt;   // view frame origin
}

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}

+ (void)initialize
{
  isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
  isRetina = [[UIScreen mainScreen] scale] > 1;

  barWidth = [UIScreen mainScreen].bounds.size.width;

  if (isPhone) {
    barHeight = 48;

    buttonHeight = 44;
    horzMargin = 6;
    buttonSpacing = 6;
  } else {
    barHeight = 72;

    buttonHeight = 60;
    horzMargin = 4;
    buttonSpacing = 6;
  }

  bounds = CGRectMake(0, 0, barWidth, barHeight);
}

+ (CGRect)bounds
{
  return bounds;
}

- (instancetype)init
{
  KOKeyboardRow *r;

#ifndef __IPHONE_7_0
#define UIInputViewStyleKeyboard 1
#endif

  if ([super respondsToSelector:@selector(initWithFrame:inputViewStyle:)]) {
    r = [super initWithFrame:[KOKeyboardRow bounds]
              inputViewStyle:UIInputViewStyleKeyboard];
  } else {
    r = [super initWithFrame:[KOKeyboardRow bounds]];
    r.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
  }

  return r;
}

- (void)setup
{
  NSString *portraitKeys;
  NSString *landscapeKeys;

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    portraitKeys = self.portraitKeysSmall;
    landscapeKeys = self.landscapeKeysSmall;
  } else {
    portraitKeys = self.portraitKeysLarge;
    landscapeKeys = self.landscapeKeysLarge;
  }

  if (portraitKeys == nil || [portraitKeys length] == 0)
    portraitKeys = @"S";

  if (landscapeKeys == nil || [landscapeKeys length] == 0)
    landscapeKeys = @"S";

  int len;

  len = [portraitKeys length];
  portraitKeys = [portraitKeys
                   stringByPaddingToLength:(len+4)/5*5
                                withString:[portraitKeys substringWithRange:NSMakeRange(len-1,1)]
                           startingAtIndex:0];


  len = [landscapeKeys length];
  landscapeKeys = [landscapeKeys
                    stringByPaddingToLength:(len+4)/5*5
                                 withString:[landscapeKeys substringWithRange:NSMakeRange(len-1,1)]
                            startingAtIndex:0];

  pButtonCount = ([portraitKeys length]+4)/5;
  lButtonCount = ([landscapeKeys length]+4)/5;

  NSInteger buttonCount = pButtonCount + lButtonCount;

  NSString *keys = [portraitKeys stringByAppendingString:landscapeKeys];

  NSUInteger firstIdx = [self.subviews count];

  buttonViews = [NSMutableArray arrayWithCapacity:buttonCount];

#if !__has_feature(objc_arc)
  [buttonViews retain];
#endif

  self.autoresizingMask = UIViewAutoresizingFlexibleWidth; // UIViewAutoresizingFlexibleHeight;
  [self setTranslatesAutoresizingMaskIntoConstraints:YES];

  NSInteger buttonWidth = (barWidth - buttonCount * buttonSpacing - 2*horzMargin) / buttonCount;
  assert(buttonWidth);

//NSInteger maxButtonWidth = (maxButtonWidth * 4)/3; // somewhat bigger
//assert(maxButtonWidth);

  NSLayoutConstraint *lc;
  KOSwipeButton *b;
  NSUInteger verticalMargin = (barHeight - buttonHeight) / 2;

  UIView *c = nil;
  for (NSInteger i = 0; i < buttonCount; i++) {

    if (i == pButtonCount) c = nil;

    UIView *lv = c;

    c = [UIView new];

    [c setTranslatesAutoresizingMaskIntoConstraints:NO];
    c.clipsToBounds = YES;
    c.tag = i;
    [self addSubview:c];
    [buttonViews addObject:c];

    b = [[KOSwipeButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    b.tag = i;
    [b setTranslatesAutoresizingMaskIntoConstraints:NO];
    [c addSubview:b];

    // SET UP IMAGE

    // Insure the button never has a negative width
    lc = [NSLayoutConstraint constraintWithItem:b
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                         toItem:nil
                                      attribute:0
                                     multiplier:1
                                       constant:0];
#if !__has_feature(objc_arc)
    [lc retain];
#endif
    [b addConstraint:lc];
    // Center it in the containing view
    lc = [NSLayoutConstraint constraintWithItem:b
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:c
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1
                                       constant:0];
#if !__has_feature(objc_arc)
    [lc retain];
#endif
    [c addConstraint:lc];
    // Button height never changes
    lc = [NSLayoutConstraint constraintWithItem:b
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:0
                                     multiplier:1
                                       constant:buttonHeight];
#if !__has_feature(objc_arc)
    [lc retain];
#endif
    [b addConstraint:lc];
    // Top margin never changes
    lc = [NSLayoutConstraint constraintWithItem:b
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:c
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:verticalMargin];
#if !__has_feature(objc_arc)
    [lc retain];
#endif
    [c addConstraint:lc];

    // Container pinned to bottom ...
    lc = [NSLayoutConstraint constraintWithItem:c
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0];
#if !__has_feature(objc_arc)
    [lc retain];
#endif
    [self addConstraint:lc];

    // ... and top of the Keyboard Row
    lc = [NSLayoutConstraint constraintWithItem:c
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];

    lc = [NSLayoutConstraint constraintWithItem:b
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:c
                                      attribute:NSLayoutAttributeLeading
                                     multiplier:1
                                       constant:buttonSpacing/2];
#if !__has_feature(objc_arc)
    [lc retain];
#endif
    lc.priority = UILayoutPriorityRequired - 2;
    [c addConstraint:lc];

    // left
    if (lv) {
      lc = [NSLayoutConstraint constraintWithItem:c
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:lv
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1
                                         constant:0];
#if !__has_feature(objc_arc)
      [lc retain];
#endif
      [self addConstraint:lc];
    }

    b.keys = [keys substringWithRange:NSMakeRange(i * 5, 5)];
    b.delegate = self;
  }

  for (int i=0; i<2; i++)
    {
      // Pin to self

      UIView *v;

      v = buttonViews[i*pButtonCount];
      lc = [NSLayoutConstraint constraintWithItem:v
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1
                                         constant:horzMargin];
#if !__has_feature(objc_arc)
      [lc retain];
#endif
      [self addConstraint:lc];

      v = buttonViews[i*lButtonCount + pButtonCount - 1];
      lc = [NSLayoutConstraint constraintWithItem:v
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1
                                         constant:-horzMargin];
#if !__has_feature(objc_arc)
      [lc retain];
#endif
      [self addConstraint:lc];
    }

  // should really test for cursor control since need a "normal" view
  UIView *firstPortraitView  = buttonViews[0];
  UIView *firstLandscapeView = buttonViews[pButtonCount];
  KOSwipeButton *firstPortraitButton = [firstPortraitView.subviews lastObject];
  KOSwipeButton *firstLandscapeButton = [firstLandscapeView.subviews lastObject];
  assert(firstPortraitButton);
  assert(firstLandscapeButton);

  [buttonViews enumerateObjectsUsingBlock:^(UIView *buttonView, NSUInteger idx, BOOL *stop)
    {
      //NSLog(@"BUTTON: %@ subviews: %@", buttonView, buttonView.subviews);
      KOSwipeButton *button = [buttonView.subviews lastObject];
      assert(button);

      NSLayoutConstraint *le;
      if (idx > 0 && idx < pButtonCount) {
        le = [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:firstPortraitButton
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                           constant:0];
#if !__has_feature(objc_arc)
        [le retain];
#endif
        le.priority = UILayoutPriorityRequired - 1;
        [self addConstraint:le];
      }

      if (idx > pButtonCount) {
        le = [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:firstLandscapeButton
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                           constant:0];
#if !__has_feature(objc_arc)
        [le retain];
#endif
        le.priority = UILayoutPriorityRequired - 1;
        [self addConstraint:le];
      }

      NSLayoutConstraint *l0 =
        [NSLayoutConstraint constraintWithItem:buttonView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:nil
                                     attribute:0
                                    multiplier:1
                                      constant:0];
      l0.priority = UILayoutPriorityRequired - 1;
#if !__has_feature(objc_arc)
      [l0 retain];
#endif
      [buttonView addConstraint:l0];
    } ];

  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  [self switchToOrientation:interfaceOrientation];

  CGFloat height = isRetina ? 0.5f : 1;
  UIView *border2 = [[UIView alloc] initWithFrame:CGRectMake(0, barHeight-height, barWidth, height)];
  border2.tag = 102;
  border2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.];
  border2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self insertSubview:border2 atIndex:firstIdx];
}

- (void)setFrame:(CGRect)frame
{
  [super setFrame:frame];

  [self setNeedsUpdateConstraints];
  [self setNeedsLayout];
}

- (void)switchToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  BOOL isPortrait = UIInterfaceOrientationIsPortrait(interfaceOrientation);

  if (isPortrait) {

    for (int i=0; i<lButtonCount; i++) {
      UIView *v = buttonViews[i+pButtonCount];
      v.hidden = YES;
    }

    for (int i=0; i<pButtonCount; i++) {
      UIView *v = buttonViews[i];
      v.hidden = NO;
    }

  } else {

    for (int i=0; i<pButtonCount; i++) {
      UIView *v = buttonViews[i];
      v.hidden = YES;
    }

    for (int i=0; i<lButtonCount; i++) {
      UIView *v = buttonViews[i+pButtonCount];
      v.hidden = NO;
    }

  }

  [self needsUpdateConstraints];
}

- (void)updateConstraints
{
  [super updateConstraints];

  //NSLog(@"updateConstraints");
  NSAssert(![self hasAmbiguousLayout], @"FOO");
  //[self performSelector:@selector(_autolayoutTrace)];
  //NSLog(@"CONSTRAINTS: %@", self.constraints);
  //NSLog(@"%@", [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(_autolayoutTrace)]);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
}

- (BOOL)enableInputClicksWhenVisible
{
  return YES;
}

- (void)insertText:(NSString *)text
{
  [[UIDevice currentDevice] playInputClick];

  //NSLog(@"KOKeyboardRow insertText:%@",text);

  [theViewController send_text_input:text];

#if 0

  if ([_koDelegate isKindOfClass:[UITextView class]]) {
    UITextView *textView = (UITextView *)_koDelegate;
    if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
      // Ask textView'delegate whether we should change the text
      NSRange selectedRange = textView.selectedRange;
      BOOL shouldInsert = [textView.delegate textView:textView shouldChangeTextInRange:selectedRange replacementText:text];
      if (shouldInsert) {
        [textView insertText:text];
        // also notify someone interested in this textview
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
      }
    } else {
      [_koDelegate insertText:text];
    }
  } else if([_koDelegate isKindOfClass:[UITextField class]]) {
    UITextField *textField = (UITextField *)_koDelegate;
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
      // Ask textView'delegate whether we should change the text
      UITextRange *selectedTextRange = textField.selectedTextRange;
      NSUInteger location = [textField offsetFromPosition:textField.beginningOfDocument
                                               toPosition:selectedTextRange.start];
      NSUInteger length = [textField offsetFromPosition:selectedTextRange.start
                                             toPosition:selectedTextRange.end];
      NSRange selectedRange = NSMakeRange(location, length);
      //NSLog(@"selectedRange: %@", NSStringFromRange(selectedRange));

      BOOL shouldInsert = [textField.delegate textField:textField shouldChangeCharactersInRange:selectedRange replacementString:text];
      if (shouldInsert) {
        [textField insertText:text];
        // also notify someone interested in this textview
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField];
      }
    } else {
      [_koDelegate insertText:text];
    }
  }

#endif
}

@end
