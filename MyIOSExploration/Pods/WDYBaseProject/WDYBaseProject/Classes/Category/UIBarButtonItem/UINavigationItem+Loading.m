
#import "UINavigationItem+Loading.h"
#import <objc/runtime.h>

static void *LoaderPositionAssociationKey = &LoaderPositionAssociationKey;
static void *SubstitutedViewAssociationKey = &SubstitutedViewAssociationKey;

@implementation UINavigationItem (Loading)

- (void)startAnimatingAt:(NavBarLoaderPosition)position {
    // stop previous if animated
    [self stopAnimating];
    
    // hold reference for position to stop at the right place
    objc_setAssociatedObject(self, LoaderPositionAssociationKey, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView* loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // substitute bar views to loader and hold reference to them for restoration
    switch (position) {
        case NavBarLoaderPositionLeft:
            objc_setAssociatedObject(self, SubstitutedViewAssociationKey, self.leftBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.leftBarButtonItem.customView = loader;
            break;
            
        case NavBarLoaderPositionCenter:
            objc_setAssociatedObject(self, SubstitutedViewAssociationKey, self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.titleView = loader;
            break;
            
        case NavBarLoaderPositionRight:
            objc_setAssociatedObject(self, SubstitutedViewAssociationKey, self.rightBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.rightBarButtonItem.customView = loader;
            break;
    }
    
    [loader startAnimating];
}

- (void)stopAnimating {
    NSNumber* positionToRestore = objc_getAssociatedObject(self, LoaderPositionAssociationKey);
    id componentToRestore = objc_getAssociatedObject(self, SubstitutedViewAssociationKey);
    
    // restore UI if animation was in a progress
    if (positionToRestore) {
        switch (positionToRestore.intValue) {
            case NavBarLoaderPositionLeft:
                self.leftBarButtonItem.customView = componentToRestore;
                break;
                
            case NavBarLoaderPositionCenter:
                self.titleView = componentToRestore;
                break;
                
            case NavBarLoaderPositionRight:
                self.rightBarButtonItem.customView = componentToRestore;
                break;
        }
    }
    
    objc_setAssociatedObject(self, LoaderPositionAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, SubstitutedViewAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
