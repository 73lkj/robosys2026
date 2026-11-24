#!/bin/bash
# SPDX-FileCopyrightText: 2026 Nanami Ishikawa
# SPDX-License-Identifier: BSD-3-Clause

ng () {                               # 関数ngの定義（P18と同じ）
         echo ${1}行目のテスト失敗
         res=1                          # 失敗したことを記録
}

res=0                                  # 0: 失敗なし（ngが呼ばれると1になる）

### NORMAL INPUT ###
out=$(echo 2 | ./wheel 65)                  # 表の1行目: wheelの出力を変数outに記録
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 408.20 ] || ng "$LINENO"      # 期待する出力（408.20）でなければngを呼び出す

out=$(echo 1000 | ./wheel -r 65)
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 4.90 ] || ng "$LINENO"      # 期待する出力（4.90）でなければngを呼び出す


### STRANGE INPUT ###
out=$(echo | ./wheel 65)           #何も入力しない
[ "$?" = 1 ]      || ng "$LINENO" #終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO" 

out=$(echo あ | ./wheel 65)       #数字以外
[ "$?" = 1 ]      || ng "$LINENO" #終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 1 | ./wheel)           #引数なし
[ "$?" = 1 ]      || ng "$LINENO" #これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 1 | ./wheel 0)         # 直径が0   
[ "$?" = 1 ]      || ng "$LINENO" #これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK            # 通ったのが（人間に）分かるように表示
exit $res                              # 終了ステータスを返して終了（機械向け）
