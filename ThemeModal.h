//
//  ThemeModal.h
//  Bingo
//
//  Created by feialoh on 08/01/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeModal : NSObject

@property (copy) id mainBackground;
@property (copy) id initialButton;
@property (copy) id selectedButton;
@property (copy) id multipleButton;


@property (copy) UIColor *initialButtonTitleColor;
@property (copy) UIColor *selectedButtonTitleColor;
@property (copy) UIColor *multipleButtonTitleColor;
@property (copy) UIColor *gameFontColor;
@property (copy) UIColor *bingoFontColor;

- (void)setTheme:(UIImageView*)_backgroundView;
@end
