//
//  VLWMItemCell.m
//  Where's Mummy
//
//  Created by Vu Long on 23/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMItemCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation VLWMItemCell
{
    NSMutableArray *nextPoint;
    NSMutableArray *jumpPoint;
    NSInteger jumpIdxNext;
    NSInteger miZoomCount;
    float fItemWidth;
    float fDelayTime;
    BOOL mbAniForceStop;
}
NSInteger MI_MAX_ZOOM = 4;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)createPoints
{
    //-A-B-C-
    //D--E--F
    //G--H--I
    CGPoint pointA = CGPointMake(CGRectGetWidth(self.frame)/8, self.frame.size.height/8);//A
    CGPoint pointB = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/8);//B
    CGPoint pointC = CGPointMake(CGRectGetWidth(self.frame)*7/4, self.frame.size.height/8);//C

    CGPoint pointD = CGPointMake(CGRectGetWidth(self.frame)/8, self.frame.size.height/2);//D
    CGPoint pointE = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);//E
    CGPoint pointF = CGPointMake(CGRectGetWidth(self.frame)*7/8, self.frame.size.height/2);//F
    
    CGPoint pointG = CGPointMake(CGRectGetWidth(self.frame)/8, self.frame.size.height*7/8);//G
    CGPoint pointH = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height*7/8);//H
    CGPoint pointI = CGPointMake(CGRectGetWidth(self.frame)*7/8, self.frame.size.height*7/8);//I
    
    nextPoint = [[NSMutableArray alloc] initWithObjects: [NSValue valueWithCGPoint:pointA],
                 [NSValue valueWithCGPoint:pointB],
                 [NSValue valueWithCGPoint:pointC],
                 [NSValue valueWithCGPoint:pointD],
                 [NSValue valueWithCGPoint:pointE],
                 [NSValue valueWithCGPoint:pointF],
                 [NSValue valueWithCGPoint:pointG],
                 [NSValue valueWithCGPoint:pointH],
                 [NSValue valueWithCGPoint:pointI],
                 nil];
    jumpPoint = [[NSMutableArray alloc] initWithObjects: [NSValue valueWithCGPoint:pointH],
                 [NSValue valueWithCGPoint:pointG],
                 [NSValue valueWithCGPoint:pointD],
                 [NSValue valueWithCGPoint:pointA],
                 [NSValue valueWithCGPoint:pointE],
                 [NSValue valueWithCGPoint:pointH],
                 [NSValue valueWithCGPoint:pointE],
                 [NSValue valueWithCGPoint:pointC],
                 [NSValue valueWithCGPoint:pointF],
                 [NSValue valueWithCGPoint:pointI],
                 nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) setPhoto:(UIImage *)image width:(float)fWid height:(float)fHei
{
    fItemWidth = fWid;
    if(_mainImageView)
    {
        [_mainImageView removeFromSuperview];
        _mainImageView=nil;
    }
    CGRect rec = CGRectMake(0, 0, fWid, fHei);
    _mainImageView = [[UIImageView alloc] initWithFrame:rec];
    _mainImageView.center = self.contentView.center;
    _mainImageView.image = image;
    [self.contentView addSubview:_mainImageView];
    
   [self aniCorrectStop];
    
    if(nextPoint==nil)
        [self createPoints];
//    itemView.frame = CGRectMake(0, 0, 50, 50);
//    itemView.center = self.contentView.center;
//    itemView.backgroundColor = [UIColor yellowColor];

//    UIImage * dispImg = [self imageWithImage:image scaledToSize:*newSize];
//    itemView.image = image;
    //    [self.contentView addSubview:_mainImageView];
//    UIImage * dispImg = [self imageWithImage:image scaledToSize:*newSize];
//    _mainImageView.frame = CGRectMake(0, 0, dispImg.size.width, dispImg.size.height);
//    _mainImageView.frame = CGRectMake(0, 0, 50, 50);
//    _mainImageView.center = _mainImageView.superview.center;
//    _mainImageView.backgroundColor = [UIColor yellowColor];
    
//    [self.mainImageView setCenter:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds))];

//    _mainImageView.center = CGPointMake(self.contentView.bounds.size.width/2,self.contentView.bounds.size.height/2);
//    NSLog(@" width %f, heigh %f",_mainImageView.center.x,_mainImageView.center.y);
}
-(void) setPhoto:(UIImage *)image {
    self.imageView.image = image;
//    [self.mainImageView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
}
-(void) setLabel:(NSString *)name {
    //    self.imageView.layer.backgroundColor = [UIColor orangeColor].CGColor;
    //    self.imageView.layer.cornerRadius = 20.0;
    //    self.imageView.layer.frame = CGRectInset(self.imageView.layer.frame, 20, 20);
    self.nameLabel.text = name;
}
-(void) setPlayed{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"played" ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    self.playStatView.image = image;
}
-(void) setPrice:(NSString*)priceTier{
    NSString * path = [[NSBundle mainBundle]pathForResource:priceTier ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    self.purchStatView.image = image;
}
-(void) markNew{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"new" ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    self.playStatView.image = image;
}
-(void) setTransLayerSecondView:(NSString *)systemResource{
    NSString * path = [[NSBundle mainBundle]pathForResource:systemResource ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    self.secondImageView.image = image;
}
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//- (void)customAction:(id)sender {
//    if([self.delegate respondsToSelector:@selector(customAction:forCell:)]) {
//        [self.delegate customAction:sender forCell:self];
//    }
//}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
////    NSLog(@"canPerformAction");
////    // The selector(s) should match your UIMenuItem selector
////    
////    NSLog(@"Sender: %@", sender);
//    if (action == @selector(customAction:)) {
//        return YES;
//    }
//    return NO;
//}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(customAction:))
        return YES;
    else if (action == @selector(delete:))
        return YES;
    return NO;
}
- (void)aniCorrect
{
    miZoomCount = 0;
    [self aniZoomUp:nil finished:nil context:nil];
}
- (void)aniCorrectStop
{
    miZoomCount = MI_MAX_ZOOM;
    [_correctView removeFromSuperview];
    _correctView.image=nil;
    _correctView=nil;
}
- (void)stopAni
{
    [self.mainImageView.layer removeAllAnimations];
    mbAniForceStop = YES;
}
//- (void)prepareForSwitchAni
//{
//    [self.mainImageView.layer removeAllAnimations];
//    mbAniForceStop = false;
//}
- (void)startAni:(NSInteger)runType shakeType:(NSInteger)shakeType
{
    mbAniForceStop = NO;
    if(runType==0)
        runType = (arc4random() % 4)+1;
    switch (runType) {
        case 1:
            [self moveToLeft:nil finished:nil context:nil];
            break;
        case 2:
            [self moveToTop:nil finished:nil context:nil];
            break;
        case 3:
            [self rollToLeft:nil finished:nil context:nil];
            break;
        default:
            [self rollToRight:nil finished:nil context:nil];
            break;
    }
    if(runType==1||runType==2)
    {
    switch (shakeType) {
        case 1:
            [self aniSwingZUD:self.mainImageView.layer];
            break;
        case 2:
            [self aniSwingZLR:self.mainImageView.layer];
            break;
        default:
            [self aniAirplanSwing:self.mainImageView.layer];
            break;
    }
    }
}
- (void)startIdleAni
{
//    [self randomMove:nil finished:nil context:nil];
//[self moveToLeft:nil finished:nil context:nil];
    mbAniForceStop = NO;
//    fDelayTime = 8/((arc4random() % 3)+1);
    fDelayTime = 0;
    NSUInteger randomIndex = arc4random() % 5;
    switch (randomIndex)
    {
        case 0:
        {
            [self aniSwingZUD:self.mainImageView.layer];
            [self moveToLeft:nil finished:nil context:nil];
            break;
        }
        case 1:
        {
            [self aniSwingZLR:self.mainImageView.layer];
            [self moveToTop:nil finished:nil context:nil];
            break;
        }
        case 2:
        {
//            [self aniRollAntiClock];
            [self rollToLeft:nil finished:nil context:nil];
            break;
        }
        case 3:
        {
//            [self aniRollClock];
            [self rollToRight:nil finished:nil context:nil];
            break;
        }
        case 4:
        {
            [self aniAirplanSwing:self.mainImageView.layer];
            [self moveToTop:nil finished:nil context:nil];
            break;
        }
        default:
            break;
    }
//    NSValue *val1 = [nextPoint objectAtIndex:6];
//    CGPoint oldPoint = [val1 CGPointValue];
//    NSValue *val2 = [nextPoint objectAtIndex:2];
//    CGPoint newPoint = [val2 CGPointValue];
//    [self moveCurve:oldPoint endPoint:newPoint];
    
//    [self randomMove:nil finished:nil context:nil];
//    [self randomMoveCurve:nil finished:nil context:nil];

//    jumpIdxNext = 0;
//    [self jumpMove:nil finished:nil context:nil];
}

- (void)jumpMove:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    NSValue *val = [jumpPoint objectAtIndex:jumpIdxNext];
    CGPoint newPoint = [val CGPointValue];
//    NSLog(@"%f , %f",newPoint.x,newPoint.y);
    [UIView animateWithDuration:4
                          delay:fDelayTime
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(jumpMove:finished:context:)];
                         self.mainImageView.center = newPoint;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to left done");
                     }];
    if (jumpIdxNext<9) {
        jumpIdxNext ++;
    }
    else
        jumpIdxNext = 0;
