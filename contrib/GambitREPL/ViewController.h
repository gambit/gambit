//
//  ViewController.h
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011-2014 Université de Montréal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <Availability.h>
#import "TView.h"
#import "ITView.h"
#import "WView.h"
#import "IView.h"


// ViewController methods callable from Scheme.

void set_ext_keys(int view, NSString *portrait_small, NSString *landscape_small, NSString *portrait_large, NSString *landscape_large);
void set_navigation(int n);
void show_cancelButton();
void hide_cancelButton();
void show_webView(int view, BOOL kbdEnabled, BOOL kbdShouldShrinkView);
void show_textView(int view, BOOL kbdEnabled, BOOL kbdShouldShrinkView);
void show_imageView(int view, BOOL kbdEnabled, BOOL kbdShouldShrinkView);
void set_textView_font(int view, NSString *name, int size);
void set_textView_content(int view, NSString *str);
NSString *get_textView_content(int view);
void add_output_to_textView(int view, NSString *str);
void add_text_input_to_textView(int view, NSString *input);
void add_key_input_to_textView(int view, NSString *input);
void set_webView_content(int view, NSString *str, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type);
void set_webView_content_from_file(int view, NSString *path, NSString *base_url_path, BOOL enable_scaling, NSString *mime_type);
void add_text_input_to_webView(int view, NSString *input);
void add_key_input_to_webView(int view, NSString *input);
void add_text_input_to_currentView(NSString *input);
void add_key_input_to_currentView(NSString *input);
NSString *eval_js_in_webView(int view, NSString *script);
void open_URL(NSString *url);
BOOL send_SMS(NSString *recipient, NSString *messsage);
BOOL pick_image();
void set_idle_timer(BOOL enable);
void set_toolbar_alpha(double alpha);
void show_toolbar();
void hide_toolbar();
void toggle_toolbar();
void segm_ctrl_set_title(int segment, NSString *title);
void segm_ctrl_insert(int segment, NSString *title);
void segm_ctrl_remove(int segment);
void segm_ctrl_remove_all();
void set_pref(NSString *key, NSString *value);
NSString *get_pref(NSString *key);
void set_pasteboard(NSString *value);
NSString *get_pasteboard();
NSString *get_documents_dir();
NSString *get_icloud_container_dir();
void popup_alert(NSString *title, NSString *msg, NSString *cancel_button, NSString *accept_button);
void setup_location_updates(double desired_accuracy, double distance_filter);

#define NB_WEBVIEWS   5
#define NB_TEXTVIEWS  2
#define NB_IMAGEVIEWS 2

@interface ViewController : UIViewController <UITextViewDelegate,UIWebViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {

@public

  UISegmentedControl *segmCtrl;
  int currentView;
  BOOL haveSoftKeyboard;
  BOOL inShowView;
  ITView *inputTextView;
  BOOL inputTextViewEnable;
  WView *webViews[NB_WEBVIEWS];
  TView *textViews[NB_TEXTVIEWS];
  IView *imageViews[NB_IMAGEVIEWS];
  UIButton *cancelButton;
  UIToolbar *navToolbar;
  NSTimer *timer;
  NSMutableArray *queuedActions;
  CLLocationManager *locationManager;
}

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmCtrl;
@property (assign) int currentView;
@property (assign) BOOL haveSoftKeyboard;
@property (assign) BOOL inShowView;
@property (nonatomic, strong) IBOutlet UITextView *inputTextView;
@property (assign) BOOL inputTextViewEnable;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIToolbar *navToolbar;
@property (strong) NSTimer *timer;
@property (strong) NSMutableArray *queuedActions;
@property (strong) CLLocationManager *locationManager;

- (void)queue_action:(void(^)())action;
- (void)send_event:(NSString*)name;
- (void)send_text_input:(NSString*)input;
- (void)send_key_input:(NSString*)input;
- (void)heartbeat_tick;
- (void)schedule_next_heartbeat_tick:(double)interval;

- (void)app_become_active;
- (id)get_inputAccessoryView;

- (IBAction)navigation_changed:(id)sender;

- (IBAction)touch_up_cancel:(id)sender;

