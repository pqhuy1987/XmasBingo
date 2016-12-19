//
//  SettingSelectionViewController.m
//  Bingo
//
//  Created by feialoh on 28/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "SettingSelectionViewController.h"
#import "SettingsOptionViewController.h"

@interface SettingSelectionViewController ()
{
    NSString *selectionType;
    ThemeModal *theme;
    
}
@end

@implementation SettingSelectionViewController

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
    [self customizeNavigationBar];
    
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_backgroundView];
    
    if ([[Reusables getDefaultValue:THEME_TYPE] isEqualToString:@"Custom_Theme"])
    {
         _settingTableDetails =[[NSMutableArray alloc]initWithObjects:@"Custom Themes" ,@"Theme Mode",@"Player Name", nil];
    }
    else
    {
        _settingTableDetails =[[NSMutableArray alloc]initWithObjects:@"Themes" ,@"Theme Mode",@"Player Name", nil];
    }
    
    
//    [_backgroundView setImage:[UIImage imageNamed:theme.mainBackground]];
    [_settingSelectTable reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) customizeNavigationBar
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    NSLog(@"NC in change setting selection=%@",self.navigationController);
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationItem.title=@"Settings";
    
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _settingTableDetails.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"settingsCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *categoryNameLabel = (UILabel *) [cell viewWithTag:100];
    
    categoryNameLabel.text=[_settingTableDetails objectAtIndex:indexPath.row];
    
    [categoryNameLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [categoryNameLabel setTextColor:theme.gameFontColor];
    
    
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ is selected.",[_settingTableDetails objectAtIndex:indexPath.row]);
    
    selectionType = [_settingTableDetails objectAtIndex:indexPath.row];
    

    if ([selectionType isEqualToString:@"Themes"] )
    {
        [self performSegueWithIdentifier:@"toInbuiltTheme" sender:self];
    }
    else if ([selectionType isEqualToString:@"Custom Themes"])
    {
        [self performSegueWithIdentifier:@"toCustomThemeSelect" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"settingToSettingOption" sender:self];
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"settingToSettingOption"])
    {
        [segue.destinationViewController setSelectionType:selectionType];
        
    }
    
    
}

@end
