//
//  ViewController.m
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011-2012 UniversitÃ© de MontrÃ©al. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "KOKeyboardRow.h"
#import "WView.h"
#import "TView.h"
#import "IView.h"


ViewController *theViewController = nil;

//-----------------------------------------------------------------------------

@implementation ViewController

@synthesize segmCtrl, currentView, keyboardShowingView, cancelButton, navToolbar, timer, queuedActions, locationManager, kov;

//-----------------------------------------------------------------------------

// Gambit setup/cleanup.


/*
 * ___VERSION must match the version number of the Gambit header file.
 */

#define ___VERSION 407003
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
___UCS_2 ucs2_gambcdir[1024];

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

  if (___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST
        (main_argv,
         &ucs2_argv)
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
    ucs2_gambcdir[i] = ucs2_argv[0][i];

  ucs2_gambcdir[i] = '\0';

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
  setup_params.gambcdir       = ucs2_gambcdir;
  setup_params.debug_settings = debug_settings;

  ___setup (&setup_params);

  ___disable_heartbeat_interrupts ();
}


void gambit_cleanup()
{
  ___cleanup ();
}


//-----------------------------------------------------------------------------

- (void)viewDidLoad {

  [super viewDidLoad];

  theViewController = self;

  currentView = -1;
  keyboardShowingView = -1;

  kov = nil;

#if 0

  set_ext_keys(@"=,.<>2406835179/-(\\_*+)?#",
               @"S:;!@`'λ\"~=,.<>2406835179/-(\\_*+)?#",
               @"bcade%^$&|<<<<<[]={}>>>>>S:;!@`'λ\"~2406835179/-(\\_*+)?#",
               @"bcade%^$&|<<<<<[]={}>>>>>S:;!@`'λ\"~2406835179/-(\\_*+)?#");

#else

  set_ext_keys(@"*=+<>/\\-#λ2406835179`'(.\":;)!?",
               @"~@,S_*=+<>/\\-#λ2406835179`'(.\":;)!?",
               @"SSSSSbcade<<<@$[]={}>>>&|*^+%_/\\-#λ2406835179`'(~\":;)!?",
               @"SSSSSbcade<<<@$[]={}>>>&|*^+%_/\\-#λ2406835179`'(~\":;)!?");

#endif

  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screen_w = screenRect.size.width;
  CGFloat screen_h = screenRect.size.height;
  CGFloat bar_y = navToolbar.bounds.origin.y;
  CGFloat bar_h = navToolbar.bounds.size.height;

  //NSLog(@"%f %f %f %f",bar_y, bar_h,view.bounds.size.width, view.bounds.size.height);
  bar_y = 0;
  bar_h = 0;

  CGRect viewRect = CGRectMake(0, bar_y+bar_h, screen_w, screen_h-(bar_y+bar_h));

  for (int i=NB_WEBVIEWS-1; i>=0; i--) {
    UIWebView *webView = [[WView alloc] initWithFrame:viewRect];

    // automatic capitalization et al. are turned off in the HTML code

    webView.backgroundColor = [UIColor clearColor];
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    webView.scalesPageToFit = NO;
    webView.hidden = YES;
    webView.delegate = self;
    [self.view insertSubview:webView atIndex:0];
    webViews[i] = webView;
  }

  for (int i=NB_TEXTVIEWS-1; i>=0; i--) {
    UITextView *textview = [[TView alloc] initWithFrame:viewRect];

    // turn off automatic capitalization, correction and spell checking
    textview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textview.autocorrectionType = UITextAutocorrectionTypeNo;
    textview.spellCheckingType = UITextSpellCheckingTypeNo;

    textview.backgroundColor = [UIColor clearColor];
    textview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    textview.hidden = YES;
    textview.delegate = self;
    [self.view insertSubview:textview atIndex:0];
    textViews[i] = textview;
  }

  for (int i=NB_IMAGEVIEWS-1; i>=0; i--) {
    UIImageView *imageview = [[IView alloc] initWithFrame:viewRect];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    imageview.hidden = YES;
    [self.view insertSubview:imageview atIndex:0];
    imageViews[i] = imageview;
  }

  set_textView_font(0, @"Courier", 16);

  segmCtrl.selectedSegmentIndex = UISegmentedControlNoSegment;
  [segmCtrl sizeToFit];

  // get rid of shadow line at top of toolbar
  navToolbar.backgroundColor = [UIColor clearColor];
  if ([navToolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
    [navToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  }
  if ([navToolbar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)]) {
    [navToolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  timer = nil;

  queuedActions = [[NSMutableArray alloc] init];

  locationManager = nil;

  gambit_setup();

  [self heartbeat_tick];
}


- (void)viewDidUnload {

  [super viewDidUnload];

  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

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

  [kov switchToOrientation:interfaceOrientation];

  //UIView *sv = [kov.subviews lastObject];
  //[sv removeFromSuperview];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

  //NSLog(@"DID: %@", NSStringFromCGRect(kov.frame));
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Text view delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {

  return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {

  [aTextView resignFirstResponder];
  return YES;
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {

  int view = currentView;

  if (view >= 0) {
    if (view < NB_WEBVIEWS) {
      //NSLog(@"ViewController keyboardWillShow WEBVIEW");
    } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {

      //NSLog(@"ViewController keyboardWillShow TEXTVIEW");

      /*
        Reduce the size of the text view so that it's not obscured by
        the keyboard.  Animate the resize so that it's in sync with
        the appearance of the keyboard.
      */

      NSDictionary *userInfo = [notification userInfo];

      // Get the origin of the keyboard when it's displayed.
      NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

      // Get the top of the keyboard as the y coordinate of its origin in
      // self's view's coordinate system. The bottom of the text view's
      // frame should align with the top of the keyboard's final position.
      CGRect keyboardRect = [aValue CGRectValue];
      keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

      CGFloat keyboardTop = keyboardRect.origin.y;
      CGRect newTextViewFrame = self.view.bounds;
      newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;

      // Get the duration of the animation.
      NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
      NSTimeInterval animationDuration;
      [animationDurationValue getValue:&animationDuration];

      // Animate the resize of the text view's frame in sync with the
      // keyboard's appearance.
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:animationDuration];

      textViews[view-NB_WEBVIEWS].frame = newTextViewFrame;

      [UIView commitAnimations];
    }
  }

  keyboardShowingView = view;
}


- (void)keyboardWillHide:(NSNotification *)notification {

  int view = currentView;

  if (view >= 0) {
    if (view < NB_WEBVIEWS) {
      //NSLog(@"ViewController keyboardWillHide WEBVIEW");
    } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {

      //NSLog(@"ViewController keyboardWillHide TEXTVIEW");

      NSDictionary* userInfo = [notification userInfo];

      /*
        Restore the size of the text view (fill self's view).  Animate
        the resize so that it's in sync with the disappearance of the
        keyboard.
      */

      NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
      NSTimeInterval animationDuration;
      [animationDurationValue getValue:&animationDuration];

      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:animationDuration];

      textViews[view-NB_WEBVIEWS].frame = self.view.bounds;

      [UIView commitAnimations];
    }
  }

  keyboardShowingView = -1;
}


#include "intf.h"


void set_ext_keys(NSString *portrait_small, NSString *landscape_small, NSString *portrait_large, NSString *landscape_large) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      KOKeyboardRow *kov = [[KOKeyboardRow alloc] init];

      kov.portraitKeysSmall  = portrait_small;
      kov.landscapeKeysSmall = landscape_small;
      kov.portraitKeysLarge  = portrait_large;
      kov.landscapeKeysLarge = landscape_large;

      kov.animation = koTraditinalAnimation;

      [kov setup];

      vc.kov = kov;
    }
}


void set_navigation(int n) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->segmCtrl removeTarget:vc action:@selector(navigation_changed:) forControlEvents:UIControlEventValueChanged];
      vc->segmCtrl.selectedSegmentIndex = n;
      [vc->segmCtrl addTarget:vc action:@selector(navigation_changed:) forControlEvents:UIControlEventValueChanged];
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


- (void)send_key:(NSString*)name {

  [self queue_action_asap:^{ send_key(name); }];
}


- (void)heartbeat_tick {

  [self queue_action:^{ [self schedule_next_heartbeat_tick:heartbeat()]; }];

  ___enable_heartbeat_interrupts ();

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

  ___disable_heartbeat_interrupts ();
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


void show_view(int view, BOOL become_first_responder) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int i;

      vc.currentView = view;

      //[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

      for (int i=0; i<NB_WEBVIEWS; i++)
        if (i != view)
          {
            [vc->webViews[i] endEditing:YES];
            vc->webViews[i].hidden = YES;
          }

      for (int i=0; i<NB_TEXTVIEWS; i++)
        if (i+NB_WEBVIEWS != view)
          {
            [vc->textViews[i] endEditing:YES];
            vc->textViews[i].hidden = YES;
          }

      for (int i=0; i<NB_IMAGEVIEWS; i++)
        if (i+(NB_WEBVIEWS+NB_TEXTVIEWS) != view)
          {
            [vc->imageViews[i] endEditing:YES];
            vc->imageViews[i].hidden = YES;
          }

      if (view >= 0) {
        if (view < NB_WEBVIEWS) {
          if (become_first_responder)
            [vc->webViews[view] becomeFirstResponder];
          vc->webViews[view].hidden = NO;
        } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
          if (become_first_responder)
            [vc->textViews[view-NB_WEBVIEWS] becomeFirstResponder];
          vc->textViews[view-NB_WEBVIEWS].hidden = NO;
        } else {
          if (become_first_responder)
            [vc->imageViews[view-(NB_WEBVIEWS+NB_TEXTVIEWS)] becomeFirstResponder];
          vc->imageViews[view-(NB_WEBVIEWS+NB_TEXTVIEWS)].hidden = NO;
        }
      }
    }

  preload_kbd();
}


