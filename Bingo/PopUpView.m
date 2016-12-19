//
//  PopUpView.m
//  DotSpaceConqueror
//
//  Created by feialoh  on 06/03/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "PopUpView.h"

#define ORDER 5

@interface PopUpView ()
{
    ThemeModal *theme;
    
}

@end

@implementation PopUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



-(id)initWithdelegate:(id)parent WithFrame:(CGRect)customFrame WithTitle:(NSString *)title WithTitleSize:(CGFloat)titleSize WithMessage:(NSString *)message WithMessageSize:(CGFloat)messageSize AndView:(UIView *)myView
{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, 300, 300)])
    {
        // Initialization code
        self=(PopUpView*)[[[NSBundle mainBundle] loadNibNamed:@"PopUpView" owner:nil options:nil] lastObject] ;
        
        self.delegate=parent;
        [((UIViewController*)parent).view addSubview:self];
        self.hidden=YES;
        
        //        if ([[UIScreen mainScreen] bounds].size.height<568.0f)
        //        {
        //            _popView.frame=CGRectMake(_popView.frame.origin.x, _popView.frame.origin.y-50, _popView.frame.size.width, _popView.frame.size.height);
        //        }
        
        theme=[[ThemeModal alloc]init];
        [theme setTheme:_mainBackgroundImage];
        
        NSMutableArray *buttons= [[NSMutableArray alloc]init];
        
        for (UILabel *turnLabel in myView.subviews)
        {
            if (turnLabel.tag==777)
            {
                [turnLabel removeFromSuperview];
                break;
            }
        }
        
        for (int i=0;i<myView.subviews.count;i++)
        {
            if ([[myView.subviews objectAtIndex:i] isKindOfClass:[UIButton class]])
            {
                [buttons addObject:[myView.subviews objectAtIndex:i]];
                UIButton *cell=[myView.subviews objectAtIndex:i];
                //                NSLog(@"Button tag:%d,button text:%@, button state:%u",cell.tag,cell.titleLabel.text,cell.state);
                [cell setBackgroundImage:[UIImage imageNamed:theme.initialButton] forState:UIControlStateNormal];
                [cell setBackgroundImage:[UIImage imageNamed:theme.selectedButton] forState:UIControlStateSelected];
                [cell.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
                [cell setTitleColor:theme.initialButtonTitleColor forState:UIControlStateNormal];
                [cell setTitleColor:theme.selectedButtonTitleColor forState:UIControlStateSelected];
            }
            else if([[myView.subviews objectAtIndex:i] isKindOfClass:[UILabel class]])
            {
                
                UILabel *myLabel=[myView.subviews objectAtIndex:i];
                
                CGSize myStringSize = [myLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]}];
                
                myLabel.frame=CGRectMake(myLabel.frame.origin.x, myLabel.frame.origin.y, myStringSize.width, myStringSize.height);
                [myLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
                [myLabel setTextColor:theme.gameFontColor];
            }
        }
        
        [self assignButtonBingoColors:buttons];
        
        [myView setUserInteractionEnabled:NO];
       
        myView.frame=CGRectMake(0, 0, myView.frame.size.width, myView.frame.size.height);
        [_popView addSubview:myView] ;
        
//        [_mainBackgroundImage setImage:[UIImage imageNamed:theme.mainBackground]];
        
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"CloseButtonType1.png"] forState:UIControlStateNormal & UIControlStateSelected];
        
        _closeButton.frame=CGRectMake((_popView.frame.size.width-_closeButton.frame.size.width), myView.frame.origin.y, _closeButton.frame.size.width, _closeButton.frame.size.height);
        
        //         _closeButton.frame=CGRectMake(150, myView.frame.origin.y+ myView.frame.size.height-25, 50, 50);
        
        [_popView sendSubviewToBack:myView];
        [_popView bringSubviewToFront:_closeButton];
        
        [_popUpTitleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:titleSize]];
        [_popUpTitleLabel setTextColor:theme.gameFontColor];
        
        [_popUpMessageLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:messageSize]];
        [_popUpMessageLabel setTextColor:theme.gameFontColor];
    }
    
    return self;
}


-(void)show
{
    self.hidden=NO;
    [self.popView setTransform:CGAffineTransformMakeScale(0.1,0.1)];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.popView setTransform:CGAffineTransformMakeScale(1.0,1.0)];
                     }
                     completion:nil
     ];
}

