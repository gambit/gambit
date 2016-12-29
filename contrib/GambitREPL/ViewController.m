//
//  ViewController.m
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011-2012 UniversitÃ© de MontrÃ©al. All rights reserved.
//
#define DEBUG_UI_not

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "KOKeyboardRow.h"
#import "WView.h"
#import "TView.h"
#import "IView.h"
#import "ITView.h"


ViewController *theViewController = nil;

//-----------------------------------------------------------------------------

@implementation ViewController

@synthesize segmCtrl, currentView, haveExtKeyboard, haveVisibleSoftKeyboard, inShowView, inCheckExtKeyboard, inputTextView, inputTextViewEnable, cancelButton, navToolbar, timer, queuedActions, locationManager, metadataQuery;

//-----------------------------------------------------------------------------

// Gambit setup/cleanup.


/*
 * ___VERSION must match the version number of the Gambit header file.
 */

#define ___VERSION 408007
#include "gambit.h"

/*
 * Define SCHEME_LIBRARY_LINKER as the name of the Scheme library
 * prefixed with "____20_" and suffixed with "__".  This is the
 * function that initializes the Scheme library.
 */

#define SCHEME_LIBRARY_LINKER ____20_program__

___BEGIN_C_LINKAGE
extern ___mod_or_lnk SCHEME_LIBRARY_LINKER (___global_state_struct*);
___END_C_LINKAGE


extern char **main_argv;
___UCS_2 ucs2_gambitdir[1024];

void gambit_setup()
{
  /*
   * Setup the Scheme library by calling "___setup" with appropriate
   * parameters.  The call to "___setup_params_reset" sets all
   * parameters to their default setting.
   */

  int debug_settings = ___DEBUG_SETTINGS_INITIAL;
  ___UCS_2STRING *ucs2_argv;
  int last_dir_sep;
  int i;

  if (___NONNULLSTRINGLIST_to_NONNULLUCS_2STRINGLIST
        (main_argv,
         &ucs2_argv,
         ___CHAR_ENCODING_UTF_8)
      != ___FIX(___NO_ERR))
    exit(1);

  last_dir_sep = 0;
  i = 0;

  while (ucs2_argv[0][i] != '\0')
    {
      if (ucs2_argv[0][i] == '/')
        last_dir_sep = i;
      i++;
    }

  for (i=0; i<last_dir_sep; i++)
    ucs2_gambitdir[i] = ucs2_argv[0][i];

  ucs2_gambitdir[i] = '\0';

  // Set debugging settings so that all threads with uncaught
  // exceptions start a REPL.

  debug_settings =
    (debug_settings
     & ~___DEBUG_SETTINGS_UNCAUGHT_MASK)
    | (___DEBUG_SETTINGS_UNCAUGHT_ALL
       << ___DEBUG_SETTINGS_UNCAUGHT_SHIFT);

  debug_settings =
    (debug_settings
     & ~___DEBUG_SETTINGS_ERROR_MASK)
    | (___DEBUG_SETTINGS_ERROR_REPL
       << ___DEBUG_SETTINGS_ERROR_SHIFT);

  ___setup_params_struct setup_params;

  ___setup_params_reset (&setup_params);

  setup_params.version        = ___VERSION;
  setup_params.linker         = SCHEME_LIBRARY_LINKER;
  setup_params.argv           = ucs2_argv;
  setup_params.gambitdir      = ucs2_gambitdir;
  setup_params.debug_settings = debug_settings;

  ___setup (&setup_params);

  ___disable_interrupts_pstate (___PSTATE);
}


void gambit_cleanup()
{
  ___cleanup ();
}


//-----------------------------------------------------------------------------

- (void)viewDidLoad {

  [super viewDidLoad];

  theViewController = self;

  //[self xtrace];//trace all methods

  currentView = -1;
  haveExtKeyboard = NO;
  haveVisibleSoftKeyboard = NO;
  inCheckExtKeyboard = NO;
  inShowView = NO;

  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screen_w = screenRect.size.width;
  CGFloat screen_h = screenRect.size.height;
  CGFloat bar_y = navToolbar.bounds.origin.y;
  CGFloat bar_h = navToolbar.bounds.size.height;

  bar_y = 0; // ignore toolbar
  bar_h = 0;

  CGRect viewRect = CGRectMake(0, bar_y+bar_h, screen_w, screen_h-(bar_y+bar_h));

  // Create inputTextView which manages keyboard input for webViews
  inputTextView = [[ITView alloc] initWithFrame:CGRectMake(-500, -500, 100, 100)];
  //inputTextView = [[ITView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];

  // turn off automatic capitalization, correction and spell checking
  inputTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
  inputTextView.autocorrectionType = UITextAutocorrectionTypeNo;
  inputTextView.spellCheckingType = UITextSpellCheckingTypeNo;

  // UpArrow doesn't work when hidden
  //[inputTextView setHidden:YES];
  inputTextView.delegate = self;

  [self.view insertSubview:inputTextView atIndex:0];

  inputTextViewEnable = YES;

  // Unneeded
  //inputTextView.layoutManager.allowsNonContiguousLayout = NO;

  // Create webViews

  for (int i=NB_WEBVIEWS-1; i>=0; i--) {
    WView *webView = [[WView alloc] initWithFrame:viewRect];

    // automatic capitalization et al. are turned off in the HTML code

    webView.backgroundColor = [UIColor clearColor];
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.scalesPageToFit = NO;
    webView.scrollView.bounces = NO;
    webView.keyboardDisplayRequiresUserAction = NO;
    webView.hidden = YES;
    webView.delegate = self;
    [self.view insertSubview:webView atIndex:0];
    webViews[i] = webView;
  }

  // Create textViews

  for (int i=NB_TEXTVIEWS-1; i>=0; i--) {
    TView *textview = [[TView alloc] initWithFrame:viewRect];

    // turn off automatic capitalization, correction and spell checking
    textview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textview.autocorrectionType = UITextAutocorrectionTypeNo;
    textview.spellCheckingType = UITextSpellCheckingTypeNo;

    textview.kbdShouldShrinkView = YES;
    textview.kbdEnabled = YES;

    textview.backgroundColor = [UIColor clearColor];
    textview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    textview.hidden = YES;
    textview.delegate = self;
    [self.view insertSubview:textview atIndex:0];
    textViews[i] = textview;
  }

  // Create imageViews

  for (int i=NB_IMAGEVIEWS-1; i>=0; i--) {
    IView *imageview = [[IView alloc] initWithFrame:viewRect];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    imageview.hidden = YES;
    [self.view insertSubview:imageview atIndex:0];
    imageViews[i] = imageview;
  }

  for (int i=0; i<NB_WEBVIEWS+NB_TEXTVIEWS; i++) {

    set_ext_keys(i,
                 @"*^+!?/\\-,.2406835179'\"(`~:;)@#",
                 @"<>=S_*^+!?/\\-,.2406835179'\"(`~:;)@#",
                 @"SSSSSbcade<<<&$[]={}>>>|%*^+!?/\\-,.2406835179'\"(`~:;)@#",
                 @"SSSSSbcade<<<&$[]={}>>>|%*^+!?/\\-,.2406835179'\"(`~:;)@#");
  }

  set_textView_font(0, @"Courier", 16);

  segmCtrl.selectedSegmentIndex = UISegmentedControlNoSegment;
  //segmCtrl.segmentedControlStyle = UISegmentedControlStyleBordered;
  //segmCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
  //segmCtrl.apportionsSegmentWidthsByContent = YES;
  //  segmCtrl.backgroundColor = [UIColor clearColor];

  //  UIColor *tintcolor = [UIColor greenColor];
  //  [[segmCtrl.subviews objectAtIndex:0] setTintColor:tintcolor];

  [segmCtrl sizeToFit];

  // get rid of shadow line at top of toolbar
  navToolbar.backgroundColor = [UIColor clearColor];
  if ([navToolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
    [navToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  }
  if ([navToolbar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)]) {
    [navToolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
  }

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(keyboardWillShow:)
           name:UIKeyboardWillShowNotification
         object:nil];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(keyboardWillHide:)
           name:UIKeyboardWillHideNotification
         object:nil];

  timer = nil;

  queuedActions = [[NSMutableArray alloc] init];

  locationManager = nil;

  gambit_setup();

#ifdef USE_ICLOUD

  self.metadataQuery = nil;

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(iCloudAccountAvailabilityChanged:)
           name:NSUbiquityIdentityDidChangeNotification
         object:nil];

#endif

  [self heartbeat_tick];
}


- (void)viewDidUnload {

  [super viewDidUnload];

  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:UIKeyboardWillShowNotification
            object:nil];

  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:UIKeyboardWillHideNotification
            object:nil];

#ifdef USE_ICLOUD

  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:NSUbiquityIdentityDidChangeNotification
            object:nil];

#endif

  segmCtrl = nil;

  cancelButton = nil;

  navToolbar = nil;

  theViewController = nil;

  gambit_cleanup();
}


- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

  return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
  [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

  //NSLog(@"WILL ANIMATE!");

  int view = currentView;

  if (view >= 0) {
    if (view < NB_WEBVIEWS) {
      WView *wv = webViews[view];
      [wv.kov switchToOrientation:interfaceOrientation];
    } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
      TView *tv = textViews[view-NB_WEBVIEWS];
      [tv.kov switchToOrientation:interfaceOrientation];
    }
  }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Text view delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {

#ifdef DEBUG_UI
  NSLog(@"textViewShouldBeginEditing");
#endif

  return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {

#if 1

#ifdef DEBUG_UI
  NSLog(@"textViewShouldEndEditing");
#endif

  [aTextView resignFirstResponder];
  return YES;

#else

  return NO;

#endif
}


void checkExtKeyboard_tail(UIView *v, BOOL become_first_responder) {

  ViewController *vc = theViewController;

  [v resignFirstResponder];

  vc.inCheckExtKeyboard = NO;

  if (become_first_responder) {
    [v becomeFirstResponder];
  }
}


void checkExtKeyboard(UIView *v, BOOL become_first_responder) {

  ViewController *vc = theViewController;

  // Check for the external keyboard (which disables soft keyboard).

  vc.inCheckExtKeyboard = YES;
  vc.haveExtKeyboard = YES;

#ifdef DEBUG_UI
  NSLog(@"checkExtKeyboard [v becomeFirstResponder];");
#endif

  [v becomeFirstResponder];

#ifdef DEBUG_UI
  if (vc.haveExtKeyboard) {
    NSLog(@"checkExtKeyboard haveExtKeyboard = YES");
  } else {
    NSLog(@"checkExtKeyboard haveExtKeyboard = NO");
  }
#endif

#ifdef DEBUG_UI
  NSLog(@"checkExtKeyboard [v resignFirstResponder];");
#endif

  // avoid bug on old iOS
  if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.1) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0),
                   dispatch_get_main_queue(),
                   ^(void){ checkExtKeyboard_tail(v, become_first_responder); });
  } else {
    checkExtKeyboard_tail(v, become_first_responder);
  }
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {

  haveVisibleSoftKeyboard = YES;

  if (inCheckExtKeyboard) haveExtKeyboard = NO;

  int view = currentView;

#ifdef DEBUG_UI
  NSLog(@"keyboardWillShow view=%d %@",view,inShowView?@"":@"***NOT-IN-show_view***");
#endif

  NSDictionary *userInfo = [notification userInfo];

  // Get the end position of the keyboard
  NSValue *kbdFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

  // Get the top of the keyboard as the y coordinate of its origin in
  // self's view's coordinate system. The bottom of the view's
  // frame should align with the top of the keyboard's final position.
  CGRect kbdFrameEnd = [kbdFrameEndValue CGRectValue];
  kbdFrameEnd = [self.view convertRect:kbdFrameEnd fromView:nil];

#ifdef DEBUG_UI
  //  NSLog(@"%0.0f %0.0f %0.0f",kbdFrameEnd.origin.y,kbdFrameEnd.size.height,self.view.bounds.size.height);
#endif

  if (kbdFrameEnd.origin.y + kbdFrameEnd.size.height == self.view.bounds.size.height) {
    haveVisibleSoftKeyboard = YES;
    haveExtKeyboard = NO;
    //NSLog(@".... showing main soft keyboard");
  } else {
    //NSLog(@".... only showing accessory view");
  }

  if (view >= 0) {

    UIView *v = nil;
    BOOL kbdEnabled = NO;

    if (view < NB_WEBVIEWS) {
      WView *wv = webViews[view];
      kbdEnabled = wv.kbdEnabled;
      if (wv.kbdShouldShrinkView)
        v = wv;
    } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
      TView *tv = textViews[view-NB_WEBVIEWS];
      kbdEnabled = tv.kbdEnabled;
      if (tv.kbdShouldShrinkView)
        v = tv;
    }

    if (v != nil) {

      /*
        Reduce the size of the view so that it's not obscured by
        the keyboard.  Animate the resize so that it's in sync with
        the appearance of the keyboard.
      */

      CGFloat keyboardTop = kbdFrameEnd.origin.y;
      CGRect newViewFrame = self.view.bounds;
      newViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;

      // Get the duration of the animation.
      NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
      NSTimeInterval animationDuration;
      [animationDurationValue getValue:&animationDuration];

      // Animate the resize of the view's frame in sync with the
      // keyboard's appearance.
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:animationDuration];

      v.frame = newViewFrame;

      [UIView commitAnimations];
    }

    if (kbdEnabled && !inShowView && !inCheckExtKeyboard) {
#if 1
      //[self send_event:@"soft-keyboard-show"];
#else
#if 1
      show_view(view, YES);
#else
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0),
                     dispatch_get_main_queue(),
                     ^(void){ show_view(theViewController.currentView, YES); });
#endif
#endif
    }
  }
}


- (void)keyboardWillHide:(NSNotification *)notification {

  haveVisibleSoftKeyboard = NO;

  int view = currentView;

#ifdef DEBUG_UI
  NSLog(@"keyboardWillHide view=%d %@",view,inShowView?@"":@"***NOT-IN-show_view***");
#endif

  if (view >= 0) {

    UIView *v = nil;
    BOOL kbdEnabled = NO;

    if (view < NB_WEBVIEWS) {
      WView *wv = webViews[view];
      kbdEnabled = wv.kbdEnabled;
      v = wv;
    } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
      TView *tv = textViews[view-NB_WEBVIEWS];
      kbdEnabled = tv.kbdEnabled;
      v = tv;
    }

    if (v != nil) {

      NSDictionary* userInfo = [notification userInfo];

      /*
        Restore the size of the view (fill self's view).  Animate
        the resize so that it's in sync with the disappearance of the
        keyboard.
      */

      NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
      NSTimeInterval animationDuration;
      [animationDurationValue getValue:&animationDuration];

      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:animationDuration];

      v.frame = self.view.bounds;

      [UIView commitAnimations];
    }

    if (kbdEnabled && !inShowView && !inCheckExtKeyboard) {
#if 1
      //[self send_event:@"soft-keyboard-hide"];
#else
#if 1
      show_view(view, NO);
#else
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0),
                     dispatch_get_main_queue(),
                     ^(void){ show_view(theViewController.currentView, NO); });
#endif
#endif
    }
  }
}


#include "intf.h"


void set_ext_keys(int view, NSString *portrait_small, NSString *landscape_small, NSString *portrait_large, NSString *landscape_large) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      KOKeyboardRow *kov = [[KOKeyboardRow alloc] init];

      kov.portraitKeysSmall  = portrait_small;
      kov.landscapeKeysSmall = landscape_small;
      kov.portraitKeysLarge  = portrait_large;
      kov.landscapeKeysLarge = landscape_large;

      [kov setup];

      if (view >= 0) {
        if (view < NB_WEBVIEWS) {
          WView *wv = vc->webViews[view];
          wv.kov = kov;
        } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
          TView *tv = vc->textViews[view-NB_WEBVIEWS];
          tv.kov = kov;
        }
      }
    }
}


void set_navigation(int n) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->segmCtrl
          removeTarget:vc
          action:@selector(navigation_changed:)
          forControlEvents:UIControlEventValueChanged];
      vc->segmCtrl.selectedSegmentIndex = n;
      [vc->segmCtrl
          addTarget:vc
          action:@selector(navigation_changed:)
          forControlEvents:UIControlEventValueChanged];
    }
}


- (void)queue_action:(void(^)())action {

  [queuedActions addObject:[action copy]];
}


- (void)queue_action_asap:(void(^)())action {

  [self queue_action:action];

  [self schedule_next_heartbeat_tick:0.0];
}


- (void)send_event:(NSString*)name {

  [self queue_action_asap:^{ send_event(name); }];
}


- (void)send_text_input:(NSString*)input {

  [self queue_action_asap:^{ send_text_input(input); }];
}


- (void)send_key_input:(NSString*)input {

  [self queue_action_asap:^{ send_key_input(input); }];
}


- (void)heartbeat_tick {

  [self queue_action:^{ [self schedule_next_heartbeat_tick:heartbeat()]; }];

  ___enable_interrupts_pstate (___PSTATE);

  while ([queuedActions count] > 0)
    {
      void (^action)(void) = [queuedActions objectAtIndex:0];
      [queuedActions removeObjectAtIndex:0];

      ___ON_THROW(
        {
          action();
        },
        exit(0);
      );
    }

  ___disable_interrupts_pstate (___PSTATE);
}


- (void)schedule_next_heartbeat_tick:(double)interval {

  if (interval >= 0)
    {
      if (timer != nil)
        {
          [timer invalidate];

#if !__has_feature(objc_arc)
          [timer release];
#endif
        }

      timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(heartbeat_tick) userInfo:nil repeats:NO];

#if !__has_feature(objc_arc)
      [timer retain];
#endif
    }
}


- (void)app_become_active {

  [self send_event:@"app-become-active"];
}


- (id)get_inputAccessoryView {

  int view = currentView;

  if (!haveExtKeyboard) {
    if (view >= 0) {
      if (view < NB_WEBVIEWS) {
        WView *wv = webViews[view];
        if (wv.kbdEnabled) {
#ifdef DEBUG_UI
          NSLog(@"****** inputAccessoryView = wv.kov");
#endif
          return wv.kov;
        }
      } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
        TView *tv = textViews[view-NB_WEBVIEWS];
        if (tv.kbdEnabled) {
#ifdef DEBUG_UI
          NSLog(@"****** inputAccessoryView = tv.kov");
#endif
          return tv.kov;
        }
      }
    }
  }

#ifdef DEBUG_UI
  NSLog(@"****** inputAccessoryView = nil");
#endif

  return nil;
}


void show_cancelButton() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->cancelButton.hidden = NO;
    }
}


void hide_cancelButton() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->cancelButton.hidden = YES;
    }
}


#if 0

void preload_kbd_now() {

  UITextField *field = [UITextField new];
  [[[[UIApplication sharedApplication] windows] lastObject] addSubview:field];
  [field becomeFirstResponder];
  [field resignFirstResponder];
  [field removeFromSuperview];
}

void preload_kbd() {

  static BOOL preloaded = false;

  if (!preloaded) {
    preloaded = true;
#if 0
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0),
                   dispatch_get_main_queue(),
                   ^(void){ preload_kbd_now(); });
#else
    preload_kbd_now();
#endif
  }
}

#endif


void show_view(int view, BOOL become_first_responder) {

#ifdef DEBUG_UI
  NSLog(@"show_view view=%d become_first_responder=%d", view, become_first_responder);
#endif

  ViewController *vc = theViewController;

  if (vc != nil)
    {
      int i;

      vc.inShowView = YES;

      vc.currentView = view;

      [vc->inputTextView endEditing:YES];

      for (int i=0; i<NB_WEBVIEWS; i++)
        {
          [vc->webViews[i] endEditing:YES];
          if (i != view)
            {
              vc->webViews[i].hidden = YES;
            }
        }

      for (int i=0; i<NB_TEXTVIEWS; i++)
        {
          [vc->textViews[i] endEditing:YES];
          if (i+NB_WEBVIEWS != view)
            {
              vc->textViews[i].hidden = YES;
            }
        }

      for (int i=0; i<NB_IMAGEVIEWS; i++)
        {
          [vc->imageViews[i] endEditing:YES];
          if (i+(NB_WEBVIEWS+NB_TEXTVIEWS) != view)
            {
              vc->imageViews[i].hidden = YES;
            }
        }

      if (view >= 0) {
        if (view < NB_WEBVIEWS) {

          WView *wv = vc->webViews[view];

          [vc resetInputTextView];

          if (wv->kbdEnabled) {
            checkExtKeyboard(vc->inputTextView, become_first_responder);
          }

          wv.hidden = NO;

        } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {

          TView *tv = vc->textViews[view-NB_WEBVIEWS];

          if (tv->kbdEnabled) {
            checkExtKeyboard(tv, become_first_responder);
          }

          tv.hidden = NO;

        } else {

          IView *iv = vc->imageViews[view-(NB_WEBVIEWS+NB_TEXTVIEWS)];

          if (iv->kbdEnabled)
            {
              if (become_first_responder)
                [iv becomeFirstResponder];
            }

          iv.hidden = NO;
        }
      }

      vc.inShowView = NO;
    }

#if 0
  preload_kbd();
#endif
}


