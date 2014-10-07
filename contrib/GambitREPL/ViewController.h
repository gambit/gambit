//
//  ViewController.h
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011-2012 Université de Montréal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "KOKeyboardRow.h"


// ViewController methods callable from Scheme.

void set_navigation(int n);
void show_cancelButton();
void hide_cancelButton();
void show_webView(int view, BOOL become_first_responder);
void show_textView(int view, BOOL become_first_responder);
void show_imageView(int view, BOOL become_first_responder);
void set_textView_font(int view, NSString *name, int size);
void set_textView_content(int view, NSString *str);
NSString *get_textView_content(int view);
void add_output_to_textView(int view, NSString *str);
void add_input_to_textView(int view, NSString *str);
void set_webView_content(int view, NSString *str, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type);
void set_webView_content_from_file(int view, NSString *path, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type);
void add_input_to_webView(int view, NSString *str);
void add_input_to_currentView(NSString *str);
NSString *eval_js_in_webView(int view, NSString *script);
void open_URL(NSString *url);
BOOL send_SMS(NSString *recipient, NSString *messsage);
BOOL pick_image();
void set_idle_timer(BOOL enable);
void set_toolbar_alpha(double alpha);
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

@interface ViewController : UIViewController <UITextViewDelegate,UIWebViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> { //,UIKeyInput

@public

  UISegmentedControl *segmCtrl;
  int currentView;
  int keyboardShowingView;
  UIWebView *webViews[NB_WEBVIEWS];
  UITextView *textViews[NB_TEXTVIEWS];
  UIImageView *imageViews[NB_IMAGEVIEWS];
  UIButton *cancelButton;
  UIToolbar *navToolbar;
  NSTimer *timer;
  NSMutableArray *queuedActions;
  CLLocationManager *locationManager;
  KOKeyboardRow *kov;
}

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmCtrl;
@property (assign) int currentView;
@property (assign) int keyboardShowingView;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIToolbar *navToolbar;
@property (strong) NSTimer *timer;
@property (strong) NSMutableArray *queuedActions;
@property (strong) CLLocationManager *locationManager;
@property (strong) KOKeyboardRow *kov;

- (void)queue_action:(void(^)())action;
- (void)send_event:(NSString*)name;
- (void)send_key:(NSString*)name;
- (void)heartbeat_tick;
- (void)schedule_next_heartbeat_tick:(double)interval;

- (void)app_become_active;

- (IBAction)navigation_changed:(id)sender;

- (IBAction)touch_up_cancel:(id)sender;

@end
