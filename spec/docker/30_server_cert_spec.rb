require "docker_helper"

### SERVER_CERTIFICATE #########################################################

describe "Server certificate", :test => :server_cert do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### CONFIG ###################################################################

  ca_subj     = "/CN=Simple CA"

  crt         = ENV["SERVER_CRT_FILE"]        || "/etc/ssl/certs/server.crt"
  crt_subj    = ENV["SERVER_CRT_SUBJECT"]     || "/CN=#{ENV["CONTAINER_NAME"]}"
  crt_user    = ENV["SERVER_CRT_FILE_USER"]   || "root"
  crt_group   = ENV["SERVER_CRT_FILE_GROUP"]  || "root"
  crt_mode    = ENV["SERVER_CRT_FILE_MODE"]   || 444

  key         = ENV["SERVER_KEY_FILE"]        || "/etc/ssl/private/server.key"
  key_pwd     = ENV["SERVER_KEY_PWD_FILE"]    || "/etc/ssl/private/server.pwd"
  key_user    = ENV["SERVER_KEY_FILE_USER"]   || "root"
  key_group   = ENV["SERVER_KEY_FILE_GROUP"]  || "root"
  key_mode    = ENV["SERVER_KEY_FILE_MODE"]   || 440

  p12         = ENV["SERVER_P12_FILE"]        || "/etc/ssl/private/server.p12"
  p12_pwd     = ENV["SERVER_KEY_PWD_FILE"]    || "/etc/ssl/private/server.pwd"
  p12_user    = ENV["SERVER_KEY_FILE_USER"]   || "root"
  p12_group   = ENV["SERVER_KEY_FILE_GROUP"]  || "root"
  p12_mode    = ENV["SERVER_KEY_FILE_MODE"]   || 440

  ca_subj_dn   = ca_subj[1..-1]
    .split(/\//)
    .map { |attribute| attribute.sub(/^(\w+)=/, '\1 = ') }
    .join(", ")

  crt_subj_dn = crt_subj[1..-1]
    .split(/\//)
    .map { |attribute| attribute.sub(/^(\w+)=/, '\1 = ') }
    .join(", ")

  ### CERTIFICATE ##############################################################

  describe x509_certificate(crt) do
    context "file" do
      subject { file(crt) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(crt_mode) }
      it { is_expected.to be_owned_by(crt_user) }
      it { is_expected.to be_grouped_into(crt_group) }
    end
    context "certificate" do
      it { is_expected.to be_certificate }
      it { is_expected.to be_valid }
    end
    its(:issuer) { is_expected.to match(/^#{ca_subj}|#{ca_subj_dn}$/) }
    its(:subject) { is_expected.to match(/^#{crt_subj}|#{crt_subj_dn}$/) }
    its(:validity_in_days) { is_expected.to be > 3600 }
    context "subject_alt_names" do
      if ! ENV["SERVER_CRT_HOST"].nil? then
        ENV["SERVER_CRT_HOST"].split(/,/).each do |host|
          it { expect(subject.subject_alt_names).to include("DNS:#{host}") }
        end
      end
      it { expect(subject.subject_alt_names).to include("DNS:#{ENV["CONTAINER_NAME"]}") }
      it { expect(subject.subject_alt_names).to include("DNS:localhost") }
      it { expect(subject.subject_alt_names).to include("IP Address:#{ENV["SERVER_CRT_IP"]}") } unless ENV["SERVER_CRT_IP"].nil?
      it { expect(subject.subject_alt_names).to include("IP Address:127.0.0.1") }
      it { expect(subject.subject_alt_names).to include("Registered ID:#{ENV["SERVER_CRT_OID"]}") } unless ENV["SERVER_CRT_OID"].nil?
    end
  end

  ### PRIVATE_KEY_PASSPHRASE ###################################################

  describe "X509 private key passphrase \"#{key_pwd}\"" do
    context "file" do
      subject { file(key_pwd) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(key_mode) }
      it { is_expected.to be_owned_by(key_user) }
      it { is_expected.to be_grouped_into(key_group) }
    end
  end

  ### PRIVATE_KEY ##############################################################

  describe x509_private_key(key, {:passin => "file:#{key_pwd}"}) do
    context "file" do
      subject { file(key) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(key_mode) }
      it { is_expected.to be_owned_by(key_user) }
      it { is_expected.to be_grouped_into(key_group) }
    end
    context "key" do
      it { is_expected.to be_encrypted }
      it { is_expected.to be_valid }
      it { is_expected.to have_matching_certificate(crt) }
    end
  end

  ### PKCS12_KEYSTORE ##########################################################

  # TODO: Serverspec does not support PKCS12 keystores
  #describe pkcs12_keystore(p12, {:passin => "file:#{key_pwd}"}) do
  describe "PKCS12 keystore \"#{p12}\"" do
    context "file" do
      subject { file(p12) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(p12_mode) }
      it { is_expected.to be_owned_by(p12_user) }
      it { is_expected.to be_grouped_into(p12_group) }
    end
    context "keystore" do
      # TODO: Serverspec does not support PKCS12 keystores
      # it { is_expected.to be_valid }
      # it { is_expected.to be_encrypted }
      subject { command("openssl pkcs12 -in #{p12} -passin file:#{key_pwd} -noout -info") }
      it "shoud be valid" do
        expect(subject.exit_status).to eq(0)
        expect(subject.stderr).to match(/^MAC(:sha1)? Iteration 2048$/)
      end
      it "should be encrypted" do
        expect(subject.stderr).to match(/^PKCS7 Encrypted data: pbeWithSHA1And3-KeyTripleDES-CBC, Iteration 2048$/)
      end
    end
    # TODO: Serverspec does not support PKCS12 keystores
    # context "certificate" do
    #   it { expect(subject.certificate).to be_certificate }
    #   it { expect(subject.certificate).to be_valid_certificate }
    # end
    # its(:subject) { is_expected.to eq "/#{subj}" }
    # its(:issuer)  { is_expected.to eq "/CN=Docker Simple CA" }
    # its(:validity_in_days) { is_expected.to be > 3650 }
    # context "subject_alt_names" do
    #   it { expect(subject.subject_alt_names).to include("DNS:#{ENV["SERVER_CRT_HOST"]}") } unless ENV["SERVER_CRT_HOST"].nil?
    #   it { expect(subject.subject_alt_names).to include("DNS:#{ENV["CONTAINER_NAME"]}") }
    #   it { expect(subject.subject_alt_names).to include("DNS:localhost") }
    #   it { expect(subject.subject_alt_names).to include("IP Address:#{ENV["SERVER_CRT_IP"]}") } unless ENV["SERVER_CRT_IP"].nil?
    #   it { expect(subject.subject_alt_names).to include("IP Address:127.0.0.1") }
    #   it { expect(subject.subject_alt_names).to include("Registered ID:#{ENV["SERVER_CRT_OID"]}") } unless ENV["SERVER_CRT_OID"].nil?
    # end
    context "key" do
      # TODO: Serverspec does not support PKCS12 keystores
      # it { expect(subject.key).to be_encrypted_key }
      # it { expect(subject.key).to be_valid_key }
      # it { expect(subject.key).to have_matching_certificate }
      subject { command("openssl pkcs12 -in #{p12} -passin file:#{key_pwd} -noout -info") }
      it "should be encrypted" do
        expect(subject.exit_status).to eq(0)
        expect(subject.stderr).to match(/^Shrouded Keybag: pbeWithSHA1And3-KeyTripleDES-CBC, Iteration 2048$/)
      end
    end
  end

  ##############################################################################

end

################################################################################
