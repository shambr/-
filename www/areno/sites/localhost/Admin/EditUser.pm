package Areno::Localhost::Admin::EditUser;

use v5.12;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/admin/edituser'
}

sub transform {
    'admin/edituser'
}

sub run {
    my ($this) = @_;

    $this->session();

    if ($this->{user}{status} eq 'moderator') {
        $this->edituser();
    }
}

sub edituser {
    my ($this) = @_;

    my ($id) = $this->param('id') =~ /^(\d+)$/a;

    if ($id) {
        $this->getuser($id);

        if ($this->param('submit') ne '') {
            $this->updateuser($id);

            $this->set_header('Location' => "/admin/users");
            $this->{areno}{http}{status} = 301;
        }
    }
}

sub getuser {
    my ($this, $id) = @_;

    my $sth = get_dbh()->prepare("
        select
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
        where
            id = ?
    ");
    $sth->execute($id);

    my ($firstname, $lastname, $username, $email, $created, $createdby, $occupation, $status, $phone, $skype, $tags) = $sth->fetchrow_array();
    $this->contentChild('user', {
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

sub updateuser {
    my ($this, $id) = @_;

    my @fields = qw(
        firstname
        lastname
        username
        occupation
        email
        phone
        skype
        tags
        status
    );
    my %data = map {$_ => $this->param($_) || ''} @fields;

    my $sth = get_dbh()->prepare("
        update users
        set
            firstname = ?,
            lastname = ?,
            username = ?,
            occupation = ?,
            email = ?,
            phone = ?,
            skype = ?,
            tags = ?,
            status = ?
        where
            id = ?
    ");
    $sth->execute($data{firstname}, $data{lastname}, $data{username}, $data{occupation}, $data{email}, $data{phone}, 
                  $data{skype}, $data{tags}, $data{status}, $id);


    my $password = $this->param('password');
    if ($password) {
        my $sth = get_dbh()->prepare("
            update users
            set
                password = password(?)
            where
                id = ?
        ");
        $sth->execute($password, $id);
    }
}

__PACKAGE__;
