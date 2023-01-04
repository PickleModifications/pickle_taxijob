INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('taxi', 'Taxi Company', '1');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES ('taxi', '0', 'recruit', 'Recruit', '0', '{}', '{}');
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES ('taxi', '0', 'employee', 'Driver', '0', '{}', '{}');
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES ('taxi', '0', 'manager', 'Lead Driver', '0', '{}', '{}');
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES ('taxi', '0', 'boss', 'Owner', '0', '{}', '{}');

-- RUN THE BELOW IF USING ESX SOCIETY

INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_taxi', 'Taxi Company', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_taxi', 'Taxi Company',1)
;