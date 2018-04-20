//
//  WeakDefine.h
//  News
//
//  Created by KM on 16/5/102016.
//  Copyright © 2016年 skyrim. All rights reserved.
//

#ifndef WeakDefine_h
#define WeakDefine_h

#ifndef weakifyObject
#if __has_feature(objc_arc)
#define weakifyObject(object) ext_keywordify __weak __typeof__(object) weak##_##object = object;
#else
#define weakifyObject(object) ext_keywordify __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongifyObject
#if __has_feature(objc_arc)
#define strongifyObject(object) ext_keywordify __strong __typeof__(object) object = weak##_##object;
#else
#define strongifyObject(object)                                                                    \
ext_keywordify __strong __typeof__(object) object = block##_##object;
#endif
#endif

#undef WEAK_SELF
#define WEAK_SELF(...) @weakifyObject(__VA_ARGS__)

#undef STRONG_SELF
#define STRONG_SELF(...) @strongifyObject(__VA_ARGS__)

#if DEBUG
#define ext_keywordify                                                                             \
autoreleasepool {                                                                              \
}
#else
#define ext_keywordify                                                                             \
try {                                                                                          \
} @catch (...) {                                                                               \
}
#endif


#endif /* WeakDefine_h */
