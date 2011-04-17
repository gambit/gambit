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

@synthesize textView, accessoryView, webView, keyboardSounds;

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


void gambit_setup()
{
  /*
   * Setup the Scheme library by calling "___setup" with appropriate
   * parameters.  The call to "___setup_params_reset" sets all
   * parameters to their default setting.
   */

  int debug_settings = ___DEBUG_SETTINGS_INITIAL;
  ___UCS_2STRING *ucs2_argv;

  if (___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST
        (main_argv,
         &ucs2_argv)
      != ___FIX(___NO_ERR))
    exit(1);

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
  setup_params.debug_settings = debug_settings;

  ___setup (&setup_params);
}


void gambit_cleanup()
{
  ___cleanup ();
}


//-----------------------------------------------------------------------------


static ViewController *theViewController = nil;

- (void)viewDidLoad {

  [super viewDidLoad];

  theViewController = self;

  set_textView_font(@"Courier-Bold", 16);

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  gambit_setup();

  [self heartbeat_tick];
}


- (void)viewDidUnload {

  [super viewDidUnload];

  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

  textView = nil;
  accessoryView = nil;
  webView = nil;
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

  if (textView.inputAccessoryView == nil)
    {

      [[NSBundle mainBundle] loadNibNamed:@"AccessoryView" owner:self options:nil];

      textView.inputAccessoryView = accessoryView;

      accessoryView = nil;

      show_textView();
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

  textView.frame = newTextViewFrame;

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
    
  textView.frame = self.view.bounds;
    
  [UIView commitAnimations];
}


#include "program.h"


- (void)heartbeat_tick {

  ___ON_THROW(
    {
      [self schedule_next_heartbeat_tick:heartbeat()];
    },
    exit(0);
  );
}


- (void)schedule_next_heartbeat_tick:(double)interval {

  if (interval > 0)
    {
      [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(heartbeat_tick) userInfo:nil repeats:NO];
    }
}


void show_textView() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc.textView.hidden = NO;
      vc.webView.hidden = YES;
      [vc.textView becomeFirstResponder];
    }
}


void show_webView() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc.webView.hidden = NO;
      vc.textView.hidden = YES;
      [vc.webView becomeFirstResponder];
    }
}


void set_textView_content(NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc.textView.text = str;
    }
}


NSString *get_textView_content() {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      return vc.textView.text;
    }

  return @"";
}


void set_textView_font(NSString *name, int size) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      vc.textView.font = [UIFont fontWithName:name size:size];
    }
}


void add_to_textView(NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      NSMutableString *new_text = [vc.textView.text mutableCopy];
      [new_text appendString:str];
      vc.textView.text = new_text;
      [new_text release];
    }
}


void add_output_to_textView(NSString *str) {

  add_to_textView([str stringByReplacingOccurrencesOfString:@" " withString:@"\u2007"]);
}


void set_webView_content(NSString *str) {

  ViewController *vc = theViewController;
  if (vc != nil)
    {
      [vc.webView
          loadHTMLString:str
          baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]

          //          baseURL:[NSURL URLWithString:@"/Users"]
          //          baseURL:[NSURL URLWithString:[[NSBundle mainBundle] bundlePath]]
          //          baseURL:[[NSBundle mainBundle] bundlePath]
          //          baseURL:n
      ];
    }
}


void open_URL(NSString *url) {

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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


- (BOOL)textView:(UITextView *)textView2 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

  if ([text isEqualToString:@"\n"])
    {
      unichar c;
      int end = [textView.text length];

      int line_start = range.location+range.length;

      while (line_start > 0 &&
             (c = [textView.text characterAtIndex:line_start-1]) != '\n' &&
             c != 0x2007) // non breaking space
        line_start--;

      int line_end = range.location+range.length;

      while (line_end < end &&
             [textView.text characterAtIndex:line_end] != '\n')
        line_end++;

      NSString *line = [textView.text substringWithRange:NSMakeRange(line_start, line_end-line_start)];

      if (line_end == end)
        {
          add_to_textView(@"\n");

          ___ON_THROW(
            {
              [self schedule_next_heartbeat_tick:send_input([line stringByAppendingString:@"\n"])];
            },
            exit(0);
          );

          [textView resignFirstResponder];
        }
      else
        add_to_textView(line);
        
      return NO;
    }

  return YES;
}


- (IBAction)touch_up_Char:(id)sender withString:(NSString *)aString {

  NSMutableString *text = [textView.text mutableCopy];
  NSRange selectedRange = textView.selectedRange;
    
  [text replaceCharactersInRange:selectedRange withString:aString];

  textView.text = text;
  [text release];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_down:(id)sender {

  if (keyboardSounds != 0)
    {
      if (keyboardSounds == -1) // delayed check of user preferences?
        keyboardSounds =
          CFPreferencesGetAppBooleanValue(CFSTR("keyboard"),
                                          CFSTR("/var/mobile/Library/Preferences/com.apple.preferences.sounds"),
                                          NULL);

      if (keyboardSounds != 0)
        AudioServicesPlaySystemSound(1104); // keyboard "tock" sound
    }
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_SHARP:(id)sender {
  [self touch_up_Char:sender withString:@"#"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_DQUOTE:(id)sender {
  [self touch_up_Char:sender withString:@"\""];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_QUOTE:(id)sender {
  [self touch_up_Char:sender withString:@"'"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_COMMA:(id)sender {
  [self touch_up_Char:sender withString:@","];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_PLUS:(id)sender {
  [self touch_up_Char:sender withString:@"+"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_MINUS:(id)sender {
  [self touch_up_Char:sender withString:@"-"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_STAR:(id)sender {
  [self touch_up_Char:sender withString:@"*"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_SLASH:(id)sender {
  [self touch_up_Char:sender withString:@"/"];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_LPAREN:(id)sender {
  [self touch_up_Char:sender withString:@"("];
}


#pragma mark -
#pragma mark Accessory view action

- (IBAction)touch_up_RPAREN:(id)sender {
  [self touch_up_Char:sender withString:@")"];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

  //NSString *url = [[request URL] absoluteString];
  NSString *url = [[request URL] relativeString];

  if ([url hasPrefix:@"event:"])
    {
#if 0
      NSString *path = [[request URL] path];
      NSString *fragment = [[request URL] fragment];
      NSString *host = [[request URL] host];
      NSString *param = [[request URL] parameterString];
      NSString *query = [[request URL] query];
      //  NSString *foo = [[request URL] foo];

      url = [url stringByAppendingString:@"|"];

      if (path != nil)
        url = [url stringByAppendingString:path];

      url = [url stringByAppendingString:@"|"];

      if (fragment != nil)
        url = [url stringByAppendingString:fragment];

      url = [url stringByAppendingString:@"|"];

      if (host != nil)
        url = [url stringByAppendingString:host];

      url = [url stringByAppendingString:@"|"];

      if (param != nil)
        url = [url stringByAppendingString:param];

      url = [url stringByAppendingString:@"|"];

      if (query != nil)
        url = [url stringByAppendingString:query];

      url = [url stringByAppendingString:@"|"];

      //  if (foo != nil)
      //    url = [url stringByAppendingString:foo];

#endif

#if 1
      ___ON_THROW(
        {
          [self schedule_next_heartbeat_tick:send_event([url stringByAppendingString:@"\n"])];
        },
        exit(0);
      );

      return NO;
    }

#endif

  return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {

  [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
  [textView release];

  [super dealloc];
}


@end
