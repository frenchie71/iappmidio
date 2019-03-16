//
//  appmidioViewController.h
//  admidio
//
//  Created by Marc Ahlgrim on 15.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appmidioAppDelegate.h"

@interface appmidioViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIView      *startView;
    IBOutlet UITextView  *t_URL;
    IBOutlet UITextField *t_User;
    IBOutlet UITextField *t_Pass;
    
}

@property appmidioAppDelegate *mainAppDelegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinWheel;



-(IBAction)buttonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;
-(void)datenspeichern;

@end
