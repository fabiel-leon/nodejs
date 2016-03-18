require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/node-playbook.yml", { copy_appjs: true, node_version: "v5.5.0" }
  end
end

describe "Nginx config should be valid" do
  include_examples "nginx::config"
end

describe command("nvm run 5.5.0 -e \"console.log('node-installed');\"") do
  its(:stdout) { should match /node-installed/ }

  its(:exit_status) { should eq 0 }
end

describe command("nvm run 5.5.0 --version") do
  its(:stdout) { should match /^v5\.5\.0$/ }

  its(:exit_status) { should eq 0 }
end

describe command('printf "GET / HTTP/1.1\nHost: node-test.dev\n\n" | nc 127.0.0.1 80') do
  its(:stdout) { should match /^+HTTP\/1\.1 200 OK$/ }

  its(:stdout) { should match /Phusion Passenger is serving Node.js v5\.5\.0 code on node-test\.dev/ }
end
