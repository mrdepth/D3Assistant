//
//  UIImageView+URL.h
//  UIImageView+URL
//
//  Created by Artem Shimanski on 24.08.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIActivityIndicatorViewStyleNone ((UIActivityIndicatorViewStyle)-1)

@interface UIImageView (URL)
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

- (void) setImageWithContentsOfURL: (NSURL*) url completion:(void(^)()) completion failureBlock:(void(^)(NSError *error)) failureBlock;
- (void) cancelAllURLRequests;
@end
