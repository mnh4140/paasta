# PV-PVC 정리

API 리소스

퍼시스턴트볼륨(PV) : 관리자가 프로비저닝 하거나 스토리지 클래스를 사용하여 동적으로 프로비저닝한 "클러스터의 스토리지"다
노드가 클러스터 리소스인 것처럼 PV는 클러스터 리소스이다.
PV는 Volumes와 같은 볼륨 플러그인이지만 PV를 사용하는 개별 파트와는 별개의 라이프사이클을 가진다
이 API 오프젝트는 NFS, iSCSI 또는 클라우드 공급자별 스토리지 시스템 등 스토리지 구현에 세부 정보를 담아낸다

퍼시스턴트볼륨클레임은 사용자의 스토리지에 대한 요청이다
파드와 비슷하다
파드는 노드 리소스를 사용 / PVC는 PV 리소스를 사용한다
파드는 특정 수준의 리소스(CPU 및 메모림) 요청 가능
클레임은 특정 크기 및 접근 모드를 요청할 수 있다.(ReadWriteOnce, ReadOnlyMany 또는 ReadWireMany로 마운트 할 수 있다.)

퍼시스턴트볼륨클레임을 사용하면 사용자가 추상화된 스토리지 리소스를 사용할수있지만 다은 문제들 때문에 성능과 같은 다양한 속성을 가진 퍼시스턴트 볼륨이 필요한 경우가 일반적이다.
클러스터 관리자는 사용자에게 해당 봉륨의 구현방법에 대한 세부정보를 제공하지않고 크기와 접근모드와는 다른방식으로 다양한 퍼시스턴트볼륨울 제공할수있어야한다
이러한 요구에는 스토리지클레스 리소스가 있다.


# PV 리소스를 사용한 pod는 종료되도 PV에 기록된 데이터는 삭제되지 않고 남아있는다.


---

# 로컬볼륨: hostPath, emptyDir

hostPath는 호스트와 볼륨을 공유하기 위해 사용하고 emptyDir은 포드의 컨테이너 간에 볼륨을 공유하기 위해 사용함

워커 노드의 로컬 디렉터리를 볼륨으로 사용: hostPath
포드의 데이터를 보존할 수 있는 가장 간단한 방법은 호스트의 디렉터리를 포드와 공유하는 것
<hostpath-pod.yaml>
<pre>
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-pod
spec:
  containers:
    - name: my-container
      image: busybox
      args: [ "tail", "-f", "/dev/null" ]
      volumeMounts:
      - name: my-hostpath-volume
        mountPath: /etc/data
  volumes:
    - name: my-hostpath-volume
      hostPath:
        path: /tmp
</pre>
volumes 항목에 볼륨을 정의한 뒤, 이를 containers 항목에서 참조해서 사용함

호스트의 /tmp를 포드의 /etc/data에 마운트 함

<pre>
$ kubectl apply -f hostpath-pod.yaml  
$ kubectl exec -it hostpath-pod touch /etc/data/mydata
</pre>
포드가 생성된 워커 노드로 접속한 뒤, /tmp 디렉터리를 확인하면 확인 가능함
참고) volumes.hostPath.type에 DirectoryOrCreate를 명시하면 실제 경로가 없다면 새로 생성함
- DirectoryOrCreate : 실제 경로가 없다면 생성
- Directory : 실제 경로가 있어야됨
- FileOrCreate : 실제 경로에 파일이 없다면 생성
- File : 실제 파일이 었어야함

하지만 위와 같은 데이터 보존은 바람직하지 않다.

디플로이먼트의 포드에 장애가 생겨 다른 노드로 포드가 옮겨간 경우 이전 노드에 저장된 데이터를 사용할 수 없기 때문이다.

특정 노드에만 포드를 배치하는 방법도 생각할 수 있지만 이 방법 또한 호스트 서버에 장애가 생기면 데이터를 잃게 된다는 단점이 존재한다.

 

hostPath 볼륨은 모든 노드에 배치해야 하는 특수한 포드의 경우에 유용하게 사용할 수 있다.

만약 CAdvisor와 같은 모니터링 툴을 쿠버네티스의 모든 워커 노드에 배포해야 한다면 hostPath를 사용하는 것이 옳을 수 있지만 그 외에는 보안 및 활용성 측면에서 그다지 바람직하지 않으므로 사용을 고려해보는 것이 좋다.

---

