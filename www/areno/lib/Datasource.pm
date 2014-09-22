package Datasource;

use v5.12;

use DBI;

require Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw(get_dbh);

my $auth_db_hostname = 'localhost';
my $auth_db_port = 3306;
my $auth_db_basename = 'znamo';
my $auth_db_username = 'znamo';
my $auth_db_password = 'znamo';

my $handler = undef;

sub get_dbh {
    my (%args) = @_;

    if (!$handler || !$handler->ping()) {
        $handler = dbconnect(\%args);
    }

    return $handler;
}

sub dbconnect {
    my ($args) = @_;
    
    my $db_basename = $auth_db_basename;

    my $conn_str = "dbi:mysql";
    if ($ENV{DBI_REDEFINE_HOST_PORT}) { # like '127.0.0.1:6033'
        $conn_str .= ":$db_basename:$ENV{DBI_REDEFINE_HOST_PORT}";
        say STDERR "info: found DBI_REDEFINE_HOST_PORT: connect to $conn_str"; 
    }
    else {
        $conn_str .= ":$db_basename:$auth_db_hostname:$auth_db_port";
    }

    return DBI->connect($conn_str, $auth_db_username, $auth_db_password);
}

END {
    $handler->disconnect() if $handler;
}

1;
