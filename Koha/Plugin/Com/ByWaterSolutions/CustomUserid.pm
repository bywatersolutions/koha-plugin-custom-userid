package Koha::Plugin::Com::ByWaterSolutions::CustomUserid;

## It's good practice to use Modern::Perl
use Modern::Perl;

## Required for all plugins
use base qw(Koha::Plugins::Base);

## Here we set our plugin version
our $VERSION = "0.0.0";
our $MINIMUM_VERSION = "{MINIMUM_VERSION}";

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name            => 'Custom Userid Plugin',
    author          => 'Nick Clemens',
    date_authored   => '2025-08-28',
    date_updated    => "1900-01-01",
    minimum_version => $MINIMUM_VERSION,
    maximum_version => undef,
    version         => $VERSION,
    description     => 'This plugin implements a custom '
      . 'userid creation using a template ',
    namespace       => 'customuserid',
};

## This is the minimum code required for a plugin's 'new' method
## More can be added, but none should be removed
sub new {
    my ( $class, $args ) = @_;

    ## We need to add our metadata here so our base class can access it
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    ## Here, we call the 'new' method for our base class
    ## This runs some additional magic and checking
    ## and returns our actual $self
    my $self = $class->SUPER::new($args);

    return $self;
}

## This is the 'install' method. Any database tables or other setup that should
## be done when the plugin if first installed should be executed in this method.
## The installation method should always return true if the installation succeeded
## or false if it failed.
sub install() {
    my ( $self, $args ) = @_;

    return C4::Context->dbh->do( "
	INSERT IGNORE INTO letter (module,code,name,title,content, message_transport_type)
	VALUES
	('members','USERID_TEMPLATE','Custom userid generation template','Custom userid generation template','[% patron.cardnumber %]','print');
    " );
}



sub patron_generate_userid {
    my ($self, $params) = @_;
    my $patron = $params->{patron};
    my $letter = eval {
	C4::Letters::GetPreparedLetter(
	    module                 => 'members',
	    letter_code            => 'USERID_TEMPLATE',
	    message_transport_type => 'print',
	    lang                   => $patron->lang,
	    objects                => {
		patron => $patron,
	    },  
	);  
    };  
    if( $@ ){
	warn "Problem generating custom userid: $@";
    }
    my $desc = $letter ? $letter->{content} : "";
    return $desc;
}