//    jumpIdxNext=jumpIdxNext<6?jumpIdxNext++:0;
}
- (void)randomMove:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
        NSUInteger randomIndex = arc4random() % [nextPoint count];
    NSValue *val = [nextPoint objectAtIndex:randomIndex];
    CGPoint newPoint = [val CGPointValue];
    [UIView animateWithDuration:0.8
                          delay:fDelayTime
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(randomMove:finished:context:)];
                         self.mainImageView.center = newPoint;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to left done");
                     }];
}
- (void)moveToLeft:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(!mbAniForceStop)
        [UIView animateWithDuration:2.0
                          delay:fDelayTime
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveToRight:finished:context:)];
//                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/8, self.frame.size.height/2);
                         self.mainImageView.center = CGPointMake(fItemWidth/2, self.frame.size.height/2);

                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to left done");
                     }];
    else
        self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);
}
- (void)moveToRight:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(!mbAniForceStop)
        [UIView animateWithDuration:2.0
                          delay:fDelayTime
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveToLeft:finished:context:)];
//                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)*7/8, self.frame.size.height/2);
                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)-(fItemWidth/2), self.frame.size.height/2);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to right done");
                     }];
    else
        self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);
    
}
- (void)moveToTop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(!mbAniForceStop)
        [UIView animateWithDuration:2.0
                          delay:fDelayTime
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveToBottom:finished:context:)];
//                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/8);
                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, fItemWidth/2);

                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to left done");
                     }];
    else
        self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);
}
- (void)moveToBottom:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(!mbAniForceStop)
        [UIView animateWithDuration:2.0
                          delay:fDelayTime
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveToTop:finished:context:)];
//                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height*7/8);
                         self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height-(fItemWidth/2));

                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to right done");
                     }];
    else
        self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);
}
- (void) aniSwingZLR:(CALayer *)layer
{
    if(!mbAniForceStop)
    {
    //SWING IN Z
    CATransform3D rotationAndPerspectiveTransformR = CATransform3DIdentity;
    rotationAndPerspectiveTransformR.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformR = CATransform3DRotate(rotationAndPerspectiveTransformR, 60.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    CATransform3D rotationAndPerspectiveTransformL = CATransform3DIdentity;
    rotationAndPerspectiveTransformL.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformL = CATransform3DRotate(rotationAndPerspectiveTransformL, -60.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    CATransform3D resetView = CATransform3DIdentity;
    resetView.m34 = 1.0 / -500;
    resetView = CATransform3DRotate(resetView, 0.0f, 0.0f, 0.0f, 0.0f);
    [UIView animateWithDuration:0.5
                          delay:fDelayTime
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         [UIView setAnimationRepeatAutoreverses:YES];
//                         [UIView setAnimationRepeatCount:10];
                         layer.transform = rotationAndPerspectiveTransformR;
                         layer.transform = rotationAndPerspectiveTransformL;
                     }
                     completion:^(BOOL finished) {
//                         layer.transform = resetView;
                           [self aniSwingZLR:layer];
                     }];
    }
}
- (void) aniSwingZUD:(CALayer *)layer
{
    if(!mbAniForceStop)
    {
    //SWING IN Z
    CATransform3D rotationAndPerspectiveTransformU = CATransform3DIdentity;
    rotationAndPerspectiveTransformU.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformU = CATransform3DRotate(rotationAndPerspectiveTransformU, 60.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    CATransform3D rotationAndPerspectiveTransformD = CATransform3DIdentity;
    rotationAndPerspectiveTransformD.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformD = CATransform3DRotate(rotationAndPerspectiveTransformD, -60.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    CATransform3D resetView = CATransform3DIdentity;
    resetView.m34 = 1.0 / -500;
    resetView = CATransform3DRotate(resetView, 0.0f, 0.0f, 0.0f, 0.0f);
    [UIView animateWithDuration:0.5
                          delay:fDelayTime
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         [UIView setAnimationRepeatAutoreverses:YES];
//                         [UIView setAnimationRepeatCount:10];
                         layer.transform = rotationAndPerspectiveTransformU;
                         layer.transform = rotationAndPerspectiveTransformD;
                     }
                     completion:^(BOOL finished) {
                         [self aniSwingZUD:layer];
                     }
     ];
    }
}
- (void) aniAirplanSwing:(CALayer *)layer
{
    if(!mbAniForceStop)
    {
        //SWING IN Z
        CATransform3D rotationAndPerspectiveTransformR = CATransform3DIdentity;
        rotationAndPerspectiveTransformR.m34 = 1.0 / -500;
        rotationAndPerspectiveTransformR = CATransform3DRotate(rotationAndPerspectiveTransformR, 30.0f * M_PI / 180.0f, 0.0f, 0.0f, 1.0f);
        CATransform3D rotationAndPerspectiveTransformL = CATransform3DIdentity;
        rotationAndPerspectiveTransformL.m34 = 1.0 / -500;
        rotationAndPerspectiveTransformL = CATransform3DRotate(rotationAndPerspectiveTransformL, -30.0f * M_PI / 180.0f, 0.0f, 0.0f, 1.0f);
        CATransform3D resetView = CATransform3DIdentity;
        resetView.m34 = 1.0 / -500;
        resetView = CATransform3DRotate(resetView, 0.0f, 0.0f, 0.0f, 0.0f);
        [UIView animateWithDuration:0.5
                              delay:fDelayTime
                            options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                         animations:^{
                             [UIView setAnimationRepeatAutoreverses:YES];
                             //                         [UIView setAnimationRepeatCount:10];
                             layer.transform = rotationAndPerspectiveTransformR;
                             layer.transform = rotationAndPerspectiveTransformL;
                         }
                         completion:^(BOOL finished) {
                             //                         layer.transform = resetView;
                             [self aniAirplanSwing:layer];
                         }];
    }
}
- (void)rollToLeft:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(!mbAniForceStop)
    {
        [self.mainImageView.layer removeAllAnimations];
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 /* full rotation*/ * 2 * 2 ];
        rotationAnimation.duration = 10;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 10;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.mainImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

        [UIView animateWithDuration:2.0
                              delay:fDelayTime
                            options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [UIView setAnimationDelegate:self];
                             [UIView setAnimationDidStopSelector:@selector(rollToRight:finished:context:)];
//                             self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/8, self.frame.size.height/2);
                             self.mainImageView.center = CGPointMake(fItemWidth/2, self.frame.size.height/2);

                         }
                         completion:^(BOOL finished){
                             NSLog(@"Move to left done");
                         }];
    }
    else
        self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);
}
- (void)rollToRight:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(!mbAniForceStop)
    {
        [self.mainImageView.layer removeAllAnimations];
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 2 * 2 ];
        rotationAnimation.duration = 5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 10;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.mainImageView.layer addAnimation:rotationAnimation forKey:@"aniRollClock"];

        [UIView animateWithDuration:2.0
                              delay:fDelayTime
                            options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [UIView setAnimationDelegate:self];
                             [UIView setAnimationDidStopSelector:@selector(rollToLeft:finished:context:)];
//                             self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)*7/8, self.frame.size.height/2);
                             self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)-(fItemWidth/2), self.frame.size.height/2);

                         }
                         completion:^(BOOL finished){
                             NSLog(@"Move to right done");
                         }];
    }
    else
        self.mainImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, self.frame.size.height/2);
    
}
-(void)aniRollAntiClock
{
    //FULL ROTATION
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 /* full rotation*/ * 2 * 2 ];
        rotationAnimation.duration = 10;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 2;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.mainImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)aniRollClock
{
    //FULL ROTATION
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 2 * 2 ];
    rotationAnimation.duration = 10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 2;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.mainImageView.layer addAnimation:rotationAnimation forKey:@"aniRollClock"];
}