void show_webView(int view, BOOL kbdEnabled, BOOL kbdShouldShrinkView) {
  WView *wv = theViewController->webViews[view];
  wv.kbdEnabled = kbdEnabled;
  wv.kbdShouldShrinkView = kbdShouldShrinkView;
  show_view(view, YES);
}

void show_textView(int view, BOOL kbdEnabled, BOOL kbdShouldShrinkView) {
  TView *tv = theViewController->textViews[view];
  tv.kbdEnabled = kbdEnabled;
  tv.kbdShouldShrinkView = kbdShouldShrinkView;
  show_view(view+NB_WEBVIEWS, YES);
}

void show_imageView(int view, BOOL kbdEnabled, BOOL kbdShouldShrinkView) {
  IView *iv = theViewController->imageViews[view];
  iv.kbdEnabled = kbdEnabled;
  iv.kbdShouldShrinkView = kbdShouldShrinkView;
  show_view(view+NB_WEBVIEWS+NB_IMAGEVIEWS, YES);
}


void show_currentView() {
  show_view(theViewController->currentView, YES);
}


void set_textView_font(int view, NSString *name, int size) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->textViews[view].font = [UIFont fontWithName:name size:size];
    }
}


void set_textView_content(int view, NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->textViews[view].text = str;
    }
}


NSString *get_textView_content(int view) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      return vc->textViews[view].text;
    }

  return @"";
}


void ensure_visible_cursor(UITextView *textView) {
  [textView scrollRangeToVisible:textView.selectedRange];
}


void add_to_textView(int view, NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      TView *textView = vc->textViews[view];
      textView.selectedRange = NSMakeRange([textView.text length], 0);
      [textView insertText:str];
      ensure_visible_cursor(textView);
    }
}


void add_output_to_textView(int view, NSString *str) {

#ifdef USE_NON_BREAKING_SPACE

   add_to_textView(view, [str stringByReplacingOccurrencesOfString:@" " withString:@"\u2007"]);

#else

  add_to_textView(view, str);

#endif
}


void add_text_input_to_textView(int view, NSString *input) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      TView *textView = vc->textViews[view];

      if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        NSRange selectedRange = textView.selectedRange;
        BOOL shouldInsert = [textView.delegate
                                textView:textView
                                shouldChangeTextInRange:selectedRange
                                replacementText:input];

        if (shouldInsert) {

          [textView insertText:input];

          [[NSNotificationCenter defaultCenter]
            postNotificationName:UITextViewTextDidChangeNotification
                          object:textView];
        }
      } else {
        [textView insertText:input];
      }
    }
}


void add_key_input_to_textView(int view, NSString *input) {
  if ([input length] == 1) {
    unichar c = [input characterAtIndex:0];
    if (c >= 32 || c == 10)  {
      add_text_input_to_textView(view, input);
    }
  }
}


void set_webView_content(int view, NSString *str, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->webViews[view]
          loadData:[str dataUsingEncoding:NSUnicodeStringEncoding]
          MIMEType:mime_type
          textEncodingName:@"UTF-8"
          baseURL:[NSURL fileURLWithPath:(base_url_path != nil) ? base_url_path : [[NSBundle mainBundle] bundlePath]]
      ];
      vc->webViews[view].scalesPageToFit = enable_scaling;
    }
}


void set_webView_content_from_file(int view, NSString *path, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSData *data = [NSData dataWithContentsOfFile:path];
      if (data != nil)
        {
          [vc->webViews[view]
              loadData:data
              MIMEType:mime_type
              textEncodingName:@"UTF-8"
              baseURL:[NSURL fileURLWithPath:(base_url_path != nil) ? base_url_path : [[NSBundle mainBundle] bundlePath]]
           ];
          vc->webViews[view].scalesPageToFit = enable_scaling;
        }
    }
}


NSMutableString *escape_js_string(NSString *str) {

  NSMutableString *s = [NSMutableString string];

  for (int i=0; i<[str length]; i++)
    {
      unichar c = [str characterAtIndex:i];
      if (c == '\\')
        [s appendString:@"\\\\"];
      //else if (c == '"')
      //  [s appendString:@"\\\""];
      else if (c == '\'')
        [s appendString:@"\\'"];
      else if (c < 32 || c >= 127)
        [s appendFormat:@"\\u%04X", c];
      else
        [s appendFormat:@"%c", c];
    }

  return s;
}


void add_text_input_to_webView(int view, NSString *input) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSString *script = [NSString stringWithFormat:@"add_text_input('%@');", escape_js_string(input)];
      eval_js_in_webView(view, script);
    }
}


void add_key_input_to_webView(int view, NSString *input) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSString *script = [NSString stringWithFormat:@"add_key_input('%@');", escape_js_string(input)];
      eval_js_in_webView(view, script);
    }
}


void add_text_input_to_currentView(NSString *input) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int view = vc.currentView;
      if (view >= 0) {
        if (view < NB_WEBVIEWS) {
          add_text_input_to_webView(view, input);
        } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
          add_text_input_to_textView(view-NB_WEBVIEWS, input);
        }
      }
    }
}


void add_key_input_to_currentView(NSString *input) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int view = vc.currentView;
      if (view >= 0) {
        if (view < NB_WEBVIEWS) {
          add_key_input_to_webView(view, input);
        } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
          add_key_input_to_textView(view-NB_WEBVIEWS, input);
        }
      }
    }
}


NSString *eval_js_in_webView(int view, NSString *script) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      return [vc->webViews[view] stringByEvaluatingJavaScriptFromString:script];
    }

  return nil;
}


void open_URL(NSString *url) {

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


BOOL send_SMS(NSString *recipient, NSString *message) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      if ([MFMessageComposeViewController canSendText])
        {
          MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];

#if !__has_feature(objc_arc)
          [controller autorelease];
#endif

          controller.body = message;
          controller.recipients = [NSArray arrayWithObjects:recipient,nil];
          controller.messageComposeDelegate = vc;
          [vc presentViewController:controller animated:YES completion:nil];

          return YES;
        }
    }

  return NO;
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
  NSString *event;

  [self dismissViewControllerAnimated:YES completion:nil];

  switch (result) {

  default:
  case MessageComposeResultFailed:
    event = @"SMS-failed";
    break;

  case MessageComposeResultCancelled:
    event = @"SMS-cancelled";
    break;

  case MessageComposeResultSent:
    event = @"SMS-sent";
    break;
  }

  [self send_event:event];
}


BOOL pick_image() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      if ([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear] ||
          [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront])
        {
          UIImagePickerController *controller = [[UIImagePickerController alloc] init];

#if !__has_feature(objc_arc)
          [controller autorelease];
#endif

          controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];

          controller.sourceType = UIImagePickerControllerSourceTypeCamera;

          controller.delegate = vc;

          [vc presentViewController:controller animated:YES completion:nil];

          return YES;
        }
    }

  return NO;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:nil];

  [self send_event:@"pick-image:"];
}


void set_idle_timer(BOOL enable) {

  [UIApplication sharedApplication].idleTimerDisabled = !enable;
}


void set_toolbar_alpha(double alpha) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->navToolbar setAlpha: alpha];
    }
}


void show_toolbar() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->navToolbar.hidden = NO;
    }
}


void hide_toolbar() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->navToolbar.hidden = YES;
    }
}


void toggle_toolbar() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc->navToolbar.hidden = !vc->navToolbar.hidden;
    }
}


void segm_ctrl_set_title(int segment, NSString *title) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->segmCtrl setTitle:title forSegmentAtIndex:segment];
    }
}


void segm_ctrl_insert(int segment, NSString *title) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->segmCtrl insertSegmentWithTitle:title atIndex:segment animated:false];
    }
}


void segm_ctrl_remove(int segment) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->segmCtrl removeSegmentAtIndex:segment animated:false];
    }
}


void segm_ctrl_remove_all() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->segmCtrl removeAllSegments];
    }
}


void set_pref(NSString *key, NSString *value) {

  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setObject:value forKey:key];
  [prefs synchronize];
}


NSString *get_pref(NSString *key) {

  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  return [prefs stringForKey:key];
}


void set_pasteboard(NSString *value) {

  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  pb.string = value;
}


NSString *get_pasteboard() {

  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  return pb.string;
}


NSString *get_documents_dir() {

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return [paths objectAtIndex:0];
}


#ifdef USE_ICLOUD

