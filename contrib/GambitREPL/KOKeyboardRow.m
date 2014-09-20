//
//  ExtraKeyboardRow.m
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
//  Modified by David Hoerl on 28.10.2013
//  Copyright (c) 2013 David Hoerl
//

#import "KOKeyboardRow.h"

#import "KOSwipeButton.h"
#import "KOProtocol.h"
#import "CreateButton.h"

@interface KOKeyboardRow () <KOProtocol, UIInputViewAudioFeedback, UIDynamicAnimatorDelegate>
@end

static BOOL isPhone;
static BOOL isRetina;

static CGRect				bounds;
static NSInteger			barWidth;
static NSInteger			barHeight;
static NSInteger			buttonHeight;
static NSInteger			horzMargin;
static NSInteger			buttonSpacing;

@implementation KOKeyboardRow
{
	NSMutableArray			*enclosingViews;
	NSMutableSet			*pConstraints;
	NSMutableSet			*lConstraints;
	
	CGRect					startLocation;			// cursor control
	
	KOSwipeButton			*originalSnapButton;
	KOSwipeButton			*snapButton;
	CGRect					snapbackPosition;		// button animation
	CGFloat					minX, maxX, minY, maxY;	// defines where the button can move
	CGPoint					originalTouchPt;		// finger hit this spot originally
	CGPoint					originalViewPt;			// view frame origin
	
	UIDynamicAnimator		*animator;
	UIAttachmentBehavior	*aBehavior;
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
	
	if(isPhone) {
		barHeight = 56;

		buttonHeight = 50;
		horzMargin = 6;
		buttonSpacing = 6;

		//keys = @"TTTTT()\"[]{}'<>\\/$´`~^|€£◉◉◉◉◉-+=%*!?#@&_:;,.1203467589";
	} else {
		barHeight = 72;

		buttonHeight = 60;
		horzMargin = 4;
		buttonSpacing = 6;

		//_keys = @"TTTTT()\"[]{}'<>\\/$´`~^|€£◉◉◉◉◉-+=%*!?#@&_:;,.1203467589";
    }
    bounds = CGRectMake(0, 0, barWidth, barHeight);
}

+ (CGRect)bounds
{
	return bounds;
}

- (instancetype)initWithDelegate:(id <UITextInput>)del;
{
	if((self = [super initWithFrame:[KOKeyboardRow bounds] inputViewStyle:UIInputViewStyleKeyboard])) {
		self.koDelegate = del;
	}
	//NSLog(@"FRAME: %@", NSStringFromCGRect(self.frame));
	return self;
}

- (void)setup
{
	if(_animation == koSnapbackAnimation) {
		animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
		animator.delegate = self;
	}

	NSUInteger firstIdx = [self.subviews count];
	
	// NSLog(@"self.subviews %d %@", [self.subviews count], self.subviews);
	
	NSInteger buttonCount = ([_keys length]+4)/5;
	assert(buttonCount);

	enclosingViews	= [NSMutableArray arrayWithCapacity:buttonCount];
	pConstraints	= [NSMutableSet setWithCapacity:buttonCount];
	lConstraints	= [NSMutableSet setWithCapacity:buttonCount];
	
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth; // UIViewAutoresizingFlexibleHeight;
	[self setTranslatesAutoresizingMaskIntoConstraints:YES];

	NSInteger buttonWidth = (barWidth - buttonCount * buttonSpacing - 2*horzMargin) / buttonCount;
	assert(buttonWidth);
	
//NSInteger maxButtonWidth = (maxButtonWidth * 4)/3;	// somewhat bigger
//assert(maxButtonWidth);

	NSLayoutConstraint *lc;
	KOSwipeButton *b;
	NSUInteger verticalMargin = (barHeight - buttonHeight) / 2;
		
	UIView *c;
    for (NSInteger i = 0; i < buttonCount; i++) {
		UIView *lv = c;
		c = [UIView new];
		//c.backgroundColor = [UIColor yellowColor];

		[c setTranslatesAutoresizingMaskIntoConstraints:NO];
		c.clipsToBounds = YES;
		c.tag = i;
		[self addSubview:c];
		[enclosingViews addObject:c];

        b = [[KOSwipeButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
		b.tag = i;
		[b setTranslatesAutoresizingMaskIntoConstraints:NO];
		[c addSubview:b];
		
		// SET UP IMAGE

		// Insure the button never has a negative width
		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:1 constant:0];
		[b addConstraint:lc];
		// Center it in the containing view
		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:c attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
		[c addConstraint:lc];
		// Button height never changes
		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:buttonHeight];
		[b addConstraint:lc];
		// Top margin never changes
		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:c attribute:NSLayoutAttributeTop multiplier:1 constant:verticalMargin];
		[c addConstraint:lc];
		// Container pinned to bottom ...
		lc = [NSLayoutConstraint constraintWithItem:c attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
		[self addConstraint:lc];
		// ... and top of the Keyboard Row
		lc = [NSLayoutConstraint constraintWithItem:c attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
		[self addConstraint:lc];

		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:c attribute:NSLayoutAttributeLeading multiplier:1 constant:buttonSpacing/2];
		lc.priority = UILayoutPriorityRequired - 2;
		[c addConstraint:lc];
	
		// left
		if(lv) {
			lc = [NSLayoutConstraint constraintWithItem:c attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lv attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
			[self addConstraint:lc];
		}
		
        b.keys = [_keys substringWithRange:NSMakeRange(i * 5, 5)];
		b.delegate = self;
    }
	// Pin to self
	{
		UIView *v;
		
		v = [enclosingViews firstObject];
		lc = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:horzMargin];
		[self addConstraint:lc];
	
		v = [enclosingViews lastObject];
		lc = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-horzMargin];
		[self addConstraint:lc];
	}

	// should really test for cursor control since need a "normal" view
	UIView *firstPortraitView	= enclosingViews[ [_portraitSet firstIndex] ];
	UIView *firstLandscapeView	= enclosingViews[ [_landscapeSet firstIndex] ];
	KOSwipeButton *firstPortraitButton = [firstPortraitView.subviews lastObject];
	KOSwipeButton *firstLandscapeButton = [firstLandscapeView.subviews lastObject];
	assert(firstPortraitButton);
	assert(firstLandscapeButton);
	
	[enclosingViews enumerateObjectsUsingBlock:^(UIView *enclosingView, NSUInteger idx, BOOL *stop)
		{
			//NSLog(@"BUTTON: %@ subviews: %@", enclosingView, enclosingView.subviews);
			KOSwipeButton *button = [enclosingView.subviews lastObject];
			assert(button);

			NSLayoutConstraint *le;
			if([button isTrackingPoint]) {
				le = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:button.bounds.size.height];
				le.priority = UILayoutPriorityRequired - 1;
				[button addConstraint:le];
			} else {
				if([_portraitSet containsIndex:idx] && enclosingView != firstPortraitView) {
					le = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstPortraitButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
					le.priority = UILayoutPriorityRequired - 1;
					[self addConstraint:le];
				}
				if([_landscapeSet containsIndex:idx] && enclosingView != firstLandscapeView) {
					le = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstLandscapeButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
					le.priority = UILayoutPriorityRequired - 1;
					[self addConstraint:le];
				}
			}

			NSLayoutConstraint *l0 = [NSLayoutConstraint constraintWithItem:enclosingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0 multiplier:1 constant:0];
			[enclosingView addConstraint:l0];
			if([_portraitSet containsIndex:idx]) [pConstraints addObject:l0];
			if([_landscapeSet containsIndex:idx]) [lConstraints addObject:l0];
		} ];
	
	UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	[self switchToOrientation:interfaceOrientation];

