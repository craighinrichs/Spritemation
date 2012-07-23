//
//  AnimationBoardScene.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AnimationBoardLayer.h"

@interface AnimationBoardScene : CCScene {
    AnimationBoardLayer *layer;
}
- (id) getDelegate;
@end
