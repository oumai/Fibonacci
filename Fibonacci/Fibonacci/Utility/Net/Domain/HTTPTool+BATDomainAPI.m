//
//  HTTPTool+BATDomainAPI.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATDomainAPI.h"
#import "BATDomainModel.h"

@implementation HTTPTool (BATDomainAPI)

+ (void)getDomain {

#ifdef DEBUG
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.65:730" forKey:@"appdominUrl"];//张玮
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.198:9999" forKey:@"appdominUrl"];//金迪
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.83:9998" forKey:@"appdominUrl"];//催扬
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.83:9999" forKey:@"appdominNotApiUrl"];//催扬
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.90:8888" forKey:@"appdominUrl"];//李何苗

    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.bulter.test.jkbat.cn" forKey:@"appdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://test.jkbat.com" forKey:@"appdominNotApiUrl"];
#elif PREVIEW

//    //预发布
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.bulter.preview.jkbat.cn" forKey:@"appdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://preview.jkbat.com" forKey:@"appdominNotApiUrl"];
#elif AZURE
    //Azure测试环境
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc016tn-web.chinacloudsites.cn" forKey:@"appdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn" forKey:@"appdominNotApiUrl"];

#elif AZUREPREVIEW
    //Azure测试环境
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.bulter.apreview.jkbat.cn" forKey:@"appdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apreview.jkbat.com" forKey:@"appdominNotApiUrl"];
    
#elif RELEASE
//#warning 打包记得修改Scheme
    //正式（APPSTORE）
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.bulter.jkbat.cn" forKey:@"appdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"appdominNotApiUrl"];
#endif
    [[NSUserDefaults standardUserDefaults] synchronize];

//#ifdef RELEASE
//    //正式环境
////    [HTTPTool domainRequest];
//#endif
}

+ (void)domainRequest {
    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
    NSString * URL = @"http://www.jkbat.com/api/GetAppDominUrl";
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        DDLogVerbose(@"\nGET返回值---\n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id dic = [HTTPTool responseConfiguration:responseObject];

        BATDomainModel * urlModel = [BATDomainModel mj_objectWithKeyValues:dic];
        if (urlModel.ResultCode == 0) {
            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.appdominUrl forKey:@"appdominUrl"];
            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.storedominUrl forKey:@"storedominUrl"];
            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.hotquestionUrl forKey:@"hotquestionUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
