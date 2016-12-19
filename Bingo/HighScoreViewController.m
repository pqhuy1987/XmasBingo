//
//  HighScoreViewController.m
//  Bingo
//
//  Created by feialoh on 29/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "HighScoreViewController.h"
#import "ThemeModal.h"

#define BANNER_HEIGHT 70.0f

@interface HighScoreViewController ()
{
    BOOL loadingFlag;
    ThemeModal *theme;
    NSString *compareKey,*tempKey;
    NSData *compareData;
    NSMutableArray *tempArray2;
    UIBarButtonItem *rightButton;
    GADBannerView *rectangleAdView;
}
@end

@implementation HighScoreViewController

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
    
    [self showBannerAd];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    __managedObjectContext = [appDelegate managedObjectContext];
    
    [self customizeNavigationBar];
    
    [self fetchData];
    
//    _highScoreTable.frame =CGRectMake(_highScoreTable.frame.origin.x,_highScoreTable.frame.origin.y,_highScoreTable.frame.size.width,[[UIScreen mainScreen] bounds].size.height-150);
//    
//    _clearData.frame=CGRectMake(_clearData.frame.origin.x,_highScoreTable.frame.origin.y+_highScoreTable.frame.size.height+10,_clearData.frame.size.width,_clearData.frame.size.height);
    
    
    if (!_highScoreDetailsArray.count)
    {
        self.navigationItem.rightBarButtonItem=nil;
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightButton;
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_highscoreBackground];
    
//    [_highscoreBackground setImage:[UIImage imageNamed:theme.mainBackground]];
    [_highScoreTable reloadData];
}

-(void)dealloc
{
    rectangleAdView=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Custom Methods
#pragma mark -
- (void) customizeNavigationBar
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationItem.title=@"High Scores";
    
    rightButton = [[UIBarButtonItem alloc] initWithTitle: @"Clear" style: UIBarButtonItemStyleBordered target:self action:@selector(confirmationAlert)];
    
    
}

-(void) fetchData
{
    //Grab Data
    
    NSFetchRequest *request = [[NSFetchRequest alloc ]init];
    NSEntityDescription *cars=[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:__managedObjectContext];
    [request setEntity:cars];
    //For sorting according to array object
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDesc, nil];
    [request setSortDescriptors:sortArray];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"level == %@", _difficultyLevel];
    [request setPredicate:predicate];
    
    NSError *error=nil;
    NSMutableArray *mutbleArray = [[__managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if(mutbleArray==nil)
    {
        //Handle error
    }
    [self setHighScoreDetailsArray:mutbleArray];
    NSLog(@"There are %lu element in Highscore array",(unsigned long)[_highScoreDetailsArray count]);
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (!_highScoreDetailsArray.count)
    {
        return 1;
    }
    
    return _highScoreDetailsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"settingsCell";
    
    static NSString *PlaceholderCellIdentifier = @"placeholderCell";
    
    if (!_highScoreDetailsArray.count)
    {
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        return cell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    Entity *highScores= (Entity *)[_highScoreDetailsArray objectAtIndex:indexPath.row];
    
    UILabel *indexLabel = (UILabel *) [cell viewWithTag:100];
    
//    indexLabel.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
    indexLabel.text=[[highScores winstreaks] stringValue];
    
//    [indexLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:15.0]];
//    [indexLabel setTextColor:theme.gameFontColor];
    
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:200];
    
    nameLabel.text=[highScores playername];
    
//    [nameLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:15.0]];
//    [nameLabel setTextColor:theme.gameFontColor];
    
    
    UIButton *scoreButton= (UIButton *) [cell viewWithTag:300];
    
    [scoreButton addTarget:self action:@selector(scoreButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [scoreButton setTitle:[[highScores score] stringValue] forState:UIControlStateNormal & UIControlStateSelected];
    
    
    return cell;
}


-(void)scoreButtonTouched:(UIButton *)sender
{
    
    
    for(Entity *highscores in _highScoreDetailsArray)
    {
        NSLog(@"\nplayername:%@ \n score:%@, \n winstreak:%@, \n level:%@, \n id:%@",[highscores playername],[highscores score],[highscores winstreaks], [highscores level],[highscores id]);
    }
    
}


//- (IBAction)clearDataAction:(UIButton *)sender

-(void) confirmationAlert
{
 
    UIAlertView *mav = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"This Action cannot be undone, are you sure you want to delete all data?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
    mav.tag=555;
    [mav show];
    
}


-(void)clearDataAction
{
    

    for(NSManagedObject *elementToDelete in _highScoreDetailsArray)
    {
        [__managedObjectContext deleteObject:elementToDelete];
        NSError *error;
        if(![__managedObjectContext save:&error ])
        {
            //Handling error
            NSLog(@"Failed to delete");
        }
        
    }
    
    [_highScoreDetailsArray removeAllObjects];
    
    [self fetchData];
    
    [_highScoreTable reloadData];
    if (!_highScoreDetailsArray.count)
    {
        self.navigationItem.rightBarButtonItem=nil;
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightButton;
    }

}

#pragma mark -
#pragma mark - Alert view delegate Actions
//Alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 555)
    {
        if (buttonIndex==0)
        {
            [self clearDataAction];
        }
        
    }
}

#pragma mark -
#pragma mark Ad Custom methods




-(void) showBannerAd
{

    _highScoreTable.frame=CGRectMake(_highScoreTable.frame.origin.x, _highScoreTable.frame.origin.y, _highScoreTable.frame.size.width, [[UIScreen mainScreen]bounds].size.height-_topLabelView.frame.size.height-BANNER_HEIGHT-self.navigationController.navigationBar.frame.size.height);
    
    rectangleAdView = [[GADBannerView alloc]initWithFrame:
                       CGRectMake(0, _highScoreTable.frame.origin.y+_highScoreTable.frame.size.height, 320, BANNER_HEIGHT-20)];
    
    [rectangleAdView setBackgroundColor:[UIColor clearColor]];
    
    
    rectangleAdView.adUnitID = BANNER_AD_ID;
    rectangleAdView.rootViewController = self;
    [rectangleAdView loadRequest:[GADRequest request]];
    
    [self.view addSubview: rectangleAdView];

    
}



#pragma mark -
#pragma mark ADBannerViewDelegate
/*
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Error loading");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded:%f",banner.frame.size.height);
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
    
}
 */

@end
