-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Dec 07. 02:06
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `server`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `chat_permissions`
--

CREATE TABLE `chat_permissions` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `chat_permissions`
--

INSERT INTO `chat_permissions` (`id`, `userId`, `type`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `log_event_jpb`
--

CREATE TABLE `log_event_jpb` (
  `id` int(11) NOT NULL,
  `players` text NOT NULL,
  `finalists` text NOT NULL,
  `winner_id` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `log_event_jpb`
--

INSERT INTO `log_event_jpb` (`id`, `players`, `finalists`, `winner_id`, `start_date`, `end_date`) VALUES
(1, '[1]', '[]', 1, '2025-11-25 02:09:04', '2025-11-25 02:09:07'),
(2, '[1,2,3]', '[1,3]', 3, '2025-11-30 03:38:59', '2025-11-30 03:41:08');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `log_player_kills`
--

CREATE TABLE `log_player_kills` (
  `id` int(11) NOT NULL,
  `killer_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `pushing` tinyint(1) NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `log_player_kills`
--

INSERT INTO `log_player_kills` (`id`, `killer_id`, `target_id`, `pushing`, `date_added`) VALUES
(1, 1, 3, 0, '2025-11-20 08:45:56'),
(2, 3, 1, 0, '2025-11-20 08:46:52'),
(3, 1, 3, 0, '2025-11-20 08:47:07'),
(4, 3, 1, 0, '2025-11-29 23:39:44'),
(5, 3, 1, 0, '2025-11-29 23:42:28'),
(6, 3, 1, 0, '2025-11-30 00:09:30'),
(7, 1, 2, 0, '2025-11-30 00:12:32'),
(8, 1, 3, 0, '2025-11-30 00:12:40'),
(9, 2, 3, 0, '2025-11-30 02:35:53'),
(10, 1, 2, 0, '2025-11-30 02:36:18'),
(11, 1, 3, 0, '2025-11-30 02:36:38'),
(12, 3, 1, 0, '2025-11-30 02:41:08'),
(13, 2, 1, 0, '2025-11-30 02:47:39'),
(14, 2, 1, 0, '2025-11-30 02:48:25'),
(15, 1, 3, 0, '2025-11-30 03:49:36');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `player_accounts`
--

CREATE TABLE `player_accounts` (
  `userId` bigint(20) NOT NULL,
  `sessionId` varchar(32) NOT NULL,
  `data` text NOT NULL DEFAULT '{"uridium":0,"credits":0,"honor":0,"experience":0,"jackpot":0}',
  `bootyKeys` text NOT NULL DEFAULT '{"greenKeys": 0, "redKeys": 0, "blueKeys": 0}',
  `info` text NOT NULL,
  `destructions` text NOT NULL DEFAULT '{"fpd":0,"dbrz":0}',
  `username` varchar(20) NOT NULL,
  `pilotName` varchar(20) NOT NULL,
  `petName` varchar(20) NOT NULL DEFAULT 'P.E.T 15',
  `password` varchar(255) NOT NULL,
  `email` varchar(260) NOT NULL,
  `shipId` int(11) NOT NULL DEFAULT 10,
  `premium` tinyint(1) NOT NULL DEFAULT 0,
  `title` varchar(128) NOT NULL DEFAULT '',
  `factionId` int(1) NOT NULL DEFAULT 0,
  `clanId` int(11) NOT NULL DEFAULT 0,
  `rankId` int(2) NOT NULL DEFAULT 1,
  `rankPoints` bigint(20) NOT NULL DEFAULT 0,
  `rank` int(11) NOT NULL DEFAULT 0,
  `warPoints` bigint(20) NOT NULL DEFAULT 0,
  `warRank` int(11) DEFAULT 0,
  `extraEnergy` int(11) NOT NULL DEFAULT 0,
  `nanohull` int(11) NOT NULL DEFAULT 0,
  `verification` text NOT NULL,
  `oldPilotNames` text NOT NULL DEFAULT '[]',
  `version` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `player_accounts`
--

INSERT INTO `player_accounts` (`userId`, `sessionId`, `data`, `bootyKeys`, `info`, `destructions`, `username`, `pilotName`, `petName`, `password`, `email`, `shipId`, `premium`, `title`, `factionId`, `clanId`, `rankId`, `rankPoints`, `rank`, `warPoints`, `warRank`, `extraEnergy`, `nanohull`, `verification`, `oldPilotNames`, `version`) VALUES
(1, 'NL8sdrGQohgkhQgdPysnZyv6JQNnnm4c', '{\"uridium\":1116166438,\"credits\":380320833,\"honor\":7738639,\"experience\":15114648,\"jackpot\":0}', '{\"greenKeys\": 0, \"redKeys\": 0, \"blueKeys\": 0}', '{\"lastIP\":\"::1\",\"registerIP\":\"::1\",\"registerDate\":\"15.11.2025 18:40:18\"}', '{\"fpd\":0,\"dbrz\":1}', 'Admin', 'ツŅΣM_ЈŌツ', 'Csak a kristály', '$2y$10$dRjvmRXpJBu4if5AJuzp3Oqsz285pNUlRxAH6SY4/LsR5Daq/DpRC', 'Admin@do.com', 66, 30, 'Pusztuljon_a_piru', 3, 1, 20, 79856, 1, 475, 1, 0, 0, '{\"verified\":true,\"hash\":\"Doc3SElKx1BteZx17i4MdjRM582mYiX6\"}', '[{\"name\":\"Admin\",\"date\":\"20.11.2025 09:56:17\"}]', 1),
(2, 'YNlW6knzkLACFLcG7N3xXiviwq37W4Ss', '{\"uridium\":110911534,\"credits\":11111110,\"honor\":1688,\"experience\":152400,\"jackpot\":0}', '{\"greenKeys\": 0, \"redKeys\": 0, \"blueKeys\": 0}', '{\"lastIP\":\"::1\",\"registerIP\":\"::1\",\"registerDate\":\"15.11.2025 18:40:47\"}', '{\"fpd\":0,\"dbrz\":1}', 'NEM_JO', 'NEM_JO', 'Marlboro', '$2y$10$2Bsk2tOHh6gpVAa3rEeN2eTHXmV6cJU9ZbbsH2s9HW59ZQL.Cqqn.', 'nem_jo@do.com', 10, 0, '1v1zsido', 1, 0, 20, 1640, 3, 225, 3, 0, 0, '{\"verified\":true,\"hash\":\"mVBLi5eqv9kkWj6cmXpMkZVqkbVZzvm9\"}', '[]', 1),
(3, '8O7NCfEiRxoKTWQpBEk4gJLthwtInHAV', '{\"uridium\":920963,\"credits\":1070355,\"honor\":27367,\"experience\":2781600,\"jackpot\":0}', '{\"greenKeys\": 0, \"redKeys\": 0, \"blueKeys\": 0}', '{\"lastIP\":\"127.0.0.1\",\"registerIP\":\"127.0.0.1\",\"registerDate\":\"20.11.2025 08:44:07\"}', '{\"fpd\":0,\"dbrz\":0}', 'Test2', 'NEM_JÓ', 'Elnézést!', '$2y$10$4mVcCy5t0qTCCT./d7.YxOM02S.uX9tabhBJu5WHreKDpIfNBjVPW', 'test@test.com', 49, 1, 'title_jackpot_battle_winner', 2, 1, 20, 6293, 2, 350, 2, 0, 0, '{\"verified\":true,\"hash\":\"G0xbrcfkAG4LQVxwkd40PLGCOmqEL7UC\"}', '[{\"name\":\"Test2\",\"date\":\"20.11.2025 09:50:04\"}]', 1),
(4, 'igsFPOI8V0gUzwYjiYAjJxozgDwu6DVa', '{\"uridium\":4950000,\"credits\":555550,\"honor\":0,\"experience\":0,\"jackpot\":0}', '{\"greenKeys\": 0, \"redKeys\": 0, \"blueKeys\": 0}', '{\"lastIP\":\"127.0.0.1\",\"registerIP\":\"127.0.0.1\",\"registerDate\":\"01.12.2025 05:19:51\"}', '{\"fpd\":0,\"dbrz\":0}', 'asdf', 'asdf', 'P.E.T 15asd', '$2y$10$Ns1EnIKSCJpZ18yp3KMwMeMruLRwbn11BcYwTZe6JqBhhhbMCU7mK', 'asd@asd.com', 10, 0, '', 2, 0, 19, 1130, 4, 0, 0, 0, 0, '{\"verified\":true,\"hash\":\"xRkkuuTwKbLfsaYxlLh8Lk8TOab4MZov\"}', '[]', 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `player_equipment`
--

CREATE TABLE `player_equipment` (
  `userId` int(11) NOT NULL,
  `config1_lasers` text NOT NULL DEFAULT '[]',
  `config1_generators` text NOT NULL DEFAULT '[]',
  `config1_drones` text NOT NULL DEFAULT '[{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]}]',
  `config2_lasers` text NOT NULL DEFAULT '[]',
  `config2_generators` text NOT NULL DEFAULT '[]',
  `config2_drones` text NOT NULL DEFAULT '[{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]},{"items":[],"designs":[]}]',
  `items` text NOT NULL DEFAULT '{"lf4Count":0,"havocCount":0,"herculesCount":0,"apis":false,"zeus":false,"pet":false,"petModules":[],"ships":[],"designs":{},"skillTree":{"logdisks":0,"researchPoints":0,"resetCount":0}}',
  `skill_points` text NOT NULL DEFAULT '{"engineering":0,"shieldEngineering":0,"detonation1":0,"detonation2":0,"heatseekingMissiles":0,"rocketFusion":0,"cruelty1":0,"cruelty2":0,"explosives":0,"luck1":0,"luck2":0}',
  `modules` longtext NOT NULL DEFAULT '[]',
  `boosters` longtext NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `player_equipment`
--

INSERT INTO `player_equipment` (`userId`, `config1_lasers`, `config1_generators`, `config1_drones`, `config2_lasers`, `config2_generators`, `config2_drones`, `items`, `skill_points`, `modules`, `boosters`) VALUES
(1, '[\"140\",\"141\",\"142\",\"143\",\"144\",\"145\",\"146\",\"147\",\"148\",\"149\",\"150\",\"151\",\"152\",\"153\",\"154\"]', '[\"100\",\"101\",\"102\",\"103\",\"104\",\"105\",\"106\",\"107\",\"108\",\"109\",\"110\",\"111\",\"112\",\"113\",\"114\"]', '[{\"items\":[\"184\",\"183\"],\"designs\":[\"129\"]},{\"items\":[\"182\",\"181\"],\"designs\":[\"128\"]},{\"items\":[\"180\",\"179\"],\"designs\":[\"127\"]},{\"items\":[\"178\",\"177\"],\"designs\":[\"126\"]},{\"items\":[\"176\",\"175\"],\"designs\":[\"125\"]},{\"items\":[\"174\",\"173\"],\"designs\":[\"124\"]},{\"items\":[\"172\",\"171\"],\"designs\":[\"123\"]},{\"items\":[\"170\",\"169\"],\"designs\":[\"122\"]},{\"items\":[\"168\",\"167\"],\"designs\":[\"121\"]},{\"items\":[\"166\",\"165\"],\"designs\":[\"120\"]}]', '[\"140\",\"141\",\"142\",\"143\",\"144\",\"145\",\"146\",\"147\",\"148\",\"149\",\"150\",\"151\",\"152\",\"153\",\"154\"]', '[\"40\",\"41\",\"42\",\"43\",\"44\",\"45\",\"46\",\"47\",\"48\",\"49\",\"50\",\"51\",\"52\",\"53\",\"54\"]', '[{\"items\":[\"184\",\"183\"],\"designs\":[\"139\"]},{\"items\":[\"182\",\"181\"],\"designs\":[\"138\"]},{\"items\":[\"180\",\"179\"],\"designs\":[\"137\"]},{\"items\":[\"178\",\"177\"],\"designs\":[\"136\"]},{\"items\":[\"176\",\"175\"],\"designs\":[\"135\"]},{\"items\":[\"174\",\"173\"],\"designs\":[\"134\"]},{\"items\":[\"172\",\"171\"],\"designs\":[\"133\"]},{\"items\":[\"170\",\"169\"],\"designs\":[\"132\"]},{\"items\":[\"168\",\"167\"],\"designs\":[\"131\"]},{\"items\":[\"166\",\"165\"],\"designs\":[\"130\"]}]', '{\"lf4Count\":45,\"havocCount\":10,\"herculesCount\":10,\"apis\":true,\"zeus\":true,\"pet\":true,\"petModules\":[],\"ships\":[49,70,69],\"designs\":{},\"skillTree\":{\"logdisks\":65967,\"researchPoints\":0,\"resetCount\":0}}', '{\"engineering\":5,\"shieldEngineering\":5,\"detonation1\":2,\"detonation2\":3,\"heatseekingMissiles\":5,\"rocketFusion\":5,\"cruelty1\":2,\"cruelty2\":3,\"explosives\":5,\"luck1\":2,\"luck2\":3}', '[]', '{\"2\":[{\"Type\":1,\"Seconds\":20250},{\"Type\":0,\"Seconds\":20265}],\"1\":[{\"Type\":5,\"Seconds\":20280},{\"Type\":6,\"Seconds\":20285},{\"Type\":7,\"Seconds\":20290}],\"7\":[{\"Type\":8,\"Seconds\":20290},{\"Type\":9,\"Seconds\":20295}],\"4\":[{\"Type\":10,\"Seconds\":20300},{\"Type\":11,\"Seconds\":20305},{\"Type\":12,\"Seconds\":20310}]}'),
(2, '[\"140\",\"141\",\"142\",\"143\",\"144\",\"145\",\"146\",\"147\",\"148\",\"149\",\"150\",\"151\",\"152\",\"153\",\"154\"]', '[\"78\",\"40\",\"41\",\"42\",\"43\",\"44\",\"45\",\"46\",\"47\",\"48\",\"49\",\"50\",\"51\",\"52\",\"53\"]', '[{\"items\":[\"99\",\"98\"],\"designs\":[\"139\"]},{\"items\":[\"97\",\"96\"],\"designs\":[\"138\"]},{\"items\":[\"95\",\"94\"],\"designs\":[\"137\"]},{\"items\":[\"93\",\"92\"],\"designs\":[\"136\"]},{\"items\":[\"91\",\"90\"],\"designs\":[\"135\"]},{\"items\":[\"89\",\"88\"],\"designs\":[\"134\"]},{\"items\":[\"87\",\"86\"],\"designs\":[\"133\"]},{\"items\":[\"85\",\"84\"],\"designs\":[\"132\"]},{\"items\":[\"83\",\"82\"],\"designs\":[\"131\"]},{\"items\":[\"81\",\"80\"],\"designs\":[\"130\"]}]', '[\"140\",\"141\",\"142\",\"143\",\"144\",\"145\",\"146\",\"147\",\"148\",\"149\",\"150\",\"151\",\"152\",\"153\",\"154\"]', '[\"100\",\"101\",\"102\",\"103\",\"104\",\"105\",\"106\",\"107\",\"108\",\"109\",\"110\",\"111\",\"112\",\"113\",\"114\"]', '[{\"items\":[\"184\",\"183\"],\"designs\":[\"129\"]},{\"items\":[\"182\",\"181\"],\"designs\":[\"128\"]},{\"items\":[\"180\",\"179\"],\"designs\":[\"127\"]},{\"items\":[\"178\",\"177\"],\"designs\":[\"126\"]},{\"items\":[\"176\",\"175\"],\"designs\":[\"125\"]},{\"items\":[\"174\",\"173\"],\"designs\":[\"124\"]},{\"items\":[\"172\",\"171\"],\"designs\":[\"123\"]},{\"items\":[\"170\",\"169\"],\"designs\":[\"122\"]},{\"items\":[\"168\",\"167\"],\"designs\":[\"121\"]},{\"items\":[\"166\",\"165\"],\"designs\":[\"120\"]}]', '{\"lf4Count\":45,\"havocCount\":10,\"herculesCount\":10,\"apis\":true,\"zeus\":true,\"pet\":true,\"petModules\":[],\"ships\":[49,70,69],\"designs\":{},\"skillTree\":{\"logdisks\":65967,\"researchPoints\":0,\"resetCount\":0}}', '{\"engineering\":5,\"shieldEngineering\":5,\"detonation1\":2,\"detonation2\":3,\"heatseekingMissiles\":5,\"rocketFusion\":5,\"cruelty1\":2,\"cruelty2\":3,\"explosives\":5,\"luck1\":2,\"luck2\":3}', '[]', '{\"2\":[{\"Type\":1,\"Seconds\":26390},{\"Type\":0,\"Seconds\":26405}],\"1\":[{\"Type\":5,\"Seconds\":26420},{\"Type\":6,\"Seconds\":26425},{\"Type\":7,\"Seconds\":26430}],\"7\":[{\"Type\":8,\"Seconds\":26430},{\"Type\":9,\"Seconds\":26435}],\"4\":[{\"Type\":10,\"Seconds\":26440},{\"Type\":11,\"Seconds\":26445},{\"Type\":12,\"Seconds\":26450}]}'),
(3, '[\"140\",\"141\",\"142\",\"143\",\"144\",\"145\",\"146\",\"147\",\"148\",\"149\",\"150\",\"151\",\"152\",\"153\",\"154\"]', '[\"78\",\"40\",\"41\",\"42\",\"43\",\"44\",\"45\",\"46\",\"47\",\"48\",\"49\",\"50\",\"51\",\"52\",\"53\"]', '[{\"items\":[\"99\",\"98\"],\"designs\":[\"139\"]},{\"items\":[\"97\",\"96\"],\"designs\":[\"138\"]},{\"items\":[\"95\",\"94\"],\"designs\":[\"137\"]},{\"items\":[\"93\",\"92\"],\"designs\":[\"136\"]},{\"items\":[\"91\",\"90\"],\"designs\":[\"135\"]},{\"items\":[\"89\",\"88\"],\"designs\":[\"134\"]},{\"items\":[\"87\",\"86\"],\"designs\":[\"133\"]},{\"items\":[\"85\",\"84\"],\"designs\":[\"132\"]},{\"items\":[\"83\",\"82\"],\"designs\":[\"131\"]},{\"items\":[\"81\",\"80\"],\"designs\":[\"130\"]}]', '[\"140\",\"141\",\"142\",\"143\",\"144\",\"145\",\"146\",\"147\",\"148\",\"149\",\"150\",\"151\",\"152\",\"153\",\"154\"]', '[\"100\",\"101\",\"102\",\"103\",\"104\",\"105\",\"106\",\"107\",\"108\",\"109\",\"110\",\"111\",\"112\",\"113\",\"114\"]', '[{\"items\":[\"184\",\"183\"],\"designs\":[\"129\"]},{\"items\":[\"182\",\"181\"],\"designs\":[\"128\"]},{\"items\":[\"180\",\"179\"],\"designs\":[\"127\"]},{\"items\":[\"178\",\"177\"],\"designs\":[\"126\"]},{\"items\":[\"176\",\"175\"],\"designs\":[\"125\"]},{\"items\":[\"174\",\"173\"],\"designs\":[\"124\"]},{\"items\":[\"172\",\"171\"],\"designs\":[\"123\"]},{\"items\":[\"170\",\"169\"],\"designs\":[\"122\"]},{\"items\":[\"168\",\"167\"],\"designs\":[\"121\"]},{\"items\":[\"166\",\"165\"],\"designs\":[\"120\"]}]', '{\"lf4Count\":45,\"havocCount\":10,\"herculesCount\":10,\"apis\":true,\"zeus\":true,\"pet\":true,\"petModules\":[],\"ships\":[49,70,69],\"designs\":{},\"skillTree\":{\"logdisks\":65967,\"researchPoints\":0,\"resetCount\":0}}', '{\"engineering\":5,\"shieldEngineering\":5,\"detonation1\":2,\"detonation2\":3,\"heatseekingMissiles\":5,\"rocketFusion\":5,\"cruelty1\":2,\"cruelty2\":3,\"explosives\":5,\"luck1\":2,\"luck2\":3}', '[]', '{\"2\":[{\"Type\":1,\"Seconds\":26390},{\"Type\":0,\"Seconds\":26405}],\"1\":[{\"Type\":5,\"Seconds\":26420},{\"Type\":6,\"Seconds\":26425},{\"Type\":7,\"Seconds\":26430}],\"7\":[{\"Type\":8,\"Seconds\":26430},{\"Type\":9,\"Seconds\":26435}],\"4\":[{\"Type\":10,\"Seconds\":26440},{\"Type\":11,\"Seconds\":26445},{\"Type\":12,\"Seconds\":26450}]}'),
(4, '[]', '[]', '[{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]}]', '[]', '[]', '[{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]},{\"items\":[],\"designs\":[]}]', '{\"lf4Count\":0,\"havocCount\":0,\"herculesCount\":0,\"apis\":false,\"zeus\":false,\"pet\":true,\"petModules\":[],\"ships\":[],\"designs\":{},\"skillTree\":{\"logdisks\":0,\"researchPoints\":0,\"resetCount\":0}}', '{\"engineering\":0,\"shieldEngineering\":0,\"detonation1\":0,\"detonation2\":0,\"heatseekingMissiles\":0,\"rocketFusion\":0,\"cruelty1\":0,\"cruelty2\":0,\"explosives\":0,\"luck1\":0,\"luck2\":0}', '[]', '{}');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `player_galaxygates`
--

CREATE TABLE `player_galaxygates` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `gateId` int(11) NOT NULL,
  `parts` longtext NOT NULL DEFAULT '[]',
  `multiplier` int(11) NOT NULL DEFAULT 0,
  `lives` int(11) NOT NULL DEFAULT -1,
  `prepared` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `player_settings`
--

CREATE TABLE `player_settings` (
  `userId` int(11) NOT NULL,
  `audio` text NOT NULL DEFAULT '',
  `quality` text NOT NULL DEFAULT '',
  `classY2T` text NOT NULL DEFAULT '',
  `display` text NOT NULL DEFAULT '',
  `gameplay` text NOT NULL DEFAULT '',
  `window` text NOT NULL DEFAULT '',
  `boundKeys` text NOT NULL DEFAULT '',
  `inGameSettings` text NOT NULL DEFAULT '',
  `cooldowns` text NOT NULL DEFAULT '',
  `slotbarItems` text NOT NULL DEFAULT '',
  `premiumSlotbarItems` text NOT NULL DEFAULT '',
  `proActionBarItems` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `player_settings`
--

INSERT INTO `player_settings` (`userId`, `audio`, `quality`, `classY2T`, `display`, `gameplay`, `window`, `boundKeys`, `inGameSettings`, `cooldowns`, `slotbarItems`, `premiumSlotbarItems`, `proActionBarItems`) VALUES
(1, '{\"notSet\":false,\"playCombatMusic\":true,\"music\":2,\"sound\":2,\"voice\":2}', '{\"notSet\":false,\"qualityAttack\":0,\"qualityBackground\":3,\"qualityPresetting\":3,\"qualityCustomized\":true,\"qualityPoizone\":3,\"qualityShip\":0,\"qualityEngine\":0,\"qualityExplosion\":0,\"qualityCollectable\":0,\"qualityEffect\":0}', '{\"questsAvailableFilter\":false,\"questsUnavailableFilter\":false,\"questsCompletedFilter\":false,\"var_1151\":false,\"var_2239\":false,\"questsLevelOrderDescending\":false}', '{\"notSet\":false,\"displayPlayerNames\":true,\"displayResources\":true,\"showPremiumQuickslotBar\":true,\"allowAutoQuality\":true,\"preloadUserShips\":true,\"displayHitpointBubbles\":true,\"showNotOwnedItems\":true,\"displayChat\":true,\"displayWindowsBackground\":true,\"displayNotFreeCargoBoxes\":true,\"dragWindowsAlways\":true,\"displayNotifications\":true,\"hoverShips\":true,\"displayDrones\":true,\"displayBonusBoxes\":true,\"displayFreeCargoBoxes\":true,\"var12P\":true,\"varb3N\":false,\"displaySetting3DqualityAntialias\":4,\"varp3M\":4,\"displaySetting3DqualityEffects\":4,\"displaySetting3DqualityLights\":3,\"displaySetting3DqualityTextures\":3,\"var03r\":4,\"displaySetting3DsizeTextures\":3,\"displaySetting3DtextureFiltering\":-1,\"proActionBarEnabled\":true,\"proActionBarKeyboardInputEnabled\":true,\"proActionBarAutohideEnabled\":true,\"proActionBarOpened\":false}', '{\"notSet\":false,\"autoRefinement\":false,\"quickSlotStopAttack\":true,\"autoBoost\":false,\"autoBuyBootyKeys\":false,\"doubleclickAttackEnabled\":true,\"autochangeAmmo\":true,\"autoStartEnabled\":true,\"varE3N\":true}', '{\"hideAllWindows\":false,\"scale\":6,\"barState\":\"24,1|23,1|100,1|25,1|35,0|34,1|39,1|33,1|36,1|\",\"gameFeatureBarPosition\":\"0.06561679790026247,0\",\"gameFeatureBarLayoutType\":\"0\",\"genericFeatureBarPosition\":\"98.29931972789116,0\",\"genericFeatureBarLayoutType\":\"0\",\"categoryBarPosition\":\"50,85\",\"standartSlotBarPosition\":\"50,85|0,40\",\"standartSlotBarLayoutType\":\"0\",\"premiumSlotBarPosition\":\"50,85|0,80\",\"premiumSlotBarLayoutType\":\"0\",\"proActionBarPosition\":\"0,NaN|0,0\",\"proActionBarLayoutType\":\"0\",\"windows\":{\"user\":{\"x\":98,\"y\":5,\"width\":212,\"height\":88,\"maximixed\":true},\"ship\":{\"x\":70,\"y\":21,\"width\":212,\"height\":88,\"maximixed\":true},\"ship_warp\":{\"x\":50,\"y\":50,\"width\":300,\"height\":210,\"maximixed\":false},\"chat\":{\"x\":94,\"y\":50,\"width\":365,\"height\":289,\"maximixed\":true},\"group\":{\"x\":66,\"y\":4,\"width\":196,\"height\":200,\"maximixed\":true},\"minimap\":{\"x\":98,\"y\":96,\"width\":375,\"height\":263,\"maximixed\":true},\"spacemap\":{\"x\":10,\"y\":7,\"width\":650,\"height\":475,\"maximixed\":false},\"log\":{\"x\":83,\"y\":0,\"width\":240,\"height\":150,\"maximixed\":true},\"pet\":{\"x\":3,\"y\":7,\"width\":260,\"height\":130,\"maximixed\":true},\"spaceball\":{\"x\":10,\"y\":10,\"width\":170,\"height\":70,\"maximixed\":false},\"booster\":{\"x\":23,\"y\":4,\"width\":110,\"height\":150,\"maximixed\":true},\"traininggrounds\":{\"x\":10,\"y\":10,\"width\":320,\"height\":320,\"maximixed\":false},\"settings\":{\"x\":50,\"y\":46,\"width\":400,\"height\":470,\"maximixed\":false},\"help\":{\"x\":10,\"y\":10,\"width\":219,\"height\":121,\"maximixed\":false},\"logout\":{\"x\":50,\"y\":36,\"width\":200,\"height\":200,\"maximixed\":false}}}', '[{\"actionType\":7,\"charCode\":0,\"parameter\":0,\"keyCodes\":[49]},{\"actionType\":7,\"charCode\":0,\"parameter\":1,\"keyCodes\":[50]},{\"actionType\":7,\"charCode\":0,\"parameter\":2,\"keyCodes\":[51]},{\"actionType\":7,\"charCode\":0,\"parameter\":3,\"keyCodes\":[52]},{\"actionType\":7,\"charCode\":0,\"parameter\":4,\"keyCodes\":[53]},{\"actionType\":7,\"charCode\":0,\"parameter\":5,\"keyCodes\":[54]},{\"actionType\":7,\"charCode\":0,\"parameter\":6,\"keyCodes\":[55]},{\"actionType\":7,\"charCode\":0,\"parameter\":7,\"keyCodes\":[56]},{\"actionType\":7,\"charCode\":0,\"parameter\":8,\"keyCodes\":[57]},{\"actionType\":7,\"charCode\":0,\"parameter\":9,\"keyCodes\":[48]},{\"actionType\":8,\"charCode\":0,\"parameter\":0,\"keyCodes\":[112]},{\"actionType\":8,\"charCode\":0,\"parameter\":1,\"keyCodes\":[113]},{\"actionType\":8,\"charCode\":0,\"parameter\":2,\"keyCodes\":[114]},{\"actionType\":8,\"charCode\":0,\"parameter\":3,\"keyCodes\":[115]},{\"actionType\":8,\"charCode\":0,\"parameter\":4,\"keyCodes\":[116]},{\"actionType\":8,\"charCode\":0,\"parameter\":5,\"keyCodes\":[117]},{\"actionType\":8,\"charCode\":0,\"parameter\":6,\"keyCodes\":[118]},{\"actionType\":8,\"charCode\":0,\"parameter\":7,\"keyCodes\":[119]},{\"actionType\":8,\"charCode\":0,\"parameter\":8,\"keyCodes\":[120]},{\"actionType\":0,\"charCode\":0,\"parameter\":0,\"keyCodes\":[74]},{\"actionType\":1,\"charCode\":0,\"parameter\":0,\"keyCodes\":[67]},{\"actionType\":2,\"charCode\":0,\"parameter\":0,\"keyCodes\":[17]},{\"actionType\":3,\"charCode\":0,\"parameter\":0,\"keyCodes\":[32]},{\"actionType\":4,\"charCode\":0,\"parameter\":0,\"keyCodes\":[69]},{\"actionType\":5,\"charCode\":0,\"parameter\":0,\"keyCodes\":[82]},{\"actionType\":13,\"charCode\":0,\"parameter\":0,\"keyCodes\":[68]},{\"actionType\":6,\"charCode\":0,\"parameter\":0,\"keyCodes\":[76]},{\"actionType\":9,\"charCode\":0,\"parameter\":0,\"keyCodes\":[72]},{\"actionType\":10,\"charCode\":0,\"parameter\":0,\"keyCodes\":[70]},{\"actionType\":11,\"charCode\":0,\"parameter\":0,\"keyCodes\":[107]},{\"actionType\":12,\"charCode\":0,\"parameter\":0,\"keyCodes\":[109]},{\"actionType\":14,\"charCode\":0,\"parameter\":0,\"keyCodes\":[13]},{\"actionType\":15,\"charCode\":0,\"parameter\":0,\"keyCodes\":[9]},{\"actionType\":8,\"charCode\":0,\"parameter\":9,\"keyCodes\":[121]},{\"actionType\":16,\"charCode\":0,\"parameter\":0,\"keyCodes\":[16]}]', '{\"petDestroyed\":false,\"blockedGroupInvites\":false,\"selectedLaser\":\"ammunition_laser_ucb-100\",\"selectedRocket\":\"ammunition_rocket_plt-3030\",\"selectedRocketLauncher\":\"ammunition_rocketlauncher_hstrm-01\",\"selectedFormation\":\"drone_formation_f-11-he\",\"currentConfig\":1,\"selectedCpus\":[\"equipment_extra_cpu_rllb-x\",\"equipment_extra_cpu_arol-x\",\"equipment_extra_cpu_cl04k-xl\"]}', '{\"ammunition_mine_smb-01\":\"2025-11-25 01:55:32\",\"equipment_extra_cpu_ish-01\":\"2025-11-25 01:55:35\",\"ammunition_specialammo_emp-01\":\"2025-11-30 01:12:25\",\"ammunition_mine\":\"2025-11-25 02:01:53\",\"ammunition_specialammo_dcr-250\":\"1957-11-18 22:46:52\",\"ammunition_specialammo_pld-8\":\"2025-11-30 19:49:54\",\"ammunition_specialammo_r-ic3\":\"1957-11-18 22:46:52\",\"tech_energy-leech\":\"\",\"tech_chain-impulse\":\"\",\"tech_precision-targeter\":\"\",\"tech_backup-shields\":\"\",\"tech_battle-repair-bot\":\"\",\"ability_solace\":\"2025-11-20 09:44:51\",\"ability_aegis_hp-repair\":\"2025-12-07 02:01:05\",\"ability_aegis_shield-repair\":\"2025-12-07 02:01:06\",\"ability_aegis_repair-pod\":\"2025-12-07 02:01:07\",\"ability_venom\":\"0001-01-01 00:00:00\",\"ability_citadel_draw-fire\":\"0001-01-01 00:00:00\"}', '{\"1\":\"ammunition_laser_ucb-100\",\"10\":\"drone_formation_f-3d-dr\",\"2\":\"ammunition_laser_rsb-75\",\"3\":\"ammunition_laser_sab-50\",\"8\":\"equipment_extra_cpu_ish-01\",\"4\":\"ammunition_rocketlauncher_hstrm-01\",\"5\":\"ammunition_rocketlauncher_sar-02\",\"6\":\"equipment_extra_cpu_cl04k-xl\",\"7\":\"ammunition_specialammo_emp-01\",\"9\":\"drone_formation_f-07-di\"}', '{\"1\":\"ammunition_rocket_plt-3030\",\"10\":\"drone_formation_f-11-he\",\"9\":\"drone_formation_f-3d-rg\",\"2\":\"ammunition_specialammo_dcr-250\",\"3\":\"ammunition_specialammo_r-ic3\",\"4\":\"ammunition_specialammo_wiz-x\",\"5\":\"ammunition_specialammo_pld-8\",\"8\":\"tech_energy-leech\",\"7\":\"tech_battle-repair-bot\",\"6\":\"tech_backup-shields\"}', '{}'),
(2, '{\"notSet\":false,\"playCombatMusic\":true,\"music\":1,\"sound\":2,\"voice\":1}', '{\"notSet\":false,\"qualityAttack\":0,\"qualityBackground\":3,\"qualityPresetting\":3,\"qualityCustomized\":true,\"qualityPoizone\":3,\"qualityShip\":0,\"qualityEngine\":0,\"qualityExplosion\":0,\"qualityCollectable\":0,\"qualityEffect\":0}', '{\"questsAvailableFilter\":false,\"questsUnavailableFilter\":false,\"questsCompletedFilter\":false,\"var_1151\":false,\"var_2239\":false,\"questsLevelOrderDescending\":false}', '{\"notSet\":false,\"displayPlayerNames\":true,\"displayResources\":true,\"showPremiumQuickslotBar\":true,\"allowAutoQuality\":true,\"preloadUserShips\":true,\"displayHitpointBubbles\":true,\"showNotOwnedItems\":true,\"displayChat\":true,\"displayWindowsBackground\":true,\"displayNotFreeCargoBoxes\":true,\"dragWindowsAlways\":true,\"displayNotifications\":true,\"hoverShips\":true,\"displayDrones\":true,\"displayBonusBoxes\":true,\"displayFreeCargoBoxes\":true,\"var12P\":true,\"varb3N\":false,\"displaySetting3DqualityAntialias\":1,\"varp3M\":4,\"displaySetting3DqualityEffects\":1,\"displaySetting3DqualityLights\":1,\"displaySetting3DqualityTextures\":1,\"var03r\":4,\"displaySetting3DsizeTextures\":1,\"displaySetting3DtextureFiltering\":1,\"proActionBarEnabled\":true,\"proActionBarKeyboardInputEnabled\":true,\"proActionBarAutohideEnabled\":true,\"proActionBarOpened\":true}', '{\"notSet\":false,\"autoRefinement\":false,\"quickSlotStopAttack\":true,\"autoBoost\":false,\"autoBuyBootyKeys\":false,\"doubleclickAttackEnabled\":true,\"autochangeAmmo\":true,\"autoStartEnabled\":true,\"varE3N\":true}', '{\"hideAllWindows\":false,\"scale\":6,\"barState\":\"24,1|23,1|100,1|25,1|35,0|34,0|39,0|\",\"gameFeatureBarPosition\":\"0.06561679790026247,0\",\"gameFeatureBarLayoutType\":\"0\",\"genericFeatureBarPosition\":\"98.29931972789116,0\",\"genericFeatureBarLayoutType\":\"0\",\"categoryBarPosition\":\"50,85\",\"standartSlotBarPosition\":\"50,85|0,40\",\"standartSlotBarLayoutType\":\"0\",\"premiumSlotBarPosition\":\"50,85|0,80\",\"premiumSlotBarLayoutType\":\"0\",\"proActionBarPosition\":\"\",\"proActionBarLayoutType\":\"\",\"windows\":{\"user\":{\"x\":97,\"y\":6,\"width\":212,\"height\":88,\"maximixed\":true},\"ship\":{\"x\":98,\"y\":20,\"width\":212,\"height\":88,\"maximixed\":true},\"ship_warp\":{\"x\":50,\"y\":50,\"width\":300,\"height\":210,\"maximixed\":false},\"chat\":{\"x\":10,\"y\":8,\"width\":300,\"height\":150,\"maximixed\":false},\"group\":{\"x\":50,\"y\":49,\"width\":196,\"height\":200,\"maximixed\":false},\"minimap\":{\"x\":98,\"y\":96,\"width\":375,\"height\":263,\"maximixed\":true},\"spacemap\":{\"x\":10,\"y\":10,\"width\":650,\"height\":475,\"maximixed\":false},\"log\":{\"x\":30,\"y\":30,\"width\":240,\"height\":150,\"maximixed\":false},\"pet\":{\"x\":0,\"y\":5,\"width\":260,\"height\":130,\"maximixed\":true},\"spaceball\":{\"x\":10,\"y\":10,\"width\":170,\"height\":70,\"maximixed\":false},\"booster\":{\"x\":10,\"y\":10,\"width\":110,\"height\":150,\"maximixed\":false},\"traininggrounds\":{\"x\":10,\"y\":10,\"width\":320,\"height\":320,\"maximixed\":false},\"settings\":{\"x\":50,\"y\":49,\"width\":400,\"height\":470,\"maximixed\":false},\"help\":{\"x\":10,\"y\":10,\"width\":219,\"height\":121,\"maximixed\":false},\"logout\":{\"x\":50,\"y\":48,\"width\":200,\"height\":200,\"maximixed\":false}}}', '[{\"actionType\":7,\"charCode\":0,\"parameter\":0,\"keyCodes\":[49]},{\"actionType\":7,\"charCode\":0,\"parameter\":1,\"keyCodes\":[50]},{\"actionType\":7,\"charCode\":0,\"parameter\":2,\"keyCodes\":[51]},{\"actionType\":7,\"charCode\":0,\"parameter\":3,\"keyCodes\":[52]},{\"actionType\":7,\"charCode\":0,\"parameter\":4,\"keyCodes\":[53]},{\"actionType\":7,\"charCode\":0,\"parameter\":5,\"keyCodes\":[54]},{\"actionType\":7,\"charCode\":0,\"parameter\":6,\"keyCodes\":[55]},{\"actionType\":7,\"charCode\":0,\"parameter\":7,\"keyCodes\":[56]},{\"actionType\":7,\"charCode\":0,\"parameter\":8,\"keyCodes\":[57]},{\"actionType\":7,\"charCode\":0,\"parameter\":9,\"keyCodes\":[48]},{\"actionType\":8,\"charCode\":0,\"parameter\":0,\"keyCodes\":[112]},{\"actionType\":8,\"charCode\":0,\"parameter\":1,\"keyCodes\":[113]},{\"actionType\":8,\"charCode\":0,\"parameter\":2,\"keyCodes\":[114]},{\"actionType\":8,\"charCode\":0,\"parameter\":3,\"keyCodes\":[115]},{\"actionType\":8,\"charCode\":0,\"parameter\":4,\"keyCodes\":[116]},{\"actionType\":8,\"charCode\":0,\"parameter\":5,\"keyCodes\":[117]},{\"actionType\":8,\"charCode\":0,\"parameter\":6,\"keyCodes\":[118]},{\"actionType\":8,\"charCode\":0,\"parameter\":7,\"keyCodes\":[119]},{\"actionType\":8,\"charCode\":0,\"parameter\":8,\"keyCodes\":[120]},{\"actionType\":0,\"charCode\":0,\"parameter\":0,\"keyCodes\":[74]},{\"actionType\":1,\"charCode\":0,\"parameter\":0,\"keyCodes\":[67]},{\"actionType\":2,\"charCode\":0,\"parameter\":0,\"keyCodes\":[17]},{\"actionType\":3,\"charCode\":0,\"parameter\":0,\"keyCodes\":[32]},{\"actionType\":4,\"charCode\":0,\"parameter\":0,\"keyCodes\":[69]},{\"actionType\":5,\"charCode\":0,\"parameter\":0,\"keyCodes\":[82]},{\"actionType\":13,\"charCode\":0,\"parameter\":0,\"keyCodes\":[68]},{\"actionType\":6,\"charCode\":0,\"parameter\":0,\"keyCodes\":[76]},{\"actionType\":9,\"charCode\":0,\"parameter\":0,\"keyCodes\":[72]},{\"actionType\":10,\"charCode\":0,\"parameter\":0,\"keyCodes\":[70]},{\"actionType\":11,\"charCode\":0,\"parameter\":0,\"keyCodes\":[107]},{\"actionType\":12,\"charCode\":0,\"parameter\":0,\"keyCodes\":[109]},{\"actionType\":14,\"charCode\":0,\"parameter\":0,\"keyCodes\":[13]},{\"actionType\":15,\"charCode\":0,\"parameter\":0,\"keyCodes\":[9]},{\"actionType\":8,\"charCode\":0,\"parameter\":9,\"keyCodes\":[121]},{\"actionType\":16,\"charCode\":0,\"parameter\":0,\"keyCodes\":[16]}]', '{\"petDestroyed\":false,\"blockedGroupInvites\":false,\"selectedLaser\":\"ammunition_laser_ucb-100\",\"selectedRocket\":\"ammunition_rocket_plt-3030\",\"selectedRocketLauncher\":\"ammunition_rocketlauncher_hstrm-01\",\"selectedFormation\":\"drone_formation_f-03-la\",\"currentConfig\":2,\"selectedCpus\":[\"equipment_extra_cpu_arol-x\",\"equipment_extra_cpu_rllb-x\"]}', '{\"ammunition_mine_smb-01\":\"1957-11-12 01:11:28\",\"equipment_extra_cpu_ish-01\":\"1957-11-12 01:11:28\",\"ammunition_specialammo_emp-01\":\"1957-11-12 01:11:28\",\"ammunition_mine\":\"1957-11-12 01:11:28\",\"ammunition_specialammo_dcr-250\":\"1957-11-12 01:11:28\",\"ammunition_specialammo_pld-8\":\"1957-11-12 01:11:28\",\"ammunition_specialammo_r-ic3\":\"1957-11-12 01:11:28\",\"tech_energy-leech\":\"\",\"tech_chain-impulse\":\"\",\"tech_precision-targeter\":\"\",\"tech_backup-shields\":\"\",\"tech_battle-repair-bot\":\"\"}', '{\"1\":\"ammunition_laser_ucb-100\",\"2\":\"ammunition_laser_rsb-75\"}', '{}', '{}'),
(3, '{\"notSet\":false,\"playCombatMusic\":true,\"music\":1,\"sound\":1,\"voice\":1}', '{\"notSet\":false,\"qualityAttack\":0,\"qualityBackground\":3,\"qualityPresetting\":3,\"qualityCustomized\":true,\"qualityPoizone\":3,\"qualityShip\":0,\"qualityEngine\":0,\"qualityExplosion\":0,\"qualityCollectable\":0,\"qualityEffect\":0}', '{\"questsAvailableFilter\":false,\"questsUnavailableFilter\":false,\"questsCompletedFilter\":false,\"var_1151\":false,\"var_2239\":false,\"questsLevelOrderDescending\":false}', '{\"notSet\":false,\"displayPlayerNames\":true,\"displayResources\":true,\"showPremiumQuickslotBar\":true,\"allowAutoQuality\":true,\"preloadUserShips\":true,\"displayHitpointBubbles\":true,\"showNotOwnedItems\":true,\"displayChat\":true,\"displayWindowsBackground\":true,\"displayNotFreeCargoBoxes\":true,\"dragWindowsAlways\":true,\"displayNotifications\":true,\"hoverShips\":true,\"displayDrones\":true,\"displayBonusBoxes\":true,\"displayFreeCargoBoxes\":true,\"var12P\":true,\"varb3N\":false,\"displaySetting3DqualityAntialias\":4,\"varp3M\":4,\"displaySetting3DqualityEffects\":4,\"displaySetting3DqualityLights\":3,\"displaySetting3DqualityTextures\":3,\"var03r\":4,\"displaySetting3DsizeTextures\":3,\"displaySetting3DtextureFiltering\":-1,\"proActionBarEnabled\":true,\"proActionBarKeyboardInputEnabled\":true,\"proActionBarAutohideEnabled\":true,\"proActionBarOpened\":false}', '{\"notSet\":false,\"autoRefinement\":false,\"quickSlotStopAttack\":true,\"autoBoost\":false,\"autoBuyBootyKeys\":false,\"doubleclickAttackEnabled\":true,\"autochangeAmmo\":true,\"autoStartEnabled\":true,\"varE3N\":true}', '{\"hideAllWindows\":false,\"scale\":6,\"barState\":\"24,1|23,1|100,1|25,1|35,0|34,0|39,0|\",\"gameFeatureBarPosition\":\"0.06561679790026247,0\",\"gameFeatureBarLayoutType\":\"0\",\"genericFeatureBarPosition\":\"98.29931972789116,0\",\"genericFeatureBarLayoutType\":\"0\",\"categoryBarPosition\":\"50,85\",\"standartSlotBarPosition\":\"50,85|0,40\",\"standartSlotBarLayoutType\":\"0\",\"premiumSlotBarPosition\":\"50,85|0,80\",\"premiumSlotBarLayoutType\":\"0\",\"proActionBarPosition\":\"0,NaN|0,0\",\"proActionBarLayoutType\":\"0\",\"windows\":{\"user\":{\"x\":97,\"y\":5,\"width\":212,\"height\":88,\"maximixed\":true},\"ship\":{\"x\":98,\"y\":17,\"width\":212,\"height\":88,\"maximixed\":true},\"ship_warp\":{\"x\":50,\"y\":50,\"width\":300,\"height\":210,\"maximixed\":false},\"chat\":{\"x\":0,\"y\":6,\"width\":354,\"height\":218,\"maximixed\":false},\"group\":{\"x\":34,\"y\":3,\"width\":196,\"height\":200,\"maximixed\":true},\"minimap\":{\"x\":98,\"y\":96,\"width\":375,\"height\":263,\"maximixed\":true},\"spacemap\":{\"x\":10,\"y\":10,\"width\":650,\"height\":475,\"maximixed\":false},\"log\":{\"x\":30,\"y\":30,\"width\":240,\"height\":150,\"maximixed\":false},\"pet\":{\"x\":1,\"y\":7,\"width\":260,\"height\":130,\"maximixed\":true},\"spaceball\":{\"x\":10,\"y\":10,\"width\":170,\"height\":70,\"maximixed\":false},\"booster\":{\"x\":10,\"y\":10,\"width\":110,\"height\":150,\"maximixed\":false},\"traininggrounds\":{\"x\":10,\"y\":10,\"width\":320,\"height\":320,\"maximixed\":false},\"settings\":{\"x\":50,\"y\":47,\"width\":400,\"height\":470,\"maximixed\":false},\"help\":{\"x\":10,\"y\":10,\"width\":219,\"height\":121,\"maximixed\":false},\"logout\":{\"x\":50,\"y\":43,\"width\":200,\"height\":200,\"maximixed\":false}}}', '[{\"actionType\":7,\"charCode\":0,\"parameter\":0,\"keyCodes\":[49]},{\"actionType\":7,\"charCode\":0,\"parameter\":1,\"keyCodes\":[50]},{\"actionType\":7,\"charCode\":0,\"parameter\":2,\"keyCodes\":[51]},{\"actionType\":7,\"charCode\":0,\"parameter\":3,\"keyCodes\":[52]},{\"actionType\":7,\"charCode\":0,\"parameter\":4,\"keyCodes\":[53]},{\"actionType\":7,\"charCode\":0,\"parameter\":5,\"keyCodes\":[54]},{\"actionType\":7,\"charCode\":0,\"parameter\":6,\"keyCodes\":[55]},{\"actionType\":7,\"charCode\":0,\"parameter\":7,\"keyCodes\":[56]},{\"actionType\":7,\"charCode\":0,\"parameter\":8,\"keyCodes\":[57]},{\"actionType\":7,\"charCode\":0,\"parameter\":9,\"keyCodes\":[48]},{\"actionType\":8,\"charCode\":0,\"parameter\":0,\"keyCodes\":[112]},{\"actionType\":8,\"charCode\":0,\"parameter\":1,\"keyCodes\":[113]},{\"actionType\":8,\"charCode\":0,\"parameter\":2,\"keyCodes\":[114]},{\"actionType\":8,\"charCode\":0,\"parameter\":3,\"keyCodes\":[115]},{\"actionType\":8,\"charCode\":0,\"parameter\":4,\"keyCodes\":[116]},{\"actionType\":8,\"charCode\":0,\"parameter\":5,\"keyCodes\":[117]},{\"actionType\":8,\"charCode\":0,\"parameter\":6,\"keyCodes\":[118]},{\"actionType\":8,\"charCode\":0,\"parameter\":7,\"keyCodes\":[119]},{\"actionType\":8,\"charCode\":0,\"parameter\":8,\"keyCodes\":[120]},{\"actionType\":0,\"charCode\":0,\"parameter\":0,\"keyCodes\":[74]},{\"actionType\":1,\"charCode\":0,\"parameter\":0,\"keyCodes\":[67]},{\"actionType\":2,\"charCode\":0,\"parameter\":0,\"keyCodes\":[17]},{\"actionType\":3,\"charCode\":0,\"parameter\":0,\"keyCodes\":[32]},{\"actionType\":4,\"charCode\":0,\"parameter\":0,\"keyCodes\":[69]},{\"actionType\":5,\"charCode\":0,\"parameter\":0,\"keyCodes\":[82]},{\"actionType\":13,\"charCode\":0,\"parameter\":0,\"keyCodes\":[68]},{\"actionType\":6,\"charCode\":0,\"parameter\":0,\"keyCodes\":[76]},{\"actionType\":9,\"charCode\":0,\"parameter\":0,\"keyCodes\":[72]},{\"actionType\":10,\"charCode\":0,\"parameter\":0,\"keyCodes\":[70]},{\"actionType\":11,\"charCode\":0,\"parameter\":0,\"keyCodes\":[107]},{\"actionType\":12,\"charCode\":0,\"parameter\":0,\"keyCodes\":[109]},{\"actionType\":14,\"charCode\":0,\"parameter\":0,\"keyCodes\":[13]},{\"actionType\":15,\"charCode\":0,\"parameter\":0,\"keyCodes\":[9]},{\"actionType\":8,\"charCode\":0,\"parameter\":9,\"keyCodes\":[121]},{\"actionType\":16,\"charCode\":0,\"parameter\":0,\"keyCodes\":[16]}]', '{\"petDestroyed\":false,\"blockedGroupInvites\":false,\"selectedLaser\":\"ammunition_laser_ucb-100\",\"selectedRocket\":\"ammunition_rocket_plt-3030\",\"selectedRocketLauncher\":\"ammunition_rocketlauncher_hstrm-01\",\"selectedFormation\":\"drone_formation_f-03-la\",\"currentConfig\":2,\"selectedCpus\":[\"equipment_extra_cpu_arol-x\",\"equipment_extra_cpu_rllb-x\"]}', '{\"ammunition_mine_smb-01\":\"2025-11-30 03:40:59\",\"equipment_extra_cpu_ish-01\":\"2025-11-30 00:45:08\",\"ammunition_specialammo_emp-01\":\"2025-11-30 00:45:17\",\"ammunition_mine\":\"2025-11-30 03:41:01\",\"ammunition_specialammo_dcr-250\":\"2025-11-30 00:43:21\",\"ammunition_specialammo_pld-8\":\"2025-11-30 00:43:25\",\"ammunition_specialammo_r-ic3\":\"2025-11-30 00:43:27\",\"tech_energy-leech\":\"\",\"tech_chain-impulse\":\"\",\"tech_precision-targeter\":\"\",\"tech_backup-shields\":\"\",\"tech_battle-repair-bot\":\"\",\"ability_solace\":\"0001-01-01 00:00:00\",\"ability_spectrum\":\"1957-11-02 06:33:06\",\"ability_diminisher\":\"2025-11-30 03:40:54\"}', '{\"1\":\"ammunition_laser_ucb-100\"}', '{\"1\":\"drone_formation_default\"}', '{}'),
(4, '', '', '', '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `player_titles`
--

CREATE TABLE `player_titles` (
  `userID` int(11) NOT NULL,
  `titles` varchar(255) NOT NULL DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `player_titles`
--

INSERT INTO `player_titles` (`userID`, `titles`) VALUES
(1, '[]'),
(2, '[]'),
(3, '[]'),
(4, '[]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_bans`
--

CREATE TABLE `server_bans` (
  `id` bigint(20) NOT NULL,
  `userId` int(11) NOT NULL,
  `modId` int(11) NOT NULL,
  `reason` text NOT NULL,
  `typeId` tinyint(4) NOT NULL,
  `ended` tinyint(1) NOT NULL,
  `end_date` datetime NOT NULL,
  `date_added` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_battlestations`
--

CREATE TABLE `server_battlestations` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `mapId` int(11) NOT NULL,
  `clanId` int(11) NOT NULL,
  `positionX` int(11) NOT NULL,
  `positionY` int(11) NOT NULL,
  `inBuildingState` tinyint(4) NOT NULL,
  `buildTimeInMinutes` int(11) NOT NULL,
  `buildTime` datetime NOT NULL,
  `deflectorActive` tinyint(4) NOT NULL,
  `deflectorSecondsLeft` int(11) NOT NULL,
  `deflectorTime` datetime NOT NULL,
  `visualModifiers` text NOT NULL,
  `modules` longtext NOT NULL,
  `active` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `server_battlestations`
--

INSERT INTO `server_battlestations` (`id`, `name`, `mapId`, `clanId`, `positionX`, `positionY`, `inBuildingState`, `buildTimeInMinutes`, `buildTime`, `deflectorActive`, `deflectorSecondsLeft`, `deflectorTime`, `visualModifiers`, `modules`, `active`) VALUES
(1, 'Julius', 15, 0, 16400, 11400, 0, 0, '0000-00-00 00:00:00', 0, 0, '0001-01-01 00:00:00', '[]', '[]', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_clans`
--

CREATE TABLE `server_clans` (
  `id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `tag` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `description` varchar(16000) NOT NULL DEFAULT '',
  `factionId` tinyint(4) NOT NULL DEFAULT 0,
  `recruiting` tinyint(4) NOT NULL DEFAULT 1,
  `leaderId` int(11) NOT NULL DEFAULT 0,
  `news` text NOT NULL DEFAULT '[]',
  `join_dates` text NOT NULL DEFAULT '{}',
  `rankPoints` bigint(20) DEFAULT 0,
  `rank` int(11) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `profile` varchar(255) NOT NULL DEFAULT 'default.jpg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `server_clans`
--

INSERT INTO `server_clans` (`id`, `name`, `tag`, `description`, `factionId`, `recruiting`, `leaderId`, `news`, `join_dates`, `rankPoints`, `rank`, `date`, `profile`) VALUES
(1, 'NEM_JO_A_BEST', 'Ζ€T', '1v1', 3, 1, 1, '[]', '{\"1\":\"2025-11-15 19:12:45\",\"3\":\"2025-11-30 06:04:21\"}', 86149, 1, '2025-11-15 19:12:45', 'default.jpg');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_clan_applications`
--

CREATE TABLE `server_clan_applications` (
  `id` int(11) NOT NULL,
  `clanId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_clan_diplomacy`
--

CREATE TABLE `server_clan_diplomacy` (
  `id` bigint(20) NOT NULL,
  `senderClanId` int(11) NOT NULL,
  `toClanId` int(11) NOT NULL,
  `diplomacyType` tinyint(4) NOT NULL,
  `date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_clan_diplomacy_applications`
--

CREATE TABLE `server_clan_diplomacy_applications` (
  `id` bigint(20) NOT NULL,
  `senderClanId` int(11) NOT NULL,
  `toClanId` int(11) NOT NULL,
  `diplomacyType` tinyint(4) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_maps`
--

CREATE TABLE `server_maps` (
  `mapID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `npcs` longtext NOT NULL,
  `stations` longtext NOT NULL,
  `portals` longtext NOT NULL,
  `collectables` longtext NOT NULL,
  `options` varchar(512) NOT NULL DEFAULT '{"StarterMap":false,"PvpMap":false,"RangeDisabled":false,"CloakBlocked":false,"LogoutBlocked":false,"DeathLocationRepair":true}',
  `factionID` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `server_maps`
--

INSERT INTO `server_maps` (`mapID`, `name`, `npcs`, `stations`, `portals`, `collectables`, `options`, `factionID`) VALUES
(1, '1-1', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(2, '1-2', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(3, '1-3', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(4, '1-4', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(5, '2-1', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(6, '2-2', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(7, '2-3', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(8, '2-4', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(9, '3-1', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(10, '3-2', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(11, '3-3', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(12, '3-4', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(13, '4-1', '[{   \"ShipId\": 79,   \"Amount\": 12},{   \"ShipId\": 78,   \"Amount\":12},{   \"ShipId\": 35,   \"Amount\":12},{   \"ShipId\": 29,   \"Amount\":12}]', '[{   \"TypeId\": 46,   \"FactionId\": 1,   \"Position\": [1600,1600] }]', '[{   \"TargetSpaceMapId\": 16,   \"Position\": [10000, 6200],   \"TargetPosition\": [19200,13400],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true },{   \"TargetSpaceMapId\": 14,   \"Position\": [18900, 1900],   \"TargetPosition\": [2500,10900],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true },{   \"TargetSpaceMapId\": 15,   \"Position\": [18900, 11300],   \"TargetPosition\": [2000,11200],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true }]', '[{   \"TypeId\": 2,   \"Amount\": 100,   \"TopLeft\": [18300,1100], \"BottomRight\": [18300,1100], \"Respawnable\":true }]', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(14, '4-2', '[{   \"ShipId\": 79,   \"Amount\": 7},{   \"ShipId\": 78,   \"Amount\":12},{   \"ShipId\": 35,   \"Amount\":2},{   \"ShipId\": 29,   \"Amount\":4}]', '[{   \"TypeId\": 46,   \"FactionId\": 2,   \"Position\": [19500,1500] }]', '[{   \"TargetSpaceMapId\": 16,   \"Position\": [10400, 6300],   \"TargetPosition\": [21900,11900],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true }, {   \"TargetSpaceMapId\": 13,   \"Position\": [2500, 10900],   \"TargetPosition\": [18900,1900],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true }, {   \"TargetSpaceMapId\": 15,   \"Position\": [18900, 10900],   \"TargetPosition\": [2000,1900],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true }]', '[{   \"TypeId\": 2,   \"Amount\": 100,   \"TopLeft\": [18300,1100], \"BottomRight\": [18300,1100], \"Respawnable\":true }]', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(15, '4-3', '[{   \"ShipId\": 79,   \"Amount\": 7},{   \"ShipId\": 78,   \"Amount\":12},{   \"ShipId\": 35,   \"Amount\":2},{   \"ShipId\": 29,   \"Amount\":4}]', '[{   \"TypeId\": 46,   \"FactionId\": 3,   \"Position\": [19500,11600] }]', '[{   \"TargetSpaceMapId\": 16,   \"Position\": [10300, 6600],   \"TargetPosition\": [21900,14500],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true },  {   \"TargetSpaceMapId\": 13,   \"Position\": [2000,11200],   \"TargetPosition\": [18900,11300],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true },  {   \"TargetSpaceMapId\": 14,   \"Position\": [2000,1900],   \"TargetPosition\": [18700,10900],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true }]', '[{   \"TypeId\": 2,   \"Amount\": 100,   \"TopLeft\": [18300,1100], \"BottomRight\": [18300,1100], \"Respawnable\":true }]', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(16, '4-4', '', '', '[{   \"TargetSpaceMapId\": 13,   \"Position\": [19200,13400],   \"TargetPosition\": [10000,6200],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true },  {   \"TargetSpaceMapId\": 14,   \"Position\": [21900,11900],   \"TargetPosition\": [10400,6300],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true },  {   \"TargetSpaceMapId\": 15,   \"Position\": [21900,14500],   \"TargetPosition\": [10300,6600],   \"GraphicId\": 1,   \"FactionId\": 1,   \"Visible\": true,   \"Working\": true }]', '', '{\"StarterMap\":false,\"PvpMap\":true,\"RangeDisabled\":true,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(17, '1-5', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(18, '1-6', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(19, '1-7', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(20, '1-8', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(21, '2-5', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(22, '2-6', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(23, '2-7', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(24, '2-8', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(25, '3-5', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(26, '3-6', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(27, '3-7', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(28, '3-8', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(42, '???', '[{   \"ShipId\": 79,   \"Amount\": 70},{   \"ShipId\": 78,   \"Amount\":120},{   \"ShipId\": 35,   \"Amount\":20},{   \"ShipId\": 29,   \"Amount\":40}]', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":true,\"CloakBlocked\":true,\"LogoutBlocked\":true,\"DeathLocationRepair\":false}', 0),
(71, 'GG Zeta', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(74, 'GG Kappa', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(101, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":true,\"CloakBlocked\":true,\"LogoutBlocked\":true,\"DeathLocationRepair\":false}', 0),
(102, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(103, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(104, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(105, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(106, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(107, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(108, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(109, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(110, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(111, 'JP', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(121, 'TA', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":true,\"CloakBlocked\":true,\"LogoutBlocked\":true,\"DeathLocationRepair\":false}', 0),
(200, 'LoW', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0),
(224, 'Custom Tournament', '', '', '', '', '{\"StarterMap\":false,\"PvpMap\":false,\"RangeDisabled\":false,\"CloakBlocked\":false,\"LogoutBlocked\":false,\"DeathLocationRepair\":true}', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `server_ships`
--

CREATE TABLE `server_ships` (
  `id` int(11) NOT NULL,
  `shipID` int(11) NOT NULL,
  `baseShipId` int(11) NOT NULL,
  `lootID` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `health` int(11) NOT NULL DEFAULT 0,
  `shield` int(11) NOT NULL DEFAULT 0,
  `speed` int(11) NOT NULL DEFAULT 300,
  `lasers` int(11) NOT NULL DEFAULT 1,
  `generators` int(11) NOT NULL DEFAULT 1,
  `cargo` int(11) NOT NULL DEFAULT 100,
  `aggressive` tinyint(1) NOT NULL DEFAULT 0,
  `damage` int(11) NOT NULL DEFAULT 20,
  `respawnable` tinyint(1) NOT NULL,
  `reward` varchar(2048) NOT NULL DEFAULT '{"Experience":0,"Honor":0,"Credits":0,"Uridium":0}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `server_ships`
--

INSERT INTO `server_ships` (`id`, `shipID`, `baseShipId`, `lootID`, `name`, `health`, `shield`, `speed`, `lasers`, `generators`, `cargo`, `aggressive`, `damage`, `respawnable`, `reward`) VALUES
(18, 1, 0, 'ship_phoenix', 'Phoenix', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(19, 2, 0, 'ship_yamato', 'Yamato', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(20, 3, 0, 'ship_leonov', 'Leonov', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(21, 4, 0, 'ship_defcom', 'Defcom', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(22, 5, 0, 'ship_liberator', 'Liberator', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(23, 6, 0, 'ship_piranha', 'Piranha', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(24, 7, 0, 'ship_nostromo', 'Nostromo', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(25, 8, 8, 'ship_vengeance', 'Vengeance', 180000, 0, 380, 10, 10, 0, 0, 0, 0, '{\"Experience\":25600,\"Honor\":256,\"Credits\":0,\"Uridium\":256}'),
(26, 9, 0, 'ship_bigboy', 'Bigboy', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(27, 10, 10, 'ship_goliath', 'Goliath', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(28, 12, 0, 'pet', 'P.E.T. Level 1-3', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":150,\"Credits\":0,\"Uridium\":0}'),
(29, 13, 0, 'pet', 'P.E.T. Red', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":150,\"Credits\":0,\"Uridium\":0}'),
(30, 15, 0, 'pet', 'P.E.T. Frozen', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":150,\"Credits\":0,\"Uridium\":0}'),
(31, 16, 8, 'ship_vengeance_design_adept', 'Adept', 180000, 0, 380, 10, 10, 0, 0, 0, 0, '{\"Experience\":25600,\"Honor\":256,\"Credits\":0,\"Uridium\":256}'),
(32, 17, 8, 'ship_vengeance_design_corsair', 'Corsair', 180000, 0, 380, 10, 10, 0, 0, 0, 0, '{\"Experience\":25600,\"Honor\":256,\"Credits\":0,\"Uridium\":256}'),
(33, 18, 8, 'ship_vengeance_design_lightning', 'Lightning', 180000, 0, 380, 10, 10, 0, 0, 0, 0, '{\"Experience\":25600,\"Honor\":256,\"Credits\":0,\"Uridium\":256}'),
(34, 19, 10, 'ship_goliath_design_jade', 'Jade', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(35, 20, 0, 'ship_admin', 'Ufo', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(36, 22, 0, 'pet', 'P.E.T. Normal', 0, 50000, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":150,\"Credits\":0,\"Uridium\":0}'),
(37, 49, 49, 'ship_aegis', 'Aegis', 275000, 0, 300, 10, 15, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":250,\"Credits\":0,\"Uridium\":250}'),
(38, 52, 10, 'ship_goliath_design_amber', 'Amber', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(39, 53, 10, 'ship_goliath_design_crimson', 'Crimson', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(40, 54, 10, 'ship_goliath_design_sapphire', 'Sapphire', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(41, 56, 10, 'ship_goliath_design_enforcer', 'Enforcer', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(42, 57, 10, 'ship_goliath_design_independence', 'Independence', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(43, 58, 8, 'ship_vengeance_design_revenge', 'Revenge', 180000, 0, 380, 10, 10, 0, 0, 0, 0, '{\"Experience\":25600,\"Honor\":256,\"Credits\":0,\"Uridium\":256}'),
(44, 59, 10, 'ship_goliath_design_bastion', 'Bastion', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(45, 60, 8, 'ship_vengeance_design_avenger', 'Avenger', 180000, 0, 380, 10, 10, 0, 0, 0, 0, '{\"Experience\":25600,\"Honor\":256,\"Credits\":0,\"Uridium\":256}'),
(46, 14, 0, 'pet', 'P.E.T. Green', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":150,\"Credits\":0,\"Uridium\":0}'),
(47, 62, 10, 'ship_goliath_design_exalted', 'Exalted', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(48, 63, 10, 'ship_goliath_design_solace', 'Solace', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(49, 64, 10, 'ship_goliath_design_diminisher', 'Diminisher', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(50, 65, 10, 'ship_goliath_design_spectrum', 'Spectrum', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(51, 66, 10, 'ship_goliath_design_sentinel', 'Sentinel', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(52, 67, 10, 'ship_goliath_design_venom', 'Venom', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(53, 68, 10, 'ship_goliath_design_ignite', 'Ignite', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(54, 69, 69, 'ship_citadel', 'Citadel', 550000, 0, 240, 7, 20, 0, 0, 0, 0, '{\"Experience\":120000,\"Honor\":1200,\"Credits\":0,\"Uridium\":1200}'),
(55, 70, 70, 'ship_spearhead', 'Spearhead', 100000, 0, 370, 5, 12, 0, 0, 0, 0, '{\"Experience\":7500,\"Honor\":75,\"Credits\":0,\"Uridium\":75}'),
(56, 81, 81, 'ship_vengeance_design_pusat', 'Pusat', 125000, 0, 370, 16, 12, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(57, 86, 10, 'ship_goliath_design_kick', 'Kick', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(58, 87, 10, 'ship_goliath_design_referee', 'Referee', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(59, 88, 10, 'ship_goliath_design_goal', 'Goal', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(60, 98, 98, 'ship_police', 'PoliceShip', 1000000, 0, 300, 35, 35, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(61, 109, 10, 'ship_goliath_design_saturn', 'Saturn', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(62, 110, 10, 'ship_goliath_design_centaur', 'Centaur', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(63, 61, 10, 'ship_goliath_design_veteran', 'Veteran', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(64, 140, 10, 'ship_goliath_design_vanquisher', 'Vanquisher', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(65, 141, 10, 'ship_goliath_design_sovereign', 'Sovereign', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(66, 142, 10, 'ship_goliath_design_peacemaker', 'Peacemaker', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(67, 150, 0, 'ship_nostromo_design_diplomat', 'Nostromo Diplomat', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(68, 151, 0, 'ship_nostromo_design_envoy', 'Nostromo Envoy', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(69, 152, 0, 'ship_nostromo_design_ambassador', 'Nostromo Ambassador', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(70, 153, 10, 'ship_goliath_design_goliath-razer', 'Razer', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(71, 154, 0, 'ship_nostromo_design_nostromo-razer', 'Nostromo Razer', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(72, 155, 10, 'ship_goliath_design_turkish', 'Hezarfen', 256000, 0, 300, 15, 15, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(73, 156, 156, 'ship_g-surgeon', 'Surgeon', 256000, 0, 300, 15, 16, 0, 0, 0, 0, '{\"Experience\":51200,\"Honor\":512,\"Credits\":0,\"Uridium\":512}'),
(74, 157, 49, 'ship_aegis_design_aegis-elite', 'Aegis Veteran', 275000, 0, 300, 10, 15, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":250,\"Credits\":0,\"Uridium\":250}'),
(75, 158, 49, 'ship_aegis_design_aegis-superelite', 'Aegis Super Elite', 275000, 0, 300, 10, 15, 0, 0, 0, 0, '{\"Experience\":25000,\"Honor\":250,\"Credits\":0,\"Uridium\":250}'),
(76, 159, 69, 'ship_citadel_design_citadel-elite', 'Citadel Veteran', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(77, 160, 69, 'ship_citadel_design_citadel-superelite', 'Citadel Super Elite', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(78, 161, 70, 'ship_aegis_design_aegis-elite', 'Spearhead Veteran', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(79, 162, 70, 'ship_aegis_design_aegis-superelite', 'Spearhead Super Elite', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(80, 442, 0, 'spaceball_summer', '..::{Spaceball}::..', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(81, 443, 0, 'spaceball_winter', '..::{Spaceball}::..', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(82, 444, 0, 'spaceball_soccer', '..::{Spaceball}::..', 0, 0, 0, 0, 0, 0, 0, 0, 0, '{\"Experience\":0,\"Honor\":0,\"Credits\":0,\"Uridium\":0}'),
(83, 79, 0, 'ship79', '-=[ Kristallon ]=-', 400000, 300000, 250, 1, 1, 100, 0, 4500, 1, '{\"Experience\":51200,\"Honor\":256,\"Credits\":409600,\"Uridium\":128}'),
(84, 78, 0, 'ship78', '-=[ Kristallin ]=-', 50000, 40000, 320, 1, 1, 100, 1, 1100, 1, '{\"Experience\":6400,\"Honor\":32,\"Credits\":12800,\"Uridium\":16}'),
(85, 35, 0, 'ship35', '..::{ Boss Kristallon }::..', 1600000, 1200000, 250, 1, 1, 100, 0, 18000, 1, '{\"Experience\":204800,\"Honor\":1024,\"Credits\":1638400,\"Uridium\":512}'),
(86, 29, 0, 'ship29', '..::{ Boss Kristallin }::..', 200000, 160000, 320, 1, 1, 100, 1, 4000, 1, '{\"Experience\":25600,\"Honor\":128,\"Credits\":51200,\"Uridium\":64}');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `shop_items`
--

CREATE TABLE `shop_items` (
  `id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `priceType` varchar(20) NOT NULL DEFAULT 'uridium',
  `amount` tinyint(1) NOT NULL DEFAULT 0,
  `image` varchar(200) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- A tábla adatainak kiíratása `shop_items`
--

INSERT INTO `shop_items` (`id`, `category`, `name`, `price`, `priceType`, `amount`, `image`, `active`) VALUES
(0, 'drones', 'Apis', 100000, 'uridium', 0, 'do_img/global/drone/apis-5_top.png', 1),
(1, 'drones', 'Zeus', 100000, 'uridium', 0, '/do_img/global/drone/zeus-5_top.png', 1),
(3, 'extras', 'Logdisk', 50, 'uridium', 1, '/do_img/global/resource/logfile_100x100.png', 1);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `chat_permissions`
--
ALTER TABLE `chat_permissions`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `log_event_jpb`
--
ALTER TABLE `log_event_jpb`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `log_player_kills`
--
ALTER TABLE `log_player_kills`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `player_accounts`
--
ALTER TABLE `player_accounts`
  ADD PRIMARY KEY (`userId`);

--
-- A tábla indexei `player_equipment`
--
ALTER TABLE `player_equipment`
  ADD PRIMARY KEY (`userId`);

--
-- A tábla indexei `player_galaxygates`
--
ALTER TABLE `player_galaxygates`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `player_settings`
--
ALTER TABLE `player_settings`
  ADD PRIMARY KEY (`userId`);

--
-- A tábla indexei `player_titles`
--
ALTER TABLE `player_titles`
  ADD PRIMARY KEY (`userID`);

--
-- A tábla indexei `server_bans`
--
ALTER TABLE `server_bans`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `server_battlestations`
--
ALTER TABLE `server_battlestations`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `server_clans`
--
ALTER TABLE `server_clans`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `server_clan_applications`
--
ALTER TABLE `server_clan_applications`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `server_clan_diplomacy`
--
ALTER TABLE `server_clan_diplomacy`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `server_clan_diplomacy_applications`
--
ALTER TABLE `server_clan_diplomacy_applications`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `server_maps`
--
ALTER TABLE `server_maps`
  ADD PRIMARY KEY (`mapID`);

--
-- A tábla indexei `server_ships`
--
ALTER TABLE `server_ships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `shipID` (`shipID`);

--
-- A tábla indexei `shop_items`
--
ALTER TABLE `shop_items`
  ADD PRIMARY KEY (`id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `chat_permissions`
--
ALTER TABLE `chat_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `log_event_jpb`
--
ALTER TABLE `log_event_jpb`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `log_player_kills`
--
ALTER TABLE `log_player_kills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT a táblához `player_accounts`
--
ALTER TABLE `player_accounts`
  MODIFY `userId` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `player_equipment`
--
ALTER TABLE `player_equipment`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `player_galaxygates`
--
ALTER TABLE `player_galaxygates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `player_settings`
--
ALTER TABLE `player_settings`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `player_titles`
--
ALTER TABLE `player_titles`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `server_bans`
--
ALTER TABLE `server_bans`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `server_battlestations`
--
ALTER TABLE `server_battlestations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `server_clans`
--
ALTER TABLE `server_clans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `server_clan_applications`
--
ALTER TABLE `server_clan_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `server_clan_diplomacy`
--
ALTER TABLE `server_clan_diplomacy`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `server_clan_diplomacy_applications`
--
ALTER TABLE `server_clan_diplomacy_applications`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `server_maps`
--
ALTER TABLE `server_maps`
  MODIFY `mapID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=225;

--
-- AUTO_INCREMENT a táblához `server_ships`
--
ALTER TABLE `server_ships`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT a táblához `shop_items`
--
ALTER TABLE `shop_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
