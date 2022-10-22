# DevOps a Rails application

## Rails アプリケーションを DevOps

## 使用ツール

- Ansible
- CircleCI
- ServerSpec
- Terraform

## 概要

リポジトリに Push を契機に CircleCI が動作します。

1. Terraform によるインフラ環境構築
2. Ansible による構成管理
3. ServerSpec による自動テスト

## 事前設定

## AWS

- IAM からプログラムによるアクセスできるユーザーの作成
- Elastic IP アドレス を用意
- RDS のエンドポイントを事前に確認しておくこと<br>
  Amazon RDS のエンドポイントの命名規則は以下
  ```
  識別子は、RDS によってインスタンスに割り当てられた DNS ホスト名の一部として使用されます。たとえば、db1 を DB インスタンス識別子として指定した場合、RDS は、db1.123456789012.us-east-1.rds.amazonaws.com などのインスタンスの DNS エンドポイントを自動的に割り当て、ここでの 123456789012 はアカウントの特定の地域の固定識別子です。
  ここでの 123456789012 はアカウントの特定の地域の固定識別子です。
  ```
  つまり、
  - RDS のインスタンス識別子
  - AWS アカウント ID
  - RDS インスタンスを配置するリージョン が変わらなければ、たとえば RDS インスタンスを作り直してもエンドポイントは変わらないようです。

## CircleCI の設定

- Project Settings > Environment Variables から設定
  ![ Environment Variables](https://user-images.githubusercontent.com/92103678/197310480-ec0620d1-cfba-4a87-abe8-067f661dc8fe.png)
  <br><br>
- Project Settings > Additional SSH Keys から設定  
  <img width="468" alt="Add an SSH Key" src="https://user-images.githubusercontent.com/92103678/197310476-b0d6a322-8a0b-473f-b9a9-c28ba9add251.png"><br><br>
  SSH キーを登録すると Fingerprint が作成されます。
  ![Additional SSH Keys](https://user-images.githubusercontent.com/92103678/197310469-01520ab9-5e95-439b-91d2-da73335675d2.png)
