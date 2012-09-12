//
//  UIAlertView+Block.m
//  
//
//  Created by Artem Shimanski on 14.08.12.
//
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

@interface UIAlertView()
@property (nonatomic, copy) void (^completionBlock)(UIAlertView* alertView, NSInteger selectedButtonIndex);
@property (nonatomic, copy) void (^cancelBlock)();
@end

@implementation UIAlertView (Block)

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	   cancelButtonTitle:(NSString *)cancelButtonTitle
	   otherButtonTitles:(NSArray*) titles
		 completionBlock:(void (^)(UIAlertView* alertView, NSInteger selectedButtonIndex)) completionBlock
			 cancelBlock:(void (^)()) cancelBlock {
#if ! __has_feature(objc_arc)
	return [[[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:titles completionBlock:completionBlock cancelBlock:cancelBlock] autorelease];
#else
	return [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:titles completionBlock:completionBlock cancelBlock:cancelBlock];
#endif
}

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSArray*) titles
	completionBlock:(void (^)(UIAlertView* alertView, NSInteger selectedButtonIndex)) completionBlock
		cancelBlock:(void (^)()) cancelBlock {
	if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]) {
		for (NSString* otherButtonTitle in titles)
			[self addButtonWithTitle:otherButtonTitle];
		self.completionBlock = completionBlock;
		self.cancelBlock = cancelBlock;
	}
	return self;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (self.completionBlock) {
		self.completionBlock(self, buttonIndex);
		self.completionBlock = nil;
	}
	self.cancelBlock = nil;
}

- (void) alertViewCancel:(UIAlertView *)alertView {
	if (self.cancelBlock) {
		self.cancelBlock();
		self.cancelBlock = nil;
	}
	self.completionBlock = nil;
}
#pragma mark - Private

- (void) setCompletionBlock:(void (^)(UIAlertView*, NSInteger))completionBlock {
	objc_setAssociatedObject(self, @"completionBlock", completionBlock, OBJC_ASSOCIATION_COPY);
}

- (void(^)(UIAlertView*, NSInteger)) completionBlock {
	return objc_getAssociatedObject(self, @"completionBlock");
}

- (void) setCancelBlock:(void (^)())cancelBlock {
	objc_setAssociatedObject(self, @"cancelBlock", cancelBlock, OBJC_ASSOCIATION_COPY);
}

- (void(^)()) cancelBlock {
	return objc_getAssociatedObject(self, @"cancelBlock");
}


@end
