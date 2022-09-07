//
//  KTSandBoxManager.m
//  vv_rootlib_ios
//
//  Created by KOTU on 2019/10/18.
//

#import "KTSandBoxManager.h"

@implementation KTSandBoxManager

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)getPathExtensionWith:(__kindof NSString *)filePath
{
    NSString *ext = [filePath pathExtension];
    return ext;
}

+ (NSString *)getFileNameWithFilePath:(__kindof NSString *)filePath
{
    NSString *fileName = [filePath lastPathComponent];
    return fileName;
}

+ (NSString *)getFileNameWithNoExtWithFilePath:(__kindof NSString *)filePath
{
    NSString *fileName = [filePath stringByDeletingPathExtension];
    return fileName;
}

+ (NSString *)getDirectoryWithFilePath:(__kindof NSString *)filePath
{
    NSString *directory = [filePath stringByDeletingLastPathComponent];
    return directory;
}

+ (NSArray *)filesWithoutFolderAtPath:(__kindof NSString *)filePath
{
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
    //新建数组，存放各个文件路径
    NSMutableArray *files = [NSMutableArray new];
    //遍历目录迭代器，获取各个文件路径
    NSString *fileName=nil;
    while (fileName = [dirEnum nextObject]) {
        NSString *tempFilePath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
        BOOL isDirectory = [self isDirectory:tempFilePath];
        if (!isDirectory && ![fileName containsString:@"/"]) {
            [files addObject:fileName];
        }
    }
    return [files copy];
}

+ (NSArray *)filesWithoutFolderAtPath:(__kindof NSString *)filePath
                           extensions:(__kindof NSArray <NSString *>*)exts
{
    NSArray *array = [self filesWithoutFolderAtPath:filePath];
    NSMutableArray *files = [NSMutableArray new];
    for (NSString *fileName in array) {
        NSString *ext = [self getPathExtensionWith:filePath];
        if ([exts containsObject:ext]) {
            [files addObject:fileName];
        }
    }
    return [files copy];
}

+ (NSArray *)filesWithFolderAtPath:(__kindof NSString *)filePath
{
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
    //新建数组，存放各个文件路径
    NSMutableArray *files = [NSMutableArray new];
    //遍历目录迭代器，获取各个文件路径
    NSString *fileName=nil;
    while (fileName = [dirEnum nextObject]) {
        if (![fileName isEqualToString:@".DS_Store"]) {//存在后缀名的文件
            [files addObject:fileName];
        }
        
    }
    return [files copy];
}

+ (NSArray *)foldersAtPath:(__kindof NSString *)filePath
{
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
    //新建数组，存放各个文件路径
    NSMutableArray *files = [NSMutableArray new];
    //遍历目录迭代器，获取各个文件路径
    NSString *fileName=nil;
    while (fileName = [dirEnum nextObject]) {
        NSString *tempFilePath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
        BOOL isDirectory = [self isDirectory:tempFilePath];
        if (isDirectory) {
            [files addObject:fileName];
        }
    }
    return [files copy];
}

+ (BOOL)isExistsFile:(__kindof NSString *)filepath
{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
    
}

+ (BOOL)isDirectory:(__kindof NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}


+ (NSString *)createDocumentsFilePathWithFileName:(NSString *)fileName
                                             data:(NSData *)data
{
    
    return [self createDocumentsFilePathWithNameSpace:nil
                                             fileName:fileName
                                                 data:data];
}

