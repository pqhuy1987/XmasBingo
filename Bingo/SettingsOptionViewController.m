//
//  SettingsOptionViewController.m
//  Bingo
//
//  Created by feialoh on 12/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "SettingsOptionViewController.h"
#import "CustomThemeSelectionViewController.h"

@interface SettingsOptionViewController ()
{
    NSString *selectionMode,*themeType;
    ThemeModal *theme;
    NSUInteger myTag;
    UIButton *defaultButton, *customButton;
    
}
@end

@implementation SettingsOptionViewController

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
    myTag=700;
    if ([_selectionType isEqualToString:@"Buttons"])
    {
        _tableDetails =[[NSMutableArray alloc]initWithObjects:@"Normal Button" ,@"Selected Button",@"Bingo Button", nil];
    }
    else if ([_selectionType isEqualToString:@"Player Name"])
    {
        _settingsOptionTable.hidden=YES;
        [self createView:1 withKey:@"single"];
        UIBarButtonItem *browseButton = [[UIBarButtonItem alloc] initWithTitle: @"Save" style: UIBarButtonItemStyleBordered target: self action: @selector(onSaveButtonTouch)];
        self.navigationItem.rightBarButtonItem = browseButton;
    }
    else if ([_selectionType isEqualToString:@"Theme Mode"])
    {
        [self createViewForTheme];
        UIBarButtonItem *browseButton = [[UIBarButtonItem alloc] initWithTitle: @"Save" style: UIBarButtonItemStyleBordered target: self action: @selector(onSaveButtonTouch)];
        self.navigationItem.rightBarButtonItem = browseButton;
        
        
    }
    else
    {
        _tableDetails =[[NSMutableArray alloc]initWithObjects:@"Normal Color" ,@"Selected Color",@"Bingo Color",@"Bingo Text Color", @"Game Color", nil];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_changeViewBackground];
    
    //    [_changeViewBackground setImage:[UIImage imageNamed:theme.mainBackground]];
    [self customizeNavigationBar];
    
    [_settingsOptionTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - Text Field delegate Actions

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    if (textField.tag >701 && textField.tag <705 )
    //    {
    //        [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-80) animated:YES];
    //    }
    
}

//Navigation bar customization
- (void) customizeNavigationBar
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    NSLog(@"NC in setting option =%@",self.navigationController);
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationItem.title=_selectionType;
    
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
    
    [categoryNameLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:20.0]];
    [categoryNameLabel setTextColor:theme.gameFontColor];
    
    
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ is selected.",[_tableDetails objectAtIndex:indexPath.row]);
    
    selectionMode = [_tableDetails objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"optionsToThemeSelect" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@, selectionType:%@", segue.identifier,selectionMode);
    
    [segue.destinationViewController setSelectionMode:selectionMode];
    
    [segue.destinationViewController setSettingsType:_selectionType];
    
}


//Create view for theme mode

