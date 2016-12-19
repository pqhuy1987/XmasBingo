//
//  ScoreAlertPopUpView.m
//  Bingo
//
//  Created by feialoh on 29/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "ScoreAlertPopUpView.h"


@interface ScoreAlertPopUpView ()
{
    ThemeModal *theme;
    UIView *player,*Cpu;
    CGRect selfFrame;
    UIColor *selfBack;
    
}

@end

@implementation ScoreAlertPopUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithdelegate:(id)parent HasPlayerWon:(BOOL)winStatus isHighScore:(BOOL)highScoreStatus PlayerScore:(NSString *)playerScore WinStreak:(NSString *)winStreak PlayerGrid:(UIView *)playerGrid CPUGrid:(UIView *)cpuGrid
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 300, 300)])
    {
        // Initialization code
        self=(ScoreAlertPopUpView*)[[[NSBundle mainBundle] loadNibNamed:@"ScoreAlertPopUpView" owner:nil options:nil] lastObject] ;
        
        self.delegate=parent;
        [((UIViewController*)parent).view addSubview:self];
        self.hidden=YES;

        
        theme=[[ThemeModal alloc]init];
        [theme setTheme:nil];
        
        _scrollView.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height+50);
        
        NSLog(@"Scrollheight:%f, scrollcontentheight:%f",_scrollView.frame.size.height,_scrollView.contentSize.height);
        
//        _scrollView.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
//        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, 1000);
        
        player=[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:playerGrid]];
        Cpu=[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cpuGrid]];
        
        if (winStatus)
        {
            [self setBackgroundColor:[UIColor greenColor]];
            if (highScoreStatus)
            {
                _gameOverLabel.text=@"Congratulation!!!";
                
                _youWonTextView.text=@"You have Won & got a new highscore.";
                
                
                [_gameOverLabel setTextColor:[UIColor orangeColor]];
                
                [_scoreLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f
                                                          green:139.0f/255.0f
                                                           blue:0.0f/255.0f
                                                          alpha:1.0f]];
                
            }
            else
            {
                _saveBtnLabel.hidden=YES;
                
                _gameOverLabel.text=@"BINGO!!!";
                
                _youWonTextView.text=@"You have Won.";
                
            }
            
        }
        else
        {
            [self setBackgroundColor:[UIColor redColor]];
            
            [_keepGoingBtnLabel setTitle:@"Try again" forState:UIControlStateSelected & UIControlStateNormal ];
            
            _saveBtnLabel.hidden=YES;
        }
        
        _scoreLabel.text=playerScore;
        
        _streakLabel.text=winStreak;
        
        
    }
    return self;
}

-(void)show
{
    self.hidden=NO;
//    [self.popView setTransform:CGAffineTransformMakeScale(0.1,0.1)];
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         [self.popView setTransform:CGAffineTransformMakeScale(1.0,1.0)];
//                     }
//                     completion:nil
//     ];
    
    self.popView.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelegate:self];
    self.popView.alpha = 1;
    [self setBackgroundColor:[UIColor whiteColor]];
    [UIView commitAnimations];

}


-(void)hide
{
    self.hidden=YES;
    [self removeFromSuperview];
}

- (IBAction)keepGoingAction:(UIButton *)sender
{
    
    [self.delegate keepGoingButtonPressed:sender];
    [self hide];
    
}

- (IBAction)shareAction:(UIButton *)sender
{
    [self.delegate shareButtonPressed:sender];
//    [self hide];
}

- (IBAction)quitAction:(UIButton *)sender
{
    
    [self.delegate quitButtonPressed:sender];
    
    [self hide];

}


- (IBAction)saveAction:(UIButton *)sender
{
     [self.delegate saveButtonPressed:sender];
    _saveBtnLabel.hidden=YES;
//     [self hide];
}

- (IBAction)submitScoreAction:(UIButton *)sender
{
    [self.delegate submitScorePressed:sender];
    //    [self hide];
}


- (IBAction)showCPUGridAction:(UIButton *)sender
{
    PopUpView *popUp=[[PopUpView alloc]initWithdelegate:self.delegate WithFrame:Cpu.frame WithTitle:@"" WithTitleSize:0 WithMessage:@"" WithMessageSize:0 AndView:Cpu];
    
    [popUp show];
}

- (IBAction)showPlayerGridAction:(UIButton *)sender
{
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"CloseButtonType1.png"] forState:UIControlStateNormal & UIControlStateSelected];
    
    _closeButton.frame=CGRectMake((_popView.frame.size.width-_closeButton.frame.size.width), 0, _closeButton.frame.size.width, _closeButton.frame.size.height);
    
    _closeButton.hidden=NO;
    self.popView.hidden=YES;
    selfFrame=self.frame;
    selfBack=self.backgroundColor;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _closeButton.frame.size.height);
    self.backgroundColor=[UIColor clearColor];
    
//    PopUpView *popUp=[[PopUpView alloc]initWithdelegate:self.delegate WithFrame:player.frame WithTitle:@"" WithTitleSize:0 WithMessage:@"" WithMessageSize:0 AndView:player];
//    
//    [popUp show];
}

- (IBAction)closeButtonAction:(UIButton *)sender
{
    _closeButton.hidden=YES;
    self.popView.hidden=NO;
    self.frame=selfFrame;
    self.backgroundColor=selfBack;
}



-(void)popCloseButtonPressed:(UIButton *)popView
{
    
}

@end
