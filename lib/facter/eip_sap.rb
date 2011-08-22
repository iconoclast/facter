# Fact: eip_sap
#
# Purpose: Return information needed for installing/upgrading the SAP adapter for EnergyIP.
#
# Resolution:
#
#
# Caveats:
#

# this has been merged into eip.rb

## eip_sap.rb
## Facts related to the SAP adapter for EnergyIP
##
# require 'facter'

# Facter.add(:eip_sap_zipfile) do
#   setcode do
#     value = nil
#     filename_glob = 'SAPAdapter*.zip'
#     dir = Facter.value(:pipe_home) || '/home/pipe'

#     candidate = Dir.glob(File.join(dir, filename_glob)).sort.last

#     value = candidate if FileTest.file?(candidate)
#   end
# end

# # todo: dry this
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

#     value
#   end
# end


