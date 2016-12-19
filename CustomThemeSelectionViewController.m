//
//  ThemeSelectionViewController.m
//  Bingo
//
//  Created by feialoh on 08/01/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "CustomThemeSelectionViewController.h"


@interface CustomThemeSelectionViewController ()
{
    BOOL loadingFlag;
    ThemeModal *theme;
    NSString *compareKey,*tempKey;
    NSData *compareData;
    NSMutableArray *tempArray2;
}
@end

@implementation CustomThemeSelectionViewController

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
    
    [self customiseNavigationBarForAllGroups];
    
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_themeBackground];
//    [_themeBackground setImage:[UIImage imageNamed:[Reusables getDefaultValue:MAIN_BACKGROUND]]];
    
    NSDictionary *holeResource  = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ThemeList" ofType:@"plist"]];
    
    
    
    NSMutableArray *tempArray1;
    
    tempArray1=[[NSMutableArray alloc]init];
    
    tempArray2=[[NSMutableArray alloc]init];
    
    
    if ([_settingsType isEqualToString:@"Background"])
    {
        tempArray1 = [holeResource valueForKey:@"Backgrounds"] ;
    }
    else if ([_settingsType isEqualToString:@"Buttons"])
    {
        
        tempArray1 = [holeResource valueForKey:@"Buttons"] ;
    }
    else if ([_settingsType isEqualToString:@"Colors"])
    {
        tempArray1 = [holeResource valueForKey:@"Colors"] ;
    }
    else if ([_settingsType isEqualToString:@"Fonts"])
    {
        for (NSString* familyName in [UIFont familyNames])
            for (NSString* fontName in [UIFont fontNamesForFamilyName:familyName])
                [tempArray1 addObject:fontName];
        
        tempArray1 = [[tempArray1 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        
        //         NSLog(@"Fonts:%@",tempArray1);
    }
    
    
    for (int i = 0; i < tempArray1.count; i++)
    {
        [tempArray2 addObject:[@{@"uniqueId": [NSString stringWithFormat:@"ID %d",i],
                                 @"name": [tempArray1 objectAtIndex:i],
                                 @"selectedFlag": @(NO)} mutableCopy]] ;
    }
    

    [self makeCompareKey];
    
    [self fetchThemeAllDetails:tempArray2];
    
    _themeSelectionTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
//        return 0;
//    } else
//        return 30;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if(loadingFlag)
//        return 1;
//    else
//        return [[self.listSection allKeys] count];
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //    if (loadingFlag)
    //        return 1;
    //
    //    return [[self.listSection valueForKey:[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    
    return _themeDetails.count;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (_themeDetails.count>INDEX_SHOW_LIMIT)
//    {
//        
//        NSArray *indexList = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
//        
//        
//        return indexList;
////        return [[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    }
//    else
//        return nil;
//}


//- (NSInteger) tableView:(UITableView *)tableView
//sectionForSectionIndexTitle:(NSString *)title
//                atIndex:(NSInteger)index
//{
//    if (index != 0) {
//        // i is the index of the cell you want to scroll to
//        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
//    }
//    return index;
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
    
    
    if(_themeDetails.count!=0)
        [cell.addButton setSelected:[[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"selectedFlag"] boolValue]];
    
    /*
     NSUInteger row = 0; //Setting global indexPath.row
     NSUInteger sect = indexPath.section;
     
     for (NSUInteger i = 0; i < sect; ++ i)
     row += [self tableView:tableView numberOfRowsInSection:i];
     
     row += indexPath.row;
     */
    
    if ([_settingsType isEqualToString:@"Buttons"])
    {
        cell.friendName.hidden=YES;
        //        NSLog(@"%@",[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"]);
        
        [cell.colorButton setBackgroundImage:[UIImage imageNamed:[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"] ]  forState:UIControlStateNormal & UIControlStateSelected ];
        
        //        [cell.colorButton setSelected:YES];
        
    }
    else if ([_settingsType isEqualToString:@"Colors"])
    {
        
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString([[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"])]];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        if ([_selectionMode isEqualToString:@"Game Color"] ||[_selectionMode isEqualToString:@"Bingo Text Color"])
        {
            cell.colorButton.hidden=YES;
            
            cell.friendName.text=[[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"] capitalizedString];
            
            [cell.friendName setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:22.0]];
            [cell.friendName setTextColor:color];
            
        }
        else
        {
            cell.friendName.hidden=YES;
            
            [cell.colorButton setTitle:@"25" forState:UIControlStateNormal & UIControlStateSelected];
            [cell.colorButton.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:20.0]];
            
            [cell.colorButton setTitleColor:color forState:UIControlStateNormal & UIControlStateSelected ];
            
            [cell.colorButton setBackgroundImage:[UIImage imageNamed:compareKey]  forState:UIControlStateNormal & UIControlStateSelected ];
            
            //        [cell.colorButton setSelected:YES];
        }
        
    }
    else if ([_settingsType isEqualToString:@"Fonts"])
    {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:GAME_FONT_COLOR];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        cell.colorButton.hidden=YES;
        
        cell.friendName.text=[[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"] capitalizedString];
        
        [cell.friendName setFont:[UIFont fontWithName:[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"] size:20.0]];
        [cell.friendName setTextColor:color];
    }
    else
    {
        cell.colorButton.hidden=YES;
        
        cell.friendName.text=[[_themeDetails objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        [cell.friendName setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
        [cell.friendName setTextColor:theme.gameFontColor];
    }
    
    return cell;
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    [view setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:231.0/255.0 blue:76.0/255.0 alpha:1 ]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 160, 20)];
//    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0 || loadingFlag)
//    {
//        label.text = @"";
//    }
//    else
//    {
//        label.text = [[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
//    }
//    [label setTextColor:[UIColor purpleColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont fontWithName:@"Gotham" size:14]];
//    [view addSubview:label];//254,231,76  - 14,69,123
//    return view;
//
//}

#pragma mark - Custom cell delegate method

-(void)onAddButtonTouched:(InviteFriendsCell *)sender
{
    for(int i=0;i<_themeDetails.count;i++)
        [[_themeDetails objectAtIndex:i]setObject:[NSNumber numberWithBool:FALSE] forKey:@"selectedFlag"];
    
    if(sender.addButton.isSelected)
    {
        
        [sender.addButton setImage:[UIImage imageNamed:@"added_down.png"] forState:UIControlStateHighlighted| UIControlStateSelected];
        
    }
    else
    {
        
        [sender.addButton setImage:[UIImage imageNamed:@"add_down.png"] forState:UIControlStateHighlighted];
        
    }
    
    [[_themeDetails objectAtIndex:sender.index] setObject:[NSNumber numberWithBool:sender.addButton.isSelected] forKey:@"selectedFlag"];
    
    
    if (sender.addButton.isSelected && [_settingsType isEqualToString:@"Background"])
    {
        [_themeBackground setImage:[UIImage imageNamed:[[_themeDetails objectAtIndex:sender.index]valueForKey:@"name"]]];
    }
    else
    {
//        [_themeBackground setImage:[UIImage imageNamed:[Reusables getDefaultValue:MAIN_BACKGROUND]]];
        [theme setTheme:_themeBackground];
    }
    [_themeSelectionTable reloadData];
    loadingFlag=NO;
}


#pragma mark - Custom Methods

-(void) fetchThemeAllDetails:(NSArray *)displayArray
{
    //    displayArray=[self sortByLastName:displayArray];
    //    NSLog(@"TableDisplay Array:%@",displayArray);
    
    
    _themeDetails= [[NSMutableArray alloc] initWithCapacity:displayArray.count];
    
    for (NSUInteger i = 0; i < displayArray.count; i++)
    {
        //        NSLog(@"%@==%@",[[displayArray objectAtIndex:i] valueForKey:@"name"],compareKey);
        if ([tempKey isEqualToString:@"MyColor"])
        {
            NSData *myData=[NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString([[displayArray objectAtIndex:i] valueForKey:@"name"])]];
            
            //             UIColor *color1 = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
            //
            //            UIColor *color2 = [NSKeyedUnarchiver unarchiveObjectWithData:compareData];
            //
            //            NSLog(@"Color:%@==%@",color1,color2);
            
            if ([myData isEqual:compareData])
            {
                [_themeDetails addObject:[@{@"uniqueId": [[displayArray objectAtIndex:i] valueForKey:@"uniqueId"],
                                            @"name": [[displayArray objectAtIndex:i] valueForKey:@"name"],
                                            @"selectedFlag": @(YES)} mutableCopy]] ;
            }
            else
            {
                
                [_themeDetails addObject:[@{@"uniqueId": [[displayArray objectAtIndex:i] valueForKey:@"uniqueId"],
                                            @"name": [[displayArray objectAtIndex:i] valueForKey:@"name"],
                                            @"selectedFlag": @(NO)} mutableCopy]] ;
            }
            
        }
        else
        {
            if ([[[displayArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:compareKey])
            {
                [_themeDetails addObject:[@{@"uniqueId": [[displayArray objectAtIndex:i] valueForKey:@"uniqueId"],
                                            @"name": [[displayArray objectAtIndex:i] valueForKey:@"name"],
                                            @"selectedFlag": @(YES)} mutableCopy]] ;
            }
            else
            {
                
                [_themeDetails addObject:[@{@"uniqueId": [[displayArray objectAtIndex:i] valueForKey:@"uniqueId"],
                                            @"name": [[displayArray objectAtIndex:i] valueForKey:@"name"],
                                            @"selectedFlag": @(NO)} mutableCopy]] ;
            }
        }
        
    }
    
    //    _themeDetails=[[NSMutableArray alloc] initWithArray:[self sortByLastName:_themeDetails]];
    //    [self getSectionIndexList:_themeDetails];
    /*
     [Reusables getSectionIndexList:_themeDetails Key:@"name" :^(NSMutableDictionary *list, NSException *exception)
     {
     
     if (exception)
     {
     NSString *message= [NSString stringWithFormat:@"Exception:%@",exception];
     showAlert(@"Message", message, STRING_CONSTANT_OK, nil);
     }
     else
     {
     self.listSection=list;
     }
     }];
     */
    [_themeSelectionTable reloadData];
}



//Method to keep track of cells in the section for selection
-(int)getRowFromSection:(NSInteger)section
{
    int count=0;
    for(NSInteger i=0;i<section;i++)
        count+=[_themeSelectionTable numberOfRowsInSection:i];
    return count;
}

//Method to sort Friendlist by last name for social Media
-(NSArray*)sortByLastName:(NSArray*)sortArray
{
    //NSLog(@"%@",sortArray);
    sortArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first,*second;int count = 0;
        
        first=[a objectForKey:@"name"];
        second=[b objectForKey:@"name"];
        
        first = [Reusables fetchLastName:first];
        second=[Reusables fetchLastName:second];
        count++;
        // NSLog(@"%@,sec:%@,count:%d",first,second,count);
        
        if([first compare:second options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            NSString *firstName=[[a objectForKey:@"name"] stringByReplacingOccurrencesOfString:first withString:@""];
            NSString *secondName=[[b objectForKey:@"name"] stringByReplacingOccurrencesOfString:second withString:@""];
            return [firstName compare:secondName options:NSCaseInsensitiveSearch];
        }
        else
            return [first compare:second options:NSCaseInsensitiveSearch];
    }];
    return  sortArray;
}


- (void) customiseNavigationBarForAllGroups
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.navigationBarHidden = NO;
    self.title = [NSString stringWithFormat:@"Choose %@",_settingsType];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle: @"Save" style: UIBarButtonItemStyleBordered target: self action:@selector(doneSelectingTheme:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
}

//Array for getting selected theme
-(NSArray*)getSelectedArrayForGroups
{
    NSMutableArray *returnArray=[[NSMutableArray alloc]init];
    
    for(int i = 0;i<_themeDetails.count;i++)
    {
        if([[[_themeDetails objectAtIndex:i] valueForKey:@"selectedFlag"]boolValue ] )
            [returnArray addObject:[_themeDetails objectAtIndex:i]];
    }
    return returnArray;
}

//Saving theme
- (void)doneSelectingTheme:(id)sender
{
    
    NSMutableArray *selectedList= [[NSMutableArray alloc] initWithCapacity:[[self getSelectedArrayForGroups] count]];
    
    for(int i=0;i<[[self getSelectedArrayForGroups] count];i++)
    {
        
        NSLog(@"%@",[self getSelectedArrayForGroups] );
        [selectedList addObject:[@{@"name": [[[self getSelectedArrayForGroups] objectAtIndex:i] valueForKey:@"name"],
                                   
                                   } mutableCopy]] ;
        
    }
    
    if (selectedList.count>0)
    {
        NSLog(@"selected groups:%@",[[selectedList objectAtIndex:0]valueForKey:@"name"]);
        
        [self modifyDefaultValuesWith:[[selectedList objectAtIndex:0]valueForKey:@"name"]];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Settings Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
-(void)modifyDefaultValuesWith:(NSString *)selectedValue
{
    
    [Reusables storeDataToDefaults:THEME_TYPE objectToAdd:@"Custom_Theme"];
    
    if ([_settingsType isEqualToString:@"Background"])
    {
        [Reusables storeDataToDefaults:MAIN_BACKGROUND objectToAdd:selectedValue];
        
    }
    else if ([_settingsType isEqualToString:@"Fonts"])
    {
        [Reusables storeDataToDefaults:GAME_FONT objectToAdd:selectedValue];
        
    }
    else if ([_selectionMode isEqualToString:@"Normal Button"])
    {
        [Reusables storeDataToDefaults:INITIAL_BUTTON_BACKGROUND objectToAdd:selectedValue];
    }
    else if ([_selectionMode isEqualToString:@"Selected Button"])
    {
        [Reusables storeDataToDefaults:SELECTED_BUTTON_BACKGROUND objectToAdd:selectedValue];
    }
    else if ([_selectionMode isEqualToString:@"Bingo Button"])
    {
        [Reusables storeDataToDefaults:MULTIPLE_BUTTON_BACKGROUND objectToAdd:selectedValue];
    }
    else if ([_selectionMode isEqualToString:@"Normal Color"])
    {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString(selectedValue)]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_TITLE_COLOR];
        
    }
    else if ([_selectionMode isEqualToString:@"Selected Color"])
    {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString(selectedValue)]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_TITLE_COLOR];
        
    }
    else if ([_selectionMode isEqualToString:@"Bingo Color"])
    {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString(selectedValue)]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_TITLE_COLOR];
        
    }
    else if ([_selectionMode isEqualToString:@"Game Color"])
    {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString(selectedValue)]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:GAME_FONT_COLOR];
        
    }
    else if ([_selectionMode isEqualToString:@"Bingo Text Color"])
    {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor performSelector:NSSelectorFromString(selectedValue)]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:BINGO_FONT_COLOR];
        
    }
    else
    {
        NSLog(@"No selection found");
    }
    
    
}


-(void) makeCompareKey
{
    if ([_settingsType isEqualToString:@"Background"])
    {
        compareKey=[Reusables getDefaultValue:MAIN_BACKGROUND];
    }
    else if ([_settingsType isEqualToString:@"Fonts"])
    {
        compareKey=[Reusables getDefaultValue:GAME_FONT];
    }
    else if ([_selectionMode isEqualToString:@"Normal Button"])
    {
        
        compareKey=[Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND];
        
        [self removeTableDetailsValuesFor:[Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND]];
        [self removeTableDetailsValuesFor:[Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND]];
        
    }
    else if ([_selectionMode isEqualToString:@"Selected Button"])
    {
        compareKey=[Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND];
        
        [self removeTableDetailsValuesFor:[Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND]];
        [self removeTableDetailsValuesFor:[Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND]];
        
    }
    else if ([_selectionMode isEqualToString:@"Bingo Button"])
    {
        compareKey=[Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND];
        
        [self removeTableDetailsValuesFor:[Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND]];
        [self removeTableDetailsValuesFor:[Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND]];
        
    }
    else if ([_selectionMode isEqualToString:@"Normal Color"])
    {
        tempKey=@"MyColor";
        compareKey=[Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND];
        compareData = [[NSUserDefaults standardUserDefaults] objectForKey:INITIAL_BUTTON_TITLE_COLOR];
    }
    else if ([_selectionMode isEqualToString:@"Selected Color"])
    {
        tempKey=@"MyColor";
        compareKey=[Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND];
        compareData = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_BUTTON_TITLE_COLOR];
    }
    else if ([_selectionMode isEqualToString:@"Bingo Color"])
    {
        tempKey=@"MyColor";
        compareKey=[Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND];
        compareData = [[NSUserDefaults standardUserDefaults] objectForKey:MULTIPLE_BUTTON_TITLE_COLOR];
    }
    else if ([_selectionMode isEqualToString:@"Game Color"])
    {
        tempKey=@"MyColor";
        compareData = [[NSUserDefaults standardUserDefaults] objectForKey:GAME_FONT_COLOR];
    }
    else if ([_selectionMode isEqualToString:@"Bingo Text Color"])
    {
        tempKey=@"MyColor";
        compareData = [[NSUserDefaults standardUserDefaults] objectForKey:BINGO_FONT_COLOR];
    }
    else
    {
        NSLog(@"No selection found");
    }
}


-(void)removeTableDetailsValuesFor:(NSString *)deleteValue
{
    
    tempArray2=[[tempArray2 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT name IN %@", deleteValue ]] mutableCopy];
    
}


@end
