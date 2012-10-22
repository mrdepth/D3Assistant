//
//  HeroSelectionViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 09.10.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "HeroSelectionViewController.h"

@interface HeroSelectionViewController ()

@end

@implementation HeroSelectionViewController
@synthesize delegate;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) didSelectHero:(NSDictionary*) hero {
	[self.delegate heroSelectionViewController:self didSelectHero:hero];
	[self dismissModalViewControllerAnimated:YES];
}

@end
