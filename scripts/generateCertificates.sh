#!/bin/bash

#find repository's root directory.
rootDir=`pwd`
while [ ! "$rootDir" == "/" ] && [ ! -d "$rootDir"/.git ]; do
  cd ..
  rootDir=`pwd`
done

if [ "$rootDir" == "/" ]
then
  echo 'Could not find git root directory. Run this from within the git repository.';
  exit 1;
fi

cd "$rootDir"

# generate a key+certificate
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 3650





if [ $? -eq 0 ]
then
  # ensure it is stripped of its password for now.
  openssl rsa -in key.pem -out newkey.pem && mv newkey.pem key.pem

  # convert to .cer for iOS
  openssl x509 -in cert.pem -outform der -out cert.cer

  # move files where apps need them
  mv './cert.pem' './server/config/certificates/cert.pem';
  mv './key.pem' './server/config/certificates/key.pem';
  mv './cert.cer' './ios/bb8-band-ios/cert.cer'
else
  echo 'we did not generate a key/certificate. aborting.'
  exit 2;
fi
