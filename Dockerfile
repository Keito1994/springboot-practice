FROM adoptopenjdk/openjdk8:alpine-slim

# javaの起動オプション（環境変数JAVA_OPTSが外部から渡されるとjavaのオプションとして更に渡します）
ENV JAVA_OPTS=""
# アプリケーション実行用グループID
ENV GROUP_ID=1000
# アプリケーション実行用グループ名
ENV GROUP_NAME="app"
# アプリケーション実行用ユーザID
ENV USER_ID=1000
# アプリケーション実行用ユーザ名
ENV USER_NAME="app"
# ホスト側の成果物パス
ENV HOST_JAR_PATH="springboot-practice-0.0.1-SNAPSHOT.jar"
# コンテナ側の成果物パス
ENV CONTAINER_JAR_PATH="/home/${USER_NAME}/${USER_NAME}.jar"

# ロケール
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8

RUN set -x && \
    # パッケージ全更新
    apk update && \
    # タイムゾーン変更 https://wiki.alpinelinux.org/wiki/Setting_the_timezone
    apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    # タイムゾーンファイルをコピーし終えて不要になったタイムゾーンパッケージはアンインストール
    apk del tzdata && \
    # アプリケーション実行用のユーザ・グループを作成
    addgroup -S -g ${GROUP_ID} ${GROUP_NAME} && \
    adduser -D -S -G ${GROUP_NAME} -u ${USER_ID} -s /bin/sh ${USER_NAME}

VOLUME /tmp

# ホストからコンテナに成果物をコピー
COPY ./build/libs/${HOST_JAR_PATH} ${CONTAINER_JAR_PATH}

RUN set -x && \
    # 成果物のオーナー・グループをアプリケーション実行ユーザに制限する
    chown ${USER_NAME}:${GROUP_NAME} ${CONTAINER_JAR_PATH} && \
    # 成果物はオーナーのみ触れるようにする
    chmod 0600 ${CONTAINER_JAR_PATH} && \
    # キャッシュクリア
    rm -rf /var/cache/apk/*

# ポートの開放
EXPOSE 8080

# アプリケーション実行ユーザはrootにしない
USER ${USER}

    ENTRYPOINT exec java $JAVA_OPTS -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom -jar ${CONTAINER_JAR_PATH}
