//
//  WView.m
//
//  Created by Marc Feeley
//  Copyright 2014 UniversitÃ© de MontrÃ©al. All rights reserved.
//

#import "WView.h"
#import "ViewController.h"

//-----------------------------------------------------------------------------


#ifdef USE_PRIVATE_API

@interface UIWebBrowserView : UIView
@end

@implementation UIWebBrowserView (CustomToolbar)

- (id)inputAccessoryView {
  return [theViewController get_inputAccessoryView];
}

@end

#else

#import "objc/runtime.h"    

@interface _GambitREPLHelper : NSObject
@end

@implementation _GambitREPLHelper

- (id)inputAccessoryView {
  return [theViewController get_inputAccessoryView];
}

@end

#endif

//-----------------------------------------------------------------------------

@implementation WView

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

#ifndef USE_PRIVATE_API

  UIView *subview = nil;

  for (UIView *v in self.scrollView.subviews) {
    if ([[v.class description] hasPrefix:@"UIWeb"])
      subview = v;
  }

  if (subview == nil) return;

  NSString *name = [NSString stringWithFormat:@"%@_GambitREPLHelper", subview.class.superclass];
  Class newClass = NSClassFromString(name);

  if (newClass == nil) {

    newClass = objc_allocateClassPair(subview.class, [name cStringUsingEncoding:NSASCIIStringEncoding], 0);
    if (newClass == nil) return;

    Method method = class_getInstanceMethod([_GambitREPLHelper class], @selector(inputAccessoryView));
    class_addMethod(newClass, @selector(inputAccessoryView), method_getImplementation(method), method_getTypeEncoding(method));

    objc_registerClassPair(newClass);
  }

  object_setClass(subview, newClass);

#endif
}


@end

//-----------------------------------------------------------------------------
