//
//  MainGameViewController.m
//  Bingo
//
//  Created by feialoh on 05/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "MainGameViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ThemeModal.h"
#import <QuartzCore/QuartzCore.h>



#define ORDER 5
#define HIGHSCORELIMIT 10
#define UNLOCKLIMITMEDIUM 5
#define UNLOCKLIMITHARD 5
#define MAXSUPPORTEDPLAYERS 4

@interface MainGameViewController ()<MCBrowserViewControllerDelegate,UITextFieldDelegate>
{
    ThemeModal *theme;
    NSArray *playerIds;
    NSMutableArray *bingoButtons,*tempArray;
    NSMutableArray *arrConnectedDevices,*dataToSend, *noOfPlayers,*colorArray;
    int bingo,firstPlayer,randomIndex,playerWinStreak,highScore;
    NSString *bingoText,*markedButton, *singlePlayerResult;
    UILabel *_bingoTextPlayer,*playerTurn,*_cpuTextPlayer,*cpuLabel,*playerlabel,*scorelabel;
    NSUInteger btnTag;
    BOOL playerChange,selfTurn,continuePlay,showWinAlert,gameRestart,markForOther;
    NSUInteger iValue,colorValue;
    MCPeerID *currentPlayer;
    UIBarButtonItem *restartButton,*newBackButton;
    FinalScoreView *resultAlert;
    ScoreAlertPopUpView *scoreAlert;
    UIAlertView *myresultAlert,*alertPopUp;
    AppDelegate *appObject;
    

    BOOL requestingAd;
    
    
}

@end

@implementation MainGameViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

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
    
    requestingAd = NO;
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __managedObjectContext = [self.appDelegate managedObjectContext];
    
    arrConnectedDevices=[[NSMutableArray alloc]init];
    appObject=[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReceivedDataWithNotification:)
                                                 name:@"MPCDemo_DidReceiveDataNotification"
                                               object:nil];
    
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_mainGameBackground];
    randomIndex=0;playerWinStreak=0;highScore=0;
    
    //    [_mainGameBackground setImage:[UIImage imageNamed:theme.mainBackground]];
    
    [self customiseNavigationBar];
    
    if([_gameType isEqualToString:@"Mutliplayer"])
    {
        [self setUpMultipeer];
        gameRestart=NO;
    }
    else if([_gameType isEqualToString:@"GameCenter"])
    {
//        [GCTurnBasedMatchHelper sharedInstance].delegate = self;
//        
//        [[GCTurnBasedMatchHelper sharedInstance]
//         findMatchWithMinPlayers:2 maxPlayers:4 viewController:self];
         [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
       
    }
    // Set GameCenter Manager Delegate
    [[GameCenterManager sharedManager] setDelegate:self];
    [self initiatePlay];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    if (available) {
        [self.navigationController.navigationBar setValue:@"GameCenter Available" forKeyPath:@"prompt"];
    } else {
        [self.navigationController.navigationBar setValue:@"GameCenter Unavailable" forKeyPath:@"prompt"];
    }
}

//-(void)glowMarquee {
//    alph = (alph == 1) ? 0.7 : 1; // Switch value of alph
//    [UIView beginAnimations:@"alpha" context:NULL];
//    [UIView setAnimationDuration:0.4];
//    _numberLabel.alpha = alph;
//    [UIView commitAnimations];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Gesture delegate methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.scrollView.superview != nil) {
        if ([touch.view isKindOfClass:[UIButton class]]||[touch.view.superview.superview isKindOfClass:[UITableViewCell class]]||[touch.view.superview.superview.superview isKindOfClass:[UITableViewCell class]]||[touch.view.superview isKindOfClass:[UITableViewCell class]])
            // isDescendantOfView:self.scrollView]) {
            // we touched our control surface
        {
            return NO; // ignore the touch
        }
        
    }
    return YES; // handle the touch
    
    
}

#pragma mark -
#pragma mark - Custom methods


