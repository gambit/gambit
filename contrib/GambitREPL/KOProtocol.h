//
//  KOProtocol.h
//  KOKeyboard
//
//  Created by David Hoerl on 10/26/13.
//  Copyright (c) 2013 Adam Horacek. All rights reserved.
//

@protocol KOProtocol <NSObject>

- (void)trackPointStarted;
- (void)trackPointMovedX:(int)xdiff Y:(int)ydiff selecting:(BOOL)selecting;
- (void)trackPointEnded;
- (void)insertText:(NSString *)text;

// for animation
- (void)finderDown:(UITouch *)t inView:(UIView *)view;
- (void)finderMoved:(UITouch *)t inView:(UIView *)view selectedLabel:(NSInteger)idx;
- (void)finderUp:(UITouch *)t inView:(UIView *)view;

@end
