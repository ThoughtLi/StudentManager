#第一阶段，用maven镜像进行编译
FROM maven:3.6.1 AS compile_stage

####################定义环境变量 start####################

#定义工程名称，也是源文件的文件夹名称

ENV PROJECT_NAME StudentManager

#定义工作目录

ENV WORK_PATH /usr/src/$PROJECT_NAME

####################定义环境变量 start####################


#将源码复制到当前目录

COPY ./src $WORK_PATH/src
COPY ./pom.xml $WORK_PATH/pom.xml


#编译构建

RUN cd $WORK_PATH && mvn clean package -U -DskipTests

FROM  tomcat:8-jdk8

####################定义环境变量 start####################
#
##定义工程名称，也是源文件的文件夹名称
#
ENV PROJECT_NAME StudentManager
#
##定义工程版本
#
ENV PROJECT_VERSION 0.0.1-SNAPSHOT
#
##定义工作目录
#
ENV WORK_PATH /usr/src/$PROJECT_NAME
#
#####################定义环境变量 start####################
#
##安全起见不用root账号，新建用户admin
#
RUN adduser --home /home/admin admin
#
##工作目录是/app
#
WORKDIR /app
#
##从名为compile_stage的stage复制构建结果到工作目录
#
COPY --from=compile_stage $WORK_PATH/target/ /usr/local/tomcat/webapps/