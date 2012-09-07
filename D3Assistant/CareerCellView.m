//
//  CareerCellView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "CareerCellView.h"

@implementation CareerCellView
@synthesize progressionSCView;
@synthesize progressionHCView;

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
