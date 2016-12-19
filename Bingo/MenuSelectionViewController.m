//
//  MenuSelectionViewController.m
//  Bingo
//
//  Created by feialoh on 11/12/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import "MenuSelectionViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Reusables.h"
#import "ThemeModal.h"
#import "MainGameViewController.h"
#import "ChooseLevelViewController.h"

@interface MenuSelectionViewController ()
{
    MPMoviePlayerController *playerCtrl,*videoPlayer;
    MainGameViewController *gameView;
    NSString *difficultyLabel,*segueId;
    ThemeModal *ob;
}
@end

@implementation MenuSelectionViewController

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
     [[GameCenterManager sharedManager] setDelegate:self];
//    [self setupMovie];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setDefaultTheme];
    
    [self.navigationController setNavigationBarHidden:YES];
    [_singlePlayerBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_singlePlayerBtn setTitleColor:ob.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
    
    [_multiplayerBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_multiplayerBtn setTitleColor:ob.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
    
    [_settingsBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_settingsBtn setTitleColor:ob.gameFontColor forState:UIControlStateNormal & UIControlStateSelected ];
    
    [_gameCenterBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_gameCenterBtn setTitleColor:ob.gameFontColor forState:UIControlStateNormal & UIControlStateSelected ];
    
    [_helpBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_helpBtn setTitleColor:ob.gameFontColor forState:UIControlStateNormal & UIControlStateSelected ];
    
    [_highScoreBtn.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [_highScoreBtn setTitleColor:ob.gameFontColor forState:UIControlStateNormal & UIControlStateSelected ];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];  // it shows
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupMovie{
 
//    playerCtrl =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
//    playerCtrl.scalingMode = MPMovieScalingModeFill;
//    playerCtrl.controlStyle = MPMovieControlStyleNone;
//    playerCtrl.view.frame = CGRectMake(0, 0, 480, 320);
    
    videoPlayer = [[MPMoviePlayerController alloc] init];
    [videoPlayer setControlStyle:MPMovieControlStyleFullscreen];
    videoPlayer.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"mp4"];
    NSString *moviePath =[Reusables getResourcePath:@"bingoIntro.mp4"];
    NSLog(@"Main bundle path: %@", [NSBundle mainBundle]);
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    [videoPlayer setContentURL:movieURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoplaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:videoPlayer];
    
//    [playerCtrl.view setCenter:CGPointMake(240, 160)];
//    [playerCtrl.view setFrame:CGRectMake(0, 0, 480, 320)];
//    [playerCtrl.view setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
        [self.view addSubview:videoPlayer.view];
        [videoPlayer play];
}

-(void)videoplaybackStateChanged:(NSNotification *)notification
{
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded)
    {
        //movie finished playing
        NSLog(@"MPMovieFinishReasonPlaybackEnded");
        MPMoviePlayerController *moviePlayer = [notification object];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        [videoPlayer stop];
        [videoPlayer.view removeFromSuperview];
        videoPlayer=nil;
    }
    else if (reason == MPMovieFinishReasonUserExited)
    {
        NSLog(@"MPMovieFinishReasonUserExited");
        //user hit the done button
        MPMoviePlayerController *moviePlayer = [notification object];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        [videoPlayer stop];
        [videoPlayer.view removeFromSuperview];
        videoPlayer=nil;
    }
    else if (reason == MPMovieFinishReasonPlaybackError)
    {
        NSLog(@"MPMovieFinishReasonPlaybackError");
    }

}

- (IBAction)singlePlayerAction:(UIButton *)sender
{
//    gameView.gameType=@"Single";
//    [self performSegueWithIdentifier:@"menuSelectionToMainController" sender:self];
    
    difficultyLabel=@"Choose Difficulty";
    segueId=@"toMainGameView";
    
 [self performSegueWithIdentifier:@"toLevelView" sender:self];
    
    
//    UIAlertView *mav = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Not Completed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [mav show];
    
}

