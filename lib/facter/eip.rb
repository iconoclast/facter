# Fact: eip
#
# Purpose: Return information about an EnergyIP installation.
#
# Resolution:
#   Tries to find EnergyIP in /home/pipe, and then reads version.txt
#
#
# Caveats:
#

## eip.rb
## Facts related to EnergyIP
##
require 'facter'
require 'facter/util/config'

Facter.add(:pipe_home) do
  setcode do
    @home_pipe = ENV['PIPE_HOME'] || ('/home/pipe' if File.directory? '/home/pipe')
  end
end

## Env Vars
['bin/EnvSetup.sh'].each do |sh_script|
  @home_pipe ||= Facter.value(:pipe_home) || '/home/pipe'
  sh_path = File.join(@home_pipe, sh_script)
  next unless File.exists? sh_path

  env_vars = `#{sh_path} 2>/dev/null; env`
  env_vars.split.each do |line|
    key, val = line.chomp.split('=')
    next unless key && val
    Facter.add('eip_env_' + key.strip) {setcode {val.strip}}
  end
end unless Facter::Util::Config.is_windows?

# Facter.add(:eip_version) do
#   setcode do
#     value = nil
#     version_file = 'version.txt'
#     dir = Facter.value(:pipe_home) || '/home/pipe'
#     [File.join(dir,version_file)
#     ].each do |file|
#         File.open(file) { |openfile| value = openfile.readlines.collect(&:chomp).join('') } if FileTest.file?(file)
#       break if value
#     end
#
#     value
#   end
# end

VERSION_FILES = {:eip_version => 'version.txt',
                 :eip_installer_version => 'installer/installer_version.txt',
                 :eip_sap_version => 'opt/SAPAdapter5/version.txt', }

VERSION_FILES.each do |product, file|
  @home_pipe ||= Facter.value(:pipe_home) || '/home/pipe'
  value = nil
  filepath = File.join(@home_pipe, file)
  next unless FileTest.file?(filepath)

  File.open(filepath) { |openfile| value = openfile.readlines.collect(&:chomp).join('') }
  Facter.add(product) { setcode { value } } unless value.nil?
end

Facter.add(:eip_sap_zipfile) do
  setcode do
    value = nil
    @home_pipe ||= Facter.value(:pipe_home) || '/home/pipe'
    filename_glob = 'SAPAdapter*.zip'

    candidate = Dir.glob(File.join(@home_pipe, filename_glob)).sort.last

    value = candidate if candidate && FileTest.file?(candidate)
  end
end

# Facter.add(:eip_sap_version) do
#   setcode do
#     value = nil
#     version_file = 'opt/SAPAdapter5/version.txt'
#     dir = Facter.value(:pipe_home) || '/home/pipe'
#     [File.join(dir,version_file)
#     ].each do |file|
#         File.open(file) { |openfile| value = openfile.readlines.collect(&:chomp).join('') } if FileTest.file?(file)
#       break if value
#     end
#
#     value
#   end
# end

['ORACLE_BASE', 'ORACLE_HOME', 'TIBCO_HOME', 'JAVA_HOME'].each do |var|
  if ENV[var]
    Facter.add(var.downcase) do
      setcode do
        Facter.value('eip_env_#{var.downcase}') || ENV[var]
      end
    end
  end
end

