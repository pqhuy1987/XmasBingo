//
//  HighScoreViewController.h
//  Bingo
//
//  Created by feialoh on 29/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Entity.h"
//#import <iAd/iAd.h>
@import GoogleMobileAds;
@interface HighScoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@property (weak, nonatomic) IBOutlet UIImageView *highscoreBackground;

@property (weak, nonatomic) IBOutlet UITableView *highScoreTable;


@property(nonatomic,strong) NSMutableArray *highScoreDetailsArray;

@property (strong, nonatomic) NSString *gameType;

@property (strong, nonatomic) NSString *difficultyLevel;

@property (weak, nonatomic) IBOutlet UIButton *clearData;

@property (weak, nonatomic) IBOutlet UIView *topLabelView;


//- (IBAction)clearDataAction:(UIButton *)sender;

@end
