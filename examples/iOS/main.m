//
//  main.m
//
//  Created by Marc Feeley on 11-03-06.
//  Copyright 2011 Université de Montréal. All rights reserved.
//

#import <UIKit/UIKit.h>

char **main_argv;

int main(int argc, char *argv[]) {
  main_argv = argv;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  return retVal;
}