-(void)initiatePlay
{
    playerTurn=[[UILabel alloc]initWithFrame:CGRectMake(130,50,150, 20.0f)];
    playerTurn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    playerTurn.backgroundColor = [UIColor clearColor];
    playerTurn.tag=777;
    //    [self.view addSubview:playerTurn];
    
    playerlabel=[[UILabel alloc]initWithFrame:CGRectMake(130,50,150, 20.0f)];
    scorelabel=[[UILabel alloc]initWithFrame:CGRectMake(130,50,150, 20.0f)];
    
    cpuLabel=[[UILabel alloc]initWithFrame:CGRectMake(130,50,150, 20.0f)];
    cpuLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cpuLabel.backgroundColor = [UIColor clearColor];
    cpuLabel.tag=777;
    
    
    
    selfTurn=YES;
    playerChange=YES;
    continuePlay=YES;
    showWinAlert=YES;
    markForOther=YES;
    iValue=1;
    
    
    tempArray=[[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.scrollView addGestureRecognizer:singleTap];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    
    bingoText=@"BINGO"; btnTag=1;
    CGSize myStringSize = [bingoText sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                           }];
    
    _bingoTextPlayer=[[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2,90, myStringSize.width, myStringSize.height)];
    
    _bingoTextPlayer.textColor=theme.bingoFontColor;
    _bingoTextPlayer.font = [self myFontWithSize:25];
    _bingoTextPlayer.text=@"";
    bingo=0;  _bingoTextPlayer.hidden=YES;
    
    _cpuTextPlayer=[[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2,90, myStringSize.width, myStringSize.height)];
    
    _cpuTextPlayer.textColor=theme.bingoFontColor;
    _cpuTextPlayer.font = [self myFontWithSize:25];
    _cpuTextPlayer.text=@"";
    _cpuTextPlayer.hidden=YES;
    
    // Do any additional setup after loading the view.
    
    bingoButtons=[[NSMutableArray alloc]init];
    
    
    if([_gameType isEqualToString:@"Single"])
    {
        noOfPlayers=[[NSMutableArray alloc]init];
        firstPlayer=arc4random()%2;
        
        NSString *player1,*player2;
        if (!firstPlayer)
        {
            player1=@"CPU";
            player2=[Reusables getDefaultValue:PLAYER_NAME];
            
            
        }
        else
        {
            player1=[Reusables getDefaultValue:PLAYER_NAME];
            player2=@"CPU";
            
        }
        [noOfPlayers addObject:[@{
                                  @"player":player1,
                                  @"id":@1
                                  } mutableCopy]] ;
        
        [noOfPlayers addObject:[@{
                                  @"player":player2,
                                  @"id":@2
                                  } mutableCopy]] ;
        
        currentPlayer=[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"id"];
        
        if (![self getFilteredName:[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"]].length)
        {
            playerTurn.text=@"Player's turn";
        }
        else
            playerTurn.text=[NSString stringWithFormat:@"%@'s turn",[self getFilteredName:[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"]]];
        
        [playerTurn setTextColor:theme.gameFontColor];
        playerTurn.font = [self myFontWithSize:19];
        [self adjustTurnLabel:19 forLabel:playerTurn];
        
        
        [self createButtonsView:CGPointMake(0, 0) withTag:1 forPlayer:1];
        
        UIView *myView=[self getViewForTag:1];
        
        UIButton *lastButton=[self getButtonForTag:25 InView:myView];
        
        myView.frame=CGRectMake(0, 0, self.view.frame.size.width, lastButton.frame.origin.y+lastButton.frame.size.height+10);
        
        
        [self createButtonsView:CGPointMake(0, myView.frame.origin.y+myView.frame.size.height) withTag:2 forPlayer:2];
        
        myView=[self getViewForTag:2];
        
        
        lastButton=[self getButtonForTag:50 InView:myView];
        
        myView.frame=CGRectMake(0, myView.frame.origin.y, self.view.frame.size.width, lastButton.frame.origin.y+lastButton.frame.size.height+10);
        
        //        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, myView.frame.origin.y+myView.frame.size.height);
        
        tempArray=[bingoButtons mutableCopy];
        
        
        //        #warning to be changed and uncommented
        [self setHiddenForCpuGrid:YES];
        
        _scrollView.scrollEnabled=NO;
        
        NSLog(@"Play turn:%d",firstPlayer);
        if (!firstPlayer)
        {
            player1=@"CPU plays first";
        }
        else
        {
            player1=@"You play first";
        }
        
        UIAlertView *mav = [[UIAlertView alloc]initWithTitle:nil message:player1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        mav.tag=790;
        [mav show];
        
    }
    else if([_gameType isEqualToString:@"Mutliplayer"])
    {
        if (!gameRestart)
        {
            noOfPlayers=[[NSMutableArray alloc]init];
            [arrConnectedDevices addObject:self.appDelegate.mpcHandler.peerID];
            
            [noOfPlayers addObject:[@{
                                      @"player":self.appDelegate.mpcHandler.peerID.displayName,
                                      @"id":self.appDelegate.mpcHandler.peerID,
                                      @"playerChance":@(NO),
                                      @"winStatus":@(NO),
                                      @"playerReady":@(NO),
                                      @"gameOver":@(NO),
                                      @"playerGrid":[[UIView alloc]init]
                                      } mutableCopy]] ;
            
            
            [self showBrowserVC];
        }
        else
        {
            iValue=randomIndex+1;
            [self createButtonsView:CGPointMake(0, 0) withTag:1 forPlayer:1];
            tempArray=[bingoButtons mutableCopy];
            [self setPlayerTurnForMultiplayer];
        }
    }
    else
    {
//        noOfPlayers=[[NSMutableArray alloc]init];
//        [arrConnectedDevices addObject:@1];
//        
//        [noOfPlayers addObject:[@{
//                                  @"player":@"player 1",
//                                  @"id":@1,
//                                  @"playerChance":@(NO),
//                                  @"winStatus":@(NO),
//                                  @"playerReady":@(NO),
//                                  @"gameOver":@(NO),
//                                  @"playerGrid":[[UIView alloc]init]
//                                  } mutableCopy]] ;
//        
//        [self createButtonsView:CGPointMake(0, 0) withTag:1 forPlayer:1];
//        tempArray=[bingoButtons mutableCopy];
        
        //        [arrConnectedDevices addObject:@2];
        //
        //        [noOfPlayers addObject:[@{
        //                                  @"player":@"player 2",
        //                                  @"id":@2,
        //                                  @"playerChance":@(NO),
        //                                  @"winStatus":@(NO),
        //                                  @"playerReady":@(NO),
        //                                  @"gameOver":@(NO),
        //                                  @"playerGrid":[[UIView alloc]init]
        //                                  } mutableCopy]] ;
        
    }
    
    
    //    [self createButtonsView:CGPointMake(0, 0) withTag:1 forPlayer:1];
    
    //    [self createButtonsView:CGPointMake(30, 350) withTag:2 forPlayer:2];
    
    
    
    
}


//Navigation bar customization
- (void) customiseNavigationBar
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    self.title = @"Bingo";
    
    restartButton = [[UIBarButtonItem alloc] initWithTitle: @"Restart" style: UIBarButtonItemStyleBordered target: self action: @selector(restartButtonAction)];
    
    
    
    newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(onBackTouched:)];
    
    [[self navigationItem] setLeftBarButtonItem:newBackButton];
    
}


- (void)onBackTouched:(id)sender
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.appDelegate.mpcHandler.session)
    {
        [self.appDelegate.mpcHandler.session disconnect];
    }
    self.appDelegate.mpcHandler.browser=nil;
    self.appDelegate.mpcHandler.advertiser=nil;
    self.appDelegate.mpcHandler.session=nil;
    self.appDelegate.mpcHandler.peerID=nil;
    //    });
}


//Creating button views
-(void) createButtonsView :(CGPoint) myViewPoint withTag:(NSUInteger) viewTag forPlayer:(NSUInteger) playerNumber
{
    float buttonWidth=40.0, buttonHeight=40.0, spaceFactor=10.0,buttonX=30.0, buttonY=0.0;
    NSString *playerName=@"Player";
    if (playerNumber==1)
    {
        playerName=[Reusables getDefaultValue:PLAYER_NAME];
    }
    else
    {
        playerName=@"CPU";
    }
    //    float viewWidth=ORDER*buttonWidth+(ORDER-1)*spaceFactor;
    //
    //    float viewHeight=ORDER*buttonHeight+(ORDER-1)*spaceFactor;
    
    
    
    NSMutableArray *buttons1_25=[[NSMutableArray alloc]init];
    UIButton *myButtons;
    
    UIView *buttonsView=[[UIView alloc] initWithFrame:CGRectMake(myViewPoint.x, myViewPoint.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    buttonsView.tag=viewTag;
    //     UIView *buttonsView=[[UIView alloc] initWithFrame:CGRectMake(myViewPoint.x, myViewPoint.y, viewWidth+30, viewHeight)];
    
    
    [buttonsView setBackgroundColor:[UIColor clearColor]];
    
    if (viewTag==1)
    {
        [buttonsView addSubview:_bingoTextPlayer];
        [buttonsView addSubview:playerTurn];
    }
    else
    {
        [buttonsView addSubview:_cpuTextPlayer];
        [buttonsView addSubview:cpuLabel];
    }
    
    
    for (NSUInteger i=0; i<ORDER; i++)
    {
        for (NSUInteger j=0; j<ORDER; j++)
        {
            
            
            myButtons = [UIButton buttonWithType:UIButtonTypeCustom];
            [myButtons addTarget:self
                          action:@selector(sendButtonAction:)
                forControlEvents:UIControlEventTouchDown];
            
            myButtons.frame = CGRectMake(buttonX,buttonY, buttonWidth, buttonHeight);
            myButtons.tag=btnTag;
            [buttons1_25 addObject:myButtons];
            [buttonsView addSubview:myButtons];
            
            btnTag++;
            
            buttonX+=buttonWidth+spaceFactor;
            
        }
        buttonX=30.0;
        buttonY+=buttonHeight+spaceFactor;
    }
    if (buttonsView.frame.origin.y+buttonsView.frame.size.height>_scrollView.frame.size.height)
    {
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, buttonsView.frame.origin.y+buttonsView.frame.size.height);
    }
    else
    {
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    }
    [_scrollView addSubview:buttonsView];
    
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    buttons1_25=[[buttons1_25 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    
    if (self.appDelegate.mpcHandler.peerID.displayName)
    {
        playerName=[self getFilteredName:self.appDelegate.mpcHandler.peerID.displayName];
    }
    
    [bingoButtons addObject:[@{
                               @"player":[NSNumber numberWithInteger:playerNumber],
                               @"button":buttons1_25,
                               @"bingoCount":[NSNumber numberWithInt:0],
                               @"playerId":playerName
                               }mutableCopy]];
    
    [self initialize:NO withButtons:bingoButtons forPlayer:playerNumber];
    
}


//Initializing the buttons
-(void)initialize :(BOOL) animated withButtons:(NSMutableArray *)myButtons forPlayer:(NSUInteger) playerNo
{
    
    NSMutableArray *_buttons1_25=[[myButtons objectAtIndex:playerNo-1]valueForKey:@"button"];
    
    NSUInteger size=_buttons1_25.count;
    
    //    NSLog(@"button nos:%lu",(unsigned long)size);
    
    int a[size];
    for(int i=0;i<size;i++)
        a[i]=i+1;
    for(int i=0;i<size;i++)
    {
        UIButton *cell=[_buttons1_25 objectAtIndex:i];
        
        int randindex=arc4random()%(size-i);
        [self changeButtonBackground:cell withBackground:theme.initialButton forBackgroundState:UIControlStateNormal withResize:YES];
        [self changeButtonBackground:cell withBackground:theme.selectedButton forBackgroundState:UIControlStateSelected withResize:YES];
        
        //        [cell setBackgroundImage:[UIImage imageNamed:theme.initialButton] forState:UIControlStateNormal];
        //        [cell setBackgroundImage:[UIImage imageNamed:theme.selectedButton] forState:UIControlStateSelected];
        //        [cell setTitle:[NSString stringWithFormat:@"%d",i+1]
        //              forState:UIControlStateNormal & UIControlStateSelected];
        [cell setTitle:[NSString stringWithFormat:@"%d",a[randindex]]
              forState:UIControlStateNormal & UIControlStateSelected];
        [cell.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
        [cell setTitleColor:theme.initialButtonTitleColor forState:UIControlStateNormal];
        [cell setTitleColor:theme.selectedButtonTitleColor forState:UIControlStateSelected];
        
        a[randindex]=a[(size-1)-i];
    }
    
    //    if([_gameType isEqualToString:@"Single"])
    //    {
    //
    //    }
    //    else
    //    {
    [self changePos:100 animated:animated forButtons:_buttons1_25];
    //    }
    
}


//Set Button Background

-(void)changeButtonBackground:(UIButton *)gameButtons withBackground:(id)buttonBackground forBackgroundState:(UIControlState) buttonState withResize:(BOOL)shouldResize
{
    if ([buttonBackground isKindOfClass:[NSString class]])
    {
        [gameButtons setBackgroundImage:[UIImage imageNamed:(NSString *)buttonBackground] forState:buttonState];
    }
    else
    {
        [gameButtons setBackgroundImage:[self imageWithColor:(UIColor *)buttonBackground] forState:buttonState];
        
        CGRect fram=gameButtons.frame;
        if (shouldResize)
        {
            fram.size.height+=(4/fram.size.height)*100;
        }
        
        gameButtons.layer.cornerRadius=fram.size.height/2;
        //        gameButtons.layer.borderWidth = 1.0;
        gameButtons.clipsToBounds=YES;
        // NSLog(@"Corner Radius:%f",gameButtons.layer.cornerRadius);
    }
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//Button Action
-(void) sendButtonAction:(UIButton*)sender
{
    
    if([_gameType isEqualToString:@"Single"])
    {
        
        selfTurn=NO;
        [self.view setUserInteractionEnabled:NO];
        
        //        markedButton=sender.titleLabel.text;
        [self flipButtonsVisibility:sender];
        
        if (continuePlay)
        {
            
            [self changePlayTurn];
            
            if (!selfTurn && [_gameType isEqualToString:@"Single"])
            {
                //                NSLog(@"CPU is going to play");
                [NSTimer scheduledTimerWithTimeInterval:0.5
                                                 target:self
                                               selector:@selector(playForCpu)
                                               userInfo:nil
                                                repeats:NO];
            }
        }
        
        else
        {
            [self.view setUserInteractionEnabled:YES];
        }
    }
    else if([_gameType isEqualToString:@"GameCenter"])
    {
        [self flipButtonsVisibility:sender];
        [self sendTurnGC:sender];
    }
    else
    {
        
        [self receiveAction:sender fromPeer:self.appDelegate.mpcHandler.peerID];
        
        if (continuePlay)
        {
            
            
            dataToSend=[[NSMutableArray alloc]init];
            
            [dataToSend addObject:[@{
                                     @"tag": sender.titleLabel.text,
                                     @"player":self.appDelegate.mpcHandler.peerID.displayName,
                                     @"id":self.appDelegate.mpcHandler.peerID,
                                     @"bingoStatus":[[NSMutableArray alloc]init],
                                     @"gridStatus":@(0),
                                     @"randomIndex":@(randomIndex)
                                     } mutableCopy]] ;
            
            [self sendDataToPeers];
        }
    }
    
    
    
}


-(void)sendTurnGC:(UIButton*)sender{
    GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    
    dataToSend=[[NSMutableArray alloc]init];
    
    [dataToSend addObject:[@{
                             @"tag": sender.titleLabel.text,
                             @"player":[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"],
                             @"id":[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"id"],
                             @"bingoStatus":[[NSMutableArray alloc]init],
                             @"gridStatus":@(0),
                             @"randomIndex":@(randomIndex)
                             } mutableCopy]] ;
    
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataToSend];
    
    
    NSUInteger currentIndex = [currentMatch.participants indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) % [currentMatch.participants count];
    nextParticipant = [currentMatch.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [currentMatch.participants count]; i++) {
        nextParticipant = [currentMatch.participants objectAtIndex:((currentIndex + 1 + i) % [currentMatch.participants count ])];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            NSLog(@"isnt' quit %@", nextParticipant);
            break;
        } else {
            NSLog(@"nex part %@", nextParticipant);
        }
    }
    
    /*if ([data length] > 3800) {
        for (GKTurnBasedParticipant *part in currentMatch.participants) {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
        statusLabel.text = @"Game has ended";
    } else {
        
        [currentMatch endTurnWithNextParticipant:nextParticipant matchData:data completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                statusLabel.text = @"Oops, there was a problem.  Try that again.";
            } else {
                statusLabel.text = @"Your turn is over.";
                textInputField.enabled = NO;
            }
        }];
    }*/
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
//    textInputField.text = @"";
//    characterCountLabel.text = @"250";
//    characterCountLabel.textColor = [UIColor blackColor];
}


-(void) receiveAction:(UIButton *)sender fromPeer: (MCPeerID *) peer
{
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"player" ascending:YES];
    [noOfPlayers sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    //    if (peer == myPeerID)
    if (peer == self.appDelegate.mpcHandler.peerID)
    {
    }
    else
    {
        NSLog(@"Its not your turn");
    }
    
    //    markedButton=sender.titleLabel.text;
    [self flipButtonsVisibility:sender];
}


//Change turn based on grid is filled or not
-(void)changePlayTurn
{
    if (playerChange)
    {
        
        
        if (iValue%noOfPlayers.count==0)
        {
            iValue=1;
        }
        else
        {
            iValue++;
        }
        
        currentPlayer=[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"id"];
        
        if (![self getFilteredName:[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"]].length)
        {
            playerTurn.text=@"Player's turn";
        }
        else
            playerTurn.text=[NSString stringWithFormat:@"%@'s turn",[self getFilteredName:[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"]]];
        
        [self setPlayerTurnForMultiplayer];
    }
    else
    {
        
        playerChange=YES;
    }
    
}

//Mark button for CPU
-(void)playForCpu
{
    selfTurn=YES;
    [self.view setUserInteractionEnabled:YES];
    
    NSMutableArray * _buttons1_25=[[[bingoButtons objectAtIndex:1]valueForKey:@"button"] mutableCopy];
    
    NSMutableArray * player_buttons1_25=[[[bingoButtons objectAtIndex:0]valueForKey:@"button"] mutableCopy];
    
    //    for(int i=0;i<bingoButtons.count;i++)
    //    {
    //        if ([[[bingoButtons objectAtIndex:i]valueForKey:@"playerId"] isEqualToString:@"CPU"])
    //        {
    //            _buttons1_25=[[[bingoButtons objectAtIndex:i]valueForKey:@"button"] mutableCopy];
    //
    //            break;
    //        }
    //    }
    
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    
    for (UIButton *subView in _buttons1_25)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            if (subView.isSelected)
            {
                [discardedItems addObject:subView];
            }
        }
    }
    
    NSMutableArray *playerdiscardedItems = [NSMutableArray array];
    
    for (UIButton *subView in player_buttons1_25)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            if (subView.isSelected)
            {
                [playerdiscardedItems addObject:subView];
            }
        }
    }
    
    
    
    if ([_difficultyLevel isEqualToString:@"Easy"])
    {
        
        [_buttons1_25 removeObjectsInArray:discardedItems];
        
        NSUInteger randIndex = arc4random() % [_buttons1_25 count];
        
        [self flipButtonsVisibility:(UIButton*)[_buttons1_25 objectAtIndex:randIndex]];
    }
    else  //if ([_difficultyLevel isEqualToString:@"Medium"])
    {
        NSMutableArray *buttonScale=[[NSMutableArray alloc]init];
        
        buttonScale= [self getButtonScaleForArray:_buttons1_25];
        
        
        //if condition to begin with center for cpus play
        if (!discardedItems.count)
        {
            for (int i=0;i<buttonScale.count;i++)
            {
                NSLog(@"%@--%@",[[buttonScale objectAtIndex:i]valueForKey:@"x"] ,[[buttonScale objectAtIndex:i]valueForKey:@"y"]);
                if ([[[buttonScale objectAtIndex:i]valueForKey:@"x"] intValue]==2 && [[[buttonScale objectAtIndex:i]valueForKey:@"y"] intValue]==3 )
                {
                    [[buttonScale objectAtIndex:i] setObject:@(3) forKey:@"scale"];
                }
            }
            
        }
        
        buttonScale=[self modifyButtonsScale:buttonScale WithSelectedButton:discardedItems];
        
        buttonScale=[[buttonScale filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"scale == %@", [[buttonScale objectAtIndex:0]valueForKey:@"scale"]]] mutableCopy];
        
        if ([_difficultyLevel isEqualToString:@"Hard"]||[_difficultyLevel isEqualToString:@"Very Hard"])
        {
            
            
            NSMutableArray *playerbuttonScale=[[NSMutableArray alloc]init];
            
            playerbuttonScale= [self getButtonScaleForArray:player_buttons1_25];
            
            playerbuttonScale=[self modifyButtonsScale:playerbuttonScale WithSelectedButton:playerdiscardedItems];
            
            
            
            //            NSLog(@"CANDIDATES");
            //
            //            for (int k=0;k<buttonScale.count;k++)
            //            {
            //                 UIButton *test=[[buttonScale objectAtIndex:k] valueForKey:@"buttons"];
            //
            //                NSLog(@"Button:%@(%@)",test.titleLabel.text,[[buttonScale objectAtIndex:k]valueForKey:@"scale"]);
            //            }
            
            
            for (int i=0;i<buttonScale.count;i++)
            {
                UIButton *myButton=[[buttonScale objectAtIndex:i] valueForKey:@"buttons"];
                
                for (int j=0;j<playerbuttonScale.count;j++)
                {
                    UIButton *compareButton=[[playerbuttonScale objectAtIndex:j] valueForKey:@"buttons"];
                    
                    if ([myButton.titleLabel.text isEqualToString:compareButton.titleLabel.text])
                    {
                        int cpuScale=[[[buttonScale objectAtIndex:i]valueForKey:@"scale"] intValue];
                        
                        int playerScale=[[[playerbuttonScale objectAtIndex:j]valueForKey:@"scale"] intValue];
                        
                        [[buttonScale objectAtIndex:i] setObject:@(cpuScale+playerScale) forKey:@"scale"];
                        
                    }
                }
            }
            
            NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"scale" ascending:YES];
            [buttonScale sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
            
            
            if (_bingoTextPlayer.text.length>0 && _cpuTextPlayer.text.length<3)
            {
                playerbuttonScale=[[playerbuttonScale filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT buttons IN %@", playerdiscardedItems]] mutableCopy];
                
                NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"scale" ascending:YES];
                [playerbuttonScale sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
                
                if ([_difficultyLevel isEqualToString:@"Hard"])
                {
                    
                    //                    [self flipButtonsVisibility:(UIButton*)[[buttonScale objectAtIndex:0] valueForKey:@"buttons"]];
                    
                    [self flipButtonsVisibility:(UIButton*)[[playerbuttonScale objectAtIndex:0] valueForKey:@"buttons"]];
                }
                else
                {
                    //Very hard logic to be completed
                    playerbuttonScale=[[playerbuttonScale filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"scale == %@", [[playerbuttonScale objectAtIndex:0]valueForKey:@"scale"]]] mutableCopy];
                    
                    
                    
                    BOOL contloop=YES;
                    for (int i=0;i<playerbuttonScale.count;i++)
                    {
                        UIButton *playerButton=[[playerbuttonScale objectAtIndex:i] valueForKey:@"buttons"];
                        if (contloop)
                        {
                            
                            for (int j=0;j<buttonScale.count;j++)
                            {
                                UIButton *newCompareButton=[[buttonScale objectAtIndex:j] valueForKey:@"buttons"];
                                
                                if ([playerButton.titleLabel.text isEqualToString:newCompareButton.titleLabel.text])
                                {
                                    NSLog(@"Selected:%@",(UIButton*)[[playerbuttonScale objectAtIndex:i] valueForKey:@"buttons"]);
                                    
                                    [self flipButtonsVisibility:(UIButton*)[[playerbuttonScale objectAtIndex:i] valueForKey:@"buttons"]];
                                    contloop=NO;
                                    break;
                                }
                                else
                                {
                                    if (i+1==playerbuttonScale.count)
                                    {
                                        [self flipButtonsVisibility:(UIButton*)[[playerbuttonScale objectAtIndex:0] valueForKey:@"buttons"]];
                                        contloop=NO;
                                        break;
                                    }
                                }
                                
                            }
                        }
                        else
                        {
                            break;
                        }
                    }
                    
                }
            }
            else
                [self flipButtonsVisibility:(UIButton*)[[buttonScale objectAtIndex:0] valueForKey:@"buttons"]];
            
            
        }
        else
        {   //Medium random button selection
            NSUInteger randIndex = arc4random() % [buttonScale count];
            
            [self flipButtonsVisibility:(UIButton*)[[buttonScale objectAtIndex:randIndex] valueForKey:@"buttons"]];
        }
        
        //        NSLog(@"UPDATED CANDIDATES");
        //
        //        for (int k=0;k<buttonScale.count;k++)
        //        {
        //            UIButton *test=[[buttonScale objectAtIndex:k] valueForKey:@"buttons"];
        //
        //            NSLog(@"Button:%@(%@)",test.titleLabel.text,[[buttonScale objectAtIndex:k]valueForKey:@"scale"]);
        //        }
        
        
        
        
    }
    
    
    if([_gameType isEqualToString:@"Single"])
        [self changePlayTurn];
}


//Set default scale for each buttons
-(NSMutableArray *)getButtonScaleForArray:(NSMutableArray *)_buttons1_25
{
    NSArray *buttonDetails=[[NSArray alloc]init];
    NSMutableArray *buttonScales=[[NSMutableArray alloc]init];
    
    
    for (int i=0;i<_buttons1_25.count;i++)
    {
        UIButton *button=[_buttons1_25 objectAtIndex:i];
        int x=0,y=0,myTag,player,scale=1;
        buttonDetails=[self getTag:button.tag];
        
        
        myTag=(int)[[buttonDetails objectAtIndex:0] integerValue];
        player=(int)[[buttonDetails objectAtIndex:1] integerValue];
        
        x=myTag/ORDER;
        y=myTag%ORDER;
        
        if (!y)
        {
            y=ORDER;
            x-=1;
        }
        
        if((y==(x+1))||(x+1==ORDER-y+1))
        {
            scale=2;
        }
        
        [buttonScales addObject:[@{
                                   @"buttons":[_buttons1_25 objectAtIndex:i],
                                   @"rowScale":@1,
                                   @"colScale":@1,
                                   @"diag1Scale":@1,
                                   @"diag2Scale":@1,
                                   @"scale":@(scale),
                                   @"x":@(x),
                                   @"y":@(y),
                                   @"player":@(player)
                                   }mutableCopy]];
    }
    
    return buttonScales;
}


//Calculate scale for each buttons based on already marked buttons
-(NSMutableArray *)modifyButtonsScale:(NSMutableArray *)buttonS WithSelectedButton:(NSMutableArray *)selectedButton
{
    int x=0,y=0,myTag,player;
    
    NSArray *buttonDetails=[[NSArray alloc]init];
    
    for (int j=0;j<selectedButton.count;j++)
    {
        UIButton *myButton=[selectedButton objectAtIndex:j];
        buttonDetails=[self getTag:myButton.tag];
        
        
        myTag=(int)[[buttonDetails objectAtIndex:0] integerValue];
        player=(int)[[buttonDetails objectAtIndex:1] integerValue];
        
        x=myTag/ORDER;
        y=myTag%ORDER;
        
        if (!y)
        {
            y=ORDER;
            x-=1;
        }
        
        for (int i=0;i<buttonS.count;i++)
        {
            int rowScale=[[[buttonS objectAtIndex:i]valueForKey:@"rowScale"] intValue];
            int colScale=[[[buttonS objectAtIndex:i]valueForKey:@"colScale"] intValue];
            int diag1Scale=[[[buttonS objectAtIndex:i]valueForKey:@"diag1Scale"] intValue];
            int diag2Scale=[[[buttonS objectAtIndex:i]valueForKey:@"diag2Scale"] intValue];
            int newScale=[[[buttonS objectAtIndex:i]valueForKey:@"scale"] intValue];
            ++rowScale;++colScale;++diag1Scale;++diag2Scale;
            
            //For selected button
            if ([[[buttonS objectAtIndex:i]valueForKey:@"x"] intValue]==x && [[[buttonS objectAtIndex:i]valueForKey:@"y"] intValue]==y )
            {
                [[buttonS objectAtIndex:i] setObject:@(0) forKey:@"scale"];
            }
            
            //For button belonging to same row
            if([[[buttonS objectAtIndex:i]valueForKey:@"x"] intValue]==x && [[[buttonS objectAtIndex:i]valueForKey:@"scale"] intValue]!=0)
            {
                if (rowScale>3)
                {
                    rowScale+=5;
                }
                [[buttonS objectAtIndex:i] setObject:@(rowScale) forKey:@"rowScale"];
                
                newScale+=rowScale+colScale+diag1Scale+diag2Scale;
                
                [[buttonS objectAtIndex:i] setObject:@(newScale) forKey:@"scale"];
            }
            
            //For button belonging to same col
            if([[[buttonS objectAtIndex:i]valueForKey:@"y"] intValue]==y && [[[buttonS objectAtIndex:i]valueForKey:@"scale"] intValue]!=0)
            {
                if (colScale>3)
                {
                    colScale+=5;
                }
                [[buttonS objectAtIndex:i] setObject:@(colScale) forKey:@"colScale"];
                
                newScale+=rowScale+colScale+diag1Scale+diag2Scale;
                
                [[buttonS objectAtIndex:i] setObject:@(newScale) forKey:@"scale"];
            }
            //y==x+1 //For button belonging to same diagonal1
            if ([[[buttonS objectAtIndex:i]valueForKey:@"y"] intValue]==[[[buttonS objectAtIndex:i]valueForKey:@"x"] intValue]+1 && [[[buttonS objectAtIndex:i]valueForKey:@"scale"] intValue]!=0)
            {
                if (diag1Scale>3)
                {
                    diag1Scale+=5;
                }
                [[buttonS objectAtIndex:i] setObject:@(diag1Scale) forKey:@"diag1Scale"];
                
                newScale+=rowScale+colScale+diag1Scale+diag2Scale;
                
                [[buttonS objectAtIndex:i] setObject:@(newScale) forKey:@"scale"];
            }
            //x+1==order-y+1 //For button belonging to same diagonal 2
            if ([[[buttonS objectAtIndex:i]valueForKey:@"x"] intValue]+1==ORDER-[[[buttonS objectAtIndex:i]valueForKey:@"y"] intValue]+1 && [[[buttonS objectAtIndex:i]valueForKey:@"scale"] intValue]!=0)
            {
                if (diag2Scale>3)
                {
                    diag2Scale+=5;
                }
                [[buttonS objectAtIndex:i] setObject:@(diag2Scale) forKey:@"diag2Scale"];
                
                newScale+=rowScale+colScale+diag1Scale+diag2Scale;
                
                [[buttonS objectAtIndex:i] setObject:@(newScale) forKey:@"scale"];
            }
            
            
        }
        
        
    }
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"scale" ascending:NO];
    [buttonS sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    return buttonS;
    
}

//Getting button tag and player
-(NSArray *)getTag:(NSUInteger)buttonTag
{
    NSUInteger order=ORDER*ORDER;
    
    
    NSUInteger diffFactor;
    
    if ((buttonTag%order)==0)
    {
        diffFactor=(buttonTag/order)-1;
    }
    else
    {
        diffFactor=buttonTag/order;
    }
    
    NSUInteger btag=buttonTag-diffFactor*order;
    
    return @[[NSNumber numberWithInteger:btag],[NSNumber numberWithInteger:diffFactor+1]];
    
    /*if (buttonTag<=25)
     {
     return @[[NSNumber numberWithInteger:buttonTag],@1];
     }
     else if(buttonTag >25 && buttonTag<=50)
     {
     return @[[NSNumber numberWithInteger:buttonTag-25],@2];
     }
     else if(buttonTag >50 && buttonTag<=75)
     {
     return @[[NSNumber numberWithInteger:buttonTag-50],@3];
     }
     else if(buttonTag >75 && buttonTag<=100)
     {
     return @[[NSNumber numberWithInteger:buttonTag-75],@4];
     }
     else
     {
     return @[[NSNumber numberWithInteger:buttonTag-100],@5];
     }*/
}


//Setting button state properties
-(void)flipButtonsVisibility:(UIButton*)sender
{
    markedButton=sender.titleLabel.text;
    
    [self beginRippleAnimation:sender];
    
    //    [sender setSelected:!sender.isSelected];
    [sender setSelected:YES];
    
    [sender setUserInteractionEnabled:NO];
    
    NSArray *buttonDetails=[[NSArray alloc]init];
    
    int x,y,x1,y1,myTag,player,bingoCount;
    BOOL row,col,diag1,diag2;
    row=FALSE;col=FALSE;diag1=FALSE;diag2=FALSE;
    
    buttonDetails=[self getTag:sender.tag];
    
    NSLog(@"tag-%@,player-%@,buttonText:%@",[buttonDetails objectAtIndex:0],[buttonDetails objectAtIndex:1],sender.titleLabel.text);
    
    myTag=(int)[[buttonDetails objectAtIndex:0] integerValue];
    player=(int)[[buttonDetails objectAtIndex:1] integerValue];
    
    x=myTag/ORDER;
    y=myTag%ORDER;
    
    if (!y)
    {
        y=ORDER;
        x-=1;
    }
    x1=x;
    y1=y;
    
    NSString *log=@"";
    
    NSMutableArray * _buttons1_25=[[bingoButtons objectAtIndex:player-1]valueForKey:@"button"];
    
    bingoCount=(int)[[[bingoButtons objectAtIndex:player-1]valueForKey:@"bingoCount"] integerValue];
    
    //Loop to check if 5 buttons in row/col/diag are selected
    //For row check
    
    for (int i=ORDER*x+1; i<=ORDER*x+ORDER; i++)
    {
        
        log=[log stringByAppendingString:[NSString stringWithFormat:@"%d,",i]];
        
        //        NSLog(@"log=%@, ivalue:%d",log,i);
        
        if (![[_buttons1_25 objectAtIndex:i-1] isSelected])
        {
            row=FALSE;
            break;
        }
        
        //        NSLog(@"%d==%d",i,ORDER*x+ORDER);
        if (i==ORDER*x+ORDER)
        {
            row=TRUE;
        }
    }
    
    //    NSLog(@"ROW:%@",log);
    log=@"";
    
    //For column check
    
    for (int i=0; i<ORDER; i++)
    {
        log=[log stringByAppendingString:[NSString stringWithFormat:@"%d,",y]];
        if (![[_buttons1_25 objectAtIndex:y-1] isSelected])
        {
            col=FALSE;
            break;
        }
        y+=5;
        
        if (i+1==ORDER)
        {
            col=TRUE;
        }
    }
    
    //    NSLog(@"COL:%@",log);
    log=@"";
    
    //For diagonal1 check
    
    if (y1==x1+1)
    {
        for (int i=0,j=1; i<ORDER; i++,j++)
        {
            log=[log stringByAppendingString:[NSString stringWithFormat:@"%d,",ORDER*i+j]];
            if (![[_buttons1_25 objectAtIndex:ORDER*i+j-1] isSelected])
            {
                diag1=FALSE;
                break;
            }
            if (i+1==ORDER)
            {
                diag1=TRUE;
            }
        }
    }
    
    //    NSLog(@"D1:%@",log);
    log=@"";
    
    //For diagonal2 check
    
    if (x1+1==ORDER-y1+1)
    {
        
        for (int i=0,j=5; i<ORDER; i++,j--)
        {
            log=[log stringByAppendingString:[NSString stringWithFormat:@"%d,",ORDER*i+j]];
            if (![[_buttons1_25 objectAtIndex:ORDER*i+j-1] isSelected])
            {
                diag2=FALSE;
                break;
            }
            if (i+1==ORDER)
            {
                diag2=TRUE;
            }
        }
    }
    
    //    NSLog(@"D2:%@",log);
    log=@"";
    
    //Same loops above repeated only this time we set the button colors
    
    x=x1;
    y=y1;
    
    if (row)
    {
        
        for (int i=ORDER*x+1; i<=ORDER*x+ORDER; i++)
        {
            UIButton *cell=[_buttons1_25 objectAtIndex:i-1];
            //            [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
            [self changeButtonBackground:cell withBackground:theme.multipleButton forBackgroundState:UIControlStateSelected withResize:NO];
            [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
            [self beginRippleAnimation:cell];
        }
        
        [[bingoButtons objectAtIndex:player-1] setObject:[NSNumber numberWithInt:++bingoCount] forKey:@"bingoCount"];
        //        bingo++;
    }
    
    
    if (col)
    {
        for (int i=0; i<ORDER; i++)
        {
            UIButton *cell=[_buttons1_25 objectAtIndex:y-1];
            //            [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
            [self changeButtonBackground:cell withBackground:theme.multipleButton forBackgroundState:UIControlStateSelected withResize:NO];
            [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
            y+=5;
            [self beginRippleAnimation:cell];
        }
        [[bingoButtons objectAtIndex:player-1] setObject:[NSNumber numberWithInt:++bingoCount] forKey:@"bingoCount"];
        //        bingo++;
    }
    
    if (diag1)
    {
        for (int i=0,j=1; i<ORDER; i++,j++)
        {
            UIButton *cell=[_buttons1_25 objectAtIndex:ORDER*i+j-1];
            //            [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
            [self changeButtonBackground:cell withBackground:theme.multipleButton forBackgroundState:UIControlStateSelected withResize:NO];
            [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
            [self beginRippleAnimation:cell];
        }
        
        [[bingoButtons objectAtIndex:player-1] setObject:[NSNumber numberWithInt:++bingoCount] forKey:@"bingoCount"];
        //        bingo++;
    }
    
    if (diag2)
    {
        for (int i=0,j=5; i<ORDER; i++,j--)
        {
            UIButton *cell=[_buttons1_25 objectAtIndex:ORDER*i+j-1];
            //            [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
            [self changeButtonBackground:cell withBackground:theme.multipleButton forBackgroundState:UIControlStateSelected withResize:NO];
            [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
            [self beginRippleAnimation:cell];
        }
        
        [[bingoButtons objectAtIndex:player-1] setObject:[NSNumber numberWithInt:++bingoCount] forKey:@"bingoCount"];
        //        bingo++;
    }
    
    bingo=(int)[[[bingoButtons objectAtIndex:player-1]valueForKey:@"bingoCount"] integerValue];
    
    //    NSLog(@"Bingo Count:%d",bingo);
    
    CGSize myStringSize;
    
    if (bingo>=6)
    {
        bingo=5;
    }
    
    if (bingo>0)
    {
        //        NSLog(@"String:%@",[bingoText substringWithRange:NSMakeRange(0, bingo)]);
        
        myStringSize = [[bingoText substringWithRange:NSMakeRange(0, bingo)] sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                                                                   }];
        
        if(player==1)
        {
            
            //            singlePlayerResult=[[bingoButtons objectAtIndex:player-1]valueForKey:@"playerId"];
            //
            //
            //            singlePlayerResult=[NSString stringWithFormat:@"%@ Wins!",singlePlayerResult];
            
            if (continuePlay)
            {
                singlePlayerResult=@"player";
                
            }
            
            
            _bingoTextPlayer.frame =CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2,30, myStringSize.width, myStringSize.height);
            _bingoTextPlayer.text=[bingoText substringWithRange:NSMakeRange(0, bingo)];
            _bingoTextPlayer.hidden=NO;
            [self.view bringSubviewToFront:_bingoTextPlayer];
            
            
        }
        else
        {
            
            if (continuePlay)
            {
                singlePlayerResult=@"cpu";
                
            }
            
            
            //            singlePlayerResult=@"CPU Wins! Better luck next time.";
            
            _cpuTextPlayer.frame =CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2,50, myStringSize.width, myStringSize.height);
            _cpuTextPlayer.text=[bingoText substringWithRange:NSMakeRange(0, bingo)];
            _cpuTextPlayer.hidden=NO;
            [self.view bringSubviewToFront:_cpuTextPlayer];
            
        }
        
        
        
    }
    
    playerIds = @[[NSNumber numberWithInteger:player]];
    
    if (continuePlay)
    {
        NSLog(@"Continued:%@,player:%@",singlePlayerResult,[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"]);
        [self checkForWinStatus];
        
    }
    
    if (markForOther && [_gameType isEqualToString:@"Single"])
    {
        
        [self markForPlayers];
        
    }
    
    
    if(![_gameType isEqualToString:@"Single"] && continuePlay)
        [self changePlayTurn];
    
    
}

-(void)markForPlayers
{
    tempArray=[[tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT player IN %@", playerIds ]] mutableCopy];
    
    
    if (tempArray.count>0)
    {
        
        [self markForOtherButtons:markedButton];
        
    }
    else
    {
        tempArray=[bingoButtons mutableCopy];
    }
    
}

-(void)markForOtherButtons:(NSString *)markedNumber
{
    NSMutableArray * _buttons1_25=[[tempArray objectAtIndex:0]valueForKey:@"button"];
    
    for (UIButton *subView in _buttons1_25)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            if ([subView.titleLabel.text isEqualToString:markedNumber])
            {
                [self flipButtonsVisibility:subView];
                break;
            }
        }
    }
    
}


//Get font with size
-(UIFont *)myFontWithSize:(CGFloat)size
{
    
    return [UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:size];
    
}

//Filter the device name
-(NSString*) getFilteredName:(NSString *)str
{
    NSRange equalRange =  [str rangeOfString:@"$#$#$-"];
    if (equalRange.location != NSNotFound) {
        NSString *result = [str substringToIndex:equalRange.location];
        //        NSLog(@"The result = %@", result);
        return result;
    } else {
        //        NSLog(@"There is no = in the string");
        return str;
    }
    
}



//Animate and set button size
-(void)changePos:(float) add animated:(BOOL) animate forButtons:(NSMutableArray *)_buttons1_25
{
    int sign=abs(add)/add;
    int i=0;
    for(UIButton *cell in _buttons1_25)
    {
        
        [UIView beginAnimations:@"button" context:nil];
        [UIView setAnimationDuration:1];
        CGRect fram=cell.frame;
        if(sign>0)
        {
            //            fram.size.height*=2;
            //            fram.size.width*=2;
            fram.size.height+=(4/fram.size.height)*100; //25% increase
            fram.size.width+=(4/fram.size.width)*100;
            cell.frame=fram;
            fram.origin.x+=sign*(fram.size.width*-((2-(i%5))*0.25));
            if (cell.tag>25)
            {
                fram.origin.y+=sign*(fram.size.height*-((2-(i/5))*0.25))+20;
            }
            else
            {
                fram.origin.y+=sign*(fram.size.height*-((2-(i/5))*0.25));
            }
            
            cell.frame=fram;
            
        }
        else
        {
            int j=0;
            for(UIView *view in [cell subviews])
            {
                j++;
                if(j<2)
                    continue;
                fram=view.frame;
                
                fram.size.height*=2.0/3.0;
                fram.size.width*=2.0/3.0;
                //fram.size.height-=(4/fram.size.height)*100; //4% decrease
                //fram.size.width-=(4/fram.size.width)*100;
                view.frame=fram;
                
            }
            fram=cell.frame;
            fram.origin.x+=sign*(fram.size.width*-((2-(i%5))*0.25));
            fram.origin.y+=sign*(fram.size.height*-((2-(i/5))*0.25));
            fram.size.height*=2.0/3.0;
            fram.size.width*=2.0/3.0;
            cell.frame=fram;
        }
        [UIView commitAnimations];
        [self positionChangeFor:cell by:add animated:animate];
        i++;
    }
    
}
-(void)positionChangeFor:(UIView*)view by:(float)add animated:(BOOL) animated
{
    float scale;
    if(animated)
    {
        [UIView beginAnimations : @"Display notif" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:FALSE];
    }
    CGRect temp;
    temp=view.frame;
    float newY=temp.origin.y+add;
    if(add>170)
    {
        scale=90;
        if(([self view].bounds.size.width/2)>temp.origin.x)
            temp.origin.x+=scale;
        else
            temp.origin.x-=scale;
    }
    else if(add<(-170))
    {
        scale=-90;
        if(([self view].bounds.size.width/2)>temp.origin.x)
            temp.origin.x+=scale;
        else
            temp.origin.x-=scale;
    }
    temp.origin.y=newY;
    view.frame=temp;
    if(animated)
        [UIView commitAnimations];
}





//set player turn and text
-(void)setPlayerTurnForMultiplayer
{
    //    NSLog(@"GAMETYPE IS :%@",_gameType);
    if([_gameType isEqualToString:@"Mutliplayer"])
    {
        //        if (![myPeerID isEqual:player])
        if (![self.appDelegate.mpcHandler.peerID isEqual:currentPlayer])
        {
            playerTurn.text=[NSString stringWithFormat:@"Its %@'s turn",[self getFilteredName:currentPlayer.displayName]];
            self.view.userInteractionEnabled=NO;
        }
        else
        {
            playerTurn.text=@"Its your turn";
            self.view.userInteractionEnabled=YES;
            
        }
        //        NSLog(@"Player:%@,text:%@",currentPlayer.displayName,playerTurn.text);
        
    }
    playerTurn.font = [self myFontWithSize:19];
    playerTurn.textColor=theme.gameFontColor;
    [self adjustTurnLabel:19 forLabel:playerTurn];
    
}

//Adjust playerturn label
-(void)adjustTurnLabel:(CGFloat)fontSize forLabel:(UILabel *)changeLabel
{
    
    CGSize myStringSize =[changeLabel.text  sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:fontSize]
                                                                  }];
    changeLabel.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2,0,2*myStringSize.width , myStringSize.height);
}


- (UIButton *)viewWithTagForButton:(NSString*)tags
{
    
    NSMutableArray * _buttons1_25=[[tempArray objectAtIndex:0]valueForKey:@"button"];
    for (UIButton *subView in _buttons1_25)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            if ([subView.titleLabel.text isEqualToString:tags])
            {
                return subView;
                break;
            }
        }
    }
    
    return nil;
}

-(void) setHiddenForCpuGrid:(BOOL) visibility
{
    for (UIView *subView in _scrollView.subviews)
    {
        if ([subView isKindOfClass:[UIView class]])
        {
            if (subView.tag==2)
            {
                subView.hidden=visibility;
                break;
            }
        }
    }
}


-(UIView *) getViewForTag:(NSUInteger) myTag
{
    for (UIView *subView in _scrollView.subviews)
    {
        if ([subView isKindOfClass:[UIView class]])
        {
            if (subView.tag==myTag)
            {
                return subView;
                break;
            }
        }
    }
    
    return nil;
}


-(UIButton *) getButtonForTag:(NSUInteger) myTag InView:(UIView *)myView
{
    
    //    NSLog(@"%@",myView.subviews);
    for (UIButton *subView in myView.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            if (subView.tag==myTag)
            {
                return subView;
                break;
            }
        }
    }
    
    return nil;
}



-(void)addDetailToScroll
{
    NSMutableArray *playerScore=[[NSMutableArray alloc]init];
    [playerScore addObject:[@{
                              @"label":@"Your Score",
                              @"value":[NSString stringWithFormat:@"%d",highScore]
                              } mutableCopy]] ;
    
    [playerScore addObject:[@{
                              @"label":@"Win Streak",
                              @"value":[NSString stringWithFormat:@"%d",playerWinStreak]
                              } mutableCopy]] ;
    
    [playerScore addObject:[@{
                              @"label":@"Level",
                              @"value":_difficultyLevel
                              } mutableCopy]] ;
    float y=[self getViewForTag:2].frame.origin.y+[self getViewForTag:2].frame.size.height+5;
    
    CGSize myStringSize;
    NSString *labels;
    
    for (NSUInteger i=0;i<playerScore.count;i++)
    {
        labels=[NSString stringWithFormat:@"%@ : ",[[playerScore objectAtIndex:i]valueForKey:@"label"]];
        myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:30]
                                                     }];
        
        playerlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y,myStringSize.width , myStringSize.height)];
        playerlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        playerlabel.backgroundColor = [UIColor clearColor];
        playerlabel.text=labels;
        playerlabel.font = [self myFontWithSize:25];
        playerlabel.textColor=theme.gameFontColor;
        
        labels=[[playerScore objectAtIndex:i]valueForKey:@"value"];
        myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:30]
                                                     }];
        
        scorelabel = [[UILabel alloc] initWithFrame:CGRectMake(playerlabel.frame.origin.x+playerlabel.frame.size.width, y,myStringSize.width ,  myStringSize.height)];
        scorelabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        scorelabel.backgroundColor = [UIColor clearColor];
        scorelabel.text=labels;
        scorelabel.font = [self myFontWithSize:25];
        scorelabel.textColor=theme.gameFontColor;
        
        y+=50;
        [_scrollView addSubview:playerlabel];
        [_scrollView addSubview:scorelabel];
        NSLog(@"Scrollview size(%f,%f,%f)--scorelabel-%f",_scrollView.contentSize.width,_scrollView.contentSize.height,_scrollView.frame.size.height,scorelabel.frame.origin.y+scorelabel.frame.size.height);
    }
    
}

