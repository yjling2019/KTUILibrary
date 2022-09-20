//
//  KTSandBoxManager.h
//  KTFoundation
//
//  Created by KOTU on 2019/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTSandBoxManager : NSObject

/// 沙盒temp文件夹路径
+ (NSString *)tempPath;

/// 沙盒cache文件夹路径
+ (NSString *)cachePath;

/// 沙盒document路径
+ (NSString *)documentPath;

/**
 获取文件的后缀名
 
 @param filePath 文件的沙盒路径
 @return 文件的后缀名
 */
+ (NSString *)getPathExtensionWith:(__kindof NSString *)filePath;

/**
 获取文件的名字 包含后缀名

 @param filePath 文件的沙盒路径
 @return 文件的名字，包含后缀名
 */
+ (NSString *)getFileNameWithFilePath:(__kindof NSString *)filePath;

/**
 获取文件的名字 不含后缀名

 @param filePath 文件的沙盒路径
 @return 文件的名字 不含后缀名
 */
+ (NSString *)getFileNameWithNoExtWithFilePath:(__kindof NSString *)filePath;

/**
 获取文件所在文件夹的沙盒路径

 @param filePath 文件的沙盒路径
 @return 文件夹的沙盒路径
 */
+ (NSString *)getDirectoryWithFilePath:(__kindof NSString *)filePath;

/**
 获取某一路径下的文件列表，不包含文件夹
 
 @param filePath 文件的路径
 @return 文件列表
 */
+ (NSArray *)filesWithoutFolderAtPath:(__kindof NSString *)filePath;

/**
 获取某一路径下的符合一定要求后缀名的文件列表，不包含文件夹，
 
 @param filePath 文件的路径
 @param exts 符合要求的后缀名列表
 @return 文件名列表
 */
+ (NSArray *)filesWithoutFolderAtPath:(__kindof NSString *)filePath
                           extensions:(__kindof NSArray <NSString *>*)exts;

/**
 获取某一路径下的文件列表，包含文件夹
 
 @param filePath 文件的路径
 @return 文件列表
 */
+ (NSArray *)filesWithFolderAtPath:(__kindof NSString *)filePath;

/**
 获取某一路径下的文件夹列表

 @param filePath 文件的沙盒路径
 @return 文件夹列表
 */
+ (NSArray *)foldersAtPath:(__kindof NSString *)filePath;

/**
 判断某个路径下的文件是否存在
 
 @param filePath 文件的沙盒路径
 @return 文件是否存在的状态 YES or NO
 */
+ (BOOL)isExistsFile:(__kindof NSString *)filePath;

/**
 判断某个路径是否是文件夹

 @param filePath 文件的沙盒路径
 @return 是否是文件夹
 */
+ (BOOL)isDirectory:(__kindof NSString *)filePath;

/**
 在沙盒documents文件夹中创建文件的路径
 
 @param fileName 文件的名字
 @param data 要写入的二进制数据
 @return 文件的沙盒路径
 */
+ (NSString *)createDocumentsFilePathWithFileName:(__kindof NSString * _Nullable)fileName
                                             data:(__kindof NSData *)data;

/**
 在沙盒documents文件夹中指定的文件夹下创建文件的路径
 
 @param nameSpace 指定的文件夹名字
 @param fileName 文件的名字
 @param data 要写入的二进制数据
 @return 文件的沙盒路径
 */
+ (NSString *)createDocumentsFilePathWithNameSpace:(__kindof NSString * _Nullable)nameSpace
                                          fileName:(__kindof NSString *)fileName
                                              data:(__kindof NSData *)data;

/**
 在cache文件夹下创建文件的路径
 
 @param fileName 文件的名字
 @param data 要写入的二进制数据
 @return 文件的沙盒路径
 */
+ (NSString *)createCacheFilePathWithFileName:(__kindof NSString *)fileName
                                         data:(__kindof NSData *)data;

/**
 在cache文件夹下指定的文件夹下创建文件的路径
 
 @param nameSpace 指定的文件夹名字
 @param fileName 文件的名字
 @param data 要写入的二进制数据
 @return 文件的沙盒路径
 */
+ (NSString *)createCacheFilePathWithNameSpace:( __kindof NSString * _Nullable )nameSpace
                                      fileName:(__kindof NSString *)fileName
                                          data:(__kindof NSData *)data;

/**
 在指定的文件夹路径下创建文件

 @param folerPath 文件夹路径
 @param fileName 文件的名字
 @param data 二进制数据
 @return 创建成功的文件沙盒路径
 */
+ (NSString *)createFileAtFolderPath:(__kindof NSString *)folerPath
                            fileName:(__kindof NSString *)fileName
                                data:(__kindof NSData *)data;

/**
 在cache文件夹下创建文件夹
 
 @param folderName 文件夹的名字
 @return 创建的文件夹沙盒路径
 */
+ (NSString *)createCacheFilePathWithFolderName:(__kindof NSString *)folderName;
/**
 在documents文件下创建文件夹
 
 @param folderName 文件夹名字
 @return 创建的文件夹沙盒路径
 */
+ (NSString *)createDocumentsFilePathWithFolderName:(__kindof NSString *)folderName;
/**
 根据沙盒路径创建文件夹路径
 
 @param folderPath 文件夹路径
 @return 文件夹的路径
 */
+ (NSString *)createDirectoryWithPath:(__kindof NSString *)folderPath;
/**
 删除指定路径的文件或指定指定文件夹下的所有文件
 
 @param filePath 文件的路径或文件夹的路径
 */
