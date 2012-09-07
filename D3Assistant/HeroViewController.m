//
//  HeroViewController.m
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "HeroViewController.h"
#import "EUOperationQueue.h"
#import "D3APISession.h"

@interface HeroViewController ()
@property (nonatomic, weak) UIView* currentSection;

@end

@implementation HeroViewController
@synthesize headView;
@synthesize shouldersView;
@synthesize torsoView;
@synthesize feetView;
@synthesize handsView;
@synthesize legsView;
@synthesize bracersView;
@synthesize mainHandView;
@synthesize offHandView;
@synthesize waistView;
@synthesize leftFingerView;
@synthesize rightFingerView;
@synthesize neckView;
@synthesize gearsView;
@synthesize attributesTableView;
@synthesize attributesDataSource;

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
	self.attributesDataSource.hero = self.hero;
	self.title = [self.hero valueForKey:@"name"];
	
	self.attributesTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundTable.png"]];
    // Do any additional setup after loading the view from its nib.
	
	
	NSDictionary* gear = @{@"head" : headView, @"shoulders" : shouldersView, @"torso" : torsoView, @"feet" : feetView, @"hands" : handsView, @"legs" : legsView, @"bracers" : bracersView,
	@"mainHand" : mainHandView, @"offHand" : offHandView, @"waist" : waistView, @"leftFinger" : leftFingerView, @"rightFinger" : rightFingerView, @"neck" : neckView};
	
	
	__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:@"GearViewController+Load" name:@"Loading"];
	
	NSMutableDictionary* gears = [NSMutableDictionary dictionary];
	
	[operation addExecutionBlock:^{
		@autoreleasepool {
			operation.progress = 0;
			D3APISession* session = [D3APISession sharedSession];
			
			NSDictionary* items = [self.hero valueForKey:@"items"];
			NSInteger n = items.count;
			NSInteger i = 0;
			for (NSString* key in [items allKeys]) {
				NSDictionary* item = [items valueForKey:key];
				item = [session itemInfoWithItemID:[item valueForKey:@"tooltipParams"] error:nil];
				if (item)
					[gears setValue:item forKey:key];

				operation.progress = (float) ++i / (float) n;
			}
		}
	}];
	
	[operation setCompletionBlockInCurrentThread:^{
		if (![operation isCancelled]) {
			for (NSString* key in [gears allKeys]) {
				[[gear valueForKey:key] setGear:[gears valueForKey:key]];
			}
		}
	}];
	
	[[EUOperationQueue sharedQueue] addOperation:operation];
	
	self.currentSection = self.gearsView;
	[self.view addSubview:self.currentSection];
	self.currentSection.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}

- (void)viewDidUnload
{
    [self setHeadView:nil];
    [self setShouldersView:nil];
	[self setTorsoView:nil];
	[self setFeetView:nil];
	[self setHandsView:nil];
	[self setLegsView:nil];
	[self setBracersView:nil];
	[self setMainHandView:nil];
	[self setOffHandView:nil];
	[self setWaistView:nil];
	[self setLeftFingerView:nil];
	[self setRightFingerView:nil];
	[self setNeckView:nil];
	[self setAttributesTableView:nil];
	[self setAttributesDataSource:nil];
	[self setGearsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onChangeSection:(id)sender {
	[self.currentSection removeFromSuperview];
	NSArray* sections = @[gearsView, attributesTableView];
	self.currentSection = [sections objectAtIndex:[sender selectedSegmentIndex]];
	[self.view addSubview:self.currentSection];
	self.currentSection.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}

@end
