--
-- PostgreSQL database dump
--


-- Dumped from database version 16.4 (Debian 16.4-1.pgdg110+2)
-- Dumped by pg_dump version 16.10

-- Started on 2026-01-11 09:54:24 UTC

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
-- TOC entry 2 (class 3079 OID 16415)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

ALTER DATABASE clean OWNER TO admin2;
ALTER SCHEMA public OWNER TO admin2;

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
-- TOC entry 221 (class 1259 OID 17493)
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
-- TOC entry 225 (class 1259 OID 17521)
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
-- TOC entry 224 (class 1259 OID 17508)
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
-- TOC entry 223 (class 1259 OID 17499)
-- Name: warehouses; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.warehouses (
    id bigint NOT NULL,
    name character varying(150),
    city character varying(100),
    country character varying(100),
    location public.geography(Point,4326) NOT NULL,
    region character varying(20) NOT NULL
);


ALTER TABLE public.warehouses OWNER TO admin2;

--
-- TOC entry 222 (class 1259 OID 17498)
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
-- Dependencies: 222
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin2
--

ALTER SEQUENCE public.warehouses_id_seq OWNED BY public.warehouses.id;


--
-- TOC entry 4117 (class 2604 OID 17502)
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouses_id_seq'::regclass);


--
-- TOC entry 4284 (class 0 OID 17493)
-- Dependencies: 221
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.customers (id, first_name, last_name, email, created_at) FROM stdin;
\.


--
-- TOC entry 4288 (class 0 OID 17521)
-- Dependencies: 225
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.orders (id, customer_id, warehouse_id, created_at) FROM stdin;
\.


--
-- TOC entry 4116 (class 0 OID 16733)
-- Dependencies: 217
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 4287 (class 0 OID 17508)
-- Dependencies: 224
-- Data for Name: warehouse_capacity; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.warehouse_capacity (warehouse_id, max_capacity, current_load, updated_at) FROM stdin;
\.


--
-- TOC entry 4286 (class 0 OID 17499)
-- Dependencies: 223
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.warehouses (id, name, city, country, location, region) FROM stdin;
\.


--
-- TOC entry 4296 (class 0 OID 0)
-- Dependencies: 222
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin2
--

SELECT pg_catalog.setval('public.warehouses_id_seq', 1, false);


--
-- TOC entry 4125 (class 2606 OID 17497)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 4132 (class 2606 OID 17525)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 17515)
-- Name: warehouse_capacity warehouse_capacity_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouse_capacity
    ADD CONSTRAINT warehouse_capacity_pkey PRIMARY KEY (warehouse_id);


--
-- TOC entry 4128 (class 2606 OID 17506)
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- TOC entry 4126 (class 1259 OID 17507)
-- Name: idx_warehouses_location; Type: INDEX; Schema: public; Owner: admin2
--

CREATE INDEX idx_warehouses_location ON public.warehouses USING gist (location);


--
-- TOC entry 4134 (class 2606 OID 17526)
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4135 (class 2606 OID 17531)
-- Name: orders orders_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 4133 (class 2606 OID 17516)
-- Name: warehouse_capacity warehouse_capacity_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.warehouse_capacity
    ADD CONSTRAINT warehouse_capacity_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id) ON DELETE CASCADE;


-- Completed on 2026-01-11 09:54:24 UTC

--
-- PostgreSQL database dump complete
--