-(void) checkForWinStatus
{
    
    
    if (bingo>=5)
    {
        continuePlay=NO;
        markForOther=NO;
        
        if([_gameType isEqualToString:@"Single"])
        {
            BOOL gotHighScore=NO;
            
            [self markForPlayers];
            //            playerTurn.hidden=YES;
            
            playerTurn.text=[NSString stringWithFormat:@"%@'s Grid",[self getFilteredName:[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"]]];
            
            cpuLabel.text=@"CPU's Grid";
            [cpuLabel setTextColor:theme.gameFontColor];
            cpuLabel.font = [self myFontWithSize:19];
            [self adjustTurnLabel:19 forLabel:cpuLabel];
            cpuLabel.frame=CGRectMake(cpuLabel.frame.origin.x,cpuLabel.frame.origin.y+20,cpuLabel.frame.size.width,cpuLabel.frame.size.height);
            //            self.navigationItem.rightBarButtonItem = restartButton;
            [self.navigationItem.leftBarButtonItem setEnabled:NO];
            [self setHiddenForCpuGrid:NO];
            UIView *myView=[self getViewForTag:2];
            
            //            myView.frame=CGRectMake(myView.frame.origin.x,myView.frame.origin.y+20,myView.frame.size.width,myView.frame.size.height);
            _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, myView.frame.origin.y+myView.frame.size.height+myView.frame.size.height);///2);
            //            _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, 1000);
            _scrollView.scrollEnabled=TRUE;
            
            //            NSLog(@"%f,%f",_scrollView.contentSize.width,_scrollView.contentSize.height);
            
            [[self getViewForTag:1] setUserInteractionEnabled:NO];
            [[self getViewForTag:2] setUserInteractionEnabled:NO];
            //            [self changePos:-100 animated:YES forButtons:[[bingoButtons objectAtIndex:0]valueForKey:@"button"]];
            
            
            playerWinStreak+=1;
            highScore+=(5-(_cpuTextPlayer.text.length)+1)*playerWinStreak;
            
            NSMutableArray *highscoresArray=[self fetchHighScores];
            
            if (!highscoresArray.count)
            {
                gotHighScore=YES;
            }
            else
            {
                Entity *highScores=[highscoresArray objectAtIndex:0];
                
                if (highScore>[[highScores score] intValue])
                {
                    gotHighScore=YES;
                }
                else
                {
                    gotHighScore=NO;
                }
                
            }
            
            if ([singlePlayerResult isEqualToString:@"player"])
            {
                NSString *score=[NSString stringWithFormat:@"%d",highScore];
                NSString *winstreak=[NSString stringWithFormat:@"%d",playerWinStreak];
                
                scoreAlert=[[ScoreAlertPopUpView alloc]initWithdelegate:self HasPlayerWon:YES isHighScore:gotHighScore PlayerScore:score WinStreak:winstreak PlayerGrid:[self getViewForTag:1] CPUGrid:[self getViewForTag:2]];
                [scoreAlert show];
                
                [self checkForUnlockStatus];
                
            }
            else
            {
                
                playerWinStreak=0;
                highScore=0;
                
                scoreAlert=[[ScoreAlertPopUpView alloc]initWithdelegate:self HasPlayerWon:NO isHighScore:NO PlayerScore:@"0" WinStreak:@"0" PlayerGrid:[self getViewForTag:1] CPUGrid:[self getViewForTag:2]];
                
                [scoreAlert show];
                
                [NSTimer scheduledTimerWithTimeInterval:2
                                                 target:self
                                               selector:@selector(showAd)
                                               userInfo:nil
                                                repeats:NO];
                //                     [self showAd];
                
            }
            
            [self addDetailToScroll];
            
        }
        
        
        
        if(![_gameType isEqualToString:@"Single"])
        {
            
            //            [self showGameOverAlert];
            
            //            NSLog(@"Current Player afterbingo:%@==%@, chance:%@",self.appDelegate.mpcHandler.peerID.displayName, [[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"],[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"playerChance"]);
            
            //            if ([[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"playerChance"] boolValue])
            //            {
            //                UIAlertView *mav = [[UIAlertView alloc]initWithTitle:@"BINGO!!!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //                [mav show];
            //            }
            
            [self modifyDetailsValuesForPeer:self.appDelegate.mpcHandler.peerID.displayName ForKey:@"winStatus" WithValue:YES];
            
            [self modifyDetailsValuesForPeer:self.appDelegate.mpcHandler.peerID.displayName ForKey:@"gameOver" WithValue:YES];
            
            [[noOfPlayers objectAtIndex:iValue-1] setObject:@(YES) forKey:@"playerChance"];
            
            [self assingGridValuesForPeer:self.appDelegate.mpcHandler.peerID.displayName WithView:[self getViewForTag:1]];
            
            
            for (int i=0;i<noOfPlayers.count; i++)
            {
                
                [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"playerReady"];
            }
            
            
            //            NSLog(@"noOfPlayers:%@",noOfPlayers);
            
            randomIndex=arc4random()%(noOfPlayers.count);
            
            dataToSend=[[NSMutableArray alloc]init];
            
            [dataToSend addObject:[@{
                                     @"tag": markedButton,
                                     @"player":self.appDelegate.mpcHandler.peerID.displayName,
                                     @"id":self.appDelegate.mpcHandler.peerID,
                                     @"bingoStatus":noOfPlayers,
                                     @"gridStatus":@(0),
                                     @"randomIndex":@(randomIndex)
                                     } mutableCopy]] ;
            
            [self sendDataToPeers];
            
        }
    }
    else
    {
        continuePlay=YES;
    }
    
    
    
    
    //    NSMutableArray *playerTitle=[[NSMutableArray alloc]init];
    //
    //    for (NSUInteger i=0;i<noOfPlayers.count;i++)
    //    {
    //        [playerTitle addObject:[@{
    //                                  @"player":[[noOfPlayers objectAtIndex:i] valueForKey:@"player"],
    //                                  @"id":[[noOfPlayers objectAtIndex:i] valueForKey:@"id"],
    //                                  @"count":[NSNumber numberWithInteger:0],
    //                                  } mutableCopy]] ;
    //    }
    
    
}

//Send data to other peers

-(void)sendDataToPeers
{
    if (arrConnectedDevices.count)
    {
        //  Convert text to NSData
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataToSend];
        
        
        //  Send data to connected peers
        NSError *error;
        //            [mySession sendData:data toPeers:[mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
        
        //        NSLog(@"CONNECTED PEERS:%@==noOfplayers:%@",self.appDelegate.mpcHandler.session.connectedPeers,noOfPlayers);
        
        [self.appDelegate.mpcHandler.session sendData:data
                                              toPeers:self.appDelegate.mpcHandler.session.connectedPeers
                                             withMode:MCSessionSendDataReliable
                                                error:&error];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Connection Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    
}


//Restart game for single player
-(void)restartButtonAction
{
    
    for (id btn in self.scrollView.subviews)
    {
        
        //            if (![btn isKindOfClass:[UIImageView class]])
        //            {
        [btn removeFromSuperview]; //remove buttons
        //            }
        
    }
    
    if(![_gameType isEqualToString:@"Single"])
    {
        if (noOfPlayers.count<2)
        {
            if (self.appDelegate.mpcHandler.session)
            {
                [self.appDelegate.mpcHandler.session disconnect];
            }
            self.appDelegate.mpcHandler.browser=nil;
            self.appDelegate.mpcHandler.advertiser=nil;
            self.appDelegate.mpcHandler.session=nil;
            self.appDelegate.mpcHandler.peerID=nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            gameRestart=YES;
            playerTurn.hidden=NO;
            
            for (int i=0; i<noOfPlayers.count; i++)
            {
                
                [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"winStatus"];
                [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"gameOver"];
                [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"playerChance"];
                [[noOfPlayers objectAtIndex:i] setObject:[[UIView alloc]init] forKey:@"playerGrid"];
            }
            
            NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"player" ascending:YES];
            [noOfPlayers sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
            
            NSLog(@"RANDOM INDEX IS:%d",randomIndex);
            currentPlayer=[[noOfPlayers objectAtIndex:randomIndex] valueForKey:@"id"];
            
            [self modifyDetailsValuesForPeer:self.appDelegate.mpcHandler.peerID.displayName ForKey:@"playerReady" WithValue:YES];
            
            
            if([self checkPlayerReadyStatus])
            {
                [appObject hideIndicator];
            }
            
            else
            {
                
                [appObject showIndicator:@"Waiting for opponent to join"];
            }
            
            dataToSend=[[NSMutableArray alloc]init];
            
            [dataToSend addObject:[@{
                                     @"tag": @"",
                                     @"player":self.appDelegate.mpcHandler.peerID.displayName,
                                     @"id":self.appDelegate.mpcHandler.peerID,
                                     @"bingoStatus":noOfPlayers,
                                     @"gridStatus":@(2),
                                     @"randomIndex":@(randomIndex)
                                     } mutableCopy]] ;
            
            [self sendDataToPeers];
            
        }
    }
    
    
    [self initiatePlay];
    self.navigationItem.rightBarButtonItem = nil;
}



-(void)showResultAlert:(NSMutableArray *)playerInfo
{
    resultAlert=[[FinalScoreView alloc]initWithdelegate:self withDetails:playerInfo];
    [resultAlert show];
}


//To show game over alert
-(void) showGameOverAlert
{
    playerTurn.hidden=YES; NSString *message=@"";
    
    NSMutableArray *nameArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<noOfPlayers.count; i++)
    {
        if ([[[noOfPlayers objectAtIndex:i]valueForKey:@"winStatus"] boolValue])
        {
            //            message=[message stringByAppendingString:[NSString stringWithFormat:@"%@ ",[self getFilteredName:[[noOfPlayers objectAtIndex:i]valueForKey:@"player"]]]];
            
            [nameArray addObject:[[noOfPlayers objectAtIndex:i]valueForKey:@"player"]];
        }
    }
    
    
    if (!nameArray.count)
    {
        message=@"You ";
    }
    else
    {
        for (int i=0;i<nameArray.count-1; i++)
        {
            message=[message stringByAppendingString:[NSString stringWithFormat:@"%@, ",[self getFilteredName:[nameArray objectAtIndex:i]]]];
        }
        
        NSLog(@"Message:%@-length:%lu",message, (unsigned long)message.length);
        
        if (message.length>2)
        {
            message= [message substringToIndex:message.length-2];
        }
        
        
        NSLog(@"Message:%@",message);
        
        if (nameArray.count==1)
        {
            message=[message stringByAppendingString:[NSString stringWithFormat:@"%@ ",[self getFilteredName:[nameArray objectAtIndex:nameArray.count-1]]]];
            
            if ([self.appDelegate.mpcHandler.peerID.displayName isEqualToString:[nameArray objectAtIndex:nameArray.count-1]])
            {
                message=@"You ";
            }
        }
        else
        {
            message=[message stringByAppendingString:[NSString stringWithFormat:@" & %@ ",[self getFilteredName:[nameArray objectAtIndex:nameArray.count-1]]]];
        }
    }
    message=[message stringByAppendingString:@"Won the Game"];
    
    //        if (!message.length)
    //        {
    //            message=@"You Won the Game";
    //        }
    //        else
    //        {
    //            message=[message stringByAppendingString:@"Won the Game"];
    //        }
    
    if (myresultAlert)
    {
        [myresultAlert dismissWithClickedButtonIndex:0 animated:NO];
    }
    
    
    myresultAlert = [[UIAlertView alloc]initWithTitle:@"GAME OVER" message:message delegate:self cancelButtonTitle:@"Show Result" otherButtonTitles:nil];
    myresultAlert.tag=800;
    [myresultAlert show];
    
    [self.view setUserInteractionEnabled:YES];
}

-(void)modifyDetailsValuesForPeer:(NSString *)peerDisplayName ForKey:(NSString *)arrayKey WithValue:(BOOL) value
{
    
    for (int i=0; i<noOfPlayers.count; i++)
    {
        if ([[[noOfPlayers objectAtIndex:i]valueForKey:@"player"] isEqualToString:peerDisplayName])
        {
            [[noOfPlayers objectAtIndex:i] setObject:@(value) forKey:arrayKey];
            break;
        }
    }
    
    
}

//Check for gameover
-(BOOL)checkForGameOver
{
    BOOL showFinalAlert=YES;
    for (int i=0; i<noOfPlayers.count; i++)
    {
        if (![[[noOfPlayers objectAtIndex:i] valueForKey:@"gameOver"] boolValue])
        {
            showFinalAlert=NO;
            break;
        }
        
    }
    
    return showFinalAlert;
}


//Check if all players are ready for restarting game
-(BOOL)checkPlayerReadyStatus
{
    BOOL readyStatus=YES;
    
    for (int i=0; i<noOfPlayers.count; i++)
    {
        if (![[[noOfPlayers objectAtIndex:i]valueForKey:@"playerReady"] boolValue])
        {
            readyStatus=NO;
            break;
        }
    }
    
    return readyStatus;
}


//To check if level is unlocked
-(void)checkForUnlockStatus
{
    if ([[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Medium"] && [_difficultyLevel isEqualToString:@"Easy"])
    {
        if (playerWinStreak>=UNLOCKLIMITMEDIUM)
        {
            [Reusables storeDataToDefaults:LOCKED_STATUS objectToAdd:@"Hard"];
            
            alertPopUp = [[UIAlertView alloc] initWithTitle:@"Congratulation!!!" message:@"Medium Level is now unlocked." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [alertPopUp show];
            [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(showUnlockAlert)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
    else if ([[Reusables getDefaultValue:LOCKED_STATUS] isEqualToString:@"Hard"] && [_difficultyLevel isEqualToString:@"Medium"])
    {
        if (playerWinStreak>=UNLOCKLIMITHARD)
        {
            [Reusables storeDataToDefaults:LOCKED_STATUS objectToAdd:@"Unlocked"];
            
            alertPopUp = [[UIAlertView alloc] initWithTitle:@"Congratulation!!!" message:@"Hard Level is now unlocked." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [alertPopUp show];
            [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(showUnlockAlert)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
    
}

//To show unlock alert
-(void)showUnlockAlert
{
    [alertPopUp dismissWithClickedButtonIndex:1 animated:YES];
}

//To fill player grid details to pass between peers
-(void)assingGridValuesForPeer:(NSString *)peerDisplayName WithView:(UIView *)gridView
{
    
    for (int i=0; i<noOfPlayers.count; i++)
    {
        if ([[[noOfPlayers objectAtIndex:i]valueForKey:@"player"] isEqualToString:peerDisplayName])
        {
            UIView *myview=[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:gridView]];
            [[noOfPlayers objectAtIndex:i] setObject:myview forKey:@"playerGrid"];
            break;
        }
    }
    
    
}


//To show ripple animation

-(void) beginRippleAnimation:(UIButton *)sender
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];//UIViewAnimationCurveEaseInOut
    [animation setType:@"rippleEffect" ];
    [sender.layer addAnimation:animation forKey:NULL];
}

-(void)closeButtonPressed:(UIButton *)popView
{
    self.navigationItem.rightBarButtonItem = restartButton;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.view setUserInteractionEnabled:NO];
    //    NSLog(@"Views:%@",_scrollView.subviews);
}

#pragma mark -
#pragma mark - Insert values to High Score Data base

-(void)insertHighScore:(NSString *)playerName
{
    Entity *score = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:__managedObjectContext];
    
    [score setPlayername:playerName];
    [score setLevel:_difficultyLevel];
    [score setScore:@(highScore)];
    [score setWinstreaks:@(playerWinStreak)];
    
    NSError *error;
    if(![__managedObjectContext save:&error ])
    {
        //manage the error
        UIAlertView *mav = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to save score." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mav show];
    }
    else
    {
        UIAlertView *mav = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Score Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mav show];
    }
    
    NSMutableArray *deleteCheck=[self fetchHighScores];
    
    NSLog(@"highscore count:%lu for difficulty :%@",(unsigned long)deleteCheck.count,_difficultyLevel);
    
    while (deleteCheck.count>HIGHSCORELIMIT)
    {
        [__managedObjectContext deleteObject:[deleteCheck objectAtIndex:HIGHSCORELIMIT]];
        [deleteCheck removeObjectAtIndex:HIGHSCORELIMIT];
        
        NSError *error;
        if(![__managedObjectContext save:&error ])
        {
            //Handling error
            NSLog(@"Failed to delete");
        }
    }
    
    
}

-(NSMutableArray *) fetchHighScores
{
    //Grab Data
    
    NSFetchRequest *request = [[NSFetchRequest alloc ]init];
    NSEntityDescription *scores=[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:__managedObjectContext];
    [request setEntity:scores];
    //For sorting according to array object
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDesc, nil];
    [request setSortDescriptors:sortArray];
    //    [request setFetchLimit:1];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"level == %@", _difficultyLevel];
    [request setPredicate:predicate];
    NSError *error=nil;
    NSMutableArray *mutbleArray = [[__managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if(mutbleArray==nil)
    {
        NSLog(@"No highscores recorded");
    }
    else
    {
        //        NSLog(@"%@",mutbleArray);
        //
        //        for(Entity *highscores in mutbleArray)
        //        {
        //            NSLog(@"\nplayername:%@ \n score:%@, \n winstreak:%@, \n level:%@, \n id:%@",[highscores playername],[highscores score],[highscores winstreaks], [highscores level],[highscores id]);
        //        }
    }
    
    return mutbleArray;
}


#pragma mark -
#pragma mark - Mulitplayer methods
-(void) setUpMultipeer
{
    
    
    NSString *idAndname=[NSString stringWithFormat:@"%@$#$#$-%@",[Reusables getDefaultValue:PLAYER_NAME],[self getDeviceId]];
    
    [self.appDelegate.mpcHandler setupPeerWithDisplayName:idAndname];
    [self.appDelegate.mpcHandler setupSession];
    [self.appDelegate.mpcHandler advertiseSelf:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerChangedStateWithNotification:)
                                                 name:@"MPCDemo_DidChangeStateNotification"
                                               object:nil];
}

-(void) showBrowserVC
{
    if (self.appDelegate.mpcHandler.session != nil) {
        [[self.appDelegate mpcHandler] setupBrowser];
        [[[self.appDelegate mpcHandler] browser] setDelegate:self];
        
        [self presentViewController:self.appDelegate.mpcHandler.browser
                           animated:YES
                         completion:^{
                             [self createButtonsView:CGPointMake(0, 0) withTag:1 forPlayer:1];
                             tempArray=[bingoButtons mutableCopy];
                         }];
    }
}

- (void) dismissBrowserVC
{
    NSLog(@"noOfPlayers:%ld",(unsigned long)noOfPlayers.count);
    //    [browserVC dismissViewControllerAnimated:YES completion:nil];
    [self.appDelegate.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
    if (noOfPlayers.count>MAXSUPPORTEDPLAYERS)
    {
        UIAlertView *mav = [[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"Max Supported players is %d",MAXSUPPORTEDPLAYERS] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        mav.tag=789;
        [mav show];
    }
    else if (noOfPlayers.count==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -
#pragma mark -Custom Popup delegates

-(void) popCloseButtonPressed:(UIButton *)popView
{
    
}


#pragma mark -
#pragma mark -Custom Popup ScoreAlert delegates

-(void) keepGoingButtonPressed:(UIButton *)popView
{
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self restartButtonAction];
}


-(void) quitButtonPressed:(UIButton *)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButtonPressed:(UIButton *)popView
{
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Enter Your Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    av.tag=111;
    [av show];
    
}

-(void)shareButtonPressed:(UIButton *)popView
{
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:theme.mainBackground]]];
    [[self getViewForTag:1] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:theme.mainBackground]]];
    [[self getViewForTag:2] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:theme.mainBackground]]];
    //    CGSize imageSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    //    UIGraphicsBeginImageContext(imageSize);
    //    [self.scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *postImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    UIImage *postImage = nil;
    //    UIGraphicsBeginImageContext(_scrollView.contentSize);
    UIGraphicsBeginImageContextWithOptions(_scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        postImage = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    NSString *postText =@"";
    if (highScore)
    {
        postText = [NSString stringWithFormat:@"I scored %d pts at Bingo. You should check this out, its fun.",highScore];
    }
    else
    {
        postText =@"Hey! this checkout, I'm playing bingo and its fun!!!";
    }
    
    //    UIImage *postImage = [UIImage imageNamed:@"xmas-bg"];
    NSURL *postURL = [NSURL URLWithString:@"www.google.com"];
    NSArray *activityItems = @[postText, postImage, postURL];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    controller.excludedActivityTypes = @[ UIActivityTypeMessage ,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:controller animated:YES completion:nil];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [[self getViewForTag:1] setBackgroundColor:[UIColor clearColor]];
    [[self getViewForTag:2] setBackgroundColor:[UIColor clearColor]];
}


-(void)submitScorePressed:(UIButton *)popView
{
    
//    showAlert(nil, @"Score Recorded", @"Ok",nil);
}

#pragma mark -
#pragma mark - UITextfield Delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}



#pragma mark -
#pragma mark - Alert view delegate Actions
//Alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 789)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([alertView tag]==790)
    {
        if (!firstPlayer)
        {
            [self.view setUserInteractionEnabled:NO];
            [self playForCpu];
            
        }
        else
        {
            [self.view setUserInteractionEnabled:YES];
        }
    }
    else if ([alertView tag]==800)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self showResultAlert:noOfPlayers];
    }
    else if ([alertView tag] == 111)
    {
        if ([[[alertView textFieldAtIndex: 0] valueForKey:@"text"] length]<3)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Name should contain atleast 3 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            av.tag=222;
            [av show];
        }
        else
        {
            [self insertHighScore:[[alertView textFieldAtIndex: 0] valueForKey:@"text"]];
            
            NSString *lID = [NSString stringWithFormat:@"com.cabot.Bingo.HighScore%@",_difficultyLevel];
            [[GameCenterManager sharedManager] saveAndReportScore:highScore leaderboard:lID sortOrder:GameCenterSortOrderHighToLow];
            
        }
        
    }
    else if([alertView tag] == 222)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Enter Your Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].delegate = self;
        av.tag=111;
        [av show];
    }
}


