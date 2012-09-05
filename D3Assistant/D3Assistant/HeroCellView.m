//
//  HeroCellView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "HeroCellView.h"

@implementation HeroCellView
@synthesize avatarImageView;
@synthesize frameImageView;
@synthesize nameLabels;
@synthesize classLabel;
@synthesize levelLabel;
@synthesize paragonLevelLabel;
@synthesize deadLabel;

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

@end
