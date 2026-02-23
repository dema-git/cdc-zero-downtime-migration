FROM amazoncorretto:17

WORKDIR /app

RUN yum install -y nc && yum clean all

COPY kafdrop/kafdrop.jar ./kafdrop.jar

ENTRYPOINT ["java", "-jar", "kafdrop.jar"]