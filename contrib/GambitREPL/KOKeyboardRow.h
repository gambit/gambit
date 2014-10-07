//
//  KOKeyboardRow.h
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

typedef enum {koNoAnimation, koSnapbackAnimation, koTraditinalAnimation } koAnimation;

@interface KOKeyboardRow : UIInputView
#if !__has_feature(objc_arc)
@property (nonatomic, assign) koAnimation animation;      // animate swiping the button
@property (nonatomic, retain) NSString *portraitKeysSmall;  // 5 characters per button
@property (nonatomic, retain) NSString *landscapeKeysSmall; // 5 characters per button
@property (nonatomic, retain) NSString *portraitKeysLarge;  // 5 characters per button
@property (nonatomic, retain) NSString *landscapeKeysLarge; // 5 characters per button
@property (nonatomic, retain) NSIndexSet *portraitSet;      // which buttons to use in portrait mode
@property (nonatomic, retain) NSIndexSet *landscapeSet;     // which buttons to use in landscape mode
#else
@property (nonatomic, assign) koAnimation animation;      // animate swiping the button
@property (nonatomic, copy) NSString *portraitKeysSmall;  // 5 characters per button
@property (nonatomic, copy) NSString *landscapeKeysSmall; // 5 characters per button
@property (nonatomic, copy) NSString *portraitKeysLarge;  // 5 characters per button
@property (nonatomic, copy) NSString *landscapeKeysLarge; // 5 characters per button
@property (nonatomic, copy) NSIndexSet *portraitSet;      // which buttons to use in portrait mode
@property (nonatomic, copy) NSIndexSet *landscapeSet;     // which buttons to use in landscape mode
#endif

- (instancetype)init;

- (void)switchToOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)setup;

@end
