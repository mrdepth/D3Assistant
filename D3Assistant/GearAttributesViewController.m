//
//  GearAttributesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "GearAttributesViewController.h"

@interface GearAttributesViewController ()

@end

@implementation GearAttributesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.attributesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttributesViewController"];
	self.gearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GearViewController"];
	[self addChildViewController:self.attributesViewController];
	[self addChildViewController:self.gearViewController];
	[self.view addSubview:self.attributesViewController.view];
	[self.view addSubview:self.gearViewController.view];

	[self.attributesViewController didMoveToParentViewController:self];
	[self.gearViewController didMoveToParentViewController:self];
}

- (void) viewDidLayoutSubviews {
	CGRect frame = self.attributesViewController.view.frame;
	frame.origin = CGPointMake(0, 0);
	frame.size.width = 320;
	self.attributesViewController.view.frame = frame;
	
	frame = self.gearViewController.view.frame;
	frame.origin = CGPointMake(self.attributesViewController.view.frame.size.width, 0);
	frame.size.width = self.view.frame.size.width - self.attributesViewController.view.frame.size.width;
	self.gearViewController.view.frame = frame;
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
