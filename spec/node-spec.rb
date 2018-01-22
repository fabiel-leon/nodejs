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

describe "NVM" do
  let(:subject) { command("nvm --version") }
  
  it "is installed" do
    expect(subject.stdout).to match /^\d+\.\d+\.\d+$/
  end
  
  # Can't use "no errors"; docker thinks this should be interactive/login shell
  it "has no errors" do
    expect(subject.exit_status).to eq 0
  end
end

context "CLI" do
  describe "Node runtime" do
    let(:subject) { command(%Q{nvm run 9.4.0 -e "console.log('node is installed');"}) }
    
    it "executes JavaScript" do
      expect(subject.stdout).to match /^node is installed$/
    end
    
    it "has no errors" do
      expect(subject.exit_status).to eq 0
    end
  end

  describe "Node version" do
    let(:subject) { command("nvm run 9.4.0 --version") }
    
    it "is the requested version" do
      expect(subject.stdout).to match /^#{Regexp.quote("v9.4.0")}$/
    end
    
    it "has no errors" do
      expect(subject.exit_status).to eq 0
    end
  end
end

describe "Web requests" do
  let(:subject) { command("curl -i node-test.dev") }
  
  include_examples("curl request", "200")

  include_examples "curl request html"
  
  it "processed Node.js code" do
    expect(subject.stdout).to match /Phusion Passenger is serving Node.js v9\.4\.0 code on node-test\.dev/
  end
end
