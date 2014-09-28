package Areno::Localhost::Admin::AddUser;

use v5.12;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/admin/adduser'
}

sub transform {
    'admin/adduser'
}

sub run {
    my ($this) = @_;

    $this->session();

    if ($this->{user}{status} eq 'moderator') {
        $this->adduser();
    }
}

sub adduser {
    my ($this) = @_;

    $this->contentChild('add-user');

    if ($this->param('submit') ne '') {
        $this->createuser();

        $this->set_header('Location' => "/admin/users");
        $this->{areno}{http}{status} = 301;
    }
}

sub createuser {
    my ($this) = @_;

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
        password
    );
    my %data = map {$_ => $this->param($_) || ''} @fields;


    my $sth = get_dbh()->prepare("
        insert into
            users
                (firstname, lastname, username, occupation, email, phone, skype, tags, status, created, createdby, password)
            values
                (?, ?, ?, ?, ?, ?, ?, ?, ?, now(), ?, password(?))
    ");
    $sth->execute($data{firstname}, $data{lastname}, $data{username}, $data{occupation}, $data{email}, $data{phone}, 
                  $data{skype}, $data{tags}, $data{status}, $this->{user}{id}, $data{password});
}

__PACKAGE__;
