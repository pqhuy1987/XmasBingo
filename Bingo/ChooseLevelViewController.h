//
//  ChooseLevelViewController.h
//  DotSpaceConqueror
//
//  Created by Aswathy  on 04/03/14.
//  Copyright (c) 2014 Cabot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"

@interface ChooseLevelViewController : UIViewController

- (IBAction)easyButtonAction:(UIButton *)sender;

- (IBAction)mediumButtonAction:(UIButton *)sender;

- (IBAction)hardButtonAction:(UIButton *)sender;

- (IBAction)veryHardButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *mainLevelBackground;

@property (weak, nonatomic) IBOutlet UILabel *chooseDifficultyLabel;

@property (weak, nonatomic) IBOutlet UIButton *easyBtn;
@property (weak, nonatomic) IBOutlet UIButton *mediumBtn;
@property (weak, nonatomic) IBOutlet UIButton *hardBtn;
@property (weak, nonatomic) IBOutlet UIButton *veryHard;

@property (weak, nonatomic) IBOutlet UIImageView *mediumLockedImage;

@property (weak, nonatomic) IBOutlet UIImageView *hardLockedImage;


@property (nonatomic, strong) NSString *chooseDifficulty;

@property (nonatomic, strong) NSString *toViewIdentifier;

@end
