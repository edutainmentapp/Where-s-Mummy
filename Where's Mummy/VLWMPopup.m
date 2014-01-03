#import "VLWMPopup.h"

@interface VLWMPopup ()
@property(nonatomic, strong) UIWindow *window;
@end

@implementation VLWMPopup

@synthesize window;

- (void) show {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    
    self.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    
    [self.window addSubview:self];
    [self.window makeKeyAndVisible];
}

- (void) hide {
    self.window.hidden = YES;
    self.window = nil;
}

@end