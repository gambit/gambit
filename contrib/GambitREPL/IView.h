//
//  IView.h
//
//  Created by Marc Feeley
//  Copyright 2014 Université de Montréal. All rights reserved.
//

#import <UIKit/UIImageView.h>
#import "KOKeyboardRow.h"

//-----------------------------------------------------------------------------

@interface IView : UIImageView
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