#if 0 // we get this "for free" now
	CGFloat height = isRetina ? 0.5f : 1;
    UIView *border1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barWidth, height)];
	border1.tag = 100;
    border1.backgroundColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1.];
    border1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self insertSubview:border1 atIndex:0];
#endif

#if 1
	CGFloat height = isRetina ? 0.5f : 1;
    UIView *border2 = [[UIView alloc] initWithFrame:CGRectMake(0, barHeight-height, barWidth, height)];
	border2.tag = 102;
    border2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.];
    border2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self insertSubview:border2 atIndex:firstIdx];
#endif
	//self.tintColor = [CreateButton backgroundColorForType:UIKeyboardAppearanceLight]; // barTintColor
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self setNeedsUpdateConstraints];
	[self setNeedsLayout];
}

- (void)setKoDelegate:(id<UITextInput>)del
{
	_koDelegate = del;
	if([_koDelegate isKindOfClass:[UITextView class]]) {
		((UITextView *)_koDelegate).inputAccessoryView = self;
	} else
	if([_koDelegate isKindOfClass:[UITextField class]]) {
		((UITextField *)_koDelegate).inputAccessoryView = self;
	}
}

- (void)switchToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(interfaceOrientation);
	NSSet *oldSet = isPortrait ? lConstraints : pConstraints;
	NSSet *newSet = isPortrait ? pConstraints : lConstraints;

	[oldSet enumerateObjectsUsingBlock:^(NSLayoutConstraint *lc, BOOL *stop)
	{
		if([newSet containsObject:lc]) return;

		UIView *c = lc.firstItem;
		lc.constant = 0;
		c.clipsToBounds = YES;
	} ];
	[newSet enumerateObjectsUsingBlock:^(NSLayoutConstraint *lc, BOOL *stop)
	{
		UIView *c = lc.firstItem;
		lc.constant = 10000;
		c.clipsToBounds = NO;
	} ];

	[self needsUpdateConstraints];
}

-(void)updateConstraints
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

#if 0
	NSLog(@"layoutSubviews");
	[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSLog(@"View[%d]  = %@ sub %@", [obj tag], NSStringFromCGRect([obj frame]), NSStringFromCGRect([[[obj subviews] lastObject] frame]));
	}];