#pragma mark -
#pragma mark - MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
    //    [self getNumberOfDots];
    [self setPlayerTurnForMultiplayer];
    self.navigationItem.rightBarButtonItem=nil;
    //
    //    if (playerMarked.count)
    //    {
    //        [self sendButtonAction:[self viewWithTagForButton:initialMarkedButton]];
    //        playerMarked=nil;
    //    }
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
}


#pragma mark -
#pragma mark- Get Device UUID
-(NSString *)getDeviceId
{
    NSString *deviceToken=[[NSUserDefaults standardUserDefaults] valueForKey:@"UniqueId"];
    if(deviceToken.length>1)
        return deviceToken;
    else
    {
        NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"UniqueId"];
        if (!identifier)
        {
            CFUUIDRef uuidRef = CFUUIDCreate(NULL);
            CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
            CFRelease(uuidRef);
            identifier = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
            CFRelease(uuidStringRef);
            [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"UniqueId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return identifier;
    }
}



#pragma mark -
#pragma mark Notification Handling
- (void)handleReceivedDataWithNotification:(NSNotification *)notification
{
    
    // Get the user info dictionary that was received along with the notification.
    NSDictionary *userInfoDict = [notification userInfo];
    
    // Convert the received data into a NSString object.
    NSData *data = [userInfoDict objectForKey:@"data"];
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    MCPeerID *peerID = [userInfoDict objectForKey:@"peerID"];
    
    //    NSLog(@"Peer IDs-%@==%@",peerID,[[array objectAtIndex:0] valueForKey:@"id"]);
    //
    //    NSLog(@"Receiving data--User:%@,tag:%@ bingostatus:%@,playerChance:%@,player:%@,ivalue:%lu",[[array objectAtIndex:0] valueForKey:@"player"],[[array objectAtIndex:0] valueForKey:@"tag"],[[array objectAtIndex:0] valueForKey:@"bingoStatus"],[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"playerChance"],[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"player"],(unsigned long)iValue);
    
    NSMutableArray *playerArray=[[[array objectAtIndex:0] valueForKey:@"bingoStatus"] mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        NSLog(@"grid status:%c,noofplayer count:%lu",[[[array objectAtIndex:0] valueForKey:@"gridStatus"] boolValue],(unsigned long)playerArray.count);
        if([[[array objectAtIndex:0] valueForKey:@"gridStatus"] intValue]==0)
        {
            if (playerArray.count)
            {
                
                
                NSMutableArray *temp=[noOfPlayers mutableCopy];
                
                noOfPlayers=playerArray;
                
                for (int i=0;i<noOfPlayers.count; i++)
                {
                    
                    //                    if ([[[noOfPlayers objectAtIndex:i] valueForKey:@"winStatus"] boolValue]|| [[[temp objectAtIndex:i] valueForKey:@"winStatus"] boolValue])
                    //                    {
                    //                        [[noOfPlayers objectAtIndex:i] setObject:@(YES) forKey:@"winStatus"];
                    //                    }
                    //                    else
                    //                    {
                    //                        [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"winStatus"];
                    //                    }
                    
                    [[noOfPlayers objectAtIndex:i] setObject:@([[[noOfPlayers objectAtIndex:i] valueForKey:@"winStatus"] boolValue]|| [[[temp objectAtIndex:i] valueForKey:@"winStatus"] boolValue]) forKey:@"winStatus"];
                    
                    [[noOfPlayers objectAtIndex:i] setObject:@([[[noOfPlayers objectAtIndex:i] valueForKey:@"gameOver"] boolValue]|| [[[temp objectAtIndex:i] valueForKey:@"gameOver"] boolValue]) forKey:@"gameOver"];
                    
                    [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"playerReady"];
                }
                
                
                //                NSLog(@"NOofplayers After:%@",noOfPlayers);
                
                continuePlay=NO;
                
                randomIndex=[[[array objectAtIndex:0] valueForKey:@"randomIndex"] intValue];
                
                [self receiveAction:[self viewWithTagForButton:[[array objectAtIndex:0] valueForKey:@"tag"]] fromPeer:peerID];
                
                [self assingGridValuesForPeer:self.appDelegate.mpcHandler.peerID.displayName WithView:[self getViewForTag:1]];
                
                [self modifyDetailsValuesForPeer:self.appDelegate.mpcHandler.peerID.displayName ForKey:@"gameOver" WithValue:YES];
                
                
                
                dataToSend=[[NSMutableArray alloc]init];
                
                [dataToSend addObject:[@{
                                         @"tag": [[array objectAtIndex:0] valueForKey:@"tag"],
                                         @"player":self.appDelegate.mpcHandler.peerID.displayName,
                                         @"id":self.appDelegate.mpcHandler.peerID,
                                         @"bingoStatus":noOfPlayers,
                                         @"gridStatus":@(1),
                                         @"randomIndex":@(randomIndex)
                                         } mutableCopy]] ;
                [self sendDataToPeers];
                
                
                NSLog(@"INSIDE LOSERS GRID,Bingo text:%@",_bingoTextPlayer.text);
                NSLog(@"DATA SEND:%@",dataToSend);
                NSLog(@"Array before Final Alert:%@",noOfPlayers);
                
                
                BOOL showFinalWinAlert=YES;
                for (int i=0;i<noOfPlayers.count; i++)
                {
                    if (![[[noOfPlayers objectAtIndex:i] valueForKey:@"gameOver"] boolValue])
                    {
                        showFinalWinAlert=NO;
                        break;
                    }
                }
                
                if (showFinalWinAlert)
                {
                    NSLog(@"Last DATA SEND:%@",dataToSend);
                    NSLog(@"Losing Array before Final Alert:%@",noOfPlayers);
                    [self showGameOverAlert];
                    
                }
            }
            else
            {
                [self receiveAction:[self viewWithTagForButton:[[array objectAtIndex:0] valueForKey:@"tag"]] fromPeer:peerID];
            }
            
        }
        else if ([[[array objectAtIndex:0] valueForKey:@"gridStatus"] intValue]==2)
            
        {
            NSMutableArray *myTempArray=[[[array objectAtIndex:0] valueForKey:@"bingoStatus"] mutableCopy];
            
            for (int i=0;i<noOfPlayers.count; i++)
            {
                
                if ([[[noOfPlayers objectAtIndex:i] valueForKey:@"playerReady"] boolValue]|| [[[myTempArray objectAtIndex:i] valueForKey:@"playerReady"] boolValue])
                {
                    [[noOfPlayers objectAtIndex:i] setObject:@(YES) forKey:@"playerReady"];
                }
                else
                {
                    [[noOfPlayers objectAtIndex:i] setObject:@(NO) forKey:@"playerReady"];
                }
                
            }
            
            
            
            if([self checkPlayerReadyStatus])
                [appObject hideIndicator];
            
        }
        else
        {
            NSLog(@"LAST BUTTON IS:%@",[[array objectAtIndex:0] valueForKey:@"tag"]);
            
            NSMutableArray *temp=[[[array objectAtIndex:0] valueForKey:@"bingoStatus"] mutableCopy];
            
            for (int i=0; i<temp.count; i++)
            {
                
                if ([[[temp objectAtIndex:i]valueForKey:@"player"] isEqualToString:[[array objectAtIndex:0] valueForKey:@"player"]])
                {
                    UIView *grid=[[temp objectAtIndex:i]valueForKey:@"playerGrid"];
                    [self assingGridValuesForPeer:[[array objectAtIndex:0] valueForKey:@"player"] WithView:grid];
                    break;
                }
            }
            
            for (int i=0;i<noOfPlayers.count; i++)
            {
                [[noOfPlayers objectAtIndex:i] setObject:@([[[noOfPlayers objectAtIndex:i] valueForKey:@"gameOver"] boolValue]|| [[[temp objectAtIndex:i] valueForKey:@"gameOver"] boolValue]) forKey:@"gameOver"];
            }
            
            
            BOOL showFinalWinAlert=YES;
            for (int i=0;i<noOfPlayers.count; i++)
            {
                if (![[[noOfPlayers objectAtIndex:i] valueForKey:@"gameOver"] boolValue])
                {
                    showFinalWinAlert=NO;
                    break;
                }
            }
            
            if (showFinalWinAlert)
            {
                NSLog(@"Winning Array before Final Alert:%@",noOfPlayers);
                [self showGameOverAlert];
                
            }
        }
    });
    //    }
}