-(void)createViewForTheme
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_changeViewBackground];
    
    float y=50;
    
    CGSize myStringSize; NSString *labels;UILabel *playerlabel;
    labels=@"Default Themes";
    myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                 }];
    
    playerlabel = [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2, y,myStringSize.width , myStringSize.height)];
    playerlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    playerlabel.backgroundColor = [UIColor clearColor];
    playerlabel.text=labels;
    playerlabel.font = [self myFontWithSize:22];
    playerlabel.textColor=theme.gameFontColor;
    
    defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [defaultButton addTarget:self
                      action:@selector(defaultTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [defaultButton setBackgroundImage:[UIImage imageNamed:@"add_up.png"] forState:UIControlStateNormal];
    [defaultButton setBackgroundImage:[UIImage imageNamed:@"add_down.png"] forState:UIControlStateHighlighted];
    [defaultButton setBackgroundImage:[UIImage imageNamed:@"added_up.png"] forState:UIControlStateSelected];
    
    defaultButton.frame = CGRectMake(playerlabel.frame.origin.x+playerlabel.frame.size.width, y, 40.0, 40.0);
    
    [self.view addSubview:playerlabel];
    [self.view addSubview:defaultButton];
    
    y=playerlabel.frame.origin.y+playerlabel.frame.size.height+20;
    
    labels=@"Custom Themes";
    myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                 }];
    
    playerlabel = [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2, y,myStringSize.width , myStringSize.height)];
    playerlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    playerlabel.backgroundColor = [UIColor clearColor];
    playerlabel.text=labels;
    playerlabel.font = [self myFontWithSize:22];
    playerlabel.textColor=theme.gameFontColor;
    
    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton addTarget:self
                     action:@selector(customTheme:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"add_up.png"] forState:UIControlStateNormal];
    [customButton setBackgroundImage:[UIImage imageNamed:@"add_down.png"] forState:UIControlStateHighlighted];
    [customButton setBackgroundImage:[UIImage imageNamed:@"added_up.png"] forState:UIControlStateSelected];
    
    customButton.frame = CGRectMake(defaultButton.frame.origin.x, y, 40.0, 40.0);
    
    
    
    [self.view addSubview:playerlabel];
    [self.view addSubview:customButton];
    
    if (![[Reusables getDefaultValue:THEME_TYPE] isEqualToString:@"Custom_Theme"])
    {
        themeType=@"Default";
        [defaultButton setSelected:YES];
    }
    else
    {
        themeType=@"Custom_Theme";
        [customButton setSelected:YES];
    }
}


-(void) defaultTheme:(UIButton *)sender
{
    
    themeType=@"Default";
    
    [sender setSelected:!sender.isSelected];
    [customButton setSelected:NO];
    
    if(sender.isSelected)
    {
        [_changeViewBackground setImage:nil];
        [_changeViewBackground setBackgroundColor:[UIColor darkGrayColor]];
        [sender setImage:[UIImage imageNamed:@"added_down.png"] forState:UIControlStateHighlighted| UIControlStateSelected];
        
    }
    else
    {
        [theme setTheme:_changeViewBackground];
        [sender setImage:[UIImage imageNamed:@"add_down.png"] forState:UIControlStateHighlighted];
    }
    
}

-(void) customTheme:(UIButton *)sender
{
    
    themeType=@"Custom_Theme";
    
    [sender setSelected:!sender.isSelected];
    
    [defaultButton setSelected:NO];
    
    if(sender.isSelected)
    {
        [_changeViewBackground setImage:[UIImage imageNamed:@"xmas-bg"]];
        [sender setImage:[UIImage imageNamed:@"added_down.png"] forState:UIControlStateHighlighted| UIControlStateSelected];
        
    }
    else
    {
        [theme setTheme:_changeViewBackground];
        [sender setImage:[UIImage imageNamed:@"add_down.png"] forState:UIControlStateHighlighted];
    }
}

//Create view for single

