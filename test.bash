#!/bin/bash
# SPDX-FileCopyrightText: 2026 Nanami Ishikawa
# SPDX-License-Identifier: BSD-3-Clause

ng () {                                  # 関数ngの定義（P18と同じ）
         echo ${1}行目のテスト失敗
         res=1                           # 失敗したことを記録
}

res=0                                    # 0: 失敗なし（ngが呼ばれると1になる）

### NORMAL INPUT ###
out=$(echo 2 | ./wheel 65)               # 表の1行目: wheelの出力を変数outに記録
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 408.41 ] || ng "$LINENO"    # 期待する出力（408.41）でなければngを呼び出す

out=$(echo 1000 | ./wheel -r 65)
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 4.90 ] || ng "$LINENO"      # 期待する出力（4.90）でなければngを呼び出す

out=$(echo 500 | ./wheel -c 65 150 )     # 円を描く場合の正常
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "2670.35 3612.83 13.08 17.69" ] || ng "$LINENO"


### STRANGE INPUT ###
out=$(echo | ./wheel 65)                 # 何も入力しない
[ "$?" = 1 ]      || ng "$LINENO"        # 終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO" 

out=$(echo あ | ./wheel 65)              # 数字以外
[ "$?" = 1 ]      || ng "$LINENO"        # 終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 2 | ./wheel -r)               # 直径なし
[ "$?" = 1 ]      || ng "$LINENO"        # 終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 1 | ./wheel)                  # 引数なし
[ "$?" = 1 ]      || ng "$LINENO"        # これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 1 | ./wheel 0)                # 直径が0   
[ "$?" = 1 ]      || ng "$LINENO"        # これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 500 | ./wheel -c 65 )         # トレッド幅なし
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 500 | ./wheel -c 65 0 )       # トレッド幅0
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 500 | ./wheel -c 0 150 )      # 直径0
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 1 | ./wheel nan )             # 直径がnan
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo -100 | ./wheel -c 65 150 )    # 半径が負
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"


[ "${res}" = 0 ] && echo OK              # 通ったのが分かるように表示
exit $res                                # 終了ステータスを返して終了
