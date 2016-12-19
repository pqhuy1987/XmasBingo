//
//  MainGameViewController.h
//  Bingo
//
//  Created by feialoh on 05/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FinalScoreView.h"
#import "PopUpView.h"
#import "Entity.h"
#import "ScoreAlertPopUpView.h"
#import "GCTurnBasedMatchHelper.h"
#import "GameCenterManager.h"
//#import <iAd/iAd.h>
@import GoogleMobileAds;
@interface MainGameViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate,finalPopViewDelegate,popViewDelegate,scoreViewDelegate,GADInterstitialDelegate,GCTurnBasedMatchHelperDelegate,GameCenterManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) NSString *gameType;

@property (strong, nonatomic) NSString *difficultyLevel;

@property (weak, nonatomic) IBOutlet UIImageView *mainGameBackground;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
