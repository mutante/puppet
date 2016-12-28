# class: parsoid
class parsoid {
    include apt
    include nginx

    apt::source { 'parsoid':
        location => 'https://releases.wikimedia.org/debian',
        release  => 'jessie-mediawiki',
        repos    => 'main',
        key      => {
            'id'     => 'A6FD76E2A61C5566D196D2C090E9F83F22250DD7',
            'server' => 'hkp://keyserver.ubuntu.com:80',
        },
    }

    ssl::cert { 'wildcard.miraheze.org': }

    file { '/etc/nginx/sites-enabled/default':
        ensure  => absent,
        require => Package['nginx'],
    }

    file { '/etc/nginx/nginx.conf':
        ensure  => present,
        content => template('parsoid/nginx.conf.erb'),
        require => Package['nginx'],
    }

    nginx::site { 'parsoid':
        ensure  => present,
        source  => 'puppet:///modules/parsoid/nginx/parsoid',
    }

    package { 'parsoid':
        ensure  => present,
        require => Apt::Source['parsoid'],
    }

    service { 'parsoid':
        ensure    => running,
        require   => Package['parsoid'],
        subscribe => File['/etc/mediawiki/parsoid/settings.js'],
    }

    # The name of the wiki (or the URL in form <wikiname>.miraheze.org. DO NOT INCLUDE WIKI.
    $wikis = [
                '3dic',
                '1209',
                '3dicxyz',
                '8station',
                'aacenterpriselearning',
                'adnovum',
                'aescapes',
                'ageofenlightenment',
                'ageofimperialism',
                'ageofimperialists',
                'air',
                'aktpos',
                'alanpedia',
                'algopedia',
                'allbanks2',
                'alwiki',
                'apneuvereniging',
                'applebranch',
                'arabudland',
                'aryaman',
                'ayrshire',
                'atheneum',
                'augustinianum',
                'aurcusonline',
                'betapurple',
                'betternews',
                'bgo',
                'biblicalwiki',
                'biblio',
                'bmed',
                'braindump',
                'brynda1231',
                'bttest',
                'calexit',
                'cancer',
                'casuarina',
                'cbmedia',
                'cec',
                'chandrusweths',
                'christipedia',
                'ciso',
                'civitas',
                'clementsworldbuilding',
                'clicordi',
                'cnv',
                'corydoctorow',
                'cssandjsschoolboard',
                'cvsmb',
                'cybersecurity',
                'dalar',
                'datachron',
                'detlefs',
                'development',
                'dicfic',
                'dish',
                'dmw',
                'doin',
                'doraemon',
                'drunkenpeasantswiki',
                'dts',
                'easywiki',
                'elainarmua',
                'elements',
                'ernaehrungsrathh',
                'essway',
                'etpo',
                'eva',
                'evelopedia',
                'extload',
                'ezdmf',
                'fablabesds',
                'fbwiki',
                'fishpercolator',
                'fmbv',
                'foodsharinghamburg',
                'frontdesks',
                'ganesha',
                'geirpedia',
                'gen',
                'gnc',
                'grandtheftwiki',
                'gze',
                'hftqms',
                'hobbies',
                'hshsinfoportal',
                'hsooden',
                'hytec',
                'ilearnthings',
                'imsts',
                'inazumaeleven',
                'irc',
                'islamwissenschaft',
                'izanagi',
                'jakepers',
                'janesskillspack',
                'jayuwiki',
                'justinbieber',
                'karniaruthenia',
                'kassai',
                'kinderacic',
                'korach',
                'krebs',
                'kwiki',
                'lancemedical',
                'lbsges',
                'lclwiki',
                'lezar224',
                'lingnlang',
                'littlebigplanet',
                'lizard',
                'lovelivewiki',
                'luckandlogic',
                'lunfeng',
                'maiasongcontest',
                'marcoschriek',
                'menufeed',
                'meregos',
                'meta',
                'mikrodev',
                'mozi',
                'muckhack',
                'musicarchive',
                'musiclibrary',
                'musictabs',
                'mydegree',
                'mylogic',
                'ndn',
                'neuronpedia',
                'newarkmanor',
                'newknowledge',
                'newtrend',
                'nidda23',
                'noalatala',
                'nwp',
                'nvc',
                'ofthevampire',
                'oncproject',
                'openconstitution',
                'opengovpioneers',
                'panorama',
                'paodeaoda',
                'partup',
                'pbm',
                'porp',
                'pflanzen',
                'priyo',
                'prp',
                'pq',
                'pso2',
                'purpanrangueilus',
                'qwerty',
                'rawdata',
                'recherchesdocumentaires',
                'ric',
                'robloxscripters',
                'rocketleaguequebec',
                'rpcharacters',
                'safiria',
                'secondcircle',
                'seldir',
                'seton',
                'shopping',
                'sidem',
                'simonjon',
                'sirikot',
                'sjuhabitat',
                'skyfireflyff',
                'snowthegame',
                'soundbox',
                'soshomophobie',
                'southparkfan',
                'starsetonline',
                'stellachronica',
                'sthomaspri',
                'studynotekr',
                'taylor',
                'tcc6640',
                'techeducation',
                'teleswiki',
                'thefosters',
                'thehushhushsaga',
                'theworld',
                'tme',
                'tochki',
                'torejorg',
                'touhouengine',
                'trex',
                'trump',
                'unikum',
                'urho3d',
                'videogames',
                'vrgo',
                'wabc',
                'walthamstowlabour',
                'webflow',
                'wikibooks',
                'wikicervantes',
                'wikidolphinhansen',
                'wikihoyo',
                'worldbuilding',
                'wthsapgov',
                'xdjibi',
                'xjtlu',
                'yacresources',
                'yggdrasilwiki',
                'yourosongcontest',
                'youtube',
    ]

    file { '/etc/mediawiki/parsoid/settings.js':
        ensure  => present,
        content => template('parsoid/settings.js'),
    }
}
