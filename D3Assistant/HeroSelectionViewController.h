//
//  HeroSelectionViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 09.10.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProfilesViewController.h"

@class HeroSelectionViewController;
@protocol HeroSelectionViewControllerDelegate <NSObject>
- (void) heroSelectionViewController:(HeroSelectionViewController*) controller didSelectHero:(NSDictionary*) hero;
@end

@interface HeroSelectionViewController : ProfilesViewController
@property (nonatomic, assign) IBOutlet id<HeroSelectionViewControllerDelegate> delegate;

- (IBAction)onCancel:(id)sender;

@end
