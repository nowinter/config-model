
$model_to_test = "Multistrap";

$from_scratch_file = <<'EOF' ,
## This file was written by Config::Model
## You may modify the content of this file. Configuration 
## modifications will be preserved. Modifications in
## comments may be mangled.

[general]
include=/usr/share/multistrap/crosschroot.conf
EOF

@tests = (
    {
        name        => 'arm',
        config_file => '/home/foo/my_arm.conf',
        check       => {
                'sections:toolchains packages:0' ,'g++-4.2-arm-linux-gnu',
                'sections:toolchains packages:1', 'linux-libc-dev-arm-cross',
            },
        load_warnings => [] , # some weird warnings pop up in Perl smoke tests with perl 5.15.9
    },
    {
        name => 'from_scratch',
        config_file => '/home/foo/my_arm.conf',
        load => "include=/usr/share/multistrap/crosschroot.conf" ,

        check => {

            # values brought by included file
            'sections:debian packages:0', {qw/mode layered value dpkg-dev/},
            'sections:base packages:0',   {qw/mode layered value gcc-4.2-base/},

            'sections:toolchains packages:0', undef,
            'sections:toolchains packages:1', undef,
          },
        file_check_sub => sub { 
            my $r = shift ; 
            # this file was created after the load instructions above
            unshift @$r, "/home/foo/my_arm.conf";
        },
        file_content => { 
            "/home/foo/my_arm.conf" => $from_scratch_file ,
        }
    },
    {
        name => 'igep0020',
        config_file => '/home/foo/strap-igep0020.conf',
    },
);

1;