void setup_icloud_query() {

  ViewController *vc = theViewController;

  if (vc.metadataQuery == nil) {

    vc.metadataQuery = [[NSMetadataQuery alloc] init];

    [vc.metadataQuery
        setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like '*'", NSMetadataItemFSNameKey]; 
    [vc.metadataQuery setPredicate:predicate]; 
          
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
    [nc addObserver:vc selector:@selector(queryFileList:) name:NSMetadataQueryDidFinishGatheringNotification object:vc.metadataQuery]; 
    [nc addObserver:vc selector:@selector(queryFileList:) name:NSMetadataQueryDidUpdateNotification object:vc.metadataQuery]; 

    [vc.metadataQuery startQuery]; 
  } 
}

- (void)iCloudAccountAvailabilityChanged:(NSNotification*)notification {
  [self send_event:@"iCloudAccountAvailabilityChanged"];
}

void downloadFileIfNotDownloaded(NSURL *url) {

  NSNumber *is_in_iCloud = nil;
 
  if ([url getResourceValue:&is_in_iCloud forKey:NSURLIsUbiquitousItemKey error:nil]) {
    if ([is_in_iCloud boolValue]) {
      NSNumber *isDownloaded = nil;
      if ([url getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemIsDownloadedKey error:nil]) {
        if (![isDownloaded boolValue]) {
          NSFileManager *fm = [NSFileManager defaultManager];
          [fm startDownloadingUbiquitousItemAtURL:url error:nil];
        }
      }
    }
  }
}

- (void)queryFileList:(NSNotification *)notification {
  NSArray *queryResults = [self.metadataQuery results];
  for (NSMetadataItem* result in queryResults) {
    NSURL *url = [result valueForAttribute:NSMetadataItemURLKey];
    downloadFileIfNotDownloaded(url);
  }
}

#endif


void request_icloud_container_dir() {

#ifdef USE_ICLOUD

  dispatch_async(dispatch_get_main_queue(), ^{

    static NSString *prefix = @"file://";
    NSString *icloud_container_dir = @"";
    NSURL *ubiq_url = [[NSFileManager defaultManager]
                        URLForUbiquityContainerIdentifier:nil];

    if (ubiq_url != nil) {
      NSString *relurl = [ubiq_url relativeString];
      icloud_container_dir = [relurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      if ([icloud_container_dir hasPrefix:prefix]) {
        icloud_container_dir = [icloud_container_dir substringFromIndex:[prefix length]];
      }
      setup_icloud_query();
    }

    [theViewController send_event:[@"iCloudContainerDirChanged:"
                                      stringByAppendingString:icloud_container_dir]];
  });

#endif
}


void popup_alert(NSString *title, NSString *msg, NSString *cancel_button, NSString *accept_button) {

  UIAlertView *alert = [[UIAlertView alloc]
                        initWithTitle: title
                        message: msg
                        delegate: theViewController
                        cancelButtonTitle: cancel_button
                        otherButtonTitles: accept_button, nil];
  [alert show];
#if !__has_feature(objc_arc)
  [alert release];
#endif
}


// Called when an alertview button is touched
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  NSString *event;

  switch (buttonIndex) {

  case 1:
    event = @"popup-alert-accept";
    break;

  default:
  case 0:
    event = @"popup-alert-cancel";
    break;
  }

  [self send_event:event];
}


#pragma mark -
#pragma mark Toolbar action

- (IBAction)navigation_changed:(id)sender {
  int n = segmCtrl.selectedSegmentIndex;
  if (n >= 0)
    [self send_event:[NSString stringWithFormat:@"NAV%d", n]];
}


#pragma mark -
#pragma mark Cancel button action

- (IBAction)touch_up_cancel:(id)sender {
  [self send_event:@"cancel"];
}


- (void)show_alert:(NSString*)str num:(int)num {
  UIAlertView *alert = [[UIAlertView alloc] 
          initWithTitle:@"ALERT"
          message:[NSString stringWithFormat:str, num]
          delegate:self  // set nil if you don't want the yes button callback
          cancelButtonTitle:@"Yes"
          otherButtonTitles:@"No", nil];
  [alert show];
}


- (void)show_alert:(NSString*)str {
  UIAlertView *alert = [[UIAlertView alloc] 
          initWithTitle:@"ALERT"
          message:str
          delegate:self  // set nil if you don't want the yes button callback
          cancelButtonTitle:@"Yes"
          otherButtonTitles:@"No", nil];
  [alert show];
}


#define inputTextViewCursor 8
#define inputTextViewLength 14
#define inputTextViewContent @"\n\n1 2 ABCD 3\n\n"

- (void)resetInputTextViewCursor {

#ifdef SANE_TEXTVIEW_SELECTEDRANGE_BEHAVIOR

  inputTextViewEnable = NO;
  inputTextView.selectedRange = NSMakeRange(inputTextViewCursor, 0);
  inputTextViewEnable = YES;

#else

  // Hack to work around an iOS bug found here:
  // http://stackoverflow.com/questions/18340360/strange-uitextview-behavior-setting-range-within-textviewdidchangeselection

  dispatch_async(dispatch_get_main_queue(), ^{
      inputTextViewEnable = NO;
      inputTextView.selectedRange = NSMakeRange(inputTextViewCursor, 0);
      inputTextViewEnable = YES;
    });

#endif
}


- (void)resetInputTextView {

  inputTextViewEnable = NO;
  inputTextView.text = inputTextViewContent;
  inputTextViewEnable = YES;

  [self resetInputTextViewCursor];
}


- (void)textViewDidChangeSelection:(UITextView *)textView {

  if (textView == inputTextView)
    {
      if (inputTextViewEnable)
        {
          if ([inputTextView.text isEqualToString:inputTextViewContent])
            {
              NSRange r = textView.selectedRange;
              BOOL handled = YES;

              [self resetInputTextViewCursor];

              if (r.location == 0)
                {
                  if (r.length == 0)
                    {
                      [self keyCmdUpArrow];
                    }
                  else if (r.length == inputTextViewCursor-0)
                    {
                      [self keyShiftCmdUpArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == 1)
                {
                  if (r.length == 0)
                    {
                      [self keyUpArrow];
                    }
                  else if (r.length == inputTextViewCursor-1)
                    {
                      [self keyShiftUpArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == 2)
                {
                  if (r.length == 0)
                    {
                      [self keyCmdLeftArrow];
                    }
                  else if (r.length == inputTextViewCursor-2)
                    {
                      [self keyShiftCmdLeftArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewCursor-4)
                {
                  if (r.length == 4)
                    {
                      [self keyDeleteLong];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewCursor-2)
                {
                  if (r.length == 0)
                    {
                      [self keyOptLeftArrow];
                    }
                  else if (r.length == 2)
                    {
                      [self keyShiftOptLeftArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewCursor-1)
                {
                  if (r.length == 0)
                    {
                      [self keyLeftArrow];
                    }
                  else if (r.length == 1)
                    {
                      [self keyShiftLeftArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewCursor+0)
                {
                  if (r.length == 0)
                    {
                      // cursor at home position and length, so just ignore
                    }
                  else if (r.length == 1)
                    {
                      [self keyShiftRightArrow];
                    }
                  else if (r.length == 2)
                    {
                      [self keyShiftOptRightArrow];
                    }
                  else if (r.length == inputTextViewLength-inputTextViewCursor-2)
                    {
                      [self keyShiftCmdRightArrow];
                    }
                  else if (r.length == inputTextViewLength-inputTextViewCursor-1)
                    {
                      [self keyShiftDownArrow];
                    }
                  else if (r.length == inputTextViewLength-inputTextViewCursor-0)
                    {
                      [self keyShiftCmdDownArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewCursor+1)
                {
                  if (r.length == 0)
                    {
                      [self keyRightArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewCursor+2)
                {
                  if (r.length == 0)
                    {
                      [self keyOptRightArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewLength-2)
                {
                  if (r.length == 0)
                    {
                      [self keyCmdRightArrow];
                    }
                }
              else if (r.location == inputTextViewLength-1)
                {
                  if (r.length == 0)
                    {
                      [self keyDownArrow];
                    }
                  else
                    handled = NO;
                }
              else if (r.location == inputTextViewLength-0)
                {
                  if (r.length == 0)
                    {
                      [self keyCmdDownArrow];
                    }
                  else
                    handled = NO;
                }

              if (!handled) {
                //[self show_alert:@"textViewDidChangeSelection: did not handle location/length=%d" num:r.location*100+r.length];
              }
            }
          else
            {
              //[self show_alert:inputTextView.text];
              [self resetInputTextView];
            }
        }
    }
}


- (BOOL)textView:(UITextView *)textView2 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

  ViewController *vc = theViewController;

  if (textView2 == inputTextView)
    {
      BOOL handled = YES;

      if (inputTextViewEnable)
        {
          if (range.length == 0)
            {
              if (range.location == inputTextViewCursor+0)
                {
                  if (text.length == 1)
                    send_key_input(text);
                  else
                    send_text_input(text);
                }
              else
                handled = NO;
            }
          else if (range.length == 1)
            {
              if (range.location == inputTextViewCursor-1 && text.length == 0)
                [self keyDelete];
              else
                handled = NO;
            }
          else if (range.length == 4)
            {
              if (range.location == inputTextViewCursor-4 && text.length == 0)
                [self keyDeleteLong];
              else
                handled = NO;
            }
          else
            handled = NO;

          if (!handled) {
            //[self show_alert:@"textView:shouldChangeTextInRange:replacementText: did not handle location/length=%d" num:range.location*100+range.length];
          }
        }

      return NO;
    }

  if ([text hasSuffix:@"\n"])
    {
      unichar c;
      TView *textView = textViews[0];
      int end = [textView.text length];

      int line_start = range.location+range.length;

      while (line_start > 0 &&
             (c = [textView.text characterAtIndex:line_start-1]) != '\n'
#ifdef USE_NON_BREAKING_SPACE
             && c != 0x2007 // non breaking space
#endif
             )
        line_start--;

      int line_end = range.location+range.length;

      while (line_end < end &&
             [textView.text characterAtIndex:line_end] != '\n')
        line_end++;

#ifndef USE_NON_BREAKING_SPACE

      // discard prompt at start of line

      int start = line_start;
      while (line_end-start >= 2) {
        int c = [textView.text characterAtIndex:start];
        if (c == '>' &&
            [textView.text characterAtIndex:start+1] == ' ') {
          line_start = start+2;
          break;
        } else if (!(c == '\\' || (c >= '0' && c <= '9')))
          break;
        start++;
      }

#endif

      if (line_start == line_end)
        {
          if (!vc.haveExtKeyboard)
            {
              // Hide the soft keyboard after "return" key is pressed on empty line
#ifdef DEBUG_UI
              NSLog(@"[textView resignFirstResponder];");
#endif
              [textView resignFirstResponder];
            }
          ensure_visible_cursor(textView);
        }
      else
        {
          NSString *line = [textView.text substringWithRange:NSMakeRange(line_start, line_end-line_start)];

          if (line_end == end)
            {
              add_to_textView(0, text);

              [self queue_action_asap:^{
                  send_input([line stringByAppendingString:text]);
              }];
            }
          else
            add_to_textView(0, line);
        }

      return NO;
    }

  return YES;
}


#ifndef __IPHONE_7_0

typedef enum {
    UIKeyModifierAlphaShift     = 1 << 16,  // This bit indicates CapsLock
    UIKeyModifierShift          = 1 << 17,
    UIKeyModifierControl        = 1 << 18,
    UIKeyModifierAlternate      = 1 << 19,
    UIKeyModifierCommand        = 1 << 20,
    UIKeyModifierNumericPad     = 1 << 21,
} UIKeyModifierFlags;

#endif


NSMutableArray *keyCommandsArray = nil;


- (void)addKey:(NSString*)input modifierFlags:(UIKeyModifierFlags)modifierFlags action:(SEL)action {

  Class uikeycommand = NSClassFromString(@"UIKeyCommand");

  if (uikeycommand != nil) {
    [keyCommandsArray
      addObject:[uikeycommand keyCommandWithInput:input
                                    modifierFlags:modifierFlags
                                           action:action]];
  }
}


- (void)addKeyUnicode:(unichar)unicode modifierFlags:(UIKeyModifierFlags)modifierFlags action:(SEL)action {

  [self addKey:[NSString stringWithCharacters:&unicode length:1]
        modifierFlags:modifierFlags
        action:action];
 }


- (void)initKeyCommandsArray {

  // local definitions to allow compatibility with iOS < 7
  static NSString *const UIKeyInputUpArrow    = @"UIKeyInputUpArrow";
  static NSString *const UIKeyInputDownArrow  = @"UIKeyInputDownArrow";
  static NSString *const UIKeyInputLeftArrow  = @"UIKeyInputLeftArrow";
  static NSString *const UIKeyInputRightArrow = @"UIKeyInputRightArrow";
  static NSString *const UIKeyInputEscape     = @"UIKeyInputEscape";

  keyCommandsArray = [NSMutableArray new];

  UIKeyModifierFlags cmd       = UIKeyModifierCommand;
  UIKeyModifierFlags ctrl      = UIKeyModifierControl;
  UIKeyModifierFlags shift     = UIKeyModifierShift;
  UIKeyModifierFlags cmdctrl   = cmd|ctrl;
  UIKeyModifierFlags cmdshift  = cmd|shift;
  UIKeyModifierFlags ctrlshift = ctrl|shift;

#define USE_INPUTTEXTAREA

  [self addKey:@"\r"
        modifierFlags:cmd
        action:@selector(keyCmdReturn)];

  [self addKey:UIKeyInputEscape
        modifierFlags:0
        action:@selector(keyESC)];

  [self addKey:@"\t"
        modifierFlags:ctrl
        action:@selector(keyCtrlTAB)];

  [self addKey:@"\t"
        modifierFlags:ctrlshift
        action:@selector(keyShiftCtrlTAB)];

#ifndef USE_INPUTTEXTAREA

  [self addKey:UIKeyInputUpArrow
        modifierFlags:0
        action:@selector(keyUpArrow)];

  [self addKey:UIKeyInputDownArrow
        modifierFlags:0
        action:@selector(keyDownArrow)];

  [self addKey:UIKeyInputLeftArrow
        modifierFlags:0
        action:@selector(keyLeftArrow)];

  [self addKey:UIKeyInputRightArrow
        modifierFlags:0
        action:@selector(keyRightArrow)];

  [self addKey:UIKeyInputUpArrow
        modifierFlags:cmd
        action:@selector(keyCmdUpArrow)];

  [self addKey:UIKeyInputDownArrow
        modifierFlags:cmd
        action:@selector(keyCmdDownArrow)];

  [self addKey:UIKeyInputLeftArrow
        modifierFlags:cmd
        action:@selector(keyCmdLeftArrow)];

  [self addKey:UIKeyInputRightArrow
        modifierFlags:cmd
        action:@selector(keyCmdRightArrow)];

  [self addKey:UIKeyInputUpArrow
        modifierFlags:shift
        action:@selector(keyShiftUpArrow)];

  [self addKey:UIKeyInputDownArrow
        modifierFlags:shift
        action:@selector(keyShiftDownArrow)];

  [self addKey:UIKeyInputLeftArrow
        modifierFlags:shift
        action:@selector(keyShiftLeftArrow)];

  [self addKey:UIKeyInputRightArrow
        modifierFlags:shift
        action:@selector(keyShiftRightArrow)];

  [self addKey:UIKeyInputUpArrow
        modifierFlags:cmdshift
        action:@selector(keyShiftCmdUpArrow)];

  [self addKey:UIKeyInputDownArrow
        modifierFlags:cmdshift
        action:@selector(keyShiftCmdDownArrow)];

  [self addKey:UIKeyInputLeftArrow
        modifierFlags:cmdshift
        action:@selector(keyShiftCmdLeftArrow)];

  [self addKey:UIKeyInputRightArrow
        modifierFlags:cmdshift
        action:@selector(keyShiftCmdRightArrow)];

#endif

  [self addKey:@"0" modifierFlags:cmd     action:@selector(keyCmd0)];
  [self addKey:@"1" modifierFlags:cmd     action:@selector(keyCmd1)];
  [self addKey:@"2" modifierFlags:cmd     action:@selector(keyCmd2)];
  [self addKey:@"3" modifierFlags:cmd     action:@selector(keyCmd3)];
  [self addKey:@"4" modifierFlags:cmd     action:@selector(keyCmd4)];
  [self addKey:@"5" modifierFlags:cmd     action:@selector(keyCmd5)];
  [self addKey:@"6" modifierFlags:cmd     action:@selector(keyCmd6)];
  [self addKey:@"7" modifierFlags:cmd     action:@selector(keyCmd7)];
  [self addKey:@"8" modifierFlags:cmd     action:@selector(keyCmd8)];
  [self addKey:@"9" modifierFlags:cmd     action:@selector(keyCmd9)];

  [self addKey:@"A" modifierFlags:cmd     action:@selector(keyCmdA)];
  [self addKey:@"B" modifierFlags:cmd     action:@selector(keyCmdB)];
  [self addKey:@"C" modifierFlags:cmd     action:@selector(keyCmdC)];
  [self addKey:@"D" modifierFlags:cmd     action:@selector(keyCmdD)];
  [self addKey:@"E" modifierFlags:cmd     action:@selector(keyCmdE)];
  [self addKey:@"F" modifierFlags:cmd     action:@selector(keyCmdF)];
  [self addKey:@"G" modifierFlags:cmd     action:@selector(keyCmdG)];
  [self addKey:@"H" modifierFlags:cmd     action:@selector(keyCmdH)];
  [self addKey:@"I" modifierFlags:cmd     action:@selector(keyCmdI)];
  [self addKey:@"J" modifierFlags:cmd     action:@selector(keyCmdJ)];
  [self addKey:@"K" modifierFlags:cmd     action:@selector(keyCmdK)];
  [self addKey:@"L" modifierFlags:cmd     action:@selector(keyCmdL)];
  [self addKey:@"M" modifierFlags:cmd     action:@selector(keyCmdM)];
  [self addKey:@"N" modifierFlags:cmd     action:@selector(keyCmdN)];
  [self addKey:@"O" modifierFlags:cmd     action:@selector(keyCmdO)];
  [self addKey:@"P" modifierFlags:cmd     action:@selector(keyCmdP)];
  [self addKey:@"Q" modifierFlags:cmd     action:@selector(keyCmdQ)];
  [self addKey:@"R" modifierFlags:cmd     action:@selector(keyCmdR)];
  [self addKey:@"S" modifierFlags:cmd     action:@selector(keyCmdS)];
  [self addKey:@"T" modifierFlags:cmd     action:@selector(keyCmdT)];
  [self addKey:@"U" modifierFlags:cmd     action:@selector(keyCmdU)];
  [self addKey:@"V" modifierFlags:cmd     action:@selector(keyCmdV)];
  [self addKey:@"W" modifierFlags:cmd     action:@selector(keyCmdW)];
  [self addKey:@"X" modifierFlags:cmd     action:@selector(keyCmdX)];
  [self addKey:@"Y" modifierFlags:cmd     action:@selector(keyCmdY)];
  [self addKey:@"Z" modifierFlags:cmd     action:@selector(keyCmdZ)];

  [self addKey:@"A" modifierFlags:cmdshift action:@selector(keyShiftCmdA)];
  [self addKey:@"B" modifierFlags:cmdshift action:@selector(keyShiftCmdB)];
  [self addKey:@"C" modifierFlags:cmdshift action:@selector(keyShiftCmdC)];
  [self addKey:@"D" modifierFlags:cmdshift action:@selector(keyShiftCmdD)];
  [self addKey:@"E" modifierFlags:cmdshift action:@selector(keyShiftCmdE)];
  [self addKey:@"F" modifierFlags:cmdshift action:@selector(keyShiftCmdF)];
  [self addKey:@"G" modifierFlags:cmdshift action:@selector(keyShiftCmdG)];
  [self addKey:@"H" modifierFlags:cmdshift action:@selector(keyShiftCmdH)];
  [self addKey:@"I" modifierFlags:cmdshift action:@selector(keyShiftCmdI)];
  [self addKey:@"J" modifierFlags:cmdshift action:@selector(keyShiftCmdJ)];
  [self addKey:@"K" modifierFlags:cmdshift action:@selector(keyShiftCmdK)];
  [self addKey:@"L" modifierFlags:cmdshift action:@selector(keyShiftCmdL)];
  [self addKey:@"M" modifierFlags:cmdshift action:@selector(keyShiftCmdM)];
  [self addKey:@"N" modifierFlags:cmdshift action:@selector(keyShiftCmdN)];
  [self addKey:@"O" modifierFlags:cmdshift action:@selector(keyShiftCmdO)];
  [self addKey:@"P" modifierFlags:cmdshift action:@selector(keyShiftCmdP)];
  [self addKey:@"Q" modifierFlags:cmdshift action:@selector(keyShiftCmdQ)];
  [self addKey:@"R" modifierFlags:cmdshift action:@selector(keyShiftCmdR)];
  [self addKey:@"S" modifierFlags:cmdshift action:@selector(keyShiftCmdS)];
  [self addKey:@"T" modifierFlags:cmdshift action:@selector(keyShiftCmdT)];
  [self addKey:@"U" modifierFlags:cmdshift action:@selector(keyShiftCmdU)];
  [self addKey:@"V" modifierFlags:cmdshift action:@selector(keyShiftCmdV)];
  [self addKey:@"W" modifierFlags:cmdshift action:@selector(keyShiftCmdW)];
  [self addKey:@"X" modifierFlags:cmdshift action:@selector(keyShiftCmdX)];
  [self addKey:@"Y" modifierFlags:cmdshift action:@selector(keyShiftCmdY)];
  [self addKey:@"Z" modifierFlags:cmdshift action:@selector(keyShiftCmdZ)];

  [self addKey:@" " modifierFlags:ctrl    action:@selector(keyCtrlSpace)];
#ifndef USE_INPUTTEXTAREA
  [self addKey:@"A" modifierFlags:ctrl    action:@selector(keyCtrlA)];
  [self addKey:@"B" modifierFlags:ctrl    action:@selector(keyCtrlB)];
#endif
  [self addKey:@"C" modifierFlags:ctrl    action:@selector(keyCtrlC)];
  [self addKey:@"D" modifierFlags:ctrl    action:@selector(keyCtrlD)];
#ifndef USE_INPUTTEXTAREA
  [self addKey:@"E" modifierFlags:ctrl    action:@selector(keyCtrlE)];
  [self addKey:@"F" modifierFlags:ctrl    action:@selector(keyCtrlF)];
#endif
  [self addKey:@"G" modifierFlags:ctrl    action:@selector(keyCtrlG)];
  [self addKey:@"H" modifierFlags:ctrl    action:@selector(keyCtrlH)];
#ifndef USE_INPUTTEXTAREA
  [self addKey:@"I" modifierFlags:ctrl    action:@selector(keyCtrlI)];
#endif
  [self addKey:@"J" modifierFlags:ctrl    action:@selector(keyCtrlJ)];
  [self addKey:@"K" modifierFlags:ctrl    action:@selector(keyCtrlK)];
  [self addKey:@"L" modifierFlags:ctrl    action:@selector(keyCtrlL)];
#ifndef USE_INPUTTEXTAREA
  [self addKey:@"M" modifierFlags:ctrl    action:@selector(keyCtrlM)];
#endif
  [self addKey:@"N" modifierFlags:ctrl    action:@selector(keyCtrlN)];
  [self addKey:@"O" modifierFlags:ctrl    action:@selector(keyCtrlO)];
  [self addKey:@"P" modifierFlags:ctrl    action:@selector(keyCtrlP)];
  [self addKey:@"Q" modifierFlags:ctrl    action:@selector(keyCtrlQ)];
  [self addKey:@"R" modifierFlags:ctrl    action:@selector(keyCtrlR)];
  [self addKey:@"S" modifierFlags:ctrl    action:@selector(keyCtrlS)];
  [self addKey:@"T" modifierFlags:ctrl    action:@selector(keyCtrlT)];
  [self addKey:@"U" modifierFlags:ctrl    action:@selector(keyCtrlU)];
  [self addKey:@"V" modifierFlags:ctrl    action:@selector(keyCtrlV)];
  [self addKey:@"W" modifierFlags:ctrl    action:@selector(keyCtrlW)];
  [self addKey:@"X" modifierFlags:ctrl    action:@selector(keyCtrlX)];
  [self addKey:@"Y" modifierFlags:ctrl    action:@selector(keyCtrlY)];
  [self addKey:@"Z" modifierFlags:ctrl    action:@selector(keyCtrlZ)];
  [self addKey:@"[" modifierFlags:ctrl    action:@selector(keyESC)];
  [self addKey:@"\\"modifierFlags:ctrl    action:@selector(keyFS)];
  [self addKey:@"]" modifierFlags:ctrl    action:@selector(keyGS)];
  [self addKey:@"^" modifierFlags:ctrl    action:@selector(keyRS)];
  [self addKey:@"_" modifierFlags:ctrl    action:@selector(keyUS)];

  [self addKey:@" " modifierFlags:cmdctrl action:@selector(keyCmdCtrlSpace)];
  [self addKey:@"A" modifierFlags:cmdctrl action:@selector(keyCmdCtrlA)];
  [self addKey:@"B" modifierFlags:cmdctrl action:@selector(keyCmdCtrlB)];
  [self addKey:@"C" modifierFlags:cmdctrl action:@selector(keyCmdCtrlC)];
  [self addKey:@"D" modifierFlags:cmdctrl action:@selector(keyCmdCtrlD)];
  [self addKey:@"E" modifierFlags:cmdctrl action:@selector(keyCmdCtrlE)];
  [self addKey:@"F" modifierFlags:cmdctrl action:@selector(keyCmdCtrlF)];
  [self addKey:@"G" modifierFlags:cmdctrl action:@selector(keyCmdCtrlG)];
  [self addKey:@"H" modifierFlags:cmdctrl action:@selector(keyCmdCtrlH)];
  [self addKey:@"I" modifierFlags:cmdctrl action:@selector(keyCmdCtrlI)];
  [self addKey:@"J" modifierFlags:cmdctrl action:@selector(keyCmdCtrlJ)];
  [self addKey:@"K" modifierFlags:cmdctrl action:@selector(keyCmdCtrlK)];
  [self addKey:@"L" modifierFlags:cmdctrl action:@selector(keyCmdCtrlL)];
  [self addKey:@"M" modifierFlags:cmdctrl action:@selector(keyCmdCtrlM)];
  [self addKey:@"N" modifierFlags:cmdctrl action:@selector(keyCmdCtrlN)];
  [self addKey:@"O" modifierFlags:cmdctrl action:@selector(keyCmdCtrlO)];
  [self addKey:@"P" modifierFlags:cmdctrl action:@selector(keyCmdCtrlP)];
  [self addKey:@"Q" modifierFlags:cmdctrl action:@selector(keyCmdCtrlQ)];
  [self addKey:@"R" modifierFlags:cmdctrl action:@selector(keyCmdCtrlR)];
  [self addKey:@"S" modifierFlags:cmdctrl action:@selector(keyCmdCtrlS)];
  [self addKey:@"T" modifierFlags:cmdctrl action:@selector(keyCmdCtrlT)];
  [self addKey:@"U" modifierFlags:cmdctrl action:@selector(keyCmdCtrlU)];
  [self addKey:@"V" modifierFlags:cmdctrl action:@selector(keyCmdCtrlV)];
  [self addKey:@"W" modifierFlags:cmdctrl action:@selector(keyCmdCtrlW)];
  [self addKey:@"X" modifierFlags:cmdctrl action:@selector(keyCmdCtrlX)];
  [self addKey:@"Y" modifierFlags:cmdctrl action:@selector(keyCmdCtrlY)];
  [self addKey:@"Z" modifierFlags:cmdctrl action:@selector(keyCmdCtrlZ)];
  [self addKey:@"[" modifierFlags:cmdctrl action:@selector(keyCmdESC)];
  [self addKey:@"\\"modifierFlags:cmdctrl action:@selector(keyCmdFS)];
  [self addKey:@"]" modifierFlags:cmdctrl action:@selector(keyCmdGS)];
  [self addKey:@"^" modifierFlags:cmdctrl action:@selector(keyCmdRS)];
  [self addKey:@"_" modifierFlags:cmdctrl action:@selector(keyCmdUS)];

  [self addKey:@" " modifierFlags:ctrlshift action:@selector(keyShiftCtrlSpace)];
  [self addKey:@"A" modifierFlags:ctrlshift action:@selector(keyShiftCtrlA)];
  [self addKey:@"B" modifierFlags:ctrlshift action:@selector(keyShiftCtrlB)];
  [self addKey:@"C" modifierFlags:ctrlshift action:@selector(keyShiftCtrlC)];
  [self addKey:@"D" modifierFlags:ctrlshift action:@selector(keyShiftCtrlD)];
  [self addKey:@"E" modifierFlags:ctrlshift action:@selector(keyShiftCtrlE)];
  [self addKey:@"F" modifierFlags:ctrlshift action:@selector(keyShiftCtrlF)];
  [self addKey:@"G" modifierFlags:ctrlshift action:@selector(keyShiftCtrlG)];
  [self addKey:@"H" modifierFlags:ctrlshift action:@selector(keyShiftCtrlH)];
  [self addKey:@"I" modifierFlags:ctrlshift action:@selector(keyShiftCtrlI)];
  [self addKey:@"J" modifierFlags:ctrlshift action:@selector(keyShiftCtrlJ)];
  [self addKey:@"K" modifierFlags:ctrlshift action:@selector(keyShiftCtrlK)];
  [self addKey:@"L" modifierFlags:ctrlshift action:@selector(keyShiftCtrlL)];
  [self addKey:@"M" modifierFlags:ctrlshift action:@selector(keyShiftCtrlM)];
  [self addKey:@"N" modifierFlags:ctrlshift action:@selector(keyShiftCtrlN)];
  [self addKey:@"O" modifierFlags:ctrlshift action:@selector(keyShiftCtrlO)];
  [self addKey:@"P" modifierFlags:ctrlshift action:@selector(keyShiftCtrlP)];
  [self addKey:@"Q" modifierFlags:ctrlshift action:@selector(keyShiftCtrlQ)];
  [self addKey:@"R" modifierFlags:ctrlshift action:@selector(keyShiftCtrlR)];
  [self addKey:@"S" modifierFlags:ctrlshift action:@selector(keyShiftCtrlS)];
  [self addKey:@"T" modifierFlags:ctrlshift action:@selector(keyShiftCtrlT)];
  [self addKey:@"U" modifierFlags:ctrlshift action:@selector(keyShiftCtrlU)];
  [self addKey:@"V" modifierFlags:ctrlshift action:@selector(keyShiftCtrlV)];
  [self addKey:@"W" modifierFlags:ctrlshift action:@selector(keyShiftCtrlW)];
  [self addKey:@"X" modifierFlags:ctrlshift action:@selector(keyShiftCtrlX)];
  [self addKey:@"Y" modifierFlags:ctrlshift action:@selector(keyShiftCtrlY)];
  [self addKey:@"Z" modifierFlags:ctrlshift action:@selector(keyShiftCtrlZ)];
  [self addKey:@"[" modifierFlags:ctrlshift action:@selector(keyShiftESC)];
  [self addKey:@"\\"modifierFlags:ctrlshift action:@selector(keyShiftFS)];
  [self addKey:@"]" modifierFlags:ctrlshift action:@selector(keyShiftGS)];
  [self addKey:@"^" modifierFlags:ctrlshift action:@selector(keyShiftRS)];
  [self addKey:@"_" modifierFlags:ctrlshift action:@selector(keyShiftUS)];

  [self addKey:@" " modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlSpace)];
  [self addKey:@"A" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlA)];
  [self addKey:@"B" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlB)];
  [self addKey:@"C" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlC)];
  [self addKey:@"D" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlD)];
  [self addKey:@"E" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlE)];
  [self addKey:@"F" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlF)];
  [self addKey:@"G" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlG)];
  [self addKey:@"H" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlH)];
  [self addKey:@"I" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlI)];
  [self addKey:@"J" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlJ)];
  [self addKey:@"K" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlK)];
  [self addKey:@"L" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlL)];
  [self addKey:@"M" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlM)];
  [self addKey:@"N" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlN)];
  [self addKey:@"O" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlO)];
  [self addKey:@"P" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlP)];
  [self addKey:@"Q" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlQ)];
  [self addKey:@"R" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlR)];
  [self addKey:@"S" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlS)];
  [self addKey:@"T" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlT)];
  [self addKey:@"U" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlU)];
  [self addKey:@"V" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlV)];
  [self addKey:@"W" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlW)];
  [self addKey:@"X" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlX)];
  [self addKey:@"Y" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlY)];
  [self addKey:@"Z" modifierFlags:ctrlshift action:@selector(keyShiftCmdCtrlZ)];
  [self addKey:@"[" modifierFlags:ctrlshift action:@selector(keyShiftCmdESC)];
  [self addKey:@"\\"modifierFlags:ctrlshift action:@selector(keyShiftCmdFS)];
  [self addKey:@"]" modifierFlags:ctrlshift action:@selector(keyShiftCmdGS)];
  [self addKey:@"^" modifierFlags:ctrlshift action:@selector(keyShiftCmdRS)];
  [self addKey:@"_" modifierFlags:ctrlshift action:@selector(keyShiftCmdUS)];
}

