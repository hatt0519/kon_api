webapi
======

##webapiについて
ネーミングは安直ですが、その名前どうりwebapiを作成するアプリケーションです。
フレームワークにsinatraを使っています。

##WEBrickについて
sinatra.ver1.4.5では搭載webサーバがWEBrickです。デフォルトでポートが4567なので空けるの忘れるとアクセスができません。
そこのところを気をつけてください。（サーバがpumaの場合もあるようですが、その時もポートは4567みたいです。）

##database.ymlについて
active_recordでDBに接続する際の設定情報を書き込みます。それぞれのDBに合わせてDB名、ホスト名、ユーザ名、パスワード等を書き込んでください。
