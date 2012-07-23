//
//  AnimationBoardScene.m
//  Spritemation
//
//  Created by Craig Hinrichs on 7/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationBoardScene.h"


@implementation AnimationBoardScene
- (id) init {
    if((self = [super init])) {
        layer = [AnimationBoardLayer node];
        [self addChild:layer];
        
    }
    return self;
}

- (id) getDelegate {
    return layer;
}
@end
