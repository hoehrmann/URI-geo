use 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'URI::geo',
    VERSION_FROM      => 'lib/URI/geo.pm', # finds $VERSION
    PREREQ_PM         => {
      'Test::More'    =>  0,
      'URI'           =>  0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/URI/geo.pm', # retrieve abstract from module
       AUTHOR         => 'Bjoern Hoehrmann <bjoern@hoehrmann.de>') : ()),

    LICENSE           => 'perl',
    'dist'            => {
      PREOP     => 'chmod 600 Makefile.PL',
      TARFLAGS	=> '--group=cpan --owner=bjoern -cvf',
    },
);