- (void)keyCmd0;
- (void)keyCmd1;
- (void)keyCmd2;
- (void)keyCmd3;
- (void)keyCmd4;
- (void)keyCmd5;
- (void)keyCmd6;
- (void)keyCmd7;
- (void)keyCmd8;
- (void)keyCmd9;

- (void)keyCmdA;
- (void)keyCmdB;
- (void)keyCmdC;
- (void)keyCmdD;
- (void)keyCmdE;
- (void)keyCmdF;
- (void)keyCmdG;
- (void)keyCmdH;
- (void)keyCmdI;
- (void)keyCmdJ;
- (void)keyCmdK;
- (void)keyCmdL;
- (void)keyCmdM;
- (void)keyCmdN;
- (void)keyCmdO;
- (void)keyCmdP;
- (void)keyCmdQ;
- (void)keyCmdR;
- (void)keyCmdS;
- (void)keyCmdT;
- (void)keyCmdU;
- (void)keyCmdV;
- (void)keyCmdW;
- (void)keyCmdX;
- (void)keyCmdY;
- (void)keyCmdZ;

- (void)keyShiftCmdA;
- (void)keyShiftCmdB;
- (void)keyShiftCmdC;
- (void)keyShiftCmdD;
- (void)keyShiftCmdE;
- (void)keyShiftCmdF;
- (void)keyShiftCmdG;
- (void)keyShiftCmdH;
- (void)keyShiftCmdI;
- (void)keyShiftCmdJ;
- (void)keyShiftCmdK;
- (void)keyShiftCmdL;
- (void)keyShiftCmdM;
- (void)keyShiftCmdN;
- (void)keyShiftCmdO;
- (void)keyShiftCmdP;
- (void)keyShiftCmdQ;
- (void)keyShiftCmdR;
- (void)keyShiftCmdS;
- (void)keyShiftCmdT;
- (void)keyShiftCmdU;
- (void)keyShiftCmdV;
- (void)keyShiftCmdW;
- (void)keyShiftCmdX;
- (void)keyShiftCmdY;
- (void)keyShiftCmdZ;

- (void)keyCtrlSpace;
- (void)keyCtrlA;
- (void)keyCtrlB;
- (void)keyCtrlC;
- (void)keyCtrlD;
- (void)keyCtrlE;
- (void)keyCtrlF;
- (void)keyCtrlG;
- (void)keyCtrlH;
- (void)keyCtrlI;
- (void)keyCtrlJ;
- (void)keyCtrlK;
- (void)keyCtrlL;
- (void)keyCtrlM;
- (void)keyCtrlN;
- (void)keyCtrlO;
- (void)keyCtrlP;
- (void)keyCtrlQ;
- (void)keyCtrlR;
- (void)keyCtrlS;
- (void)keyCtrlT;
- (void)keyCtrlU;
- (void)keyCtrlV;
- (void)keyCtrlW;
- (void)keyCtrlX;
- (void)keyCtrlY;
- (void)keyCtrlZ;
- (void)keyESC;
- (void)keyFS;
- (void)keyGS;
- (void)keyRS;
- (void)keyUS;

- (void)keyCmdCtrlSpace;
- (void)keyCmdCtrlA;
- (void)keyCmdCtrlB;
- (void)keyCmdCtrlC;
- (void)keyCmdCtrlD;
- (void)keyCmdCtrlE;
- (void)keyCmdCtrlF;
- (void)keyCmdCtrlG;
- (void)keyCmdCtrlH;
- (void)keyCmdCtrlI;
- (void)keyCmdCtrlJ;
- (void)keyCmdCtrlK;
- (void)keyCmdCtrlL;
- (void)keyCmdCtrlM;
- (void)keyCmdCtrlN;
- (void)keyCmdCtrlO;
- (void)keyCmdCtrlP;
- (void)keyCmdCtrlQ;
- (void)keyCmdCtrlR;
- (void)keyCmdCtrlS;
- (void)keyCmdCtrlT;
- (void)keyCmdCtrlU;
- (void)keyCmdCtrlV;
- (void)keyCmdCtrlW;
- (void)keyCmdCtrlX;
- (void)keyCmdCtrlY;
- (void)keyCmdCtrlZ;
- (void)keyCmdESC;
- (void)keyCmdFS;
- (void)keyCmdGS;
- (void)keyCmdRS;
- (void)keyCmdUS;