-(void)aniZoomUp:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    miZoomCount ++;
    if(miZoomCount<MI_MAX_ZOOM)
        [UIView animateWithDuration:0.6
                           delay:0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             [UIView setAnimationDelegate:self];
                             [UIView setAnimationDidStopSelector:@selector(aniZoomDown:finished:context:)];
                             self.mainImageView.transform = CGAffineTransformMakeScale(2,2);
                         }
                         completion:^(BOOL finished) {
                         }
         ];
    else
    {
        if(_correctView)
        {
            [_correctView removeFromSuperview];
            _correctView.image = nil;
            _correctView = nil;
        }
        if(miZoomCount==MI_MAX_ZOOM)
        {
            NSString * path = [[NSBundle mainBundle]pathForResource:@"roundTransCorrect" ofType:@"png"];
            UIImage * image = [UIImage imageWithContentsOfFile:path];
            CGRect rec = CGRectMake(0, 0, self.contentView.frame.size.width-30, self.contentView.frame.size.height-30);
            _correctView = [[UIImageView alloc] initWithFrame:rec];
            _correctView.center = self.contentView.center;
            _correctView.image = image;
            [self.contentView addSubview:_correctView];
            [self.contentView sendSubviewToBack:_correctView];
        }
//        [self startIdleAni];
    }
}
-(void)aniZoomDown:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(aniZoomUp:finished:context:)];
                         self.mainImageView.transform = CGAffineTransformMakeScale(1,1);
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

