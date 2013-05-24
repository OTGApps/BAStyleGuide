//
//  CircularUIImageView.h
//
//  Created by Mark Rickert on 05/23/2013.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CircularUIImageView : UIImageView
{
    BOOL touchesMoved;

    CGPoint lastPoint;
    NSTimeInterval lastTouchTimeStamp;

    double currentAngle;
    double angularSpeed;
    CATransform3D currentTransform;
    NSInteger turnDirection;
}
@property (nonatomic) float decelerationTime;
@property (nonatomic) bool continueSpinning;

// Math Functions
-(double)distanceBetweenPointOne:(CGPoint)point1 andpointTwo:(CGPoint) point2;
-(double)angleBetweenThreePoints:(CGPoint)x :(CGPoint)y :(CGPoint)z;
-(double)crossProduct:(CGPoint)p1 :(CGPoint)p2 :(CGPoint)p3;
-(void)spin:(double)delta;

// Spinning Animation
- (void)runSpinAnimation;

@end