- (IBAction)closeButtonAction:(UIButton *)sender
{
    [self.delegate popCloseButtonPressed:sender];
    self.hidden=YES;
    [self removeFromSuperview];
}


-(void) assignButtonBingoColors:(NSMutableArray *)_buttons1_25
{
    NSArray *buttonDetails=[[NSArray alloc]init];
    int x,y,x1,y1,myTag;
    BOOL row,col,diag1,diag2;
    row=FALSE;col=FALSE;diag1=FALSE;diag2=FALSE;
    
   
    
    for (int ij=0 ; ij<_buttons1_25.count; ij++)
    {
        
        buttonDetails=[self getTag:[[_buttons1_25 objectAtIndex:ij] tag]];

        myTag=(int)[[buttonDetails objectAtIndex:0] integerValue];
        
        x=myTag/ORDER;
        y=myTag%ORDER;
        
        if (!y)
        {
            y=ORDER;
            x-=1;
        }
        x1=x;
        y1=y;
        
        
        //    NSLog(@"x=%d,y=%d",x+1,y);
        
        
        //Loop to check if 5 buttons in row/col/diag are selected
        //For row check
        
        for (int i=ORDER*x+1; i<=ORDER*x+ORDER; i++)
        {
            
            
            if (![[_buttons1_25 objectAtIndex:i-1] isSelected])
            {
                row=FALSE;
                break;
            }
            
            
            if (i==ORDER*x+ORDER)
            {
                row=TRUE;
            }
        }
        
        
        //For column check
        
        for (int i=0; i<ORDER; i++)
        {
            if (![[_buttons1_25 objectAtIndex:y-1] isSelected])
            {
                col=FALSE;
                break;
            }
            y+=5;
            
            if (i+1==ORDER)
            {
                col=TRUE;
            }
        }
        
        
        //For diagonal1 check
        
        if (y1==x1+1)
        {
            for (int i=0,j=1; i<ORDER; i++,j++)
            {
                if (![[_buttons1_25 objectAtIndex:ORDER*i+j-1] isSelected])
                {
                    diag1=FALSE;
                    break;
                }
                if (i+1==ORDER)
                {
                    diag1=TRUE;
                }
            }
        }
        
        //For diagonal2 check
        
        if (x1+1==ORDER-y1+1)
        {
            
            for (int i=0,j=5; i<ORDER; i++,j--)
            {
                if (![[_buttons1_25 objectAtIndex:ORDER*i+j-1] isSelected])
                {
                    diag2=FALSE;
                    break;
                }
                if (i+1==ORDER)
                {
                    diag2=TRUE;
                }
            }
        }
        
        
        //Same loops above repeated only this time we set the button colors
        
        x=x1;
        y=y1;
        
        if (row)
        {
            
            for (int i=ORDER*x+1; i<=ORDER*x+ORDER; i++)
            {
                UIButton *cell=[_buttons1_25 objectAtIndex:i-1];
                [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
                [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
                
            }
            
            //        bingo++;
        }
        
        
        if (col)
        {
            for (int i=0; i<ORDER; i++)
            {
                UIButton *cell=[_buttons1_25 objectAtIndex:y-1];
                [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
                [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
                y+=5;
            }
            
        }
        
        if (diag1)
        {
            for (int i=0,j=1; i<ORDER; i++,j++)
            {
                UIButton *cell=[_buttons1_25 objectAtIndex:ORDER*i+j-1];
                [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
                [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
            }
            
        }
        
        if (diag2)
        {
            for (int i=0,j=5; i<ORDER; i++,j--)
            {
                UIButton *cell=[_buttons1_25 objectAtIndex:ORDER*i+j-1];
                [cell setBackgroundImage:[UIImage imageNamed:theme.multipleButton] forState:UIControlStateSelected];
                [cell setTitleColor:theme.multipleButtonTitleColor forState:UIControlStateSelected];
            }
            
        }
    }
    
}


//Getting button tag and player
-(NSArray *)getTag:(NSUInteger)buttonTag
{
    NSUInteger order=ORDER*ORDER;
    
    
    NSUInteger diffFactor;
    
    if ((buttonTag%order)==0)
    {
        diffFactor=(buttonTag/order)-1;
    }
    else
    {
        diffFactor=buttonTag/order;
    }
    
    NSUInteger btag=buttonTag-diffFactor*order;
    
    return @[[NSNumber numberWithInteger:btag],[NSNumber numberWithInteger:diffFactor+1]];
}

@end