void show_webView(int view, BOOL become_first_responder) {
  show_view(view, become_first_responder);
}


void show_textView(int view, BOOL become_first_responder) {
  show_view(view+NB_WEBVIEWS, become_first_responder);
}


void show_imageView(int view, BOOL become_first_responder) {
  show_view(view+NB_WEBVIEWS+NB_IMAGEVIEWS, become_first_responder);
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
      UITextView *textView = vc->textViews[view];
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


void add_input_to_textView(int view, NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      UITextView *textView = vc->textViews[view];
      //NSLog(@"add_input_to_textView %d %@",view,str);

#if 0

      NSMutableString *new_text = [textView.text mutableCopy];
      NSRange selectedRange = textView.selectedRange;

      [new_text replaceCharactersInRange:selectedRange withString:str];

      textView.text = new_text;
#if !__has_feature(objc_arc)
      [new_text release];
#endif

#else

      if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        NSRange selectedRange = textView.selectedRange;
        BOOL shouldInsert = [textView.delegate textView:textView shouldChangeTextInRange:selectedRange replacementText:str];
        if (shouldInsert) {
          [textView insertText:str];
          [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
        }
      } else {
        [textView insertText:str];
      }

#endif

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


void add_input_to_webView(int view, NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSString *script;
      if ([str isEqualToString:@"'"]) {
        script = [NSString stringWithFormat:@"add_input(\"%@\");", str];
      } else {
        script = [NSString stringWithFormat:@"add_input('%@');", str];
      }
      //NSLog(@"add_input_to_webView %d script=%@",view,script);
      eval_js_in_webView(view, script);
    }
}


void add_input_to_currentView(NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int view = vc.currentView;
      //NSLog(@"add_input_to_currentView %d %@",view,str);
      if (view >= 0) {
        if (view < NB_WEBVIEWS) {
          add_input_to_webView(view, str);
        } else if (view < NB_WEBVIEWS+NB_TEXTVIEWS) {
          add_input_to_textView(view-NB_WEBVIEWS, str);
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


- (BOOL)textView:(UITextView *)textView2 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

  if ([text hasSuffix:@"\n"])
    {
      unichar c;
      UITextView *textView = textViews[0];
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
          [textView resignFirstResponder]; // Hide the keyboard after "return" key is pressed on empty line
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


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

  NSURL *url = [request URL];
  NSString *relurl = [url relativeString];

  if ([relurl hasPrefix:@"event:"]) {
    [self send_event:relurl];
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

  [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];

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

#if 0

// UIKeyInput protocol methods

- (void) insertText:(NSString* )text
{
    NSLog(@"ViewController insertText: %@", text);
}

- (void)deleteBackward {
    NSLog(@"ViewController deleteBackward");
}

- (BOOL) canBecomeFirstResponder
{
    NSLog(@"ViewController canBecomeFirstResponder");
    //return NO;
    return YES;
}

- (BOOL) resignFirstResponder
{
    NSLog(@"ViewController resignFirstResponder");
    //return NO;
    return YES;
}

- (BOOL) hasText
{
    NSLog(@"ViewController hasText");
    return YES;
}

#endif

#if 0

@implementation RAEditorView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (void) setup {
  [self hideKeyboardBar];
}

- (void) hideKeyboardBar {
  static NSString * uniqueSuffix;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      uniqueSuffix = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
    });

  for (UIView *aView in scrollView.subviews) {
    Class ownClass = [aView class];
    NSString *className = NSStringFromClass(ownClass);
    if (![className hasSuffix:uniqueSuffix]) {
      NSString *newClassName = [className stringByAppendingString:uniqueSuffix];
      Class newClass = objc_allocateClassPair(ownClass, [newClassName UTF8String], 0);
      if (newClass) {
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
      }
      object_setClass(aView, (newClass ?: NSClassFromString(newClassName)));
    }
  }
}

- (id) methodReturningNil {
  return nil;
}

@end


#endif


//-----------------------------------------------------------------------------

@end
