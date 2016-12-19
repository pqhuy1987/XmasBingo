//
//  ChangeSettingsViewController.h
//  Bingo
//
//  Created by feialoh on 11/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"

@interface ChangeSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *changeSettingsBackground;

@property (weak, nonatomic) IBOutlet UITableView *settingsTable;

//Array to contain table details for display on table
@property (retain, nonatomic) NSMutableArray *tableDetails;

@end
