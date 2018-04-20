//
//  BATEnumMacro.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATEnumMacro_h
#define BATEnumMacro_h

#pragma mark - 推荐好友
/**
 *  推荐类型
 */
typedef NS_ENUM(NSInteger, BATRecommendType) {
    /**
     *  好友
     */
    BATRecommendFriends = 1,
    /**
     *  医生
     */
    BATRecommendDoctors = 2,
};

#pragma mark - 搜索
/**
 *  搜索类型
 */
typedef NS_ENUM(NSInteger, kSearchType) {
    /**
     *  全部
     */
    kSearchAll = 0,
    /**
     *  病症
     */
    kSearchCondition,
    /**
     *  药品
     */
    kSearchTreatment,
    /**
     *  医院
     */
    kSearchHospital,
    /**
     *  医生
     */
    kSearchDoctor,
    /**
     *  资讯
     */
    kSearchInformation,
};

#pragma mark 健康圈-群组详情
/**
 *  群组详情获取动态操作enum
 */
typedef NS_ENUM(NSInteger, BATGroupDetailDynamicOpration) {
    /**
     *  全部
     */
    BATGroupDetailDynamicOprationAll = -1,
    /**
     *  动态
     */
    BATGroupDetailDynamicOprationDynamic = 0,
    /**
     *  问题
     */
    BATGroupDetailDynamicOprationQuestion = 1,
};


#pragma mark - 咨询－咨询类型
/**
 *  咨询类型
 */
typedef NS_ENUM(NSInteger, ConsultType) {
    /**
     *  免费
     */
    kConsultTypeFree              = 0,
    /**
     *  图文
     */
    kConsultTypeTextAndImage      = 1,

    /**
     *  视频
     */
    kConsultTypeVideo             = 2,
    
    /**
     *  语音
     */
    kConsultTypeAudio             = 3,
};

/**
 *  资讯类型
 */
typedef NS_ENUM(NSInteger, HomeNewsType) {

    /**
     *  推荐
     */
    kHomeNewsRecommend         = 10,
    /**
     *  热门
     */
    kHomeNewsHot               = 11,

};

#endif /* BATEnumMacro_h */
