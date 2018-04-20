//
//  CoreCameraDetection.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/30.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "CoreCameraDetection.h"
#import "sys/utsname.h"
@implementation CoreCameraDetection
@synthesize timerCount = _timerCount;
@synthesize delegate = _delegate;
static CoreCameraDetection *coreCameraDetection = nil;


+ (CoreCameraDetection *)sharedCoreCameraDetection
{
    //static HappyCoinClass *happCoinClass = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        coreCameraDetection = [[self alloc] init];
    });
    return coreCameraDetection;
}

-(id)init
{
    if (self=[super init])
    {
        if ([self getAuthStatus])
        {
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
            [self initCameraSupport];
#endif
        }
    }
    return self;
}



//初始化
- (void)initCameraSupport
{
    ratioNumber = 5;
    storageArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSError *error = nil;

    captureSession = [[AVCaptureSession alloc] init];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    else
    {
        captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    captureDevice = [AVCaptureDevice  defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    
    [captureSession addInput:input];
    for(AVCaptureDeviceFormat *vFormat in [captureDevice formats] )
    {
        CMFormatDescriptionRef description= vFormat.formatDescription;
        float maxrate=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
        
        if(maxrate>59 && CMFormatDescriptionGetMediaSubType(description)==kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        {
            if ( YES == [captureDevice lockForConfiguration:NULL] )
            {
                captureDevice.activeFormat = vFormat;
                [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(10,600)];
                [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(10,600)];
                [captureDevice unlockForConfiguration];
            }
        }
    }
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
                            nil];
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("videoQueue", NULL);

    [output setSampleBufferDelegate:self queue:queue];
    [captureSession addOutput:output];
    [captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
}

#pragma mark - 开始 和 结束
//开始检测
-(void)detectionStartRunning
{
    if (![self cameraRunningStatus] && [self getAuthStatus])
    {
        if (_timerCount==0)
        {
            _timerCount = 30*ratioNumber;
        }
        smooth = 0;
        [storageArray removeAllObjects];
        sosTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(sumTimer:) userInfo:nil repeats:YES];
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOn];
        [captureDevice setFlashMode:AVCaptureFlashModeOn];
        [sosTimer fire];
        [captureSession startRunning];
    }
}

//停止检测
- (void)detectionStopRunning
{
    if ([self cameraRunningStatus])
    {
        [self closeDetectionTimer];
    }
}

#pragma mark - 定时器
- (void)sumTimer:(NSTimer *)timer
{
    stopCount ++;
    //计算每分钟多少次
    CGFloat meanSum = sumCount;
    CGFloat secondSum = meanSum/2/stopCount;
    if (secondSum<0.2) {
        secondSum += 0.08;
    }
    else if (secondSum >0.3)
    {
        secondSum -= 0.07;
    }
    NSUInteger testSum =secondSum*62*ratioNumber;

    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraDetection:didOutputSampleHeartCount:andTimerCount:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate cameraDetection: self didOutputSampleHeartCount: testSum andTimerCount:stopCount/ratioNumber];
        });
    }
}

- (void)closeDetectionTimer
{
    errorCount = 0;
    stopCount = 0;
    sumCount = 0;
    _timerCount = 0;
    [sosTimer invalidate];
    sosTimer = nil;
    [captureSession stopRunning];
    [captureDevice setTorchMode:AVCaptureTorchModeOff];
    [captureDevice setFlashMode:AVCaptureFlashModeOff];
}

#pragma mark -获取检测的状态
-(BOOL)cameraRunningStatus
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请开启相机权限：设置->隐私->康美小管家" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
        }
    }];
    [alertController addAction:sureAction];
    UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:canleAction];
    UIApplication *appDelegate = [UIApplication sharedApplication];
    [appDelegate.delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    return YES;
#elif TARGET_OS_IPHONE//真机
    if(captureSession.isRunning)
    {
        return YES;
    }
    else
    {
        return NO;
    }
#endif

}

#pragma mark - 获取摄像头权限
-(BOOL)getAuthStatus
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请开启相机权限：设置->隐私->康美小管家" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
        }
    }];
    [alertController addAction:sureAction];
    UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:canleAction];
    UIApplication *appDelegate = [UIApplication sharedApplication];
    [appDelegate.delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    return NO;
#elif TARGET_OS_IPHONE//真机
    __block BOOL isAvalible = NO;
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusNotDetermined) //第一次使用，则会弹出是否打开权限
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            isAvalible = granted;
        }];
        return isAvalible;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized)
    {
        return YES;
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请开启相机权限：设置->隐私->康美小管家" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
            }
        }];
        [alertController addAction:sureAction];
        UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:canleAction];
        UIApplication *appDelegate = [UIApplication sharedApplication];
        [appDelegate.delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        return isAvalible;
    }
#endif
    
}

