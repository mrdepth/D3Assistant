//
//  DATask.m
//  D3Assistant
//
//  Created by Artem Shimanski on 11.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DATask.h"

@implementation DATask

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void) main {
    self.block(self);
}

- (void) start {
    @autoreleasepool {
        if (self.completionHandler) {
            DATask* __weak weakSelf = self;
            [self setCompletionBlock:^{
                if ([NSThread isMainThread])
                    weakSelf.completionHandler(weakSelf);
                else {
                    DATask* strongSelf = weakSelf;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf.completionHandler(strongSelf);
                    });
                }
            }];
        }
        [self.delegate taskWillStart:self];
        [super start];
        [self.delegate taskDidFinish:self];
    }
}

- (void) setProgress:(float)progress {
    _progress = progress;
    [self.delegate task:self didChangeProgress:progress];
}

@end