- (void)peerChangedStateWithNotification:(NSNotification *)notification
{
    // Get the state of the peer.
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state != MCSessionStateConnecting) {
            if (state == MCSessionStateConnected)
            {
                //NSLog(@"sessionID:%@",session.securityIdentity);
                [arrConnectedDevices addObject:peerID];
                [noOfPlayers addObject:[@{
                                          @"player":peerID.displayName,
                                          @"id":peerID,
                                          @"playerChance":@(NO),
                                          @"winStatus":@(NO),
                                          @"playerReady":@(NO),
                                          @"gameOver":@(NO),
                                          @"playerGrid":[[UIView alloc]init]
                                          } mutableCopy]] ;
                
                
                NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"player" ascending:YES];
                [noOfPlayers sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
                currentPlayer=[[noOfPlayers objectAtIndex:0] valueForKey:@"id"];
                
            }
            else if (state == MCSessionStateNotConnected){
                if ([arrConnectedDevices count] > 0 && [self connectedDeviceContainsPeer:peerID]) {
                    NSUInteger indexOfPeer = [arrConnectedDevices indexOfObject:peerID];
                    
                    
                    [arrConnectedDevices removeObjectAtIndex:indexOfPeer];
                    
                    for (NSUInteger i=0;i<noOfPlayers.count; i++)
                    {
                        if([[[noOfPlayers objectAtIndex:i]valueForKey:@"id"] isEqual:peerID])
                        {
                            [noOfPlayers removeObjectAtIndex:i];
                            break;
                        }
                    }
                    
                    NSString *disconnectedPlayer=[NSString stringWithFormat:@"Connection lost with %@.",[self getFilteredName:peerID.displayName]];
                    
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:disconnectedPlayer delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    
                    
                    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"player" ascending:YES];
                    [noOfPlayers sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
                    if (iValue>1)
                        iValue--;
                    currentPlayer=[[noOfPlayers objectAtIndex:iValue-1] valueForKey:@"id"];
                    [self setPlayerTurnForMultiplayer];
                    [appObject hideIndicator];
                }
            }
        }
        
    });
}

