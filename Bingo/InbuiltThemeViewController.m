//
//  InbuiltThemeViewController.m
//  Bingo
//
//  Created by feialoh on 28/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "InbuiltThemeViewController.h"

@interface InbuiltThemeViewController ()
{
    BOOL loadingFlag;
    ThemeModal *theme;
    NSString *compareKey,*tempKey;
    NSData *compareData;
    NSMutableArray *tempArray2;
}
@end

@implementation InbuiltThemeViewController

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
//     _themeTableDetails =[[NSMutableArray alloc]initWithObjects:@"Default" ,@"Xmas",@"Love",@"Broken Heart", nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_themeBackgroundView];
    
//    [_themeBackgroundView setImage:[UIImage imageNamed:theme.mainBackground]];
    
    NSDictionary *holeResource  = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ThemeList" ofType:@"plist"]];
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    tempArray = [[holeResource valueForKey:@"Themes"] mutableCopy] ;
    
    [self fetchThemeAllDetails:tempArray];
    
    [_mainThemeTable reloadData];
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
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationItem.title=@"Themes";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle: @"Save" style: UIBarButtonItemStyleBordered target: self action:@selector(saveTheme:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _themeTableDetails.count;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (_themeDetails.count>INDEX_SHOW_LIMIT)
//    {
//        return [[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    }
//    else
//        return nil;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"themeCell";
    
    static NSString *PlaceholderCellIdentifier = @"placeholderCell";
    
    // add a placeholder cell while waiting on table data
    
	if (loadingFlag)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
    
    //    if (_themeDetails.count<10)
    //	{
    //        InviteFriendsCell *cell= [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
    //		cell.cellSubtitle.text=@"No Theme";
    //
    //		return cell;
    //    }
    
    InviteFriendsCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell==nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    // Configure the cell...
    
    cell.delegate=self;
    cell.index=indexPath.row;
    cell.section=indexPath.section;
    
    
    if(_themeTableDetails.count!=0)
        [cell.addButton setSelected:[[[_themeTableDetails objectAtIndex:indexPath.row] valueForKey:@"selectedFlag"] boolValue]];
    
    /*
     NSUInteger row = 0; //Setting global indexPath.row
     NSUInteger sect = indexPath.section;
     
     for (NSUInteger i = 0; i < sect; ++ i)
     row += [self tableView:tableView numberOfRowsInSection:i];
     
     row += indexPath.row;
     */
    
    BuiltInThemeModal *themeObject=[[BuiltInThemeModal alloc]init];
    
    themeObject=[_themeTableDetails objectAtIndex:indexPath.row];
    
    
    cell.friendName.text=[themeObject.themeName capitalizedString];
    
    [cell.friendName setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:20.0]];
    [cell.friendName setTextColor:theme.gameFontColor];
    
    return cell;
}


#pragma mark - Custom cell delegate method

-(void)onAddButtonTouched:(InviteFriendsCell *)sender
{
    for(int i=0;i<_themeTableDetails.count;i++)
    {
        BuiltInThemeModal *themeObject=[[BuiltInThemeModal alloc]init];
        themeObject=[_themeTableDetails objectAtIndex:i];
        themeObject.selectedFlag=NO;
    }
    
    if(sender.addButton.isSelected)
    {
        
        [sender.addButton setImage:[UIImage imageNamed:@"added_down.png"] forState:UIControlStateHighlighted| UIControlStateSelected];
        
    }
    else
    {
        
        [sender.addButton setImage:[UIImage imageNamed:@"add_down.png"] forState:UIControlStateHighlighted];
        
    }
    
    BuiltInThemeModal *themeOb=[[BuiltInThemeModal alloc]init];
    themeOb=[_themeTableDetails objectAtIndex:sender.index];
    themeOb.selectedFlag=sender.addButton.isSelected;

    
    if (sender.addButton.isSelected)
    {
        if ([themeOb.mainBackground isKindOfClass:[NSString class]])
        {
            [_themeBackgroundView setImage:[UIImage imageNamed:themeOb.mainBackground]];
        }
        else
        {
            [_themeBackgroundView setImage:nil];
            [_themeBackgroundView setBackgroundColor:[self getColorFor:themeOb.mainBackground]];
        }
        
        theme.gameFontColor=[self getColorFor:themeOb.gameFontColor];
    }
    else
    {
         theme=[[ThemeModal alloc]init];
         [theme setTheme:_themeBackgroundView];
//        [_themeBackgroundView setImage:[UIImage imageNamed:[Reusables getDefaultValue:MAIN_BACKGROUND]]];
    }
    [_mainThemeTable reloadData];
    loadingFlag=NO;
}

