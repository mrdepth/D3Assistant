//
//  ProfileHeaderView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileHeaderView;
@protocol ProfileHeaderViewDelegate
- (void) profileHeaderViewDidPressFavoritesButton:(ProfileHeaderView*) profileHeaderView;

@end

@interface ProfileHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *battleTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (nonatomic, strong) NSDictionary* profile;
@property (nonatomic, weak) id<ProfileHeaderViewDelegate> delegate;

- (IBAction) onFavorites:(id)sender;
@end