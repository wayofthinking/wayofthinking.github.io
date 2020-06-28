# wayofthinking.github.io

The one-page website of [Way of Thinking](http://wayofthinking.net).

## TODO

- Fix problem reported by GSuite Toolbox Check MX tool for wayofthinking.be

  >  There should not be a mail exchanger set up on naked domain name.
  >
  > Presence of mail server on A record of your domain can lead to subtle and hard-to-debug problems with mails 'accidentally' missing in case of DNS problems. You can check this problem yourself by typing
  >
  > telnet your.doma.in 25
  >
  > Normally this SHOULD result in 'Connection refused' message.

- set GitHub Pages custom domain to .be
- extract zone module as Git repo `terraform-ovh-dns` that is used by wayofthinking, thinkinglabs and motheronthepea
  bring `dns/ovh/req_auth_token.sh` under that repo


