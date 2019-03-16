//
//  appmidioAppDelegate.h
//  admidio
//
//  Created by Marc Ahlgrim on 15.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>

// ////////////////////////////////////
// ////////////////////////////////////
//
// Präprozessor Konstanten
//
// ////////////////////////////////////
// ////////////////////////////////////

//#define DEBUGFLAG

#define LOGOUTURLPART   @"/adm_program/system/logout.php"
#define LOGINURLPART    @"/adm_program/system/login_check.php"
#define APPMIDIOURLPART @"/adm_plugins/appmidio/appmidio.php"


// ////////////////////////////////////
// ////////////////////////////////////
//
// Die Applikationsklasse
//
// ////////////////////////////////////
// ////////////////////////////////////


@interface appmidioAppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL *Bconnected;
}

@property (strong, nonatomic) UIWindow *window;


@property NSString *admidioUser;
@property NSString *admidioPass;
@property NSString *admidioURL;
@property BOOL validlogin;
@property id startView;


@property NSDictionary *admidioPreferences;
@property NSArray *aktuelleListe;

-(BOOL) establishInitialConnection;
-(BOOL) establishConnection:(NSString *) t_URL withUser: (NSString *) t_user andPass:(NSString *) t_pass;
-(BOOL) readPreferences:(NSData *) rawJSONString;
-(NSArray *) listeRollen;
-(NSArray *) listeMember:(NSString *) rollenID;
-(NSArray *) listeSuch:(NSString *) suchKriterium;
-(NSData *) sendeKommando:(NSDictionary *) kommando;
-(NSDictionary *) data2JSON:(NSData *) rawJSONString;
-(NSArray *) data2JSONArray:(NSData *) rawJSONString;
-(NSArray *) memberDetail:(NSString *) memberID;



@end