- (void)keyShiftCtrlSpace;
- (void)keyShiftCtrlA;
- (void)keyShiftCtrlB;
- (void)keyShiftCtrlC;
- (void)keyShiftCtrlD;
- (void)keyShiftCtrlE;
- (void)keyShiftCtrlF;
- (void)keyShiftCtrlG;
- (void)keyShiftCtrlH;
- (void)keyShiftCtrlI;
- (void)keyShiftCtrlJ;
- (void)keyShiftCtrlK;
- (void)keyShiftCtrlL;
- (void)keyShiftCtrlM;
- (void)keyShiftCtrlN;
- (void)keyShiftCtrlO;
- (void)keyShiftCtrlP;
- (void)keyShiftCtrlQ;
- (void)keyShiftCtrlR;
- (void)keyShiftCtrlS;
- (void)keyShiftCtrlT;
- (void)keyShiftCtrlU;
- (void)keyShiftCtrlV;
- (void)keyShiftCtrlW;
- (void)keyShiftCtrlX;
- (void)keyShiftCtrlY;
- (void)keyShiftCtrlZ;
- (void)keyShiftESC;
- (void)keyShiftFS;
- (void)keyShiftGS;
- (void)keyShiftRS;
- (void)keyShiftUS;

- (void)keyShiftCmdCtrlSpace;
- (void)keyShiftCmdCtrlA;
- (void)keyShiftCmdCtrlB;
- (void)keyShiftCmdCtrlC;
- (void)keyShiftCmdCtrlD;
- (void)keyShiftCmdCtrlE;
- (void)keyShiftCmdCtrlF;
- (void)keyShiftCmdCtrlG;
- (void)keyShiftCmdCtrlH;
- (void)keyShiftCmdCtrlI;
- (void)keyShiftCmdCtrlJ;
- (void)keyShiftCmdCtrlK;
- (void)keyShiftCmdCtrlL;
- (void)keyShiftCmdCtrlM;
- (void)keyShiftCmdCtrlN;
- (void)keyShiftCmdCtrlO;
- (void)keyShiftCmdCtrlP;
- (void)keyShiftCmdCtrlQ;
- (void)keyShiftCmdCtrlR;
- (void)keyShiftCmdCtrlS;
- (void)keyShiftCmdCtrlT;
- (void)keyShiftCmdCtrlU;
- (void)keyShiftCmdCtrlV;
- (void)keyShiftCmdCtrlW;
- (void)keyShiftCmdCtrlX;
- (void)keyShiftCmdCtrlY;
- (void)keyShiftCmdCtrlZ;
- (void)keyShiftCmdESC;
- (void)keyShiftCmdFS;
- (void)keyShiftCmdGS;
- (void)keyShiftCmdRS;
- (void)keyShiftCmdUS;

- (void)keyDelete;
- (void)keyDeleteLong;

- (void)keyCmdReturn;

- (void)keyCtrlTAB;
- (void)keyShiftCtrlTAB;

- (void)keyUpArrow;
- (void)keyDownArrow;
- (void)keyLeftArrow;
- (void)keyRightArrow;

- (void)keyCmdUpArrow;
- (void)keyCmdDownArrow;
- (void)keyCmdLeftArrow;
- (void)keyCmdRightArrow;

- (void)keyShiftUpArrow;
- (void)keyShiftDownArrow;
- (void)keyShiftLeftArrow;
- (void)keyShiftRightArrow;

- (void)keyShiftCmdUpArrow;
- (void)keyShiftCmdDownArrow;
- (void)keyShiftCmdLeftArrow;
- (void)keyShiftCmdRightArrow;

- (void)keyOptLeftArrow;
- (void)keyOptRightArrow;
- (void)keyShiftOptLeftArrow;
- (void)keyShiftOptRightArrow;

- (void)keyCtrl;

@end

extern ViewController *theViewController;
