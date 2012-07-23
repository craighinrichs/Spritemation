//
//  AnimationBoardLayer.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AnimationBoardDelegate.h"
#import "TouchableSprite.h"

@interface AnimationBoardLayer : CCLayer<AnimationBoardDelegate> {
    TouchableSprite *currentSelectedSprite;
    CGPoint startlocation;
    UIRotationGestureRecognizer *rotate;
    UIPinchGestureRecognizer *pinch;
    float lastRotation;
    float lastScale;
}
- (void) spriteWasSelected:(TouchableSprite *) selectedSprite;
@end

