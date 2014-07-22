//
//  PAPieAniView.m
//  PieAni
//
//  Created by duan on 13-7-1.
//  Copyright (c) 2013年 duan. All rights reserved.
//

#import "PAPieAniView.h"

@interface PAPieAniView()
{
    NSTimer *timer;
    double currDrawData;
    double colorR;
    double colorG;
    double colorB;
    
    double initColorR;
    double initColorG;
    double initColorB;
}

@property(nonatomic,retain) NSArray *oriDataArr;
@property(nonatomic,retain) NSArray *drawDataArr;
@end

@implementation PAPieAniView
@synthesize oriDataArr=_oriDataArr;
@synthesize drawDataArr=_drawDataArr;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)showPieAni:(NSArray*)dataArr
{
    self.oriDataArr=dataArr;
    if (_oriDataArr) {
        double dataSum=0;
        for (NSInteger i=0;i<_oriDataArr.count;i++) {
            NSNumber *num=[_oriDataArr objectAtIndex:i];
            dataSum=dataSum+[num doubleValue];
        }
        
        NSMutableArray *tempArr=[NSMutableArray array];
        double drawSum=0;
        for (NSInteger i=0;i<_oriDataArr.count;i++) {
            double drawData=0;
            if (i!=_oriDataArr.count-1) {
                NSNumber *num=[_oriDataArr objectAtIndex:i];
                drawData=[num doubleValue]/dataSum;
                drawSum=drawSum+drawData;
            }
            else
            {
                drawData=1-drawSum;
            }
            //NSLog(@"%f",drawData);
            [tempArr addObject:[NSNumber numberWithDouble:drawData]];
        }
        //NSLog(@"--------------------------");
        self.drawDataArr=tempArr;
        currDrawData=0;
        srandom(time(NULL));
        initColorR=(arc4random()%10)/10.0;
        initColorG=(arc4random()%10)/10.0;
        initColorB=(arc4random()%10)/10.0;
        if (!timer) {
            timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timer_Interval) userInfo:nil repeats:YES];
            [timer retain];
        }
        
    }
}

-(void)timer_Interval
{
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //圆心
    CGPoint arcCenter=CGPointMake((int)((rect.size.width)/2), (int)((rect.size.height)/2));
    currDrawData=currDrawData+0.02;
    CGFloat radius=rect.size.width/2*currDrawData;
    if (currDrawData>1) {
        radius=rect.size.width/2;
        currDrawData=1;
        if (timer) {
            [timer invalidate];
            [timer release];
            timer=nil;
        }
    }
    colorR=initColorR;
    colorG=initColorG;
    colorB=initColorB;
    
    
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    double startData=0;
    for (NSInteger i=0;i<_drawDataArr.count;i++) {
        
        colorR=colorR+0.1;
        if (colorR>1) {
            colorR=colorR-1;
        }
        colorG=colorG+0.3;
        if (colorG>1) {
            colorG=colorG-1;
        }
        colorB=colorG+0.5;
        if (colorB>1) {
            colorB=colorB-1;
        }
        
        CGContextSetFillColor(contextRef, CGColorGetComponents( [[UIColor colorWithRed:colorR green:colorG blue:colorB alpha:1.0] CGColor]));
        
        CGContextMoveToPoint(contextRef, arcCenter.x, arcCenter.y);
        
        NSNumber *currNum=[_drawDataArr objectAtIndex:i];
        double currData=[currNum doubleValue];
        if (startData+currData<currDrawData) {
            CGContextAddArc(contextRef, arcCenter.x, arcCenter.y, radius,  (270+360*startData)*M_PI/180+M_PI/2, (270+360*(startData+currData))*M_PI/180+M_PI/2, 0);
            //NSLog(@"1 s:%f e:%f c:%f",startData,startData+currData,currDrawData);
            startData=startData+currData;
             CGContextFillPath(contextRef);
        }
        else
        {
            CGContextAddArc(contextRef, arcCenter.x, arcCenter.y, radius,  (270+360*startData)*M_PI/180+M_PI/2, (270+360*currDrawData)*M_PI/180+M_PI/2, 0);
            //NSLog(@"2 s:%f e:%f c:%f",startData,currDrawData,currDrawData);
             CGContextFillPath(contextRef);
            break;
        }
    }
    //NSLog(@"+++++++++++++++++++++++");
   
}

-(void)stopAni
{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer=nil;
    }
}


@end
