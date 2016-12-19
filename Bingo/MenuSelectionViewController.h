//
//  MenuSelectionViewController.h
//  Bingo
//
//  Created by feialoh on 11/12/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTurnBasedMatchHelper.h"
#import "GameCenterManager.h"

@interface MenuSelectionViewController : UIViewController<GameCenterManagerDelegate>

- (IBAction)singlePlayerAction:(UIButton *)sender;

- (IBAction)settingsButtonAction:(UIButton *)sender;

- (IBAction)multiplayerAction:(UIButton *)sender;

- (IBAction)highScoreAction:(UIButton *)sender;

- (IBAction)helpAction:(UIButton *)sender;

- (IBAction)gameCenterAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *highScoreBtn;

@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@property (weak, nonatomic) IBOutlet UIButton *gameCenterBtn;

@property (weak, nonatomic) IBOutlet UIImageView *mainMenuBackground;

@property (weak, nonatomic) IBOutlet UIButton *singlePlayerBtn;

@property (weak, nonatomic) IBOutlet UIButton *multiplayerBtn;

@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;


@end
