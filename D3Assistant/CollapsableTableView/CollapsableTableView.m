//
//  CollapsableTableView.m
//  CollapsableTableView
//
//  Created by Artem Shimanski on 13.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "CollapsableTableView.h"
#import <objc/runtime.h>

@interface SectionHeaderTapGestureRecognizer : UITapGestureRecognizer<UIGestureRecognizerDelegate>
@property (nonatomic, assign) UITableView* tableView;

@end

@implementation SectionHeaderTapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	CGPoint p = [touch locationInView:self.tableView];
	NSInteger numberOfSections = [self.tableView numberOfSections];
	for (NSInteger section = 0; section < numberOfSections; section++)
		if (CGRectContainsPoint([self.tableView rectForHeaderInSection:section], p))
			return YES;
	return NO;
}

@end

@interface CollapsableTableView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* sections;
@property (nonatomic, assign) BOOL updateTransaction;
@property (nonatomic, strong) NSMutableIndexSet* insertSections;
@property (nonatomic, strong) NSMutableIndexSet* deleteSections;
@property (nonatomic, strong) NSMutableArray* moveSections;

- (void) onTap:(UITapGestureRecognizer*) recognizer;
@end

@implementation CollapsableTableView
@synthesize delegate;
@synthesize dataSource;
@synthesize sections;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
	[super setDelegate:(id)self];
	[super setDataSource:(id)self];
	SectionHeaderTapGestureRecognizer* recognizer = [[SectionHeaderTapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
	recognizer.delegate = recognizer;
	recognizer.tableView = self;
	for (UIGestureRecognizer* r in self.gestureRecognizers)
		[recognizer requireGestureRecognizerToFail:r];
	[self addGestureRecognizer:recognizer];
}

- (void) reloadData {
	self.sections = nil;
	[super reloadData];
}

- (BOOL) respondsToSelector:(SEL)aSelector {
	return [CollapsableTableView instancesRespondToSelector:aSelector] || [delegate respondsToSelector:aSelector] || [dataSource respondsToSelector:aSelector];
}

- (id) forwardingTargetForSelector:(SEL)aSelector {
	if ([delegate respondsToSelector:aSelector])
		return delegate;
	else if ([dataSource respondsToSelector:aSelector])
		return dataSource;
	else
		return nil;
}

- (void) setDelegate:(id<CollapsableTableViewDelegate>)value {
	if ((id) value != self)
		delegate = value;
	else
		[super setDelegate:value];
}

- (void) setDataSource:(id<UITableViewDataSource>)value {
	if ((id) value != self)
		dataSource = value;
	else
		[super setDataSource:value];
}

- (id<UITableViewDataSource>) dataSource {
	return [super dataSource];
}

- (id<CollapsableTableViewDelegate>) delegate {
	return (id<CollapsableTableViewDelegate>) [super delegate];
}

- (void) beginUpdates {
	[super beginUpdates];
	self.updateTransaction = YES;
	self.insertSections = [NSMutableIndexSet indexSet];
	self.deleteSections = [NSMutableIndexSet indexSet];
	self.moveSections = [NSMutableArray array];
}

- (void) endUpdates {
	[self.sections removeObjectsAtIndexes:self.deleteSections];

	NSInteger number = [self.insertSections count];
	NSMutableArray* objects = [NSMutableArray array];
	for (NSInteger i = 0; i < number; i++)
		[objects addObject:[NSNull null]];
	[self.sections insertObjects:objects atIndexes:self.insertSections];

	[super endUpdates];
	self.updateTransaction = NO;
	self.insertSections = nil;
	self.deleteSections = nil;
	self.moveSections = nil;
}

- (void) insertSections:(NSIndexSet *)aSections withRowAnimation:(UITableViewRowAnimation)animation {
	if (self.updateTransaction) {
		[self.insertSections addIndexes:aSections];
	}
	else {
		NSInteger number = [aSections count];
		NSMutableArray* objects = [NSMutableArray array];
		for (NSInteger i = 0; i < number; i++)
			[objects addObject:[NSNull null]];
		[self.sections insertObjects:objects atIndexes:aSections];
	}
	[super insertSections:aSections withRowAnimation:animation];
}

- (void) deleteSections:(NSIndexSet *)aSections withRowAnimation:(UITableViewRowAnimation)animation {
	if (self.updateTransaction)
		[self.deleteSections addIndexes:aSections];
	else
		[self.sections removeObjectsAtIndexes:aSections];
	[super deleteSections:aSections withRowAnimation:animation];
}

- (void) moveSection:(NSInteger)section toSection:(NSInteger)newSection {
	if ([super respondsToSelector:@selector(moveSection:toSection:)]) {
		if (self.updateTransaction)
			[self.moveSections addObject:@{@"from" : @(section), @"to" : @(newSection)}];
		[super moveSection:section toSection:newSection];
	}
}

- (NSMutableArray*) sections {
	if (!sections) {
		sections = [[NSMutableArray alloc] init];
		NSInteger numberOfSections = [self numberOfSections];
		self.sections = [NSMutableArray arrayWithCapacity:numberOfSections];
		for (NSInteger section = 0; section < numberOfSections; section++)
			[self.sections addObject:[NSNull null]];
	}
	return sections;
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSNumber* collapsed = [self.sections objectAtIndex:section];
	if ((NSNull*) collapsed == [NSNull null]) {
		if ([self.delegate respondsToSelector:@selector(tableView:sectionIsCollapsed:)])
			collapsed = @([delegate tableView:tableView sectionIsCollapsed:section]);
		else
			collapsed =  @(NO);
		[self.sections replaceObjectAtIndex:section withObject:collapsed];
	}
	if ([collapsed boolValue])
		return 0;
	else
		return [dataSource tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - Private

- (void) onTap:(UITapGestureRecognizer *)recognizer {
	CGPoint p = [recognizer locationInView:self];
	NSInteger numberOfSections = [self numberOfSections];
	for (NSInteger section = 0; section < numberOfSections; section++) {
		if (CGRectContainsPoint([self rectForHeaderInSection:section], p)) {
			NSNumber* collapsed = [self.sections objectAtIndex:section];
			if ((NSNull*) collapsed == [NSNull null]) {
				if ([self.delegate respondsToSelector:@selector(tableView:sectionIsCollapsed:)])
					collapsed = @([delegate tableView:self sectionIsCollapsed:section]);
				else
					collapsed =  @(NO);
				[self.sections replaceObjectAtIndex:section withObject:collapsed];
			}
			if ([delegate respondsToSelector:@selector(tableView:canCollapsSection:)] && [delegate tableView:self canCollapsSection:section]) {
				[self.sections replaceObjectAtIndex:section withObject:@(![collapsed boolValue])];
				if ([collapsed boolValue] && [delegate respondsToSelector:@selector(tableView:didExpandSection:)])
					[delegate tableView:self didExpandSection:section];
				else if (![collapsed boolValue] && [delegate respondsToSelector:@selector(tableView:didCollapsSection:)])
					[delegate tableView:self didCollapsSection:section];
				
				[self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
				return;
			}
		}
	}
}

@end
