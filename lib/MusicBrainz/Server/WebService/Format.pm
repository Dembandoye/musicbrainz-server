package MusicBrainz::Server::WebService::Format;

use HTTP::Status qw( HTTP_NOT_ACCEPTABLE );
use MooseX::Role::Parameterized;
use REST::Utils qw( best_match );

parameter serializers => (
    is => 'ro',
    isa => 'ArrayRef',
);

role {
    my $role = shift;

    method 'get_serialization' => sub
    {
        my ($self, $c) = @_;

        my @serializers = map {
            Class::MOP::load_class ($_);
            $_->new;
        } @{ $role->serializers };


        my %formats = map { $_->fmt => $_ } @serializers;
        my %accepted = map { $_->mime_type => $_ } @serializers;

        my $fmt = $c->request->parameters->{fmt};

        if (defined $fmt)
        {
            return $formats{$fmt} if $formats{$fmt};
        }
        else
        {
            # Default to application/xml when no accept header is specified.
            # (Picard does this, http://tickets.musicbrainz.org/browse/PICARD-273).
            my $accept = $c->req->header ('Accept') // "application/xml";

            my $match = best_match ([ keys %accepted ], $accept);

            return $accepted{$match} if $match;
        }

        $c->stash->{error} = 'Invalid format. Either set an Accept header'
            . ' (recognized mime types are '. join (' and ', keys %accepted)
            . '), or include a fmt= argument in the query string (valid values'
            . ' for fmt are '. join (' and ', keys %formats) . ').';

        my $ser = $role->serializers->[0];

        $c->res->status(HTTP_NOT_ACCEPTABLE);
        $c->res->content_type($ser->mime_type . '; charset=utf-8');
        $c->res->body($ser->output_error($c->stash->{error}));
        $c->detach();
    };

};

no Moose;
1;

=head1 COPYRIGHT

Copyright (C) 2011 MetaBrainz Foundation

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=cut
