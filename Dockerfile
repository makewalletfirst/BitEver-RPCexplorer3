# 1. Base 이미지 설정
FROM node:18-slim

# 2. 작업 디렉토리 생성
WORKDIR /app

# 3. git 설치 (slim 이미지에는 git이 없어서 수동으로 추가해야 합니다)
# 설치 후 불필요한 캐시를 지워 용량을 최적화합니다.
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# 4. npm 설정 (네트워크 타임아웃 대비)
RUN npm config set fetch-retries 5
RUN npm config set fetch-retry-mintimeout 20000

# 5. 의존성 설치
COPY package*.json ./
RUN npm install --omit=dev --no-audit --progress=false

# 6. 전체 소스 코드 복사
COPY . .

# 7. 실행 포트 노출 (기본 3002번)
EXPOSE 3002

# 8. 앱 실행 명령어
CMD ["npm", "start"]
