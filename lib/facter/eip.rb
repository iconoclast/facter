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

Facter.add(:pipe_home) do
  setcode do
    ENV['PIPE_HOME'] || ('/home/pipe' if File.directory? '/home/pipe')
  end
end

Facter.add(:eip_version) do
  setcode do
    value = nil
    version_file = 'version.txt'
    dir = Facter.value(:pipe_home) || '/home/pipe'
    [File.join(dir,version_file)
    ].each do |file|
        File.open(file) { |openfile| value = openfile.readlines.collect(&:chomp).join('') } if FileTest.file?(file)
      break if value
    end

    value
  end
end


['ORACLE_BASE', 'ORACLE_HOME', 'TIBCO_HOME', 'JAVA_HOME'].each do |var|
  if ENV[var]
    Facter.add(var.downcase) do
      setcode do
        ENV[var]
      end
    end
  end
end

