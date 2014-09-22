package Areno::Localhost::Sort;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/sort'
}

sub run {
    my ($this) = @_;

    $this->session();

    if ($this->{user}{status} eq 'moderator') {
        $this->sort_questions();
    }
}

sub sort_questions {
    my ($this) = @_;

    my ($ids) = $this->param('ids');
    my @ids = grep {/^(\d+)$/a} split /,/, $ids;

    return unless @ids;

    my $order_id = scalar @ids;
    for (my $c = 0; $c != scalar @ids; $c++) {

        my $sth = get_dbh()->prepare("
            update
                questions
            set
                order_id = ?
            where
                id = ?
        ");
        $sth->execute($order_id, $ids[$c]);

        $order_id--
    }

    my $in_ids = join ',', @ids;
    get_dbh()->do("
        update
            questions
        set
            order_id = 0
        where
            id not in ($in_ids)
    ");
}

__PACKAGE__;
