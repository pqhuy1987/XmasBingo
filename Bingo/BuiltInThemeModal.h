//
//  BuiltInThemeModal.h
//  Bingo
//
//  Created by feialoh on 04/09/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuiltInThemeModal : NSObject

@property (copy) NSString *themeName;
@property  BOOL selectedFlag;
@property (copy)  id mainBackground;
@property (copy)  id initialButton;
@property (copy)  id selectedButton;
@property (copy)  id bingoButton;

@property (copy) NSMutableDictionary *initialButtonTitleColor;
@property (copy) NSMutableDictionary *selectedButtonTitleColor;
@property (copy) NSMutableDictionary *bingoButtonTitleColor;
@property (copy) NSMutableDictionary *gameFontColor;
@property (copy) NSMutableDictionary *bingoFontColor;


- (void)setBuiltInTheme:(NSDictionary *)themeList;
@end
