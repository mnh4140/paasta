# Jenkins 쿠버네티스 Pod로 올리기
## 1. jenkins repo 추가
helm chart에 jenkins repo를 추가합니다.

```
helm repo add ${레포지터리 이름} https://charts.jenkins.io
helm repo update
```

## 2. Jenkins 파일 받기
```
mkdir helm_chart && cd helm_chart
helm fetch --untar ${레포지터리 이름}/jenkins
```
## 3. values.yaml 수정
### Ingress 사용을 위해 수정
```
vi jenkins/values.yaml
```
ingress path를 "/"이 아닌 것을 사용할 경우 jenkinsUriPrefix를 설정해야 합니다.
![image](https://github.com/mnh4140/paasta/assets/71053769/e5d25ed2-7bdf-4ab0-a8da-b4bb58f20fb2)

```
controller:
  serviceType: NodePort
  jenkinsUriPrefix: "/nh-jenkins"

  ingress:
    enabled: true
    path: "/nh-jenkins"
```
ingress 항목 수정
![image](https://github.com/mnh4140/paasta/assets/71053769/15df61b1-1337-46f1-8c5c-f60d6833ca32)
## 4. helm chart를 사용하여 Jenkins 배포
```
helm install nh-jenkins ./jenkins/ -n nh-name
```
![image](https://github.com/mnh4140/paasta/assets/71053769/8484194e-e43c-494c-ace1-5e45b4c2b17d)

## 5. Jenkins Pod 확인
```
kubectl get all -n nh-name
```
![image](https://github.com/mnh4140/paasta/assets/71053769/59b8c7e6-e33f-4a41-a1f2-03e32c5026d5)

## 6. Jenkins 접속
![image](https://github.com/mnh4140/paasta/assets/71053769/63e81459-ae5f-4f3d-9d34-4f33409f19ec)



