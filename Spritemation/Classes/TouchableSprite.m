//
//  MyCocos2DClass.m
//  TouchableSprite
//
//  Created by Craig Hinrichs on 7/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchableSprite.h"
#import "AnimationBoardLayer.h"

@implementation TouchableSprite
-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
    if( (self=[super initWithTexture:texture rect:rect])) {
        
    }
    return self;
}

- (void) draw {
    if(self.selected) {
        CGPoint vertices[4] = {
            ccp( quad_.bl.vertices.x, quad_.bl.vertices.y ),
            ccp( quad_.br.vertices.x, quad_.br.vertices.y ),
            ccp( quad_.tr.vertices.x, quad_.tr.vertices.y ),
            ccp( quad_.tl.vertices.x, quad_.tl.vertices.y ),
        };
        ccDrawPoly(vertices, 4, YES);
    }
    [super draw];
}
- (void) touchedSprite {
    //NSLog(@"Selected sprite");
    //[self removeFromParentAndCleanup:YES];
    self.selected = !self.selected;
    [(AnimationBoardLayer*)self.parent spriteWasSelected:self];
}

- (void) unselect; {
    self.selected = NO;
    self.touched = NO;
}

-(void) onEnter {
	[super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher]  addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void) onExit {
    [super onExit];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    if(CGRectContainsPoint(self.boundingBox, location)) {
        self.touched = YES;
        if(touch.tapCount > 1) {
            [self touchedSprite];
        }
    }
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.touched = NO;
}

@end
