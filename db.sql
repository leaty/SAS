-- phpMyAdmin SQL Dump
-- version 2.11.8.1deb5+lenny8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 30, 2011 at 04:44 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6-1+lenny9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `iou_tho`
--

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `banid` int(11) NOT NULL auto_increment,
  `player` varchar(30) NOT NULL,
  `reason` varchar(128) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `banner` varchar(30) NOT NULL,
  PRIMARY KEY  (`banid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=87 ;

-- --------------------------------------------------------

--
-- Table structure for table `cw_locations`
--

CREATE TABLE IF NOT EXISTS `cw_locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `x1` float NOT NULL,
  `y1` float NOT NULL,
  `z1` float NOT NULL,
  `ang1` float NOT NULL,
  `x2` float NOT NULL,
  `y2` float NOT NULL,
  `z2` float NOT NULL,
  `ang2` float NOT NULL,
  `xmax` float NOT NULL,
  `xmin` float NOT NULL,
  `ymax` float NOT NULL,
  `ymin` float NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `cw_locations`
--

INSERT INTO `cw_locations` (`id`, `name`, `x1`, `y1`, `z1`, `ang1`, `x2`, `y2`, `z2`, `ang2`, `xmax`, `xmin`, `ymax`, `ymin`) VALUES
(1, 'Advanced Motoring', -2051.75, -142.396, 35.3203, 178.392, -2053.57, -259.802, 35.3274, 358.925, -2011.16, -2096.33, -123.247, -280.893),
(2, 'LW''s Duel Arena (intended for ww)', 2531.42, 2353.98, 4.2179, 358.905, 2533.74, 2395.16, 4.21094, 176.486, 2546.48, 2490.76, 2402.87, 2350.93),
(3, 'Baseball Field', 1353.09, 2113.83, 11.0156, 0.684141, 1356.41, 2185.93, 11.0156, 180.526, 1397.9, 1299.6, 2199.36, 2102.41);

-- --------------------------------------------------------

--
-- Table structure for table `fc_locations`
--

CREATE TABLE IF NOT EXISTS `fc_locations` (
  `fcid` int(11) NOT NULL auto_increment,
  `fcname` varchar(128) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `angle` float NOT NULL,
  `interior` int(11) NOT NULL,
  PRIMARY KEY  (`fcid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `fc_locations`
--

INSERT INTO `fc_locations` (`fcid`, `fcname`, `x`, `y`, `z`, `angle`, `interior`) VALUES
(1, 'Classic FightClub', 2101.7, 2154.96, 17.7592, 47.1506, 0),
(2, 'Desert FightClub', -551.354, 2611, 66.8359, 116.203, 0),
(3, 'Walls FightClub', -2210.13, 824.15, 69.4615, 353.171, 0),
(4, 'LW''s FightClub', 2493.54, 2377.14, 5.1828, 270.369, 0),
(5, 'Dark Garage FightClub', -1851.71, 1281.14, 31.4299, 296.195, 0),
(6, 'Top Garage FightClub', -1856.22, 1285.18, 62.4844, 288.979, 0),
(7, 'Chillground FightClub', -1873.85, 777.779, 113.289, 342.633, 0),
(8, 'Advanced Motoring''s FightClub', -2034.63, -117.137, 38.9219, 161.702, 0),
(9, 'Liberty City''s FightClub', -725.665, 588.3, 1371.97, 0.761047, 1),
(10, 'iou''s FightClub', 1615.32, -1488.46, 14.0864, 143.785, 0),
(11, 'mAzz''s FightClub', 2345.9, 1388.51, 42.8203, 88.9024, 0),
(12, 'Fat Cobra''s FightClub', -1380.73, 650.939, 3.07031, 19.0694, 0),
(13, 'Underwater FightClub', 342.69, -2078.05, -28.2578, 269.833, 0),
(14, 'Pillar - WW Style', 2558.53, 801.88, 5.3158, 272.307, 0),
(15, 'SF Hotel', -1947.32, 1275.55, 52.4453, 129.966, 0),
(16, 'Floater', -1954.68, 788.535, 108.481, 236.486, 0);

-- --------------------------------------------------------

--
-- Table structure for table `gangs`
--

CREATE TABLE IF NOT EXISTS `gangs` (
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `gangid` int(11) NOT NULL,
  `gangname` varchar(20) NOT NULL,
  `gangowner` varchar(24) NOT NULL,
  `colorid` int(11) NOT NULL,
  `members` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `wins` int(11) NOT NULL,
  `losses` int(11) NOT NULL,
  PRIMARY KEY  (`gangid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `kicks`
--

CREATE TABLE IF NOT EXISTS `kicks` (
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `kickid` int(11) NOT NULL auto_increment,
  `player` varchar(30) NOT NULL,
  `reason` varchar(128) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `kicker` varchar(30) NOT NULL,
  PRIMARY KEY  (`kickid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=819 ;

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE IF NOT EXISTS `news` (
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL auto_increment,
  `item` varchar(256) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`date`, `id`, `item`) VALUES
('2010-12-18 22:21:11', 1, 'Join our community!  -->  www.forum.splitmode.net  <--'),
('2010-12-18 23:40:57', 2, 'Create a gang with /gang and invite your friends!'),
('2010-12-19 00:13:24', 3, 'Use /switchmode to switch between modes'),
('2010-12-19 00:14:05', 4, 'Use /cw invite to invite another gang to a war!'),
('2010-12-19 18:55:15', 5, 'Visit our IRC Channels (#SAS.echo, #SAS) at this server: irc.gtanet.com '),
('2010-12-22 17:13:27', 6, 'Buy or sell properties with /property!'),
('2010-12-22 18:03:23', 7, 'Buy a bank account at San Fierro''s Police Department!'),
('2011-03-22 10:57:20', 8, 'The highly anticipated Squad Rush minigame has been released! See /minigames.');

-- --------------------------------------------------------

--
-- Table structure for table `pickups`
--

CREATE TABLE IF NOT EXISTS `pickups` (
  `pickupid` int(11) NOT NULL auto_increment,
  `modelid` int(11) NOT NULL,
  `typeid` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `worldid` int(11) NOT NULL,
  PRIMARY KEY  (`pickupid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

--
-- Dumping data for table `pickups`
--

INSERT INTO `pickups` (`pickupid`, `modelid`, `typeid`, `x`, `y`, `z`, `worldid`) VALUES
(1, 1240, 2, 2099.24, 2193.37, 13.4786, 101),
(2, 1242, 2, 2098.85, 2190.56, 13.4786, 101),
(3, 1242, 2, -551.387, 2609.73, 66.8359, 101),
(4, 1240, 2, -551.496, 2608.06, 66.8359, 101),
(5, 1240, 2, -2198.38, 823.847, 69.4615, 101),
(6, 1242, 2, -2198.51, 828.334, 69.4615, 101),
(7, 1240, 2, 2496.72, 2360.49, 4.2179, 101),
(8, 1242, 2, 2495.28, 2360.77, 4.2179, 101),
(9, 1240, 2, -1856.36, 1288.9, 32.9976, 101),
(10, 1242, 2, -1857.26, 1291.48, 32.9859, 101),
(11, 1240, 2, -1853.78, 1290.26, 62.4844, 101),
(12, 1242, 2, -1854.74, 1292.94, 62.4844, 101),
(13, 1240, 2, -1866.72, 785.532, 113.289, 101),
(14, 1242, 2, -1864.93, 785.753, 113.289, 101),
(15, 1240, 2, -2031.28, -119.939, 39.1026, 101),
(16, 1242, 2, -2029.93, -119.865, 39.1026, 101),
(17, 1240, 2, -739.255, 593.057, 1371.97, 101),
(18, 1242, 2, -737.68, 593.019, 1371.97, 101),
(19, 1240, 2, 1575.75, -1479.15, 14.2135, 101),
(20, 1242, 2, 1575.6, -1478.1, 14.2163, 101),
(21, 1240, 2, 1614.57, -1506.98, 14.2107, 101),
(22, 1242, 2, 1614.25, -1505.84, 14.2136, 101),
(23, 1240, 2, 2347.01, 1390.23, 43.9128, 101),
(24, 1242, 2, 2347.01, 1386.92, 43.9128, 101),
(25, 1240, 2, -1370.41, 662.898, 4.70312, 101),
(26, 1242, 2, -1371.23, 662.313, 4.70312, 101),
(27, 1240, 2, 355.211, -2085.39, -28.2578, -1),
(28, 1242, 2, 354.964, -2087.84, -28.2578, -1),
(29, 1240, 2, 2557.75, 804.52, 5.3158, -1),
(30, 1242, 2, 2557.75, 805.805, 5.3158, -1),
(31, 1240, 2, -1948.13, 1273.85, 52.4453, -1),
(32, 1242, 2, -1948.2, 1272.56, 52.4453, -1),
(33, 1240, 2, -1953.49, 789.728, 108.481, -1),
(34, 1242, 2, -1952.57, 789.733, 108.481, -1);

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `prize` int(11) NOT NULL,
  `earn` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=57 ;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`id`, `name`, `prize`, `earn`, `x`, `y`, `z`) VALUES
(1, 'Paradiso''s Empty Pool', 250, 100, -2694.96, 917.098, 65.829),
(2, 'Santa Flora''s Donuts', 250, 50, -2767.87, 788.754, 52.7812),
(3, 'NO ENTRY', 100, 50, -1979.25, 428.823, 24.9429),
(4, 'I''m hiding in a bush', 250, 150, -1951.51, 668.296, 47.7031),
(5, 'San Fierro''s Church', 100, 50, -1989.9, 1117.92, 54.4688),
(6, 'Otto''s Auto''s', 100, 100, -1657.99, 1206.9, 7.25),
(7, 'San Fierro''s Submarine', 250, 150, -1881.22, 1458.8, 10.891),
(8, 'Financial Building', 150, 100, -1754.08, 964.372, 29.0625),
(9, 'Michelle''s Auto Repair', 120, 80, -1799.83, 1206.61, 25.125),
(10, 'San Fierro Statue', 80, 60, -1935.89, 883.338, 38.5127),
(11, 'You got guts', 100, 60, -1753.66, 885.796, 295.875),
(12, 'SF Train Station', 250, 150, -1973.13, 114.987, 30.5665),
(13, 'SF Fire Dept', 250, 200, -2037.15, 86.191, 42),
(14, 'Advanced Motoring', 150, 80, -2015.45, -104.923, 35.0729),
(15, 'Avispa Country Club', 150, 80, -2720.33, -318.393, 7.84375),
(16, 'Sub Urban', 100, 50, 210.537, -33.0301, 1001.93),
(17, 'Cool House', 100, 50, -2646.22, -3.29641, 22.4438),
(18, 'Queens Pool', 250, 200, -2500.61, 128.682, 24.0343),
(19, 'China Town', 250, 200, -2206.88, 707.277, 56.3817),
(20, 'Burger Hot', 50, 20, 375.597, -61.0913, 1002.66),
(21, 'Pro Stunts', 200, 150, -2566.8, 734.716, 45.0234),
(22, 'San Andreas Federal Mint', 150, 100, -2447.11, 523.016, 34.169),
(23, 'Roof of Gayclub', 150, 100, -2544.19, 190.771, 13.0391),
(24, 'SF Supermarket', 100, 50, -2442.71, 755.202, 35.1719),
(25, 'Lamp says: I like the view', 500, 350, -2619.88, 596.146, 70.5372),
(26, 'San Fierro Bridge', 600, 400, -1531.48, 687.305, 133.051),
(27, 'What the sign says', 800, 600, -2665.21, 1595.06, 217.274),
(28, 'Cool Cable', 150, 100, -2545.64, 1228.13, 39.2594),
(29, 'SF Cargoship', 350, 250, -2478.22, 1544.47, 36.8047),
(30, 'iou''s Cargoship Seat', 1000, 500, -2470.58, 1550.14, 34.1592),
(31, 'SF Garage', 250, 150, -1828.84, 1313.81, 31.8587),
(32, 'You''re now a fish', 500, 200, -1465.11, 1378.45, -32.9919),
(33, 'iou''s Garage', 250, 150, -2105.06, 890.183, 76.7031),
(34, 'Old Factory', 250, 200, -2188.83, -247.996, 40.7195),
(35, 'Hardspotted Tunnel', 150, 100, -2535.61, 41.7101, 8.50781),
(36, 'NRG Spiderman', 150, 100, -2235.79, -109.344, 47.2874),
(37, 'SF Crane', 1000, 800, -2080.51, 296.532, 69.7914),
(38, 'Top of SF Drift Mountain', 250, 150, -2393.62, -589.004, 132.754),
(39, 'SF Airport Parking', 250, 150, -1361.62, -220.638, 6.33594),
(40, 'Squareish Building', 250, 150, -1941.97, 418.402, 35.1719),
(41, 'I see neighborhood', 300, 250, -2651.13, 866.869, 83.5664),
(42, 'iou''s Mansion', 50000, 20000, 1121.71, -2037.03, 69.4364),
(43, 'Plugy''s Tree', 2000, 1000, -2864.9, 2648, 269.854),
(44, 'Bayside Docks', 300, 200, -2381.54, 2216.05, 20.808),
(45, 'Old Cannon Place', 200, 100, -2093.31, 2314.7, 25.9141),
(46, 'Lets dive baby', 500, 300, -608.553, 1924.85, 113.312),
(47, 'Rat House', 400, 200, 237.9, 1858.23, 17.8732),
(48, 'Area 69', 300, 250, 227.859, 1836.62, 25.4177),
(49, 'You''re now officially a star', 2000, 1000, 1229.09, -1125.87, 24.0853),
(50, 'iou''s hideout', 1000, 800, 839.35, -1065.02, 25.1068),
(51, 'SF Police Dept', 150, 50, -1616.08, 686.201, 7.1875),
(52, 'SF ClockTower', 1000, 200, -1480.41, 920.114, 71.3504),
(53, 'SF Ammunation', 80, 20, 299.499, -40.9836, 1001.52),
(54, 'Mini Baseball', 400, 100, -2314.45, 101.246, 35.3984),
(55, 'Wang Cars', 600, 200, -1951.41, 305.351, 41.0471),
(56, 'Pay n Spray', 200, 30, -1904.66, 289.085, 41.0469);

-- --------------------------------------------------------

--
-- Table structure for table `sdm_locations`
--

CREATE TABLE IF NOT EXISTS `sdm_locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `x1` float NOT NULL,
  `y1` float NOT NULL,
  `z1` float NOT NULL,
  `ang1` float NOT NULL,
  `x2` float NOT NULL,
  `y2` float NOT NULL,
  `z2` float NOT NULL,
  `ang2` float NOT NULL,
  `xmax` float NOT NULL,
  `xmin` float NOT NULL,
  `ymax` float NOT NULL,
  `ymin` float NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `sdm_locations`
--

INSERT INTO `sdm_locations` (`id`, `name`, `x1`, `y1`, `z1`, `ang1`, `x2`, `y2`, `z2`, `ang2`, `xmax`, `xmin`, `ymax`, `ymin`) VALUES
(1, 'San Fierro', -2143.58, 808.353, 69.4141, 269.168, -1824.13, 1303.62, 31.8516, 193.812, -1643.92, -2209.59, 1352.38, 770.145),
(2, 'Pershing Square', 1598.16, -1674.13, 5.89062, 11.6375, 1372.98, -1669.93, 13.1041, 270.545, 1602.77, 1367.74, -1599.07, -1726.57),
(5, 'Ruins of a Village', -1196.34, 2518.56, 112.287, 95.4591, -1335.7, 2511.46, 87.0469, 272.478, -1105.02, -1410.59, 2676.43, 2395.89),
(3, 'Fort Carson', -334.53, 1054.95, 19.7392, 85.8722, -110.699, 1133.25, 19.7422, 3.09092, -91.0715, -351.007, 1233.73, 1008.73),
(4, 'Back o Beyond', -447.225, -2188.07, 60.1123, 252.663, -270.098, -2160.14, 28.7425, 114.752, -234.537, -469.734, -2075.17, -2287.55),
(6, 'Whetstone', -1423.92, -1481.52, 101.672, 182.45, -1449.26, -1576.8, 101.758, 357.221, -1372.1, -1533.46, -1427.99, -1602.93),
(7, 'Palomino Creek', 2415.11, 90.5639, 26.471, 179.897, 2261.2, -84.421, 26.5156, 5.60395, 2572.01, 2126.34, 237.122, -148.412),
(8, 'Blueberry Acres', -5.42726, 93.6408, 3.11719, 159.954, -133.126, -93.4408, 3.11808, 353.284, 4.36744, -199.901, 213.662, -186.023),
(9, 'Dillimore', 683.108, -442.191, 16.3359, 181.08, 698.228, -646.143, 16.3359, 2.8054, 920.428, 506.34, -388.365, -713.937),
(10, 'Beacon Hill', -356.982, -1041.63, 59.4049, 273.626, -81.0767, -1019.86, 16.6853, 93.0773, -57.8277, -407.495, -954.156, -1196.18),
(11, 'Flint Range', -378.213, -1434.61, 25.7266, 92.3287, -584.693, -1500.62, 10.0243, 296.414, -341.898, -623.691, -1343.08, -1574.6),
(12, 'Trailer Park', -63.0614, -1542.09, 2.61719, 151.111, -94.0354, -1600.62, 2.61719, 326.167, -30.3964, -122.082, -1520.82, -1630.33),
(13, 'Riverdance LS', 785.321, -1615.58, 13.3828, 92.6105, 675.778, -1672.53, 8.70494, 275.68, 807.114, 642.027, -1585.88, -1765.39),
(14, 'Verdant Bluffs', 1116.28, -2055.48, 74.4297, 180.175, 1193.08, -2327.33, 14.599, 8.05215, 1388.33, 1010.51, -1885.38, -2362),
(15, 'Operation Cargoship', -2513.36, 1544.56, 17.3281, 269.322, -2329.12, 1547.5, 17.3281, 92.0568, -2269.02, -2554.05, 1584.88, 1486.6),
(16, 'Carrier', -1304.75, 500.559, 11.1953, 90.3842, -1431.26, 501.063, 3.03906, 270.324, -1287.58, -1446.2, 517.502, 485.107);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `userid` int(11) NOT NULL auto_increment,
  `username` varchar(20) NOT NULL,
  `password` varchar(1000) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `isban` int(11) NOT NULL,
  `admin` int(11) NOT NULL,
  `playtime` bigint(20) NOT NULL,
  `f_time` bigint(20) NOT NULL,
  `t_time` bigint(20) NOT NULL,
  `gang` varchar(128) NOT NULL,
  `lastfc` int(11) NOT NULL,
  `skinid` int(11) NOT NULL,
  `bankvalue` int(11) NOT NULL,
  `banklevel` int(11) NOT NULL,
  `propcount` int(11) NOT NULL,
  `lootcount` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  PRIMARY KEY  (`userid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2933 ;

