--
-- PostgreSQL database dump
--

\restrict dEILXVcP3PAJWweFVbtwebx6f2he8wJ19xhHHKzS9En31vZDfC58Sm3d2fhcURI

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.10

-- Started on 2026-01-11 09:09:02 UTC

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
-- TOC entry 3435 (class 1262 OID 16384)
-- Name: clean; Type: DATABASE; Schema: -; Owner: admin2
--

ALTER DATABASE clean OWNER TO admin2;

\unrestrict dEILXVcP3PAJWweFVbtwebx6f2he8wJ19xhHHKzS9En31vZDfC58Sm3d2fhcURI
\connect clean
\restrict dEILXVcP3PAJWweFVbtwebx6f2he8wJ19xhHHKzS9En31vZDfC58Sm3d2fhcURI

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16398)
-- Name: orders; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    amount numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.orders OWNER TO admin2;

--
-- TOC entry 217 (class 1259 OID 16397)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: admin2
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO admin2;

--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 217
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin2
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 216 (class 1259 OID 16386)
-- Name: users; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO admin2;

--
-- TOC entry 215 (class 1259 OID 16385)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: admin2
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO admin2;

--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin2
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3274 (class 2604 OID 16401)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3272 (class 2604 OID 16389)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3429 (class 0 OID 16398)
-- Dependencies: 218
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: admin2
--



--
-- TOC entry 3427 (class 0 OID 16386)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin2
--



--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 217
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin2
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin2
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3281 (class 2606 OID 16404)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3277 (class 2606 OID 16396)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3279 (class 2606 OID 16394)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3282 (class 2606 OID 16405)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2026-01-11 09:09:02 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict dEILXVcP3PAJWweFVbtwebx6f2he8wJ19xhHHKzS9En31vZDfC58Sm3d2fhcURI

