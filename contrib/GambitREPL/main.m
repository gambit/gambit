
//
//  main.m
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011 Université de Montréal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

char **main_argv;

int main(int argc, char *argv[]) {

  main_argv = argv;

  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
