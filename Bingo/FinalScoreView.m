//
//  FinalScoreView.m
//  DotSpaceConqueror
//
//  Created by feialoh  on 06/03/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import "FinalScoreView.h"

@interface FinalScoreView ()
{
    ThemeModal *theme;
    NSMutableArray *gridDetails;
}
@end

@implementation FinalScoreView

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

-(id)initWithdelegate:(id)parent withDetails:(NSMutableArray *)playerDetails
{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, 300, 300)])
    {
        // Initialization code
        self=(FinalScoreView*)[[[NSBundle mainBundle] loadNibNamed:@"FinalScoreView" owner:nil options:nil] lastObject] ;
        
        self.delegate=parent;
        [((UIViewController*)parent).view addSubview:self];
        self.hidden=YES;
        theme=[[ThemeModal alloc]init];
        [theme setTheme:_finalScoreBg];
        
//        [_finalScoreBg setImage:[UIImage imageNamed:theme.mainBackground]];
        
        [_closeButtonOut.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
        [_closeButtonOut setTitleColor:theme.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
        
        [_finalScoreLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
        [_finalScoreLabel setTextColor:theme.gameFontColor];
        
        if ([[UIScreen mainScreen] bounds].size.height<568.0f)
        {
        _closeButtonOut.frame=CGRectMake(_closeButtonOut.frame.origin.x, _closeButtonOut.frame.origin.y-40, _closeButtonOut.frame.size.width, _closeButtonOut.frame.size.height);
        
        }
//        if ([[UIScreen mainScreen] bounds].size.height<568.0f)
//        {
//            _popView.frame=CGRectMake(_popView.frame.origin.x, _popView.frame.origin.y-50, _popView.frame.size.width, _popView.frame.size.height);
//            _finalScoreBg.frame=CGRectMake(_finalScoreBg.frame.origin.x, _finalScoreBg.frame.origin.y+35, _finalScoreBg.frame.size.width, _finalScoreBg.frame.size.height-80);
//            
//            _finalScoreScroll.frame=CGRectMake(_finalScoreScroll.frame.origin.x, _finalScoreScroll.frame.origin.y+35, _finalScoreScroll.frame.size.width, _finalScoreScroll.frame.size.height-80);
//            
//            _closeButtonOut.frame=CGRectMake(_closeButtonOut.frame.origin.x, _closeButtonOut.frame.origin.y-40, _closeButtonOut.frame.size.width, _closeButtonOut.frame.size.height);
//            
//            _finalScoreLabel.frame=CGRectMake(_finalScoreLabel.frame.origin.x, _finalScoreLabel.frame.origin.y+10, _finalScoreLabel.frame.size.width, _finalScoreLabel.frame.size.height);
//        }

        gridDetails=[[NSMutableArray alloc]init];
        
        for (UIView *gridView in [playerDetails valueForKey:@"playerGrid"])
        {
            gridView.frame=CGRectMake(0, 0, 320, 420);
            UIGraphicsBeginImageContext(gridView.frame.size);
            [[UIImage imageNamed:theme.mainBackground] drawInRect:gridView.bounds];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            gridView.backgroundColor = [UIColor colorWithPatternImage:image];
            [gridDetails addObject:gridView];
            
        }
       
        
        [self fillScoreDetails:playerDetails];
    }
    
    return self;
}

-(void)fillScoreDetails:(NSMutableArray *)playerScore
{
    float y=10,maxWidth=100, maxHeight=300;CGSize myStringSize;
    UILabel *playerlabel,*scorelabel,*resultLabel; NSString *labels,*status;
    
    
    for (NSUInteger i=0;i<playerScore.count;i++)
    {
        labels=[self getFilteredName:[[playerScore objectAtIndex:i]valueForKey:@"player"]];
        
        if (labels.length>10)
        {
            labels=[NSString stringWithFormat:@"%@... : ",[labels substringToIndex:10]];
        }
        else
        {
            labels=[NSString stringWithFormat:@"%@ : ",labels];
        }
        myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                     }];
        
        playerlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y,myStringSize.width , myStringSize.height)];
        playerlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        playerlabel.backgroundColor = [UIColor clearColor];
        playerlabel.text=labels;
        playerlabel.font = [self myFontWithSize:25];
        playerlabel.textColor=theme.gameFontColor;
        
        
        if ([[[playerScore objectAtIndex:i]valueForKey:@"winStatus"] boolValue])
        {
            status=@"Won";
        }
        else
        {
            status=@"Lost";
        }
        
        labels=[NSString stringWithFormat:@"%@ : ",status];
        myStringSize = [labels sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:25]
                                                     }];
        
        scorelabel = [[UILabel alloc] initWithFrame:CGRectMake(playerlabel.frame.origin.x+playerlabel.frame.size.width, y,myStringSize.width ,  myStringSize.height)];
        scorelabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        scorelabel.backgroundColor = [UIColor clearColor];
        scorelabel.text=status;
        scorelabel.font = [self myFontWithSize:25];
        scorelabel.textColor=theme.gameFontColor ;
        
        UIButton *viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [viewButton addTarget:self action:@selector(showPlayerGrids:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setTag:i];
        
        [viewButton setBackgroundImage:[UIImage imageNamed:@"ViewImage"] forState:UIControlStateNormal];
//        [viewButton setTitle:@"(View Grid)" forState:UIControlStateNormal];
        [viewButton.titleLabel setFont:[UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:25.0]];
        [viewButton setTitleColor:theme.gameFontColor forState:UIControlStateNormal & UIControlStateSelected];
        [viewButton.layer setCornerRadius:7];
        [viewButton setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
        [viewButton sizeToFit];
        viewButton.frame=CGRectMake(scorelabel.frame.origin.x+scorelabel.frame.size.width, y-10, viewButton.frame.size.width, viewButton.frame.size.height);
        
        if (maxWidth<viewButton.frame.origin.x+viewButton.frame.size.width)
        {
            maxWidth=viewButton.frame.origin.x+viewButton.frame.size.width;
        }
        
        [_finalScoreScroll addSubview:viewButton];

        
        y+=50;
        [_finalScoreScroll addSubview:playerlabel];
        [_finalScoreScroll addSubview:scorelabel];
    }

   myStringSize = [ [self getFilteredName:[[playerScore objectAtIndex:0]valueForKey:@"player"]] sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:30]}];
    
    resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, y,2*myStringSize.width , 30.0f)];
    resultLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    resultLabel.backgroundColor = [UIColor clearColor];
    resultLabel.text=@"";
    
