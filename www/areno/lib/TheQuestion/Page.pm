package TheQuestion::Page;

use base 'Areno::Page';

use Datasource;

sub session {
    my ($this) = @_;

    my ($id, $status) = (0, 'guest');
    my $session = $this->cookie('usession');

    unless ($session) {
        for (0..20) {
            $session .= chr(int(rand(25) + 65));
        }
    }
    else {
        my $sth = get_dbh()->prepare("
            select
                id,
                status,
                firstname,
                lastname
            from
                users
            where
                session = ?
        ");
        $sth->execute($session);
        ($id, $status, $firstname, $lastname) = $sth->fetchrow_array();
        $status ||= 'user';
    }

    $this->manifestChild('session', {
        id => $id,
        status => $status,
        firstname => $firstname,
        lastname => $lastname,
    }, $session);

    $this->{session} = $session;
    $this->{user} = {
        id => $id,
        status => $status,
    };

    $this->set_header('Set-Cookie', "usession=$session; expires=Wed, 09 Jun 2021 10:18:14 GMT; path=/");
}

sub get_users {
    my ($this) = @_;

    my $sth = get_dbh()->prepare("
        select
            id,
            firstname,
            lastname
        from
            users
    ");
    $sth->execute();

    my %data;
    while (my ($id, $firstname, $lastname) = $sth->fetchrow_array()) {
        $data{$id} = [$firstname, $lastname];
    }

    my $usersNode = $this->contentChild('users');

    for my $id (sort {$data{$_}[1]} keys %data) {
        my ($firstname, $lastname) = @{$data{$id}};

        $this->newItem($usersNode, {
            id => $id,
            firstname => $firstname,
            lastname => $lastname,
        });
    }
}

sub get_name {
    my ($this, $user_id) = @_;

    my $sth = get_dbh()->prepare("
        select
            firstname,
            lastname
        from
            users
        where
            id = ?
    ");
    $sth->execute($user_id);
    my ($firstname, $lastname) = $sth->fetchrow_array();

    return "$firstname $lastname"; 
}

1;
