//
//  TView.h
//
//  Created by Marc Feeley
//  Copyright 2014 Université de Montréal. All rights reserved.
//

#import <UIKit/UITextView.h>
#import "KOKeyboardRow.h"

//-----------------------------------------------------------------------------

@interface TView : UITextView
{
@public

  KOKeyboardRow *kov;
  BOOL kbdShouldShrinkView;
  BOOL kbdEnabled;
}

@property (strong) KOKeyboardRow *kov;
@property (assign) BOOL kbdShouldShrinkView;
@property (assign) BOOL kbdEnabled;

@end

//-----------------------------------------------------------------------------
