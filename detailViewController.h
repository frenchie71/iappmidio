//
//  detailViewController.h
//  admidio
//
//  Created by Marc Ahlgrim on 20.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appmidioAppDelegate.h"

@interface detailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    IBOutlet UILabel *lblFirstName;
    IBOutlet UILabel *lblBirthday;
}


@property appmidioAppDelegate *mainAppDelegate;
@property     __weak IBOutlet UIActivityIndicatorView *spinWheel;


@property NSDictionary *selektierterMember;
@property IBOutlet UILabel *lblLastName;
@property NSArray *memberDetail;
@property IBOutlet UITableView *meineTableView;


-(IBAction)okButtonClicked:(id)sender;

- (void) datenAnzeigen;
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)linkOeffnen:(NSString *)sLinkValue linkTyp:(NSString *)sLinkType;

//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex;
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
