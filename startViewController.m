//
//  startViewController.m
//  admidio
//
//  Created by Marc Ahlgrim on 20.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import "startViewController.h"
#import "listViewController.h"
#import "appmidioViewController.h"
#import "detailViewController.h"

@interface startViewController ()

@end

@implementation startViewController


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

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Marker : %@",@"enter viewDidAppear");

    // Versuche zu verbinden
    
    if (!_fromSetup)
        _mainAppDelegate.validlogin = [_mainAppDelegate establishInitialConnection];

    _fromSetup=NO;

    [ self statusAnzeigen];
    NSLog(@"Marker : %@",@"exit viewDidAppear");
    [_spinWheel stopAnimating];

}


- (void)viewDidLoad
{
    NSLog(@"Marker : %@",@"enter viewDidLoad");
    [_spinWheel startAnimating];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _fromSetup=NO;
    
    _mainAppDelegate  = [[UIApplication sharedApplication] delegate];
    _mainAppDelegate.startView=self;

    NSLog(@"Marker : %@",@"exit viewDidLoad");
}

// /////////////////////////////////////////////////////
//
// statusAnzeigen : zeige den Status des Login-
// versuches auf der Titelseite
//
// /////////////////////////////////////////////////////


-(void) statusAnzeigen
{
    NSLog(@"Marker : %@",@"enter StatusAnzeigen");
   
    if (_mainAppDelegate.validlogin)
    {
        t_Status.text = [NSString stringWithFormat:@"verbunden mit %@",_mainAppDelegate.admidioPreferences[@"org_longname"]] ;
        [t_Status setTextColor:[UIColor greenColor]];
        t_Status.font = [UIFont systemFontOfSize:20];
    } else
    {
        
        if (_mainAppDelegate.admidioPreferences)
        {
            t_Status.text = [NSString  stringWithFormat:@"Nicht angemeldet bei %@ - Username und Passwort prüfen.",_mainAppDelegate.admidioPreferences[@"org_longname"]];
            [t_Status setTextColor:[UIColor orangeColor]];
            t_Status.font = [UIFont systemFontOfSize:20];
        } else
        {

            t_Status.text = [NSString  stringWithFormat:@"Nicht verbunden. Bitte Einstellungen prüfen."];
            [t_Status setTextColor:[UIColor redColor]];
            t_Status.font = [UIFont systemFontOfSize:20];
        }
    }
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    NSLog(@"Marker : %@",@"exit StatusAnzeigen");
    
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
//
// /////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_spinWheel startAnimating];

    
    NSArray *Datenliste;
    
    #ifdef DEBUGFLAG
        NSLog(@"prepareForSegue: %@", segue.identifier);
    #endif
    
    // Zeige die Listenansicht
    
    if ([segue.identifier isEqualToString:@"sgeListe"])
    {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        
        Datenliste = [_mainAppDelegate listeRollen];

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        
        [ (listViewController *) segue.destinationViewController setMainAppDelegate:_mainAppDelegate ];
        [ (listViewController *) segue.destinationViewController setRollenListe:Datenliste ];
        [ (listViewController *) segue.destinationViewController setListenTyp:ROLLENLISTE ];
    
    }
    
    // Gehe zu den Einstellungen
    
    if ([segue.identifier isEqualToString:@"sgeSetup"])
    {
        [ (appmidioViewController *) segue.destinationViewController setMainAppDelegate:_mainAppDelegate ];
        _fromSetup=YES;

    }
    
    // Rufe die Detailseite des Profils auf
    
    if ([segue.identifier isEqualToString:@"sgeDetail"])
    {
        
       
        [ (detailViewController *) segue.destinationViewController setMainAppDelegate:_mainAppDelegate ];
        [ (detailViewController *) segue.destinationViewController setSelektierterMember:_mainAppDelegate.admidioPreferences] ;
    }
    
    if ([segue.identifier isEqualToString:@"sgeSearch"])
    {

        
        Datenliste = [_mainAppDelegate listeSuch:@"Marc"];
        [ (listViewController *) segue.destinationViewController setMainAppDelegate:_mainAppDelegate ];
        [ (listViewController *) segue.destinationViewController setListenTyp:SUCHLISTE ];
        [ (listViewController *) segue.destinationViewController setMemberListe:Datenliste ];
        
    }

    
}

@end
