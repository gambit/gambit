/* File: "intf.h" */

/*
 * Scheme functions which can be called from C.  These functions are
 * declared with a c-define in "intf.scm".
 */

extern NSString *eval_string(NSString *);

extern void send_input(NSString *);

extern void send_event(NSString *);

extern void send_key(NSString *);

extern double heartbeat();
