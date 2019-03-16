//
//  listViewController.h
//  admidio
//
//  Created by Marc Ahlgrim on 20.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appmidioAppDelegate.h"
#import "detailViewController.h"
#import "MessageUI/MessageUI.h"

#define ROLLENLISTE 1
#define MEMBERLISTE 2
#define SUCHLISTE 3


// ////////////////////////////////////
// Klassendefinition
// ////////////////////////////////////


@interface listViewController : UITableViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UIView *startView;
}


@property appmidioAppDelegate *mainAppDelegate;
//@property     __weak IBOutlet UIActivityIndicatorView *spinWheel;


@property NSArray        *rollenListe;
@property NSArray        *memberListe;
@property NSMutableArray *sectionKeysAndCounts;
@property NSInteger      listenTyp;
@property NSDictionary   *selektierteRolle;
@property NSDictionary   *selektierterMember;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) makeSectionKeysAndCounts;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

-(IBAction)kontaktButtonClicked:(id)sender;
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error ;
@end
