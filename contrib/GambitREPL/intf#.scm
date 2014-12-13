;;;============================================================================

;;; File: "intf#.scm"

;;; Copyright (c) 2011-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("intf#"

string->Class
Class->string
string->SEL
SEL->string
send0
send1
send2
id->string
string->id
id->bool
bool->id
id->int
int->id
id->float
float->id
id->double
double->id

NSDate
alloc
init
description
date

NSBundle
mainBundle
objectForInfoDictionaryKey
mainBundle-info
CFBundleName
CFBundleDisplayName

currentDevice-batteryLevel
currentDevice-batteryMonitoringEnabled
currentDevice-batteryMonitoringEnabled-set!
currentDevice-multitaskingSupported
currentDevice-model
currentDevice-name
currentDevice-systemName
currentDevice-systemVersion
currentDevice-uniqueIdentifier
device-status
device-model
UDID

AudioServicesPlayAlertSound
AudioServicesPlaySystemSound
kSystemSoundID_FlashScreen
kSystemSoundID_Vibrate
kSystemSoundID_UserPreferredAlert

set-ext-keys
set-navigation
show-cancelButton
hide-cancelButton
show-textView
show-webView
set-textView-font
set-textView-content
get-textView-content
add-output-to-textView
add-text-input-to-textView
add-key-input-to-textView
set-webView-content
set-webView-content-from-file
add-text-input-to-webView
add-key-input-to-webView
add-text-input-to-currentView
add-key-input-to-currentView
eval-js-in-webView

open-URL
send-SMS
pick-image
set-idle-timer
set-toolbar-alpha
show-toolbar
hide-toolbar
toggle-toolbar
segm-ctrl-set-title
segm-ctrl-insert
set-pref
get-pref
set-pasteboard
get-pasteboard
get-documents-dir
get-icloud-container-dir
popup-alert
setup-location-updates

set-navigation-bar

send-input
send-event
send-text-input
send-key-input
handle-text-input
handle-key-input
heartbeat
next-heartbeat-interval
interval-runnable
interval-io-pending
interval-no-io-pending
interval-min-wait

eval-string

repl-port
event-port
event-handler

set-event-handler
set-location-update-event-handler
show-view
set-view-content

has-prefix?
get-event-parameters

contained-path-resolve

iCloudAccountAvailabilityChanged

))

;;;============================================================================