-(BOOL)connectedDeviceContainsPeer:(MCPeerID *)peerIDs
{
    
    NSLog(@"Connected devices:%@--%@",arrConnectedDevices,peerIDs);
    
    for (MCPeerID * peer in arrConnectedDevices)
    {
        if (peer==peerIDs)
        {
            return YES;
        }
    }
    
    
    return NO;
}


#pragma mark -
#pragma mark iAd Custom methods


//-(void) showInterstitialAd
//{
//   self.interstitialPresentationPolicy =
//        ADInterstitialPresentationPolicyAutomatic;
//
//}
//Interstitial iAd


#pragma mark - GCTurnBasedMatchHelperDelegate


-(void)checkForEnding:(NSData *)matchData {
    
    NSLog(@"Match Data:%@",matchData);
//    if ([matchData length] > 3000) {
//        statusLabel.text = [NSString stringWithFormat:@"%@, only about %d letter left", statusLabel.text, 4000 - [matchData length]];
//    }
}

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    //    statusLabel.text = @"Player 1's Turn (that's you)";
    //    textInputField.enabled = YES;
    //    mainTextController.text = @"Once upon a time";
}

-(void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"Taking turn for existing game...");
//    int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
//    NSString *statusString = [NSString stringWithFormat:@"Player %d's Turn (that's you)", playerNum];
    //    statusLabel.text = statusString;
    //    textInputField.enabled = YES;
    if ([match.matchData bytes]) {
//        NSMutableArray *storySoFar = [NSString stringWithUTF8String:[match.matchData bytes]];
//        mainTextController.text = storySoFar;
        NSData *data = match.matchData;
        
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSLog(@"unarchived data :%@",array);
        
        [self checkForEnding:match.matchData];
    }
}

