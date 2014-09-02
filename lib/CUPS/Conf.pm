package CUPS::Conf;
#
# This program will maintain the printers that are with Block state.
#
# Author: Tácito Chaves - 2014-08-21
# e-mail: chaves@tchaves.com.br
# skype: tacito.chaves

# creates the new method
sub new {
    my $class = shift;

    return bless { _config => {}, }, $class;
}

sub config {
    return $_[0]->{_config}->{ $_[1] } if $_[1];
    return $_[0]->{_config};
}

# ready file
sub read {
    my ( $self, $file ) = @_;

    open my $file_fh, '<', $file or die "File reader error: $! \n";
    $self->_parse($file_fh);
    close $file_fh;

    $self;
}

# parse data
sub _parse {
    my ( $self, $fh ) = @_;

    my $_block;
    while (<$fh>) {
        chomp;
        my $line = $_;

        # block start
        if ( $line =~ /^\s*<Printer (.[^>]*)>/ ) {
            $_block = $1;
            next;
        }

        # block end
        if ( $line =~ /^\s*<\/Printer>/ ) {
            $_block = undef;
            next;
        }

        # parse config
        if ( $line =~ /^\s*([\w]*)\s+(.*)$/ ) {
            my ( $key, $value ) = ( $1, $2 );
            $self->config->{$_block}->{$key} = $value;
        }
    }
}

# create log file
sub log_file {
    my ( $self, $file, $date ) = @_;
    open( LOG, ">>", "/tmp/cups.log" ) or die "File not found!\n";
    print LOG "Impressora " . $file . " esta Block - $date\n";
    close(LOG);
}

# enableding the pses
sub pses_enable {
    my ( $self, $printers ) = @_;
    open( CUPS, "/usr/sbin/cupsenable $printers |" )
      or die "Error: Could not find the printer\n";
    close(CUPS);
}

1;
