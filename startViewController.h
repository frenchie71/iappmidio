//
//  startViewController.h
//  admidio
//
//  Created by Marc Ahlgrim on 20.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appmidioAppDelegate.h"

@interface startViewController : UIViewController
{
    IBOutlet UIButton *btnList;
    IBOutlet UIButton *btnDetail;
    IBOutlet UIButton *btnSetup;
    IBOutlet UINavigationItem *meinTitel;
    IBOutlet UITextView  *t_Status;
}

@property appmidioAppDelegate *mainAppDelegate;
@property     __weak IBOutlet UIActivityIndicatorView *spinWheel;

@property BOOL fromSetup;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-(void) statusAnzeigen;

@end
