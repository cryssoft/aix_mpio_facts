#
#  FACT(S):     aix_mpio
#
#  PURPOSE:     This custom fact returns a hash of "lsmpio -q" output with
#		disk->name and name->disk components.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        March 15, 2021
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#		NEVER FORGET!  "\n" and '\n' are not the same in Ruby!
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_mpio) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define a mostly empty hash to return
    l_aixMPIO = {}
    l_aixMPIO['by_disk'] = {}
    l_aixMPIO['by_name'] = {}

    #  Do the work
    setcode do
        #  Run the command to look through the process list for the Tidal daemon
        l_lines = Facter::Util::Resolution.exec('/bin/lsmpio -q 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Strip leading and trailing whitespace and split on any whitespace
            l_list = l_oneLine.strip().split()

            #  If this is an hdisk# device, take the data for it
            if (l_list[0].match(/hdisk/))
                l_aixMPIO['by_disk'][l_list[0]] = l_list[4]
                l_aixMPIO['by_name'][l_list[4]] = l_list[0]
            end
        end

        #  Implicitly return the contents of the variable
        l_aixMPIO
    end
end