//    for (int i=0;i<playerScore.count; i++)
//    {
//        if ([[[playerScore objectAtIndex:i]valueForKey:@"winStatus"] boolValue])
//        {
//            resultLabel.text=[resultLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",[self getFilteredName:[[playerScore objectAtIndex:i]valueForKey:@"player"]]]];
//        }
//    }
//    
//    resultLabel.text=[resultLabel.text stringByAppendingString:@"Won the Game"];
    
    NSMutableArray *nameArray=[[NSMutableArray alloc]init]; NSString *message=@"";
    
    for (int i=0;i<playerScore.count; i++)
    {
        if ([[[playerScore objectAtIndex:i]valueForKey:@"winStatus"] boolValue])
        {
           NSString *addlabels=[self getFilteredName:[[playerScore objectAtIndex:i]valueForKey:@"player"]];
            
            if (addlabels.length>10)
            {
                addlabels=[NSString stringWithFormat:@"%@... ",[addlabels substringToIndex:10]];
            }

            
            [nameArray addObject:addlabels];
        }
    }
    
    
    if (!nameArray.count)
    {
        message=@"You ";
    }
    else
    {
        for (int i=0;i<nameArray.count-1; i++)
        {
            message=[message stringByAppendingString:[NSString stringWithFormat:@"%@, ",[nameArray objectAtIndex:i]]];
        }
        
        
        if (message.length>2)
        {
            message= [message substringToIndex:message.length-2];
        }
        
        if (nameArray.count==1)
        {
            message=[message stringByAppendingString:[NSString stringWithFormat:@"%@ ",[nameArray objectAtIndex:nameArray.count-1]]];
        }
        else
        {
            message=[message stringByAppendingString:[NSString stringWithFormat:@" & %@ ",[nameArray objectAtIndex:nameArray.count-1]]];
        }
    }
    message=[message stringByAppendingString:@"Won the Game"];
    
    resultLabel.text=message;
    
    myStringSize = [resultLabel.text sizeWithAttributes: @{NSFontAttributeName:[self myFontWithSize:30]}];
    
    resultLabel.frame=CGRectMake(10, resultLabel.frame.origin.y, myStringSize.width, resultLabel.frame.size.height);
    
    resultLabel.font = [self myFontWithSize:20];
    resultLabel.textColor=theme.gameFontColor ;
    
    if (resultLabel.frame.origin.y+resultLabel.frame.size.height+10<maxHeight)
    {
        maxHeight=resultLabel.frame.origin.y+resultLabel.frame.size.height+10;

    }
    
    _finalScoreScroll.frame=CGRectMake(_finalScoreScroll.frame.origin.x, _finalScoreScroll.frame.origin.y, _finalScoreScroll.frame.size.width, maxHeight);
    
//    NSLog(@"Height:%f",resultLabel.frame.origin.y+resultLabel.frame.size.height);
    [_finalScoreScroll addSubview:resultLabel];
    _finalScoreScroll.contentSize =CGSizeMake(maxWidth, resultLabel.frame.origin.y+resultLabel.frame.size.height+10);
    
    _closeButtonOut.frame=CGRectMake(_closeButtonOut.frame.origin.x, _finalScoreScroll.frame.origin.y+_finalScoreScroll.frame.size.height+10, _closeButtonOut.frame.size.width, _closeButtonOut.frame.size.height);
}


-(NSString*) getFilteredName:(NSString *)str
{
    NSRange equalRange =  [str rangeOfString:@"$#$#$-"];
    if (equalRange.location != NSNotFound) {
        NSString *result = [str substringToIndex:equalRange.location];
        NSLog(@"The result = %@", result);
        return result;
    } else {
        NSLog(@"There is no = in the string");
        return str;
    }
    
}

//Get font with size
-(UIFont *)myFontWithSize:(CGFloat)size
{
    
   return [UIFont fontWithName:[Reusables getDefaultValue:GAME_FONT] size:size];

//     return [UIFont fontWithName:@"Papyrus" size:size];
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

-(void)showPlayerGrids:(UIButton *)sender
{
    UIView *selectedView=[gridDetails objectAtIndex:sender.tag];
    
    PopUpView *popUp=[[PopUpView alloc]initWithdelegate:self.delegate WithFrame:selectedView.frame WithTitle:@"" WithTitleSize:0 WithMessage:@"" WithMessageSize:0 AndView:selectedView];
    
    [popUp show];
//    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//    [alertView setContainerView:[gridDetails objectAtIndex:sender.tag]];
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK", nil]];
//    [alertView setDelegate:self];
//    [alertView setUseMotionEffects:true];
//    [alertView show];

    
    NSLog(@"Buton tag:%ld",(long)sender.tag);
}


- (IBAction)closeButton:(UIButton *)sender
{
    [self.delegate closeButtonPressed:sender];
    self.hidden=YES;
//    [self removeFromSuperview];
}

-(void)popCloseButtonPressed:(UIButton *)popView
{
    
}

@end
