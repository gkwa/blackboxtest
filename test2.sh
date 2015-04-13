#!/bin/sh

set -x


export PATH=`pwd`/blackbox/bin:$PATH




topdir=`pwd`


rm -rf repo



mkdir repo
cd $topdir/repo
git init
echo test >test.txt
git add test.txt
git commit -m test
echo yes | blackbox_initialize
chmod -R 700 keyrings
git commit -m'INITIALIZE BLACKBOX' keyrings .gitignore



cd $topdir/repo/keyrings/live

cat >foo <<EOF
%echo Generating a basic OpenPGP key
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Taylor Monacelli
Name-Comment: with stupid passphrase
Name-Email: tailor@u.washington.edu
Expire-Date: 1
Passphrase: abc
%pubring pubring.gpg
%secring secring.gpg
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

rm -rf /Users/demo/.gnupg

cd $topdir/repo
gpg2 --homedir=$topdir/repo/keyrings/live --batch --gen-key foo
test -d /Users/demo/.gnupg && echo /Users/demo/.gnupg exists && exit 1
gpg2 --homedir=keyrings/live --no-default-keyring --secret-keyring ./secring.gpg --keyring ./pubring.gpg --list-secret-keys
test -d /Users/demo/.gnupg && echo /Users/demo/.gnupg exists && exit 1

blackbox_addadmin tailor@u.washington.edu $topdir/repo/keyrings/live

# blackbox_addadmin tailor@u.washington.edu
git add keyrings/live/pubring.gpg
git add keyrings/live/trustdb.gpg
git add keyrings/live/blackbox-admins.txt

git commit -m'NEW ADMIN: tailor@u.washington.edu'


cd $topdir/repo
gpg2 --homedir=keyrings/live --list-keys


eval $(gpg-agent --homedir=keyrings/live --daemon)


gpg2 --homedir=keyrings/live --list-keys

cd $topdir/repo
rm -f foo.txt.gpg foo.txt
echo This is a test. >foo.txt
test -d /Users/demo/.gnupg && echo /Users/demo/.gnupg exists && exit 1
blackbox_register_new_file foo.txt

test -d /Users/demo/.gnupg && echo /Users/demo/.gnupg exists && exit 1
blackbox_register_new_file $topdir/repo/foo.txt  $topdir/repo/keyrings/live
test -d /Users/demo/.gnupg && echo /Users/demo/.gnupg exists && exit 1

# blackbox_register_new_file foo.txt

blackbox_edit_start foo.txt.gpg $topdir/repo/keyrings/live
cat foo.txt
echo This is the new file contents. >foo.txt
