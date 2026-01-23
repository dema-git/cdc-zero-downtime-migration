-- This is the dump of the legacy database.
-- It contains 'outdated' tables and raw historical data that must be
-- cleaned, normalized, and transformed into the 'clean' database format.
-- The legacy database is initialized from this dump during container build.
-- A Faker-based generator also writes synthetic data here every N seconds.


--
-- PostgreSQL database dump
--

\restrict TbqhnzEnD3RxVzojAxYevsjM4AYQMMpJ96S6untf37czz8I4obMws7vfltpnN2H

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.10

-- Started on 2026-01-07 20:39:50 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3434 (class 1262 OID 16384)
-- Name: legacy; Type: DATABASE; Schema: -; Owner: postgres
--

ALTER DATABASE legacy OWNER TO postgres;

\unrestrict TbqhnzEnD3RxVzojAxYevsjM4AYQMMpJ96S6untf37czz8I4obMws7vfltpnN2H
\connect legacy
\restrict TbqhnzEnD3RxVzojAxYevsjM4AYQMMpJ96S6untf37czz8I4obMws7vfltpnN2H

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16386)
-- Name: legacy_customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.legacy_customers (
    id bigint NOT NULL,
    full_name character varying(200) NOT NULL,
    email character varying(200),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.legacy_customers OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16385)
-- Name: legacy_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.legacy_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.legacy_customers_id_seq OWNER TO postgres;

--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 215
-- Name: legacy_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.legacy_customers_id_seq OWNED BY public.legacy_customers.id;


--
-- TOC entry 218 (class 1259 OID 16394)
-- Name: legacy_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.legacy_orders (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    warehouse_city character varying(100) NOT NULL,
    warehouse_country character varying(100) NOT NULL,
    capacity integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.legacy_orders OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16393)
-- Name: legacy_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.legacy_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.legacy_orders_id_seq OWNER TO postgres;

--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 217
-- Name: legacy_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.legacy_orders_id_seq OWNED BY public.legacy_orders.id;


