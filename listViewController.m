//
//  listViewController.m
//  admidio
//
//  Created by Marc Ahlgrim on 20.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import "listViewController.h"

@interface listViewController ()

@end

@implementation listViewController






// ////////////////////////////////////////////////////////////////
//
// Der "Kontakt" Button wurde geklickt
// Mail oder SMS an ganze Liste senden ?
//
// ////////////////////////////////////////////////////////////////



-(IBAction)kontaktButtonClicked:(id)sender
{

    if (_listenTyp != MEMBERLISTE) return;
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Liste kontaktieren (kann etwas dauern)"
                                                             delegate:self
                                                    cancelButtonTitle:@"Abbruch"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"SMS an Liste",@"Mail an Liste", nil];
    
    [actionsheet showInView:self.view];
    
    

    #ifdef DEBUGFLAG
      NSLog(@"Button clicked%@",@"Kontakt" );
    #endif

}


// ////////////////////////////////////////////////////////////////
//
// Mail / SMS / Abbruch wurde ausgewählt
// Mail oder SMS an ganze Liste senden ?
//
// ////////////////////////////////////////////////////////////////



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if ((buttonIndex != 0) && (buttonIndex !=1 )) return;
    
    if (buttonIndex==0)
        if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ihr Gerät unterstützt SMS nicht" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }

    if (buttonIndex==1)
        if(![MFMailComposeViewController canSendMail]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Ihr Gerät unterstützt Mail nicht" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
    
    NSMutableArray *recipients =nil;
    NSString *body = @"mit iAppmidio gesendet";
    
    for (NSDictionary *einMitglied in _memberListe)
    {
        NSArray *mitgliederDaten=[_mainAppDelegate memberDetail:einMitglied[@"usr_id"]];
        for (NSDictionary *einElement in mitgliederDaten)
        {
            NSString *cellKey = [einElement objectForKey:@"usf_name_intern"];
            NSString *cellValue = nil;
    

            if (buttonIndex ==0) // SMS
            {
                if (
                    ([cellKey rangeOfString:@"MOBILE" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                    ([cellKey rangeOfString:@"NATEL" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                    ([cellKey rangeOfString:@"GSM" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                    ([cellKey rangeOfString:@"HANDY" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    
                    )
                    cellValue = [einElement objectForKey:@"usd_value"];
            }
            if (buttonIndex ==1) // Mail
            {
                if ( ([cellKey rangeOfString:@"EMAIL" options:NSCaseInsensitiveSearch].location != NSNotFound)   )
                    cellValue = [einElement objectForKey:@"usd_value"];
            }

            if (cellValue)
            {
//                NSLog(@"Cell Key %@ Cell Value %@ ",cellKey,cellValue );
                if (recipients != nil)
                    [recipients insertObject:cellValue atIndex:0 ];
                else
                    recipients = [NSMutableArray arrayWithObjects:cellValue, nil];
            }
        }
    }

    if (buttonIndex ==0) // SMS
    {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipients];
        [messageController setBody:body];
        [self presentViewController:messageController animated:YES completion:nil];
    }
    if (buttonIndex ==1) // Mail
    {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
        [composer setMessageBody:body isHTML:NO];
        [composer setToRecipients:recipients];
        composer.mailComposeDelegate = self;
        [self presentViewController:composer animated:YES completion:NULL];
    }
    
  
}


// ////////////////////////////////////////////////////////////////
//
// Mailcomposer wurde beendet
//
// ////////////////////////////////////////////////////////////////


#pragma mark - MFMailComposeViewControllerDelegate methods
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled"); break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved"); break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent"); break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]); break;
        default:
            break;
    }
    
    // close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// ////////////////////////////////////////////////////////////////
//
// Messagecomposer wurde beendet
//
// ////////////////////////////////////////////////////////////////


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    
    UIAlertView *warningAlert;
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// /////////////////////////////////////////////////////
// Little helper : getString
// /////////////////////////////////////////////////////

NSString *_getString(id obj)
{
    return [obj isKindOfClass:[NSString class]] ? obj : nil;
}



// /////////////////////////////////////////////////////
// /////////////////////////////////////////////////////
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
// /////////////////////////////////////////////////////
//
- (void)viewDidLoad
//
// /////////////////////////////////////////////////////
// /////////////////////////////////////////////////////

{
    [super viewDidLoad];
    
    #ifdef DEBUGFLAG
        if (_memberListe) NSLog(@"Memberliste OK");
        if (_rollenListe) NSLog(@"Rollenliste OK");
        NSLog(@"Listentyp %li", (long)_listenTyp);
    #endif
    self.edgesForExtendedLayout=UIRectEdgeAll;

    switch (_listenTyp)
    {
        case ROLLENLISTE :
            self.title=@"Rollen";
            break;
        case MEMBERLISTE :
            self.title=[_selektierteRolle objectForKey:@"rol_name"];
            //@"Mitglieder";
            break;
        case SUCHLISTE :
            self.title=@"Suchergebnis";
            break;
    }
}



// /////////////////////////////////////////////////////
//
// numberOfRowsInSection gibt die Anzahl der Zeilen in der
// Section zurück
//
// /////////////////////////////////////////////////////


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (_listenTyp)
    {
        case SUCHLISTE :
        {
            return [_memberListe count];
            break;
        }
        default:
        {
            if (_sectionKeysAndCounts==nil) [self makeSectionKeysAndCounts];
            NSDictionary *Position = _sectionKeysAndCounts[section];
            NSString *temp =  [Position valueForKey:@"count"];
            return temp.integerValue;
            break;
        }
    }
//    return 0;
}


// /////////////////////////////////////////////////////
//
// makeSectionKeysAndCounts erzeugt den NSArray
// sectionKeysAndCounts, der seinerseits NSDictionary
// mit den Schlüsseln key, count, title enthält.
// key ist die rol_id in der Rollenliste,
// count ist die Anzahl der Elemente in dieser Kategorie
// und title ist der Name der Kategorie.
//
// /////////////////////////////////////////////////////


- (void) makeSectionKeysAndCounts
{
    int i=0,j=0;
    NSString *oldValue = nil;
    NSString *oldTitle = nil;
    NSString *newValue = nil;
    NSDictionary *einElement =nil;
    NSDictionary *einSchluessel = nil;
    
    
    NSArray *dieListe;
    

    if  (_listenTyp == ROLLENLISTE )
        dieListe = _rollenListe;
    else
        dieListe = _memberListe;
    
    
    for (i=0 ; i<=dieListe.count ; i++)
    {
        if (i<dieListe.count)
        {
            einElement = dieListe[i];

            switch (_listenTyp)
            {
                case ROLLENLISTE :
                    newValue = [einElement valueForKey:@"cat_id"];
                    break;
                case MEMBERLISTE :
                    newValue = [einElement valueForKey:@"mem_leader"];
                    break;
                case SUCHLISTE :
                    newValue = @"0";
                    break;
            }

        }
        else
            newValue=[NSString stringWithFormat:@"THIsIS%@DIFFERENT",oldValue];

        
        if ([newValue isEqualToString:oldValue])
            j++;

        else
        {
            if (oldValue != nil)
            {

                einSchluessel = [NSDictionary dictionaryWithObjectsAndKeys:
                                    oldValue,@"key",
                                    [NSString stringWithFormat:@"%i",j],@"count",
                                    oldTitle,@"title",
                                    nil ];
                if (_sectionKeysAndCounts)
                    [_sectionKeysAndCounts addObject:einSchluessel];
                else
                    _sectionKeysAndCounts = [NSMutableArray arrayWithObject:einSchluessel];
            }
            j=1;
        }
    
        oldValue = newValue ;

        
        switch (_listenTyp)
        {
            case ROLLENLISTE :
                oldTitle = [einElement valueForKey:@"cat_name"];
                break;
            case MEMBERLISTE :
                if ( [(NSString *) [einElement valueForKey:@"mem_leader"] isEqualToString:@"1"])
                    oldTitle = @"Leiter";
                else
                    oldTitle=@"Mitglieder";
                break;
            case SUCHLISTE :
                oldTitle = @"Suchergebnis";
                break;
        }

        
    }
    
}


// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //if  (_listenTyp == ROLLENLISTE )
    //{
        if (_sectionKeysAndCounts==nil) [self makeSectionKeysAndCounts];
        return _sectionKeysAndCounts.count;
    //}
    //return 1;
}

// /////////////////////////////////////////////////////
//
//
// /////////////////////////////////////////////////////


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
 //   if  (_listenTyp == ROLLENLISTE )
 //   {
        if (_sectionKeysAndCounts==nil) [self makeSectionKeysAndCounts];
        NSDictionary *derSchluessel = _sectionKeysAndCounts[section];
        return [derSchluessel objectForKey:@"title" ];
 //   }

    
    
 //   return [_selektierteRolle valueForKey:@"rol_name"];
}


// /////////////////////////////////////////////////////
//
// cellForRowAtIndexPath gibt den Inhalt einer Zelle
// abhängig vom IndexPath aus.
//
// /////////////////////////////////////////////////////


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    
    int i=0,j=0;
    
    
    switch (_listenTyp)
    {
        case ROLLENLISTE :

            cell = [tableView dequeueReusableCellWithIdentifier:@"roleCell"];
            
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"roleCell"];
            

 
            j=0;
            for (i=0 ; i< indexPath.section ; i++)
                j += [[_sectionKeysAndCounts[i] valueForKey:@"count"] integerValue];
            
            cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)",
                                 _getString([[_rollenListe objectAtIndex:j+indexPath.row] objectForKey:@"rol_name"]),
                                 _getString([[_rollenListe objectAtIndex:j+indexPath.row] objectForKey:@"mem_count"])];
                                 
            cell.detailTextLabel.text = _getString([[_rollenListe objectAtIndex:j+indexPath.row] objectForKey:@"rol_description"]);
            break;
            
        default:
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
            
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"memberCell"];
            }

            j=0;
            for (i=0 ; i< indexPath.section ; i++)
                j += [[_sectionKeysAndCounts[i] valueForKey:@"count"] integerValue];
           
            cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",
                                            _getString([[_memberListe objectAtIndex:j+indexPath.row] objectForKey:@"first_name"]),
                                 _getString([[_memberListe objectAtIndex:j+indexPath.row] objectForKey:@"last_name"])];
            cell.detailTextLabel.text = _getString([[_memberListe objectAtIndex:j+indexPath.row] objectForKey:@"birthday"]);
            //cell.detailTextLabel.text = ;
            break;
    }
    return cell;
}


