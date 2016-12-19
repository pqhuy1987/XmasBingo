//
//  PopUpView.h
//  DotSpaceConqueror
//
//  Created by feialoh  on 06/03/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"

@protocol popViewDelegate<NSObject>

@optional

-(void) popCloseButtonPressed:(UIButton *)popView;

@end


@interface PopUpView : UIView

@property (nonatomic,assign) id <popViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *mainBackgroundImage;

@property (weak, nonatomic) IBOutlet UILabel *popUpTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITextView *popUpMessageLabel;

@property (retain, nonatomic) IBOutlet UIView *popView;

- (IBAction)closeButtonAction:(UIButton *)sender;

-(id)initWithdelegate:(id)parent WithFrame:(CGRect)customFrame WithTitle:(NSString *)title WithTitleSize:(CGFloat)titleSize WithMessage:(NSString *)message WithMessageSize:(CGFloat)messageSize AndView:(UIView *)myView;
-(void)show;

@end