-(void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } else {
//        int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
//        statusString = [NSString stringWithFormat:@"Player %d's Turn", playerNum];
    }
//    statusLabel.text = statusString;
//    textInputField.enabled = NO;
//    NSString *storySoFar = [NSString stringWithUTF8String:[match.matchData bytes]];
//    mainTextController.text = storySoFar;
    
    NSData *data = match.matchData;
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"unarchived data :%@",array);
    
    [self checkForEnding:match.matchData];
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!" message:notice delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
    [av show];
}

-(void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}



//------------------------------------------------------------------------------------------------------------//
//------- GameCenter Manager Delegate ------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
    NSLog(@"GC Availabilty: %@", availabilityInformation);
    if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) {
        [self.navigationController.navigationBar setValue:@"GameCenter Available" forKeyPath:@"prompt"];
//        statusDetailLabel.text = @"Game Center is online, the current player is logged in, and this app is setup.";
    } else {
        [self.navigationController.navigationBar setValue:@"GameCenter Unavailable" forKeyPath:@"prompt"];
//        statusDetailLabel.text = [availabilityInformation objectForKey:@"error"];
    }
    
    GKLocalPlayer *player = [[GameCenterManager sharedManager] localPlayerData];
    if (player) {
        if ([player isUnderage] == NO) {
//            actionBarLabel.title = [NSString stringWithFormat:@"%@ signed in.", player.displayName];
//            playerName.text = player.displayName;
//            playerStatus.text = @"Player is not underage and is signed-in";
            [[GameCenterManager sharedManager] localPlayerPhoto:^(UIImage *playerPhoto) {
//                playerPicture.image = playerPhoto;
            }];
        } else {
//            playerName.text = player.displayName;
//            playerStatus.text = @"Player is underage";
//            actionBarLabel.title = [NSString stringWithFormat:@"Underage player, %@, signed in.", player.displayName];
        }
    } else {
//        actionBarLabel.title = [NSString stringWithFormat:@"No GameCenter player found."];
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
    NSLog(@"GCM Error: %@", error);
//    actionBarLabel.title = error.domain;
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Achievement: %@", achievement);
//        actionBarLabel.title = [NSString stringWithFormat:@"Reported achievement with %.1f percent completed", achievement.percentComplete];
    } else {
        NSLog(@"GCM Error while reporting achievement: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Score: %@", score);
//        actionBarLabel.title = [NSString stringWithFormat:@"Reported leaderboard score: %lld", score.value];
    } else {
        NSLog(@"GCM Error while reporting score: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
    NSLog(@"Saved GCM Score with value: %lld", score.value);
//    actionBarLabel.title = [NSString stringWithFormat:@"Score saved for upload to GameCenter."];
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
    NSLog(@"Saved GCM Achievement: %@", achievement);
//    actionBarLabel.title = [NSString stringWithFormat:@"Achievement saved for upload to GameCenter."];
}



/*
 -(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
 interstitial = nil;
 requestingAd = NO;
 NSLog(@"interstitialAd didFailWithERROR");
 NSLog(@"%@", error);
 }
 
 -(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
 NSLog(@"interstitialAdDidLOAD");
 if (interstitialAd != nil && interstitial != nil && requestingAd == YES) {
 [self requestInterstitialAdPresentation];
 NSLog(@"interstitialAdDidPRESENT");
 }//end if
 }
 
 -(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
 interstitial = nil;
 requestingAd = NO;
 NSLog(@"interstitialAdDidUNLOAD");
 }
 
 -(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
 interstitial = nil;
 requestingAd = NO;
 NSLog(@"interstitialAdDidFINISH");
 }
 
 */
@end
