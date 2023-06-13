package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Size::DisplayResolution;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;
with 'TableDataRole::Source::AOA';

around new => sub {
    require Display::Resolution;

    my $orig = shift;

    my $res = Display::Resolution::list_display_resolution_names();
    die "Can't list display resolution sizes from Display::Resolution: $res->[0] - $res->[1]"
        unless $res->[0] == 200;

    my $aoa = [];
    my $column_names = [qw/
                              name
                              size
                              width
                              height
                          /];
    for my $name (sort keys %{ $res->[2] }) {
        my $size = $res->[2]{$name};
        my ($width, $height) = $size =~ /\A(\d+)x(\d+)\z/
            or die "Invalid size syntax for '$name': $size (not in WxH format)";
        push @$aoa, [
            $name,
            $size,
            $width,
            $height,
        ];
    }

    $orig->(@_, aoa => $aoa, column_names=>$column_names);
};

package TableData::Size::DisplayResolution;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Size::DisplayResolution';

# STATS

1;
# ABSTRACT: Display resolution sizes

=head1 DESCRIPTION

This table gets its data dynamically by querying
L<Display::Resolution>, so this is basically just a L<TableData>
interface for C<Display::Resolution>.
