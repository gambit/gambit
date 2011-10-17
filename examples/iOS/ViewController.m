//
//  ViewController.m
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011 Université de Montréal. All rights reserved.
//

// Note: some of this code comes from the KeyboardAccessory
// sample application written by Apple.

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"


@implementation ViewController

@synthesize segmCtrl, webView0, webView1, webView2, webView3, textView0, textView1, imageView0, imageView1, cancelButton, accessoryView, keyboardSounds, timer, queuedActions;

//-----------------------------------------------------------------------------

// Gambit setup/cleanup.


/*
 * ___VERSION must match the version number of the Gambit header file.
 */

#define ___VERSION 406001
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


static ViewController *theViewController = nil;

- (void)viewDidLoad {

  [super viewDidLoad];

  webViews[0] = webView0;
  webViews[1] = webView1;
  webViews[2] = webView2;
  webViews[3] = webView3;

  textViews[0] = textView0;
  textViews[1] = textView1;

  imageViews[0] = imageView0;
  imageViews[1] = imageView1;

  theViewController = self;

  set_textView_font(0, @"Courier-Bold", 16);

  segmCtrl.selectedSegmentIndex = UISegmentedControlNoSegment;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  timer = nil;

  queuedActions = [[NSMutableArray alloc] init];

  gambit_setup();

  [self heartbeat_tick];
}


- (void)viewDidUnload {

  [super viewDidUnload];

  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

  segmCtrl = nil;

  webView0 = nil;
  webView1 = nil;
  webView2 = nil;
  webView3 = nil;

  textView0 = nil;
  textView1 = nil;

  imageView0 = nil;
  imageView1 = nil;

  cancelButton = nil;

  accessoryView = nil;

  theViewController = nil;

  gambit_cleanup();
}


- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

  return YES;
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Text view delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {

  if (textViews[0].inputAccessoryView == nil)
    {
      [[NSBundle mainBundle] loadNibNamed:@"AccessoryView" owner:self options:nil];

      textViews[0].inputAccessoryView = accessoryView;

      accessoryView = nil;

      show_textView(0);
    }

  return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {

  [aTextView resignFirstResponder];
  return YES;
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {

  /*
    Reduce the size of the text view so that it's not obscured by the keyboard.
    Animate the resize so that it's in sync with the appearance of the keyboard.
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

  textViews[0].frame = newTextViewFrame;

  [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {

  NSDictionary* userInfo = [notification userInfo];

  /*
    Restore the size of the text view (fill self's view).  Animate the
    resize so that it's in sync with the disappearance of the
    keyboard.
  */

  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];

  textViews[0].frame = self.view.bounds;

  [UIView commitAnimations];
}


#include "intf.h"


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
          [timer release];
        }

      timer = [[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(heartbeat_tick) userInfo:nil repeats:NO] retain];
    }
}


- (void)app_become_active {

  theViewController.keyboardSounds = -1; // delay check of user preferences

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


void show_webView(int view) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int i;

      for (int i=0; i<NB_WEBVIEWS; i++)
        if (i != view)
          {
            [vc->webViews[i] resignFirstResponder];
            vc->webViews[i].hidden = YES;
          }
          
      for (int i=0; i<NB_TEXTVIEWS; i++)
        {
          [vc->textViews[i] resignFirstResponder];
          vc->textViews[i].hidden = YES;
        }

      for (int i=0; i<NB_IMAGEVIEWS; i++)
        {
          [vc->imageViews[i] resignFirstResponder];
          vc->imageViews[i].hidden = YES;
        }
      
      [vc->webViews[view] becomeFirstResponder];
      vc->webViews[view].hidden = NO;
    }
}


void show_textView(int view) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int i;

      for (int i=0; i<NB_WEBVIEWS; i++)
        {
          [vc->webViews[i] resignFirstResponder];
          vc->webViews[i].hidden = YES;
        }
          
      for (int i=0; i<NB_TEXTVIEWS; i++)
        if (i != view)
          {
            [vc->textViews[i] resignFirstResponder];
            vc->textViews[i].hidden = YES;
          }

      for (int i=0; i<NB_IMAGEVIEWS; i++)
        {
          [vc->imageViews[i] resignFirstResponder];
          vc->imageViews[i].hidden = YES;
        }
      
      [vc->textViews[view] becomeFirstResponder];
      vc->textViews[view].hidden = NO;
    }
}


void show_imageView(int view) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      int i;

      for (int i=0; i<NB_WEBVIEWS; i++)
        {
          [vc->webViews[i] resignFirstResponder];
          vc->webViews[i].hidden = YES;
        }
          
      for (int i=0; i<NB_TEXTVIEWS; i++)
        {
          [vc->textViews[i] resignFirstResponder];
          vc->textViews[i].hidden = YES;
        }

      for (int i=0; i<NB_IMAGEVIEWS; i++)
        if (i != view)
          {
            [vc->imageViews[i] resignFirstResponder];
            vc->imageViews[i].hidden = YES;
          }
      
      [vc->imageViews[view] becomeFirstResponder];
      vc->imageViews[view].hidden = NO;
    }
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


