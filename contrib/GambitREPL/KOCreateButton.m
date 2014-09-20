//
//  KOCreateButton.m
//  CreateShadowedRoundRectButtonImage
//
//  Created by David Hoerl on 10/28/13.
//  Copyright (c) 2013 David Hoerl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "KOCreateButton.h"

typedef struct { CGFloat whiteColor ; CGFloat opacity; } setting;

typedef struct {
	CGFloat		keyboardBackColor;
	CGFloat		keyBackColor;
	CGFloat		keyShadowColor;
	//CGFloat	keyFontColor;		// not changing in 7.0

	CGFloat		altKeyBackColor;
	CGFloat		altKeyShadowColor;
	//CGFloat	altKeyFontColor;	// not changing in 7.0
} keyboardVariant;

typedef struct {
	setting		keyboardBackSetting;
	setting		keyBackColorSetting;
	setting		keyShadowColorSetting;
	
	setting		altKeyBackColorSetting;
	setting		altKeyShadowColorSetting;
	
} settings;

static settings whiteKeyboardSettings, blackKeyboardSettings;

static BOOL isIdiomPhone;

@implementation KOCreateButton

+ (void)initialize
{
	isIdiomPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
	
	// Using 'Pixie' observe values of the keyboard with an all white or all black background, to compute white and opacity
	// NOTE: black values must be somewhat smaller than the light ones or you get divide by null
	if(isIdiomPhone) {
		// White Keyboard
		{
			keyboardVariant white = { .87f, .99f, .53f,   .77f, .53f };
			keyboardVariant black = { .65f, .98f, .40f,   .66f, .40f };	// Alt Font was .39 no opacity
			whiteKeyboardSettings = [self defineWithWhiteBackground:white blackBackground:black];
		}
		// Black Keyboard
		{
			keyboardVariant white = { .36f, .55f, .21f,   .42f, .21f };
			keyboardVariant black = { .08f, .35f, .05f,   .20f, .05f };	// Alt Font 1.0
			blackKeyboardSettings = [self defineWithWhiteBackground:white blackBackground:black];
		}
	} else {
		// White Keyboard
		{
			keyboardVariant white = { .82f, .99f, .49f,   .75f, .49f };
			keyboardVariant black = { .81f, .98f, .48f,   .74f, .48f };	// Alt Font 1.0
			whiteKeyboardSettings = [self defineWithWhiteBackground:white blackBackground:black];
		}
		// Black Keyboard
		{
			keyboardVariant white = { .05f, .34f, .03f,   .19f, .03f };
			keyboardVariant black = { .04f, .33f, .02f,   .18f, .02f };	// Alt Font 1.0
			blackKeyboardSettings = [self defineWithWhiteBackground:white blackBackground:black];
		}
	}
}

+ (UIColor *)backgroundColorForType:(UIKeyboardAppearance)type
{
	setting s = type == UIKeyboardAppearanceLight ? whiteKeyboardSettings.keyboardBackSetting : blackKeyboardSettings.keyboardBackSetting;
	return 	[UIColor colorWithRed:s.whiteColor-.01 green:s.whiteColor blue:s.whiteColor+.01 alpha:s.opacity];
}

+ (settings)defineWithWhiteBackground:(keyboardVariant)white blackBackground:(keyboardVariant)black
{
	settings v;

	v.keyboardBackSetting		= [self solveForWhite:white.keyboardBackColor black:black.keyboardBackColor whiteBG:1 blackBG:0];
	v.keyBackColorSetting		= [self solveForWhite:white.keyBackColor black:black.keyBackColor whiteBG:white.keyboardBackColor blackBG:black.keyboardBackColor];
	v.keyShadowColorSetting		= [self solveForWhite:white.keyShadowColor black:black.keyShadowColor whiteBG:white.keyboardBackColor blackBG:black.keyboardBackColor];

	v.altKeyBackColorSetting	= [self solveForWhite:white.altKeyBackColor black:black.altKeyBackColor whiteBG:white.keyboardBackColor blackBG:black.keyboardBackColor];
	v.altKeyShadowColorSetting	= [self solveForWhite:white.altKeyShadowColor black:black.altKeyShadowColor whiteBG:white.keyboardBackColor blackBG:black.keyboardBackColor];

	return v;
}