-(void) createView:(NSUInteger) count withKey:(NSString *) key
{
    theme=[[ThemeModal alloc]init];
    [theme setTheme:_changeViewBackground];
    float y=10; UITextField *playerName;
    for (NSUInteger i=0;i<count; i++)
    {
        
        CGSize myStringSize; NSString *labels;
        //        labels=[NSString stringWithFormat:@"***PLAYER%lu NAME***",(unsigned long)i+1];
        labels=@"***PLAYER NAME***";
        myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                     }];
        
        UILabel *playerlabel = [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2, y,myStringSize.width , myStringSize.height)];
        playerlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        playerlabel.backgroundColor = [UIColor clearColor];
        playerlabel.text=labels;
        playerlabel.font = [self myFontWithSize:22];
        playerlabel.textColor=theme.gameFontColor;
        
        //        if ([key isEqualToString:@"multiplesame"])
        //        {
        //            labels=[[[setDetails valueForKey:key]objectAtIndex:0] objectAtIndex:i];
        //        }
        //        else
        //        {
        //            labels=[[setDetails valueForKey:key]objectAtIndex:0];
        //        }
        labels=[Reusables getDefaultValue:PLAYER_NAME];
        
        y=playerlabel.frame.origin.y+playerlabel.frame.size.height;
        
        playerName =[[UITextField alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-myStringSize.width)/2, y,myStringSize.width , myStringSize.height+10)];
        playerName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        playerName.text=labels;
        playerName.font = [self myFontWithSize:25];
        playerName.textColor=theme.gameFontColor;
        // Design our border so it looks like a "real" UITextField
        [playerName.layer setBorderColor:[[[UIColor yellowColor] colorWithAlphaComponent:0.4] CGColor]];
        [playerName.layer setBorderWidth:1];
        
        // Make the corner all round
        playerName.layer.cornerRadius = 7;
        playerName.clipsToBounds = YES;
        
        playerName.tag=myTag++;
        playerName.delegate=self;
        
        y+=75;
        [self.view addSubview:playerlabel];
        [self.view addSubview:playerName];
    }
    
}

//Get font with size
-(UIFont *)myFontWithSize:(CGFloat)size
{
    
    return [UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:size];
    
}

//change theme

-(void)changeTheme
{
    NSString *message;
    if (!defaultButton.isSelected && !customButton.isSelected)
    {
       message=@"Please select a theme";
    }
    else
    {
        [Reusables storeDataToDefaults:THEME_TYPE objectToAdd:themeType];
        NSData *colorData;message=@"Settings Saved";
        
        if ([themeType isEqualToString:@"Custom_Theme"])
        {

            
            [Reusables storeDataToDefaults:MAIN_BACKGROUND objectToAdd:@"xmas-bg"];
            
            [Reusables storeDataToDefaults:INITIAL_BUTTON_BACKGROUND objectToAdd:@"bubble-red-md"];
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_TITLE_COLOR];
            
            
            [Reusables storeDataToDefaults:SELECTED_BUTTON_BACKGROUND objectToAdd:@"bubble-yellow-md"];
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_TITLE_COLOR];
            
            [Reusables storeDataToDefaults:MULTIPLE_BUTTON_BACKGROUND objectToAdd:@"bubble-green-md"];
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_TITLE_COLOR];
            
            [Reusables storeDataToDefaults:GAME_FONT objectToAdd:@"Baskerville-Bold"];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:GAME_FONT_COLOR];
            
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:BINGO_FONT_COLOR];
    
        }
        else
        {
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor darkGrayColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MAIN_BACKGROUND];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor orangeColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_BACKGROUND];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:INITIAL_BUTTON_TITLE_COLOR];
            
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_BACKGROUND];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor orangeColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:SELECTED_BUTTON_TITLE_COLOR];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_BACKGROUND];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:MULTIPLE_BUTTON_TITLE_COLOR];
            
            [Reusables storeDataToDefaults:GAME_FONT objectToAdd:@"Baskerville-Bold"];
            
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:GAME_FONT_COLOR];
            
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:BINGO_FONT_COLOR];
        }
    }
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}


-(void)onSaveButtonTouch
{
    if ([_selectionType isEqualToString:@"Theme Mode"])
    {
        [self changeTheme];
    }
    else
    {
        
        NSInteger checkTag=700; NSString *valueToAdd; NSString *message;
        
        valueToAdd=[self viewWithTagForText:checkTag++];
        
        
        if (valueToAdd.length<3)
        {
            message=@"Name should contain atleast 3 characters";
        }
        else
        {
            
            [Reusables storeDataToDefaults:PLAYER_NAME objectToAdd:valueToAdd];
            message=@"Settings Saved";
            
        }
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
    
}

- (NSString *)viewWithTagForText:(NSInteger)tag
{
    for (UITextField *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            if (subView.tag==tag)
            {
                return subView.text;
                break;
            }
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark - UITextfield Delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}


@end
