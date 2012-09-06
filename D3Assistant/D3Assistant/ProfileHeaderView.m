//
//  ProfileHeaderView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView
@synthesize battleTagLabel;
@synthesize favoritesButton;
@synthesize profile;
@synthesize delegate;

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

- (IBAction) onFavorites:(id)sender {
	[self.delegate profileHeaderViewDidPressFavoritesButton:self];
}

@end
