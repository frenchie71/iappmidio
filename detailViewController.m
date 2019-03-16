//
//  detailViewController.m
//  admidio
//
//  Created by Marc Ahlgrim on 20.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import "detailViewController.h"



@interface detailViewController ()

@end

@implementation detailViewController

// /////////////////////////////////////////////////////
@synthesize meineTableView;
// /////////////////////////////////////////////////////


// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
        CGRect currentbounds=cell.bounds;
        currentbounds.size.height = currentbounds.size.height*0.5;
    }
    NSString *cellKey = [[_memberDetail objectAtIndex:indexPath.row] objectForKey:@"usf_name"];
    NSString *cellValue = [[_memberDetail objectAtIndex:indexPath.row] objectForKey:@"usd_value"];
    cell.textLabel.text       = cellKey ;
    cell.detailTextLabel.text = cellValue;
    
    
    return cell;
}


// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _memberDetail.count;
}

// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self datenAnzeigen];
    self.title = @"Detail";
}

// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// /////////////////////////////////////////////////////
//
// linkoeffnen - Zeige UIAlertView
//
//
// /////////////////////////////////////////////////////

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
    }
    
    
    
    
    NSString *textFeldInhalt = [alertView textFieldAtIndex:0].text;
    NSString *sURL;
    
    switch (alertView.tag) {
        case 1:
            sURL=[NSString stringWithFormat:@"tel://%@",textFeldInhalt];
            break;
        case 2:
            sURL=[NSString stringWithFormat:@"mailto://%@",textFeldInhalt];
            break;
          
        default:
            break;
    }

    
    if (buttonIndex ==1)
    {
      if (sURL)  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sURL]];
        
#ifdef DEBUGFLAG
      NSLog(@"sURL :%@",sURL) ;   //Code that will run after you press ok button
#endif

    }
    
}


- (void)linkOeffnen:(NSString *)sLinkValue linkTyp:(NSString *)sLinkType
{

    NSString *Titel;
    UIAlertView *alertView;
    
    if ([sLinkType isEqualToString:@"tel://"])
    {
        Titel=@"Telefon";
        alertView = [[UIAlertView alloc] initWithTitle:Titel
                                                        message:@"Diese Nummer anrufen"
                                                       delegate:self
                                              cancelButtonTitle:@"Abbruch"
                                              otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag=1;
        UITextField *Nummer = [alertView textFieldAtIndex:0];
        [Nummer setText:sLinkValue];
    }

    if ([sLinkType isEqualToString:@"mailto://"])
    {
        Titel=@"eMail";
        alertView = [[UIAlertView alloc] initWithTitle:Titel
                                                        message:@"Mail senden an diese Adresse"
                                                       delegate:self
                                              cancelButtonTitle:@"Abbruch"
                                              otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag=2;
        UITextField *Adresse = [alertView textFieldAtIndex:0];
        [Adresse setText:sLinkValue];
    }

    if (alertView !=nil)
        [alertView show];
    
    
}


// /////////////////////////////////////////////////////
//
// didSelectRowAtIndexPath soll auf Telefonnumern
// und e-mail-Adressen reagieren.
//
// /////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellDict = [_memberDetail objectAtIndex:indexPath.row];
    NSString *cellKey = [cellDict objectForKey:@"usf_name_intern"];
    NSString *cellValue = [cellDict objectForKey:@"usd_value"];

    #ifdef DEBUGFLAG
        NSLog ([NSString stringWithFormat:@"Cellkey is %@ and Value is %@",(NSString *)cellKey,(NSString *)cellValue]);
    #endif

   // NSURL *linkURL = nil;
   // UIDevice *device = [UIDevice currentDevice];
    
    // Telefonnummern
    
    if (
        ([cellKey isEqualToString:@"NOTFALL-NUMMER"]) ||
        ([cellKey rangeOfString:@"PHONE" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
        ([cellKey rangeOfString:@"TELEFON" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
        ([cellKey rangeOfString:@"HANDY" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
        ([cellKey rangeOfString:@"NATEL" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
        ([cellKey rangeOfString:@"GSM" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
        ([cellKey rangeOfString:@"MOBILE" options:NSCaseInsensitiveSearch].location != NSNotFound)
       )
    {
        // Bugfix : Leerzeichen entfernen
        NSString *Telefonnummer = [[NSString stringWithFormat:@"%@",cellValue]stringByReplacingOccurrencesOfString:@" " withString:@""];

        // Erweiterung : Vorher nachfragen
        [self linkOeffnen:Telefonnummer linkTyp:@"tel://"];
    }
    // e-Mail
    
    if (
        ([cellKey rangeOfString:@"MAIL" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
        ([cellValue rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString: @"@"]].location != NSNotFound)
        )
    {
      NSString *mailAdresse = [[NSString stringWithFormat:@"%@",cellValue]stringByReplacingOccurrencesOfString:@" " withString:@""];
      [self linkOeffnen:mailAdresse linkTyp:@"mailto://"];

    }
}
// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////


-(IBAction) okButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////


- (void) datenAnzeigen
{
    self->lblFirstName.text = [_selektierterMember valueForKey: @"first_name"];
    self.lblLastName.text = _selektierterMember[@"last_name"];
    self->lblBirthday.text = _selektierterMember[@"birthday"];
    _memberDetail=[_mainAppDelegate memberDetail:_selektierterMember[@"usr_id"]];

    int j=0;
    
    for (j=0;j<_memberDetail.count;j++)
    {
        NSString *cellKey = [[_memberDetail objectAtIndex:j] objectForKey:@"usf_name"];
        NSString *cellValue = [[_memberDetail objectAtIndex:j] objectForKey:@"usd_value"];
        
        if ( [cellKey isEqualToString:@"Geburtstag"])
            lblBirthday.text=cellValue;
        
    }
    
    // Bugfix Geburtstagslabel

    /*
    
*/
    
 }

@end
