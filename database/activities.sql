CREATE DATABASE activities;

USE activities;

CREATE TABLE activities (
  id VARCHAR(50),
  name VARCHAR(255),
  description TEXT,
  maxParticipants INT,
  lastUpdated DATETIME,
  updatedBy VARCHAR(50)
);

INSERT INTO activities (id, name, description, maxParticipants)
VALUES ('abc1234', 'Activity 1', 'Test description', 4);

INSERT INTO activities (id, name, description, maxParticipants)
VALUES ('abc12323', 'Activity 2', 'Test description', 2);
