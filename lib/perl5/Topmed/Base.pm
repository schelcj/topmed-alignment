package Topmed::Base;

use base qw(Import::Base);

our @IMPORT_MODULES = (
  'FindBin' => [qw($Bin)],
  'English' => [qw(-no_match_vars)],
  'Carp'    => [qw(confess)],
  'Modern::Perl',
  'Cache::File',
  'Data::Dumper',
  'System::Command',
  'Readonly',
  'File::Slurp::Tiny' => [qw(read_file read_lines)],
  'File::Spec',
);

our %IMPORT_BUNDLES = (
  db => [
    'Topmed::DB'
  ]
);

1;
