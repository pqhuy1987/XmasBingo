//
//  AppDelegate.h
//  Bingo
//
//  Created by feialoh on 18/11/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCHandler.h"
#import "GameCenterManager.h"
//#import <iAd/iAd.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MPCHandler *mpcHandler;

@property (strong, nonatomic) UIActivityIndicatorView  * generalIndicator;
@property (strong, nonatomic) UIAlertView *genAlert;

- (void)showIndicator:(NSString *) title;

- (void)hideIndicator;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
