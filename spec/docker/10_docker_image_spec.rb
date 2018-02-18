require "docker_helper"

### DOCKER_IMAGE ###############################################################

describe "Docker image", :test => :docker_image do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_IMAGE #############################################################

  describe docker_image(ENV["DOCKER_IMAGE"]) do
    # Execute Serverspec commands locally
    before(:each) { set :backend, :exec }
    it { is_expected.to exist }
  end

  ### OS #######################################################################

  describe "Operating system" do
    context "family" do
      # We can not simple test the os[:family] because CentOS is reported as "redhat"
      subject { file("/etc/#{ENV["BASE_IMAGE_NAME"]}-release") }
      it "sould eq \"#{ENV["BASE_IMAGE_NAME"]}\"" do
        expect(subject).to be_file
      end
    end
    context "release" do
      subject { os[:release] }
      it { is_expected.to match(/^#{Regexp.escape(ENV["BASE_IMAGE_OS_VERSION"])}\./) }
    end
    context "locale" do
      context "CHARSET" do
        subject { command("echo ${CHARSET}") }
        it { expect(subject.stdout.strip).to eq("UTF-8") }
      end
      context "LANG" do
        subject { command("echo ${LANG}") }
        it { expect(subject.stdout.strip).to eq("en_US.UTF-8") }
      end
      context "LC_ALL" do
        subject { command("echo ${LC_ALL}") }
        it { expect(subject.stdout.strip).to eq("en_US.UTF-8") }
      end
    end
  end

  ### PACKAGES #################################################################

  describe "Packages" do

    # [package, version, installer]
    packages = []

    case ENV["BASE_IMAGE_NAME"]
    when "alpine"
      packages += [
        "bash",
        "ca-certificates",
        "curl",
        "jq",
        "libressl",
        "nmap-ncat",
        "su-exec",
        "supervisor",
        "tini",
      ]
    when "centos"
      packages += [
        "bash",
        "bind-utils",
        "ca-certificates",
        "curl",
        "iproute",
        "jq",
        "less",
        "net-tools",
        # CentOS 7 contains ncat an obsoleted version of ncat,
        # docker-entrypoint.d/02-wait-for.sh requires the ncat version 7.x
        # "nmap-ncat",
        "ncat",
        "openssl",
        "supervisor",
        "which",
      ]
    when "debian"
      packages += [
        "bash",
        "ca-certificates",
        "curl",
        "jq",
        "less",
        "net-tools",
        "nmap",
        "openssl",
        "procps",
        "supervisor",
      ]
    end

    packages.each do |package, version, installer|
      describe package(package) do
        it { is_expected.to be_installed }                        if installer.nil? && version.nil?
        it { is_expected.to be_installed.with_version(version) }  if installer.nil? && ! version.nil?
        it { is_expected.to be_installed.by(installer) }          if ! installer.nil? && version.nil?
        it { is_expected.to be_installed.by(installer).with_version(version) } if ! installer.nil? && ! version.nil?
      end
    end
  end

  ### COMMANDS #################################################################

  describe "Commands" do

    # [command, version, args]
    commands = []

    case ENV["BASE_IMAGE_NAME"]
    when "centos"
      commands += [
        "/sbin/su-exec",
        ["/sbin/tini",              ENV["TINI_VERSION"]],
      ]
    when "debian"
      commands += [
        "/sbin/su-exec",
        ["/sbin/tini",              ENV["TINI_VERSION"]],
      ]
    end

    commands.each do |command, version, args|
      describe "Command \"#{command}\"" do
        subject { file(command) }
        let(:version_regex) { "(^|\\W)#{version}(\\W|$)" }
        let(:version_cmd) { "#{command} #{args.nil? ? "--version" : "#{args}"}" }
        it "should be installed#{version.nil? ? "" : " with version \"#{version}\""}" do
          expect(subject).to exist
          expect(subject).to be_executable
          expect(command(version_cmd).stdout).to match(version_regex) unless version.nil?
        end
      end
    end
  end

  ### FILES ####################################################################

  describe "Files" do

    # [file, mode, user, group, [expectations]]
    files = [
      ["/docker-entrypoint.sh",                           755, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d",                            755, "root", "root", [:be_directory]],
      ["/docker-entrypoint.d/01-lib-messages.sh",         644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/02-lib-wait-for.sh",         644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/10-default-command.sh",      644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/20-docker-introspection.sh", 644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/30-simple-ca-wait.sh",       644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/35-certs-environment.sh",    644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/40-server-key-pwd.sh",       644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/41-simple-ca-certs.sh",      644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/45-trusted-ca-certs.sh",     644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/46-server-pkcs12.sh",        644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/90-exec-command.sh",         644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/etc/bashrc",                                     644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/etc/inputrc",                                    644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/etc/profile",                                    644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/etc/ssl/openssl.cnf",                            644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/etc/supervisor",                                 755, "root", "root", [:be_directory]],
      ["/etc/supervisor/supervisord.ini",                 644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/etc/supervisor/listener",                        755, "root", "root", [:be_directory]],
      ["/etc/supervisor/listener/terminate-container",    755, "root", "root", [:be_file, :eq_sha256sum]],
      ["/root/.bash_logout",                              644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/root/.bash_profile",                             644, "root", "root", [:be_file, :eq_sha256sum]],
      ["/var/log/docker.log",                             nil, "root", "root", [:be_pipe]],
      ["/var/log/docker.err",                             nil, "root", "root", [:be_pipe]],
    ]

    files.each do |file, mode, user, group, expectations|
      expectations ||= []
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_pipe }       if expectations.include?(:be_pipe)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        its(:sha256sum) do
          is_expected.to eq(
              Digest::SHA256.file("rootfs/#{subject.name}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end
  end

  ##############################################################################

end

################################################################################