+ (BOOL)deleteFile:(__kindof NSString *)filePath;

/**
 将某个文件或者文件夹移动到指定的路径下
 
 @param originFilePath 某个文件或文件夹的路径
 @param targetFilePath 指定的路径
 */
+ (BOOL)moveFileFrom:(__kindof NSString *)originFilePath
                  to:(__kindof NSString *)targetFilePath;

/**
 将某个文件或者文件夹复制到指定的路径下
 
 @param originFilePath 某个文件或文件夹的路径
 @param targetFilePath 指定的路径
 */
+ (BOOL)copyFileFrom:(__kindof NSString *)originFilePath
                  to:(__kindof NSString *)targetFilePath;

/**
 根据文件的名字拼接文件在沙盒documents的路径，实际不创建文件
 
 @param fileName 文件的名字
 @return 文件的沙盒路径
 */
+ (NSString *)appendDocumentsFilePathWithFileName:(__kindof NSString *)fileName;

/**
 根据文件的名字拼接文件在沙盒documents的路径，实际不创建文件
 
 @param folderName 子文件夹名字
 @param fileName 文件的名字
 @return 沙盒的路径
 */
+ (NSString *)appendDocumentsFilePathWithFolderName:(__kindof NSString *_Nullable)folderName
                                           fileName:(__kindof NSString *)fileName;

/**
 根据文件的名字拼接文件在沙盒Cache的路径，实际不创建文件
 
 @param fileName 文件的名字
 @return 文件的沙盒路径
 */
+ (NSString *)appendCacheFilePathWithFileName:(__kindof NSString *)fileName;

/**
 根据文件的名字拼接文件在沙盒Cache的路径，实际不创建文件
 
 @param folderName 子文件夹名字
 @param fileName 文件的名字
 @return 沙盒的路径
 */
+ (NSString *)appendCacheFilePathWithFolderName:(__kindof NSString *_Nullable)folderName
                                       fileName:(__kindof NSString *)fileName;

/**
 根据文件的名字拼接文件在沙盒Temporary的路径，实际不创建文件
 
 @param fileName 文件的名字
 @return 文件的沙盒路径
 */
+ (NSString *)appendTemporaryFilePathWithFileName:(__kindof NSString *)fileName;

/**
 获取某个Bundle下的文件的路径
 
 @param fileName 文件的名字，可以带后缀名
 @param podName pod组件的名字 podName为nil的话，默认为MainBundle
 @param ext 文件的后缀名
 @return 文件的路径
 */
+ (NSString *)pathWithFileName:(__kindof NSString *)fileName
                       podName:(__kindof NSString *)podName
                        ofType:(__kindof NSString *)ext;

/**
 获取某个podName对象的bundle对象
 
 @param podName pod的名字 podName为nil的话，默认为MainBundle
 @return 对应的bundle对象
 */
+ (NSBundle *)bundleWithPodName:(__kindof NSString *)podName;

/**
 根据bundle名字获取bundle对象，只能获取mainBundle下的bundle

 @param bundleName bundleName
 @return bundle instance
 */
+ (NSBundle *)bundleWithBundleName:(__kindof NSString *)bundleName;

/**
 根据fileName、bundleName、podName、获取文件的组件化路径

 @param bundleName bundleName
 @param fileName fileName
 @param podName podName
 @return filePath
 */
+ (NSString *)filePathWithBundleName:(__kindof NSString *)bundleName
                            fileName:(__kindof NSString *)fileName
                             podName:(__kindof NSString *)podName;

/**
 根据fileName、bundleName、podName、获取文件的组件化路径URL
 
 @param bundleName bundleName
 @param fileName fileName
 @param podName podName
 @return filePath
 */
+ (NSURL *)fileURLWithBundleName:(__kindof NSString *)bundleName
                        fileName:(__kindof NSString *)fileName
                         podName:(__kindof NSString *)podName;

/**
 获取某个podName下的nib文件并创建对象
 
 @param nibName xib文件的名字
 @param podName pod库名 podName为nil的话，默认为MainBundle
 @return 创建好的对象
 */
+ (id)loadNibName:(__kindof NSString *)nibName
          podName:(__kindof NSString *)podName;

/**
 获取某个pod下的UIStoryboard文件的对象
 
 @param name UIStoryboard 的名字
 @param podName pod库名  podName为nil的话，默认为MainBundle
 @return UIStoryboard 对象
 */
+ (UIStoryboard *)storyboardWithName:(__kindof NSString *)name
                             podName:(__kindof NSString *)podName;

/**
 在模块内查找UIImage的方法
 
 @param imageName 图片的名字，如果是非png格式的话，要带上后缀名
 @param podName pod库名 podName为nil的话，默认为MainBundle
 @return UIImage对象
 */
+ (UIImage *)imageWithName:(__kindof NSString *)imageName
                   podName:(__kindof NSString *)podName DEPRECATED_MSG_ATTRIBUTE("use imageNamed:inPod: instead");

/**
 在模块内查找UIImage的方法
 
 @param imageName 图片的名字，如果是非png格式的话，要带上后缀名
 @param podName pod库名 podName为nil的话，默认为MainBundle
 @return UIImage对象
 */
+ (UIImage *)imageNamed:(__kindof NSString *)imageName
				  inPod:(__kindof NSString *)podName;

@end

NS_ASSUME_NONNULL_END
