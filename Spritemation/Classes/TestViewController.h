//
//  TestViewController.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/15/12.
//
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface TestViewController : UIViewController {
    DBRestClient* restClient;
    
    NSArray* photoPaths;
    NSString* photosHash;
    NSString* currentPhotoPath;
    BOOL working;
}
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@end
