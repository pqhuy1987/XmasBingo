//
//  ThemeSelectionViewController.h
//  Bingo
//
//  Created by feialoh on 08/01/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendsCell.h"
#import "ThemeModal.h"

@interface CustomThemeSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomCellViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *themeSelectionTable;

@property (retain, nonatomic) NSMutableDictionary *listSection;
//Dictionary to contain all group details
@property (retain, nonatomic) NSMutableArray *themeDetails;
@property (weak, nonatomic) IBOutlet UIImageView *themeBackground;

@property (strong, nonatomic) NSString *settingsType;

@property (strong, nonatomic) NSString *selectionMode;

@end
