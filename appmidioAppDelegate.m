//
//  appmidioAppDelegate.m
//  admidio
//
//  Created by Marc Ahlgrim on 15.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import "appmidioAppDelegate.h"
#import "startViewController.h"

@implementation appmidioAppDelegate


// /////////////////////////////////////////////////////
//
// Initiale Aufgaben
//
// /////////////////////////////////////////////////////

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    
    NSLog(@"Marker : %@",@"entering didfinishLaunchingwithOption");

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // versuche einen Login mit den gespeicherten Parametern
    _validlogin=NO;
    NSLog(@"Marker : %@",@"exit didfinishLaunchingwithOption");
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// ///////////////////////////////////////////////
// data2JSONArray versucht, von einer URL gesendete
// (hoffentlich) JSON Daten in ein
// NSArray umzuwandeln
// ///////////////////////////////////////////////


-(NSArray *) data2JSONArray:(NSData *) rawJSONString
{
    if (rawJSONString)
        
    {
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: rawJSONString options :NSJSONReadingMutableContainers error: &e];
        
        if (!jsonArray)
        {
            #ifdef DEBUGFLAG
                NSLog(@"Error parsing JSON: %@", e);
            #endif
            return nil;
        } else
        {
            return jsonArray;
        }
    }
    return nil; // falls irgendwas schieflief...
}


// ///////////////////////////////////////////////
// data2JSON versucht, von einer URL gesendete
// (hoffentlich) JSON Daten in ein
// NSDictionary umzuwandeln
// ///////////////////////////////////////////////


-(NSDictionary *) data2JSON:(NSData *) rawJSONString
{
    if (rawJSONString)
    {
        NSArray *jsonArray = [self data2JSONArray:rawJSONString];
        if (!jsonArray)
        {
            #ifdef DEBUGFLAG
                NSLog(@"Error parsing JSONARRAY");
            #endif
            return nil;
        } else
        {
            for(NSDictionary *item in jsonArray)
            {
                return item; // ist jetzt nicht ganz sauber, wir erwarten aber nur ein Element...
            }
        }
    }
    return nil; // falls irgendwas schieflief...
}


// ///////////////////////////////////////////////
//
// sendeKommando ruft die Appmidio Seite
// mit einem bestimmten Kommando auf.
//
// ///////////////////////////////////////////////

