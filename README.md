# Docker, docker-composeハンズオン的な何か

**目次**

- [今日のゴール](#goal)
- [Dockerとは](#docker-about)
- [仮装技術とは](#vm-about)
- [Dockerと仮装技術の違い](#docker-vm)
- [準備](#preparation)
- [Dockerfileの作り方](#dockerfile)
- [Dockerをbuild](#docker-build)
- [Dockerの実行](#docker-run)
- [docker-composeとは](#compose-about)
- [docker-compose.ymlの作り方](#compose)
- [docker-composeの実行](#compose-run)

<a id="goal"></a>
## <a href="#goal">今日のゴール</a>
***

`簡単なDockerイメージを作成して、docker-composeを使って、起動できる`

<a id="docker-about"></a>
## <a href="#docker-about">Dockerとは</a>
***
`Docker社が提供している軽量な実行環境を実現するコンテナ技術のプロダクト`

簡単に言うと、「OSとDockerさえあれば、だいたい何でもできる魔法の技術」

<a id="vm-about"></a>
## <a href="#vm-about">仮装技術とは</a>
***

`PCやサーバといったマシンにインストールされているOS(ホストOS)の上に、別のマシンを仮想的に立ち上げる事`

簡単に言うと「パソコンの中に仮想パソコンを起動する」のが仮想化です。

- vagrant
- VMware



<a id="docker-vm"></a>
## <a href="#docker-vm">Dockerと仮装技術の違い</a>
***

**そもそもの背景として**

開発者が使用しているコンピュータはMac OSX、Windowsなどの違いがあったり、人によって様々なソフトウェアが入っているなど、実行環境を共有するのは容易ではなかったため

そこで、導入され始めたのが、vagrantなどの仮装環境技術

だが、従来のホスト型仮想化では、動作がとても重く、共有するためのファイルも軽量とは言えませんでした。

そこで、Docker社のコンテナ技術が登場し、軽量かつ実行環境の共有が用意になった

<a id="preparation"></a>
## <a href="#preparation">準備</a>
***

どちらかのリポジトリをforkしておいてください

- [Javaの人](https://github.com/adachishohei/springboot-practice)
- [PHPの人](https://github.com/adachishohei/laravel-practice)


<a id="dockerfile"></a>
## <a href="#dockerfile">Dockerfileの作り方</a>
***

1. イメージ選び
   実行したいものに対して、最適な軽量イメージを選ぶ必要があります
   Javaの場合は、Openjdk, adoptopenjdk, correttoなどなど...
   PHPの場合は、php-fpm

2. イメージに必要なモジュールをinstallする
   タイムゾーンの設定やツールのアップデートなどをする
   RUN

3. 必要なデータをホストから渡す
   アプリケーションを実行するために必要なデータを渡す
   COPYやADDを使う

4. ポートの解放
   アプリケーションへアクセスするためのポートを解放する
   EXPOSE 8080

5. 最終のコマンドの実行
   アプリケーションの実行コマンドなどがくる
   ex) java -jar xxxx.jar

<a id="docker-build"></a>
## <a href="#docker-build">Dockerをbuild</a>
***

**作ったDockerfileでbuildしてみる**

```
docker build -t test/test:latest .
```

<a id="docker-run"></a>
## <a href="#docker-run">Dockerの実行</a>
***

**実際作ったイメージを実行する**

Javaの人

ネットワークの作成
```
docker network create my_network
```

mysqlを実行
```
docker run --net my_network --name mysql -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=sample -d -p 3306:3306 mysql:5.7
```

アプリケーションの実行
```
docker run --net my_network -e DATABASE_URL=mysql -e DATABASE_PASSWORD=password -d -p 8080:8080 springboot-practice:latest
```

PHPの人

ごめんなさい
docker runコマンドでの方法がわからなかった....

```
docker run --net nginx-php --name php -v $PWD/app:/var/www -p 9000:9000 -d php-test

docker run --net nginx-php --name nginx -v $PWD/nginx-config/default.conf:/etc/nginx/conf.d/default.conf  -p 80:80 -d nginx

docker run --net nginx-php --name mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=docker -e MYSQL_PASSWORD=docker -e MYSQL_DATABASE=database -d -p 3306:3306 mysql:5.7
```

<a id="compose-about"></a>
## <a href="#compose-about">docker-composeとは</a>
***

*Docker compose とは、複数のコンテナから成るサービスを構築・実行する手順を自動的にし、管理を容易にする機能です。*
*Docker compose では、compose ファイルを用意してコマンドを1 回実行することで、そのファイルから設定を読み込んですべてのコンテナサービスを起動することができます。*

docker-composeを使うケースは、下記のような複数のコンテナを使用するケースが一般的

- Webアプリケーション
- DB
- Webサーバー

理由としては、それぞれのコンテナを用意して、それぞれを実行するのは、面倒で管理コストが高いから

変な話、docker-composがあれば、Dockerfileはいらない場合もある(docker-composeでbuildできるから)

<a id="compose"></a>
## <a href="#compose">docker-compose.ymlの作り方</a>
***

docker-composeを一行ずつ書いていきながら、説明する

## 

<a id="compose-run"></a>
## <a href="#compose-run">docker-composeの実行</a>
***

`docker-compose up`
もしくは
`docker-compose up -d`