--
-- TOC entry 3272 (class 2604 OID 16389)
-- Name: legacy_customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legacy_customers ALTER COLUMN id SET DEFAULT nextval('public.legacy_customers_id_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 16397)
-- Name: legacy_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legacy_orders ALTER COLUMN id SET DEFAULT nextval('public.legacy_orders_id_seq'::regclass);


--
-- TOC entry 3426 (class 0 OID 16386)
-- Dependencies: 216
-- Data for Name: legacy_customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.legacy_customers VALUES
	(1, 'Amanda Holt', 'josephwilliams@example.org', '2026-01-07 20:31:55.37395'),
	(2, 'Jerry Johnson', 'llang@example.com', '2026-01-07 20:31:55.37395'),
	(3, 'Danielle Garrison', 'paul34@example.org', '2026-01-07 20:31:55.37395'),
	(4, 'Spencer Thomas', 'fordalexander@example.net', '2026-01-07 20:31:55.37395'),
	(5, 'David Wilkinson', 'jasonadams@example.org', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(6, 'Karen Jenkins', 'iedwards@example.net', '2026-01-07 20:31:55.37395'),
	(7, 'Gary Johnson', 'cgraves@example.com', '2026-01-07 20:31:55.37395'),
	(8, 'David Young', 'kevinjohnson@example.org', '2026-01-07 20:31:55.37395'),
	(9, 'Sean Reyes', 'david29@example.org', '2026-01-07 20:31:55.37395'),
	(10, 'David Klein', 'acabrera@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(11, 'Paige Sherman', 'grichardson@example.com', '2026-01-07 20:31:55.37395'),
	(12, 'Cindy Le', 'gina65@example.com', '2026-01-07 20:31:55.37395'),
	(13, 'Nathan Hill', 'craig53@example.org', '2026-01-07 20:31:55.37395'),
	(14, 'Ronald Bryant', 'cody65@example.net', '2026-01-07 20:31:55.37395'),
	(15, 'Chris Doyle', 'pthomas@example.org', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(16, 'Mrs. Lauren Elliott', 'jessica79@example.net', '2026-01-07 20:31:55.37395'),
	(17, 'Laura Olson', 'hayesalyssa@example.com', '2026-01-07 20:31:55.37395'),
	(18, 'Christopher Lee', 'sarathomas@example.net', '2026-01-07 20:31:55.37395'),
	(19, 'Monique Martin', 'robertsonjennifer@example.com', '2026-01-07 20:31:55.37395'),
	(20, 'Dennis Martin', 'taylorcarrie@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(21, 'Krista Mooney', 'loganhurley@example.org', '2026-01-07 20:31:55.37395'),
	(22, 'Robert Thompson', 'zbryant@example.net', '2026-01-07 20:31:55.37395'),
	(23, 'Raymond Brown DDS', 'shawnvargas@example.com', '2026-01-07 20:31:55.37395'),
	(24, 'Janice Johnston', 'hughescory@example.org', '2026-01-07 20:31:55.37395'),
	(25, 'Austin Lee', 'david68@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(26, 'Matthew Turner', 'katiewalker@example.com', '2026-01-07 20:31:55.37395'),
	(27, 'Kristen Powell', 'elijahhobbs@example.net', '2026-01-07 20:31:55.37395'),
	(28, 'Jonathan Carter', 'cainchristine@example.org', '2026-01-07 20:31:55.37395'),
	(29, 'Brittany Chavez', 'kdaniels@example.net', '2026-01-07 20:31:55.37395'),
	(30, 'Stacey Rogers', 'francisco85@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(31, 'Christina Johnson', 'mark75@example.com', '2026-01-07 20:31:55.37395'),
	(32, 'Bryce Ferrell', 'xavierfigueroa@example.net', '2026-01-07 20:31:55.37395'),
	(33, 'David Henderson Jr.', 'andrewschmidt@example.org', '2026-01-07 20:31:55.37395'),
	(34, 'Emily Wall', 'lsmith@example.org', '2026-01-07 20:31:55.37395'),
	(35, 'Charles Cox', 'ryan76@example.net', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(36, 'Jerry Hamilton', 'patrickrodriguez@example.net', '2026-01-07 20:31:55.37395'),
	(37, 'Kevin Miller', 'michellesanders@example.org', '2026-01-07 20:31:55.37395'),
	(38, 'Patricia Harris', 'pwood@example.com', '2026-01-07 20:31:55.37395'),
	(39, 'Angela Harris', 'jessica79@example.org', '2026-01-07 20:31:55.37395'),
	(40, 'Brandy Price', 'brownmichele@example.org', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(41, 'Christopher Moreno', 'torresfelicia@example.com', '2026-01-07 20:31:55.37395'),
	(42, 'Brittany Wagner', 'lisa61@example.org', '2026-01-07 20:31:55.37395'),
	(43, 'Brian Wilson', 'davidrush@example.org', '2026-01-07 20:31:55.37395'),
	(44, 'Jenna Bowen', 'showard@example.org', '2026-01-07 20:31:55.37395'),
	(45, 'Ashlee Coleman', 'abigail07@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(46, 'Lisa Reid', 'romerojoshua@example.org', '2026-01-07 20:31:55.37395'),
	(47, 'Martin Harper', 'michaelmiller@example.com', '2026-01-07 20:31:55.37395'),
	(48, 'Sarah Fernandez', 'anthonymaxwell@example.com', '2026-01-07 20:31:55.37395'),
	(49, 'Alison Thompson', 'brenda09@example.com', '2026-01-07 20:31:55.37395'),
	(50, 'Robin Burgess MD', 'joshua86@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(51, 'Darren Kelly', 'robertsrobert@example.com', '2026-01-07 20:31:55.37395'),
	(52, 'Wendy Flores', 'hollykoch@example.com', '2026-01-07 20:31:55.37395'),
	(53, 'Laura Bell', 'abooth@example.org', '2026-01-07 20:31:55.37395'),
	(54, 'Phillip Clark', 'wle@example.net', '2026-01-07 20:31:55.37395'),
	(55, 'Cameron Chavez', 'stanleylarry@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(56, 'Brian Esparza', 'franklinmichelle@example.org', '2026-01-07 20:31:55.37395'),
	(57, 'Rebecca Martin MD', 'dianesanders@example.com', '2026-01-07 20:31:55.37395'),
	(58, 'Angel Castaneda', 'brownrobin@example.net', '2026-01-07 20:31:55.37395'),
	(59, 'Melissa Wheeler', 'castroherbert@example.com', '2026-01-07 20:31:55.37395'),
	(60, 'Anthony Bowman', 'phillipsdouglas@example.net', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(61, 'Kimberly Patel', 'jackmayer@example.com', '2026-01-07 20:31:55.37395'),
	(62, 'Cheryl Campos', 'jnewton@example.com', '2026-01-07 20:31:55.37395'),
	(63, 'Monica Flores MD', 'johnstonrebecca@example.com', '2026-01-07 20:31:55.37395'),
	(64, 'Donald Alexander', 'juliewagner@example.net', '2026-01-07 20:31:55.37395'),
	(65, 'Carlos Salazar', 'andersonchristopher@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(66, 'Jennifer Adkins', 'leeaaron@example.org', '2026-01-07 20:31:55.37395'),
	(67, 'Thomas Wright', 'handerson@example.com', '2026-01-07 20:31:55.37395'),
	(68, 'Timothy Graham', 'ianmaxwell@example.com', '2026-01-07 20:31:55.37395'),
	(69, 'Christopher Baldwin', 'thomasmariah@example.net', '2026-01-07 20:31:55.37395'),
	(70, 'John Gonzalez Jr.', 'smithwayne@example.org', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(71, 'Samuel Clark', 'silvarobert@example.com', '2026-01-07 20:31:55.37395'),
	(72, 'Ashley Ross', 'kelly94@example.com', '2026-01-07 20:31:55.37395'),
	(73, 'Ricky Jones', 'jamesmonica@example.com', '2026-01-07 20:31:55.37395'),
	(74, 'Christopher Lloyd', 'charles52@example.net', '2026-01-07 20:31:55.37395'),
	(75, 'Joshua Burke', 'jonesabigail@example.com', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(76, 'Leroy Ortiz', 'ibutler@example.org', '2026-01-07 20:31:55.37395'),
	(77, 'Maria Stokes', 'mandy94@example.net', '2026-01-07 20:31:55.37395'),
	(78, 'Robert Valdez', 'robinsonjudy@example.com', '2026-01-07 20:31:55.37395'),
	(79, 'Ralph Mendez', 'imiller@example.net', '2026-01-07 20:31:55.37395'),
	(80, 'Erin White', 'steventorres@example.org', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(81, 'Mr. David Harris', 'stephengutierrez@example.org', '2026-01-07 20:31:55.37395'),
	(82, 'Amy Valenzuela', 'sandra12@example.net', '2026-01-07 20:31:55.37395'),
	(83, 'Tina Richard', 'portermaria@example.net', '2026-01-07 20:31:55.37395'),
	(84, 'Laura Green', 'connormckee@example.net', '2026-01-07 20:31:55.37395'),
	(85, 'Daniel Chavez', 'jvilla@example.org', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(86, 'Manuel Kaiser', 'jasonmathis@example.org', '2026-01-07 20:31:55.37395'),
	(87, 'Todd Bennett', 'jenniferturner@example.net', '2026-01-07 20:31:55.37395'),
	(88, 'Jessica Oconnor', 'chentiffany@example.com', '2026-01-07 20:31:55.37395'),
	(89, 'Dennis Duran', 'jasonkelly@example.org', '2026-01-07 20:31:55.37395'),
	(90, 'Samuel Skinner II', 'bmartin@example.net', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(91, 'Brian Cole', 'amberbaker@example.net', '2026-01-07 20:31:55.37395'),
	(92, 'Jeffery Brown', 'mistymassey@example.org', '2026-01-07 20:31:55.37395'),
	(93, 'Austin Jones', 'laura27@example.org', '2026-01-07 20:31:55.37395'),
	(94, 'Lisa Larsen', 'jperry@example.com', '2026-01-07 20:31:55.37395'),
	(95, 'Sean Thomas', 'michael85@example.net', '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_customers VALUES
	(96, 'Kelly Sutton', 'wilsonamy@example.com', '2026-01-07 20:31:55.37395'),
	(97, 'Denise Davis', 'knighteric@example.org', '2026-01-07 20:31:55.37395'),
	(98, 'Shawn Holland', 'cindyleonard@example.com', '2026-01-07 20:31:55.37395'),
	(99, 'Jonathan Perez', 'jasonbenton@example.org', '2026-01-07 20:31:55.37395'),
	(100, 'Victoria Gonzales', 'richardsmith@example.com', '2026-01-07 20:31:55.37395');


--
-- TOC entry 3428 (class 0 OID 16394)
-- Dependencies: 218
-- Data for Name: legacy_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.legacy_orders VALUES
	(1, 71, 'Vienna', 'Austria', 82, '2026-01-07 20:31:55.37395'),
	(2, 32, 'Amsterdam', 'Netherlands', 42, '2026-01-07 20:31:55.37395'),
	(3, 46, 'Warsaw', 'Poland', 16, '2026-01-07 20:31:55.37395'),
	(4, 71, 'Warsaw', 'Poland', 74, '2026-01-07 20:31:55.37395'),
	(5, 61, 'Berlin', 'Germany', 5, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(6, 31, 'Amsterdam', 'Netherlands', 88, '2026-01-07 20:31:55.37395'),
	(7, 53, 'Amsterdam', 'Netherlands', 31, '2026-01-07 20:31:55.37395'),
	(8, 3, 'Vienna', 'Austria', 66, '2026-01-07 20:31:55.37395'),
	(9, 4, 'Prague', 'Czech Republic', 60, '2026-01-07 20:31:55.37395'),
	(10, 62, 'Stockholm', 'Sweden', 1, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(11, 71, 'Prague', 'Czech Republic', 14, '2026-01-07 20:31:55.37395'),
	(12, 39, 'Stockholm', 'Sweden', 18, '2026-01-07 20:31:55.37395'),
	(13, 58, 'Vienna', 'Austria', 14, '2026-01-07 20:31:55.37395'),
	(14, 75, 'Paris', 'France', 97, '2026-01-07 20:31:55.37395'),
	(15, 100, 'Warsaw', 'Poland', 38, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(16, 75, 'Berlin', 'Germany', 58, '2026-01-07 20:31:55.37395'),
	(17, 6, 'Warsaw', 'Poland', 78, '2026-01-07 20:31:55.37395'),
	(18, 87, 'Helsinki', 'Finland', 71, '2026-01-07 20:31:55.37395'),
	(19, 74, 'Paris', 'France', 35, '2026-01-07 20:31:55.37395'),
	(20, 97, 'Stockholm', 'Sweden', 47, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(21, 30, 'Warsaw', 'Poland', 73, '2026-01-07 20:31:55.37395'),
	(22, 14, 'Prague', 'Czech Republic', 65, '2026-01-07 20:31:55.37395'),
	(23, 27, 'Amsterdam', 'Netherlands', 29, '2026-01-07 20:31:55.37395'),
	(24, 89, 'Madrid', 'Spain', 98, '2026-01-07 20:31:55.37395'),
	(25, 98, 'Warsaw', 'Poland', 96, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(26, 78, 'Stockholm', 'Sweden', 67, '2026-01-07 20:31:55.37395'),
	(27, 3, 'Warsaw', 'Poland', 63, '2026-01-07 20:31:55.37395'),
	(28, 79, 'Paris', 'France', 34, '2026-01-07 20:31:55.37395'),
	(29, 66, 'Paris', 'France', 86, '2026-01-07 20:31:55.37395'),
	(30, 88, 'Rome', 'Italy', 12, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(31, 37, 'Rome', 'Italy', 47, '2026-01-07 20:31:55.37395'),
	(32, 55, 'Vienna', 'Austria', 57, '2026-01-07 20:31:55.37395'),
	(33, 33, 'Amsterdam', 'Netherlands', 26, '2026-01-07 20:31:55.37395'),
	(34, 55, 'Rome', 'Italy', 43, '2026-01-07 20:31:55.37395'),
	(35, 9, 'Berlin', 'Germany', 17, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(36, 21, 'Vienna', 'Austria', 99, '2026-01-07 20:31:55.37395'),
	(37, 23, 'Prague', 'Czech Republic', 9, '2026-01-07 20:31:55.37395'),
	(38, 29, 'Rome', 'Italy', 84, '2026-01-07 20:31:55.37395'),
	(39, 69, 'Prague', 'Czech Republic', 43, '2026-01-07 20:31:55.37395'),
	(40, 95, 'Paris', 'France', 63, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(41, 12, 'Amsterdam', 'Netherlands', 81, '2026-01-07 20:31:55.37395'),
	(42, 83, 'Rome', 'Italy', 43, '2026-01-07 20:31:55.37395'),
	(43, 99, 'Prague', 'Czech Republic', 32, '2026-01-07 20:31:55.37395'),
	(44, 69, 'Paris', 'France', 42, '2026-01-07 20:31:55.37395'),
	(45, 96, 'Warsaw', 'Poland', 85, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(46, 40, 'Warsaw', 'Poland', 50, '2026-01-07 20:31:55.37395'),
	(47, 53, 'Stockholm', 'Sweden', 34, '2026-01-07 20:31:55.37395'),
	(48, 97, 'Helsinki', 'Finland', 75, '2026-01-07 20:31:55.37395'),
	(49, 50, 'Madrid', 'Spain', 85, '2026-01-07 20:31:55.37395'),
	(50, 83, 'Rome', 'Italy', 31, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(51, 62, 'Warsaw', 'Poland', 86, '2026-01-07 20:31:55.37395'),
	(52, 22, 'Helsinki', 'Finland', 28, '2026-01-07 20:31:55.37395'),
	(53, 36, 'Amsterdam', 'Netherlands', 39, '2026-01-07 20:31:55.37395'),
	(54, 33, 'Paris', 'France', 24, '2026-01-07 20:31:55.37395'),
	(55, 7, 'Paris', 'France', 79, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(56, 34, 'Rome', 'Italy', 40, '2026-01-07 20:31:55.37395'),
	(57, 90, 'Vienna', 'Austria', 65, '2026-01-07 20:31:55.37395'),
	(58, 70, 'Helsinki', 'Finland', 5, '2026-01-07 20:31:55.37395'),
	(59, 89, 'Berlin', 'Germany', 51, '2026-01-07 20:31:55.37395'),
	(60, 61, 'Vienna', 'Austria', 26, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(61, 82, 'Warsaw', 'Poland', 73, '2026-01-07 20:31:55.37395'),
	(62, 89, 'Berlin', 'Germany', 67, '2026-01-07 20:31:55.37395'),
	(63, 28, 'Madrid', 'Spain', 47, '2026-01-07 20:31:55.37395'),
	(64, 61, 'Helsinki', 'Finland', 65, '2026-01-07 20:31:55.37395'),
	(65, 84, 'Warsaw', 'Poland', 11, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(66, 5, 'Vienna', 'Austria', 69, '2026-01-07 20:31:55.37395'),
	(67, 51, 'Vienna', 'Austria', 67, '2026-01-07 20:31:55.37395'),
	(68, 41, 'Paris', 'France', 89, '2026-01-07 20:31:55.37395'),
	(69, 32, 'Stockholm', 'Sweden', 1, '2026-01-07 20:31:55.37395'),
	(70, 34, 'Stockholm', 'Sweden', 66, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(71, 62, 'Amsterdam', 'Netherlands', 66, '2026-01-07 20:31:55.37395'),
	(72, 74, 'Amsterdam', 'Netherlands', 37, '2026-01-07 20:31:55.37395'),
	(73, 1, 'Vienna', 'Austria', 90, '2026-01-07 20:31:55.37395'),
	(74, 24, 'Amsterdam', 'Netherlands', 2, '2026-01-07 20:31:55.37395'),
	(75, 64, 'Madrid', 'Spain', 39, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(76, 87, 'Helsinki', 'Finland', 77, '2026-01-07 20:31:55.37395'),
	(77, 29, 'Vienna', 'Austria', 52, '2026-01-07 20:31:55.37395'),
	(78, 19, 'Vienna', 'Austria', 7, '2026-01-07 20:31:55.37395'),
	(79, 44, 'Madrid', 'Spain', 87, '2026-01-07 20:31:55.37395'),
	(80, 49, 'Prague', 'Czech Republic', 52, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(81, 16, 'Paris', 'France', 84, '2026-01-07 20:31:55.37395'),
	(82, 40, 'Warsaw', 'Poland', 16, '2026-01-07 20:31:55.37395'),
	(83, 28, 'Stockholm', 'Sweden', 26, '2026-01-07 20:31:55.37395'),
	(84, 11, 'Berlin', 'Germany', 95, '2026-01-07 20:31:55.37395'),
	(85, 40, 'Stockholm', 'Sweden', 7, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(86, 27, 'Paris', 'France', 64, '2026-01-07 20:31:55.37395'),
	(87, 22, 'Rome', 'Italy', 63, '2026-01-07 20:31:55.37395'),
	(88, 37, 'Vienna', 'Austria', 23, '2026-01-07 20:31:55.37395'),
	(89, 60, 'Warsaw', 'Poland', 33, '2026-01-07 20:31:55.37395'),
	(90, 37, 'Amsterdam', 'Netherlands', 25, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(91, 79, 'Rome', 'Italy', 87, '2026-01-07 20:31:55.37395'),
	(92, 27, 'Rome', 'Italy', 14, '2026-01-07 20:31:55.37395'),
	(93, 16, 'Helsinki', 'Finland', 29, '2026-01-07 20:31:55.37395'),
	(94, 8, 'Stockholm', 'Sweden', 61, '2026-01-07 20:31:55.37395'),
	(95, 59, 'Prague', 'Czech Republic', 49, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(96, 48, 'Paris', 'France', 60, '2026-01-07 20:31:55.37395'),
	(97, 60, 'Madrid', 'Spain', 75, '2026-01-07 20:31:55.37395'),
	(98, 32, 'Berlin', 'Germany', 96, '2026-01-07 20:31:55.37395'),
	(99, 72, 'Amsterdam', 'Netherlands', 82, '2026-01-07 20:31:55.37395'),
	(100, 43, 'Helsinki', 'Finland', 41, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(101, 95, 'Amsterdam', 'Netherlands', 30, '2026-01-07 20:31:55.37395'),
	(102, 72, 'Rome', 'Italy', 19, '2026-01-07 20:31:55.37395'),
	(103, 18, 'Warsaw', 'Poland', 84, '2026-01-07 20:31:55.37395'),
	(104, 66, 'Warsaw', 'Poland', 45, '2026-01-07 20:31:55.37395'),
	(105, 99, 'Madrid', 'Spain', 67, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(106, 15, 'Amsterdam', 'Netherlands', 81, '2026-01-07 20:31:55.37395'),
	(107, 5, 'Madrid', 'Spain', 89, '2026-01-07 20:31:55.37395'),
	(108, 53, 'Rome', 'Italy', 68, '2026-01-07 20:31:55.37395'),
	(109, 79, 'Paris', 'France', 92, '2026-01-07 20:31:55.37395'),
	(110, 74, 'Helsinki', 'Finland', 59, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(111, 59, 'Madrid', 'Spain', 24, '2026-01-07 20:31:55.37395'),
	(112, 93, 'Stockholm', 'Sweden', 67, '2026-01-07 20:31:55.37395'),
	(113, 77, 'Prague', 'Czech Republic', 66, '2026-01-07 20:31:55.37395'),
	(114, 39, 'Rome', 'Italy', 74, '2026-01-07 20:31:55.37395'),
	(115, 94, 'Stockholm', 'Sweden', 80, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(116, 84, 'Warsaw', 'Poland', 51, '2026-01-07 20:31:55.37395'),
	(117, 58, 'Paris', 'France', 7, '2026-01-07 20:31:55.37395'),
	(118, 97, 'Berlin', 'Germany', 39, '2026-01-07 20:31:55.37395'),
	(119, 45, 'Vienna', 'Austria', 3, '2026-01-07 20:31:55.37395'),
	(120, 30, 'Madrid', 'Spain', 78, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(121, 6, 'Paris', 'France', 69, '2026-01-07 20:31:55.37395'),
	(122, 38, 'Vienna', 'Austria', 94, '2026-01-07 20:31:55.37395'),
	(123, 22, 'Warsaw', 'Poland', 48, '2026-01-07 20:31:55.37395'),
	(124, 4, 'Warsaw', 'Poland', 49, '2026-01-07 20:31:55.37395'),
	(125, 20, 'Prague', 'Czech Republic', 34, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(126, 81, 'Stockholm', 'Sweden', 67, '2026-01-07 20:31:55.37395'),
	(127, 98, 'Vienna', 'Austria', 7, '2026-01-07 20:31:55.37395'),
	(128, 12, 'Helsinki', 'Finland', 30, '2026-01-07 20:31:55.37395'),
	(129, 53, 'Helsinki', 'Finland', 30, '2026-01-07 20:31:55.37395'),
	(130, 23, 'Warsaw', 'Poland', 65, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(131, 3, 'Paris', 'France', 89, '2026-01-07 20:31:55.37395'),
	(132, 73, 'Warsaw', 'Poland', 96, '2026-01-07 20:31:55.37395'),
	(133, 54, 'Paris', 'France', 56, '2026-01-07 20:31:55.37395'),
	(134, 72, 'Vienna', 'Austria', 18, '2026-01-07 20:31:55.37395'),
	(135, 62, 'Berlin', 'Germany', 3, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(136, 71, 'Prague', 'Czech Republic', 9, '2026-01-07 20:31:55.37395'),
	(137, 68, 'Amsterdam', 'Netherlands', 81, '2026-01-07 20:31:55.37395'),
	(138, 81, 'Amsterdam', 'Netherlands', 3, '2026-01-07 20:31:55.37395'),
	(139, 68, 'Prague', 'Czech Republic', 96, '2026-01-07 20:31:55.37395'),
	(140, 92, 'Warsaw', 'Poland', 7, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(141, 99, 'Rome', 'Italy', 38, '2026-01-07 20:31:55.37395'),
	(142, 97, 'Berlin', 'Germany', 42, '2026-01-07 20:31:55.37395'),
	(143, 5, 'Prague', 'Czech Republic', 8, '2026-01-07 20:31:55.37395'),
	(144, 10, 'Paris', 'France', 78, '2026-01-07 20:31:55.37395'),
	(145, 64, 'Madrid', 'Spain', 57, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(146, 68, 'Warsaw', 'Poland', 4, '2026-01-07 20:31:55.37395'),
	(147, 79, 'Berlin', 'Germany', 17, '2026-01-07 20:31:55.37395'),
	(148, 79, 'Warsaw', 'Poland', 18, '2026-01-07 20:31:55.37395'),
	(149, 67, 'Rome', 'Italy', 54, '2026-01-07 20:31:55.37395'),
	(150, 70, 'Madrid', 'Spain', 43, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(151, 7, 'Madrid', 'Spain', 5, '2026-01-07 20:31:55.37395'),
	(152, 31, 'Warsaw', 'Poland', 10, '2026-01-07 20:31:55.37395'),
	(153, 41, 'Helsinki', 'Finland', 54, '2026-01-07 20:31:55.37395'),
	(154, 91, 'Berlin', 'Germany', 15, '2026-01-07 20:31:55.37395'),
	(155, 97, 'Vienna', 'Austria', 15, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(156, 26, 'Rome', 'Italy', 95, '2026-01-07 20:31:55.37395'),
	(157, 48, 'Berlin', 'Germany', 76, '2026-01-07 20:31:55.37395'),
	(158, 2, 'Vienna', 'Austria', 33, '2026-01-07 20:31:55.37395'),
	(159, 99, 'Paris', 'France', 56, '2026-01-07 20:31:55.37395'),
	(160, 29, 'Stockholm', 'Sweden', 34, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(161, 84, 'Paris', 'France', 62, '2026-01-07 20:31:55.37395'),
	(162, 59, 'Madrid', 'Spain', 98, '2026-01-07 20:31:55.37395'),
	(163, 71, 'Vienna', 'Austria', 87, '2026-01-07 20:31:55.37395'),
	(164, 49, 'Stockholm', 'Sweden', 98, '2026-01-07 20:31:55.37395'),
	(165, 92, 'Amsterdam', 'Netherlands', 71, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(166, 99, 'Paris', 'France', 80, '2026-01-07 20:31:55.37395'),
	(167, 91, 'Vienna', 'Austria', 95, '2026-01-07 20:31:55.37395'),
	(168, 33, 'Warsaw', 'Poland', 53, '2026-01-07 20:31:55.37395'),
	(169, 65, 'Prague', 'Czech Republic', 90, '2026-01-07 20:31:55.37395'),
	(170, 38, 'Vienna', 'Austria', 46, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(171, 58, 'Stockholm', 'Sweden', 36, '2026-01-07 20:31:55.37395'),
	(172, 1, 'Helsinki', 'Finland', 96, '2026-01-07 20:31:55.37395'),
	(173, 74, 'Amsterdam', 'Netherlands', 24, '2026-01-07 20:31:55.37395'),
	(174, 32, 'Madrid', 'Spain', 43, '2026-01-07 20:31:55.37395'),
	(175, 47, 'Amsterdam', 'Netherlands', 26, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(176, 68, 'Madrid', 'Spain', 18, '2026-01-07 20:31:55.37395'),
	(177, 17, 'Madrid', 'Spain', 9, '2026-01-07 20:31:55.37395'),
	(178, 45, 'Amsterdam', 'Netherlands', 84, '2026-01-07 20:31:55.37395'),
	(179, 71, 'Helsinki', 'Finland', 22, '2026-01-07 20:31:55.37395'),
	(180, 98, 'Paris', 'France', 84, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(181, 87, 'Amsterdam', 'Netherlands', 64, '2026-01-07 20:31:55.37395'),
	(182, 79, 'Amsterdam', 'Netherlands', 55, '2026-01-07 20:31:55.37395'),
	(183, 59, 'Vienna', 'Austria', 93, '2026-01-07 20:31:55.37395'),
	(184, 18, 'Berlin', 'Germany', 70, '2026-01-07 20:31:55.37395'),
	(185, 50, 'Warsaw', 'Poland', 42, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(186, 40, 'Berlin', 'Germany', 72, '2026-01-07 20:31:55.37395'),
	(187, 14, 'Paris', 'France', 32, '2026-01-07 20:31:55.37395'),
	(188, 20, 'Vienna', 'Austria', 5, '2026-01-07 20:31:55.37395'),
	(189, 95, 'Stockholm', 'Sweden', 20, '2026-01-07 20:31:55.37395'),
	(190, 86, 'Madrid', 'Spain', 81, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(191, 8, 'Helsinki', 'Finland', 85, '2026-01-07 20:31:55.37395'),
	(192, 56, 'Stockholm', 'Sweden', 23, '2026-01-07 20:31:55.37395'),
	(193, 27, 'Vienna', 'Austria', 47, '2026-01-07 20:31:55.37395'),
	(194, 85, 'Stockholm', 'Sweden', 55, '2026-01-07 20:31:55.37395'),
	(195, 82, 'Berlin', 'Germany', 9, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(196, 37, 'Berlin', 'Germany', 30, '2026-01-07 20:31:55.37395'),
	(197, 60, 'Warsaw', 'Poland', 12, '2026-01-07 20:31:55.37395'),
	(198, 2, 'Paris', 'France', 98, '2026-01-07 20:31:55.37395'),
	(199, 2, 'Vienna', 'Austria', 31, '2026-01-07 20:31:55.37395'),
	(200, 21, 'Paris', 'France', 40, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(201, 60, 'Paris', 'France', 97, '2026-01-07 20:31:55.37395'),
	(202, 41, 'Warsaw', 'Poland', 7, '2026-01-07 20:31:55.37395'),
	(203, 94, 'Warsaw', 'Poland', 44, '2026-01-07 20:31:55.37395'),
	(204, 91, 'Berlin', 'Germany', 77, '2026-01-07 20:31:55.37395'),
	(205, 5, 'Helsinki', 'Finland', 60, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(206, 88, 'Warsaw', 'Poland', 37, '2026-01-07 20:31:55.37395'),
	(207, 26, 'Paris', 'France', 20, '2026-01-07 20:31:55.37395'),
	(208, 91, 'Stockholm', 'Sweden', 27, '2026-01-07 20:31:55.37395'),
	(209, 48, 'Madrid', 'Spain', 18, '2026-01-07 20:31:55.37395'),
	(210, 5, 'Prague', 'Czech Republic', 44, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(211, 42, 'Amsterdam', 'Netherlands', 68, '2026-01-07 20:31:55.37395'),
	(212, 13, 'Berlin', 'Germany', 69, '2026-01-07 20:31:55.37395'),
	(213, 94, 'Madrid', 'Spain', 61, '2026-01-07 20:31:55.37395'),
	(214, 18, 'Berlin', 'Germany', 33, '2026-01-07 20:31:55.37395'),
	(215, 85, 'Madrid', 'Spain', 47, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(216, 4, 'Helsinki', 'Finland', 67, '2026-01-07 20:31:55.37395'),
	(217, 71, 'Helsinki', 'Finland', 14, '2026-01-07 20:31:55.37395'),
	(218, 18, 'Prague', 'Czech Republic', 1, '2026-01-07 20:31:55.37395'),
	(219, 72, 'Paris', 'France', 58, '2026-01-07 20:31:55.37395'),
	(220, 42, 'Amsterdam', 'Netherlands', 93, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(221, 8, 'Vienna', 'Austria', 77, '2026-01-07 20:31:55.37395'),
	(222, 76, 'Berlin', 'Germany', 24, '2026-01-07 20:31:55.37395'),
	(223, 85, 'Paris', 'France', 13, '2026-01-07 20:31:55.37395'),
	(224, 31, 'Prague', 'Czech Republic', 44, '2026-01-07 20:31:55.37395'),
	(225, 45, 'Vienna', 'Austria', 13, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(226, 79, 'Stockholm', 'Sweden', 74, '2026-01-07 20:31:55.37395'),
	(227, 33, 'Paris', 'France', 93, '2026-01-07 20:31:55.37395'),
	(228, 32, 'Stockholm', 'Sweden', 86, '2026-01-07 20:31:55.37395'),
	(229, 45, 'Stockholm', 'Sweden', 44, '2026-01-07 20:31:55.37395'),
	(230, 97, 'Berlin', 'Germany', 17, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(231, 70, 'Amsterdam', 'Netherlands', 66, '2026-01-07 20:31:55.37395'),
	(232, 1, 'Stockholm', 'Sweden', 77, '2026-01-07 20:31:55.37395'),
	(233, 17, 'Vienna', 'Austria', 3, '2026-01-07 20:31:55.37395'),
	(234, 45, 'Madrid', 'Spain', 75, '2026-01-07 20:31:55.37395'),
	(235, 2, 'Stockholm', 'Sweden', 48, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(236, 42, 'Vienna', 'Austria', 16, '2026-01-07 20:31:55.37395'),
	(237, 70, 'Helsinki', 'Finland', 20, '2026-01-07 20:31:55.37395'),
	(238, 4, 'Warsaw', 'Poland', 7, '2026-01-07 20:31:55.37395'),
	(239, 8, 'Warsaw', 'Poland', 66, '2026-01-07 20:31:55.37395'),
	(240, 55, 'Prague', 'Czech Republic', 37, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(241, 39, 'Rome', 'Italy', 27, '2026-01-07 20:31:55.37395'),
	(242, 36, 'Madrid', 'Spain', 74, '2026-01-07 20:31:55.37395'),
	(243, 13, 'Stockholm', 'Sweden', 58, '2026-01-07 20:31:55.37395'),
	(244, 68, 'Prague', 'Czech Republic', 94, '2026-01-07 20:31:55.37395'),
	(245, 21, 'Paris', 'France', 75, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(246, 69, 'Amsterdam', 'Netherlands', 15, '2026-01-07 20:31:55.37395'),
	(247, 13, 'Stockholm', 'Sweden', 74, '2026-01-07 20:31:55.37395'),
	(248, 74, 'Stockholm', 'Sweden', 90, '2026-01-07 20:31:55.37395'),
	(249, 22, 'Berlin', 'Germany', 14, '2026-01-07 20:31:55.37395'),
	(250, 86, 'Amsterdam', 'Netherlands', 21, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(251, 62, 'Rome', 'Italy', 91, '2026-01-07 20:31:55.37395'),
	(252, 77, 'Stockholm', 'Sweden', 80, '2026-01-07 20:31:55.37395'),
	(253, 85, 'Amsterdam', 'Netherlands', 52, '2026-01-07 20:31:55.37395'),
	(254, 53, 'Warsaw', 'Poland', 9, '2026-01-07 20:31:55.37395'),
	(255, 52, 'Stockholm', 'Sweden', 21, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(256, 90, 'Madrid', 'Spain', 78, '2026-01-07 20:31:55.37395'),
	(257, 31, 'Madrid', 'Spain', 83, '2026-01-07 20:31:55.37395'),
	(258, 71, 'Stockholm', 'Sweden', 43, '2026-01-07 20:31:55.37395'),
	(259, 47, 'Madrid', 'Spain', 86, '2026-01-07 20:31:55.37395'),
	(260, 69, 'Madrid', 'Spain', 69, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(261, 45, 'Berlin', 'Germany', 38, '2026-01-07 20:31:55.37395'),
	(262, 21, 'Vienna', 'Austria', 71, '2026-01-07 20:31:55.37395'),
	(263, 6, 'Warsaw', 'Poland', 86, '2026-01-07 20:31:55.37395'),
	(264, 28, 'Paris', 'France', 90, '2026-01-07 20:31:55.37395'),
	(265, 83, 'Vienna', 'Austria', 45, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(266, 52, 'Helsinki', 'Finland', 65, '2026-01-07 20:31:55.37395'),
	(267, 52, 'Stockholm', 'Sweden', 14, '2026-01-07 20:31:55.37395'),
	(268, 45, 'Amsterdam', 'Netherlands', 60, '2026-01-07 20:31:55.37395'),
	(269, 99, 'Rome', 'Italy', 42, '2026-01-07 20:31:55.37395'),
	(270, 50, 'Warsaw', 'Poland', 66, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(271, 50, 'Prague', 'Czech Republic', 50, '2026-01-07 20:31:55.37395'),
	(272, 10, 'Paris', 'France', 98, '2026-01-07 20:31:55.37395'),
	(273, 57, 'Paris', 'France', 89, '2026-01-07 20:31:55.37395'),
	(274, 95, 'Madrid', 'Spain', 16, '2026-01-07 20:31:55.37395'),
	(275, 55, 'Warsaw', 'Poland', 43, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(276, 30, 'Helsinki', 'Finland', 45, '2026-01-07 20:31:55.37395'),
	(277, 45, 'Berlin', 'Germany', 88, '2026-01-07 20:31:55.37395'),
	(278, 8, 'Rome', 'Italy', 44, '2026-01-07 20:31:55.37395'),
	(279, 64, 'Madrid', 'Spain', 28, '2026-01-07 20:31:55.37395'),
	(280, 50, 'Warsaw', 'Poland', 12, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(281, 55, 'Berlin', 'Germany', 45, '2026-01-07 20:31:55.37395'),
	(282, 56, 'Helsinki', 'Finland', 46, '2026-01-07 20:31:55.37395'),
	(283, 19, 'Helsinki', 'Finland', 38, '2026-01-07 20:31:55.37395'),
	(284, 25, 'Madrid', 'Spain', 35, '2026-01-07 20:31:55.37395'),
	(285, 94, 'Helsinki', 'Finland', 55, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(286, 8, 'Rome', 'Italy', 19, '2026-01-07 20:31:55.37395'),
	(287, 44, 'Berlin', 'Germany', 30, '2026-01-07 20:31:55.37395'),
	(288, 58, 'Paris', 'France', 12, '2026-01-07 20:31:55.37395'),
	(289, 39, 'Vienna', 'Austria', 26, '2026-01-07 20:31:55.37395'),
	(290, 12, 'Berlin', 'Germany', 11, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(291, 62, 'Madrid', 'Spain', 90, '2026-01-07 20:31:55.37395'),
	(292, 36, 'Amsterdam', 'Netherlands', 32, '2026-01-07 20:31:55.37395'),
	(293, 63, 'Berlin', 'Germany', 32, '2026-01-07 20:31:55.37395'),
	(294, 86, 'Amsterdam', 'Netherlands', 34, '2026-01-07 20:31:55.37395'),
	(295, 81, 'Paris', 'France', 37, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(296, 35, 'Madrid', 'Spain', 26, '2026-01-07 20:31:55.37395'),
	(297, 52, 'Warsaw', 'Poland', 60, '2026-01-07 20:31:55.37395'),
	(298, 66, 'Prague', 'Czech Republic', 22, '2026-01-07 20:31:55.37395'),
	(299, 26, 'Rome', 'Italy', 47, '2026-01-07 20:31:55.37395'),
	(300, 56, 'Vienna', 'Austria', 63, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(301, 23, 'Rome', 'Italy', 79, '2026-01-07 20:31:55.37395'),
	(302, 88, 'Prague', 'Czech Republic', 15, '2026-01-07 20:31:55.37395'),
	(303, 67, 'Warsaw', 'Poland', 10, '2026-01-07 20:31:55.37395'),
	(304, 37, 'Madrid', 'Spain', 64, '2026-01-07 20:31:55.37395'),
	(305, 23, 'Warsaw', 'Poland', 16, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(306, 27, 'Berlin', 'Germany', 65, '2026-01-07 20:31:55.37395'),
	(307, 76, 'Rome', 'Italy', 88, '2026-01-07 20:31:55.37395'),
	(308, 35, 'Warsaw', 'Poland', 89, '2026-01-07 20:31:55.37395'),
	(309, 49, 'Berlin', 'Germany', 29, '2026-01-07 20:31:55.37395'),
	(310, 34, 'Madrid', 'Spain', 100, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(311, 58, 'Stockholm', 'Sweden', 92, '2026-01-07 20:31:55.37395'),
	(312, 85, 'Paris', 'France', 100, '2026-01-07 20:31:55.37395'),
	(313, 2, 'Prague', 'Czech Republic', 15, '2026-01-07 20:31:55.37395'),
	(314, 76, 'Helsinki', 'Finland', 4, '2026-01-07 20:31:55.37395'),
	(315, 11, 'Amsterdam', 'Netherlands', 39, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(316, 71, 'Vienna', 'Austria', 82, '2026-01-07 20:31:55.37395'),
	(317, 84, 'Prague', 'Czech Republic', 92, '2026-01-07 20:31:55.37395'),
	(318, 69, 'Amsterdam', 'Netherlands', 33, '2026-01-07 20:31:55.37395'),
	(319, 43, 'Paris', 'France', 57, '2026-01-07 20:31:55.37395'),
	(320, 40, 'Warsaw', 'Poland', 62, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(321, 17, 'Paris', 'France', 48, '2026-01-07 20:31:55.37395'),
	(322, 35, 'Madrid', 'Spain', 56, '2026-01-07 20:31:55.37395'),
	(323, 58, 'Madrid', 'Spain', 67, '2026-01-07 20:31:55.37395'),
	(324, 78, 'Vienna', 'Austria', 67, '2026-01-07 20:31:55.37395'),
	(325, 84, 'Paris', 'France', 27, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(326, 39, 'Madrid', 'Spain', 70, '2026-01-07 20:31:55.37395'),
	(327, 59, 'Helsinki', 'Finland', 16, '2026-01-07 20:31:55.37395'),
	(328, 47, 'Rome', 'Italy', 32, '2026-01-07 20:31:55.37395'),
	(329, 36, 'Vienna', 'Austria', 48, '2026-01-07 20:31:55.37395'),
	(330, 92, 'Prague', 'Czech Republic', 97, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(331, 51, 'Paris', 'France', 71, '2026-01-07 20:31:55.37395'),
	(332, 49, 'Paris', 'France', 3, '2026-01-07 20:31:55.37395'),
	(333, 7, 'Rome', 'Italy', 2, '2026-01-07 20:31:55.37395'),
	(334, 63, 'Vienna', 'Austria', 14, '2026-01-07 20:31:55.37395'),
	(335, 7, 'Rome', 'Italy', 1, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(336, 75, 'Helsinki', 'Finland', 83, '2026-01-07 20:31:55.37395'),
	(337, 63, 'Madrid', 'Spain', 81, '2026-01-07 20:31:55.37395'),
	(338, 51, 'Amsterdam', 'Netherlands', 44, '2026-01-07 20:31:55.37395'),
	(339, 74, 'Prague', 'Czech Republic', 11, '2026-01-07 20:31:55.37395'),
	(340, 14, 'Madrid', 'Spain', 45, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(341, 3, 'Vienna', 'Austria', 87, '2026-01-07 20:31:55.37395'),
	(342, 74, 'Vienna', 'Austria', 87, '2026-01-07 20:31:55.37395'),
	(343, 75, 'Vienna', 'Austria', 27, '2026-01-07 20:31:55.37395'),
	(344, 60, 'Paris', 'France', 18, '2026-01-07 20:31:55.37395'),
	(345, 78, 'Berlin', 'Germany', 28, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(346, 95, 'Vienna', 'Austria', 63, '2026-01-07 20:31:55.37395'),
	(347, 24, 'Warsaw', 'Poland', 40, '2026-01-07 20:31:55.37395'),
	(348, 98, 'Berlin', 'Germany', 82, '2026-01-07 20:31:55.37395'),
	(349, 78, 'Berlin', 'Germany', 96, '2026-01-07 20:31:55.37395'),
	(350, 79, 'Rome', 'Italy', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(351, 64, 'Madrid', 'Spain', 71, '2026-01-07 20:31:55.37395'),
	(352, 79, 'Helsinki', 'Finland', 93, '2026-01-07 20:31:55.37395'),
	(353, 93, 'Warsaw', 'Poland', 30, '2026-01-07 20:31:55.37395'),
	(354, 19, 'Stockholm', 'Sweden', 42, '2026-01-07 20:31:55.37395'),
	(355, 47, 'Berlin', 'Germany', 70, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(356, 71, 'Amsterdam', 'Netherlands', 62, '2026-01-07 20:31:55.37395'),
	(357, 92, 'Vienna', 'Austria', 86, '2026-01-07 20:31:55.37395'),
	(358, 75, 'Amsterdam', 'Netherlands', 28, '2026-01-07 20:31:55.37395'),
	(359, 57, 'Vienna', 'Austria', 74, '2026-01-07 20:31:55.37395'),
	(360, 7, 'Paris', 'France', 55, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(361, 24, 'Helsinki', 'Finland', 65, '2026-01-07 20:31:55.37395'),
	(362, 27, 'Prague', 'Czech Republic', 85, '2026-01-07 20:31:55.37395'),
	(363, 38, 'Stockholm', 'Sweden', 42, '2026-01-07 20:31:55.37395'),
	(364, 45, 'Madrid', 'Spain', 98, '2026-01-07 20:31:55.37395'),
	(365, 79, 'Rome', 'Italy', 78, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(366, 7, 'Prague', 'Czech Republic', 40, '2026-01-07 20:31:55.37395'),
	(367, 32, 'Prague', 'Czech Republic', 88, '2026-01-07 20:31:55.37395'),
	(368, 98, 'Rome', 'Italy', 55, '2026-01-07 20:31:55.37395'),
	(369, 45, 'Helsinki', 'Finland', 86, '2026-01-07 20:31:55.37395'),
	(370, 31, 'Rome', 'Italy', 25, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(371, 100, 'Rome', 'Italy', 100, '2026-01-07 20:31:55.37395'),
	(372, 44, 'Berlin', 'Germany', 80, '2026-01-07 20:31:55.37395'),
	(373, 92, 'Rome', 'Italy', 22, '2026-01-07 20:31:55.37395'),
	(374, 11, 'Warsaw', 'Poland', 15, '2026-01-07 20:31:55.37395'),
	(375, 28, 'Rome', 'Italy', 18, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(376, 7, 'Vienna', 'Austria', 96, '2026-01-07 20:31:55.37395'),
	(377, 27, 'Berlin', 'Germany', 78, '2026-01-07 20:31:55.37395'),
	(378, 45, 'Helsinki', 'Finland', 14, '2026-01-07 20:31:55.37395'),
	(379, 88, 'Stockholm', 'Sweden', 24, '2026-01-07 20:31:55.37395'),
	(380, 23, 'Berlin', 'Germany', 9, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(381, 80, 'Paris', 'France', 68, '2026-01-07 20:31:55.37395'),
	(382, 75, 'Paris', 'France', 80, '2026-01-07 20:31:55.37395'),
	(383, 33, 'Rome', 'Italy', 100, '2026-01-07 20:31:55.37395'),
	(384, 12, 'Berlin', 'Germany', 100, '2026-01-07 20:31:55.37395'),
	(385, 74, 'Vienna', 'Austria', 28, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(386, 18, 'Prague', 'Czech Republic', 33, '2026-01-07 20:31:55.37395'),
	(387, 86, 'Prague', 'Czech Republic', 56, '2026-01-07 20:31:55.37395'),
	(388, 37, 'Paris', 'France', 23, '2026-01-07 20:31:55.37395'),
	(389, 7, 'Paris', 'France', 20, '2026-01-07 20:31:55.37395'),
	(390, 98, 'Helsinki', 'Finland', 39, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(391, 50, 'Warsaw', 'Poland', 10, '2026-01-07 20:31:55.37395'),
	(392, 70, 'Amsterdam', 'Netherlands', 90, '2026-01-07 20:31:55.37395'),
	(393, 100, 'Amsterdam', 'Netherlands', 69, '2026-01-07 20:31:55.37395'),
	(394, 88, 'Vienna', 'Austria', 94, '2026-01-07 20:31:55.37395'),
	(395, 32, 'Helsinki', 'Finland', 24, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(396, 93, 'Helsinki', 'Finland', 66, '2026-01-07 20:31:55.37395'),
	(397, 29, 'Vienna', 'Austria', 40, '2026-01-07 20:31:55.37395'),
	(398, 32, 'Stockholm', 'Sweden', 44, '2026-01-07 20:31:55.37395'),
	(399, 98, 'Berlin', 'Germany', 96, '2026-01-07 20:31:55.37395'),
	(400, 68, 'Berlin', 'Germany', 80, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(401, 83, 'Helsinki', 'Finland', 95, '2026-01-07 20:31:55.37395'),
	(402, 60, 'Berlin', 'Germany', 42, '2026-01-07 20:31:55.37395'),
	(403, 9, 'Warsaw', 'Poland', 43, '2026-01-07 20:31:55.37395'),
	(404, 62, 'Madrid', 'Spain', 65, '2026-01-07 20:31:55.37395'),
	(405, 22, 'Warsaw', 'Poland', 11, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(406, 32, 'Paris', 'France', 84, '2026-01-07 20:31:55.37395'),
	(407, 58, 'Amsterdam', 'Netherlands', 12, '2026-01-07 20:31:55.37395'),
	(408, 17, 'Stockholm', 'Sweden', 47, '2026-01-07 20:31:55.37395'),
	(409, 34, 'Stockholm', 'Sweden', 23, '2026-01-07 20:31:55.37395'),
	(410, 69, 'Rome', 'Italy', 2, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(411, 12, 'Stockholm', 'Sweden', 22, '2026-01-07 20:31:55.37395'),
	(412, 49, 'Amsterdam', 'Netherlands', 44, '2026-01-07 20:31:55.37395'),
	(413, 50, 'Stockholm', 'Sweden', 47, '2026-01-07 20:31:55.37395'),
	(414, 96, 'Helsinki', 'Finland', 32, '2026-01-07 20:31:55.37395'),
	(415, 37, 'Rome', 'Italy', 90, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(416, 34, 'Helsinki', 'Finland', 59, '2026-01-07 20:31:55.37395'),
	(417, 23, 'Paris', 'France', 12, '2026-01-07 20:31:55.37395'),
	(418, 46, 'Paris', 'France', 89, '2026-01-07 20:31:55.37395'),
	(419, 68, 'Prague', 'Czech Republic', 25, '2026-01-07 20:31:55.37395'),
	(420, 12, 'Warsaw', 'Poland', 18, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(421, 57, 'Rome', 'Italy', 34, '2026-01-07 20:31:55.37395'),
	(422, 33, 'Berlin', 'Germany', 67, '2026-01-07 20:31:55.37395'),
	(423, 15, 'Paris', 'France', 17, '2026-01-07 20:31:55.37395'),
	(424, 89, 'Vienna', 'Austria', 10, '2026-01-07 20:31:55.37395'),
	(425, 77, 'Paris', 'France', 36, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(426, 95, 'Rome', 'Italy', 35, '2026-01-07 20:31:55.37395'),
	(427, 18, 'Rome', 'Italy', 93, '2026-01-07 20:31:55.37395'),
	(428, 100, 'Amsterdam', 'Netherlands', 12, '2026-01-07 20:31:55.37395'),
	(429, 95, 'Vienna', 'Austria', 77, '2026-01-07 20:31:55.37395'),
	(430, 19, 'Berlin', 'Germany', 85, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(431, 72, 'Prague', 'Czech Republic', 69, '2026-01-07 20:31:55.37395'),
	(432, 53, 'Prague', 'Czech Republic', 35, '2026-01-07 20:31:55.37395'),
	(433, 3, 'Stockholm', 'Sweden', 70, '2026-01-07 20:31:55.37395'),
	(434, 2, 'Prague', 'Czech Republic', 69, '2026-01-07 20:31:55.37395'),
	(435, 71, 'Paris', 'France', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(436, 70, 'Prague', 'Czech Republic', 98, '2026-01-07 20:31:55.37395'),
	(437, 100, 'Amsterdam', 'Netherlands', 50, '2026-01-07 20:31:55.37395'),
	(438, 95, 'Prague', 'Czech Republic', 64, '2026-01-07 20:31:55.37395'),
	(439, 36, 'Amsterdam', 'Netherlands', 25, '2026-01-07 20:31:55.37395'),
	(440, 79, 'Warsaw', 'Poland', 35, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(441, 86, 'Prague', 'Czech Republic', 20, '2026-01-07 20:31:55.37395'),
	(442, 16, 'Madrid', 'Spain', 7, '2026-01-07 20:31:55.37395'),
	(443, 99, 'Warsaw', 'Poland', 14, '2026-01-07 20:31:55.37395'),
	(444, 29, 'Paris', 'France', 59, '2026-01-07 20:31:55.37395'),
	(445, 9, 'Helsinki', 'Finland', 86, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(446, 34, 'Rome', 'Italy', 81, '2026-01-07 20:31:55.37395'),
	(447, 23, 'Berlin', 'Germany', 16, '2026-01-07 20:31:55.37395'),
	(448, 88, 'Warsaw', 'Poland', 53, '2026-01-07 20:31:55.37395'),
	(449, 73, 'Vienna', 'Austria', 36, '2026-01-07 20:31:55.37395'),
	(450, 46, 'Prague', 'Czech Republic', 97, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(451, 89, 'Prague', 'Czech Republic', 48, '2026-01-07 20:31:55.37395'),
	(452, 26, 'Amsterdam', 'Netherlands', 30, '2026-01-07 20:31:55.37395'),
	(453, 6, 'Prague', 'Czech Republic', 62, '2026-01-07 20:31:55.37395'),
	(454, 42, 'Stockholm', 'Sweden', 25, '2026-01-07 20:31:55.37395'),
	(455, 88, 'Madrid', 'Spain', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(456, 75, 'Rome', 'Italy', 71, '2026-01-07 20:31:55.37395'),
	(457, 49, 'Stockholm', 'Sweden', 8, '2026-01-07 20:31:55.37395'),
	(458, 48, 'Warsaw', 'Poland', 27, '2026-01-07 20:31:55.37395'),
	(459, 94, 'Prague', 'Czech Republic', 75, '2026-01-07 20:31:55.37395'),
	(460, 3, 'Berlin', 'Germany', 72, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(461, 41, 'Berlin', 'Germany', 91, '2026-01-07 20:31:55.37395'),
	(462, 21, 'Amsterdam', 'Netherlands', 48, '2026-01-07 20:31:55.37395'),
	(463, 37, 'Madrid', 'Spain', 57, '2026-01-07 20:31:55.37395'),
	(464, 81, 'Vienna', 'Austria', 64, '2026-01-07 20:31:55.37395'),
	(465, 19, 'Paris', 'France', 68, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(466, 69, 'Helsinki', 'Finland', 25, '2026-01-07 20:31:55.37395'),
	(467, 2, 'Vienna', 'Austria', 19, '2026-01-07 20:31:55.37395'),
	(468, 63, 'Rome', 'Italy', 88, '2026-01-07 20:31:55.37395'),
	(469, 34, 'Vienna', 'Austria', 13, '2026-01-07 20:31:55.37395'),
	(470, 51, 'Helsinki', 'Finland', 29, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(471, 27, 'Paris', 'France', 22, '2026-01-07 20:31:55.37395'),
	(472, 92, 'Madrid', 'Spain', 27, '2026-01-07 20:31:55.37395'),
	(473, 42, 'Helsinki', 'Finland', 26, '2026-01-07 20:31:55.37395'),
	(474, 59, 'Helsinki', 'Finland', 43, '2026-01-07 20:31:55.37395'),
	(475, 37, 'Stockholm', 'Sweden', 31, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(476, 62, 'Amsterdam', 'Netherlands', 79, '2026-01-07 20:31:55.37395'),
	(477, 64, 'Paris', 'France', 9, '2026-01-07 20:31:55.37395'),
	(478, 80, 'Stockholm', 'Sweden', 12, '2026-01-07 20:31:55.37395'),
	(479, 75, 'Helsinki', 'Finland', 27, '2026-01-07 20:31:55.37395'),
	(480, 84, 'Madrid', 'Spain', 82, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(481, 8, 'Prague', 'Czech Republic', 61, '2026-01-07 20:31:55.37395'),
	(482, 66, 'Warsaw', 'Poland', 94, '2026-01-07 20:31:55.37395'),
	(483, 46, 'Warsaw', 'Poland', 37, '2026-01-07 20:31:55.37395'),
	(484, 55, 'Helsinki', 'Finland', 56, '2026-01-07 20:31:55.37395'),
	(485, 57, 'Rome', 'Italy', 100, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(486, 47, 'Paris', 'France', 76, '2026-01-07 20:31:55.37395'),
	(487, 34, 'Vienna', 'Austria', 17, '2026-01-07 20:31:55.37395'),
	(488, 46, 'Amsterdam', 'Netherlands', 52, '2026-01-07 20:31:55.37395'),
	(489, 46, 'Rome', 'Italy', 27, '2026-01-07 20:31:55.37395'),
	(490, 68, 'Berlin', 'Germany', 23, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(491, 43, 'Prague', 'Czech Republic', 64, '2026-01-07 20:31:55.37395'),
	(492, 94, 'Warsaw', 'Poland', 14, '2026-01-07 20:31:55.37395'),
	(493, 44, 'Amsterdam', 'Netherlands', 60, '2026-01-07 20:31:55.37395'),
	(494, 90, 'Amsterdam', 'Netherlands', 32, '2026-01-07 20:31:55.37395'),
	(495, 3, 'Berlin', 'Germany', 98, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(496, 56, 'Warsaw', 'Poland', 2, '2026-01-07 20:31:55.37395'),
	(497, 63, 'Warsaw', 'Poland', 75, '2026-01-07 20:31:55.37395'),
	(498, 30, 'Prague', 'Czech Republic', 22, '2026-01-07 20:31:55.37395'),
	(499, 48, 'Stockholm', 'Sweden', 64, '2026-01-07 20:31:55.37395'),
	(500, 28, 'Prague', 'Czech Republic', 96, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(501, 79, 'Stockholm', 'Sweden', 26, '2026-01-07 20:31:55.37395'),
	(502, 41, 'Prague', 'Czech Republic', 8, '2026-01-07 20:31:55.37395'),
	(503, 68, 'Berlin', 'Germany', 97, '2026-01-07 20:31:55.37395'),
	(504, 90, 'Stockholm', 'Sweden', 9, '2026-01-07 20:31:55.37395'),
	(505, 91, 'Warsaw', 'Poland', 89, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(506, 80, 'Rome', 'Italy', 45, '2026-01-07 20:31:55.37395'),
	(507, 64, 'Paris', 'France', 42, '2026-01-07 20:31:55.37395'),
	(508, 94, 'Berlin', 'Germany', 14, '2026-01-07 20:31:55.37395'),
	(509, 28, 'Helsinki', 'Finland', 76, '2026-01-07 20:31:55.37395'),
	(510, 77, 'Helsinki', 'Finland', 10, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(511, 95, 'Paris', 'France', 12, '2026-01-07 20:31:55.37395'),
	(512, 25, 'Stockholm', 'Sweden', 99, '2026-01-07 20:31:55.37395'),
	(513, 6, 'Rome', 'Italy', 67, '2026-01-07 20:31:55.37395'),
	(514, 88, 'Berlin', 'Germany', 2, '2026-01-07 20:31:55.37395'),
	(515, 19, 'Madrid', 'Spain', 95, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(516, 57, 'Amsterdam', 'Netherlands', 19, '2026-01-07 20:31:55.37395'),
	(517, 52, 'Helsinki', 'Finland', 77, '2026-01-07 20:31:55.37395'),
	(518, 7, 'Vienna', 'Austria', 20, '2026-01-07 20:31:55.37395'),
	(519, 24, 'Helsinki', 'Finland', 29, '2026-01-07 20:31:55.37395'),
	(520, 46, 'Rome', 'Italy', 86, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(521, 97, 'Warsaw', 'Poland', 48, '2026-01-07 20:31:55.37395'),
	(522, 26, 'Helsinki', 'Finland', 98, '2026-01-07 20:31:55.37395'),
	(523, 36, 'Helsinki', 'Finland', 38, '2026-01-07 20:31:55.37395'),
	(524, 32, 'Amsterdam', 'Netherlands', 45, '2026-01-07 20:31:55.37395'),
	(525, 65, 'Amsterdam', 'Netherlands', 40, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(526, 84, 'Vienna', 'Austria', 28, '2026-01-07 20:31:55.37395'),
	(527, 38, 'Berlin', 'Germany', 1, '2026-01-07 20:31:55.37395'),
	(528, 5, 'Helsinki', 'Finland', 61, '2026-01-07 20:31:55.37395'),
	(529, 18, 'Rome', 'Italy', 14, '2026-01-07 20:31:55.37395'),
	(530, 25, 'Paris', 'France', 43, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(531, 39, 'Berlin', 'Germany', 9, '2026-01-07 20:31:55.37395'),
	(532, 81, 'Rome', 'Italy', 19, '2026-01-07 20:31:55.37395'),
	(533, 14, 'Berlin', 'Germany', 77, '2026-01-07 20:31:55.37395'),
	(534, 2, 'Vienna', 'Austria', 1, '2026-01-07 20:31:55.37395'),
	(535, 85, 'Vienna', 'Austria', 52, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(536, 89, 'Berlin', 'Germany', 30, '2026-01-07 20:31:55.37395'),
	(537, 25, 'Warsaw', 'Poland', 54, '2026-01-07 20:31:55.37395'),
	(538, 85, 'Paris', 'France', 31, '2026-01-07 20:31:55.37395'),
	(539, 63, 'Rome', 'Italy', 87, '2026-01-07 20:31:55.37395'),
	(540, 71, 'Warsaw', 'Poland', 52, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(541, 46, 'Helsinki', 'Finland', 11, '2026-01-07 20:31:55.37395'),
	(542, 39, 'Madrid', 'Spain', 83, '2026-01-07 20:31:55.37395'),
	(543, 68, 'Prague', 'Czech Republic', 68, '2026-01-07 20:31:55.37395'),
	(544, 38, 'Berlin', 'Germany', 87, '2026-01-07 20:31:55.37395'),
	(545, 48, 'Berlin', 'Germany', 26, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(546, 73, 'Berlin', 'Germany', 82, '2026-01-07 20:31:55.37395'),
	(547, 31, 'Rome', 'Italy', 22, '2026-01-07 20:31:55.37395'),
	(548, 23, 'Helsinki', 'Finland', 99, '2026-01-07 20:31:55.37395'),
	(549, 69, 'Madrid', 'Spain', 32, '2026-01-07 20:31:55.37395'),
	(550, 93, 'Helsinki', 'Finland', 7, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(551, 10, 'Paris', 'France', 69, '2026-01-07 20:31:55.37395'),
	(552, 61, 'Prague', 'Czech Republic', 27, '2026-01-07 20:31:55.37395'),
	(553, 58, 'Rome', 'Italy', 5, '2026-01-07 20:31:55.37395'),
	(554, 58, 'Prague', 'Czech Republic', 19, '2026-01-07 20:31:55.37395'),
	(555, 51, 'Berlin', 'Germany', 33, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(556, 42, 'Helsinki', 'Finland', 25, '2026-01-07 20:31:55.37395'),
	(557, 39, 'Stockholm', 'Sweden', 91, '2026-01-07 20:31:55.37395'),
	(558, 96, 'Vienna', 'Austria', 33, '2026-01-07 20:31:55.37395'),
	(559, 9, 'Amsterdam', 'Netherlands', 96, '2026-01-07 20:31:55.37395'),
	(560, 87, 'Helsinki', 'Finland', 19, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(561, 58, 'Berlin', 'Germany', 15, '2026-01-07 20:31:55.37395'),
	(562, 54, 'Stockholm', 'Sweden', 19, '2026-01-07 20:31:55.37395'),
	(563, 57, 'Amsterdam', 'Netherlands', 50, '2026-01-07 20:31:55.37395'),
	(564, 36, 'Vienna', 'Austria', 33, '2026-01-07 20:31:55.37395'),
	(565, 73, 'Berlin', 'Germany', 72, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(566, 53, 'Warsaw', 'Poland', 53, '2026-01-07 20:31:55.37395'),
	(567, 24, 'Madrid', 'Spain', 23, '2026-01-07 20:31:55.37395'),
	(568, 65, 'Helsinki', 'Finland', 53, '2026-01-07 20:31:55.37395'),
	(569, 27, 'Warsaw', 'Poland', 10, '2026-01-07 20:31:55.37395'),
	(570, 29, 'Amsterdam', 'Netherlands', 91, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(571, 17, 'Berlin', 'Germany', 12, '2026-01-07 20:31:55.37395'),
	(572, 22, 'Paris', 'France', 68, '2026-01-07 20:31:55.37395'),
	(573, 12, 'Paris', 'France', 99, '2026-01-07 20:31:55.37395'),
	(574, 81, 'Prague', 'Czech Republic', 20, '2026-01-07 20:31:55.37395'),
	(575, 83, 'Stockholm', 'Sweden', 47, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(576, 84, 'Amsterdam', 'Netherlands', 24, '2026-01-07 20:31:55.37395'),
	(577, 98, 'Amsterdam', 'Netherlands', 4, '2026-01-07 20:31:55.37395'),
	(578, 61, 'Amsterdam', 'Netherlands', 51, '2026-01-07 20:31:55.37395'),
	(579, 31, 'Amsterdam', 'Netherlands', 85, '2026-01-07 20:31:55.37395'),
	(580, 18, 'Stockholm', 'Sweden', 58, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(581, 21, 'Berlin', 'Germany', 53, '2026-01-07 20:31:55.37395'),
	(582, 28, 'Amsterdam', 'Netherlands', 57, '2026-01-07 20:31:55.37395'),
	(583, 27, 'Vienna', 'Austria', 28, '2026-01-07 20:31:55.37395'),
	(584, 92, 'Prague', 'Czech Republic', 44, '2026-01-07 20:31:55.37395'),
	(585, 20, 'Vienna', 'Austria', 77, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(586, 29, 'Rome', 'Italy', 14, '2026-01-07 20:31:55.37395'),
	(587, 7, 'Madrid', 'Spain', 100, '2026-01-07 20:31:55.37395'),
	(588, 61, 'Vienna', 'Austria', 83, '2026-01-07 20:31:55.37395'),
	(589, 8, 'Rome', 'Italy', 29, '2026-01-07 20:31:55.37395'),
	(590, 13, 'Stockholm', 'Sweden', 6, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(591, 74, 'Berlin', 'Germany', 26, '2026-01-07 20:31:55.37395'),
	(592, 100, 'Berlin', 'Germany', 99, '2026-01-07 20:31:55.37395'),
	(593, 83, 'Helsinki', 'Finland', 85, '2026-01-07 20:31:55.37395'),
	(594, 24, 'Amsterdam', 'Netherlands', 21, '2026-01-07 20:31:55.37395'),
	(595, 7, 'Prague', 'Czech Republic', 27, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(596, 14, 'Stockholm', 'Sweden', 89, '2026-01-07 20:31:55.37395'),
	(597, 52, 'Prague', 'Czech Republic', 83, '2026-01-07 20:31:55.37395'),
	(598, 3, 'Warsaw', 'Poland', 28, '2026-01-07 20:31:55.37395'),
	(599, 40, 'Berlin', 'Germany', 74, '2026-01-07 20:31:55.37395'),
	(600, 40, 'Warsaw', 'Poland', 73, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(601, 56, 'Madrid', 'Spain', 70, '2026-01-07 20:31:55.37395'),
	(602, 3, 'Stockholm', 'Sweden', 41, '2026-01-07 20:31:55.37395'),
	(603, 31, 'Prague', 'Czech Republic', 95, '2026-01-07 20:31:55.37395'),
	(604, 55, 'Berlin', 'Germany', 69, '2026-01-07 20:31:55.37395'),
	(605, 21, 'Paris', 'France', 44, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(606, 76, 'Berlin', 'Germany', 92, '2026-01-07 20:31:55.37395'),
	(607, 58, 'Madrid', 'Spain', 59, '2026-01-07 20:31:55.37395'),
	(608, 58, 'Madrid', 'Spain', 91, '2026-01-07 20:31:55.37395'),
	(609, 49, 'Berlin', 'Germany', 11, '2026-01-07 20:31:55.37395'),
	(610, 73, 'Berlin', 'Germany', 58, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(611, 45, 'Vienna', 'Austria', 91, '2026-01-07 20:31:55.37395'),
	(612, 44, 'Warsaw', 'Poland', 13, '2026-01-07 20:31:55.37395'),
	(613, 58, 'Paris', 'France', 91, '2026-01-07 20:31:55.37395'),
	(614, 10, 'Vienna', 'Austria', 96, '2026-01-07 20:31:55.37395'),
	(615, 70, 'Berlin', 'Germany', 14, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(616, 23, 'Stockholm', 'Sweden', 67, '2026-01-07 20:31:55.37395'),
	(617, 84, 'Vienna', 'Austria', 1, '2026-01-07 20:31:55.37395'),
	(618, 71, 'Berlin', 'Germany', 15, '2026-01-07 20:31:55.37395'),
	(619, 2, 'Madrid', 'Spain', 61, '2026-01-07 20:31:55.37395'),
	(620, 26, 'Helsinki', 'Finland', 100, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(621, 60, 'Paris', 'France', 18, '2026-01-07 20:31:55.37395'),
	(622, 60, 'Warsaw', 'Poland', 4, '2026-01-07 20:31:55.37395'),
	(623, 11, 'Berlin', 'Germany', 31, '2026-01-07 20:31:55.37395'),
	(624, 72, 'Amsterdam', 'Netherlands', 15, '2026-01-07 20:31:55.37395'),
	(625, 97, 'Rome', 'Italy', 5, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(626, 58, 'Warsaw', 'Poland', 50, '2026-01-07 20:31:55.37395'),
	(627, 15, 'Vienna', 'Austria', 43, '2026-01-07 20:31:55.37395'),
	(628, 48, 'Amsterdam', 'Netherlands', 45, '2026-01-07 20:31:55.37395'),
	(629, 31, 'Warsaw', 'Poland', 12, '2026-01-07 20:31:55.37395'),
	(630, 51, 'Amsterdam', 'Netherlands', 96, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(631, 46, 'Vienna', 'Austria', 5, '2026-01-07 20:31:55.37395'),
	(632, 28, 'Stockholm', 'Sweden', 71, '2026-01-07 20:31:55.37395'),
	(633, 68, 'Vienna', 'Austria', 33, '2026-01-07 20:31:55.37395'),
	(634, 28, 'Prague', 'Czech Republic', 31, '2026-01-07 20:31:55.37395'),
	(635, 90, 'Stockholm', 'Sweden', 50, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(636, 53, 'Amsterdam', 'Netherlands', 86, '2026-01-07 20:31:55.37395'),
	(637, 34, 'Rome', 'Italy', 62, '2026-01-07 20:31:55.37395'),
	(638, 20, 'Vienna', 'Austria', 76, '2026-01-07 20:31:55.37395'),
	(639, 100, 'Amsterdam', 'Netherlands', 95, '2026-01-07 20:31:55.37395'),
	(640, 100, 'Amsterdam', 'Netherlands', 9, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(641, 82, 'Paris', 'France', 78, '2026-01-07 20:31:55.37395'),
	(642, 89, 'Stockholm', 'Sweden', 81, '2026-01-07 20:31:55.37395'),
	(643, 57, 'Helsinki', 'Finland', 29, '2026-01-07 20:31:55.37395'),
	(644, 23, 'Madrid', 'Spain', 36, '2026-01-07 20:31:55.37395'),
	(645, 98, 'Berlin', 'Germany', 86, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(646, 95, 'Prague', 'Czech Republic', 99, '2026-01-07 20:31:55.37395'),
	(647, 27, 'Vienna', 'Austria', 56, '2026-01-07 20:31:55.37395'),
	(648, 90, 'Madrid', 'Spain', 83, '2026-01-07 20:31:55.37395'),
	(649, 81, 'Amsterdam', 'Netherlands', 23, '2026-01-07 20:31:55.37395'),
	(650, 45, 'Amsterdam', 'Netherlands', 81, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(651, 46, 'Helsinki', 'Finland', 89, '2026-01-07 20:31:55.37395'),
	(652, 61, 'Berlin', 'Germany', 6, '2026-01-07 20:31:55.37395'),
	(653, 47, 'Prague', 'Czech Republic', 65, '2026-01-07 20:31:55.37395'),
	(654, 69, 'Stockholm', 'Sweden', 40, '2026-01-07 20:31:55.37395'),
	(655, 21, 'Warsaw', 'Poland', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(656, 34, 'Stockholm', 'Sweden', 89, '2026-01-07 20:31:55.37395'),
	(657, 98, 'Prague', 'Czech Republic', 93, '2026-01-07 20:31:55.37395'),
	(658, 89, 'Rome', 'Italy', 89, '2026-01-07 20:31:55.37395'),
	(659, 97, 'Vienna', 'Austria', 32, '2026-01-07 20:31:55.37395'),
	(660, 43, 'Paris', 'France', 54, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(661, 15, 'Warsaw', 'Poland', 8, '2026-01-07 20:31:55.37395'),
	(662, 10, 'Paris', 'France', 57, '2026-01-07 20:31:55.37395'),
	(663, 82, 'Paris', 'France', 36, '2026-01-07 20:31:55.37395'),
	(664, 12, 'Stockholm', 'Sweden', 93, '2026-01-07 20:31:55.37395'),
	(665, 8, 'Helsinki', 'Finland', 63, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(666, 83, 'Stockholm', 'Sweden', 70, '2026-01-07 20:31:55.37395'),
	(667, 73, 'Stockholm', 'Sweden', 68, '2026-01-07 20:31:55.37395'),
	(668, 63, 'Paris', 'France', 72, '2026-01-07 20:31:55.37395'),
	(669, 75, 'Helsinki', 'Finland', 69, '2026-01-07 20:31:55.37395'),
	(670, 62, 'Vienna', 'Austria', 39, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(671, 77, 'Stockholm', 'Sweden', 49, '2026-01-07 20:31:55.37395'),
	(672, 28, 'Prague', 'Czech Republic', 83, '2026-01-07 20:31:55.37395'),
	(673, 42, 'Madrid', 'Spain', 14, '2026-01-07 20:31:55.37395'),
	(674, 3, 'Helsinki', 'Finland', 1, '2026-01-07 20:31:55.37395'),
	(675, 51, 'Helsinki', 'Finland', 85, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(676, 29, 'Stockholm', 'Sweden', 16, '2026-01-07 20:31:55.37395'),
	(677, 2, 'Prague', 'Czech Republic', 59, '2026-01-07 20:31:55.37395'),
	(678, 72, 'Madrid', 'Spain', 24, '2026-01-07 20:31:55.37395'),
	(679, 66, 'Helsinki', 'Finland', 90, '2026-01-07 20:31:55.37395'),
	(680, 48, 'Paris', 'France', 32, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(681, 49, 'Stockholm', 'Sweden', 20, '2026-01-07 20:31:55.37395'),
	(682, 94, 'Helsinki', 'Finland', 63, '2026-01-07 20:31:55.37395'),
	(683, 21, 'Berlin', 'Germany', 10, '2026-01-07 20:31:55.37395'),
	(684, 16, 'Berlin', 'Germany', 94, '2026-01-07 20:31:55.37395'),
	(685, 87, 'Vienna', 'Austria', 36, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(686, 83, 'Stockholm', 'Sweden', 46, '2026-01-07 20:31:55.37395'),
	(687, 27, 'Paris', 'France', 50, '2026-01-07 20:31:55.37395'),
	(688, 75, 'Warsaw', 'Poland', 100, '2026-01-07 20:31:55.37395'),
	(689, 28, 'Helsinki', 'Finland', 32, '2026-01-07 20:31:55.37395'),
	(690, 65, 'Stockholm', 'Sweden', 93, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(691, 8, 'Paris', 'France', 49, '2026-01-07 20:31:55.37395'),
	(692, 51, 'Prague', 'Czech Republic', 76, '2026-01-07 20:31:55.37395'),
	(693, 56, 'Rome', 'Italy', 97, '2026-01-07 20:31:55.37395'),
	(694, 31, 'Paris', 'France', 28, '2026-01-07 20:31:55.37395'),
	(695, 67, 'Amsterdam', 'Netherlands', 32, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(696, 41, 'Stockholm', 'Sweden', 14, '2026-01-07 20:31:55.37395'),
	(697, 63, 'Berlin', 'Germany', 69, '2026-01-07 20:31:55.37395'),
	(698, 29, 'Vienna', 'Austria', 22, '2026-01-07 20:31:55.37395'),
	(699, 11, 'Rome', 'Italy', 92, '2026-01-07 20:31:55.37395'),
	(700, 52, 'Amsterdam', 'Netherlands', 3, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(701, 23, 'Vienna', 'Austria', 87, '2026-01-07 20:31:55.37395'),
	(702, 80, 'Stockholm', 'Sweden', 1, '2026-01-07 20:31:55.37395'),
	(703, 50, 'Paris', 'France', 86, '2026-01-07 20:31:55.37395'),
	(704, 28, 'Prague', 'Czech Republic', 99, '2026-01-07 20:31:55.37395'),
	(705, 30, 'Paris', 'France', 94, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(706, 33, 'Prague', 'Czech Republic', 11, '2026-01-07 20:31:55.37395'),
	(707, 95, 'Prague', 'Czech Republic', 8, '2026-01-07 20:31:55.37395'),
	(708, 98, 'Madrid', 'Spain', 81, '2026-01-07 20:31:55.37395'),
	(709, 53, 'Paris', 'France', 16, '2026-01-07 20:31:55.37395'),
	(710, 85, 'Amsterdam', 'Netherlands', 8, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(711, 12, 'Madrid', 'Spain', 47, '2026-01-07 20:31:55.37395'),
	(712, 41, 'Warsaw', 'Poland', 88, '2026-01-07 20:31:55.37395'),
	(713, 84, 'Berlin', 'Germany', 54, '2026-01-07 20:31:55.37395'),
	(714, 75, 'Vienna', 'Austria', 81, '2026-01-07 20:31:55.37395'),
	(715, 48, 'Vienna', 'Austria', 50, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(716, 44, 'Madrid', 'Spain', 28, '2026-01-07 20:31:55.37395'),
	(717, 62, 'Paris', 'France', 91, '2026-01-07 20:31:55.37395'),
	(718, 97, 'Warsaw', 'Poland', 18, '2026-01-07 20:31:55.37395'),
	(719, 11, 'Amsterdam', 'Netherlands', 94, '2026-01-07 20:31:55.37395'),
	(720, 7, 'Stockholm', 'Sweden', 40, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(721, 51, 'Stockholm', 'Sweden', 97, '2026-01-07 20:31:55.37395'),
	(722, 80, 'Paris', 'France', 85, '2026-01-07 20:31:55.37395'),
	(723, 53, 'Madrid', 'Spain', 40, '2026-01-07 20:31:55.37395'),
	(724, 99, 'Vienna', 'Austria', 98, '2026-01-07 20:31:55.37395'),
	(725, 77, 'Warsaw', 'Poland', 97, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(726, 25, 'Amsterdam', 'Netherlands', 59, '2026-01-07 20:31:55.37395'),
	(727, 58, 'Paris', 'France', 5, '2026-01-07 20:31:55.37395'),
	(728, 93, 'Amsterdam', 'Netherlands', 59, '2026-01-07 20:31:55.37395'),
	(729, 4, 'Stockholm', 'Sweden', 89, '2026-01-07 20:31:55.37395'),
	(730, 68, 'Rome', 'Italy', 52, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(731, 95, 'Helsinki', 'Finland', 98, '2026-01-07 20:31:55.37395'),
	(732, 13, 'Rome', 'Italy', 96, '2026-01-07 20:31:55.37395'),
	(733, 20, 'Warsaw', 'Poland', 83, '2026-01-07 20:31:55.37395'),
	(734, 100, 'Warsaw', 'Poland', 37, '2026-01-07 20:31:55.37395'),
	(735, 38, 'Amsterdam', 'Netherlands', 21, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(736, 69, 'Rome', 'Italy', 6, '2026-01-07 20:31:55.37395'),
	(737, 37, 'Berlin', 'Germany', 99, '2026-01-07 20:31:55.37395'),
	(738, 6, 'Madrid', 'Spain', 31, '2026-01-07 20:31:55.37395'),
	(739, 25, 'Warsaw', 'Poland', 5, '2026-01-07 20:31:55.37395'),
	(740, 51, 'Prague', 'Czech Republic', 30, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(741, 41, 'Madrid', 'Spain', 45, '2026-01-07 20:31:55.37395'),
	(742, 68, 'Prague', 'Czech Republic', 99, '2026-01-07 20:31:55.37395'),
	(743, 40, 'Stockholm', 'Sweden', 32, '2026-01-07 20:31:55.37395'),
	(744, 98, 'Rome', 'Italy', 99, '2026-01-07 20:31:55.37395'),
	(745, 59, 'Vienna', 'Austria', 44, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(746, 86, 'Vienna', 'Austria', 71, '2026-01-07 20:31:55.37395'),
	(747, 11, 'Madrid', 'Spain', 96, '2026-01-07 20:31:55.37395'),
	(748, 47, 'Madrid', 'Spain', 98, '2026-01-07 20:31:55.37395'),
	(749, 66, 'Helsinki', 'Finland', 9, '2026-01-07 20:31:55.37395'),
	(750, 72, 'Warsaw', 'Poland', 85, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(751, 18, 'Vienna', 'Austria', 75, '2026-01-07 20:31:55.37395'),
	(752, 73, 'Madrid', 'Spain', 33, '2026-01-07 20:31:55.37395'),
	(753, 21, 'Prague', 'Czech Republic', 87, '2026-01-07 20:31:55.37395'),
	(754, 47, 'Madrid', 'Spain', 85, '2026-01-07 20:31:55.37395'),
	(755, 34, 'Madrid', 'Spain', 51, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(756, 48, 'Paris', 'France', 41, '2026-01-07 20:31:55.37395'),
	(757, 33, 'Rome', 'Italy', 17, '2026-01-07 20:31:55.37395'),
	(758, 57, 'Amsterdam', 'Netherlands', 61, '2026-01-07 20:31:55.37395'),
	(759, 39, 'Warsaw', 'Poland', 36, '2026-01-07 20:31:55.37395'),
	(760, 26, 'Rome', 'Italy', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(761, 93, 'Helsinki', 'Finland', 27, '2026-01-07 20:31:55.37395'),
	(762, 46, 'Madrid', 'Spain', 70, '2026-01-07 20:31:55.37395'),
	(763, 84, 'Warsaw', 'Poland', 23, '2026-01-07 20:31:55.37395'),
	(764, 60, 'Vienna', 'Austria', 87, '2026-01-07 20:31:55.37395'),
	(765, 53, 'Warsaw', 'Poland', 46, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(766, 91, 'Paris', 'France', 34, '2026-01-07 20:31:55.37395'),
	(767, 29, 'Rome', 'Italy', 21, '2026-01-07 20:31:55.37395'),
	(768, 20, 'Stockholm', 'Sweden', 71, '2026-01-07 20:31:55.37395'),
	(769, 77, 'Prague', 'Czech Republic', 65, '2026-01-07 20:31:55.37395'),
	(770, 61, 'Helsinki', 'Finland', 79, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(771, 4, 'Berlin', 'Germany', 88, '2026-01-07 20:31:55.37395'),
	(772, 61, 'Prague', 'Czech Republic', 44, '2026-01-07 20:31:55.37395'),
	(773, 93, 'Berlin', 'Germany', 17, '2026-01-07 20:31:55.37395'),
	(774, 28, 'Prague', 'Czech Republic', 9, '2026-01-07 20:31:55.37395'),
	(775, 13, 'Stockholm', 'Sweden', 26, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(776, 20, 'Madrid', 'Spain', 3, '2026-01-07 20:31:55.37395'),
	(777, 85, 'Berlin', 'Germany', 5, '2026-01-07 20:31:55.37395'),
	(778, 5, 'Vienna', 'Austria', 62, '2026-01-07 20:31:55.37395'),
	(779, 8, 'Rome', 'Italy', 60, '2026-01-07 20:31:55.37395'),
	(780, 78, 'Berlin', 'Germany', 77, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(781, 47, 'Berlin', 'Germany', 96, '2026-01-07 20:31:55.37395'),
	(782, 100, 'Madrid', 'Spain', 94, '2026-01-07 20:31:55.37395'),
	(783, 67, 'Amsterdam', 'Netherlands', 61, '2026-01-07 20:31:55.37395'),
	(784, 80, 'Paris', 'France', 36, '2026-01-07 20:31:55.37395'),
	(785, 28, 'Paris', 'France', 54, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(786, 12, 'Helsinki', 'Finland', 23, '2026-01-07 20:31:55.37395'),
	(787, 39, 'Madrid', 'Spain', 2, '2026-01-07 20:31:55.37395'),
	(788, 53, 'Warsaw', 'Poland', 84, '2026-01-07 20:31:55.37395'),
	(789, 34, 'Stockholm', 'Sweden', 41, '2026-01-07 20:31:55.37395'),
	(790, 25, 'Stockholm', 'Sweden', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(791, 15, 'Vienna', 'Austria', 46, '2026-01-07 20:31:55.37395'),
	(792, 47, 'Rome', 'Italy', 47, '2026-01-07 20:31:55.37395'),
	(793, 71, 'Warsaw', 'Poland', 7, '2026-01-07 20:31:55.37395'),
	(794, 56, 'Warsaw', 'Poland', 58, '2026-01-07 20:31:55.37395'),
	(795, 82, 'Berlin', 'Germany', 93, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(796, 85, 'Prague', 'Czech Republic', 84, '2026-01-07 20:31:55.37395'),
	(797, 15, 'Warsaw', 'Poland', 28, '2026-01-07 20:31:55.37395'),
	(798, 91, 'Warsaw', 'Poland', 15, '2026-01-07 20:31:55.37395'),
	(799, 44, 'Paris', 'France', 3, '2026-01-07 20:31:55.37395'),
	(800, 5, 'Prague', 'Czech Republic', 75, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(801, 21, 'Paris', 'France', 17, '2026-01-07 20:31:55.37395'),
	(802, 65, 'Madrid', 'Spain', 85, '2026-01-07 20:31:55.37395'),
	(803, 97, 'Prague', 'Czech Republic', 16, '2026-01-07 20:31:55.37395'),
	(804, 46, 'Amsterdam', 'Netherlands', 22, '2026-01-07 20:31:55.37395'),
	(805, 78, 'Rome', 'Italy', 1, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(806, 60, 'Vienna', 'Austria', 10, '2026-01-07 20:31:55.37395'),
	(807, 65, 'Berlin', 'Germany', 2, '2026-01-07 20:31:55.37395'),
	(808, 91, 'Madrid', 'Spain', 15, '2026-01-07 20:31:55.37395'),
	(809, 1, 'Stockholm', 'Sweden', 31, '2026-01-07 20:31:55.37395'),
	(810, 16, 'Paris', 'France', 60, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(811, 73, 'Prague', 'Czech Republic', 50, '2026-01-07 20:31:55.37395'),
	(812, 31, 'Berlin', 'Germany', 58, '2026-01-07 20:31:55.37395'),
	(813, 2, 'Stockholm', 'Sweden', 84, '2026-01-07 20:31:55.37395'),
	(814, 31, 'Rome', 'Italy', 56, '2026-01-07 20:31:55.37395'),
	(815, 75, 'Vienna', 'Austria', 98, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(816, 53, 'Paris', 'France', 39, '2026-01-07 20:31:55.37395'),
	(817, 69, 'Amsterdam', 'Netherlands', 18, '2026-01-07 20:31:55.37395'),
	(818, 5, 'Rome', 'Italy', 36, '2026-01-07 20:31:55.37395'),
	(819, 21, 'Warsaw', 'Poland', 68, '2026-01-07 20:31:55.37395'),
	(820, 69, 'Warsaw', 'Poland', 53, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(821, 48, 'Paris', 'France', 62, '2026-01-07 20:31:55.37395'),
	(822, 25, 'Warsaw', 'Poland', 8, '2026-01-07 20:31:55.37395'),
	(823, 41, 'Rome', 'Italy', 72, '2026-01-07 20:31:55.37395'),
	(824, 92, 'Berlin', 'Germany', 41, '2026-01-07 20:31:55.37395'),
	(825, 93, 'Helsinki', 'Finland', 97, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(826, 18, 'Amsterdam', 'Netherlands', 6, '2026-01-07 20:31:55.37395'),
	(827, 90, 'Paris', 'France', 18, '2026-01-07 20:31:55.37395'),
	(828, 68, 'Berlin', 'Germany', 88, '2026-01-07 20:31:55.37395'),
	(829, 49, 'Rome', 'Italy', 20, '2026-01-07 20:31:55.37395'),
	(830, 5, 'Paris', 'France', 56, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(831, 72, 'Amsterdam', 'Netherlands', 44, '2026-01-07 20:31:55.37395'),
	(832, 32, 'Warsaw', 'Poland', 29, '2026-01-07 20:31:55.37395'),
	(833, 14, 'Paris', 'France', 78, '2026-01-07 20:31:55.37395'),
	(834, 54, 'Madrid', 'Spain', 30, '2026-01-07 20:31:55.37395'),
	(835, 14, 'Warsaw', 'Poland', 21, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(836, 87, 'Vienna', 'Austria', 7, '2026-01-07 20:31:55.37395'),
	(837, 13, 'Vienna', 'Austria', 83, '2026-01-07 20:31:55.37395'),
	(838, 58, 'Warsaw', 'Poland', 16, '2026-01-07 20:31:55.37395'),
	(839, 36, 'Warsaw', 'Poland', 62, '2026-01-07 20:31:55.37395'),
	(840, 19, 'Rome', 'Italy', 97, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(841, 79, 'Helsinki', 'Finland', 46, '2026-01-07 20:31:55.37395'),
	(842, 89, 'Vienna', 'Austria', 85, '2026-01-07 20:31:55.37395'),
	(843, 96, 'Helsinki', 'Finland', 79, '2026-01-07 20:31:55.37395'),
	(844, 83, 'Stockholm', 'Sweden', 54, '2026-01-07 20:31:55.37395'),
	(845, 96, 'Madrid', 'Spain', 77, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(846, 6, 'Rome', 'Italy', 33, '2026-01-07 20:31:55.37395'),
	(847, 93, 'Warsaw', 'Poland', 54, '2026-01-07 20:31:55.37395'),
	(848, 25, 'Prague', 'Czech Republic', 38, '2026-01-07 20:31:55.37395'),
	(849, 18, 'Madrid', 'Spain', 19, '2026-01-07 20:31:55.37395'),
	(850, 83, 'Berlin', 'Germany', 52, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(851, 55, 'Prague', 'Czech Republic', 51, '2026-01-07 20:31:55.37395'),
	(852, 80, 'Warsaw', 'Poland', 8, '2026-01-07 20:31:55.37395'),
	(853, 4, 'Berlin', 'Germany', 87, '2026-01-07 20:31:55.37395'),
	(854, 61, 'Stockholm', 'Sweden', 93, '2026-01-07 20:31:55.37395'),
	(855, 62, 'Stockholm', 'Sweden', 20, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(856, 54, 'Paris', 'France', 93, '2026-01-07 20:31:55.37395'),
	(857, 33, 'Helsinki', 'Finland', 19, '2026-01-07 20:31:55.37395'),
	(858, 66, 'Paris', 'France', 82, '2026-01-07 20:31:55.37395'),
	(859, 49, 'Vienna', 'Austria', 5, '2026-01-07 20:31:55.37395'),
	(860, 58, 'Madrid', 'Spain', 1, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(861, 50, 'Stockholm', 'Sweden', 7, '2026-01-07 20:31:55.37395'),
	(862, 30, 'Paris', 'France', 4, '2026-01-07 20:31:55.37395'),
	(863, 57, 'Paris', 'France', 44, '2026-01-07 20:31:55.37395'),
	(864, 28, 'Prague', 'Czech Republic', 76, '2026-01-07 20:31:55.37395'),
	(865, 25, 'Vienna', 'Austria', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(866, 47, 'Madrid', 'Spain', 14, '2026-01-07 20:31:55.37395'),
	(867, 86, 'Madrid', 'Spain', 28, '2026-01-07 20:31:55.37395'),
	(868, 2, 'Stockholm', 'Sweden', 44, '2026-01-07 20:31:55.37395'),
	(869, 66, 'Warsaw', 'Poland', 85, '2026-01-07 20:31:55.37395'),
	(870, 76, 'Berlin', 'Germany', 9, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(871, 21, 'Madrid', 'Spain', 25, '2026-01-07 20:31:55.37395'),
	(872, 92, 'Prague', 'Czech Republic', 53, '2026-01-07 20:31:55.37395'),
	(873, 39, 'Stockholm', 'Sweden', 60, '2026-01-07 20:31:55.37395'),
	(874, 31, 'Stockholm', 'Sweden', 83, '2026-01-07 20:31:55.37395'),
	(875, 45, 'Helsinki', 'Finland', 46, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(876, 26, 'Vienna', 'Austria', 19, '2026-01-07 20:31:55.37395'),
	(877, 86, 'Helsinki', 'Finland', 41, '2026-01-07 20:31:55.37395'),
	(878, 67, 'Vienna', 'Austria', 65, '2026-01-07 20:31:55.37395'),
	(879, 77, 'Stockholm', 'Sweden', 79, '2026-01-07 20:31:55.37395'),
	(880, 15, 'Vienna', 'Austria', 87, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(881, 77, 'Helsinki', 'Finland', 66, '2026-01-07 20:31:55.37395'),
	(882, 31, 'Helsinki', 'Finland', 94, '2026-01-07 20:31:55.37395'),
	(883, 13, 'Berlin', 'Germany', 7, '2026-01-07 20:31:55.37395'),
	(884, 46, 'Vienna', 'Austria', 46, '2026-01-07 20:31:55.37395'),
	(885, 78, 'Amsterdam', 'Netherlands', 55, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(886, 52, 'Warsaw', 'Poland', 83, '2026-01-07 20:31:55.37395'),
	(887, 2, 'Warsaw', 'Poland', 2, '2026-01-07 20:31:55.37395'),
	(888, 84, 'Prague', 'Czech Republic', 91, '2026-01-07 20:31:55.37395'),
	(889, 100, 'Stockholm', 'Sweden', 7, '2026-01-07 20:31:55.37395'),
	(890, 74, 'Helsinki', 'Finland', 49, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(891, 21, 'Prague', 'Czech Republic', 62, '2026-01-07 20:31:55.37395'),
	(892, 60, 'Prague', 'Czech Republic', 89, '2026-01-07 20:31:55.37395'),
	(893, 34, 'Warsaw', 'Poland', 41, '2026-01-07 20:31:55.37395'),
	(894, 94, 'Paris', 'France', 30, '2026-01-07 20:31:55.37395'),
	(895, 77, 'Warsaw', 'Poland', 56, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(896, 81, 'Berlin', 'Germany', 14, '2026-01-07 20:31:55.37395'),
	(897, 28, 'Rome', 'Italy', 91, '2026-01-07 20:31:55.37395'),
	(898, 58, 'Paris', 'France', 73, '2026-01-07 20:31:55.37395'),
	(899, 66, 'Prague', 'Czech Republic', 99, '2026-01-07 20:31:55.37395'),
	(900, 95, 'Stockholm', 'Sweden', 76, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(901, 33, 'Warsaw', 'Poland', 18, '2026-01-07 20:31:55.37395'),
	(902, 62, 'Stockholm', 'Sweden', 34, '2026-01-07 20:31:55.37395'),
	(903, 76, 'Paris', 'France', 9, '2026-01-07 20:31:55.37395'),
	(904, 87, 'Paris', 'France', 43, '2026-01-07 20:31:55.37395'),
	(905, 24, 'Berlin', 'Germany', 25, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(906, 67, 'Warsaw', 'Poland', 33, '2026-01-07 20:31:55.37395'),
	(907, 43, 'Berlin', 'Germany', 38, '2026-01-07 20:31:55.37395'),
	(908, 35, 'Warsaw', 'Poland', 79, '2026-01-07 20:31:55.37395'),
	(909, 74, 'Paris', 'France', 62, '2026-01-07 20:31:55.37395'),
	(910, 45, 'Vienna', 'Austria', 55, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(911, 81, 'Paris', 'France', 46, '2026-01-07 20:31:55.37395'),
	(912, 100, 'Madrid', 'Spain', 3, '2026-01-07 20:31:55.37395'),
	(913, 6, 'Rome', 'Italy', 66, '2026-01-07 20:31:55.37395'),
	(914, 20, 'Prague', 'Czech Republic', 25, '2026-01-07 20:31:55.37395'),
	(915, 75, 'Berlin', 'Germany', 4, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(916, 66, 'Amsterdam', 'Netherlands', 10, '2026-01-07 20:31:55.37395'),
	(917, 53, 'Rome', 'Italy', 68, '2026-01-07 20:31:55.37395'),
	(918, 29, 'Paris', 'France', 61, '2026-01-07 20:31:55.37395'),
	(919, 72, 'Rome', 'Italy', 97, '2026-01-07 20:31:55.37395'),
	(920, 56, 'Helsinki', 'Finland', 54, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(921, 30, 'Helsinki', 'Finland', 34, '2026-01-07 20:31:55.37395'),
	(922, 40, 'Vienna', 'Austria', 92, '2026-01-07 20:31:55.37395'),
	(923, 51, 'Stockholm', 'Sweden', 22, '2026-01-07 20:31:55.37395'),
	(924, 24, 'Amsterdam', 'Netherlands', 64, '2026-01-07 20:31:55.37395'),
	(925, 1, 'Prague', 'Czech Republic', 10, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(926, 49, 'Vienna', 'Austria', 46, '2026-01-07 20:31:55.37395'),
	(927, 93, 'Madrid', 'Spain', 44, '2026-01-07 20:31:55.37395'),
	(928, 48, 'Rome', 'Italy', 93, '2026-01-07 20:31:55.37395'),
	(929, 7, 'Madrid', 'Spain', 93, '2026-01-07 20:31:55.37395'),
	(930, 78, 'Vienna', 'Austria', 58, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(931, 45, 'Stockholm', 'Sweden', 64, '2026-01-07 20:31:55.37395'),
	(932, 93, 'Berlin', 'Germany', 5, '2026-01-07 20:31:55.37395'),
	(933, 33, 'Paris', 'France', 5, '2026-01-07 20:31:55.37395'),
	(934, 36, 'Rome', 'Italy', 84, '2026-01-07 20:31:55.37395'),
	(935, 42, 'Warsaw', 'Poland', 96, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(936, 40, 'Warsaw', 'Poland', 19, '2026-01-07 20:31:55.37395'),
	(937, 79, 'Stockholm', 'Sweden', 64, '2026-01-07 20:31:55.37395'),
	(938, 53, 'Vienna', 'Austria', 58, '2026-01-07 20:31:55.37395'),
	(939, 12, 'Paris', 'France', 34, '2026-01-07 20:31:55.37395'),
	(940, 6, 'Berlin', 'Germany', 89, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(941, 64, 'Rome', 'Italy', 12, '2026-01-07 20:31:55.37395'),
	(942, 27, 'Berlin', 'Germany', 7, '2026-01-07 20:31:55.37395'),
	(943, 49, 'Berlin', 'Germany', 74, '2026-01-07 20:31:55.37395'),
	(944, 49, 'Rome', 'Italy', 24, '2026-01-07 20:31:55.37395'),
	(945, 37, 'Madrid', 'Spain', 31, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(946, 99, 'Rome', 'Italy', 95, '2026-01-07 20:31:55.37395'),
	(947, 73, 'Paris', 'France', 76, '2026-01-07 20:31:55.37395'),
	(948, 27, 'Prague', 'Czech Republic', 28, '2026-01-07 20:31:55.37395'),
	(949, 79, 'Berlin', 'Germany', 27, '2026-01-07 20:31:55.37395'),
	(950, 69, 'Berlin', 'Germany', 81, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(951, 78, 'Madrid', 'Spain', 36, '2026-01-07 20:31:55.37395'),
	(952, 75, 'Prague', 'Czech Republic', 32, '2026-01-07 20:31:55.37395'),
	(953, 77, 'Helsinki', 'Finland', 57, '2026-01-07 20:31:55.37395'),
	(954, 57, 'Warsaw', 'Poland', 13, '2026-01-07 20:31:55.37395'),
	(955, 20, 'Madrid', 'Spain', 77, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(956, 2, 'Madrid', 'Spain', 77, '2026-01-07 20:31:55.37395'),
	(957, 83, 'Berlin', 'Germany', 70, '2026-01-07 20:31:55.37395'),
	(958, 41, 'Amsterdam', 'Netherlands', 61, '2026-01-07 20:31:55.37395'),
	(959, 50, 'Stockholm', 'Sweden', 21, '2026-01-07 20:31:55.37395'),
	(960, 53, 'Berlin', 'Germany', 41, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(961, 52, 'Stockholm', 'Sweden', 58, '2026-01-07 20:31:55.37395'),
	(962, 93, 'Stockholm', 'Sweden', 8, '2026-01-07 20:31:55.37395'),
	(963, 35, 'Madrid', 'Spain', 27, '2026-01-07 20:31:55.37395'),
	(964, 17, 'Stockholm', 'Sweden', 46, '2026-01-07 20:31:55.37395'),
	(965, 8, 'Amsterdam', 'Netherlands', 30, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(966, 60, 'Warsaw', 'Poland', 68, '2026-01-07 20:31:55.37395'),
	(967, 75, 'Vienna', 'Austria', 6, '2026-01-07 20:31:55.37395'),
	(968, 100, 'Berlin', 'Germany', 26, '2026-01-07 20:31:55.37395'),
	(969, 84, 'Helsinki', 'Finland', 76, '2026-01-07 20:31:55.37395'),
	(970, 9, 'Helsinki', 'Finland', 66, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(971, 79, 'Berlin', 'Germany', 47, '2026-01-07 20:31:55.37395'),
	(972, 9, 'Madrid', 'Spain', 84, '2026-01-07 20:31:55.37395'),
	(973, 100, 'Prague', 'Czech Republic', 99, '2026-01-07 20:31:55.37395'),
	(974, 53, 'Rome', 'Italy', 65, '2026-01-07 20:31:55.37395'),
	(975, 24, 'Rome', 'Italy', 71, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(976, 17, 'Berlin', 'Germany', 37, '2026-01-07 20:31:55.37395'),
	(977, 58, 'Paris', 'France', 10, '2026-01-07 20:31:55.37395'),
	(978, 58, 'Helsinki', 'Finland', 82, '2026-01-07 20:31:55.37395'),
	(979, 83, 'Warsaw', 'Poland', 73, '2026-01-07 20:31:55.37395'),
	(980, 28, 'Stockholm', 'Sweden', 95, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(981, 10, 'Vienna', 'Austria', 36, '2026-01-07 20:31:55.37395'),
	(982, 26, 'Prague', 'Czech Republic', 37, '2026-01-07 20:31:55.37395'),
	(983, 4, 'Stockholm', 'Sweden', 79, '2026-01-07 20:31:55.37395'),
	(984, 33, 'Rome', 'Italy', 92, '2026-01-07 20:31:55.37395'),
	(985, 89, 'Stockholm', 'Sweden', 88, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(986, 34, 'Paris', 'France', 88, '2026-01-07 20:31:55.37395'),
	(987, 46, 'Warsaw', 'Poland', 87, '2026-01-07 20:31:55.37395'),
	(988, 58, 'Vienna', 'Austria', 71, '2026-01-07 20:31:55.37395'),
	(989, 79, 'Warsaw', 'Poland', 57, '2026-01-07 20:31:55.37395'),
	(990, 4, 'Paris', 'France', 64, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(991, 63, 'Stockholm', 'Sweden', 33, '2026-01-07 20:31:55.37395'),
	(992, 56, 'Stockholm', 'Sweden', 46, '2026-01-07 20:31:55.37395'),
	(993, 50, 'Madrid', 'Spain', 72, '2026-01-07 20:31:55.37395'),
	(994, 92, 'Prague', 'Czech Republic', 89, '2026-01-07 20:31:55.37395'),
	(995, 19, 'Paris', 'France', 75, '2026-01-07 20:31:55.37395');
INSERT INTO public.legacy_orders VALUES
	(996, 23, 'Warsaw', 'Poland', 73, '2026-01-07 20:31:55.37395'),
	(997, 35, 'Vienna', 'Austria', 48, '2026-01-07 20:31:55.37395'),
	(998, 72, 'Helsinki', 'Finland', 84, '2026-01-07 20:31:55.37395'),
	(999, 40, 'Helsinki', 'Finland', 35, '2026-01-07 20:31:55.37395'),
	(1000, 70, 'Madrid', 'Spain', 100, '2026-01-07 20:31:55.37395');


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 215
-- Name: legacy_customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.legacy_customers_id_seq', 100, true);


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 217
-- Name: legacy_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.legacy_orders_id_seq', 1000, true);


--
-- TOC entry 3277 (class 2606 OID 16392)
-- Name: legacy_customers legacy_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legacy_customers
    ADD CONSTRAINT legacy_customers_pkey PRIMARY KEY (id);


--
-- TOC entry 3280 (class 2606 OID 16400)
-- Name: legacy_orders legacy_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legacy_orders
    ADD CONSTRAINT legacy_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3278 (class 1259 OID 16406)
-- Name: idx_legacy_orders_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_legacy_orders_location ON public.legacy_orders USING btree (warehouse_country, warehouse_city);


--
-- TOC entry 3281 (class 2606 OID 16401)
-- Name: legacy_orders legacy_orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legacy_orders
    ADD CONSTRAINT legacy_orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.legacy_customers(id);


-- Completed on 2026-01-07 20:39:50 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict TbqhnzEnD3RxVzojAxYevsjM4AYQMMpJ96S6untf37czz8I4obMws7vfltpnN2H

