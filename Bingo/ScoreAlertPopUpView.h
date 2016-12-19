//
//  ScoreAlertPopUpView.h
//  Bingo
//
//  Created by feialoh on 29/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"
#import "PopUpView.h"

@protocol scoreViewDelegate<NSObject>

@optional

-(void) keepGoingButtonPressed:(UIButton *)popView;

-(void) quitButtonPressed:(UIButton *)popView;

-(void) saveButtonPressed:(UIButton *)popView;
-(void) shareButtonPressed:(UIButton *)popView;
-(void) submitScorePressed:(UIButton *)popView;

@end


@interface ScoreAlertPopUpView : UIView<popViewDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) id <scoreViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIView *popView;


@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;

@property (weak, nonatomic) IBOutlet UITextView *youWonTextView;


@property (weak, nonatomic) IBOutlet UILabel *yourScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *winStreakLabel;

@property (weak, nonatomic) IBOutlet UILabel *streakLabel;

@property (weak, nonatomic) IBOutlet UIButton *keepGoingBtnLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareBtnLabel;

@property (weak, nonatomic) IBOutlet UIButton *quitBtnLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveBtnLabel;


- (IBAction)keepGoingAction:(UIButton *)sender;

- (IBAction)shareAction:(UIButton *)sender;

- (IBAction)quitAction:(UIButton *)sender;

- (IBAction)saveAction:(UIButton *)sender;


- (IBAction)submitScoreAction:(UIButton *)sender;

- (IBAction)showCPUGridAction:(UIButton *)sender;

- (IBAction)showPlayerGridAction:(UIButton *)sender;


- (IBAction)closeButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIButton *showCPUGrid;
@property (weak, nonatomic) IBOutlet UIButton *showPlayerGrid;


-(id)initWithdelegate:(id)parent HasPlayerWon:(BOOL)winStatus isHighScore:(BOOL)highScoreStatus PlayerScore:(NSString *)playerScore WinStreak:(NSString *)winStreak PlayerGrid:(UIView *)playerGrid CPUGrid:(UIView *)cpuGrid;

-(void)show;

@end
