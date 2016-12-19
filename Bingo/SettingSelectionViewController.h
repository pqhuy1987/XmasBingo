//
//  SettingSelectionViewController.h
//  Bingo
//
//  Created by feialoh on 28/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"

@interface SettingSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingSelectTable;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;


//Array to contain table details for display on table
@property (retain, nonatomic) NSMutableArray *settingTableDetails;

@end
