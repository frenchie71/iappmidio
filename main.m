//
//  main.m
//  admidio
//
//  Created by Marc Ahlgrim on 15.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "appmidioAppDelegate.h"

int main(int argc, char * argv[])
{
    NSLog(@"Marker : %@",@"enter main");
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([appmidioAppDelegate class]));
        NSLog(@"Marker : %@",@"exit main");
    }
}
