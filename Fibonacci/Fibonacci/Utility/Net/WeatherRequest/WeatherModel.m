//
//  WeatherModel.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/11/28.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeartherBasic
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.cnty forKey:@"cnty"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.city = [decoder decodeObjectForKey:@"city"];
        self.cnty = [decoder decodeObjectForKey:@"cnty"];
    }
    return  self;
}
@end

@implementation WeartherNow
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tmp forKey:@"tmp"];
    [encoder encodeObject:self.cond forKey:@"cond"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.tmp = [decoder decodeObjectForKey:@"tmp"];
        self.cond = [decoder decodeObjectForKey:@"cond"];
    }
    return  self;
}
@end

@implementation WeartherCond
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.txt forKey:@"txt"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.code = [decoder decodeObjectForKey:@"code"];
        self.txt = [decoder decodeObjectForKey:@"txt"];
    }
    return  self;
}
@end


@implementation WeartherAstro
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mr forKey:@"mr"];
    [encoder encodeObject:self.ms forKey:@"ms"];
    [encoder encodeObject:self.sr forKey:@"sr"];
    [encoder encodeObject:self.ss forKey:@"ss"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.mr = [decoder decodeObjectForKey:@"mr"];
        self.ms = [decoder decodeObjectForKey:@"ms"];
        self.sr = [decoder decodeObjectForKey:@"sr"];
        self.ss = [decoder decodeObjectForKey:@"ss"];
    }
    return  self;
}
@end

@implementation WeartherDaily
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.astro forKey:@"astro"];
    [encoder encodeObject:self.cond forKey:@"cond"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.astro = [decoder decodeObjectForKey:@"astro"];
        self.cond = [decoder decodeObjectForKey:@"cond"];

    }
    return  self;
}
@end

@implementation WeartherHe
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.basic forKey:@"basic"];
    [encoder encodeObject:self.now forKey:@"now"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.daily_forecast forKey:@"daily_forecast"];    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.basic = [decoder decodeObjectForKey:@"basic"];
        self.now = [decoder decodeObjectForKey:@"now"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.daily_forecast = [decoder decodeObjectForKey:@"daily_forecast"];
    }
    return  self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"daily_forecast": [WeartherDaily class]};
}
@end
    
@implementation WeatherModel
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.HeWeather5 forKey:@"HeWeather5"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.HeWeather5 = [decoder decodeObjectForKey:@"HeWeather5"];

    }
    return  self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"HeWeather5": [WeartherHe class]};
}
@end
