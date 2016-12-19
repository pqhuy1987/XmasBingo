//
//  InviteFriendsCell.h
//  DotSpaceConqueror
//
//  Created by feialoh on 26/09/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteFriendsCell;
@protocol CustomCellViewDelegate<NSObject>

@optional

-(void) onAddButtonTouched:(InviteFriendsCell *)sender;

@end

@interface InviteFriendsCell : UITableViewCell

@property (nonatomic,assign) id <CustomCellViewDelegate> delegate;

@property NSUInteger index;
@property NSUInteger section;
@property(nonatomic,weak)IBOutlet UIImageView *thumbImage;
@property(nonatomic,weak)IBOutlet UIImageView *aDCImage;
@property(nonatomic,weak)IBOutlet UILabel *friendName;
@property(nonatomic,weak)IBOutlet UIButton *addButton;
@property(nonatomic,weak)IBOutlet UIButton *colorButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)addButtonAction:(UIButton *)sender;

// inn app product cell properties
@property (nonatomic, retain) NSString *productId;
@property(nonatomic,weak)IBOutlet UILabel *cellSubtitle;
@end
