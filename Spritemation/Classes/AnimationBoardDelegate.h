//
//  AnimationBoardDelegate.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/22/12.
//
//

#import <Foundation/Foundation.h>

@protocol AnimationBoardDelegate <NSObject>
- (void) addSpriteToScene:(NSString *) filename;
@end