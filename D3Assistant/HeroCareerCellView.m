//
//  HeroCareerCellView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 12.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "HeroCareerCellView.h"

@implementation HeroCareerCellView
@synthesize progressionView;

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
