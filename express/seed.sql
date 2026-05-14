-- Iceberg Gaming Website — MySQL Seed File
-- Reconstructed from Express API source code (express-api branch)
-- Run: mysql -u <user> -p < seed.sql

CREATE DATABASE IF NOT EXISTS iceberg_gaming CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE iceberg_gaming;

-- --------------------------------------------------------
-- USERS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id         INT            NOT NULL AUTO_INCREMENT,
  createdAt  DATETIME       NOT NULL,
  discord    VARCHAR(100)   NOT NULL DEFAULT '',
  email      VARCHAR(255)   NOT NULL,
  password   VARCHAR(32)    NOT NULL,  -- MD5 hash
  username   VARCHAR(100)   NOT NULL,
  photoURL   VARCHAR(500)   DEFAULT NULL,
  status     VARCHAR(255)   DEFAULT NULL,
  isDeleted  TINYINT(1)     NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- USER ROLES
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_roles (
  id      INT          NOT NULL AUTO_INCREMENT,
  userID  INT          NOT NULL,
  role    VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_user_roles_userID (userID),
  CONSTRAINT fk_user_roles_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- TOKENS  (refresh tokens — one row per active session)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS tokens (
  token  VARCHAR(512) NOT NULL,
  id     INT          NOT NULL,  -- FK to users.id
  PRIMARY KEY (token),
  KEY idx_tokens_id (id),
  CONSTRAINT fk_tokens_user FOREIGN KEY (id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- APPLICATIONS  (master registry)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS applications (
  id             INT          NOT NULL AUTO_INCREMENT,
  userID         INT          NOT NULL,
  division       VARCHAR(50)  NOT NULL,  -- '17th', 'Iceberg', 'CGS'
  applicationID  INT          NOT NULL,  -- FK into the division-specific table
  createdAt      DATETIME     NOT NULL,
  PRIMARY KEY (id),
  KEY idx_applications_userID (userID),
  CONSTRAINT fk_applications_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 17TH APPLICATIONS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS 17th_applications (
  id            INT           NOT NULL AUTO_INCREMENT,
  userID        INT           NOT NULL,
  createdAt     DATETIME      NOT NULL,
  steamURL      VARCHAR(500)  NOT NULL,
  timezone      VARCHAR(100)  NOT NULL,
  age           VARCHAR(10)   NOT NULL,
  arma3Hours    VARCHAR(20)   NOT NULL,
  hobbies       TEXT          NOT NULL,
  whyJoin       TEXT          NOT NULL,
  attractmilsim TEXT          NOT NULL,
  ranger        TINYINT(1)    NOT NULL DEFAULT 0,
  medic         TINYINT(1)    NOT NULL DEFAULT 0,
  sapper        TINYINT(1)    NOT NULL DEFAULT 0,
  pilot         TINYINT(1)    NOT NULL DEFAULT 0,
  tank_crew     TINYINT(1)    NOT NULL DEFAULT 0,
  idf           TINYINT(1)    NOT NULL DEFAULT 0,
  attendOps     TINYINT(1)    NOT NULL DEFAULT 0,
  status        VARCHAR(50)   NOT NULL DEFAULT 'Waiting',  -- 'Waiting', 'Processed', 'Approved', 'Denied'
  comment       TEXT          DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_17th_applications_userID (userID),
  CONSTRAINT fk_17th_applications_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- ICEBERG APPLICATIONS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS iceberg_applications (
  id                       INT           NOT NULL AUTO_INCREMENT,
  userID                   INT           NOT NULL,
  createdAt                DATETIME      NOT NULL,
  steamURL                 VARCHAR(500)  NOT NULL,
  age                      VARCHAR(10)   NOT NULL,
  hobbies                  TEXT          NOT NULL,
  gamesTheyJoinFor         TEXT          NOT NULL,
  hoursInGamesTheyJoinFor  VARCHAR(20)   NOT NULL,
  areYouInAnyCommunities   TEXT          NOT NULL,
  whyJoin                  TEXT          NOT NULL,
  whereDidYouHearUsFrom    TEXT          NOT NULL,
  status                   VARCHAR(50)   NOT NULL DEFAULT 'Waiting',  -- 'Waiting', 'Processed', 'Approved', 'Denied'
  comment                  TEXT          DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_iceberg_applications_userID (userID),
  CONSTRAINT fk_iceberg_applications_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- CGS APPLICATIONS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS cgs_applications (
  id                    INT           NOT NULL AUTO_INCREMENT,
  userID                INT           NOT NULL,
  createdAt             DATETIME      NOT NULL,
  steamURL              VARCHAR(500)  NOT NULL,
  age                   VARCHAR(10)   NOT NULL,
  playstyle             TEXT          NOT NULL,
  squadron              VARCHAR(100)  NOT NULL,
  whyJoin               TEXT          NOT NULL,
  whereDidYouHearAboutUs TEXT         NOT NULL,
  status                VARCHAR(50)   NOT NULL DEFAULT 'Waiting',  -- 'Waiting', 'Processed', 'Approved', 'Denied'
  comment               TEXT          DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_cgs_applications_userID (userID),
  CONSTRAINT fk_cgs_applications_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- LEAVE OF ABSENCE
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS loas (
  id         INT          NOT NULL AUTO_INCREMENT,
  userID     INT          NOT NULL,
  startDate  DATETIME     NOT NULL,
  endDate    DATETIME     NOT NULL,
  reason     TEXT         NOT NULL,
  isDeleted  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_loas_userID (userID),
  CONSTRAINT fk_loas_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- CHANNELS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS channels (
  id         INT          NOT NULL AUTO_INCREMENT,
  name       VARCHAR(255) NOT NULL,
  division   VARCHAR(50)  NOT NULL,  -- '17th', 'Iceberg', 'CGS'
  type       VARCHAR(50)  NOT NULL,  -- 'calendar', 'forum', 'documents'
  createdAt  DATETIME     NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- CALENDAR EVENTS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS channels_calendar_events (
  id          INT           NOT NULL AUTO_INCREMENT,
  channelID   INT           NOT NULL,
  userID      INT           NOT NULL,
  title       VARCHAR(255)  NOT NULL,
  description TEXT          NOT NULL DEFAULT '<p>No Description</p>',
  start       DATETIME      NOT NULL,
  end         DATETIME      NOT NULL,
  color       VARCHAR(50)   NOT NULL,
  createdAt   DATETIME      NOT NULL,
  PRIMARY KEY (id),
  KEY idx_cal_events_channelID (channelID),
  KEY idx_cal_events_userID (userID),
  CONSTRAINT fk_cal_events_channel FOREIGN KEY (channelID) REFERENCES channels (id),
  CONSTRAINT fk_cal_events_user    FOREIGN KEY (userID)    REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- CALENDAR ATTENDANCE
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS channels_calendar_attendance (
  id         INT         NOT NULL AUTO_INCREMENT,
  eventID    INT         NOT NULL,
  channelID  INT         NOT NULL,
  userID     INT         NOT NULL,
  status     VARCHAR(20) NOT NULL,  -- 'Going', 'Maybe', 'Declined'
  PRIMARY KEY (id),
  KEY idx_cal_attendance_eventID   (eventID),
  KEY idx_cal_attendance_channelID (channelID),
  KEY idx_cal_attendance_userID    (userID),
  CONSTRAINT fk_cal_attendance_event   FOREIGN KEY (eventID)   REFERENCES channels_calendar_events (id),
  CONSTRAINT fk_cal_attendance_channel FOREIGN KEY (channelID) REFERENCES channels (id),
  CONSTRAINT fk_cal_attendance_user    FOREIGN KEY (userID)    REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- FORUM TOPICS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS channels_forums_topics (
  id         INT           NOT NULL AUTO_INCREMENT,
  channelID  INT           NOT NULL,
  userID     INT           NOT NULL,
  title      VARCHAR(255)  NOT NULL,
  body       TEXT          NOT NULL,
  createdAt  DATETIME      NOT NULL,
  PRIMARY KEY (id),
  KEY idx_forum_topics_channelID (channelID),
  KEY idx_forum_topics_userID    (userID),
  CONSTRAINT fk_forum_topics_channel FOREIGN KEY (channelID) REFERENCES channels (id),
  CONSTRAINT fk_forum_topics_user    FOREIGN KEY (userID)    REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- FORUM REPLIES
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS channels_forums_replies (
  id         INT       NOT NULL AUTO_INCREMENT,
  topicID    INT       NOT NULL,
  channelID  INT       NOT NULL,
  userID     INT       NOT NULL,
  body       TEXT      NOT NULL,
  createdAt  DATETIME  NOT NULL,
  PRIMARY KEY (id),
  KEY idx_forum_replies_topicID   (topicID),
  KEY idx_forum_replies_channelID (channelID),
  KEY idx_forum_replies_userID    (userID),
  CONSTRAINT fk_forum_replies_topic   FOREIGN KEY (topicID)   REFERENCES channels_forums_topics (id),
  CONSTRAINT fk_forum_replies_channel FOREIGN KEY (channelID) REFERENCES channels (id),
  CONSTRAINT fk_forum_replies_user    FOREIGN KEY (userID)    REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- DOCUMENTS (PDF metadata)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS channels_documents_pdfs (
  id         INT           NOT NULL AUTO_INCREMENT,
  channelID  INT           NOT NULL,
  userID     INT           NOT NULL,
  filename   VARCHAR(500)  NOT NULL,
  name       VARCHAR(255)  NOT NULL,
  createdAt  DATETIME      NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_documents_filename (filename),
  KEY idx_documents_channelID (channelID),
  KEY idx_documents_userID    (userID),
  CONSTRAINT fk_documents_channel FOREIGN KEY (channelID) REFERENCES channels (id),
  CONSTRAINT fk_documents_user    FOREIGN KEY (userID)    REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- DISCIPLINARY ACTION FORMS
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS disciplinary_action_forms (
  id                INT           NOT NULL AUTO_INCREMENT,
  userID            INT           NOT NULL,
  offender          VARCHAR(255)  NOT NULL,
  division          VARCHAR(50)   NOT NULL,
  date              DATETIME      NOT NULL,
  whereDidThisOccur TEXT          NOT NULL,
  witnesses         TEXT          NOT NULL,
  explanation       TEXT          NOT NULL,
  infraction        TEXT          NOT NULL,
  whatPunishment    TEXT          NOT NULL,
  actualPunishment  TEXT          DEFAULT NULL,
  whoPunished       VARCHAR(255)  DEFAULT NULL,
  comment           TEXT          DEFAULT NULL,
  createdAt         DATETIME      NOT NULL,
  PRIMARY KEY (id),
  KEY idx_daf_userID (userID),
  CONSTRAINT fk_daf_user FOREIGN KEY (userID) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- SEED DATA
-- Admin account: vinniehat@gmail.com
-- Default password: "password"  (MD5: 5f4dcc3b5aa765d61d8327deb882cf99)
-- IMPORTANT: Change this password immediately after first login via the settings page.
-- --------------------------------------------------------
INSERT INTO users (createdAt, discord, email, password, username, status, isDeleted)
VALUES ('2021-01-01 00:00:00', '', 'vinniehat@gmail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Vinnie', NULL, 0);

INSERT INTO user_roles (userID, role) VALUES (1, '[ICE] Member');
INSERT INTO user_roles (userID, role) VALUES (1, '[ICE] Webmaster');
