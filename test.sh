#!/bin/sh

cat >foo <<EOF
%echo Generating a basic OpenPGP key
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Taylor Monacelli
Name-Comment: with stupid passphrase
Name-Email: tailor@u.washington.edu
Expire-Date: 2
Passphrase: abc
%pubring foo.pub
%secring foo.sec
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

gpg2 --batch --gen-key foo
gpg2 --no-default-keyring --secret-keyring ./foo.sec --keyring ./foo.pub --list-secret-keys
