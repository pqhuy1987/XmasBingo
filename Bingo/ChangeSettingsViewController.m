//
//  ChangeSettingsViewController.m
//  Bingo
//
//  Created by feialoh on 11/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "ChangeSettingsViewController.h"
#import "CustomThemeSelectionViewController.h"
#import "SettingsOptionViewController.h"

@interface ChangeSettingsViewController ()
{
    NSString *selectionType;
     ThemeModal *theme;
    
}
@end

@implementation ChangeSettingsViewController

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
    
    _tableDetails =[[NSMutableArray alloc]initWithObjects:@"Background" ,@"Buttons",@"Colors",@"Fonts", nil];
    
//    _settingsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_changeSettingsBackground];
    
//    [_changeSettingsBackground setImage:[UIImage imageNamed:theme.mainBackground]];
    [_settingsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Navigation bar customization
- (void) customizeNavigationBar
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    NSLog(@"NC in change setting=%@",self.navigationController);
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
    
    return _tableDetails.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"settingsCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *categoryNameLabel = (UILabel *) [cell viewWithTag:100];
    
    categoryNameLabel.text=[_tableDetails objectAtIndex:indexPath.row];
    
    [categoryNameLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
    [categoryNameLabel setTextColor:theme.gameFontColor];
    
    
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ is selected.",[_tableDetails objectAtIndex:indexPath.row]);
    
    selectionType = [_tableDetails objectAtIndex:indexPath.row];
    
    if ([selectionType isEqualToString:@"Background"]||[selectionType isEqualToString:@"Fonts"] )
    {
        [self performSegueWithIdentifier:@"toThemeSelect" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"toSettingOptions" sender:self];
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);

    if ([segue.identifier isEqualToString:@"toThemeSelect"])
    {
        [segue.destinationViewController setSettingsType:selectionType];
    }
    else
    {
        [segue.destinationViewController setSelectionType:selectionType];
        
    }
    
   
}


@end
