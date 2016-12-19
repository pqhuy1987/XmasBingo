//
//  ThemeModal.m
//  Bingo
//
//  Created by feialoh on 08/01/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "ThemeModal.h"

@implementation ThemeModal

- (void)setTheme:(UIImageView*)_backgroundView
{
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:GAME_FONT_COLOR];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    _gameFontColor=color;

    colorData = [[NSUserDefaults standardUserDefaults] objectForKey:BINGO_FONT_COLOR];
    color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    _bingoFontColor=color;
    
    colorData = [[NSUserDefaults standardUserDefaults] objectForKey:INITIAL_BUTTON_TITLE_COLOR];
    color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    _initialButtonTitleColor=color;
    
    
    colorData= [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_BUTTON_TITLE_COLOR];
    color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    _selectedButtonTitleColor=color;
    
    colorData= [[NSUserDefaults standardUserDefaults] objectForKey:MULTIPLE_BUTTON_TITLE_COLOR];
    color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    _multipleButtonTitleColor=color;
    
    
    if ([[Reusables getDefaultValue:MAIN_BACKGROUND] isKindOfClass:[NSString class]])
    {
        [_backgroundView setImage:[UIImage imageNamed:[Reusables getDefaultValue:MAIN_BACKGROUND]]];
    }
    else
    {
        colorData= [[NSUserDefaults standardUserDefaults] objectForKey:MAIN_BACKGROUND];
        color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        _mainBackground=color;
        [_backgroundView setImage:nil];
        [_backgroundView setBackgroundColor:_mainBackground];
    }

    
    if ([[Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND] isKindOfClass:[NSString class]])
    {
       _initialButton=[Reusables getDefaultValue:INITIAL_BUTTON_BACKGROUND];
    }
    else
    {
        colorData= [[NSUserDefaults standardUserDefaults] objectForKey:INITIAL_BUTTON_BACKGROUND];
        color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        _initialButton=color;
    }
    
    
    if ([[Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND] isKindOfClass:[NSString class]])
    {
        _selectedButton=[Reusables getDefaultValue:SELECTED_BUTTON_BACKGROUND];
    }
    else
    {
        colorData= [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_BUTTON_BACKGROUND];
        color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        _selectedButton=color;
    }

    
    if ([[Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND] isKindOfClass:[NSString class]])
    {
        _multipleButton=[Reusables getDefaultValue:MULTIPLE_BUTTON_BACKGROUND];
    }
    else
    {
        colorData= [[NSUserDefaults standardUserDefaults] objectForKey:MULTIPLE_BUTTON_BACKGROUND];
        color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        _multipleButton=color;
    }
    
   
    
}


@end
