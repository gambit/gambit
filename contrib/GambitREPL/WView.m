//
//  WView.m
//
//  Created by Marc Feeley
//  Copyright 2014 UniversitÃ© de MontrÃ©al. All rights reserved.
//

#import "WView.h"

//-----------------------------------------------------------------------------

@implementation WView

#if 0

// UIKeyInput protocol methods

- (void) insertText:(NSString* )text
{
  NSLog(@"WView insertText: %@", text);
}

- (void)deleteBackward {
  NSLog(@"WView deleteBackward");
}

- (BOOL) canBecomeFirstResponder
{
  NSLog(@"WView canBecomeFirstResponder");
  //  return YES;
  return NO;
}

- (BOOL) resignFirstResponder
{
  NSLog(@"WView resignFirstResponder");
  return YES;
}

- (BOOL) hasText
{
  NSLog(@"WView hasText");
  return YES;
}

#endif

@end

//-----------------------------------------------------------------------------
