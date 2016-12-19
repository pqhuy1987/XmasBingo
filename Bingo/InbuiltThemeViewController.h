//
//  InbuiltThemeViewController.h
//  Bingo
//
//  Created by feialoh on 28/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendsCell.h"
#import "ThemeModal.h"
#import "BuiltInThemeModal.h"

@interface InbuiltThemeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomCellViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainThemeTable;

@property (weak, nonatomic) IBOutlet UIImageView *themeBackgroundView;


//Array to contain table details for display on table
@property (retain, nonatomic) NSMutableArray *themeTableDetails;

@end
