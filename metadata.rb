name             'svc'
maintainer       'John Ko'
maintainer_email 'git@johnko.ca'
license          'Apache 2.0'
description      'Manages FreeBSD services'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe           'svc', 'Manages FreeBSD services'

%w(freebsd).each do |os|
  supports os
end
