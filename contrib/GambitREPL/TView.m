//
//  TView.m
//
//  Created by Marc Feeley
//  Copyright 2014 UniversitÃ© de MontrÃ©al. All rights reserved.
//

#import "TView.h"
#import "ViewController.h"

//-----------------------------------------------------------------------------

@implementation TView

@synthesize kov, kbdShouldShrinkView, kbdEnabled;

- (instancetype) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}


- (void) setup {

  kbdShouldShrinkView = NO;
  kbdEnabled = NO;
}


- (id)inputAccessoryView {
  return [theViewController get_inputAccessoryView];
}

@end

//-----------------------------------------------------------------------------
