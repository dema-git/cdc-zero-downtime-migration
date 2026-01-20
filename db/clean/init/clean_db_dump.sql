--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg110+2)
-- Dumped by pg_dump version 16.11

-- Started on 2026-01-18 13:32:33 UTC

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
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: admin2
--

-- *not* creating schema, since initdb creates it

ALTER DATABASE clean OWNER TO admin2;
ALTER SCHEMA public OWNER TO admin2;

--
-- TOC entry 2 (class 3079 OID 16385)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4294 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 17463)
-- Name: customers; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(200),
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.customers OWNER TO admin2;

--
-- TOC entry 222 (class 1259 OID 17466)
-- Name: orders; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    warehouse_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.orders OWNER TO admin2;

--
-- TOC entry 223 (class 1259 OID 17469)
-- Name: warehouse_capacity; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.warehouse_capacity (
    warehouse_id bigint NOT NULL,
    max_capacity integer NOT NULL,
    current_load integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT warehouse_capacity_check CHECK ((current_load <= max_capacity))
);


ALTER TABLE public.warehouse_capacity OWNER TO admin2;

--
-- TOC entry 224 (class 1259 OID 17475)
-- Name: warehouses; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.warehouses (
    id bigint NOT NULL,
    warehouse_nr character varying(20),
    city character varying(100),
    country character varying(100),
    location public.geography(Point,4326) NOT NULL,
    region character varying(20) NOT NULL
);


ALTER TABLE public.warehouses OWNER TO admin2;

--
-- TOC entry 225 (class 1259 OID 17480)
-- Name: warehouses_id_seq; Type: SEQUENCE; Schema: public; Owner: admin2
--

CREATE SEQUENCE public.warehouses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.warehouses_id_seq OWNER TO admin2;

--
-- TOC entry 4295 (class 0 OID 0)
-- Dependencies: 225
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin2
--

ALTER SEQUENCE public.warehouses_id_seq OWNED BY public.warehouses.id;


--
-- TOC entry 4119 (class 2604 OID 17481)
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouses_id_seq'::regclass);


--
-- TOC entry 4284 (class 0 OID 17463)
-- Dependencies: 221
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: admin2
--



--
-- TOC entry 4285 (class 0 OID 17466)
-- Dependencies: 222
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: admin2
--



--
-- TOC entry 4116 (class 0 OID 16703)
-- Dependencies: 217
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: admin2
--



--
-- TOC entry 4286 (class 0 OID 17469)
-- Dependencies: 223
-- Data for Name: warehouse_capacity; Type: TABLE DATA; Schema: public; Owner: admin2
--

INSERT INTO public.warehouse_capacity VALUES
	(1, 500000, 0, '2026-01-18 13:28:35.211084'),
	(2, 750000, 0, '2026-01-18 13:28:35.211084'),
	(3, 1000000, 0, '2026-01-18 13:28:35.211084'),
	(4, 1250000, 0, '2026-01-18 13:28:35.211084'),
	(5, 1500000, 0, '2026-01-18 13:28:35.211084'),
	(6, 2000000, 0, '2026-01-18 13:28:35.211084'),
	(7, 2500000, 0, '2026-01-18 13:28:35.211084'),
	(8, 3000000, 0, '2026-01-18 13:28:35.211084'),
	(9, 3500000, 0, '2026-01-18 13:28:35.211084'),
	(10, 4000000, 0, '2026-01-18 13:28:35.211084');


--
-- TOC entry 4287 (class 0 OID 17475)
-- Dependencies: 224
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: admin2
--

INSERT INTO public.warehouses VALUES
	(1, 'WH-0001', 'Berlin', 'Germany', '0101000020E61000008FC2F5285CCF2A40C3F5285C8F424A40', 'EU'),
	(2, 'WH-0002', 'Paris', 'France', '0101000020E6100000A835CD3B4ED1024076E09C11A56D4840', 'EU'),
	(3, 'WH-0003', 'Madrid', 'Spain', '0101000020E6100000FE65F7E461A10DC0857CD0B359354440', 'EU'),
	(4, 'WH-0004', 'Rome', 'Italy', '0101000020E610000003780B2428FE2840166A4DF38EF34440', 'EU'),
	(5, 'WH-0005', 'Amsterdam', 'Netherlands', '0101000020E61000002041F163CC9D13403B014D840D2F4A40', 'EU'),
	(6, 'WH-0006', 'Vienna', 'Austria', '0101000020E6100000AB3E575BB15F30407B832F4CA61A4840', 'EU'),
	(7, 'WH-0007', 'Prague', 'Czech Republic', '0101000020E6100000AA60545227E02C408B6CE7FBA9094940', 'EU'),
	(8, 'WH-0008', 'Warsaw', 'Poland', '0101000020E6100000DE02098A1F03354013F241CF661D4A40', 'EU'),
	(9, 'WH-0009', 'Stockholm', 'Sweden', '0101000020E61000006F8104C58F11324052499D8026AA4D40', 'EU'),
	(10, 'WH-0010', 'Helsinki', 'Finland', '0101000020E610000000917EFB3AF0384092CB7F48BF154E40', 'EU');


--
-- TOC entry 4296 (class 0 OID 0)
-- Dependencies: 225
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin2
--

SELECT pg_catalog.setval('public.warehouses_id_seq', 1, false);


--
-- TOC entry 4125 (class 2606 OID 17483)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 4127 (class 2606 OID 17485)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 17487)
-- Name: warehouse_capacity warehouse_capacity_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouse_capacity
    ADD CONSTRAINT warehouse_capacity_pkey PRIMARY KEY (warehouse_id);


--
-- TOC entry 4132 (class 2606 OID 17489)
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 1259 OID 17490)
-- Name: idx_warehouses_location; Type: INDEX; Schema: public; Owner: admin2
--

CREATE INDEX idx_warehouses_location ON public.warehouses USING gist (location);


--
-- TOC entry 4133 (class 2606 OID 17491)
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

--ALTER TABLE ONLY public.orders
--    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4134 (class 2606 OID 17496)
-- Name: orders orders_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 4135 (class 2606 OID 17501)
-- Name: warehouse_capacity warehouse_capacity_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouse_capacity
    ADD CONSTRAINT warehouse_capacity_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id) ON DELETE CASCADE;


-- Completed on 2026-01-18 13:32:33 UTC

--
-- PostgreSQL database dump complete
--