-(NSData *) sendeKommando:(NSDictionary *) kommando{

    if (kommando == nil) return nil;

   // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    NSURL *app_url    = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _admidioURL, APPMIDIOURLPART]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[app_url standardizedURL]];
    
    
    NSString *requestFields = [NSString stringWithFormat:@""];
    int i=0;
    
    for (id derSchluessel in kommando)
    {
        id derWert=kommando[derSchluessel];
    
        if (i>0)
            requestFields = [requestFields stringByAppendingFormat:@"&%@=%@", derSchluessel,derWert];
        else
            requestFields = [requestFields stringByAppendingFormat:@"%@=%@", derSchluessel,derWert];
        i++;
    }
    requestFields = [requestFields stringByAppendingFormat:@"&%@=%@", @"org_id",_admidioPreferences[@"org_id"]];
    
    requestFields = [requestFields stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *requestData = [requestFields dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestData;
    request.HTTPMethod = @"POST";
    NSURLResponse *response=nil;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];

    
    /*
    if (responseData == nil) {
        // Check for problems
        if (err != nil) {

            NSString *Errormessage = [NSString stringWithFormat:@"Fehler : %@ %@", [err localizedDescription], [err localizedFailureReason]];
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:Errormessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
    }
    else {
        // Data was received.. continue processing
    }
    
     
     */
     
     
    if (responseData == nil ) { return nil; };
    #ifdef DEBUGFLAG
        NSString *sdata=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseData: %@",sdata);
    #endif
    
    return responseData;
    
}


// ///////////////////////////////////////////////
//
// listeRollen gibt ein NSArray
// mit den existierenden Rollen aus.
//
// ///////////////////////////////////////////////


-(NSArray *) listeRollen{

    NSData *responseData = [self sendeKommando: [NSDictionary dictionaryWithObjectsAndKeys:@"gr",@"cmd", nil]];

    if (responseData == nil) return nil;

    NSArray *xListe = [self data2JSONArray:responseData];
    
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    
    return xListe;
}

// ///////////////////////////////////////////////
//
// listeMember gibt ein NSArray
// mit den Mitgliedern zu einer
// gegebenen Rolle aus.
//
// ///////////////////////////////////////////////


-(NSArray *) listeMember:(NSString *) rollenID{

    NSData *responseData = [self sendeKommando:[NSDictionary dictionaryWithObjectsAndKeys:@"gm",@"cmd",rollenID,@"rol_id",nil]];
    
    if (responseData == nil) return nil;
    
    NSArray *xListe = [self data2JSONArray:responseData];


    NSMutableArray *xListe2 = (NSMutableArray *)xListe;
    
    [xListe2 sortUsingDescriptors:
     [NSArray arrayWithObjects:
      [NSSortDescriptor sortDescriptorWithKey:@"mem_leader" ascending:NO],
      [NSSortDescriptor sortDescriptorWithKey:@"last_name" ascending:YES],
      nil]];

    return (NSArray *)xListe2;

}


// ///////////////////////////////////////////////
//
// listeMember gibt ein NSArray
// mit den Mitgliedern zu einer
// gegebenen Rolle aus.
//
// ///////////////////////////////////////////////


-(NSArray *) listeSuch:(NSString *) suchKriterium{
    
    NSData *responseData = [self sendeKommando:[NSDictionary dictionaryWithObjectsAndKeys:@"gm",@"cmd",@"1 or mem_rol_id<9999",@"rol_id",nil]];
    
    if (responseData == nil) return nil;
    
    NSArray *xListe = [self data2JSONArray:responseData];
    
    
    NSMutableArray *xListe2 = (NSMutableArray *)xListe;
    
    [xListe2 sortUsingDescriptors:
     [NSArray arrayWithObjects:
      [NSSortDescriptor sortDescriptorWithKey:@"last_name" ascending:YES],
      nil]];
    
    return (NSArray *)xListe2;
    
}


// ///////////////////////////////////////////////
//
// listeMember gibt ein NSArray
// mit den Mitgliedern zu einer
// gegebenen Rolle aus.
//
// ///////////////////////////////////////////////


-(NSArray *) memberDetail:(NSString *) memberID{

    NSData *responseData = [self sendeKommando:[NSDictionary dictionaryWithObjectsAndKeys:@"gmd",@"cmd",memberID,@"usr_id",nil]];
    
    if (responseData == nil) return nil;
    
    NSArray *xListe = [self data2JSONArray:responseData];
    
    
    
    
    return xListe;
}


// ///////////////////////////////////////////////
//
// establishInitialConnection führt die initiale
// Verbindung zur Appmidio Seite aus.
//
// ///////////////////////////////////////////////


-(BOOL) establishInitialConnection{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [self setAdmidioUser:[prefs stringForKey:@"userName"]];
    [self setAdmidioPass:[prefs stringForKey:@"password"]];
    [self setAdmidioURL:[prefs stringForKey:@"URL"]];
 
    
    BOOL erfolg = [self establishConnection: _admidioURL withUser:_admidioUser andPass:_admidioPass];

 //   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    return erfolg;
}

// ///////////////////////////////////////////////
// establishConnection führt die
// Verbindung zur Appmidio Seite aus.
// ///////////////////////////////////////////////


-(BOOL) establishConnection:(NSString *) t_URL withUser: (NSString *) t_user andPass:(NSString *) t_pass{
    

//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    _validlogin=NO;
   
    //initialize url that is going to be fetched.
    
    NSURL *logout_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", t_URL, LOGOUTURLPART    ]];
    NSURL *login_url  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", t_URL, LOGINURLPART     ]];
    NSURLResponse *response;
    NSError *err;
    NSData *postData, *responseData;
    NSString *postString;
    
    // We want to make sure we are not logged in as the wrong user, so let's log out first
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[logout_url standardizedURL]];
    [request setHTTPMethod:@"GET"];
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];

    /*
     
    if (responseData == nil) {
        // Check for problems
        if (err != nil) {
            
            NSString *Errormessage = [NSString stringWithFormat:@"Fehler : %@ %@", [err localizedDescription], [err localizedFailureReason]];
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:Errormessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
    }

    */
    
    
    if (responseData == nil ) { return NO; };
    
    // now let's send the login data
    
    [request setURL:[login_url standardizedURL]];
    postString = [NSString stringWithFormat:@"plg_usr_login_name=%@&plg_usr_password=%@", t_user , t_pass];
    postData = [[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod=@"POST";
    request.HTTPBody=postData;
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];

    if (responseData == nil ) { return NO; };

    [self setAdmidioUser:t_user];
    [self setAdmidioPass:t_pass];
    [self setAdmidioURL:t_URL];

    responseData = [self sendeKommando: [NSDictionary dictionaryWithObjectsAndKeys:@"gp",@"cmd", nil]];
    if ( [self readPreferences:responseData] )
    {
        NSString *s =  [ _admidioPreferences valueForKey:@"valid_login"];
#ifdef DEBUGFLAG
        NSLog(@"LoginKey: %@",s);
#endif

 if ((_validlogin = (s.intValue == 1)))
            if (_startView)
                [_startView statusAnzeigen];

    }

    // Auto Save Preferences
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:t_user forKey:@"userName"];
    [defaults setObject:t_pass forKey:@"password"];
    [defaults setObject:t_URL forKey:@"URL"];
    [defaults synchronize];

    
    if (_validlogin) return YES;
    

 if (_startView)
        [_startView statusAnzeigen];

    
    return NO;
};

// /////////////////////////////////////////////////////
//
// read preference record from JSON Data
// This subroutine does no checking of the CONTENT of the JSON, just checks IF there is JSON data.
//
// /////////////////////////////////////////////////////



-(BOOL) readPreferences:(NSData *) rawJSONString{

    NSDictionary *item = [self data2JSON:rawJSONString];
    if (item==nil)
    {
        return NO;
    }
    else
    {
      [self setAdmidioPreferences:item];
      return YES;
    }
};

@end