void add_to_textView(int view, NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSMutableString *new_text = [vc->textViews[view].text mutableCopy];
      [new_text appendString:str];
      vc->textViews[view].text = new_text;
      [new_text release];
    }
}


void add_output_to_textView(int view, NSString *str) {

  add_to_textView(view, [str stringByReplacingOccurrencesOfString:@" " withString:@"\u2007"]);
}


void add_input_to_textView(int view, NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSMutableString *new_text = [vc->textViews[view].text mutableCopy];
      NSRange selectedRange = vc->textViews[view].selectedRange;

      [new_text replaceCharactersInRange:selectedRange withString:str];

      vc->textViews[view].text = new_text;
      [new_text release];
    }
}


void set_webView_content(int view, NSString *str, BOOL enable_scaling, NSString *mime_type) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc->webViews[view]
          loadData:[str dataUsingEncoding:NSUnicodeStringEncoding]
          MIMEType:mime_type
          textEncodingName:@"UTF-8" 
          baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
      ];
      vc->webViews[0].scalesPageToFit = enable_scaling;
    }
}


void set_webView_content_from_file(int view, NSString *path, BOOL enable_scaling, NSString *mime_type) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSString *p = [[NSBundle mainBundle] pathForResource:path ofType:nil];
      if (p != nil)
        {
          NSData *data = [NSData dataWithContentsOfFile:p]; 
          if (data != nil)
            {
              [vc->webViews[view]
                  loadData:data
                  MIMEType:mime_type
                  textEncodingName:@"UTF-8" 
                  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
               ];
              vc->webViews[view].scalesPageToFit = enable_scaling;
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
      [vc->segmCtrl insertSegmentWithTitle:title atIndex:segment animated:true];
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
  [alert release];
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
      int end = [textViews[0].text length];

      int line_start = range.location+range.length;

      while (line_start > 0 &&
             (c = [textViews[0].text characterAtIndex:line_start-1]) != '\n' &&
             c != 0x2007) // non breaking space
        line_start--;

      int line_end = range.location+range.length;

      while (line_end < end &&
             [textViews[0].text characterAtIndex:line_end] != '\n')
        line_end++;

      if (line_start == line_end)
        {
          [textViews[0] resignFirstResponder]; // Hide the keyboard after "return" key is pressed on empty line
        }
      else
        {
          NSString *line = [textViews[0].text substringWithRange:NSMakeRange(line_start, line_end-line_start)];

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


- (IBAction)touch_up_Char:(id)sender withString:(NSString *)aString {

  add_input_to_textView(0, aString);
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_down:(id)sender {

  if (keyboardSounds != 0)
    {
      if (keyboardSounds == -1) // delayed check of user preferences?
        {
          Boolean exists_and_valid;
          keyboardSounds =
            CFPreferencesGetAppBooleanValue(CFSTR("keyboard"),
                                            CFSTR("/var/mobile/Library/Preferences/com.apple.preferences.sounds"),
                                            &exists_and_valid);
          if (!exists_and_valid)
            keyboardSounds = true; // by default turn on keyboard clicks
        }

      if (keyboardSounds != 0)
        AudioServicesPlaySystemSound(1104); // keyboard "tock" sound
    }
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F1:(id)sender {
  [self send_key:@"F1"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F2:(id)sender {
  [self send_key:@"F2"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F3:(id)sender {
  [self send_key:@"F3"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F4:(id)sender {
  [self send_key:@"F4"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F5:(id)sender {
  [self send_key:@"F5"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F6:(id)sender {
  [self send_key:@"F6"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F7:(id)sender {
  [self send_key:@"F7"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F8:(id)sender {
  [self send_key:@"F8"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F9:(id)sender {
  [self send_key:@"F9"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F10:(id)sender {
  [self send_key:@"F10"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F11:(id)sender {
  [self send_key:@"F11"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F12:(id)sender {
  [self send_key:@"F12"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_F13:(id)sender {
  [self send_key:@"F13"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_SHARP:(id)sender {
  [self send_key:@"#"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_DQUOTE:(id)sender {
  [self send_key:@"\""];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_QUOTE:(id)sender {
  [self send_key:@"'"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_COMMA:(id)sender {
  [self send_key:@","];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_PLUS:(id)sender {
  [self send_key:@"+"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_MINUS:(id)sender {
  [self send_key:@"-"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_STAR:(id)sender {
  [self send_key:@"*"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_SLASH:(id)sender {
  [self send_key:@"/"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_LPAREN:(id)sender {
  [self send_key:@"("];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_RPAREN:(id)sender {
  [self send_key:@")"];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

  NSString *url = [[request URL] relativeString];

  if ([url hasPrefix:@"event:"])
    {
      [self send_event:url];

      return NO;
    }

  return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {

  int i;

  [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];

  [segmCtrl release];

  for (i=0; i<NB_WEBVIEWS; i++)
    [webViews[i] release];

  for (i=0; i<NB_TEXTVIEWS; i++)
    [textViews[i] release];

  for (i=0; i<NB_IMAGEVIEWS; i++)
    [imageViews[i] release];

  [cancelButton release];

  [super dealloc];
}


@end