#pragma mark - Custom Methods


-(UIColor *)getColorFor:(NSDictionary *)rgbValues
{
    NSLog(@"RGB:%@",rgbValues);
    
    float red,green,blue,alpha;
    
    red= [[rgbValues valueForKey:@"red"] floatValue]/255.0f;
    green= [[rgbValues valueForKey:@"green"] floatValue]/255.0f;
    blue= [[rgbValues valueForKey:@"blue"] floatValue]/255.0f;
    alpha= [[rgbValues valueForKey:@"alpha"] floatValue]/10.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


//Array for getting selected theme
-(NSArray*)getSelectedThemes
{
    NSMutableArray *returnArray=[[NSMutableArray alloc]init];
    
    for(int i = 0;i<_themeTableDetails.count;i++)
    {
        BuiltInThemeModal *themeObject=[[BuiltInThemeModal alloc]init];
        themeObject=[_themeTableDetails objectAtIndex:i];
        
        if(themeObject.selectedFlag)
        {
            [returnArray addObject:themeObject];
            break;
        }
    }
    return returnArray;
}



//Saving theme
- (void)saveTheme:(id)sender
{
    
//    NSMutableArray *selectedList= [[NSMutableArray alloc] initWithCapacity:[[self getSelectedThemes] count]];
    
//    for(int i=0;i<[[self getSelectedThemes] count];i++)
//    {
//        BuiltInThemeModal *themeObject=[[BuiltInThemeModal alloc]init];
//        
//        themeObject=[[self getSelectedThemes] objectAtIndex:i];
//        
//        NSLog(@"%@",[self getSelectedThemes] );
//        
//    }
    
//     NSLog(@"Theme Count:%lu",(unsigned long)[[self getSelectedThemes] count] );
    
    if ([[self getSelectedThemes] count]>0)
    {
        
        BuiltInThemeModal *themeObject=[[BuiltInThemeModal alloc]init];
        
        themeObject=[[self getSelectedThemes] objectAtIndex:0];
        [self saveCurrentTheme:themeObject];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Settings Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

//Saving theme
-(void)saveCurrentTheme:(BuiltInThemeModal *)newTheme
{
    NSData *colorData;
    
    if ([newTheme.mainBackground isKindOfClass:[NSString class]])
    {
        [Reusables storeDataToDefaults:MAIN_BACKGROUND objectToAdd:newTheme.mainBackground];
    }
    else
    {
  
        colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.mainBackground]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MAIN_BACKGROUND];

    }
    
    
    if ([newTheme.initialButton isKindOfClass:[NSString class]])
    {
        [Reusables storeDataToDefaults:INITIAL_BUTTON_BACKGROUND objectToAdd:newTheme.initialButton];
    }
    else
    {
        
        colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.initialButton]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_BACKGROUND];
        
    }
    
    if ([newTheme.selectedButton isKindOfClass:[NSString class]])
    {
        [Reusables storeDataToDefaults:SELECTED_BUTTON_BACKGROUND objectToAdd:newTheme.selectedButton];
    }
    else
    {
        
        colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.selectedButton]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_BACKGROUND];
        
    }
    
    if ([newTheme.bingoButton isKindOfClass:[NSString class]])
    {
        [Reusables storeDataToDefaults:MULTIPLE_BUTTON_BACKGROUND objectToAdd:newTheme.bingoButton];
    }
    else
    {
        
        colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.bingoButton]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_BACKGROUND];
        
    }
    
    
    colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.initialButtonTitleColor]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_TITLE_COLOR];
    
    colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.selectedButtonTitleColor]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_TITLE_COLOR];
    
    colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.bingoButtonTitleColor]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_TITLE_COLOR];
    
    colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.gameFontColor]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:GAME_FONT_COLOR];
    
    colorData = [NSKeyedArchiver archivedDataWithRootObject:[self getColorFor:newTheme.bingoFontColor]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:BINGO_FONT_COLOR];
    
}

//Filling table details from plist
-(void) fetchThemeAllDetails:(NSArray *)displayArray
{
    _themeTableDetails= [[NSMutableArray alloc] initWithCapacity:displayArray.count];
    
    for (NSUInteger i = 0; i < displayArray.count; i++)
    {
        BuiltInThemeModal *themeObject=[[BuiltInThemeModal alloc]init];
        
        [themeObject setBuiltInTheme:[displayArray objectAtIndex:i]];
        
        [_themeTableDetails addObject:themeObject] ;

    }
}

@end
