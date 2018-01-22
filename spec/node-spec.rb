require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/node-playbook.yml", ENV["TARGET_HOST"], {
      copy_appjs: true,
      node_version: "v9.4.0"
    })
  end
end

describe "Nginx" do
  include_examples "nginx"
end

describe command("nvm run 9.4.0 -e \"console.log('node-installed');\"") do
  its(:stdout) { should match /node-installed/ }

  its(:exit_status) { should eq 0 }
end

describe command("nvm run 9.4.0 --version") do
  its(:stdout) { should match /^v9\.4\.0$/ }

  its(:exit_status) { should eq 0 }
end

describe command('curl -i node-test.dev') do
  its(:stdout) { should match /^HTTP\/1\.1 200 OK$/ }

  its(:stdout) { should match /Phusion Passenger is serving Node.js v9\.4\.0 code on node-test\.dev/ }
end
