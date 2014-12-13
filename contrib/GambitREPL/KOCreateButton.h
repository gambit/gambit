//
//  KOCreateButton.h
//  CreateShadowedRoundRectButtonImage
//
//  Created by David Hoerl on 10/28/13.
//  Copyright (c) 2013 David Hoerl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Availability.h>

@interface KOCreateButton : NSObject

+ (UIColor *)backgroundColorForType:(UIKeyboardAppearance)type;

- (UIImage *)buttonImage:(CGSize)size type:(UIKeyboardAppearance)type;
- (UIImage *)altButtonImage:(CGSize)size type:(UIKeyboardAppearance)type;

- (UIImage *)buttonImage:(CGSize)size color:(UIColor *)color;

@end

#ifndef __IPHONE_7_0
#define UIKeyboardAppearanceDark UIKeyboardAppearanceAlert // 1
#define UIKeyboardAppearanceLight ((UIKeyboardAppearance)2)
#endif
