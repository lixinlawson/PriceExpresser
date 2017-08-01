# Base configuration recipe in Chef.
package "wget"
package "ntp"
package "ruby1.9.1-dev"
package "zlib1g-dev"
package "sqlite3"
package "libsqlite3-dev"
package "nodejs"
package "openjdk-7-jre-headless"
package "apache2"
package "libapache2-mod-passenger"
package "postgresql"
package "libpq-dev"

cookbook_file "ntp.conf" do
  path "/etc/ntp.conf"
end
execute 'ntp_restart' do
  command 'service ntp restart'
end
cookbook_file "000-default.conf" do
  path "/etc/apache2/sites-enabled/000-default.conf"
end
execute 'apt_update' do
  command 'apt-get update'
end
execute 'install_rails' do
  command 'sudo gem install rails'
end
execute 'bundle_install' do
  cwd '/home/vagrant/project/PriceExpresser/'
  command 'bundle install'
end
execute 'copy_hosts_file' do
  command 'cp /home/vagrant/project/hosts /etc/'
end

execute 'rake_migrate' do
  cwd '/home/vagrant/project/PriceExpresser/bin'
  command 'rake db:migrate'
end

execute 'create_db' do
  command 'echo "CREATE DATABASE mydb; CREATE USER vagrant; GRANT ALL PRIVILEGES ON DATABASE mydb TO vagrant;" | sudo -u postgres psql'
end

execute 'rake_db' do
  user 'vagrant'
  cwd '/home/vagrant/project/PriceExpresser/'
  command 'rake db:migrate RAILS_ENV=production'
  user 'vagrant'
end

execute 'rake_db_seed' do
  user 'vagrant'
  cwd '/home/vagrant/project/PriceExpresser/'
  command 'rake db:seed RAILS_ENV=production'
  user 'vagrant'
end

execute 'cp_db_file' do
 user 'vagrant'
 cwd '/home/vagrant/project/'
 command 'psql mydb < initial_data'
end

execute 'static_files' do
 cwd '/home/vagrant/project/PriceExpresser/'
 command 'bundle exec rake assets:precompile RAILS_ENV=production'
 user 'vagrant'
end


execute 'apache2_restart' do
  command 'service apache2 restart'
end

execute 'download_elasticsearch' do
  cwd '/home/vagrant/project/'
  command 'wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.0.0/elasticsearch-2.0.0.deb'
end
execute 'install_search_engine' do
  cwd '/home/vagrant/project/'
  command 'sudo dpkg -i elasticsearch-2.0.0.deb'
end
execute 'start_elasticsearch' do
  command 'sudo service elasticsearch start'
end


