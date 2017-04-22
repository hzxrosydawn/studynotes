---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ./
---

## Classpath详解

使用命令行新建一个简单的Maven项目。

Windows 下按下 `Win+R` 快捷键打开命令行，输入`mvn archetype:generate` ，然后按下 `Enter` 键，再次按下 `Enter` 键来使用默认的名为 `maven-archetype-quickstart` 的 `archetype` ，然后按照提示依次输入 `groupId`  名称  → `Enter` →  输入 `artifactId` 名称 → `Enter` → 输入  `version` 名称（可直接敲 `Enter` 使用默认名称） → `Enter` →  再输入包名  →  `Enter` ，最后 `Enter` 确定所输入的信息。

```shell
C:\Users\UserName>mvn archetype:generate
[INFO] Scanning for projects...
...
[INFO] Generating project in Interactive mode
[WARNING] No archetype found in remote catalog. Defaulting to internal catalog
[INFO] No archetype defined. Using maven-archetype-quickstart (org.apache.maven.archetypes:maven-archetype-quickstart:1.0)
Choose archetype:
1: internal -> org.apache.maven.archetypes:maven-archetype-archetype (An archetype which contains a sample archetype.)
2: internal -> org.apache.maven.archetypes:maven-archetype-j2ee-simple (An archetype which contains a simplifed sample J2EE application.)
...
7: internal -> org.apache.maven.archetypes:maven-archetype-quickstart (An archetype which contains a sample Maven project.)
...
Choose a number or apply filter (format: [groupId:]artifactId, case sensitive contains): 7: 
Define value for property 'groupId': com.rosydawn.test
Define value for property 'artifactId': classpath-test
Define value for property 'version' 1.0-SNAPSHOT: :
Define value for property 'package' com.rosydawn.test: : com.rosydawn.test
Confirm properties configuration:
groupId: com.rosydawn.test
artifactId: classpath-test
version: 1.0-SNAPSHOT
package: com.rosydawn.test
 Y: :
[INFO] ----------------------------------------------------------------------------
[INFO] Using following parameters for creating project from Old (1.x) Archetype: maven-archetype-quickstart:1.1
[INFO] ----------------------------------------------------------------------------
[INFO] Parameter: basedir, Value: C:\Users\Vincent Huang
[INFO] Parameter: package, Value: com.rosydawn.test
[INFO] Parameter: groupId, Value: com.rosydawn.test
[INFO] Parameter: artifactId, Value: classpath-test
[INFO] Parameter: packageName, Value: com.rosydawn.test
[INFO] Parameter: version, Value: 1.0-SNAPSHOT
[INFO] project created from Old (1.x) Archetype in dir: C:\Users\Vincent Huang\classpath-test
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 06:09 min
[INFO] Finished at: 2017-04-20T21:11:40+08:00
[INFO] Final Memory: 15M/167M
[INFO] ------------------------------------------------------------------------
```



![classpathtest](../../graphs/photos/classpathtest.png)