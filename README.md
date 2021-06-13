# ALComponentManager

当我们的组件化工程越来越大的时候，组件越来越多，AppDelegate的代码量也会越来越多，所以我们需要一个方法去管理AppDelegate里面的组件注册等其他相关工作

## Cocoapods安装

ALComponentManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ALComponentManager'
```

## 使用方法

相关内容可以阅读[文档](https://blog.arclin.cn/post/7e5c9fa9.html)

### 使用方法

#### AppDelegate继承自ALAppDelegate

只需要在实现`UIApplicationDelegate`的方法内部调用super方法即可，如

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [super applicationWillResignActive:application];
}

```

#### AppDelegate继承自UIResponder

在AppDelegate的各个方法做分发埋点，触发到埋点后事件会分发到各个组件类里面
	
如

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
```

埋点如下

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
  {
      [[ALComponentManager sharedManager] triggerEvent:ALSetupEvent];
      [[ALComponentManager sharedManager] triggerEvent:ALInitEvent];

      dispatch_async(dispatch_get_main_queue(), ^{
          [[ALComponentManager sharedManager] triggerEvent:ALSplashEvent];
      });
  #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
      if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
          [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      }
  #endif
      return YES;
  }
```
	
其他埋点见组件Demo
	
#### 给每个组件创建组件管理类

1. 给每个组件创建一个类并写上注解，如`ALComponentA.m`

	```
	@ALMod(ALComponentA);
	@interface ALComponentA()<ALComponentProtocol>

	@end

	@implementation ALComponentA

	@end
	```
	
2. 实现协议`ALComponentProtocol`和需要的协议方法。
	这个协议里面蕴含了基本所有的`AppDelegate`方法，当然要触发这些方法都是要预先在AppDelegate写上埋点。
	
	```
	@implementation ALComponentA

	+ (void)load
	{
		NSLog(@"Component A Load");    
	}

	- (instancetype)init
	{
		if (self = [super init]) {
			NSLog(@"ComponentA Init");
		}
		return self;
	}

	- (void)modSetUp:(ALContext *)context
	{
		NSLog(@"ComponentA setup");
	}

	@end
	```
	
3. 接下来你就可以尝试使用了。

## Author

arclin325@gmail.com

## License

ALComponentManager is available under the MIT license. See the LICENSE file for more info.
