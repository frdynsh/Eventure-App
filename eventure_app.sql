-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 03, 2025 at 04:30 AM
-- Server version: 8.4.3
-- PHP Version: 8.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eventure_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `external_id` varchar(100) NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_date` datetime NOT NULL,
  `venue_name` varchar(255) NOT NULL,
  `image_url` text,
  `personal_notes` text,
  `status` enum('Plan','Going','Done') DEFAULT 'Plan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`id`, `user_id`, `external_id`, `event_name`, `event_date`, `venue_name`, `image_url`, `personal_notes`, `status`) VALUES
(2, 1, 'G5dzZbN6Hg-x7', 'Ultimate Coldplay', '2025-12-13 00:00:00', 'O2 Academy Islington', 'https://s1.ticketm.net/dam/c/ab4/6367448e-7474-4650-bd2d-02a8f7166ab4_106161_TABLET_LANDSCAPE_LARGE_16_9.jpg', '-', 'Plan'),
(3, 1, '17a8vxG6G1Hjxr-', 'BLACKPINK WORLD TOUR <DEADLINE> IN HONG KONG', '2026-01-25 00:00:00', 'Kai Tak Stadium', 'https://s1.ticketm.net/dam/a/201/07e3e636-ad3b-4a21-bbf7-4aa71aa83201_ARTIST_PAGE_3_2.jpg', '-', 'Plan'),
(4, 2, 'vv170ZbgGkRDDzSI', 'Cold Cave', '2026-02-13 00:00:00', 'The Bellwether', 'https://s1.ticketm.net/dam/a/250/be453523-d8dc-4388-93b5-5515734cc250_731351_TABLET_LANDSCAPE_3_2.jpg', '-', 'Plan');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `created_at`) VALUES
(1, 'Ferdi Yansah', 'ferdi@gmail.com', '$2y$12$EbPu.R.KkvNmseRweiu0VO9Dc/MHANDYsbeT85bctesz1qKVFV9Ne', '2025-12-01 15:39:10'),
(2, 'Aril', 'aril@gmail.com', '$2y$12$NFyJshW6.603kiUdGiDwW.Bm9zT6XwXNnHIAoKFySXuZMgdO3DfxO', '2025-12-02 17:31:02');

-- --------------------------------------------------------

--
-- Table structure for table `user_tokens`
--

CREATE TABLE `user_tokens` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `auth_key` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_tokens`
--

