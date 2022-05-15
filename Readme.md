# 개요
* 테라폼 transit gatweway 실습을 위한 인프라 자동화
* 유투브 영상: https://youtu.be/sN55nRo6eQs
* 인프라 아키텍처

![](imgs/arch.png)

# 준비
* aws 프로파일을 환경변수로 설정(또는 $HOME/.aws로 관리)
* ohio 리전 사용
```sh
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-east-2"
```

# 실행
```sh
terraform init
terraform plan
terraform apply
```

# 삭제
```sh
terraform destroy
```