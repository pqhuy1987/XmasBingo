//
//  FinalScoreView.h
//  DotSpaceConqueror
//
//  Created by feialoh  on 06/03/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModal.h"
#import "PopUpView.h"

@protocol finalPopViewDelegate<NSObject>

@optional

-(void) closeButtonPressed:(UIButton *)popView;

@end


@interface FinalScoreView : UIView<popViewDelegate>

@property (nonatomic,assign) id <finalPopViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *finalScoreLabel;

@property (weak, nonatomic) IBOutlet UIView *popView;

-(id)initWithdelegate:(id)parent withDetails:(NSMutableArray *)playerDetails;
-(void)show;

- (IBAction)closeButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *finalScoreScroll;


@property (weak, nonatomic) IBOutlet UIButton *closeButtonOut;
@property (weak, nonatomic) IBOutlet UIImageView *finalScoreBg;
@end
