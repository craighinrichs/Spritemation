//
//  MyCocos2DClass.h
//  TouchableSprite
//
//  Created by Craig Hinrichs on 7/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TouchableSprite : CCSprite<CCTargetedTouchDelegate> {
    
}
- (void) touchedSprite;
- (void) unselect;
@property BOOL selected;
@property BOOL touched;
@end
