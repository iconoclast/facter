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

Facter.add(:eip) do
  setcode do
    value = nil
    ["/home/pipe/version.txt",
    ].each do |file|
        File.open(file) { |openfile| value = openfile.readlines.collect(&:chomp).join('') } if FileTest.file?(file)
      break if value
    end

    value
  end
end
