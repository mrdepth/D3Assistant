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
	// Do any additional setup after loading the view.
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
	if (self.heroViewController) {
//		self.dele
	}
	else {
		[self performSegueWithIdentifier:@"HeroInfo" sender:hero];
	}
}

@end
