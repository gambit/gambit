//
//  ITView.m
//
//  Created by Marc Feeley
//  Copyright 2014 UniversitÃ© de MontrÃ©al. All rights reserved.
//

#import "ITView.h"
#import "ViewController.h"

//-----------------------------------------------------------------------------

@implementation ITView

- (id)inputAccessoryView {
  return [theViewController get_inputAccessoryView];
}

@end

//-----------------------------------------------------------------------------