+ (setting)solveForWhite:(CGFloat)white black:(CGFloat)black whiteBG:(CGFloat)wBG blackBG:(CGFloat)bBG
{
	// Solve two equations in two variables:
	//   bBG(1-opacity) + whiteColor*opacity = black
	//   wBG(1-opacity) + whiteColor*opacity = white

	if(isIdiomPhone) {
		CGFloat a = black - bBG;
		CGFloat b = white - wBG;
		
		CGFloat colorDiff = (a - b);
		CGFloat backgDiff = (wBG - bBG);
		
		CGFloat opacity = colorDiff / backgDiff;
		opacity = MIN(1, opacity);
		opacity = MAX(0, opacity);

		CGFloat whiteColor = b/opacity + wBG;
		whiteColor = MIN(1, whiteColor);
		whiteColor = MAX(0, whiteColor);
		assert(whiteColor);

		setting setting;
		setting.opacity = opacity;
		setting.whiteColor = whiteColor;
		
		return setting;
	} else {
		setting setting;
		setting.opacity = 1;
		setting.whiteColor = white;
		return setting;
	}
}

- (UIImage *)buttonImage:(CGSize)size type:(UIKeyboardAppearance)type
{
	return [self buttonImage:size type:type isAlt:NO foreColor:nil];
}

- (UIImage *)altButtonImage:(CGSize)size type:(UIKeyboardAppearance)type
{
	return [self buttonImage:size type:type isAlt:YES foreColor:nil];
}

- (UIImage *)buttonImage:(CGSize)size color:(UIColor *)color
{
	return [self buttonImage:size type:UIKeyboardAppearanceLight isAlt:NO foreColor:color];
}


- (UIImage *)buttonImage:(CGSize)size type:(UIKeyboardAppearance)type isAlt:(BOOL)altButton foreColor:(UIColor *)specColor
{
	CGFloat cornerRadius = isIdiomPhone ? 4 : 7;
	setting foreSetting, shadowSetting;

	if(altButton) {
		foreSetting	  = type == UIKeyboardAppearanceLight ? whiteKeyboardSettings.altKeyBackColorSetting : blackKeyboardSettings.altKeyBackColorSetting;
		shadowSetting = type == UIKeyboardAppearanceLight ? whiteKeyboardSettings.altKeyShadowColorSetting : blackKeyboardSettings.altKeyShadowColorSetting;
	} else {
		foreSetting	  = type == UIKeyboardAppearanceLight ? whiteKeyboardSettings.keyBackColorSetting : blackKeyboardSettings.keyBackColorSetting;
		shadowSetting = type == UIKeyboardAppearanceLight ? whiteKeyboardSettings.keyShadowColorSetting : blackKeyboardSettings.keyShadowColorSetting;
	}

	UIColor *foregroundColor	= [UIColor colorWithRed:foreSetting.whiteColor-.01 green:foreSetting.whiteColor blue:foreSetting.whiteColor+.01 alpha:foreSetting.opacity];
	UIColor *shadowColor		= [UIColor colorWithRed:shadowSetting.whiteColor-.01 green:shadowSetting.whiteColor blue:shadowSetting.whiteColor+.01 alpha:shadowSetting.opacity];

	CGRect frame = (CGRect){ {0,0}, size };
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);	// NO -> not opaque

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode(context, kCGBlendModeCopy);

	if(isIdiomPhone && altButton) {
		UIColor *altColor = [UIColor colorWithRed:foreSetting.whiteColor+.05 green:foreSetting.whiteColor+.06 blue:foreSetting.whiteColor+.07 alpha:foreSetting.opacity];
		[self drawRoundRectofSize:frame inContext:context color:altColor radius:cornerRadius];
		frame.size.height -= 1;
		frame.origin.y += 1;
		[self drawRoundRectofSize:frame inContext:context color:shadowColor radius:cornerRadius];
	} else {
		[self drawRoundRectofSize:frame inContext:context color:shadowColor radius:cornerRadius];
	}
	frame.size.height -= 1;
	UIColor *drawColor = specColor ? specColor : foregroundColor;
	[self drawRoundRectofSize:frame inContext:context color:drawColor radius:cornerRadius];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return image;
}


- (void)drawRoundRectofSize:(CGRect)rect inContext:(CGContextRef)context color:(UIColor *)fillColor radius:(CGFloat)radius
{
	CGContextSetFillColorWithColor(context, fillColor.CGColor);

	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
				radius, M_PI, M_PI / 2, 1); //STS fixed
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, 
						rect.origin.y + rect.size.height);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, 
				rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
				radius, 0.0f, -M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, 
				-M_PI / 2, M_PI, 1);

	CGContextFillPath(context);
}

@end
