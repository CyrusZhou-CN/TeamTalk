# TeamTalk
* [TeamTalk源码解析](TeamTalk源码解析/index.md)
* TeamTalk is a solution for enterprise IM
具体文档见doc目录下,安装之前请仔细阅读[相关文档](doc/README.md)。
# 安装调试参考 
https://blog.csdn.net/lsqtzj/article/details/119456161</br>
# 客户端
## Android
2022年1月6日 项目更新到 Android Studio 2020.3.1.26 版本</br>
Android Gradle Plugin   7.0.4</br>
Gradle                  7.0.2
## Windows
更新到 Visual Studio 2019 (v142)  ISO C++17 标准 (/std:c++17)</br>
win-cliient\solution\teamtalk.sln(需要管理员模式打开)
### 库安装
需要安装 vcpkg https://github.com/microsoft/vcpkg#quick-start-windows</br>
vcpkg install protobuf[core]:x86-windows</br>
protobuf    -> 3.18.0</br>
protobuf 更新后可以替换/pb/protoc.exe 后重新运行make_PB_Files.bat 生成PB协议文件

# 服务端 Docker 支持
基于 openeuler/openeuler:20.03 系统的 docker 容器系统，方便快速调试。
![image](https://user-images.githubusercontent.com/4635861/150361679-a56f862f-ff1f-4c99-bcf3-2d4e4719d143.png)
## 直接运行版本
cd docker</br>
docker-compose up -d
## 编译版本
cd docker</br>
docker-compose -f "docker-compose-build.yml" up -d --build
### b'i/o timeout' 问题
重复执行 docker-compose *** 命令就可以解决。
# 其他
## 命令行转换
下载https://sourceforge.net/projects/dos2unix/</br>

命令行运行</br>
for /R %G in (*.c *.cc *.h *.mk *.cpp) do unix2dos "%G" 
## linux换行问题
yum install dos2unix</br>
find ./ -type f -print0 | xargs -0 dos2unix --