//
//  BuiltInThemeModal.m
//  Bingo
//
//  Created by feialoh on 04/09/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "BuiltInThemeModal.h"

@implementation BuiltInThemeModal


- (void)setBuiltInTheme:(NSDictionary *)themeList
{
    NSLog(@"%@",themeList);
    
    _themeName=[themeList valueForKey:@"themeName"];
    
    _initialButtonTitleColor=[[themeList valueForKey:@"initialButtonTitleColor"] mutableCopy];
    _selectedButtonTitleColor=[[themeList valueForKey:@"selectedButtonTitleColor"] mutableCopy];
    _bingoButtonTitleColor=[[themeList valueForKey:@"bingoButtonTitleColor"] mutableCopy];
    _gameFontColor=[[themeList valueForKey:@"gameFontTitleColor"] mutableCopy];
    _bingoFontColor=[[themeList valueForKey:@"bingoFontTitleColor"] mutableCopy];
    
    if ([[themeList valueForKey:@"mainBg"] isKindOfClass:[NSString class]])
    {
        _mainBackground=[themeList valueForKey:@"mainBg"];
    }
    else
    {
        _mainBackground=[[themeList valueForKey:@"mainBg"]mutableCopy];
    }
    
    if ([[themeList valueForKey:@"initialButtonBg"] isKindOfClass:[NSString class]])
    {
        _initialButton=[themeList valueForKey:@"initialButtonBg"];
    }
    else
    {
        _initialButton=[[themeList valueForKey:@"initialButtonBg"]mutableCopy];
    }
    
    if ([[themeList valueForKey:@"selectedButtonBg"] isKindOfClass:[NSString class]])
    {
        _selectedButton=[themeList valueForKey:@"selectedButtonBg"];
    }
    else
    {
        _selectedButton=[[themeList valueForKey:@"selectedButtonBg"]mutableCopy];
    }
    
    if ([[themeList valueForKey:@"bingoButtonBg"] isKindOfClass:[NSString class]])
    {
        _bingoButton=[themeList valueForKey:@"bingoButtonBg"];
    }
    else
    {
        _bingoButton=[[themeList valueForKey:@"bingoButtonBg"]mutableCopy];
    }
    
    _selectedFlag=NO;
    
}


@end
