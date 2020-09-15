//
//  FPSLabel.m
//  FPSDisplay
//
//  Created by LZhenHong on 2020/9/15.
//

#import "FPSLabel.h"

@interface FPSLabel ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) CFTimeInterval lastTimestamp;
@end

@implementation FPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, 75, 30);
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self _doCommonInit];
    }
    return self;
}

// 这里之前用了 _commonInit，结果发现 UI 总是不对，结果发现 UILabel 也有个 _commonInit 方法。
// 所以之前这里把 UILabel 的方法给覆盖了，导致 UI 不对。😂
- (void)_doCommonInit {
    self.count = 0;
    self.lastTimestamp = 0;
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont boldSystemFontOfSize:20];
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    [self _registerNotificationObserver];
}

- (void)_registerNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:NULL];
}

- (void)appBecomeActive {
    [self.displayLink setPaused:NO];
}

- (void)appResignActive {
    [self.displayLink setPaused:YES];
}

- (void)didMoveToSuperview {
    [self.displayLink setPaused:NO];
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setPaused:YES];
    }
    return _displayLink;
}

- (void)tick:(CADisplayLink *)link {
    if (self.lastTimestamp <= 0) {
        self.lastTimestamp = link.timestamp;
        return;
    }
    
    ++self.count;
    CFTimeInterval delta = link.timestamp - self.lastTimestamp;
    if (delta < 1) {
        return;
    }
    

    float fps = self.count / delta;
    [self setText:[NSString stringWithFormat:@"%d FPS", (int)round(fps)]];
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    [self setTextColor:color];

    self.count = 0;
    self.lastTimestamp = link.timestamp;
}

- (void)dealloc {
    [self.displayLink invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