- (NSArray *)keyCommands {

  if (keyCommandsArray == nil) {
    [self initKeyCommandsArray];
  }

  return keyCommandsArray;
}

- (void)keyCmd0 { send_key_input(@"M0"); }
- (void)keyCmd1 { send_key_input(@"M1"); }
- (void)keyCmd2 { send_key_input(@"M2"); }
- (void)keyCmd3 { send_key_input(@"M3"); }
- (void)keyCmd4 { send_key_input(@"M4"); }
- (void)keyCmd5 { send_key_input(@"M5"); }
- (void)keyCmd6 { send_key_input(@"M6"); }
- (void)keyCmd7 { send_key_input(@"M7"); }
- (void)keyCmd8 { send_key_input(@"M8"); }
- (void)keyCmd9 { send_key_input(@"M9"); }

- (void)keyCmdA { send_key_input(@"MA"); }
- (void)keyCmdB { send_key_input(@"MB"); }
- (void)keyCmdC { send_key_input(@"MC"); }
- (void)keyCmdD { send_key_input(@"MD"); }
- (void)keyCmdE { send_key_input(@"ME"); }
- (void)keyCmdF { send_key_input(@"MF"); }
- (void)keyCmdG { send_key_input(@"MG"); }
- (void)keyCmdH { send_key_input(@"MH"); }
- (void)keyCmdI { send_key_input(@"MI"); }
- (void)keyCmdJ { send_key_input(@"MJ"); }
- (void)keyCmdK { send_key_input(@"MK"); }
- (void)keyCmdL { send_key_input(@"ML"); }
- (void)keyCmdM { send_key_input(@"MM"); }
- (void)keyCmdN { send_key_input(@"MN"); }
- (void)keyCmdO { send_key_input(@"MO"); }
- (void)keyCmdP { send_key_input(@"MP"); }
- (void)keyCmdQ { send_key_input(@"MQ"); }
- (void)keyCmdR { send_key_input(@"MR"); }
- (void)keyCmdS { send_key_input(@"MS"); }
- (void)keyCmdT { send_key_input(@"MT"); }
- (void)keyCmdU { send_key_input(@"MU"); }
- (void)keyCmdV { send_key_input(@"MV"); }
- (void)keyCmdW { send_key_input(@"MW"); }
- (void)keyCmdX { send_key_input(@"MX"); }
- (void)keyCmdY { send_key_input(@"MY"); }
- (void)keyCmdZ { send_key_input(@"MZ"); }

