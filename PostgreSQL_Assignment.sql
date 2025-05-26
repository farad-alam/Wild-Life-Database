-- Active: 1747477737929@@127.0.0.1@5432@conservation_db
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);


CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(255) NOT NULL

);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id) NOT NULL,
    species_id INTEGER REFERENCES species(species_id) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(255) NOT NULL,
    notes TEXT
);



-- Insert Datat to table -------->>>>>>>>
INSERT INTO rangers (name, region) VALUES
( 'Alice Green', 'Northern Hills'),
( 'Bob White', 'River Delta'),
( 'Carol King', 'Mountain Range');

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);




-- QUESTION SOLVING ------------->>>>>>>

-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region) 
VALUES('Derek Fox','Coastal Plains')




-- 2️⃣ Count unique species ever sighted.
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings




-- 3️⃣ Find all sightings where the location includes "Pass".
SELECT * FROM sightings si 
WHERE si.location LIKE '%Pass%'




-- 4️⃣ List each ranger's name and their total number of sightings.

SELECT name, count(*) as total_sighted FROM sightings si
JOIN rangers ra ON si.ranger_id = ra.ranger_id
GROUP BY name 



-- 5️⃣ List species that have never been sighted.
SELECT common_name FROM species sp
WHERE NOT EXISTS (
    SELECT 1 
    FROM sightings si
    WHERE sp.species_id = si.species_id
)




-- 6️⃣ Show the most recent 2 sightings.
SELECT common_name, sighting_time, name FROM sightings si
JOIN species sp ON si.species_id = sp.species_id
JOIN rangers ra ON si.ranger_id = ra.ranger_id
ORDER BY sighting_time DESC LIMIT 2




-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species 
SET conservation_status = 'Historic' 
WHERE EXTRACT(year from discovery_date) < 1800




-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT sighting_id, 
CASE 
    WHEN EXTRACT (hour from sighting_time) < 12 THEN  'Morning'
    WHEN EXTRACT (hour from sighting_time) BETWEEN 12 AND 17 THEN  'Afternoon'
    ELSE 'Evening'
END AS time_of_day
FROM sightings;




-- 9️⃣ Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE NOT EXISTS (
    SELECT 1 
    FROM sightings
    WHERE rangers.ranger_id = sightings.ranger_id
)