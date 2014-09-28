package Areno::Localhost::Admin::Users;

use v5.12;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/admin/users'
}

sub transform {
    'admin/users'
}

sub run {
    my ($this) = @_;

    $this->session();

    if ($this->{user}{status} eq 'moderator') {
        $this->users();
    }
}

sub users {
    my ($this) = @_;

    my $usersNode = $this->contentChild('users');

    my $sth = get_dbh()->prepare("
        select
            id,
            firstname,
            lastname,
            username,
            email,
            created,
            createdby,
            occupation,
            status,
            phone,
            skype,
            tags
        from
            users
        order by
            id desc
    ");
    $sth->execute();

    while (my ($id, $firstname, $lastname, $username, $email, $created, $createdby, $occupation, $status, $phone, $skype, $tags) = $sth->fetchrow_array()) {
        $this->newItem($usersNode, {
            id => $id,
            firstname => $firstname,
            lastname => $lastname,
            username => $username,
            email => $email,
            created => $created,
            createdby => $createdby,
            occupation => $occupation,
            status => $status,
            phone => $phone,
            skype => $skype,
            tags => $tags,
        });
    }
}

__PACKAGE__;