- (void)keyShiftCmdA { send_key_input(@"SMA"); }
- (void)keyShiftCmdB { send_key_input(@"SMB"); }
- (void)keyShiftCmdC { send_key_input(@"SMC"); }
- (void)keyShiftCmdD { send_key_input(@"SMD"); }
- (void)keyShiftCmdE { send_key_input(@"SME"); }
- (void)keyShiftCmdF { send_key_input(@"SMF"); }
- (void)keyShiftCmdG { send_key_input(@"SMG"); }
- (void)keyShiftCmdH { send_key_input(@"SMH"); }
- (void)keyShiftCmdI { send_key_input(@"SMI"); }
- (void)keyShiftCmdJ { send_key_input(@"SMJ"); }
- (void)keyShiftCmdK { send_key_input(@"SMK"); }
- (void)keyShiftCmdL { send_key_input(@"SML"); }
- (void)keyShiftCmdM { send_key_input(@"SMM"); }
- (void)keyShiftCmdN { send_key_input(@"SMN"); }
- (void)keyShiftCmdO { send_key_input(@"SMO"); }
- (void)keyShiftCmdP { send_key_input(@"SMP"); }
- (void)keyShiftCmdQ { send_key_input(@"SMQ"); }
- (void)keyShiftCmdR { send_key_input(@"SMR"); }
- (void)keyShiftCmdS { send_key_input(@"SMS"); }
- (void)keyShiftCmdT { send_key_input(@"SMT"); }
- (void)keyShiftCmdU { send_key_input(@"SMU"); }
- (void)keyShiftCmdV { send_key_input(@"SMV"); }
- (void)keyShiftCmdW { send_key_input(@"SMW"); }
- (void)keyShiftCmdX { send_key_input(@"SMX"); }
- (void)keyShiftCmdY { send_key_input(@"SMY"); }
- (void)keyShiftCmdZ { send_key_input(@"SMZ"); }

