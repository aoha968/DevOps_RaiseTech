require 'spec_helper'

db_user = "admin"
db_password = "password"
db_host = "terraform-db-instance.c7ebcdldpjme.ap-northeast-1.rds.amazonaws.com"
db_name = "raisetech_live8_sample_app_development"

# -------------------------------------------------------------------------#
# ポートチェック
# -------------------------------------------------------------------------#
listen_ports = [22, 3000]
listen_ports.each do |listen_port|
  describe port(listen_port) do
    it { should be_listening }
  end
end

#ステータスが200で返ってくるか
# -------------------------------------------------------------------------#
# HTTPステータスコード(200 = リクエスト受理)
# -------------------------------------------------------------------------#
describe command('curl http://13.112.172.57:3000 -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end

# -------------------------------------------------------------------------#
# Bundlerのバージョンを確認
# -------------------------------------------------------------------------#
describe package('bundler') do
  it { should be_installed.by('gem').with_version('2.3.14') }
end

# -------------------------------------------------------------------------#
# Rubyのバージョンを確認
# -------------------------------------------------------------------------#
describe command('ruby -v') do
  its(:stdout) { should match /ruby 2\.6\.3/ }
end

# -------------------------------------------------------------------------#
# Railsのバージョンを確認
# -------------------------------------------------------------------------#
describe package('rails') do
  it { should be_installed.by('gem').with_version('6.1.3.1') }
end

# -------------------------------------------------------------------------#
# RDSにデータベースがあるかを確認
# -------------------------------------------------------------------------#
describe command("mysqlshow -u #{db_user} -h #{db_host} -p#{db_password} #{db_name}" ) do
    its(:stdout) { should contain("#{db_name}").from("Database:") }
end

# -------------------------------------------------------------------------#
# Nginxのバージョンを確認
# -------------------------------------------------------------------------#
describe package('nginx') do
  it { should be_installed }
  it { should be_installed.with_version "1.20.0" }
end

# -------------------------------------------------------------------------#
# Nginxの動作確認
# -------------------------------------------------------------------------#
describe service('nginx') do
  it { should be_running }
end

# -------------------------------------------------------------------------#
# Unicornのバージョンを確認
# -------------------------------------------------------------------------#
describe package('unicorn') do
  it { should be_installed.by('gem').with_version('5.4.1') }
end

# -------------------------------------------------------------------------#
# Unicornのsocketsファイルがあるかを確認
# -------------------------------------------------------------------------#
describe file('/var/www/raisetech-live8-sample-app/tmp/sockets/unicorn.sock') do
  it { should be_socket }
end

# -------------------------------------------------------------------------#
# Rails Applicationを格納しているディレクトリのパスの確認
# 所有者とグループがec2-userであるかの確認
# -------------------------------------------------------------------------#
describe file('/var/www/raisetech-live8-sample-app') do
  it { should be_directory }
  it { should be_owned_by 'ec2-user' }
end

# -------------------------------------------------------------------------#
# ImageMagickがインストールされているか
# -------------------------------------------------------------------------#
describe command('convert --version') do
  its(:exit_status) { should eq 0 }
end