// /////////////////////////////////////////////////////
//
// didSelectRowAtIndexPath : Was passiert wenn eine Zelle
// ausgewählt wurde ?
// ROLLENLISTE : Zeige Memberliste
// MEMBERLISTE : Zeige Detail View
//
// /////////////////////////////////////////////////////


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_listenTyp)
    {

        int i=0,j=0;

        case ROLLENLISTE :
        {
            j=0;
            for (i=0 ; i< indexPath.section ; i++)
                j += [[_sectionKeysAndCounts[i] valueForKey:@"count"] integerValue];
            _selektierteRolle = [_rollenListe objectAtIndex:j+indexPath.row];
            [self performSegueWithIdentifier:@"sgeMemberListe" sender:self];
            break;
        }

        default:
            j=0;
            for (i=0 ; i< indexPath.section ; i++)
                j += [[_sectionKeysAndCounts[i] valueForKey:@"count"] integerValue];
            _selektierterMember = _memberListe[j+indexPath.row];
            [self performSegueWithIdentifier:@"sgeListDetail" sender:self];
            break;

    }
}

// /////////////////////////////////////////////////////
//
// prepareForSegue setzt die Parameter der Destination View
//
// /////////////////////////////////////////////////////



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    
    if ([segue.identifier isEqualToString:@"sgeListDetail"])
    {
        #ifdef DEBUGFLAG
            NSLog(@"[%s] [%d]", __PRETTY_FUNCTION__, __LINE__);
        #endif
        [ (detailViewController *) segue.destinationViewController setMainAppDelegate:_mainAppDelegate ];
        [ (detailViewController *) segue.destinationViewController setSelektierterMember:_selektierterMember] ;
    }
    
    if ([segue.identifier isEqualToString:@"sgeMemberListe"])

    {
        
        #ifdef DEBUGFLAG
            NSLog(@"[%s] [%d]", __PRETTY_FUNCTION__, __LINE__);
        #endif
        [ (listViewController *) segue.destinationViewController setMainAppDelegate:_mainAppDelegate ];
        [ (listViewController *) segue.destinationViewController setListenTyp:MEMBERLISTE ];
        _memberListe = [_mainAppDelegate listeMember:_selektierteRolle[@"rol_id"]];
        [ (listViewController *) segue.destinationViewController setRollenListe:_rollenListe ];
        [ (listViewController *) segue.destinationViewController setMemberListe:_memberListe ];
        [ (listViewController *) segue.destinationViewController setSelektierteRolle:_selektierteRolle];
//        [ (listViewController *) segue.destinationViewController setTitle:@"XXX"];
        
    }
}

// ///////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
