//
//  ImageSelectTableViewController.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/19/12.
//
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "AnimationBoardDelegate.h"
@interface ImageSelectTableViewController : UITableViewController {
    DBRestClient* restClient;
    
    NSArray* photoPaths;
    NSString* photosHash;
    //NSString* currentPhotoPath;
    BOOL working;
}
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) id bdelegate;
@end