- (void)keyCtrlSpace { send_key_input(@"^ "); }
- (void)keyCtrlA { send_key_input(@"\001"); }
- (void)keyCtrlB { send_key_input(@"\002"); }
- (void)keyCtrlC { send_key_input(@"\003"); }
- (void)keyCtrlD { send_key_input(@"\004"); }
- (void)keyCtrlE { send_key_input(@"\005"); }
- (void)keyCtrlF { send_key_input(@"\006"); }
- (void)keyCtrlG { send_key_input(@"\007"); }
- (void)keyCtrlH { send_key_input(@"\010"); }
- (void)keyCtrlI { send_key_input(@"\011"); }
- (void)keyCtrlJ { send_key_input(@"\012"); }
- (void)keyCtrlK { send_key_input(@"\013"); }
- (void)keyCtrlL { send_key_input(@"\014"); }
- (void)keyCtrlM { send_key_input(@"\015"); }
- (void)keyCtrlN { send_key_input(@"\016"); }
- (void)keyCtrlO { send_key_input(@"\017"); }
- (void)keyCtrlP { send_key_input(@"\020"); }
- (void)keyCtrlQ { send_key_input(@"\021"); }
- (void)keyCtrlR { send_key_input(@"\022"); }
- (void)keyCtrlS { send_key_input(@"\023"); }
- (void)keyCtrlT { send_key_input(@"\024"); }
- (void)keyCtrlU { send_key_input(@"\025"); }
- (void)keyCtrlV { send_key_input(@"\026"); }
- (void)keyCtrlW { send_key_input(@"\027"); }
- (void)keyCtrlX { send_key_input(@"\030"); }
- (void)keyCtrlY { send_key_input(@"\031"); }
- (void)keyCtrlZ { send_key_input(@"\032"); }
- (void)keyESC   { send_key_input(@"\033"); }
- (void)keyFS    { send_key_input(@"\034"); }
- (void)keyGS    { send_key_input(@"\035"); }
- (void)keyRS    { send_key_input(@"\036"); }
- (void)keyUS    { send_key_input(@"\037"); }

- (void)keyCmdCtrlSpace { send_key_input(@"M^ "); }
- (void)keyCmdCtrlA { send_key_input(@"M\001"); }
- (void)keyCmdCtrlB { send_key_input(@"M\002"); }
- (void)keyCmdCtrlC { send_key_input(@"M\003"); }
- (void)keyCmdCtrlD { send_key_input(@"M\004"); }
- (void)keyCmdCtrlE { send_key_input(@"M\005"); }
- (void)keyCmdCtrlF { send_key_input(@"M\006"); }
- (void)keyCmdCtrlG { send_key_input(@"M\007"); }
- (void)keyCmdCtrlH { send_key_input(@"M\010"); }
- (void)keyCmdCtrlI { send_key_input(@"M\011"); }
- (void)keyCmdCtrlJ { send_key_input(@"M\012"); }
- (void)keyCmdCtrlK { send_key_input(@"M\013"); }
- (void)keyCmdCtrlL { send_key_input(@"M\014"); }
- (void)keyCmdCtrlM { send_key_input(@"M\015"); }
- (void)keyCmdCtrlN { send_key_input(@"M\016"); }
- (void)keyCmdCtrlO { send_key_input(@"M\017"); }
- (void)keyCmdCtrlP { send_key_input(@"M\020"); }
- (void)keyCmdCtrlQ { send_key_input(@"M\021"); }
- (void)keyCmdCtrlR { send_key_input(@"M\022"); }
- (void)keyCmdCtrlS { send_key_input(@"M\023"); }
- (void)keyCmdCtrlT { send_key_input(@"M\024"); }
- (void)keyCmdCtrlU { send_key_input(@"M\025"); }
- (void)keyCmdCtrlV { send_key_input(@"M\026"); }
- (void)keyCmdCtrlW { send_key_input(@"M\027"); }
- (void)keyCmdCtrlX { send_key_input(@"M\030"); }
- (void)keyCmdCtrlY { send_key_input(@"M\031"); }
- (void)keyCmdCtrlZ { send_key_input(@"M\032"); }
- (void)keyCmdESC   { send_key_input(@"M\033"); }
- (void)keyCmdFS    { send_key_input(@"M\034"); }
- (void)keyCmdGS    { send_key_input(@"M\035"); }
- (void)keyCmdRS    { send_key_input(@"M\036"); }
- (void)keyCmdUS    { send_key_input(@"M\037"); }

