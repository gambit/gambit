//
//  ViewController.h
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011-2012 Université de Montréal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


// ViewController methods callable from Scheme.

void set_navigation(int n);
void show_cancelButton();
void hide_cancelButton();
void show_webView(int view);
void show_textView(int view);
void show_imageView(int view);
void set_textView_font(int view, NSString *name, int size);
void set_textView_content(int view, NSString *str);
NSString *get_textView_content(int view);
void add_output_to_textView(int view, NSString *str);
void add_input_to_textView(int view, NSString *str);
void set_webView_content(int view, NSString *str, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type);
void set_webView_content_from_file(int view, NSString *path, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type);
NSString *eval_js_in_webView(int view, NSString *script);
void open_URL(NSString *url);
void set_idle_timer(BOOL enable);
void segm_ctrl_set_title(int segment, NSString *title);
void segm_ctrl_insert(int segment, NSString *title);
void segm_ctrl_remove(int segment);
void segm_ctrl_remove_all();
void set_pref(NSString *key, NSString *value);
NSString *get_pref(NSString *key);
void set_pasteboard(NSString *value);
NSString *get_pasteboard();
NSString *get_documents_dir();
void popup_alert(NSString *title, NSString *msg, NSString *cancel_button, NSString *accept_button);
void setup_location_updates(double desired_accuracy, double distance_filter);

#define NB_WEBVIEWS   4
#define NB_TEXTVIEWS  2
#define NB_IMAGEVIEWS 2

@interface ViewController : UIViewController <UITextViewDelegate,UIWebViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate> {

  UISegmentedControl *segmCtrl;
  UIWebView *webViews[NB_WEBVIEWS];
  UIWebView *webView0;
  UIWebView *webView1;
  UIWebView *webView2;
  UIWebView *webView3;
  UITextView *textViews[NB_TEXTVIEWS];
  UITextView *textView0;
  UITextView *textView1;
  UIImageView *imageViews[NB_IMAGEVIEWS];
  UIImageView *imageView0;
  UIImageView *imageView1;
  UIButton *cancelButton;
  UIView *accessoryView;
  int keyboardSounds;
  NSTimer *timer;
  NSMutableArray *queuedActions;
  CLLocationManager *locationManager;
}

@property (nonatomic, assign) IBOutlet UISegmentedControl *segmCtrl;
@property (nonatomic, assign) IBOutlet UIWebView *webView0;
@property (nonatomic, assign) IBOutlet UIWebView *webView1;
@property (nonatomic, assign) IBOutlet UIWebView *webView2;
@property (nonatomic, assign) IBOutlet UIWebView *webView3;
@property (nonatomic, retain) IBOutlet UITextView *textView0;
@property (nonatomic, retain) IBOutlet UITextView *textView1;
@property (nonatomic, retain) IBOutlet UIImageView *imageView0;
@property (nonatomic, retain) IBOutlet UIImageView *imageView1;
@property (nonatomic, assign) IBOutlet UIButton *cancelButton;
@property (nonatomic, assign) IBOutlet UIView *accessoryView;
@property (assign) int keyboardSounds;
@property (assign) NSTimer *timer;
@property (assign) NSMutableArray *queuedActions;
@property (assign) CLLocationManager *locationManager;

- (void)queue_action:(void(^)())action;
- (void)send_event:(NSString*)name;
- (void)send_key:(NSString*)name;
- (void)heartbeat_tick;
- (void)schedule_next_heartbeat_tick:(double)interval;

- (void)app_become_active;

- (IBAction)navigation_changed:(id)sender;

- (IBAction)touch_up_cancel:(id)sender;

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
