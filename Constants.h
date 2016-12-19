//
//  Constants.h
//  Bingo
//
//  Created by feialoh on 08/01/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#ifndef CONSTANTS_H
#define CONSTANTS_H

//device identifier macros
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)?TRUE:FALSE
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)

//System Versioning Preprocessor Macros

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//Ad Info

#define BANNER_AD_ID                           @"ca-app-pub-5090472565759639/6697346701"
#define INTERSTITIAL_AD_ID                     @"ca-app-pub-5090472565759639/8174079909"

#define BANNER_AD_ID_TEST                           @"ca-app-pub-8378134183480520/3838050511"
#define INTERSTITIAL_AD_ID_TEST                     @"ca-app-pub-8378134183480520/5314783717"


//Button constants
#pragma mark - STRING CONSTANTS

#define GAME_FONT                           @"gameFont"

#define GAME_FONT_COLOR                     @"gameFontColor"

#define BINGO_FONT_COLOR                    @"bingoFontColor"

#define MAIN_BACKGROUND                     @"mainBackground"

#define INITIAL_BUTTON_BACKGROUND           @"initialButtonBg"

#define SELECTED_BUTTON_BACKGROUND          @"selectedButtonBg"

#define MULTIPLE_BUTTON_BACKGROUND          @"multipleButtonBg"

#define THEME_TYPE                          @"themeType"

#define INITIAL_BUTTON_TITLE_COLOR          @"initialButtonTitle"

#define SELECTED_BUTTON_TITLE_COLOR         @"selectedButtonTitle"

#define MULTIPLE_BUTTON_TITLE_COLOR         @"multipleButtonTitle"

#define PLAYER_NAME                         @"playerDeviceName"

#define LOCKED_STATUS                       @"lockedStatus"

#define STRING_CONSTANT_OK @"OK"

#define STRING_CONSTANT_DISMISS @"Dismiss"

#define INDEX_SHOW_LIMIT 50

// UIAlertView MACROS
#define showAlert(title, msg, button, buttons...) {UIAlertView *__alert =[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:button otherButtonTitles:buttons];[__alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];}

#endif