#endif
}

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void)insertText:(NSString *)text
{
	[[UIDevice currentDevice] playInputClick];

	if([_koDelegate isKindOfClass:[UITextView class]]) {
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
	} else
	if([_koDelegate isKindOfClass:[UITextField class]]) {
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
}

- (void)trackPointStarted
{
    startLocation = [_koDelegate caretRectForPosition:_koDelegate.selectedTextRange.start];
}

- (void)trackPointMovedX:(int)xdiff Y:(int)ydiff selecting:(BOOL)selecting
{
    CGPoint loc = CGPointMake( CGRectGetMidX(startLocation), CGRectGetMidY(startLocation) ) ;

	// Following line causes problems DFH
    //loc.origin.y += textView.contentOffset.y;
	if(selecting) ydiff = 0; // DFH
    
    UITextPosition *p1 = [_koDelegate closestPositionToPoint:loc];
    
    loc.x -= xdiff;
    loc.y -= ydiff;
    
    UITextPosition *p2 = [_koDelegate closestPositionToPoint:loc];
    
    if (!selecting) {
        p1 = p2;
    }
    UITextRange *r = [_koDelegate textRangeFromPosition:p1 toPosition:p2];
	
    _koDelegate.selectedTextRange = r;
}

- (void)trackPointEnded
{
	UITextRange *r = [_koDelegate selectedTextRange];
	if(!r.empty) {
		// need to defer this or the menu stops the button unhiliting
		dispatch_async(dispatch_get_main_queue(), ^
			{
				UITextRange *selectionRange	= [_koDelegate selectedTextRange];
				CGRect selectionStartRect	= [_koDelegate caretRectForPosition:selectionRange.start];
				CGRect selectionEndRect		= [_koDelegate caretRectForPosition:selectionRange.end];
				CGRect selectionRect		= CGRectUnion(selectionStartRect, selectionEndRect);

				// bring up edit menu.
				UIMenuController *theMenu = [UIMenuController sharedMenuController];
				UIView *view = (UIView *)_koDelegate;
				[theMenu setTargetRect:selectionRect inView:view];
				[theMenu setMenuVisible:YES animated:YES];
			} );
	}
}

- (void)finderDown:(UITouch *)t inView:(UIView *)view
{
	if(_animation == koNoAnimation) {
		return;
	}

	UIView *box = [view superview];
	originalTouchPt = [t locationInView:self];
	originalViewPt	= [box convertPoint:view.center toView:self];
	snapbackPosition = [view convertRect:view.bounds toView:self];
}

- (void)finderMoved:(UITouch *)t inView:(UIView *)view selectedLabel:(NSInteger)idx
{
	if(_animation == koNoAnimation) {
		return;
	}
	
	if(!snapButton) {
		UIView *box = [view superview];
		{
			CGRect frame = box.frame;
			//NSLog(@"BOX frame: %@", NSStringFromCGRect(snapbackPosition));
			minX = box.tag ? (frame.origin.x - buttonSpacing/2) : 0;
			maxX = frame.origin.x + frame.size.width + buttonSpacing/2 - view.bounds.size.width;
			minY = 0;
			maxY = barHeight - view.bounds.size.height;
		}

		originalSnapButton = (KOSwipeButton *)view;
		snapButton = [[KOSwipeButton alloc] initWithFrame:[box convertRect:view.frame toView:self]];
		snapButton.keys = originalSnapButton.keys;

		//NSLog(@"SnapShot frame: %@", NSStringFromCGRect(snapButton.frame));
		view.alpha = 0;
		[self addSubview:snapButton];
	}
	
	CGPoint pt = [t locationInView:self];
	
	CGFloat xDiff = pt.x - originalTouchPt.x;
	CGFloat yDiff = pt.y - originalTouchPt.y;
	
	CGPoint newOrigin = snapbackPosition.origin;
	newOrigin.x += xDiff;
	newOrigin.x = MAX(newOrigin.x, minX);
	newOrigin.x = MIN(newOrigin.x, maxX);
	newOrigin.y += yDiff;
	newOrigin.y = MAX(newOrigin.y, minY);
	newOrigin.y = MIN(newOrigin.y, maxY);
	
	snapButton.frame = (CGRect){ newOrigin, snapbackPosition.size };
	[snapButton selectLabel:idx];
}

- (void)finderUp:(UITouch *)t inView:(UIView *)view
{
	switch(_animation) {
	case koNoAnimation:
		return;
	
	case koTraditinalAnimation:
	{
		[UIView animateWithDuration:.100 animations:^{
			snapButton.frame = snapbackPosition;
		} completion:^(BOOL finished) {
			view.alpha = 1;
			[snapButton removeFromSuperview];
			snapButton = nil;
		} ];
	}	break;
	
	case koSnapbackAnimation:
	{
		UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:snapButton snapToPoint:originalViewPt];
		behavior.damping = 1;
		[animator addBehavior:behavior];
	}	break;
	}
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)ani
{
	//NSLog(@"pause centerNow=%@ desired=%@", NSStringFromCGPoint(snapButton.center), NSStringFromCGPoint(originalViewPt));
  	[UIView animateWithDuration:.10 animations:^{
		snapButton.frame = snapbackPosition;
	} completion:^(BOOL finished) {
		originalSnapButton.alpha = 1;
		originalSnapButton = nil;
		[snapButton removeFromSuperview];
		snapButton = nil;
	} ];

	[ani removeAllBehaviors];
}

@end
