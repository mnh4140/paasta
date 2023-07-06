FROM nginx:latest

#nginx 설정 파일 복사
COPY ingress-test/nginx-test/default.conf /etc/nginx/conf.d/default.conf
COPY ingress-test/nginx-test/index.html /usr/share/nginx/html/index.html

# 웹서버 기본 포트 4140으로 변경
EXPOSE 4140
