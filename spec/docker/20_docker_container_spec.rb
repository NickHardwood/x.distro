require "docker_helper"

### DOCKER_CONTAINER ###########################################################

describe "Docker container", :test => :docker_container do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_CONTAINER #########################################################

  describe docker_container(ENV["CONTAINER_NAME"]) do
    # Execute Serverspec command locally
    before(:each) { set :backend, :exec }
    it { is_expected.to be_running }
  end

  ### PROCESSES ################################################################

  describe "Processes" do
    # [process, user, group, pid]
    processes = []

    case ENV["BASE_IMAGE_NAME"]
    when "alpine"
      processes += [
        ["/sbin/tini",              "root", "root", 1],
      ]
    when "centos"
      processes += [
        ["tini",                    "root", "root", 1],
      ]
    end

    processes.each do |process, user, group, pid|
      context process(process) do
        it { is_expected.to be_running }
        its(:pid) { is_expected.to eq(pid) } unless pid.nil?
        its(:user) { is_expected.to eq(user) } unless user.nil?
        its(:group) { is_expected.to eq(group) } unless group.nil?
      end
    end
  end

  ### DOCKER_ENTRYPOINT ########################################################

  describe "Docker Entrypoint", :test => :entrypoint do
    lib_messages = "/docker-entrypoint.d/01-lib-messages.sh"
    lib_wait_for = "/docker-entrypoint.d/02-lib-wait-for.sh"

    ### /docker-entrypoint.d/01-lib-messages.sh ################################

    describe lib_messages do
      describe "#msg" do
        context "works with default arguments" do
          subject { command(<<~END)
            /bin/bash -c ". #{lib_messages}; msg LEVEL bash message"
            END
          }
          its(:exit_status) { is_expected.to eq(0) }
          its(:stdout) { is_expected.to match(/^\[\d+-\d+-\d+T\d+:\d+:\d+Z\s*\]\[LEVEL\s*\]\[bash\s*\] message$/) }
        end
      end
      [
        "error",
        "warn",
        "info",
        "debug",
      ].each do |function|
        describe "##{function}" do
          context "works with default arguments" do
            subject { command(<<~END)
              /bin/bash -c ". #{lib_messages}; #{function} message"
              END
            }
            its(:exit_status) { is_expected.to eq(0) }
            its(:stdout) { is_expected.to match(/^\[\d+-\d+-\d+T\d+:\d+:\d+Z\s*\]\[#{function.upcase}\s*\]\[bash\s*\] message$/) }
          end
        end
      end
    end

    ### /docker-entrypoint.d/02-lib-wait-for.sh ################################

    describe lib_wait_for do
      context "#wait_for_dns" do
        # [url,                                   exit_status, match]
        [
          ["simple-ca.local",                     0, "Got the simple-ca.local address \\d+\\.\\d+\\.\\d+\\.\\d+ in 0s"],
          ["https://simple-ca.local:443/ca.crt",  0, "Got the simple-ca.local address \\d+\\.\\d+\\.\\d+\\.\\d+ in 0s"],
          ["https://nonexistent.local:8888/test", 1, "nonexistent.local name resolution timed out after \\d+s"],
        ].each do |url, exit_status, match|
          context "resolve \"#{url}\"" do
            subject { command(<<~END)
              /bin/bash -c ". #{lib_messages}; . #{lib_wait_for}; wait_for_dns 1 #{url}"
              END
            }
            its(:exit_status) { is_expected.to eq(exit_status) }
            its(:stdout) { is_expected.to match(/#{match}/) }
          end
        end
      end

      context "#wait_for_tcp" do
        # [url,                                   exit_status, match]
        [
          ["baseimage.local:7",                   0, "Got the connection to tcp://baseimage.local:7 in 0s"],
          ["simple-ca.local:443",                 0, "Got the connection to tcp://simple-ca.local:443 in 0s"],
          ["https://simple-ca.local:443/ca.crt",  0, "Got the connection to tcp://simple-ca.local:443 in 0s"],
          ["https://simple-ca.local/ca.crt",      0, "Got the connection to tcp://simple-ca.local:443 in 0s"],
          ["http://simple-ca.local/ca.crt",       1, "Connection to tcp://simple-ca.local:80 timed out after \\d+s"],
          ["https://nonexistent.local:8888/test", 1, "nonexistent.local name resolution timed out after \\d+s"],
        ].each do |url, exit_status, match|
          context "connect to \"#{url}\"" do
            subject { command(<<~END)
              /bin/bash -c ". #{lib_messages}; . #{lib_wait_for}; wait_for_tcp 1 #{url}"
              END
            }
            its(:exit_status) { is_expected.to eq(exit_status) }
            its(:stdout) { is_expected.to match(/#{match}/) }
          end
        end
      end

      context "#wait_for_url" do
        # [url,                                   exit_status, match]
        [
          ["https://simple-ca.local/ca.crt",      0, "Got the connection to https://simple-ca.local/ca.crt in 0s"],
          ["http://simple-ca.local/ca.crt",       1, "Connection to http://simple-ca.local/ca.crt timed out after \\d+s"],
          ["https://nonexistent.local:8888/test", 1, "nonexistent.local name resolution timed out after \\d+s"],
        ].each do |url, exit_status, match|
          context "connect to \"#{url}\"" do
            subject { command(<<~END)
              /bin/bash -c ". #{lib_messages}; . #{lib_wait_for}; wait_for_url 1 #{url}"
              END
            }
            its(:exit_status) { is_expected.to eq(exit_status) }
            its(:stdout) { is_expected.to match(/#{match}/) }
          end
        end
      end
    end

  end

  ##############################################################################

end

################################################################################
