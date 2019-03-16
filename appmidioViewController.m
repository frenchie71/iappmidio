//
//  appmidioViewController.m
//  admidio
//
//  Created by Marc Ahlgrim on 15.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import "appmidioViewController.h"
//#import "startViewController.h"

@interface appmidioViewController ()

@end

@implementation appmidioViewController


// ////////////////////////////////
// Connect Button clicked          //
// ////////////////////////////////

-(IBAction)buttonClicked:(id)sender


{
    
    [_spinWheel startAnimating];
    
    _mainAppDelegate  = [[UIApplication sharedApplication] delegate];
//    startViewController *tempController = _mainAppDelegate.startView;
    
    _mainAppDelegate.admidioURL=nil;
    _mainAppDelegate.admidioUser =nil;
    _mainAppDelegate.admidioPass=nil;
    _mainAppDelegate.admidioPreferences=nil;
    _mainAppDelegate.validlogin=NO;
  
    
    [self performSelector:@selector(datenspeichern) withObject:nil afterDelay:0];
     
     
//     @selector([self dismissViewControllerAnimated:NO completion:nil]) withObject:nil afterDelay:0]
    
    
   // [self dismissViewControllerAnimated:NO completion:nil];
}

// ////////////////////////////////////
//
// Daten Speichern
//
// ////////////////////////////////////
// ////////////////////////////////////


-(void)datenspeichern
{
    if ([_mainAppDelegate establishConnection:t_URL.text withUser: t_User.text andPass:t_Pass.text] == YES)
    {
    }
    [self dismissViewControllerAnimated:NO completion:nil];
   
}


// ////////////////////////////////
// Cancel Button clicked          //
// ////////////////////////////////

-(IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

// ////////////////////////////////
// viewDidLoad
// ////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_spinWheel stopAnimating];

    t_User.text = _mainAppDelegate.admidioUser;
    t_URL.text = _mainAppDelegate.admidioURL;
    t_Pass.text = _mainAppDelegate.admidioPass;
    self.title=@"Setup";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// //////////////////////////////////////
// Tastatur verstecken bei
// Enter in Passwortzeile
// //////////////////////////////////////

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self->t_Pass)
    {
        [self->t_Pass resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
