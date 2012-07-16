//
//  DropboxImages.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/15/12.
//
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxImagesScrollView : UIScrollView {
    DBRestClient* restClient;
}
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@end