INSERT INTO `user_tokens` (`id`, `user_id`, `auth_key`) VALUES
(2, 1, 'd55c8d2d51837f7aa140588a908ebb6781e8ac5e1e05f4435dcf265a3a764afd'),
(3, 1, 'fc010c381de1e3e5001b6d6ddf57699f1dd9ab1a6f34e54c56080fc2dd0c5083'),
(4, 1, '2422835cee5e2591e47a44d7aaa93ffde80b7188754ce42deec09d2e1e60d340'),
(5, 1, '6fd67ff437ccb1d3fc09cdd6ed58ebdc70556e23dc0d95478409b79d3aa7fe31'),
(6, 2, 'a5dcbe579fd6ff59a241d403afdd0881eeed27d8f9be2b7f9f475100afe66f7d'),
(7, 2, 'c4dddf68689537e67e988a86045a4d11454d7f3eda17267169afcd28979cdc62'),
(8, 1, '8f34f5b2c285015da98c9383fc9fe76d120b243c461b5b68cc84b5f2e4e1afa4'),
(9, 2, '87639a6ad37a2de8272f5374f6bc18396104a6ec84d8a103d615bafebb8d64e1'),
(10, 1, 'cc86602284765764ca99ecb92dddf3b6571dff387a62cc8e0ee1c535a0a1c39e'),
(11, 1, '81b7511e2bd4e88bc448b8fbccc13826bab5acc7bf59df36c9c2dbae2c738436'),
(12, 1, '04198f84fe706643a8382212db949e57aa0cd31907ef530d55d48abd67964404'),
(13, 1, '2bb814d9078b9b6c95bba3facfe584185697245f62a462209e5da0febc43c772'),
(14, 1, 'bd132b4f0c742ce836f11d4b020d7353b482faa4ebe40f65c92bc81f5c7c756d'),
(15, 1, '5c3b01f31f5c366a03dc0011abd3b548b8e9014b2fcfa82dd0bbd43fc85ebd41'),
(16, 1, '3b35a860a83ce13441987d781bf5471dff5652241423632d6b358111f6390b53'),
(17, 2, '95b290f12e385087d06aa51d8e14031ea489e1a79f97cc36fb70b95de5d6b932'),
(18, 1, '8968713ed625c23a56c88a3dd06ccffe3ca978a52bb2eba48031603b642adeb2'),
(19, 2, '90cbe01f9a305855ca1fd19a083bf0689ef6aad774fcfc96e5d1ad857435549e'),
(20, 2, 'ceca1e53476d9a17f72e7f6fdc882e458c882154bb1720f05d7f8d1b81c935e0'),
(21, 2, '30a47ae6e3079b7b0b083da33a846c627ed42b5ce15bbbd343f6ec0d7f70e179'),
(22, 2, '181bb327e679db1435f35f0483967c75da32dd5602b1b04c026f418d6886c0d9'),
(23, 2, '22a2e5684f730f57ab1281047600eda5bb587a145c1467cbaa60f0cdfb27617a'),
(24, 1, '9efe16f68e7a6b49f34381e8991bf79296691406588538eb553da200f1f26c45'),
(25, 1, '7d95d7c6d016b7d8fe80370f3781623fd1a3a4aa61b0395e5f5f468eef956338'),
(26, 1, '58a11ab975f52bfa1f92f0e06204660e0539c0c96aae7264edd0a9540fc7bace'),
(27, 1, '078150f6649b35fa230bb96548436904edbe90ccd6a184101ca9d6b33a92d473'),
(28, 1, '37858d1545ee45666732e63056ba9a4fc300ff03f23003b87ff535d58ccd90a2'),
(29, 1, '354feba1bd33554dc2c4fbe0e4487b54667bb0af2dad4d210e51ed6935e9feeb'),
(30, 1, 'ba133371a8ec699016db793ce79c79f7b795d03800cd280b87d525cbe581b701'),
(31, 1, '8441a6da30afaad488b8db881c099db247868174566599e0ed7352742e85dcf7'),
(32, 2, '2aaf19bca48add2988aea2029f794cdb1471f22bc23972aa35a70232b777cb0d'),
(33, 1, 'f2f9db569fe0a1bc7b444716368c979b6760b5e3d09283b09994880b1a9f1ea8'),
(34, 1, 'e619728de6d99befa476bcf6870af7256d67f0c922c086e49cbaac8619796e8b'),
(35, 1, 'a9b7bf3f07e432a72e7dfc8716c4f1233eda2f46e0b4840cc2443cd19d8c0ba8'),
(36, 1, 'e2263ea96e2e2614364ca37510ccc910beb11859ed9c977bdb39877e69e07a1b'),
(37, 1, 'bdaa853c3bb8e2b79e53912fa3a632f9a22fe5936d3a8a8fc25770c0b8a138d9'),
(38, 1, 'ba3169e99a4e4cf1dc85d421b5ee7dfe126ff7f9b30f448816cbeeed1431552f'),
(39, 1, '58b5286f5b9e4e8c09e091ac9345df4ab09faa8aae7fcf48e76ad5fb486b26ff'),
(40, 1, '6a61d807a340bd0ba2cd3b30b653ba8e4d214078c780c6a486f379df4a937028'),
(41, 1, 'db76bd1485161846045d316f5341802b6530c08db124a212f8056d5ee5a07ee7'),
(42, 1, '7223985663f6501b9f57d3b2ac432849663384ac64eef477223b7af88f661e5f'),
(43, 1, '7a8c1cbffd5dec6a3394a1bc2d09d02e97060da131d6b0a223623fdf681ee687'),
(44, 1, '1ee3a1ffa849238ef04b2371e1bf151efd2e11c6b61d419526d7e9de8f5dbe13');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_unique` (`email`);

--
-- Indexes for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_tokens`
--
ALTER TABLE `user_tokens`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