- (void)keyShiftCtrlSpace { send_key_input(@"S^ "); }
- (void)keyShiftCtrlA { send_key_input(@"S\001"); }
- (void)keyShiftCtrlB { send_key_input(@"S\002"); }
- (void)keyShiftCtrlC { send_key_input(@"S\003"); }
- (void)keyShiftCtrlD { send_key_input(@"S\004"); }
- (void)keyShiftCtrlE { send_key_input(@"S\005"); }
- (void)keyShiftCtrlF { send_key_input(@"S\006"); }
- (void)keyShiftCtrlG { send_key_input(@"S\007"); }
- (void)keyShiftCtrlH { send_key_input(@"S\010"); }
- (void)keyShiftCtrlI { send_key_input(@"S\011"); }
- (void)keyShiftCtrlJ { send_key_input(@"S\012"); }
- (void)keyShiftCtrlK { send_key_input(@"S\013"); }
- (void)keyShiftCtrlL { send_key_input(@"S\014"); }
- (void)keyShiftCtrlM { send_key_input(@"S\015"); }
- (void)keyShiftCtrlN { send_key_input(@"S\016"); }
- (void)keyShiftCtrlO { send_key_input(@"S\017"); }
- (void)keyShiftCtrlP { send_key_input(@"S\020"); }
- (void)keyShiftCtrlQ { send_key_input(@"S\021"); }
- (void)keyShiftCtrlR { send_key_input(@"S\022"); }
- (void)keyShiftCtrlS { send_key_input(@"S\023"); }
- (void)keyShiftCtrlT { send_key_input(@"S\024"); }
- (void)keyShiftCtrlU { send_key_input(@"S\025"); }
- (void)keyShiftCtrlV { send_key_input(@"S\026"); }
- (void)keyShiftCtrlW { send_key_input(@"S\027"); }
- (void)keyShiftCtrlX { send_key_input(@"S\030"); }
- (void)keyShiftCtrlY { send_key_input(@"S\031"); }
- (void)keyShiftCtrlZ { send_key_input(@"S\032"); }
- (void)keyShiftESC   { send_key_input(@"S\033"); }
- (void)keyShiftFS    { send_key_input(@"S\034"); }
- (void)keyShiftGS    { send_key_input(@"S\035"); }
- (void)keyShiftRS    { send_key_input(@"S\036"); }
- (void)keyShiftUS    { send_key_input(@"S\037"); }

- (void)keyShiftCmdCtrlSpace { send_key_input(@"SM^ "); }
- (void)keyShiftCmdCtrlA { send_key_input(@"SM\001"); }
- (void)keyShiftCmdCtrlB { send_key_input(@"SM\002"); }
- (void)keyShiftCmdCtrlC { send_key_input(@"SM\003"); }
- (void)keyShiftCmdCtrlD { send_key_input(@"SM\004"); }
- (void)keyShiftCmdCtrlE { send_key_input(@"SM\005"); }
- (void)keyShiftCmdCtrlF { send_key_input(@"SM\006"); }
- (void)keyShiftCmdCtrlG { send_key_input(@"SM\007"); }
- (void)keyShiftCmdCtrlH { send_key_input(@"SM\010"); }
- (void)keyShiftCmdCtrlI { send_key_input(@"SM\011"); }
- (void)keyShiftCmdCtrlJ { send_key_input(@"SM\012"); }
- (void)keyShiftCmdCtrlK { send_key_input(@"SM\013"); }
- (void)keyShiftCmdCtrlL { send_key_input(@"SM\014"); }
- (void)keyShiftCmdCtrlM { send_key_input(@"SM\015"); }
- (void)keyShiftCmdCtrlN { send_key_input(@"SM\016"); }
- (void)keyShiftCmdCtrlO { send_key_input(@"SM\017"); }
- (void)keyShiftCmdCtrlP { send_key_input(@"SM\020"); }
- (void)keyShiftCmdCtrlQ { send_key_input(@"SM\021"); }
- (void)keyShiftCmdCtrlR { send_key_input(@"SM\022"); }
- (void)keyShiftCmdCtrlS { send_key_input(@"SM\023"); }
- (void)keyShiftCmdCtrlT { send_key_input(@"SM\024"); }
- (void)keyShiftCmdCtrlU { send_key_input(@"SM\025"); }
- (void)keyShiftCmdCtrlV { send_key_input(@"SM\026"); }
- (void)keyShiftCmdCtrlW { send_key_input(@"SM\027"); }
- (void)keyShiftCmdCtrlX { send_key_input(@"SM\030"); }
- (void)keyShiftCmdCtrlY { send_key_input(@"SM\031"); }
- (void)keyShiftCmdCtrlZ { send_key_input(@"SM\032"); }
- (void)keyShiftCmdESC   { send_key_input(@"SM\033"); }
- (void)keyShiftCmdFS    { send_key_input(@"SM\034"); }
- (void)keyShiftCmdGS    { send_key_input(@"SM\035"); }
- (void)keyShiftCmdRS    { send_key_input(@"SM\036"); }
- (void)keyShiftCmdUS    { send_key_input(@"SM\037"); }

- (void)keyDelete { send_key_input(@"\177"); }
- (void)keyDeleteLong { [self keyDelete]; [self keyDelete]; [self keyDelete]; [self keyDelete]; }

- (void)keyCmdReturn { send_key_input(@"M\015"); }

- (void)keyCtrlTAB { send_key_input(@"^\011"); }
- (void)keyShiftCtrlTAB { send_key_input(@"S^\011"); }

- (void)keyUpArrow    { send_key_input(@"AU"); }
- (void)keyDownArrow  { send_key_input(@"AD"); }
- (void)keyLeftArrow  { send_key_input(@"AL"); }
- (void)keyRightArrow { send_key_input(@"AR"); }

- (void)keyCmdUpArrow    { send_key_input(@"MAU"); }
- (void)keyCmdDownArrow  { send_key_input(@"MAD"); }
- (void)keyCmdLeftArrow  { send_key_input(@"MAL"); }
- (void)keyCmdRightArrow { send_key_input(@"MAR"); }

- (void)keyShiftUpArrow    { send_key_input(@"SAU"); }
- (void)keyShiftDownArrow  { send_key_input(@"SAD"); }
- (void)keyShiftLeftArrow  { send_key_input(@"SAL"); }
- (void)keyShiftRightArrow { send_key_input(@"SAR"); }

- (void)keyShiftCmdUpArrow    { send_key_input(@"SMAU"); }
- (void)keyShiftCmdDownArrow  { send_key_input(@"SMAD"); }
- (void)keyShiftCmdLeftArrow  { send_key_input(@"SMAL"); }
- (void)keyShiftCmdRightArrow { send_key_input(@"SMAR"); }

- (void)keyOptLeftArrow  { send_key_input(@"MAL"); }
- (void)keyOptRightArrow { send_key_input(@"MAR"); }
- (void)keyShiftOptLeftArrow  { send_key_input(@"SMAL"); }
- (void)keyShiftOptRightArrow { send_key_input(@"SMAR"); }

- (void)keyCtrl { send_key_input(@"CTRL"); }


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

  NSURL *url = [request URL];
  NSString *relurl = [url relativeString];
  NSString *str = [[relurl stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

  if ([str hasPrefix:@"event:"]) {
    [self send_event:str];
    return NO;
  }

  return YES;
}


void setup_location_updates(double desired_accuracy, double distance_filter)
{
  ViewController *vc = theViewController;
  if (vc != nil)
    {
      if (vc->locationManager == nil)
        {
          vc->locationManager = [[CLLocationManager alloc] init];
          vc->locationManager.delegate = vc;
        }

      if (desired_accuracy < 0.0)
        [vc->locationManager stopUpdatingLocation];
      else
        {
          if (desired_accuracy == 0.0)
            vc->locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
          else
            vc->locationManager.desiredAccuracy = desired_accuracy;

          vc->locationManager.distanceFilter = kCLDistanceFilterNone;

          if (distance_filter < 0.0)
            [vc->locationManager startMonitoringSignificantLocationChanges];
          else
            {
              if (distance_filter > 0.0)
                vc->locationManager.distanceFilter = distance_filter;
              [vc->locationManager startUpdatingLocation];
            }
        }
    }
}


// Delegate method from the CLLocationManagerDelegate protocol.

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
    fromLocation:(CLLocation *)oldLocation
{
    NSString *event = [NSString stringWithFormat:@"location-update:%+.9f %+.9f %+.1f %+.1f %+.1f %+.1f %+.1f %+.6f",
                                newLocation.coordinate.latitude,
                                newLocation.coordinate.longitude,
                                newLocation.horizontalAccuracy,
                                newLocation.altitude,
                                newLocation.verticalAccuracy,
                                newLocation.course,
                                newLocation.speed,
                                [newLocation.timestamp timeIntervalSince1970]];
    [self send_event:event];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {

  int i;

  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:nil
            object:nil];

#if !__has_feature(objc_arc)

  [segmCtrl release];

  for (i=0; i<NB_WEBVIEWS; i++)
    [webViews[i] release];

  for (i=0; i<NB_TEXTVIEWS; i++)
    [textViews[i] release];

  for (i=0; i<NB_IMAGEVIEWS; i++)
    [imageViews[i] release];

  [cancelButton release];

  [super dealloc];

#endif
}


//-----------------------------------------------------------------------------

@end