+ (NSString *)createDocumentsFilePathWithNameSpace:(__kindof  NSString * _Nullable)nameSpace
                                          fileName:(NSString *)fileName
                                              data:(NSData *)data
{
    
    if (!data) {
        return nil;
    }
    
    NSString *fileDir =[self createDocumentsFilePathWithFolderName:nameSpace];
    NSString *filePath =[fileDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}


+ (NSString *)createCacheFilePathWithFileName:(__kindof NSString *)fileName
                                         data:(__kindof NSData *)data
{
    
    return [self createCacheFilePathWithNameSpace:nil fileName:fileName data:data];
}

+ (NSString *)createCacheFilePathWithNameSpace:(__kindof NSString *)nameSpace
                                      fileName:(__kindof NSString *)fileName
                                          data:(__kindof NSData *)data
{
    if (!data) {
        return nil;
    }
    
    NSString *fileDir =[self createCacheFilePathWithFolderName:nameSpace];
    NSString *filePath =[fileDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}

+ (NSString *)createFileAtFolderPath:(__kindof NSString *)folerPath
                            fileName:(__kindof NSString *)fileName
                                data:(__kindof NSData *)data
{
    if (!data) {
        return nil;
    }
    
    if(![KTSandBoxManager isDirectory:folerPath]){
        [KTSandBoxManager createDirectoryWithPath:folerPath];
    }
    NSString *filePath =[NSString stringWithFormat:@"%@/%@",folerPath,fileName];
    if([data writeToFile:filePath atomically:YES]){
        return filePath;
    }
    return nil;
}

+ (NSString *)createCacheFilePathWithFolderName:(__kindof NSString *)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    NSString *folderPath=folderName?[cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",folderName]]:cacheDir;
    if ([self isExistsFile:folderPath]) {
        return folderPath;
    }
    [[NSFileManager defaultManager]   createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return folderPath;
    
}

+ (NSString *)createDocumentsFilePathWithFolderName:(__kindof NSString *)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *folderPath =folderName?[documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@",folderName]]:documentsDir;
    if ([self isExistsFile:folderPath]) {
        return folderPath;
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    return folderPath;
}

+ (NSString *)createDirectoryWithPath:(__kindof NSString *)filePath
{
    if ([self isExistsFile:filePath]) {
        return filePath;
    }
    
    [[NSFileManager defaultManager]  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return filePath;
}

+ (BOOL)deleteFile:(__kindof NSString *)filePath
{
    NSError *error =nil;
    if (!filePath) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

+ (BOOL)moveFileFrom:(__kindof NSString *)originFilePath
                  to:(__kindof NSString *)targetFilePath
{
    NSError *error = nil;
    if (!(originFilePath&&targetFilePath)) {
        return NO;
    }
    
    if ([self isExistsFile:targetFilePath]) {
        [self deleteFile:targetFilePath];
    }
    
    return [[NSFileManager defaultManager] moveItemAtPath:originFilePath toPath:targetFilePath error:&error];
}


+ (BOOL)copyFileFrom:(__kindof NSString *)originFilePath
                  to:(__kindof NSString *)targetFilePath
{
    NSError *error = nil;
    if (!(originFilePath&&targetFilePath)) {
        return NO;
    }
    
    if ([self isExistsFile:targetFilePath]) {
        [self deleteFile:targetFilePath];
    }
    return [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
}

+ (NSString *)appendDocumentsFilePathWithFileName:(__kindof NSString *)fileName
{
    return [self appendDocumentsFilePathWithFolderName:nil
                                              fileName:fileName];
}

+ (NSString *)appendDocumentsFilePathWithFolderName:(__kindof NSString * _Nullable)folderName fileName:(__kindof NSString *)fileName
{
    if (!folderName || [folderName isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@/%@",[self documentPath],fileName];
    }
    
    return [NSString stringWithFormat:@"%@/%@",[self createDocumentsFilePathWithFolderName:folderName],fileName];
}

+ (NSString *)appendCacheFilePathWithFileName:(__kindof NSString *)fileName
{
    return [self appendCacheFilePathWithFolderName:nil
                                          fileName:fileName];
}

+ (NSString *)appendCacheFilePathWithFolderName:(__kindof NSString *_Nullable)folderName
                                       fileName:(__kindof NSString *)fileName
{
    if (!folderName || [folderName isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@/%@",[self cachePath],fileName];
    }
    return [NSString stringWithFormat:@"%@/%@",[self createCacheFilePathWithFolderName:folderName],fileName];
}

+ (NSString *)appendTemporaryFilePathWithFileName:(__kindof NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@",[self tempPath],fileName];
}

+ (NSString *)pathWithFileName:(__kindof NSString *)fileName
                       podName:(__kindof NSString *)podName
                        ofType:(__kindof NSString *)ext
{
    if (!fileName ) {
        return nil;
    }
    NSBundle * pod_bundle =[self bundleWithPodName:podName];
    if (!pod_bundle) {
        return nil;
    }
    if (!pod_bundle.loaded) {
        [pod_bundle load];
    }
    NSString *filePath =[pod_bundle pathForResource:fileName ofType:ext];
    return filePath;
}

+ (NSBundle *)bundleWithPodName:(__kindof NSString *)podName
{
    if (!podName) {
        return [NSBundle mainBundle];
    }
    NSBundle * bundle = [NSBundle bundleForClass:NSClassFromString(podName)];
    NSURL * url = [bundle URLForResource:podName withExtension:@"bundle"];
    if (!url) {
        NSArray *frameWorks = [NSBundle allFrameworks];
        for (NSBundle *tempBundle in frameWorks) {
            url = [tempBundle URLForResource:podName withExtension:@"bundle"];
            if (url) {
                bundle =[NSBundle bundleWithURL:url];
                if (!bundle.loaded) {
                    [bundle load];
                }
                return bundle;
            }
        }
    }else{
        bundle =[NSBundle bundleWithURL:url];
        return bundle;
    }
    return nil;
}

+ (NSBundle *)bundleWithBundleName:(__kindof NSString *)bundleName
{
    if (!bundleName) {
        return [NSBundle mainBundle];
    }
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    bundlePath = [NSString stringWithFormat:@"%@/%@.bundle",bundlePath,bundleName];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"file://%@",bundlePath] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                                                           
    NSBundle *bundle =[NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSString *)filePathWithBundleName:(__kindof NSString *)bundleName
                            fileName:(__kindof NSString *)fileName
                             podName:(__kindof NSString *)podName
{
    if (!podName) {
        NSBundle *bundle = [self bundleWithBundleName:bundleName];
        NSString *filePath = [bundle pathForResource:fileName ofType:nil];
        return filePath;
    }
    
    NSBundle *pod_bundle = [self bundleWithPodName:podName];
    if (!bundleName) {
        NSString *filePath = [pod_bundle pathForResource:fileName ofType:nil];
        return filePath;
    }
    
    NSString *bundlePath = pod_bundle.bundlePath;
    bundlePath = [NSString stringWithFormat:@"%@/%@.bundle",bundlePath,podName];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"file://%@/%@.bundle",bundlePath,bundleName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSBundle *bundle =[NSBundle bundleWithURL:url];
    if (bundle) {
        NSString *filePath = [bundle pathForResource:fileName ofType:nil];
        return filePath;
    }
    return nil;
}

+ (NSURL *)fileURLWithBundleName:(__kindof NSString *)bundleName
                        fileName:(__kindof NSString *)fileName
                         podName:(__kindof NSString *)podName
{
    NSString *filePath = [self filePathWithBundleName:bundleName fileName:fileName podName:podName];
    NSString *fileURLStr = [NSString stringWithFormat:@"file://%@",filePath];
    NSURL *fileURL = [NSURL URLWithString:fileURLStr];
    if (!fileURL) {
       fileURLStr = [fileURLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        fileURL = [NSURL URLWithString:fileURLStr];
    }
    return fileURL;
}

+ (id)loadNibName:(__kindof NSString *)nibName
          podName:(__kindof NSString *)podName
{
    NSBundle *bundle =[self bundleWithPodName:podName];
    if (!bundle) {
        return nil;
    }
    id object = [[bundle loadNibNamed:nibName owner:nil options:nil] lastObject];
    return object;
}

+ (UIStoryboard *)storyboardWithName:(__kindof NSString *)name
                             podName:(__kindof NSString *)podName
{
    NSBundle *bundle =[self bundleWithPodName:podName];
    if (!bundle) {
        return nil;
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:bundle];
    return storyBoard;
}

+ (UIImage *)imageWithName:(__kindof NSString *)imageName
                   podName:(__kindof NSString *)podName
{
    NSBundle * pod_bundle =[self bundleWithPodName:podName];
    if (!pod_bundle) {
        return nil;
    }
    if (!pod_bundle.loaded) {
        [pod_bundle load];
    }
    UIImage *image = [UIImage imageNamed:imageName inBundle:pod_bundle compatibleWithTraitCollection:nil];
    return image;
}
@end
