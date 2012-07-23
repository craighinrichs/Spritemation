//
//  AnimationBoardLayer.m
//  Spritemation
//
//  Created by Craig Hinrichs on 7/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationBoardLayer.h"
#import "TouchableSprite.h"

@implementation AnimationBoardLayer
- (id) init {
    if((self = [super init])) {
        self.isTouchEnabled = YES;
        rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:rotate];
        [rotate release];
        pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:pinch];
        [pinch release];
        
    }
    return self;
}

- (void) addSpriteToScene:(NSString *) filename {
    CGSize wins = [[CCDirector sharedDirector] winSize];
    CGPoint center = ccp(wins.width/2,wins.height/2);
    
    TouchableSprite *sprite = [TouchableSprite spriteWithFile:filename];
    sprite.position = center;
    [self addChild:sprite];
    
}

- (void) spriteWasSelected:(TouchableSprite *) selectedSprite {
    for(TouchableSprite *touchsprite in [self children]) {
        if(selectedSprite != touchsprite) {
            touchsprite.selected = NO;
        }
    }
    
    currentSelectedSprite = selectedSprite;
}

- (void) unselectAll {
    for(TouchableSprite *touchsprite in [self children]) {
        touchsprite.selected = NO;
    }
}

#pragma mark -
#pragma mark GestureRecognizer

- (void) rotate:(UIRotationGestureRecognizer *) rotateRecog {
    NSLog(@"Rotate");
    if(rotateRecog.state == UIGestureRecognizerStateBegan) {
        lastRotation = currentSelectedSprite.rotation;
    } else if(rotateRecog.state == UIGestureRecognizerStateChanged) {
        currentSelectedSprite.rotation = CC_RADIANS_TO_DEGREES(rotateRecog.rotation) + lastRotation;
    }
}

- (void) pinch:(UIPinchGestureRecognizer *) pinchRecog {
    NSLog(@"Pinch");
    if(pinchRecog.state == UIGestureRecognizerStateBegan) {
        lastScale = currentSelectedSprite.scale;
    } else if(pinchRecog.state == UIGestureRecognizerStateChanged) {
        currentSelectedSprite.scale = pinchRecog.scale;
    }
    NSLog(@"Last scale %f  currentScale %f",lastScale,pinchRecog.scale);
}

#pragma mark -
#pragma mark Touch Events

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    startlocation = location;
    NSLog(@"YEs");
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    if(currentSelectedSprite.touched && currentSelectedSprite.selected) {
        currentSelectedSprite.position = location;
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void) dealloc {
    [super dealloc];
}
@end
