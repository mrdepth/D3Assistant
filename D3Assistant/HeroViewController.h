//
//  HeroViewController.h
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributesViewController.h"
#import "SkillsViewController.h"
#import "GearViewController.h"
#import "GearAttributesViewController.h"

@interface HeroViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *sectionsControl;
@property (strong, nonatomic) GearViewController* gearViewController;
@property (strong, nonatomic) SkillsViewController* skillsViewController;
@property (strong, nonatomic) AttributesViewController* attributesViewController;
@property (strong, nonatomic) GearAttributesViewController* gearAttributesViewController;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong, readonly) NSDictionary* hero;
@property (nonatomic, assign, readonly) BOOL fallen;

- (void) setHero:(NSDictionary *)hero fallen:(BOOL) fallen;

- (IBAction)onChangeSection:(id)sender;

@end