#pragma mark - AVCaptureOutput AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    static int errorSum=0;
    // only run if we're not already processing an image
    // 设置Core Video图像缓存对象
    CVImageBufferRef cvimgRef = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(cvimgRef,0);
    //得到pixel buffer的基地址
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
    size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
    // 访问数据，得到pixel buffer的宽和高
    NSUInteger width=CVPixelBufferGetWidth(cvimgRef);
    NSUInteger height=CVPixelBufferGetHeight(cvimgRef);
    CVPixelBufferUnlockBaseAddress(cvimgRef,0);
    // 获取原始图像字节
    CGFloat r=0,g=0,b=0;
    for(int y=0; y<height; y++) {
        for(int x=0; x<width*4; x+=4) {
            b+=buf[x];
            g+=buf[x+1];
            r+=buf[x+2];
        }
        buf+=bprow;
    }
    r/=255*(CGFloat) (width*height);
    g/=255*(CGFloat) (width*height);
    b/=255*(CGFloat) (width*height);
    float h,s,v;
    RGBtoHSV(r, g, b, &h, &s, &v);
    // 简单的高通和低通滤波器
    static CGFloat lastH=0;

    CGFloat highPassValue=h-lastH;
    lastH=h;
    CGFloat lastHighPassValue=0;
    CGFloat lowPassValue=(lastHighPassValue+highPassValue)/2;
    lastHighPassValue=highPassValue;
//    NSLog(@"H=%0.2f\nS=%0.2f\n=v %0.2f\n",h,s,v);
//    NSLog(@"r=%0.2f\ng=%0.2f\nb=%0.2f\n",r,g,b);
//    CGFloat sum = g+b;
#ifdef iPhone5
    if (r >0.20 &&g<0.4&&b<0.4)
#else
        if (r >0.25 &&g<0.2&&b<0.3)
#endif
    {
        if (lastHighPassValue <1 && lastHighPassValue > -1)
        {
            NSNumber * number = @(lastHighPassValue);
            while(storageArray.count > 3)
            {
                [storageArray removeLastObject];
            }
            [storageArray insertObject:number atIndex:0];
            for (int i = 0; i < [storageArray count]; i++) {
                NSNumber *elem = storageArray[i];
                CGFloat elemValue = [elem floatValue];
                smooth +=elemValue;
                smooth=smooth/(i+1);
            }
            if (lastValue != 0)
            {
                if (lastValue < smooth)
                {
                    if (lastHighPassValue >smooth&&negativeCount>2)
                    {
                        negativeCount = 0;
                        positiveCount = 0;
                        sumCount ++;
                        errorSum = 0;
                    }
                    else if(lastHighPassValue>smooth)
                    {
                        negativeCount ++;
                    }
                }
                else
                {
                    if (lastHighPassValue <smooth&&positiveCount>2)
                    {
                        positiveCount = 0;
                        negativeCount = 0;
                        sumCount ++;
                        errorSum = 0;
                    }
                    else if(lastHighPassValue<smooth)
                    {
                        positiveCount++;
                    }
                }
            }
            [self sendValue:lowPassValue];
        }
        else
        {
            [self sendValue:0];
        }
    }
    else
    {
        [self sendValue:0];
        errorSum ++;
        if (errorSum >= 20) {
            errorSum = 0;
            errorCount ++;
            [self sendErrorCount:errorCount];
        }
    }
    lastValue = lastHighPassValue;
}

-(void)sendErrorCount:(NSUInteger)count
{
    if (errorCount ==2)
    {
        [self closeDetectionTimer];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraDetection:didOutputSampleErrorCount:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate cameraDetection: self didOutputSampleErrorCount:count];
        });
    }
}

-(void)sendValue:(float)value
{
#ifdef DEBUG
//    NSLog(@"%f",value);
#endif
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraDetection:didOutputSamplePassValue:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate cameraDetection: self didOutputSamplePassValue: value];
        });
    }
}

#pragma mark -RGB转换HSV
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        // r = g = b = 0
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h=2+(b-r)/delta;
    else
        *h=4+(r-g)/delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

void NewRGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, deltaValue;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    deltaValue = (max-min);
    if (r == max) *h = (g-b)/deltaValue;
    if (g == max) *h = 2 + (b-r)/deltaValue;
    if (b == max) *h = 4 + (r-g)/deltaValue;
                
    *h = *h * 60;
    if (*h < 0)
    {
        *h = *h + 360;
    }
                    
    *v=MAX( r, MAX(g, b ));
    *s=deltaValue/max;
}

#pragma mark - 初始化属性
-(AVCaptureSession *)captureSesion
{
    if(captureSession == nil)
    {
        captureSession = [[AVCaptureSession alloc] init];
    }
    return captureSession;
}

-(AVCaptureDevice *)captureDevice
{
    if(captureDevice == nil)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return captureDevice;
}

-(NSString *)getDevicePlatForm
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}
@end
