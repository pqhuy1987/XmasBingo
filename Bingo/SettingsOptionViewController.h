//
//  SettingsOptionViewController.h
//  Bingo
//
//  Created by feialoh on 12/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"


@interface SettingsOptionViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *changeViewBackground;

@property (weak, nonatomic) IBOutlet UITableView *settingsOptionTable;


@property (strong, nonatomic) NSString *selectionType;

//Array to contain table details for display on table
@property (retain, nonatomic) NSMutableArray *tableDetails;

@end
