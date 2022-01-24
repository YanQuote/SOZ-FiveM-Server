table.insert(migrations, {
    name = "add-concess-storage",
    queries = {
        [[
            CREATE TABLE IF NOT EXISTS `player_vehicles` 
            (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `license` varchar(50) DEFAULT NULL,
                `citizenid` varchar(50) DEFAULT NULL,
                `vehicle` varchar(50) DEFAULT NULL,
                `hash` varchar(50) DEFAULT NULL,
                `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                `plate` varchar(15) NOT NULL,
                `fakeplate` varchar(50) DEFAULT NULL,
                `garage` varchar(50) DEFAULT NULL,
                `fuel` int(11) DEFAULT 100,
                `engine` float DEFAULT 1000,
                `body` float DEFAULT 1000,
                `state` int(11) DEFAULT 1,
                `depotprice` int(11) NOT NULL DEFAULT 0,
                `drivingdistance` int(50) DEFAULT NULL,
                `status` text DEFAULT NULL,
                `balance` int(11) NOT NULL DEFAULT 0,
                `paymentamount` int(11) NOT NULL DEFAULT 0,
                `paymentsleft` int(11) NOT NULL DEFAULT 0,
                `financetime` int(11) NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `plate` (`plate`),
                KEY `citizenid` (`citizenid`),
                KEY `license` (`license`)
            ) ENGINE=InnoDB AUTO_INCREMENT=1;
        ]],
        [[
            ALTER TABLE `player_vehicles`
            ADD UNIQUE INDEX UK_playervehicles_plate (plate);
        ]],
        [[
            ALTER TABLE `player_vehicles`
            ADD CONSTRAINT FK_playervehicles_players FOREIGN KEY (citizenid)
            REFERENCES `players` (citizenid) ON DELETE CASCADE ON UPDATE CASCADE;            
        ]],
        [[
            CREATE TABLE `concess_storage` (
                `model` varchar(50) NOT NULL,
                `stock` int(3) NOT NULL,
                `category` varchar(60) DEFAULT NULL,
                PRIMARY KEY (`model`)
            );
        ]],
        [[
            INSERT INTO `concess_storage` ( model, stock, category) VALUES
            ('blade',6,'Muscle'),
            ('buccaneer',6,'Muscle'),
            ('buccaneer2',6,'Muscle'),
            ('chino',6,'Muscle'),
            ('chino2',6,'Muscle'),
            ('coquette3',6,'Muscle'),
            ('dominator',6,'Muscle'),
            ('dukes',6,'Muscle'),
            ('gauntlet',6,'Muscle'),
            ('hotknife',6,'Muscle'),
            ('faction',6,'Muscle'),
            ('faction2',6,'Muscle'),
            ('nightshade',6,'Muscle'),
            ('phoenix',6,'Muscle'),
            ('picador',6,'Muscle'),
            ('sabregt',6,'Muscle'),
            ('sabregt2',6,'Muscle'),
            ('slamvan3',6,'Muscle'),
            ('tampa',6,'Muscle'),
            ('virgo',6,'Muscle'),
            ('vigero',6,'Muscle'),
            ('voodoo',6,'Muscle'),
            ('blista',6,'Compacts'),
            ('brioso',6,'Compacts'),
            ('issi2',6,'Compacts'),
            ('panto',6,'Compacts'),
            ('prairie',6,'Compacts'),
            ('bison',6,'Vans'),
            ('bobcatxl',6,'Vans'),
            ('burrito3',6,'Vans'),
            ('gburrito2',6,'Vans'),
            ('camper',6,'Vans'),
            ('gburrito',6,'Vans'),
            ('journey',6,'Vans'),
            ('minivan',6,'Vans'),
            ('moonbeam',6,'Vans'),
            ('moonbeam2',6,'Vans'),
            ('paradise',6,'Vans'),
            ('rumpo3',6,'Vans'),
            ('surfer',6,'Vans'),
            ('youga',6,'Vans'),
            ('youga2',6,'Vans'),
            ('asea',6,'Sedans'),
            ('cognoscenti',6,'Sedans'),
            ('emperor',6,'Sedans'),
            ('fugitive',6,'Sedans'),
            ('glendale',6,'Sedans'),
            ('intruder',6,'Sedans'),
            ('premier',6,'Sedans'),
            ('primo2',6,'Sedans'),
            ('regina',6,'Sedans'),
            ('schafter2',6,'Sedans'),
            ('stretch',6,'Sedans'),
            ('superd',6,'Sedans'),
            ('tailgater',6,'Sedans'),
            ('warrener',6,'Sedans'),
            ('washington',6,'Sedans'),
            ('baller2',6,'Suvs'),
            ('baller3',6,'Suvs'),
            ('cavalcade2',6,'Suvs'),
            ('contender',6,'Suvs'),
            ('dubsta',6,'Suvs'),
            ('dubsta2',6,'Suvs'),
            ('fq2',6,'Suvs'),
            ('granger',6,'Suvs'),
            ('gresley',6,'Suvs'),
            ('huntley',6,'Suvs'),
            ('landstalker',6,'Suvs'),
            ('mesa',6,'Suvs'),
            ('mesa3',6,'Suvs'),
            ('patriot',6,'Suvs'),
            ('radi',6,'Suvs'),
            ('rocoto',6,'Suvs'),
            ('seminole',6,'Suvs'),
            ('xls',6,'Suvs'),
            ('btype',6,'Sportsclassics'),
            ('btype3',6,'Sportsclassics'),
            ('btype2',6,'Sportsclassics'),
            ('casco',6,'Sportsclassics'),
            ('coquette2',6,'Sportsclassics'),
            ('manana',6,'Sportsclassics'),
            ('monroe',6,'Sportsclassics'),
            ('pigalle',6,'Sportsclassics'),
            ('stinger',6,'Sportsclassics'),
            ('stingergt',6,'Sportsclassics'),
            ('feltzer3',6,'Sportsclassics'),
            ('ztype',6,'Sportsclassics'),
            ('bifta',6,'Off-road'),
            ('bfinjection',6,'Off-road'),
            ('blazer',6,'Off-road'),
            ('blazer4',6,'Off-road'),
            ('brawler',6,'Off-road'),
            ('dubsta3',6,'Off-road'),
            ('dune',6,'Off-road'),
            ('guardian',6,'Off-road'),
            ('rebel2',6,'Off-road'),
            ('sandking',6,'Off-road'),
            ('monster',6,'Off-road'),
            ('cogcabrio',6,'Coupes'),
            ('exemplar',6,'Coupes'),
            ('f620',6,'Coupes'),
            ('felon',6,'Coupes'),
            ('felon2',6,'Coupes'),
            ('jackal',6,'Coupes'),
            ('oracle2',6,'Coupes'),
            ('sentinel',6,'Coupes'),
            ('sentinel2',6,'Coupes'),
            ('windsor',6,'Coupes'),
            ('windsor2',6,'Coupes'),
            ('zion',6,'Coupes'),
            ('zion2',6,'Coupes'),
            ('AKUMA',6,'Motorcycles'),
            ('avarus',6,'Motorcycles'),
            ('bagger',6,'Motorcycles'),
            ('bati',6,'Motorcycles'),
            ('bati2',6,'Motorcycles'),
            ('bf400',6,'Motorcycles'),
            ('bmx',6,'Motorcycles'),
            ('carbonrs',6,'Motorcycles'),
            ('chimera',6,'Motorcycles'),
            ('cliffhanger',6,'Motorcycles'),
            ('cruiser',6,'Motorcycles'),
            ('daemon',6,'Motorcycles'),
            ('daemon2',6,'Motorcycles'),
            ('defiler',6,'Motorcycles'),
            ('double',6,'Motorcycles'),
            ('enduro',6,'Motorcycles'),
            ('esskey',6,'Motorcycles'),
            ('faggio',6,'Motorcycles'),
            ('faggio2',6,'Motorcycles'),
            ('fixter',6,'Motorcycles'),
            ('gargoyle',6,'Motorcycles'),
            ('hakuchou',6,'Motorcycles'),
            ('hakuchou2',6,'Motorcycles'),
            ('hexer',6,'Motorcycles'),
            ('innovation',6,'Motorcycles'),
            ('manchez',6,'Motorcycles'),
            ('nemesis',6,'Motorcycles'),
            ('nightblade',6,'Motorcycles'),
            ('pcj',6,'Motorcycles'),
            ('ruffian',6,'Motorcycles'),
            ('sanchez',6,'Motorcycles'),
            ('sanchez2',6,'Motorcycles'),
            ('sanctus',6,'Motorcycles'),
            ('scorcher',6,'Motorcycles'),
            ('sovereign',6,'Motorcycles'),
            ('shotaro',6,'Motorcycles'),
            ('thrust',6,'Motorcycles'),
            ('tribike3',6,'Motorcycles'),
            ('vader',6,'Motorcycles'),
            ('vortex',6,'Motorcycles'),
            ('wolfsbane',6,'Motorcycles'),
            ('zombiea',6,'Motorcycles'),
            ('zombieb',6,'Motorcycles'),
            ('blazer5', 6, 'Off-road'),
            ('ruiner2', 6, 'Muscle'),
            ('yosemite', 6, 'Muscle'),
            ('riata', 6, 'Off-road'),
            ('hermes', 6, 'Muscle'),
            ('kamacho', 6, 'Off-road'),
            ('hustler', 6, 'Muscle')
        ;
        ]],
    },
});
