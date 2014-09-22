package Areno::Localhost::Login;

use strict;
use base 'Areno::Page';
use utf8;

use Datasource;

sub route {
    '/login'
}

sub transform {
    'login'
}

sub run {
    my ($this) = @_;
    
    $this->login();

    $this->contentTextChild('login');
}

sub login {
    my ($this) = @_;

    my $username = $this->param('username');
    my $password = $this->param('password');

    $this->manifestChild('username', {}, $username);

    if ($username && $password) {
        my $sth = get_dbh()->prepare("
            select
                id,
                session
            from
                users
            where
                username = ? and
                password = password(?)
        ");
        $sth->execute($username, $password);
        my ($user_id, $session) = $sth->fetchrow_array();

        unless ($user_id) {
            $this->contentChild('error', {}, 'Неправильный логин или пароль');
        }
        else {
            unless ($session) {
                $session = `/usr/bin/uuid  -v3 ns:URL http://thequestion.ru/`;
                chomp $session;
                $this->{session} = $session;

                my $sth = get_dbh()->prepare("
                    update
                        users
                    set
                        session = ?
                    where
                        id = ?
                ");
                $sth->execute($session, $user_id);
            }
            $this->set_header('Set-Cookie', "session=$session; Expires=Wed, 09 Jun 2021 10:18:14 GMT");

            $this->set_header('Location' => "/all");
            $this->{areno}{http}{status} = 301;
        }
    }
}

__PACKAGE__;