//- (void)moveCurve:(CGPoint)startPoint endPoint:(CGPoint)endPoint
//{
//
//    // Set up fade out effect
//    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
//    fadeOutAnimation.fillMode = kCAFillModeForwards;
//    fadeOutAnimation.removedOnCompletion = NO;
//
//    // Set up scaling
//    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
//    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, self.mainImageView.frame.size.height * (40.0f / self.mainImageView.frame.size.width))]];
//    resizeAnimation.fillMode = kCAFillModeForwards;
//    resizeAnimation.removedOnCompletion = NO;
//
//    // Set up path movement
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"curveAnimation"];
//    pathAnimation.calculationMode = kCAAnimationPaced;
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.removedOnCompletion = NO;
//
//    CGMutablePathRef curvedPath = CGPathCreateMutable();
//    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
//    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, startPoint.y, endPoint.x, startPoint.y, endPoint.x, endPoint.y);
//
//    pathAnimation.path = curvedPath;
//    pathAnimation.duration = 2.0;
//
//    CGPathRelease(curvedPath);
//
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.fillMode = kCAFillModeForwards;
//    group.removedOnCompletion = NO;
//    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
//    group.duration = 0.7f;
//    group.delegate = self;
//    [group setValue:self.mainImageView forKey:@"imageViewBeingAnimated"];
//
//    [self.mainImageView.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
//}
//- (void)randomMoveCurve:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//{
//    CGPoint viewOrigin = self.mainImageView.frame.origin;
//    NSUInteger randomIndex = arc4random() % [nextPoint count];
//    NSValue *val = [nextPoint objectAtIndex:randomIndex];
//    CGPoint newPoint = [val CGPointValue];
//    [self moveCurve:viewOrigin endPoint:newPoint];
//}
@end
