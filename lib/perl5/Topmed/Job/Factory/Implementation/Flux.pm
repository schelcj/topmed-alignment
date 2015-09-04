package Topmed::Job::Factory::Implementation::Flux;

use Topmed::Base qw(www);
use Topmed::Config;
use Topmed::Util qw(:parsers);

use Moose;

has 'job_id' => (is => 'ro', isa => 'Int', required => 1);
has '_logstash_url' => (is => 'ro', isa => 'Str', lazy => 1, builder => '_build__logstash_url');

sub _build__logstash_url {
  my ($self) = @_;

  my $now = DateTime->now();
  my $uri = URI->new(sprintf $FLUX_KIBANA_URL_FMT, $now->year);
  $uri->query_form(
    {
      q      => 'jobid:' . $self->job_id,
      fields => 'resources_used.walltime',
    }
  );

  return $uri->as_string;
}

sub elapsed {
  my ($self) = @_;

  my $ua       = Mojo::UserAgent->new();
  my $stash    = $ua->get($self->_logstash_url)->res->json;
  my $walltime = $stash->{hits}->{hits}->[2]->{fields}->{'resources_used.walltime'}->[0];

  return parse_time($walltime);
}

sub state {
  my ($self) = @_;
  my $cmd = sprintf $JOB_STATE_CMD_FORMAT{flux}, $self->job_id;
  chomp(my $state = capture(EXIT_ANY, $cmd));
  return $JOB_STATES{$state};
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;