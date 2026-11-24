-- Spotify Music Trends Analysis | PostgreSQL
-- Synthetic tracks for learning. Audio features are illustrative, not sourced from Spotify.
DROP TABLE IF EXISTS tracks;
CREATE TABLE tracks (
 track_id INT PRIMARY KEY, track_name VARCHAR(80), artist VARCHAR(50), release_year INT,
 genre VARCHAR(25), popularity INT, danceability NUMERIC(3,2), energy NUMERIC(3,2),
 duration_sec INT, streams_millions NUMERIC(8,2)
);
INSERT INTO tracks VALUES
(1,'Neon Drive','Aster Lane',2022,'Pop',82,.78,.84,198,125.4),
(2,'Quiet Rain','Mira Sol',2021,'Indie',71,.52,.38,224,48.2),
(3,'Night Runner','Aster Lane',2024,'Electronic',89,.81,.91,205,210.8),
(4,'Golden Hour','Mira Sol',2023,'Pop',86,.69,.61,216,156.3),
(5,'Old Roads','The North',2019,'Rock',74,.48,.88,242,62.1),
(6,'Blue Window','Mira Sol',2020,'Indie',68,.58,.42,231,39.7),
(7,'Pulse City','The North',2025,'Electronic',91,.86,.93,190,245.6),
(8,'Open Skies','Aster Lane',2023,'Pop',79,.72,.70,202,98.5),
(9,'Slow Motion','The North',2022,'Rock',77,.55,.76,238,84.9),
(10,'Afterglow','Mira Sol',2025,'Indie',88,.63,.57,219,177.2);
-- 1. Catalogue KPIs
SELECT COUNT(*) AS tracks, COUNT(DISTINCT artist) AS artists,
 ROUND(AVG(popularity),1) AS avg_popularity, SUM(streams_millions) AS streams_millions
FROM tracks;
-- 2. Artist performance
SELECT artist, COUNT(*) AS tracks, ROUND(AVG(popularity),1) AS avg_popularity,
 SUM(streams_millions) AS streams_millions
FROM tracks GROUP BY artist ORDER BY streams_millions DESC;
-- 3. Genre performance
SELECT genre, COUNT(*) AS tracks, ROUND(AVG(popularity),1) AS avg_popularity,
 ROUND(AVG(energy),2) AS avg_energy, SUM(streams_millions) AS streams_millions
FROM tracks GROUP BY genre ORDER BY streams_millions DESC;
-- 4. Popularity vs streams
SELECT track_name, artist, popularity, streams_millions,
 DENSE_RANK() OVER (ORDER BY streams_millions DESC) AS stream_rank
FROM tracks ORDER BY stream_rank;
-- 5. Release-year catalogue
SELECT release_year, COUNT(*) AS tracks, ROUND(AVG(popularity),1) AS avg_popularity
FROM tracks GROUP BY release_year ORDER BY release_year;
-- 6. Audio profile by popularity band
SELECT CASE WHEN popularity>=85 THEN 'High' WHEN popularity>=75 THEN 'Medium' ELSE 'Emerging' END AS popularity_band,
 ROUND(AVG(danceability),2) AS avg_danceability, ROUND(AVG(energy),2) AS avg_energy
FROM tracks GROUP BY 1;
-- 7. Longest tracks
SELECT track_name, artist, duration_sec, ROUND(duration_sec/60.0,2) AS minutes
FROM tracks ORDER BY duration_sec DESC LIMIT 5;
-- 8. Artist track-level running streams
SELECT artist, track_name, streams_millions,
 SUM(streams_millions) OVER (PARTITION BY artist ORDER BY streams_millions DESC) AS artist_running_streams
FROM tracks ORDER BY artist,streams_millions DESC;
