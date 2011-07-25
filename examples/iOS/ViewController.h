//
//  ViewController.h
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011 Université de Montréal. All rights reserved.
//

#import <UIKit/UIKit.h>


// ViewController methods callable from Scheme.

void show_textView();
void show_webView();
NSString *get_textView_content();
void set_textView_font(NSString *name, int size);
void set_textView_content(NSString *str);
void add_output_to_textView(NSString *str);
void add_input_to_textView(NSString *str);
void set_webView_content(NSString *str, BOOL enable_scaling, NSString *mime_type);
void open_URL(NSString *url);
void set_pref(NSString *key, NSString *value);
NSString *get_pref(NSString *key);


@interface ViewController : UIViewController <UITextViewDelegate,UIWebViewDelegate> {

  UITextView *textView;
  UIView *accessoryView;
  UIWebView *webView;
  int keyboardSounds;
  NSTimer *timer;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) IBOutlet UIView *accessoryView;
@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (assign) int keyboardSounds;
@property (assign) NSTimer *timer;

- (void)up_key:(NSString*)name;
- (void)heartbeat_tick;
- (void)schedule_next_heartbeat_tick:(double)interval;

- (IBAction)touch_down:(id)sender;
- (IBAction)touch_up_F1:(id)sender;
- (IBAction)touch_up_F2:(id)sender;
- (IBAction)touch_up_F3:(id)sender;
- (IBAction)touch_up_F4:(id)sender;
- (IBAction)touch_up_F5:(id)sender;
- (IBAction)touch_up_F6:(id)sender;
- (IBAction)touch_up_F7:(id)sender;
- (IBAction)touch_up_F8:(id)sender;
- (IBAction)touch_up_F9:(id)sender;
- (IBAction)touch_up_F10:(id)sender;
- (IBAction)touch_up_F11:(id)sender;
- (IBAction)touch_up_F12:(id)sender;
- (IBAction)touch_up_F13:(id)sender;
- (IBAction)touch_up_SHARP:(id)sender;
- (IBAction)touch_up_DQUOTE:(id)sender;
- (IBAction)touch_up_QUOTE:(id)sender;
- (IBAction)touch_up_COMMA:(id)sender;
- (IBAction)touch_up_PLUS:(id)sender;
- (IBAction)touch_up_MINUS:(id)sender;
- (IBAction)touch_up_STAR:(id)sender;
- (IBAction)touch_up_SLASH:(id)sender;
- (IBAction)touch_up_LPAREN:(id)sender;
- (IBAction)touch_up_RPAREN:(id)sender;

@end
