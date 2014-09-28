package Areno::Localhost::Go;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    qr{^/of/[A-Z]{11}/?}
}

sub run {
    my ($this) = @_;

    $this->session();

    my ($code) = $this->request_uri() =~ m{^/of/([A-Z]{11})/?};
    my $redirect = '/';
    if ($code) {
        my $sth = get_dbh()->prepare("
            select
                question_id,
                user_id
            from
                asking
            where
                code = ?
        ");
        $sth->execute($code);
        my ($question_id, $user_id) = $sth->fetchrow_array();

        if ($question_id && $user_id) {
            $sth = get_dbh()->prepare("
                select
                    knownas
                from
                    users
                where
                    id = ?
            ");
            $sth->execute($user_id);
            my ($knownas) = $sth->fetchrow_array();

            unless ($knownas) {
                my $r = rand();
                $knownas = `/usr/bin/uuid  -v3 ns:URL http://thequestion.ru/?r=$r`;
                chomp $knownas;

                $sth = get_dbh()->prepare("
                    update
                        users
                    set
                        knownas = ?
                    where
                        id = ?
                ");
                $sth->execute($knownas, $user_id);
            }
            $this->set_header('Set-Cookie' => "knownas=$knownas; expires=Wed, 09 Jun 2021 10:18:14 GMT; path=/");

            $redirect = "/answer?id=$question_id";
        }        
    }

    $this->set_header('Location' => $redirect);
    $this->{areno}{http}{status} = 301;
}

__PACKAGE__;
