//
//  ChooseLevelViewController.m
//  DotSpaceConqueror
//
//  Created by Aswathy  on 04/03/14.
//  Copyright (c) 2014 Cabot. All rights reserved.
//

#import "ChooseLevelViewController.h"
#import "MainGameViewController.h"

#define ALERT_MESSAGE @"Will be available in next version"

@interface ChooseLevelViewController ()
{
    ThemeModal *theme;
    NSString *gameType,*difficultyLevel;
    UIAlertView *alertPopUp;
}
@end

@implementation ChooseLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                                  forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //    self.navigationController.navigationBar.translucent = YES;
    //    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBarHidden = NO;
    
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_mainLevelBackground];
    
//    [_mainLevelBackground setImage:[UIImage imageNamed:theme.mainBackground]];
    
    [_easyBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_easyBtn setTitleColor:theme.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
    
    [_mediumBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_mediumBtn setTitleColor:theme.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
    
    [_hardBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_hardBtn setTitleColor:theme.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
    
    [_veryHard.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_veryHard setTitleColor:theme.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
    
    [_chooseDifficultyLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_chooseDifficultyLabel setTextColor:theme.gameFontColor];
    _chooseDifficultyLabel.text=_chooseDifficulty;
    
    
    if ([[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Unlocked"])
    {
        _mediumLockedImage.hidden=YES;
        _hardLockedImage.hidden=YES;
    }
    else if ([[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Hard"])
    {

       _mediumLockedImage.hidden=YES;
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)easyButtonAction:(UIButton *)sender
{
    
    //    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
    //                                                             bundle: nil];
    //    MainGameViewController *interactiveAddView = (MainGameViewController*)[mainStoryboard
    //                                                                           instantiateViewControllerWithIdentifier: @"MainGameView"];
    //    interactiveAddView.gameType = @"Single";
    //    interactiveAddView.difficultyLevel= @"Easy";
    //
    //    [self.navigationController pushViewController:interactiveAddView animated:YES];
    
    gameType = @"Single";
    difficultyLevel= @"Easy";
    
    [self performSegueWithIdentifier:_toViewIdentifier sender:self];
}

- (IBAction)mediumButtonAction:(UIButton *)sender
{
    if ([[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Hard"]||[[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Unlocked"])
    {
        gameType=@"Single";
        difficultyLevel= @"Medium";
        [self performSegueWithIdentifier:_toViewIdentifier sender:self];
       
    }
    else
    {
       
        alertPopUp = [[UIAlertView alloc] initWithTitle:@"Locked" message:@"Get a win streak of 5 in Easy to unlock this level." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertPopUp show];
    }
    
}

- (IBAction)hardButtonAction:(UIButton *)sender
{
    if ([[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Unlocked"])
    {
        gameType=@"Single";
        difficultyLevel= @"Hard";
        [self performSegueWithIdentifier:_toViewIdentifier sender:self];

    }
    else
    {
        alertPopUp = [[UIAlertView alloc] initWithTitle:@"Locked" message:@"Get a win streak of 5 in Medium to unlock this level." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertPopUp show];
    }
    
}

- (IBAction)veryHardButtonAction:(UIButton *)sender
{
    
    gameType=@"Single";
    difficultyLevel= @"Very Hard";
    [self performSegueWithIdentifier:_toViewIdentifier sender:self];
    
    
    //    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:ALERT_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [av show];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    //    if ([segue.identifier isEqualToString:@"toMainGameView"])
    //    {
    [segue.destinationViewController setGameType:gameType];
    [segue.destinationViewController setDifficultyLevel:difficultyLevel];
    
    
    
}



@end
