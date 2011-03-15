/* File: "program.h" */

/*
 * Scheme functions which can be called from C.  These functions are
 * declared with a c-define in "program.scm".
 */

extern NSString *eval_string(NSString *);

extern double send_input(NSString *);

extern double send_event(NSString *);

extern double heartbeat();
