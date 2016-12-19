//
//  InviteFriendsCell.m
//  DotSpaceConqueror
//
//  Created by feialoh on 26/09/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import "InviteFriendsCell.h"

@implementation InviteFriendsCell
@synthesize productId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

   

- (IBAction)addButtonAction:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.delegate onAddButtonTouched:self];

}
@end
