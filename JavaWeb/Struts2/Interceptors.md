---
typora-copy-images-to: ..\..\..\graphs\photos
typora-root-url: ..\..\..\graphs\photos
---

## Interceptors



The **default Interceptor stack** is designed to serve the needs of most applications. **Most applications will not need to add Interceptors or change the Interceptor stack**.When you request a resource that maps to an "action", the framework invokes the Action object. But, before the Action is executed, the invocation can be intercepted by another object. After the Action executes, the invocation could be intercepted again. Unsurprisingly, we call these objects "Interceptors."

Most of the framework's core functionality is implemented as Interceptors. Features like double-submit guards, type conversion, object population, validation, file upload, page preparation, and more, are all implemented with the help of Interceptors. Each and every Interceptor is pluggable, so you can decide exactly which features an Action needs to support.

Interceptors can be configured on a per-action basis. Your own custom Interceptors can be mixed-and-matched with the Interceptors bundled with the framework. Interceptors "set the stage" for the Action classes, doing much of the "heavy lifting" before the Action executes.

![QQ截图20170510101634](/QQ截图20170510101634.png)

