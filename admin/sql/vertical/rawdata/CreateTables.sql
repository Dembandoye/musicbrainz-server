\set ON_ERROR_STOP 1
BEGIN;

CREATE TABLE artist_tag_raw
(
    artist              INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    moderator           INTEGER NOT NULL
);

CREATE TABLE release_tag_raw
(
    release             INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    moderator           INTEGER NOT NULL
);

CREATE TABLE track_tag_raw
(
    track               INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    moderator           INTEGER NOT NULL
);

CREATE TABLE label_tag_raw
(
    label               INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    moderator           INTEGER NOT NULL
);

CREATE TABLE collection_info
(
	id								SERIAL,
	moderator						INTEGER NOT NULL, -- references moderator
	--collection_watch				INTEGER NOT NULL, -- references collection_watch
	collection_ignore_time_range	INTEGER, -- references collection_ignore_time_range
	lastcheck						TIMESTAMP DEFAULT (CURRENT_TIMESTAMP - '7 days'::INTERVAL),
	publiccollection				BOOLEAN NOT NULL, -- publicly display collection?
	emailnotifications				BOOLEAN DEFAULT TRUE, -- send notifications by e-mail?
	notificationinterval			INTEGER DEFAULT 7, -- specifies how many days in advance of a release date the user want to be notified
	ignoreattributes				INTEGER[] DEFAULT '{0,3,4,5,6,7,8,9,10,11,101,102,103}' -- list of attributes to ignore releases of
);

CREATE TABLE collection_ignore_time_range
(
	id				SERIAL,
	rangestart		TIMESTAMP NOT NULL,
	rangeend		TIMESTAMP NOT NULL
);

CREATE TABLE collection_watch_artist_join
(
	id					SERIAL,
	collection_info		INTEGER NOT NULL,
	artist				INTEGER NOT NULL
);

CREATE TABLE collection_discography_artist_join
(
	id					SERIAL,
	collection_info		INTEGER NOT NULl, -- references collection_info
	artist				INTEGER NOT NULL -- references artist
);

CREATE TABLE collection_ignore_release_join
(
	id					SERIAL,
	collection_info		INTEGER NOT NULl, -- references collection_info
	album				INTEGER NOT NULL -- references album
);

CREATE TABLE collection_has_release_join
(
	id					SERIAL,
	collection_info		INTEGER NOT NULl, -- references collection_info
	album				INTEGER NOT NULL -- references album
);

COMMIT;

-- vi: set ts=4 sw=4 et :