- (IBAction)settingsButtonAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"menuSelectionToSettings" sender:self];
}

- (IBAction)multiplayerAction:(UIButton *)sender
{
//     gameView=[[MainGameViewController alloc]init];
//     gameView.gameType=@"Multiplayer";
//     [self performSegueWithIdentifier:@"toMainGameView" sender:self];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    MainGameViewController *interactiveAddView = (MainGameViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"MainGameView"];
    interactiveAddView.gameType = @"Mutliplayer";
    [self.navigationController pushViewController:interactiveAddView animated:YES];
}

- (IBAction)highScoreAction:(UIButton *)sender
{
    
    difficultyLabel=@"High Scores";
    segueId=@"toHighScoreView";
    
    [self performSegueWithIdentifier:@"toLevelView" sender:self];
    
    
}

- (IBAction)helpAction:(UIButton *)sender
{
    
}

- (IBAction)gameCenterAction:(UIButton *)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    MainGameViewController *interactiveAddView = (MainGameViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"MainGameView"];
    interactiveAddView.gameType = @"GameCenter";
    
    
     if([[GameCenterManager sharedManager] isGameCenterAvailable])
     {
//          [self.navigationController pushViewController:interactiveAddView animated:YES];
         
         [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
     }
    else
    {
        showAlert(nil,@"Game Center Unavailable", @"Ok",nil)
    }
    
    
   


}


-(void)setDefaultTheme
{
    
    if (![Reusables getDefaultValue:THEME_TYPE])
    {
        [Reusables storeDataToDefaults:THEME_TYPE objectToAdd:@"Default"];
        
    }
    
    if (![Reusables getDefaultValue:MAIN_BACKGROUND])
    {
        [Reusables storeDataToDefaults:MAIN_BACKGROUND objectToAdd:@"xmas-bg"];
      
    }
    
    if (![Reusables getDefaultValue:LOCKED_STATUS])
    {
        [Reusables storeDataToDefaults:LOCKED_STATUS objectToAdd:@"Medium"];
        
    }
    
    
    if (![Reusables getDefaultValue:PLAYER_NAME])
    {
        NSString *playerName=[UIDevice currentDevice].name;
        if ([UIDevice currentDevice].name.length>10)
        {
            playerName=[[UIDevice currentDevice].name substringToIndex:10];
        }
        
        [Reusables storeDataToDefaults:PLAYER_NAME objectToAdd:playerName];
        
    }
    
    if (![Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND])
    {
        [Reusables storeDataToDefaults:INITIAL_BUTTON_BACKGROUND objectToAdd:@"bubble-red-md"];
         NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_TITLE_COLOR];
         NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:INITIAL_BUTTON_TITLE_COLOR]);
    }
    
    if (![Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND])
    {
        [Reusables storeDataToDefaults:SELECTED_BUTTON_BACKGROUND objectToAdd:@"bubble-yellow-md"];
         NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_TITLE_COLOR];
    }
    
    if (![Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND])
    {
        [Reusables storeDataToDefaults:MULTIPLE_BUTTON_BACKGROUND objectToAdd:@"bubble-green-md"];
         NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_TITLE_COLOR];
        
    }
    
    if (![Reusables getDefaultValue:GAME_FONT])
    {
        [Reusables storeDataToDefaults:GAME_FONT objectToAdd:@"Baskerville-Bold"];
        
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:GAME_FONT_COLOR];
        
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:BINGO_FONT_COLOR];
        
    }
    

//    [_mainMenuBackground setImage:[UIImage imageNamed:[Reusables getDefaultValue:MAIN_BACKGROUND]]];
    
    ob=[[ThemeModal alloc]init];
    [ob setTheme:_mainMenuBackground];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
        if ([segue.identifier isEqualToString:@"toLevelView"])
        {
            [segue.destinationViewController setChooseDifficulty:difficultyLabel];
            [segue.destinationViewController setToViewIdentifier:segueId];

        }

    
    
}

#pragma mark - GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}


@end
