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
                status
            from
                users
            where
                session = ?
        ");
        $sth->execute($session);
        ($id, $status) = $sth->fetchrow_array();
        $status ||= 'user';
    }

    $this->manifestChild('session', {
        status => $status,
    }, $session);

    $this->{session} = $session;
    $this->{user} = {
        id => $id,
        status => $status,
    };

    $this->set_header('Set-Cookie', "usession=$session; expires=Wed, 09 Jun 2021 10:18:14 GMT; path=/");
}

1;
