--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: company_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO company_user;

--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: company_user
--

CREATE TABLE public.purchase_order_items (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    item_description text NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    unit character varying(20),
    total_price numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.purchase_order_items OWNER TO company_user;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: company_user
--

CREATE SEQUENCE public.purchase_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_items_id_seq OWNER TO company_user;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: company_user
--

ALTER SEQUENCE public.purchase_order_items_id_seq OWNED BY public.purchase_order_items.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: company_user
--

CREATE TABLE public.purchase_orders (
    id integer NOT NULL,
    purchase_request_id integer NOT NULL,
    supplier_id integer NOT NULL,
    order_number character varying(50) NOT NULL,
    order_date timestamp with time zone DEFAULT now() NOT NULL,
    expected_delivery_date timestamp with time zone,
    actual_delivery_date timestamp with time zone,
    total_amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying NOT NULL,
    status character varying(20) DEFAULT 'Ordered'::character varying NOT NULL,
    payment_status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.purchase_orders OWNER TO company_user;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: company_user
--

CREATE SEQUENCE public.purchase_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_orders_id_seq OWNER TO company_user;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: company_user
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: purchase_requests; Type: TABLE; Schema: public; Owner: company_user
--

CREATE TABLE public.purchase_requests (
    id integer NOT NULL,
    requester_name character varying(100) NOT NULL,
    department character varying(50),
    description text NOT NULL,
    category character varying(50),
    quantity integer NOT NULL,
    unit character varying(20),
    budget numeric(10,2),
    urgency_level character varying(20),
    status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_urgency_level CHECK (((urgency_level)::text = ANY ((ARRAY['Low'::character varying, 'Medium'::character varying, 'High'::character varying])::text[])))
);


ALTER TABLE public.purchase_requests OWNER TO company_user;

--
-- Name: purchase_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: company_user
--

CREATE SEQUENCE public.purchase_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_requests_id_seq OWNER TO company_user;

--
-- Name: purchase_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: company_user
--

ALTER SEQUENCE public.purchase_requests_id_seq OWNED BY public.purchase_requests.id;


--
-- Name: supplier_performance; Type: TABLE; Schema: public; Owner: company_user
--

CREATE TABLE public.supplier_performance (
    id integer NOT NULL,
    supplier_id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    delivery_rating integer NOT NULL,
    quality_rating integer NOT NULL,
    communication_rating integer NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_communication_rating CHECK (((communication_rating >= 1) AND (communication_rating <= 5))),
    CONSTRAINT check_delivery_rating CHECK (((delivery_rating >= 1) AND (delivery_rating <= 5))),
    CONSTRAINT check_quality_rating CHECK (((quality_rating >= 1) AND (quality_rating <= 5)))
);


ALTER TABLE public.supplier_performance OWNER TO company_user;

--
-- Name: supplier_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: company_user
--

CREATE SEQUENCE public.supplier_performance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_performance_id_seq OWNER TO company_user;

--
-- Name: supplier_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: company_user
--

ALTER SEQUENCE public.supplier_performance_id_seq OWNED BY public.supplier_performance.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: company_user
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    rating numeric(3,2),
    contact_email character varying(100),
    contact_phone character varying(20),
    payment_terms character varying(50),
    delivery_lead_time integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_rating_range CHECK (((rating >= (0)::numeric) AND (rating <= (5)::numeric)))
);


ALTER TABLE public.suppliers OWNER TO company_user;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: company_user
--

CREATE SEQUENCE public.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO company_user;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: company_user
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: purchase_order_items id; Type: DEFAULT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_order_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_items_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: purchase_requests id; Type: DEFAULT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_requests ALTER COLUMN id SET DEFAULT nextval('public.purchase_requests_id_seq'::regclass);


--
-- Name: supplier_performance id; Type: DEFAULT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.supplier_performance ALTER COLUMN id SET DEFAULT nextval('public.supplier_performance_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: company_user
--

COPY public.alembic_version (version_num) FROM stdin;
c2f1df39c0cc
\.


--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: company_user
--

COPY public.purchase_order_items (id, purchase_order_id, item_description, quantity, unit_price, unit, total_price, created_at) FROM stdin;
1	1	Notebook - Premium	2	4.93	pcs	9.86	2023-04-16 19:17:04.535236+00
2	2	Filing Cabinet - Standard	3	213.66	pcs	640.98	2024-12-04 19:17:04.535236+00
3	2	Filing Cabinet - Basic	3	188.68	pcs	566.04	2024-12-04 19:17:04.535236+00
4	2	Filing Cabinet - Standard	2	251.67	pcs	503.34	2024-12-04 19:17:04.535236+00
5	3	Printing Paper - Basic	1	12.50	box	12.50	2025-04-22 19:17:04.535236+00
6	3	Printing Paper - Basic	2	8.30	box	16.60	2025-04-22 19:17:04.535236+00
7	3	Printing Paper - Basic	4	9.02	box	36.08	2025-04-22 19:17:04.535236+00
8	4	Office Chair - Standard	4	281.79	pcs	1127.16	2024-11-16 19:17:04.535236+00
9	4	Office Chair - Premium	2	254.33	pcs	508.66	2024-11-16 19:17:04.535236+00
10	4	Office Chair - Basic	4	177.43	pcs	709.72	2024-11-16 19:17:04.535236+00
11	5	Stapler - Basic	3	9.61	pcs	28.83	2024-09-17 19:17:04.535236+00
12	5	Stapler - Basic	1	20.18	pcs	20.18	2024-09-17 19:17:04.535236+00
13	5	Stapler - Premium	1	18.50	pcs	18.50	2024-09-17 19:17:04.535236+00
14	6	Notebook - Standard	5	6.85	pcs	34.25	2024-07-29 19:17:04.535236+00
15	6	Notebook - Basic	1	7.31	pcs	7.31	2024-07-29 19:17:04.535236+00
16	7	Monitor - Premium	1	214.48	pcs	214.48	2023-03-02 19:17:04.535236+00
17	7	Monitor - Premium	2	294.96	pcs	589.92	2023-03-02 19:17:04.535236+00
18	8	Bookshelf - Standard	2	186.55	pcs	373.10	2025-04-20 19:17:04.535236+00
19	8	Bookshelf - Premium	5	166.09	pcs	830.45	2025-04-20 19:17:04.535236+00
20	8	Bookshelf - Basic	3	215.75	pcs	647.25	2025-04-20 19:17:04.535236+00
21	9	Keyboard - Basic	1	87.47	pcs	87.47	2023-06-22 19:17:04.535236+00
22	10	Sticky Notes - Basic	5	5.71	pack	28.55	2025-02-05 19:17:04.535236+00
23	10	Sticky Notes - Basic	1	4.90	pack	4.90	2025-02-05 19:17:04.535236+00
24	10	Sticky Notes - Basic	4	7.62	pack	30.48	2025-02-05 19:17:04.535236+00
25	11	Stapler - Basic	1	17.03	pcs	17.03	2024-09-03 19:17:04.535236+00
26	12	Desk - Standard	2	290.92	pcs	581.84	2023-11-21 19:17:04.535236+00
27	12	Desk - Basic	4	208.01	pcs	832.04	2023-11-21 19:17:04.535236+00
28	12	Desk - Basic	4	485.90	pcs	1943.60	2023-11-21 19:17:04.535236+00
29	13	Desk - Premium	3	369.71	pcs	1109.13	2025-05-18 19:17:04.535236+00
30	14	Sticky Notes - Standard	4	4.75	pack	19.00	2025-01-27 19:17:04.535236+00
31	14	Sticky Notes - Premium	3	4.97	pack	14.91	2025-01-27 19:17:04.535236+00
32	15	Laptop - Premium	1	538.24	pcs	538.24	2024-06-01 19:17:04.535236+00
33	15	Laptop - Standard	4	732.21	pcs	2928.84	2024-06-01 19:17:04.535236+00
34	16	Sticky Notes - Premium	2	2.93	pack	5.86	2024-12-07 19:17:04.535236+00
35	16	Sticky Notes - Premium	1	4.95	pack	4.95	2024-12-07 19:17:04.535236+00
36	17	Stapler - Premium	3	15.76	pcs	47.28	2025-04-08 19:17:04.535236+00
37	17	Stapler - Premium	3	15.63	pcs	46.89	2025-04-08 19:17:04.535236+00
38	17	Stapler - Premium	1	19.40	pcs	19.40	2025-04-08 19:17:04.535236+00
39	18	Stapler - Basic	4	19.57	pcs	78.28	2024-05-05 19:17:04.535236+00
40	19	Laptop - Basic	1	800.52	pcs	800.52	2023-06-02 19:17:04.535236+00
41	19	Laptop - Premium	2	717.28	pcs	1434.56	2023-06-02 19:17:04.535236+00
42	19	Laptop - Standard	4	612.69	pcs	2450.76	2023-06-02 19:17:04.535236+00
43	20	Laptop - Premium	2	450.85	pcs	901.70	2024-12-30 19:17:04.535236+00
44	20	Laptop - Basic	1	483.86	pcs	483.86	2024-12-30 19:17:04.535236+00
45	20	Laptop - Standard	5	716.54	pcs	3582.70	2024-12-30 19:17:04.535236+00
46	21	Headset - Basic	5	36.95	pcs	184.75	2024-06-10 19:17:04.535236+00
47	21	Headset - Standard	1	51.90	pcs	51.90	2024-06-10 19:17:04.535236+00
48	22	Stapler - Basic	3	18.06	pcs	54.18	2020-09-02 19:17:04.535236+00
49	23	Notebook - Basic	1	7.80	pcs	7.80	2024-08-08 19:17:04.535236+00
50	23	Notebook - Standard	1	8.97	pcs	8.97	2024-08-08 19:17:04.535236+00
51	23	Notebook - Basic	2	4.08	pcs	8.16	2024-08-08 19:17:04.535236+00
52	24	Printing Paper - Premium	3	12.83	box	38.49	2025-03-15 19:17:04.535236+00
53	25	Office Chair - Premium	4	202.06	pcs	808.24	2024-03-10 19:17:04.535236+00
54	25	Office Chair - Basic	3	285.73	pcs	857.19	2024-03-10 19:17:04.535236+00
55	25	Office Chair - Basic	5	240.65	pcs	1203.25	2024-03-10 19:17:04.535236+00
56	26	Stapler - Basic	1	12.18	pcs	12.18	2023-09-10 19:17:04.535236+00
57	27	Keyboard - Basic	1	90.97	pcs	90.97	2024-12-12 19:17:04.535236+00
58	28	Notebook - Premium	2	8.36	pcs	16.72	2023-07-31 19:17:04.535236+00
59	29	Printing Paper - Premium	2	5.26	box	10.52	2024-12-14 19:17:04.535236+00
60	29	Printing Paper - Premium	1	9.09	box	9.09	2024-12-14 19:17:04.535236+00
61	29	Printing Paper - Basic	2	5.74	box	11.48	2024-12-14 19:17:04.535236+00
62	30	Sticky Notes - Standard	5	5.47	pack	27.35	2024-02-19 19:17:04.535236+00
63	30	Sticky Notes - Premium	5	7.53	pack	37.65	2024-02-19 19:17:04.535236+00
64	31	Sticky Notes - Premium	4	5.23	pack	20.92	2025-01-08 19:17:04.535236+00
65	31	Sticky Notes - Basic	3	6.08	pack	18.24	2025-01-08 19:17:04.535236+00
66	31	Sticky Notes - Premium	3	6.32	pack	18.96	2025-01-08 19:17:04.535236+00
67	32	Pen Set - Premium	3	13.97	set	41.91	2025-05-07 19:17:04.535236+00
68	32	Pen Set - Premium	2	15.75	set	31.50	2025-05-07 19:17:04.535236+00
69	33	Printing Paper - Basic	2	6.90	box	13.80	2025-05-03 19:17:04.535236+00
70	33	Printing Paper - Basic	3	7.08	box	21.24	2025-05-03 19:17:04.535236+00
71	34	Printing Paper - Standard	1	10.33	box	10.33	2024-10-10 19:17:04.535236+00
72	34	Printing Paper - Premium	5	7.79	box	38.95	2024-10-10 19:17:04.535236+00
73	34	Printing Paper - Standard	3	11.94	box	35.82	2024-10-10 19:17:04.535236+00
74	35	Bookshelf - Premium	5	216.93	pcs	1084.65	2023-09-19 19:17:04.535236+00
75	35	Bookshelf - Basic	4	149.68	pcs	598.72	2023-09-19 19:17:04.535236+00
76	36	Stapler - Standard	1	10.10	pcs	10.10	2025-05-14 19:17:04.535236+00
77	36	Stapler - Basic	5	24.04	pcs	120.20	2025-05-14 19:17:04.535236+00
78	37	Printing Paper - Premium	5	11.07	box	55.35	2024-11-04 19:17:04.535236+00
79	37	Printing Paper - Standard	4	10.04	box	40.16	2024-11-04 19:17:04.535236+00
80	38	Stapler - Standard	1	11.95	pcs	11.95	2023-12-10 19:17:04.535236+00
81	38	Stapler - Premium	4	13.71	pcs	54.84	2023-12-10 19:17:04.535236+00
82	38	Stapler - Basic	5	15.27	pcs	76.35	2023-12-10 19:17:04.535236+00
83	39	Pen Set - Standard	2	13.47	set	26.94	2023-11-15 19:17:04.535236+00
84	39	Pen Set - Premium	5	11.19	set	55.95	2023-11-15 19:17:04.535236+00
85	39	Pen Set - Basic	5	17.05	set	85.25	2023-11-15 19:17:04.535236+00
86	40	Headset - Premium	1	85.42	pcs	85.42	2023-07-10 19:17:04.535236+00
87	41	Laptop - Basic	4	471.59	pcs	1886.36	2023-08-01 19:17:04.535236+00
88	42	Pen Set - Basic	5	8.76	set	43.80	2023-04-28 19:17:04.535236+00
89	42	Pen Set - Premium	1	10.53	set	10.53	2023-04-28 19:17:04.535236+00
90	42	Pen Set - Premium	4	11.30	set	45.20	2023-04-28 19:17:04.535236+00
91	43	Stapler - Premium	5	10.62	pcs	53.10	2024-12-08 19:17:04.535236+00
92	44	Printing Paper - Premium	1	7.63	box	7.63	2024-12-30 19:17:04.535236+00
93	45	Notebook - Standard	3	6.93	pcs	20.79	2025-02-28 19:17:04.535236+00
94	45	Notebook - Standard	4	5.38	pcs	21.52	2025-02-28 19:17:04.535236+00
95	46	Pen Set - Standard	4	17.38	set	69.52	2024-10-09 19:17:04.535236+00
96	46	Pen Set - Premium	3	20.23	set	60.69	2024-10-09 19:17:04.535236+00
97	47	Bookshelf - Basic	1	117.23	pcs	117.23	2024-01-18 19:17:04.535236+00
98	47	Bookshelf - Premium	1	88.49	pcs	88.49	2024-01-18 19:17:04.535236+00
99	48	Printing Paper - Premium	2	9.11	box	18.22	2025-05-08 19:17:04.535236+00
100	48	Printing Paper - Basic	2	5.54	box	11.08	2025-05-08 19:17:04.535236+00
101	48	Printing Paper - Basic	4	7.69	box	30.76	2025-05-08 19:17:04.535236+00
102	49	Laptop - Premium	2	745.43	pcs	1490.86	2025-03-18 19:17:04.535236+00
103	49	Laptop - Basic	5	578.60	pcs	2893.00	2025-03-18 19:17:04.535236+00
104	49	Laptop - Basic	4	702.93	pcs	2811.72	2025-03-18 19:17:04.535236+00
105	50	Stapler - Standard	2	12.91	pcs	25.82	2023-10-27 19:17:04.535236+00
106	50	Stapler - Premium	2	14.69	pcs	29.38	2023-10-27 19:17:04.535236+00
107	51	Stapler - Basic	1	17.07	pcs	17.07	2023-09-11 19:17:04.535236+00
108	51	Stapler - Standard	4	10.91	pcs	43.64	2023-09-11 19:17:04.535236+00
109	52	Pen Set - Standard	4	13.18	set	52.72	2024-12-30 19:17:04.535236+00
110	53	Notebook - Premium	4	7.66	pcs	30.64	2023-01-30 19:17:04.535236+00
111	54	Office Chair - Premium	4	227.60	pcs	910.40	2022-01-09 19:17:04.535236+00
112	55	Desk - Premium	5	222.29	pcs	1111.45	2023-09-08 19:17:04.535236+00
113	56	Printing Paper - Basic	2	13.63	box	27.26	2024-11-19 19:17:04.535236+00
114	56	Printing Paper - Premium	2	12.92	box	25.84	2024-11-19 19:17:04.535236+00
115	57	Keyboard - Standard	3	50.69	pcs	152.07	2022-08-22 19:17:04.535236+00
116	57	Keyboard - Premium	1	83.05	pcs	83.05	2022-08-22 19:17:04.535236+00
117	58	Stapler - Standard	1	17.36	pcs	17.36	2021-02-05 19:17:04.535236+00
118	58	Stapler - Basic	3	14.92	pcs	44.76	2021-02-05 19:17:04.535236+00
119	59	Bookshelf - Basic	5	210.14	pcs	1050.70	2023-09-26 19:17:04.535236+00
120	59	Bookshelf - Premium	5	115.29	pcs	576.45	2023-09-26 19:17:04.535236+00
121	60	Sticky Notes - Standard	2	6.11	pack	12.22	2025-04-19 19:17:04.535236+00
122	60	Sticky Notes - Standard	1	5.31	pack	5.31	2025-04-19 19:17:04.535236+00
123	61	Stapler - Standard	5	17.14	pcs	85.70	2023-10-13 19:17:04.535236+00
124	62	Notebook - Premium	4	9.12	pcs	36.48	2025-05-29 19:17:04.535236+00
125	62	Notebook - Standard	2	6.19	pcs	12.38	2025-05-29 19:17:04.535236+00
126	62	Notebook - Standard	3	6.35	pcs	19.05	2025-05-29 19:17:04.535236+00
127	63	Stapler - Standard	2	10.21	pcs	20.42	2024-10-01 19:17:04.535236+00
128	63	Stapler - Standard	1	20.55	pcs	20.55	2024-10-01 19:17:04.535236+00
129	63	Stapler - Standard	3	17.55	pcs	52.65	2024-10-01 19:17:04.535236+00
130	64	Laptop - Standard	1	741.78	pcs	741.78	2025-05-05 19:17:04.535236+00
131	64	Laptop - Standard	4	448.95	pcs	1795.80	2025-05-05 19:17:04.535236+00
132	64	Laptop - Premium	1	574.35	pcs	574.35	2025-05-05 19:17:04.535236+00
133	65	Pen Set - Basic	1	18.66	set	18.66	2023-07-11 19:17:04.535236+00
134	66	Pen Set - Basic	1	10.77	set	10.77	2024-11-29 19:17:04.535236+00
135	67	Printing Paper - Standard	2	8.01	box	16.02	2022-09-13 19:17:04.535236+00
136	68	Filing Cabinet - Premium	1	310.78	pcs	310.78	2022-03-23 19:17:04.535236+00
137	68	Filing Cabinet - Premium	4	373.04	pcs	1492.16	2022-03-23 19:17:04.535236+00
138	69	Desk - Standard	4	455.90	pcs	1823.60	2024-04-07 19:17:04.535236+00
139	69	Desk - Standard	5	459.06	pcs	2295.30	2024-04-07 19:17:04.535236+00
140	69	Desk - Premium	4	402.67	pcs	1610.68	2024-04-07 19:17:04.535236+00
141	70	Stapler - Basic	1	21.34	pcs	21.34	2025-02-23 19:17:04.535236+00
142	70	Stapler - Standard	1	17.19	pcs	17.19	2025-02-23 19:17:04.535236+00
143	71	Notebook - Standard	4	6.18	pcs	24.72	2024-01-10 19:17:04.535236+00
144	71	Notebook - Standard	3	4.16	pcs	12.48	2024-01-10 19:17:04.535236+00
145	72	Sticky Notes - Basic	3	5.81	pack	17.43	2024-07-06 19:17:04.535236+00
146	72	Sticky Notes - Standard	1	7.92	pack	7.92	2024-07-06 19:17:04.535236+00
147	72	Sticky Notes - Basic	2	4.55	pack	9.10	2024-07-06 19:17:04.535236+00
148	73	Notebook - Standard	5	7.75	pcs	38.75	2024-03-22 19:17:04.535236+00
149	73	Notebook - Standard	2	4.79	pcs	9.58	2024-03-22 19:17:04.535236+00
150	74	Headset - Premium	2	62.56	pcs	125.12	2023-01-22 19:17:04.535236+00
151	75	Laptop - Basic	5	681.47	pcs	3407.35	2025-05-10 19:17:04.535236+00
152	75	Laptop - Standard	3	742.28	pcs	2226.84	2025-05-10 19:17:04.535236+00
153	75	Laptop - Standard	2	445.30	pcs	890.60	2025-05-10 19:17:04.535236+00
154	76	Pen Set - Basic	3	8.21	set	24.63	2025-02-08 19:17:04.535236+00
155	77	Sticky Notes - Basic	3	3.41	pack	10.23	2024-05-07 19:17:04.535236+00
156	78	Filing Cabinet - Standard	1	234.17	pcs	234.17	2021-11-05 19:17:04.535236+00
157	79	Sticky Notes - Basic	5	8.00	pack	40.00	2024-07-27 19:17:04.535236+00
158	79	Sticky Notes - Premium	2	5.07	pack	10.14	2024-07-27 19:17:04.535236+00
159	80	Stapler - Basic	3	12.90	pcs	38.70	2023-12-28 19:17:04.535236+00
160	80	Stapler - Basic	3	13.22	pcs	39.66	2023-12-28 19:17:04.535236+00
161	81	Desk - Standard	5	441.10	pcs	2205.50	2023-11-22 19:17:04.535236+00
162	81	Desk - Standard	3	267.69	pcs	803.07	2023-11-22 19:17:04.535236+00
163	82	Sticky Notes - Standard	1	3.67	pack	3.67	2024-06-03 19:17:04.535236+00
164	83	Pen Set - Standard	4	18.91	set	75.64	2025-05-19 19:17:04.535236+00
165	83	Pen Set - Standard	2	8.52	set	17.04	2025-05-19 19:17:04.535236+00
166	84	Stapler - Basic	5	17.34	pcs	86.70	2024-12-10 19:17:04.535236+00
167	84	Stapler - Standard	3	13.02	pcs	39.06	2024-12-10 19:17:04.535236+00
168	84	Stapler - Premium	5	13.17	pcs	65.85	2024-12-10 19:17:04.535236+00
169	85	Mouse - Standard	5	49.01	pcs	245.05	2024-07-12 19:17:04.535236+00
170	85	Mouse - Premium	1	28.51	pcs	28.51	2024-07-12 19:17:04.535236+00
171	85	Mouse - Standard	2	35.29	pcs	70.58	2024-07-12 19:17:04.535236+00
172	86	Bookshelf - Premium	5	199.35	pcs	996.75	2025-01-20 19:17:04.535236+00
173	86	Bookshelf - Premium	3	173.29	pcs	519.87	2025-01-20 19:17:04.535236+00
174	86	Bookshelf - Standard	2	110.43	pcs	220.86	2025-01-20 19:17:04.535236+00
175	87	Pen Set - Basic	5	18.45	set	92.25	2024-11-12 19:17:04.535236+00
176	88	Stapler - Basic	3	15.86	pcs	47.58	2025-04-17 19:17:04.535236+00
177	88	Stapler - Basic	3	19.67	pcs	59.01	2025-04-17 19:17:04.535236+00
178	89	Laptop - Basic	3	399.09	pcs	1197.27	2023-12-06 19:17:04.535236+00
179	89	Laptop - Premium	1	669.79	pcs	669.79	2023-12-06 19:17:04.535236+00
180	89	Laptop - Premium	1	470.41	pcs	470.41	2023-12-06 19:17:04.535236+00
181	90	Bookshelf - Standard	5	197.27	pcs	986.35	2024-04-15 19:17:04.535236+00
182	91	Notebook - Standard	5	3.62	pcs	18.10	2023-06-03 19:17:04.535236+00
183	91	Notebook - Basic	2	3.03	pcs	6.06	2023-06-03 19:17:04.535236+00
184	91	Notebook - Premium	2	7.14	pcs	14.28	2023-06-03 19:17:04.535236+00
185	92	Mouse - Premium	5	40.93	pcs	204.65	2023-12-08 19:17:04.535236+00
186	93	Office Chair - Standard	5	193.58	pcs	967.90	2025-02-09 19:17:04.535236+00
187	93	Office Chair - Basic	1	232.00	pcs	232.00	2025-02-09 19:17:04.535236+00
188	93	Office Chair - Basic	3	121.03	pcs	363.09	2025-02-09 19:17:04.535236+00
189	94	Filing Cabinet - Premium	5	265.95	pcs	1329.75	2022-12-25 19:17:04.535236+00
190	94	Filing Cabinet - Basic	4	392.47	pcs	1569.88	2022-12-25 19:17:04.535236+00
191	94	Filing Cabinet - Premium	3	338.55	pcs	1015.65	2022-12-25 19:17:04.535236+00
192	95	Pen Set - Premium	2	10.01	set	20.02	2024-02-02 19:17:04.535236+00
193	95	Pen Set - Premium	1	12.72	set	12.72	2024-02-02 19:17:04.535236+00
194	95	Pen Set - Premium	5	9.28	set	46.40	2024-02-02 19:17:04.535236+00
195	96	Stapler - Basic	4	21.83	pcs	87.32	2025-03-14 19:17:04.535236+00
196	96	Stapler - Basic	3	10.00	pcs	30.00	2025-03-14 19:17:04.535236+00
197	96	Stapler - Basic	4	25.04	pcs	100.16	2025-03-14 19:17:04.535236+00
198	97	Sticky Notes - Standard	1	2.10	pack	2.10	2024-12-03 19:17:04.535236+00
199	97	Sticky Notes - Premium	5	2.60	pack	13.00	2024-12-03 19:17:04.535236+00
200	98	Stapler - Standard	5	17.33	pcs	86.65	2022-11-29 19:17:04.535236+00
201	99	Conference Table - Standard	5	558.08	pcs	2790.40	2025-03-14 19:17:04.535236+00
202	99	Conference Table - Standard	2	661.55	pcs	1323.10	2025-03-14 19:17:04.535236+00
203	100	Desk - Basic	3	260.28	pcs	780.84	2024-12-28 19:17:04.535236+00
204	101	Notebook - Standard	4	3.86	pcs	15.44	2022-09-11 19:17:04.535236+00
205	102	Conference Table - Premium	1	591.75	pcs	591.75	2023-06-05 19:17:04.535236+00
206	103	Pen Set - Basic	3	12.82	set	38.46	2024-04-20 19:17:04.535236+00
207	103	Pen Set - Premium	3	14.11	set	42.33	2024-04-20 19:17:04.535236+00
208	103	Pen Set - Standard	1	11.98	set	11.98	2024-04-20 19:17:04.535236+00
209	104	Headset - Premium	2	144.05	pcs	288.10	2023-07-13 19:17:04.535236+00
210	105	Notebook - Basic	2	7.51	pcs	15.02	2025-03-18 19:17:04.535236+00
211	105	Notebook - Standard	4	9.75	pcs	39.00	2025-03-18 19:17:04.535236+00
212	106	Pen Set - Premium	2	11.44	set	22.88	2025-02-27 19:17:04.535236+00
213	106	Pen Set - Standard	4	11.58	set	46.32	2025-02-27 19:17:04.535236+00
214	106	Pen Set - Standard	2	12.86	set	25.72	2025-02-27 19:17:04.535236+00
215	107	Notebook - Premium	5	6.47	pcs	32.35	2020-12-11 19:17:04.535236+00
216	108	Sticky Notes - Basic	2	3.12	pack	6.24	2022-07-01 19:17:04.535236+00
217	109	Monitor - Premium	3	153.73	pcs	461.19	2024-05-09 19:17:04.535236+00
218	109	Monitor - Standard	5	245.72	pcs	1228.60	2024-05-09 19:17:04.535236+00
219	110	Desk - Premium	5	350.33	pcs	1751.65	2021-02-12 19:17:04.535236+00
220	110	Desk - Basic	2	463.46	pcs	926.92	2021-02-12 19:17:04.535236+00
221	110	Desk - Standard	2	353.92	pcs	707.84	2021-02-12 19:17:04.535236+00
222	111	Conference Table - Premium	5	1795.41	pcs	8977.05	2024-09-14 19:17:04.535236+00
223	111	Conference Table - Standard	5	1853.21	pcs	9266.05	2024-09-14 19:17:04.535236+00
224	112	Printing Paper - Basic	3	12.32	box	36.96	2025-04-13 19:17:04.535236+00
225	112	Printing Paper - Basic	4	13.74	box	54.96	2025-04-13 19:17:04.535236+00
226	113	Headset - Basic	1	118.37	pcs	118.37	2023-06-16 19:17:04.535236+00
227	114	Keyboard - Standard	3	78.15	pcs	234.45	2024-03-16 19:17:04.535236+00
228	115	Stapler - Premium	3	20.26	pcs	60.78	2025-02-17 19:17:04.535236+00
229	115	Stapler - Basic	1	18.47	pcs	18.47	2025-02-17 19:17:04.535236+00
230	115	Stapler - Basic	2	21.19	pcs	42.38	2025-02-17 19:17:04.535236+00
231	116	Office Chair - Premium	5	232.36	pcs	1161.80	2023-06-30 19:17:04.535236+00
232	116	Office Chair - Standard	5	263.46	pcs	1317.30	2023-06-30 19:17:04.535236+00
233	117	Mouse - Premium	3	34.24	pcs	102.72	2025-05-30 19:17:04.535236+00
234	117	Mouse - Premium	4	35.50	pcs	142.00	2025-05-30 19:17:04.535236+00
235	117	Mouse - Standard	5	28.05	pcs	140.25	2025-05-30 19:17:04.535236+00
236	118	Headset - Standard	5	82.66	pcs	413.30	2025-04-29 19:17:04.535236+00
237	118	Headset - Basic	1	79.11	pcs	79.11	2025-04-29 19:17:04.535236+00
238	119	Sticky Notes - Premium	1	2.47	pack	2.47	2024-02-06 19:17:04.535236+00
239	119	Sticky Notes - Premium	4	6.32	pack	25.28	2024-02-06 19:17:04.535236+00
240	120	Headset - Standard	5	133.52	pcs	667.60	2025-04-30 19:17:04.535236+00
241	120	Headset - Premium	2	50.84	pcs	101.68	2025-04-30 19:17:04.535236+00
242	120	Headset - Standard	5	47.59	pcs	237.95	2025-04-30 19:17:04.535236+00
243	121	Bookshelf - Basic	1	180.72	pcs	180.72	2024-11-01 19:17:04.535236+00
244	121	Bookshelf - Standard	5	211.30	pcs	1056.50	2024-11-01 19:17:04.535236+00
245	121	Bookshelf - Basic	4	102.22	pcs	408.88	2024-11-01 19:17:04.535236+00
246	122	Bookshelf - Standard	2	196.37	pcs	392.74	2024-09-22 19:17:04.535236+00
247	122	Bookshelf - Standard	3	171.50	pcs	514.50	2024-09-22 19:17:04.535236+00
248	123	Filing Cabinet - Basic	5	281.95	pcs	1409.75	2022-01-04 19:17:04.535236+00
249	123	Filing Cabinet - Standard	1	397.34	pcs	397.34	2022-01-04 19:17:04.535236+00
250	123	Filing Cabinet - Standard	5	337.04	pcs	1685.20	2022-01-04 19:17:04.535236+00
251	124	Conference Table - Premium	1	1463.45	pcs	1463.45	2021-08-29 19:17:04.535236+00
252	124	Conference Table - Basic	3	1963.26	pcs	5889.78	2021-08-29 19:17:04.535236+00
253	125	Sticky Notes - Basic	2	5.64	pack	11.28	2025-03-08 19:17:04.535236+00
254	125	Sticky Notes - Basic	4	6.15	pack	24.60	2025-03-08 19:17:04.535236+00
255	125	Sticky Notes - Standard	3	2.51	pack	7.53	2025-03-08 19:17:04.535236+00
256	126	Printing Paper - Premium	2	5.37	box	10.74	2021-10-24 19:17:04.535236+00
257	126	Printing Paper - Standard	1	5.70	box	5.70	2021-10-24 19:17:04.535236+00
258	127	Sticky Notes - Standard	4	3.31	pack	13.24	2024-11-05 19:17:04.535236+00
259	128	Conference Table - Premium	1	531.99	pcs	531.99	2025-05-30 19:17:04.535236+00
260	128	Conference Table - Premium	5	1264.34	pcs	6321.70	2025-05-30 19:17:04.535236+00
261	129	Printing Paper - Standard	1	10.97	box	10.97	2024-01-13 19:17:04.535236+00
262	130	Conference Table - Premium	3	483.90	pcs	1451.70	2023-12-03 19:17:04.535236+00
263	131	Printing Paper - Standard	3	9.72	box	29.16	2024-06-18 19:17:04.535236+00
264	131	Printing Paper - Premium	4	9.33	box	37.32	2024-06-18 19:17:04.535236+00
265	131	Printing Paper - Standard	3	9.12	box	27.36	2024-06-18 19:17:04.535236+00
266	132	Keyboard - Basic	2	77.41	pcs	154.82	2024-12-14 19:17:04.535236+00
267	132	Keyboard - Premium	2	56.33	pcs	112.66	2024-12-14 19:17:04.535236+00
268	132	Keyboard - Standard	1	52.48	pcs	52.48	2024-12-14 19:17:04.535236+00
269	133	Keyboard - Standard	1	100.98	pcs	100.98	2023-10-13 19:17:04.535236+00
270	133	Keyboard - Standard	2	64.77	pcs	129.54	2023-10-13 19:17:04.535236+00
271	134	Conference Table - Basic	5	1690.76	pcs	8453.80	2024-11-05 19:17:04.535236+00
272	135	Stapler - Premium	4	22.84	pcs	91.36	2024-05-18 19:17:04.535236+00
273	135	Stapler - Premium	3	20.06	pcs	60.18	2024-05-18 19:17:04.535236+00
274	135	Stapler - Basic	1	20.32	pcs	20.32	2024-05-18 19:17:04.535236+00
275	136	Pen Set - Basic	1	9.61	set	9.61	2024-12-02 19:17:04.535236+00
276	137	Notebook - Standard	5	6.01	pcs	30.05	2025-01-14 19:17:04.535236+00
277	137	Notebook - Standard	1	8.34	pcs	8.34	2025-01-14 19:17:04.535236+00
278	137	Notebook - Premium	5	3.31	pcs	16.55	2025-01-14 19:17:04.535236+00
279	138	Pen Set - Basic	2	14.16	set	28.32	2025-03-12 19:17:04.535236+00
280	139	Sticky Notes - Basic	3	7.65	pack	22.95	2024-08-18 19:17:04.535236+00
281	140	Desk - Premium	2	433.78	pcs	867.56	2025-03-21 19:17:04.535236+00
282	140	Desk - Premium	3	332.72	pcs	998.16	2025-03-21 19:17:04.535236+00
283	141	Laptop - Basic	5	532.28	pcs	2661.40	2023-10-01 19:17:04.535236+00
284	141	Laptop - Premium	4	419.52	pcs	1678.08	2023-10-01 19:17:04.535236+00
285	142	Sticky Notes - Standard	2	5.36	pack	10.72	2021-08-28 19:17:04.535236+00
286	142	Sticky Notes - Premium	4	3.18	pack	12.72	2021-08-28 19:17:04.535236+00
287	142	Sticky Notes - Standard	2	6.38	pack	12.76	2021-08-28 19:17:04.535236+00
288	143	Notebook - Premium	4	7.95	pcs	31.80	2023-10-25 19:17:04.535236+00
289	144	Mouse - Premium	2	27.24	pcs	54.48	2023-09-03 19:17:04.535236+00
290	145	Headset - Basic	1	54.92	pcs	54.92	2024-05-05 19:17:04.535236+00
291	145	Headset - Basic	5	133.16	pcs	665.80	2024-05-05 19:17:04.535236+00
292	145	Headset - Premium	4	84.58	pcs	338.32	2024-05-05 19:17:04.535236+00
293	146	Printing Paper - Premium	2	10.59	box	21.18	2023-12-22 19:17:04.535236+00
294	146	Printing Paper - Basic	2	5.49	box	10.98	2023-12-22 19:17:04.535236+00
295	146	Printing Paper - Basic	4	6.03	box	24.12	2023-12-22 19:17:04.535236+00
296	147	Notebook - Basic	5	6.81	pcs	34.05	2024-12-06 19:17:04.535236+00
297	147	Notebook - Standard	2	3.27	pcs	6.54	2024-12-06 19:17:04.535236+00
298	148	Monitor - Basic	5	300.50	pcs	1502.50	2024-02-11 19:17:04.535236+00
299	148	Monitor - Standard	4	210.02	pcs	840.08	2024-02-11 19:17:04.535236+00
300	148	Monitor - Basic	4	192.28	pcs	769.12	2024-02-11 19:17:04.535236+00
301	149	Monitor - Standard	5	178.08	pcs	890.40	2024-03-08 19:17:04.535236+00
302	149	Monitor - Premium	2	164.11	pcs	328.22	2024-03-08 19:17:04.535236+00
303	149	Monitor - Basic	2	248.66	pcs	497.32	2024-03-08 19:17:04.535236+00
304	150	Laptop - Basic	1	425.39	pcs	425.39	2024-01-14 19:17:04.535236+00
305	150	Laptop - Premium	3	543.78	pcs	1631.34	2024-01-14 19:17:04.535236+00
306	150	Laptop - Premium	1	662.53	pcs	662.53	2024-01-14 19:17:04.535236+00
307	151	Sticky Notes - Basic	3	4.14	pack	12.42	2022-12-14 19:17:04.535236+00
308	151	Sticky Notes - Premium	4	4.58	pack	18.32	2022-12-14 19:17:04.535236+00
309	152	Sticky Notes - Standard	1	7.14	pack	7.14	2023-12-16 19:17:04.535236+00
310	152	Sticky Notes - Standard	1	4.38	pack	4.38	2023-12-16 19:17:04.535236+00
311	153	Monitor - Basic	1	280.65	pcs	280.65	2024-01-28 19:17:04.535236+00
312	154	Stapler - Basic	3	11.21	pcs	33.63	2025-05-19 19:17:04.535236+00
313	154	Stapler - Premium	4	12.41	pcs	49.64	2025-05-19 19:17:04.535236+00
314	154	Stapler - Premium	3	16.50	pcs	49.50	2025-05-19 19:17:04.535236+00
315	155	Notebook - Standard	3	6.22	pcs	18.66	2024-04-30 19:17:04.535236+00
316	156	Printing Paper - Basic	1	13.02	box	13.02	2025-02-08 19:17:04.535236+00
317	156	Printing Paper - Standard	5	5.74	box	28.70	2025-02-08 19:17:04.535236+00
318	157	Pen Set - Standard	4	9.35	set	37.40	2024-01-01 19:17:04.535236+00
319	158	Desk - Standard	2	246.45	pcs	492.90	2023-03-08 19:17:04.535236+00
320	159	Bookshelf - Premium	1	140.36	pcs	140.36	2025-03-25 19:17:04.535236+00
321	159	Bookshelf - Basic	1	84.97	pcs	84.97	2025-03-25 19:17:04.535236+00
322	160	Conference Table - Basic	4	1913.49	pcs	7653.96	2024-08-22 19:17:04.535236+00
323	161	Printing Paper - Basic	4	10.35	box	41.40	2021-05-11 19:17:04.535236+00
324	162	Desk - Basic	4	359.15	pcs	1436.60	2022-07-16 19:17:04.535236+00
325	162	Desk - Premium	1	413.94	pcs	413.94	2022-07-16 19:17:04.535236+00
326	163	Filing Cabinet - Basic	3	345.30	pcs	1035.90	2024-10-21 19:17:04.535236+00
327	163	Filing Cabinet - Standard	2	201.08	pcs	402.16	2024-10-21 19:17:04.535236+00
328	164	Filing Cabinet - Premium	2	351.85	pcs	703.70	2025-05-01 19:17:04.535236+00
329	164	Filing Cabinet - Basic	4	260.94	pcs	1043.76	2025-05-01 19:17:04.535236+00
330	165	Notebook - Basic	4	4.09	pcs	16.36	2023-05-30 19:17:04.535236+00
331	165	Notebook - Premium	3	9.06	pcs	27.18	2023-05-30 19:17:04.535236+00
332	165	Notebook - Premium	5	6.38	pcs	31.90	2023-05-30 19:17:04.535236+00
333	166	Notebook - Premium	5	4.10	pcs	20.50	2023-09-30 19:17:04.535236+00
334	166	Notebook - Premium	1	6.64	pcs	6.64	2023-09-30 19:17:04.535236+00
335	167	Bookshelf - Standard	3	123.21	pcs	369.63	2025-02-03 19:17:04.535236+00
336	167	Bookshelf - Basic	1	130.76	pcs	130.76	2025-02-03 19:17:04.535236+00
337	168	Sticky Notes - Premium	1	2.44	pack	2.44	2025-03-21 19:17:04.535236+00
338	168	Sticky Notes - Standard	4	2.96	pack	11.84	2025-03-21 19:17:04.535236+00
339	169	Pen Set - Basic	2	13.45	set	26.90	2024-04-20 19:17:04.535236+00
340	170	Pen Set - Standard	2	19.78	set	39.56	2022-02-25 19:17:04.535236+00
341	170	Pen Set - Standard	3	13.14	set	39.42	2022-02-25 19:17:04.535236+00
342	171	Stapler - Standard	1	24.51	pcs	24.51	2021-09-27 19:17:04.535236+00
343	171	Stapler - Premium	3	18.74	pcs	56.22	2021-09-27 19:17:04.535236+00
344	172	Printing Paper - Standard	1	10.16	box	10.16	2022-03-11 19:17:04.535236+00
345	173	Sticky Notes - Basic	4	4.70	pack	18.80	2024-10-10 19:17:04.535236+00
346	173	Sticky Notes - Standard	4	5.89	pack	23.56	2024-10-10 19:17:04.535236+00
347	173	Sticky Notes - Premium	4	5.73	pack	22.92	2024-10-10 19:17:04.535236+00
348	174	Bookshelf - Standard	1	224.53	pcs	224.53	2025-03-03 19:17:04.535236+00
349	175	Filing Cabinet - Premium	4	345.45	pcs	1381.80	2024-09-05 19:17:04.535236+00
350	176	Conference Table - Premium	3	810.76	pcs	2432.28	2024-04-21 19:17:04.535236+00
351	176	Conference Table - Standard	2	822.21	pcs	1644.42	2024-04-21 19:17:04.535236+00
352	176	Conference Table - Premium	2	1861.01	pcs	3722.02	2024-04-21 19:17:04.535236+00
353	177	Notebook - Basic	4	5.21	pcs	20.84	2023-01-23 19:17:04.535236+00
354	177	Notebook - Basic	1	5.74	pcs	5.74	2023-01-23 19:17:04.535236+00
355	178	Notebook - Basic	5	7.12	pcs	35.60	2024-04-29 19:17:04.535236+00
356	178	Notebook - Premium	3	9.94	pcs	29.82	2024-04-29 19:17:04.535236+00
357	178	Notebook - Premium	2	9.58	pcs	19.16	2024-04-29 19:17:04.535236+00
358	179	Headset - Basic	4	143.90	pcs	575.60	2024-05-14 19:17:04.535236+00
359	180	Desk - Standard	4	403.61	pcs	1614.44	2023-07-06 19:17:04.535236+00
360	181	Laptop - Standard	5	594.74	pcs	2973.70	2023-12-03 19:17:04.535236+00
361	182	Notebook - Premium	4	4.40	pcs	17.60	2024-05-26 19:17:04.535236+00
362	182	Notebook - Premium	4	3.14	pcs	12.56	2024-05-26 19:17:04.535236+00
363	182	Notebook - Standard	1	5.72	pcs	5.72	2024-05-26 19:17:04.535236+00
364	183	Notebook - Standard	3	9.09	pcs	27.27	2024-07-06 19:17:04.535236+00
365	183	Notebook - Premium	2	5.27	pcs	10.54	2024-07-06 19:17:04.535236+00
366	183	Notebook - Basic	2	7.87	pcs	15.74	2024-07-06 19:17:04.535236+00
367	184	Stapler - Basic	2	14.36	pcs	28.72	2023-04-13 19:17:04.535236+00
368	184	Stapler - Premium	1	23.35	pcs	23.35	2023-04-13 19:17:04.535236+00
369	185	Notebook - Premium	1	5.01	pcs	5.01	2025-05-23 19:17:04.535236+00
370	185	Notebook - Standard	3	4.13	pcs	12.39	2025-05-23 19:17:04.535236+00
371	185	Notebook - Premium	1	3.44	pcs	3.44	2025-05-23 19:17:04.535236+00
372	186	Filing Cabinet - Premium	5	258.90	pcs	1294.50	2025-01-10 19:17:04.535236+00
373	187	Office Chair - Standard	2	255.46	pcs	510.92	2024-07-28 19:17:04.535236+00
374	187	Office Chair - Premium	1	134.22	pcs	134.22	2024-07-28 19:17:04.535236+00
375	187	Office Chair - Standard	3	215.38	pcs	646.14	2024-07-28 19:17:04.535236+00
376	188	Printing Paper - Standard	5	8.12	box	40.60	2024-03-30 19:17:04.535236+00
377	189	Printing Paper - Standard	4	8.79	box	35.16	2021-06-01 19:17:04.535236+00
378	189	Printing Paper - Premium	4	10.00	box	40.00	2021-06-01 19:17:04.535236+00
379	190	Office Chair - Standard	5	226.18	pcs	1130.90	2022-11-23 19:17:04.535236+00
380	190	Office Chair - Basic	5	271.34	pcs	1356.70	2022-11-23 19:17:04.535236+00
381	191	Laptop - Basic	5	782.46	pcs	3912.30	2025-02-08 19:17:04.535236+00
382	192	Stapler - Basic	4	19.03	pcs	76.12	2024-03-05 19:17:04.535236+00
383	192	Stapler - Standard	4	23.99	pcs	95.96	2024-03-05 19:17:04.535236+00
384	192	Stapler - Standard	4	23.56	pcs	94.24	2024-03-05 19:17:04.535236+00
385	193	Keyboard - Basic	1	61.54	pcs	61.54	2024-09-24 19:17:04.535236+00
386	194	Printing Paper - Basic	2	8.90	box	17.80	2022-08-28 19:17:04.535236+00
387	194	Printing Paper - Basic	3	6.79	box	20.37	2022-08-28 19:17:04.535236+00
388	195	Stapler - Basic	1	13.90	pcs	13.90	2025-05-06 19:17:04.535236+00
389	195	Stapler - Basic	1	17.59	pcs	17.59	2025-05-06 19:17:04.535236+00
390	195	Stapler - Premium	1	16.59	pcs	16.59	2025-05-06 19:17:04.535236+00
391	196	Keyboard - Standard	4	69.11	pcs	276.44	2024-12-12 19:17:04.535236+00
392	196	Keyboard - Premium	2	56.07	pcs	112.14	2024-12-12 19:17:04.535236+00
393	196	Keyboard - Premium	2	56.59	pcs	113.18	2024-12-12 19:17:04.535236+00
394	197	Notebook - Basic	5	9.07	pcs	45.35	2023-07-17 19:17:04.535236+00
395	198	Desk - Premium	3	502.46	pcs	1507.38	2020-09-27 19:17:04.535236+00
396	199	Keyboard - Standard	2	95.38	pcs	190.76	2022-06-08 19:17:04.535236+00
397	199	Keyboard - Premium	2	98.93	pcs	197.86	2022-06-08 19:17:04.535236+00
398	200	Conference Table - Premium	3	1371.17	pcs	4113.51	2023-12-03 19:17:04.535236+00
399	200	Conference Table - Premium	4	1839.75	pcs	7359.00	2023-12-03 19:17:04.535236+00
400	200	Conference Table - Standard	5	932.38	pcs	4661.90	2023-12-03 19:17:04.535236+00
401	201	Notebook - Premium	5	4.13	pcs	20.65	2024-07-26 19:17:04.535236+00
402	202	Office Chair - Premium	3	239.95	pcs	719.85	2024-09-19 19:17:04.535236+00
403	202	Office Chair - Basic	5	218.54	pcs	1092.70	2024-09-19 19:17:04.535236+00
404	203	Printing Paper - Premium	1	8.88	box	8.88	2022-04-09 19:17:04.535236+00
405	204	Stapler - Premium	4	21.12	pcs	84.48	2025-03-25 19:17:04.535236+00
406	204	Stapler - Premium	5	15.44	pcs	77.20	2025-03-25 19:17:04.535236+00
407	204	Stapler - Premium	4	14.53	pcs	58.12	2025-03-25 19:17:04.535236+00
408	205	Laptop - Standard	1	517.17	pcs	517.17	2024-08-02 19:17:04.535236+00
409	205	Laptop - Basic	4	659.64	pcs	2638.56	2024-08-02 19:17:04.535236+00
410	205	Laptop - Standard	1	636.00	pcs	636.00	2024-08-02 19:17:04.535236+00
411	206	Sticky Notes - Premium	5	2.10	pack	10.50	2024-12-24 19:17:04.535236+00
412	206	Sticky Notes - Basic	4	4.92	pack	19.68	2024-12-24 19:17:04.535236+00
413	207	Filing Cabinet - Premium	1	278.35	pcs	278.35	2024-08-11 19:17:04.535236+00
414	207	Filing Cabinet - Premium	5	357.06	pcs	1785.30	2024-08-11 19:17:04.535236+00
415	208	Stapler - Basic	1	16.88	pcs	16.88	2023-11-18 19:17:04.535236+00
416	208	Stapler - Basic	1	23.20	pcs	23.20	2023-11-18 19:17:04.535236+00
417	208	Stapler - Standard	2	22.28	pcs	44.56	2023-11-18 19:17:04.535236+00
418	209	Printing Paper - Basic	1	9.50	box	9.50	2024-08-10 19:17:04.535236+00
419	209	Printing Paper - Premium	5	6.07	box	30.35	2024-08-10 19:17:04.535236+00
420	209	Printing Paper - Premium	4	7.34	box	29.36	2024-08-10 19:17:04.535236+00
421	210	Headset - Basic	2	140.16	pcs	280.32	2021-06-29 19:17:04.535236+00
422	210	Headset - Standard	3	103.58	pcs	310.74	2021-06-29 19:17:04.535236+00
423	210	Headset - Premium	4	57.63	pcs	230.52	2021-06-29 19:17:04.535236+00
424	211	Stapler - Premium	5	19.71	pcs	98.55	2024-01-17 19:17:04.535236+00
425	211	Stapler - Basic	2	22.43	pcs	44.86	2024-01-17 19:17:04.535236+00
426	211	Stapler - Basic	4	21.97	pcs	87.88	2024-01-17 19:17:04.535236+00
427	212	Monitor - Premium	3	215.76	pcs	647.28	2022-02-23 19:17:04.535236+00
428	212	Monitor - Basic	4	156.17	pcs	624.68	2022-02-23 19:17:04.535236+00
429	212	Monitor - Standard	3	203.14	pcs	609.42	2022-02-23 19:17:04.535236+00
430	213	Notebook - Premium	2	5.07	pcs	10.14	2025-04-20 19:17:04.535236+00
431	213	Notebook - Basic	4	8.06	pcs	32.24	2025-04-20 19:17:04.535236+00
432	214	Printing Paper - Standard	3	13.91	box	41.73	2024-02-02 19:17:04.535236+00
433	214	Printing Paper - Basic	4	9.19	box	36.76	2024-02-02 19:17:04.535236+00
434	214	Printing Paper - Standard	1	5.91	box	5.91	2024-02-02 19:17:04.535236+00
435	215	Pen Set - Standard	4	14.39	set	57.56	2024-01-07 19:17:04.535236+00
436	216	Desk - Standard	3	443.41	pcs	1330.23	2024-10-07 19:17:04.535236+00
437	216	Desk - Standard	5	418.94	pcs	2094.70	2024-10-07 19:17:04.535236+00
438	217	Stapler - Standard	2	18.82	pcs	37.64	2023-01-17 19:17:04.535236+00
439	217	Stapler - Standard	2	25.51	pcs	51.02	2023-01-17 19:17:04.535236+00
440	218	Notebook - Basic	5	8.37	pcs	41.85	2022-08-16 19:17:04.535236+00
441	219	Stapler - Premium	2	19.96	pcs	39.92	2025-02-17 19:17:04.535236+00
442	220	Sticky Notes - Standard	2	5.60	pack	11.20	2023-08-11 19:17:04.535236+00
443	220	Sticky Notes - Standard	3	3.89	pack	11.67	2023-08-11 19:17:04.535236+00
444	220	Sticky Notes - Standard	5	6.53	pack	32.65	2023-08-11 19:17:04.535236+00
445	221	Printing Paper - Standard	3	10.53	box	31.59	2023-08-20 19:17:04.535236+00
446	221	Printing Paper - Basic	4	14.12	box	56.48	2023-08-20 19:17:04.535236+00
447	222	Printing Paper - Standard	5	6.06	box	30.30	2023-09-28 19:17:04.535236+00
448	223	Stapler - Basic	1	24.87	pcs	24.87	2024-11-10 19:17:04.535236+00
449	223	Stapler - Standard	3	17.09	pcs	51.27	2024-11-10 19:17:04.535236+00
450	223	Stapler - Premium	4	15.13	pcs	60.52	2024-11-10 19:17:04.535236+00
451	224	Laptop - Standard	2	650.52	pcs	1301.04	2024-08-18 19:17:04.535236+00
452	225	Headset - Basic	2	70.65	pcs	141.30	2023-09-20 19:17:04.535236+00
453	225	Headset - Standard	4	101.41	pcs	405.64	2023-09-20 19:17:04.535236+00
454	226	Sticky Notes - Premium	3	6.66	pack	19.98	2022-12-13 19:17:04.535236+00
455	227	Printing Paper - Standard	3	14.62	box	43.86	2022-02-08 19:17:04.535236+00
456	227	Printing Paper - Premium	3	7.77	box	23.31	2022-02-08 19:17:04.535236+00
457	227	Printing Paper - Premium	5	5.84	box	29.20	2022-02-08 19:17:04.535236+00
458	228	Stapler - Standard	3	15.32	pcs	45.96	2025-04-19 19:17:04.535236+00
459	228	Stapler - Basic	4	14.59	pcs	58.36	2025-04-19 19:17:04.535236+00
460	229	Desk - Basic	4	218.77	pcs	875.08	2023-12-05 19:17:04.535236+00
461	230	Printing Paper - Premium	2	10.53	box	21.06	2025-02-16 19:17:04.535236+00
462	230	Printing Paper - Standard	5	14.49	box	72.45	2025-02-16 19:17:04.535236+00
463	231	Pen Set - Premium	1	18.24	set	18.24	2025-04-07 19:17:04.535236+00
464	231	Pen Set - Premium	2	8.21	set	16.42	2025-04-07 19:17:04.535236+00
465	232	Laptop - Premium	5	677.93	pcs	3389.65	2022-07-19 19:17:04.535236+00
466	232	Laptop - Standard	4	604.77	pcs	2419.08	2022-07-19 19:17:04.535236+00
467	232	Laptop - Basic	5	589.31	pcs	2946.55	2022-07-19 19:17:04.535236+00
468	233	Stapler - Premium	5	13.78	pcs	68.90	2021-02-20 19:17:04.535236+00
469	234	Sticky Notes - Basic	4	5.96	pack	23.84	2025-03-20 19:17:04.535236+00
470	235	Keyboard - Standard	2	56.84	pcs	113.68	2023-06-04 19:17:04.535236+00
471	235	Keyboard - Basic	3	66.62	pcs	199.86	2023-06-04 19:17:04.535236+00
472	235	Keyboard - Premium	4	77.55	pcs	310.20	2023-06-04 19:17:04.535236+00
473	236	Pen Set - Standard	4	15.90	set	63.60	2022-11-16 19:17:04.535236+00
474	237	Notebook - Basic	3	6.05	pcs	18.15	2025-03-17 19:17:04.535236+00
475	237	Notebook - Premium	3	7.16	pcs	21.48	2025-03-17 19:17:04.535236+00
476	238	Conference Table - Basic	4	1800.76	pcs	7203.04	2024-11-26 19:17:04.535236+00
477	239	Conference Table - Basic	2	1129.27	pcs	2258.54	2022-04-20 19:17:04.535236+00
478	239	Conference Table - Standard	2	698.01	pcs	1396.02	2022-04-20 19:17:04.535236+00
479	239	Conference Table - Premium	5	571.02	pcs	2855.10	2022-04-20 19:17:04.535236+00
480	240	Filing Cabinet - Premium	2	221.39	pcs	442.78	2022-08-22 19:17:04.535236+00
481	240	Filing Cabinet - Basic	2	262.89	pcs	525.78	2022-08-22 19:17:04.535236+00
482	240	Filing Cabinet - Standard	4	237.74	pcs	950.96	2022-08-22 19:17:04.535236+00
483	241	Pen Set - Basic	2	8.38	set	16.76	2022-04-25 19:17:04.535236+00
484	241	Pen Set - Standard	5	16.10	set	80.50	2022-04-25 19:17:04.535236+00
485	242	Headset - Premium	4	116.34	pcs	465.36	2025-03-25 19:17:04.535236+00
486	243	Stapler - Basic	1	19.18	pcs	19.18	2024-07-02 19:17:04.535236+00
487	244	Notebook - Basic	4	7.08	pcs	28.32	2025-05-19 19:17:04.535236+00
488	244	Notebook - Premium	3	4.46	pcs	13.38	2025-05-19 19:17:04.535236+00
489	245	Sticky Notes - Standard	1	5.18	pack	5.18	2024-08-31 19:17:04.535236+00
490	246	Notebook - Basic	5	5.32	pcs	26.60	2024-10-03 19:17:04.535236+00
491	247	Pen Set - Basic	4	16.58	set	66.32	2024-05-27 19:17:04.535236+00
492	247	Pen Set - Standard	5	8.68	set	43.40	2024-05-27 19:17:04.535236+00
493	247	Pen Set - Standard	1	14.58	set	14.58	2024-05-27 19:17:04.535236+00
494	248	Stapler - Standard	4	17.65	pcs	70.60	2024-09-16 19:17:04.535236+00
495	249	Bookshelf - Standard	1	105.90	pcs	105.90	2025-05-11 19:17:04.535236+00
496	249	Bookshelf - Basic	4	121.85	pcs	487.40	2025-05-11 19:17:04.535236+00
497	250	Monitor - Standard	1	239.88	pcs	239.88	2024-08-19 19:17:04.535236+00
498	250	Monitor - Standard	4	239.28	pcs	957.12	2024-08-19 19:17:04.535236+00
499	250	Monitor - Basic	3	260.58	pcs	781.74	2024-08-19 19:17:04.535236+00
500	251	Monitor - Premium	3	160.60	pcs	481.80	2025-02-09 19:17:04.535236+00
501	252	Monitor - Standard	1	238.98	pcs	238.98	2022-11-28 19:17:04.535236+00
502	252	Monitor - Premium	5	158.73	pcs	793.65	2022-11-28 19:17:04.535236+00
503	253	Sticky Notes - Standard	4	2.59	pack	10.36	2024-07-10 19:17:04.535236+00
504	253	Sticky Notes - Basic	2	6.11	pack	12.22	2024-07-10 19:17:04.535236+00
505	253	Sticky Notes - Basic	2	3.11	pack	6.22	2024-07-10 19:17:04.535236+00
506	254	Monitor - Premium	5	265.46	pcs	1327.30	2024-12-13 19:17:04.535236+00
507	255	Stapler - Basic	2	20.66	pcs	41.32	2024-02-22 19:17:04.535236+00
508	255	Stapler - Premium	3	21.73	pcs	65.19	2024-02-22 19:17:04.535236+00
509	256	Monitor - Premium	1	205.89	pcs	205.89	2023-05-09 19:17:04.535236+00
510	257	Pen Set - Basic	5	17.70	set	88.50	2025-03-23 19:17:04.535236+00
511	258	Sticky Notes - Standard	4	7.30	pack	29.20	2023-04-21 19:17:04.535236+00
512	258	Sticky Notes - Premium	3	5.30	pack	15.90	2023-04-21 19:17:04.535236+00
513	258	Sticky Notes - Standard	5	5.25	pack	26.25	2023-04-21 19:17:04.535236+00
514	259	Sticky Notes - Premium	2	6.24	pack	12.48	2024-12-13 19:17:04.535236+00
515	259	Sticky Notes - Basic	1	6.81	pack	6.81	2024-12-13 19:17:04.535236+00
516	260	Stapler - Premium	2	11.70	pcs	23.40	2023-06-20 19:17:04.535236+00
517	260	Stapler - Basic	3	11.59	pcs	34.77	2023-06-20 19:17:04.535236+00
518	261	Printing Paper - Premium	3	8.15	box	24.45	2023-09-02 19:17:04.535236+00
519	262	Pen Set - Standard	4	10.90	set	43.60	2025-01-27 19:17:04.535236+00
520	262	Pen Set - Premium	5	8.76	set	43.80	2025-01-27 19:17:04.535236+00
521	262	Pen Set - Basic	4	15.27	set	61.08	2025-01-27 19:17:04.535236+00
522	263	Stapler - Basic	5	23.43	pcs	117.15	2024-08-27 19:17:04.535236+00
523	263	Stapler - Basic	2	22.52	pcs	45.04	2024-08-27 19:17:04.535236+00
524	264	Notebook - Premium	4	7.80	pcs	31.20	2023-06-03 19:17:04.535236+00
525	265	Laptop - Basic	5	574.77	pcs	2873.85	2021-07-09 19:17:04.535236+00
526	265	Laptop - Premium	2	517.13	pcs	1034.26	2021-07-09 19:17:04.535236+00
527	266	Printing Paper - Premium	2	11.36	box	22.72	2025-01-21 19:17:04.535236+00
528	267	Printing Paper - Standard	3	6.57	box	19.71	2025-01-22 19:17:04.535236+00
529	267	Printing Paper - Basic	2	8.28	box	16.56	2025-01-22 19:17:04.535236+00
530	267	Printing Paper - Premium	1	7.97	box	7.97	2025-01-22 19:17:04.535236+00
531	268	Sticky Notes - Premium	3	3.97	pack	11.91	2023-11-12 19:17:04.535236+00
532	268	Sticky Notes - Basic	3	7.51	pack	22.53	2023-11-12 19:17:04.535236+00
533	269	Filing Cabinet - Standard	2	356.33	pcs	712.66	2024-07-26 19:17:04.535236+00
534	269	Filing Cabinet - Basic	5	322.76	pcs	1613.80	2024-07-26 19:17:04.535236+00
535	270	Sticky Notes - Standard	2	4.61	pack	9.22	2024-11-24 19:17:04.535236+00
536	271	Stapler - Standard	2	12.91	pcs	25.82	2024-04-08 19:17:04.535236+00
537	271	Stapler - Premium	2	10.76	pcs	21.52	2024-04-08 19:17:04.535236+00
538	272	Bookshelf - Standard	2	118.88	pcs	237.76	2024-03-08 19:17:04.535236+00
539	272	Bookshelf - Basic	3	197.13	pcs	591.39	2024-03-08 19:17:04.535236+00
540	272	Bookshelf - Basic	2	121.62	pcs	243.24	2024-03-08 19:17:04.535236+00
541	273	Sticky Notes - Standard	4	5.27	pack	21.08	2025-05-07 19:17:04.535236+00
542	274	Filing Cabinet - Standard	5	213.56	pcs	1067.80	2023-11-13 19:17:04.535236+00
543	274	Filing Cabinet - Standard	1	278.85	pcs	278.85	2023-11-13 19:17:04.535236+00
544	274	Filing Cabinet - Basic	1	368.77	pcs	368.77	2023-11-13 19:17:04.535236+00
545	275	Pen Set - Premium	2	18.41	set	36.82	2023-11-04 19:17:04.535236+00
546	275	Pen Set - Premium	1	18.89	set	18.89	2023-11-04 19:17:04.535236+00
547	276	Pen Set - Basic	5	18.55	set	92.75	2024-02-06 19:17:04.535236+00
548	277	Printing Paper - Standard	3	14.05	box	42.15	2025-05-28 19:17:04.535236+00
549	277	Printing Paper - Standard	4	7.01	box	28.04	2025-05-28 19:17:04.535236+00
550	278	Pen Set - Premium	5	14.20	set	71.00	2025-04-12 19:17:04.535236+00
551	278	Pen Set - Basic	2	16.76	set	33.52	2025-04-12 19:17:04.535236+00
552	279	Printing Paper - Premium	3	14.08	box	42.24	2025-03-11 19:17:04.535236+00
553	279	Printing Paper - Premium	1	6.70	box	6.70	2025-03-11 19:17:04.535236+00
554	280	Sticky Notes - Standard	5	2.31	pack	11.55	2021-08-31 19:17:04.535236+00
555	280	Sticky Notes - Standard	5	3.09	pack	15.45	2021-08-31 19:17:04.535236+00
556	281	Printing Paper - Premium	3	5.94	box	17.82	2023-09-10 19:17:04.535236+00
557	282	Laptop - Premium	1	432.83	pcs	432.83	2025-04-17 19:17:04.535236+00
558	282	Laptop - Premium	2	785.16	pcs	1570.32	2025-04-17 19:17:04.535236+00
559	283	Stapler - Standard	3	24.57	pcs	73.71	2025-04-18 19:17:04.535236+00
560	283	Stapler - Standard	5	22.54	pcs	112.70	2025-04-18 19:17:04.535236+00
561	283	Stapler - Standard	2	22.05	pcs	44.10	2025-04-18 19:17:04.535236+00
562	284	Printing Paper - Premium	4	10.46	box	41.84	2024-08-03 19:17:04.535236+00
563	284	Printing Paper - Basic	3	5.91	box	17.73	2024-08-03 19:17:04.535236+00
564	284	Printing Paper - Standard	4	12.91	box	51.64	2024-08-03 19:17:04.535236+00
565	285	Notebook - Basic	5	5.89	pcs	29.45	2025-02-08 19:17:04.535236+00
566	286	Notebook - Standard	2	7.95	pcs	15.90	2023-11-17 19:17:04.535236+00
567	286	Notebook - Standard	4	7.16	pcs	28.64	2023-11-17 19:17:04.535236+00
568	286	Notebook - Basic	3	8.42	pcs	25.26	2023-11-17 19:17:04.535236+00
569	287	Pen Set - Standard	4	14.29	set	57.16	2024-10-04 19:17:04.535236+00
570	287	Pen Set - Standard	1	18.84	set	18.84	2024-10-04 19:17:04.535236+00
571	288	Pen Set - Premium	2	14.94	set	29.88	2023-08-24 19:17:04.535236+00
572	288	Pen Set - Basic	2	12.91	set	25.82	2023-08-24 19:17:04.535236+00
573	288	Pen Set - Premium	5	14.70	set	73.50	2023-08-24 19:17:04.535236+00
574	289	Pen Set - Premium	2	8.21	set	16.42	2022-10-29 19:17:04.535236+00
575	290	Pen Set - Premium	2	9.24	set	18.48	2024-10-24 19:17:04.535236+00
576	291	Bookshelf - Premium	4	123.50	pcs	494.00	2025-05-02 19:17:04.535236+00
577	291	Bookshelf - Premium	3	144.35	pcs	433.05	2025-05-02 19:17:04.535236+00
578	291	Bookshelf - Premium	1	226.75	pcs	226.75	2025-05-02 19:17:04.535236+00
579	292	Sticky Notes - Premium	5	7.23	pack	36.15	2025-04-14 19:17:04.535236+00
580	292	Sticky Notes - Standard	1	2.67	pack	2.67	2025-04-14 19:17:04.535236+00
581	292	Sticky Notes - Premium	3	6.56	pack	19.68	2025-04-14 19:17:04.535236+00
582	293	Pen Set - Standard	2	18.49	set	36.98	2024-08-11 19:17:04.535236+00
583	294	Pen Set - Basic	3	17.70	set	53.10	2024-07-15 19:17:04.535236+00
584	294	Pen Set - Basic	3	13.82	set	41.46	2024-07-15 19:17:04.535236+00
585	294	Pen Set - Basic	4	10.93	set	43.72	2024-07-15 19:17:04.535236+00
586	295	Sticky Notes - Standard	1	3.43	pack	3.43	2025-01-26 19:17:04.535236+00
587	295	Sticky Notes - Basic	4	4.19	pack	16.76	2025-01-26 19:17:04.535236+00
588	296	Stapler - Premium	3	22.49	pcs	67.47	2022-09-07 19:17:04.535236+00
589	297	Notebook - Basic	1	9.08	pcs	9.08	2024-11-07 19:17:04.535236+00
590	298	Filing Cabinet - Premium	2	393.25	pcs	786.50	2024-01-09 19:17:04.535236+00
591	299	Laptop - Premium	5	637.90	pcs	3189.50	2021-10-05 19:17:04.535236+00
592	299	Laptop - Premium	2	817.05	pcs	1634.10	2021-10-05 19:17:04.535236+00
593	299	Laptop - Standard	3	708.89	pcs	2126.67	2021-10-05 19:17:04.535236+00
594	300	Sticky Notes - Basic	2	4.69	pack	9.38	2023-05-04 19:17:04.535236+00
595	301	Filing Cabinet - Premium	3	412.31	pcs	1236.93	2024-11-29 19:17:04.535236+00
596	302	Keyboard - Standard	5	60.36	pcs	301.80	2022-06-23 19:17:04.535236+00
597	303	Mouse - Basic	1	32.64	pcs	32.64	2024-07-19 19:17:04.535236+00
598	303	Mouse - Premium	5	38.78	pcs	193.90	2024-07-19 19:17:04.535236+00
599	303	Mouse - Premium	5	37.67	pcs	188.35	2024-07-19 19:17:04.535236+00
600	304	Sticky Notes - Standard	1	4.21	pack	4.21	2021-09-23 19:17:04.535236+00
601	305	Printing Paper - Premium	3	5.76	box	17.28	2024-12-07 19:17:04.535236+00
602	305	Printing Paper - Basic	4	8.11	box	32.44	2024-12-07 19:17:04.535236+00
603	305	Printing Paper - Premium	3	11.39	box	34.17	2024-12-07 19:17:04.535236+00
604	306	Conference Table - Basic	3	1468.78	pcs	4406.34	2022-03-28 19:17:04.535236+00
605	306	Conference Table - Basic	3	844.13	pcs	2532.39	2022-03-28 19:17:04.535236+00
606	307	Conference Table - Premium	1	791.78	pcs	791.78	2025-02-28 19:17:04.535236+00
607	308	Desk - Basic	3	329.87	pcs	989.61	2024-11-03 19:17:04.535236+00
608	308	Desk - Basic	1	213.22	pcs	213.22	2024-11-03 19:17:04.535236+00
609	308	Desk - Standard	3	215.28	pcs	645.84	2024-11-03 19:17:04.535236+00
610	309	Conference Table - Premium	4	1341.12	pcs	5364.48	2024-09-29 19:17:04.535236+00
611	309	Conference Table - Premium	2	1068.95	pcs	2137.90	2024-09-29 19:17:04.535236+00
612	310	Sticky Notes - Basic	2	3.45	pack	6.90	2023-04-08 19:17:04.535236+00
613	311	Sticky Notes - Premium	5	7.03	pack	35.15	2025-05-02 19:17:04.535236+00
614	311	Sticky Notes - Premium	5	2.31	pack	11.55	2025-05-02 19:17:04.535236+00
615	312	Sticky Notes - Standard	3	4.07	pack	12.21	2021-08-26 19:17:04.535236+00
616	312	Sticky Notes - Basic	1	6.41	pack	6.41	2021-08-26 19:17:04.535236+00
617	313	Laptop - Standard	2	552.84	pcs	1105.68	2023-09-24 19:17:04.535236+00
618	314	Conference Table - Basic	3	1977.97	pcs	5933.91	2023-04-02 19:17:04.535236+00
619	314	Conference Table - Standard	5	1430.86	pcs	7154.30	2023-04-02 19:17:04.535236+00
620	315	Notebook - Standard	5	9.53	pcs	47.65	2025-02-11 19:17:04.535236+00
621	316	Notebook - Standard	5	9.94	pcs	49.70	2025-05-25 19:17:04.535236+00
622	316	Notebook - Premium	2	8.51	pcs	17.02	2025-05-25 19:17:04.535236+00
623	317	Sticky Notes - Premium	1	7.59	pack	7.59	2021-02-27 19:17:04.535236+00
624	317	Sticky Notes - Premium	5	5.69	pack	28.45	2021-02-27 19:17:04.535236+00
625	318	Notebook - Standard	4	7.14	pcs	28.56	2024-12-31 19:17:04.535236+00
626	319	Desk - Standard	1	214.58	pcs	214.58	2023-01-14 19:17:04.535236+00
627	319	Desk - Standard	1	244.47	pcs	244.47	2023-01-14 19:17:04.535236+00
628	319	Desk - Basic	3	357.13	pcs	1071.39	2023-01-14 19:17:04.535236+00
629	320	Pen Set - Premium	4	14.07	set	56.28	2024-11-07 19:17:04.535236+00
630	320	Pen Set - Basic	4	9.49	set	37.96	2024-11-07 19:17:04.535236+00
631	321	Sticky Notes - Premium	4	3.67	pack	14.68	2023-05-17 19:17:04.535236+00
632	321	Sticky Notes - Premium	1	2.45	pack	2.45	2023-05-17 19:17:04.535236+00
633	322	Bookshelf - Basic	2	252.80	pcs	505.60	2024-09-22 19:17:04.535236+00
634	322	Bookshelf - Basic	2	189.71	pcs	379.42	2024-09-22 19:17:04.535236+00
635	322	Bookshelf - Standard	2	118.45	pcs	236.90	2024-09-22 19:17:04.535236+00
636	323	Desk - Basic	4	463.79	pcs	1855.16	2025-05-12 19:17:04.535236+00
637	323	Desk - Premium	1	390.72	pcs	390.72	2025-05-12 19:17:04.535236+00
638	323	Desk - Premium	3	240.19	pcs	720.57	2025-05-12 19:17:04.535236+00
639	324	Pen Set - Standard	1	9.57	set	9.57	2025-03-28 19:17:04.535236+00
640	324	Pen Set - Basic	5	17.15	set	85.75	2025-03-28 19:17:04.535236+00
641	324	Pen Set - Standard	4	18.51	set	74.04	2025-03-28 19:17:04.535236+00
642	325	Sticky Notes - Standard	4	3.50	pack	14.00	2025-04-22 19:17:04.535236+00
643	326	Sticky Notes - Basic	5	4.60	pack	23.00	2025-03-01 19:17:04.535236+00
644	327	Stapler - Premium	3	14.25	pcs	42.75	2024-02-23 19:17:04.535236+00
645	327	Stapler - Standard	4	13.92	pcs	55.68	2024-02-23 19:17:04.535236+00
646	327	Stapler - Standard	1	24.64	pcs	24.64	2024-02-23 19:17:04.535236+00
647	328	Pen Set - Premium	4	11.54	set	46.16	2025-01-19 19:17:04.535236+00
648	328	Pen Set - Standard	3	9.49	set	28.47	2025-01-19 19:17:04.535236+00
649	329	Printing Paper - Basic	5	6.97	box	34.85	2024-12-04 19:17:04.535236+00
650	329	Printing Paper - Standard	5	12.73	box	63.65	2024-12-04 19:17:04.535236+00
651	329	Printing Paper - Basic	4	11.85	box	47.40	2024-12-04 19:17:04.535236+00
652	330	Pen Set - Standard	3	11.15	set	33.45	2024-03-09 19:17:04.535236+00
653	331	Desk - Standard	4	262.73	pcs	1050.92	2025-04-12 19:17:04.535236+00
654	331	Desk - Basic	3	467.44	pcs	1402.32	2025-04-12 19:17:04.535236+00
655	332	Sticky Notes - Basic	2	5.43	pack	10.86	2025-03-19 19:17:04.535236+00
656	333	Laptop - Basic	1	450.46	pcs	450.46	2025-03-19 19:17:04.535236+00
657	333	Laptop - Standard	5	602.01	pcs	3010.05	2025-03-19 19:17:04.535236+00
658	333	Laptop - Basic	4	738.05	pcs	2952.20	2025-03-19 19:17:04.535236+00
659	334	Conference Table - Standard	1	629.50	pcs	629.50	2022-01-29 19:17:04.535236+00
660	334	Conference Table - Standard	3	520.07	pcs	1560.21	2022-01-29 19:17:04.535236+00
661	334	Conference Table - Premium	2	1863.38	pcs	3726.76	2022-01-29 19:17:04.535236+00
662	335	Laptop - Standard	2	747.83	pcs	1495.66	2024-10-15 19:17:04.535236+00
663	335	Laptop - Standard	4	585.33	pcs	2341.32	2024-10-15 19:17:04.535236+00
664	336	Sticky Notes - Standard	3	3.80	pack	11.40	2024-05-01 19:17:04.535236+00
665	337	Stapler - Basic	3	12.65	pcs	37.95	2025-02-15 19:17:04.535236+00
666	337	Stapler - Premium	1	12.59	pcs	12.59	2025-02-15 19:17:04.535236+00
667	337	Stapler - Basic	1	10.06	pcs	10.06	2025-02-15 19:17:04.535236+00
668	338	Stapler - Standard	2	18.63	pcs	37.26	2024-02-19 19:17:04.535236+00
669	339	Pen Set - Basic	3	10.47	set	31.41	2024-05-22 19:17:04.535236+00
670	339	Pen Set - Standard	1	12.50	set	12.50	2024-05-22 19:17:04.535236+00
671	340	Stapler - Standard	4	20.59	pcs	82.36	2023-12-04 19:17:04.535236+00
672	341	Pen Set - Standard	4	14.57	set	58.28	2024-01-30 19:17:04.535236+00
673	341	Pen Set - Standard	2	15.91	set	31.82	2024-01-30 19:17:04.535236+00
674	341	Pen Set - Basic	4	10.84	set	43.36	2024-01-30 19:17:04.535236+00
675	342	Notebook - Standard	2	8.11	pcs	16.22	2022-03-10 19:17:04.535236+00
676	342	Notebook - Premium	3	9.64	pcs	28.92	2022-03-10 19:17:04.535236+00
677	343	Stapler - Premium	3	21.12	pcs	63.36	2025-05-24 19:17:04.535236+00
678	343	Stapler - Premium	4	19.06	pcs	76.24	2025-05-24 19:17:04.535236+00
679	344	Sticky Notes - Basic	4	3.87	pack	15.48	2024-12-12 19:17:04.535236+00
680	344	Sticky Notes - Standard	2	6.67	pack	13.34	2024-12-12 19:17:04.535236+00
681	345	Keyboard - Standard	4	71.79	pcs	287.16	2025-05-17 19:17:04.535236+00
682	346	Sticky Notes - Standard	5	2.61	pack	13.05	2024-09-19 19:17:04.535236+00
683	346	Sticky Notes - Basic	5	6.26	pack	31.30	2024-09-19 19:17:04.535236+00
684	347	Conference Table - Premium	1	1163.22	pcs	1163.22	2023-12-11 19:17:04.535236+00
685	348	Conference Table - Premium	3	1183.22	pcs	3549.66	2025-05-05 19:17:04.535236+00
686	348	Conference Table - Premium	3	505.23	pcs	1515.69	2025-05-05 19:17:04.535236+00
687	349	Sticky Notes - Basic	4	7.97	pack	31.88	2024-12-23 19:17:04.535236+00
688	350	Printing Paper - Standard	3	10.73	box	32.19	2024-06-01 19:17:04.535236+00
689	350	Printing Paper - Basic	4	14.83	box	59.32	2024-06-01 19:17:04.535236+00
690	351	Pen Set - Premium	1	8.24	set	8.24	2025-04-24 19:17:04.535236+00
691	351	Pen Set - Standard	3	15.57	set	46.71	2025-04-24 19:17:04.535236+00
692	351	Pen Set - Basic	3	19.13	set	57.39	2025-04-24 19:17:04.535236+00
693	352	Stapler - Basic	1	11.54	pcs	11.54	2025-02-05 19:17:04.535236+00
694	352	Stapler - Premium	3	11.94	pcs	35.82	2025-02-05 19:17:04.535236+00
695	352	Stapler - Basic	5	13.31	pcs	66.55	2025-02-05 19:17:04.535236+00
696	353	Stapler - Premium	5	25.61	pcs	128.05	2022-06-11 19:17:04.535236+00
697	354	Conference Table - Basic	4	916.05	pcs	3664.20	2025-04-30 19:17:04.535236+00
698	354	Conference Table - Premium	2	553.99	pcs	1107.98	2025-04-30 19:17:04.535236+00
699	355	Printing Paper - Premium	5	9.20	box	46.00	2023-08-19 19:17:04.535236+00
700	356	Filing Cabinet - Basic	1	377.07	pcs	377.07	2024-05-03 19:17:04.535236+00
701	357	Pen Set - Standard	5	19.82	set	99.10	2023-11-24 19:17:04.535236+00
702	358	Pen Set - Premium	3	12.14	set	36.42	2024-05-11 19:17:04.535236+00
703	359	Notebook - Premium	3	8.45	pcs	25.35	2025-05-05 19:17:04.535236+00
704	360	Notebook - Basic	4	9.13	pcs	36.52	2023-03-06 19:17:04.535236+00
705	360	Notebook - Basic	2	4.69	pcs	9.38	2023-03-06 19:17:04.535236+00
706	361	Notebook - Basic	2	5.70	pcs	11.40	2023-08-23 19:17:04.535236+00
707	361	Notebook - Basic	2	4.68	pcs	9.36	2023-08-23 19:17:04.535236+00
708	362	Monitor - Premium	1	228.11	pcs	228.11	2024-09-08 19:17:04.535236+00
709	362	Monitor - Basic	4	184.28	pcs	737.12	2024-09-08 19:17:04.535236+00
710	362	Monitor - Standard	5	185.25	pcs	926.25	2024-09-08 19:17:04.535236+00
711	363	Printing Paper - Premium	5	11.13	box	55.65	2025-05-01 19:17:04.535236+00
712	363	Printing Paper - Premium	5	7.46	box	37.30	2025-05-01 19:17:04.535236+00
713	363	Printing Paper - Premium	3	10.32	box	30.96	2025-05-01 19:17:04.535236+00
714	364	Office Chair - Premium	1	268.10	pcs	268.10	2025-04-22 19:17:04.535236+00
715	364	Office Chair - Standard	1	217.50	pcs	217.50	2025-04-22 19:17:04.535236+00
716	364	Office Chair - Basic	3	278.39	pcs	835.17	2025-04-22 19:17:04.535236+00
717	365	Keyboard - Premium	2	60.11	pcs	120.22	2025-04-17 19:17:04.535236+00
718	365	Keyboard - Basic	3	77.39	pcs	232.17	2025-04-17 19:17:04.535236+00
719	366	Notebook - Basic	4	7.21	pcs	28.84	2022-06-10 19:17:04.535236+00
720	367	Desk - Premium	2	353.03	pcs	706.06	2024-07-15 19:17:04.535236+00
721	368	Notebook - Standard	5	6.65	pcs	33.25	2025-04-30 19:17:04.535236+00
722	369	Stapler - Basic	2	18.22	pcs	36.44	2025-01-28 19:17:04.535236+00
723	369	Stapler - Basic	5	15.98	pcs	79.90	2025-01-28 19:17:04.535236+00
724	370	Conference Table - Premium	2	1451.28	pcs	2902.56	2025-01-01 19:17:04.535236+00
725	370	Conference Table - Premium	1	1847.39	pcs	1847.39	2025-01-01 19:17:04.535236+00
726	370	Conference Table - Premium	2	554.18	pcs	1108.36	2025-01-01 19:17:04.535236+00
727	371	Pen Set - Premium	1	10.65	set	10.65	2025-02-19 19:17:04.535236+00
728	371	Pen Set - Standard	4	9.88	set	39.52	2025-02-19 19:17:04.535236+00
729	372	Printing Paper - Basic	2	14.20	box	28.40	2021-04-14 19:17:04.535236+00
730	373	Pen Set - Premium	1	13.97	set	13.97	2025-05-29 19:17:04.535236+00
731	374	Conference Table - Basic	2	1726.69	pcs	3453.38	2025-02-01 19:17:04.535236+00
732	375	Headset - Standard	4	121.41	pcs	485.64	2024-11-01 19:17:04.535236+00
733	375	Headset - Basic	2	83.31	pcs	166.62	2024-11-01 19:17:04.535236+00
734	375	Headset - Standard	3	69.77	pcs	209.31	2024-11-01 19:17:04.535236+00
735	376	Desk - Premium	2	334.93	pcs	669.86	2024-10-16 19:17:04.535236+00
736	376	Desk - Standard	3	347.01	pcs	1041.03	2024-10-16 19:17:04.535236+00
737	377	Sticky Notes - Basic	1	3.65	pack	3.65	2024-06-14 19:17:04.535236+00
738	378	Sticky Notes - Premium	1	3.69	pack	3.69	2025-03-27 19:17:04.535236+00
739	378	Sticky Notes - Basic	3	7.88	pack	23.64	2025-03-27 19:17:04.535236+00
740	379	Mouse - Premium	1	38.77	pcs	38.77	2025-05-12 19:17:04.535236+00
741	380	Keyboard - Basic	1	78.68	pcs	78.68	2023-09-06 19:17:04.535236+00
742	381	Sticky Notes - Basic	3	3.99	pack	11.97	2022-08-15 19:17:04.535236+00
743	382	Stapler - Basic	5	14.66	pcs	73.30	2023-08-04 19:17:04.535236+00
744	382	Stapler - Basic	3	10.83	pcs	32.49	2023-08-04 19:17:04.535236+00
745	382	Stapler - Standard	3	18.47	pcs	55.41	2023-08-04 19:17:04.535236+00
746	383	Notebook - Basic	1	4.32	pcs	4.32	2025-02-03 19:17:04.535236+00
747	383	Notebook - Standard	1	4.02	pcs	4.02	2025-02-03 19:17:04.535236+00
748	383	Notebook - Standard	4	7.12	pcs	28.48	2025-02-03 19:17:04.535236+00
749	384	Notebook - Basic	3	6.96	pcs	20.88	2024-07-11 19:17:04.535236+00
750	384	Notebook - Basic	1	8.23	pcs	8.23	2024-07-11 19:17:04.535236+00
751	385	Keyboard - Premium	3	98.06	pcs	294.18	2024-06-25 19:17:04.535236+00
752	386	Pen Set - Premium	2	9.39	set	18.78	2022-08-28 19:17:04.535236+00
753	387	Bookshelf - Basic	1	189.63	pcs	189.63	2022-09-26 19:17:04.535236+00
754	388	Keyboard - Premium	2	62.19	pcs	124.38	2022-07-08 19:17:04.535236+00
755	388	Keyboard - Standard	5	56.33	pcs	281.65	2022-07-08 19:17:04.535236+00
756	388	Keyboard - Premium	1	91.56	pcs	91.56	2022-07-08 19:17:04.535236+00
757	389	Sticky Notes - Basic	2	3.75	pack	7.50	2023-06-02 19:17:04.535236+00
758	389	Sticky Notes - Standard	4	2.78	pack	11.12	2023-06-02 19:17:04.535236+00
759	389	Sticky Notes - Standard	2	4.32	pack	8.64	2023-06-02 19:17:04.535236+00
760	390	Printing Paper - Standard	4	7.86	box	31.44	2024-01-15 19:17:04.535236+00
761	391	Desk - Standard	1	486.51	pcs	486.51	2025-05-17 19:17:04.535236+00
762	391	Desk - Premium	5	216.76	pcs	1083.80	2025-05-17 19:17:04.535236+00
763	392	Notebook - Premium	5	8.53	pcs	42.65	2021-05-22 19:17:04.535236+00
764	392	Notebook - Basic	3	6.44	pcs	19.32	2021-05-22 19:17:04.535236+00
765	393	Pen Set - Basic	2	12.34	set	24.68	2024-12-10 19:17:04.535236+00
766	393	Pen Set - Premium	1	14.90	set	14.90	2024-12-10 19:17:04.535236+00
767	393	Pen Set - Premium	2	18.36	set	36.72	2024-12-10 19:17:04.535236+00
768	394	Conference Table - Basic	1	1054.66	pcs	1054.66	2022-06-04 19:17:04.535236+00
769	395	Pen Set - Basic	4	17.76	set	71.04	2025-05-08 19:17:04.535236+00
770	395	Pen Set - Standard	4	11.39	set	45.56	2025-05-08 19:17:04.535236+00
771	396	Laptop - Standard	4	442.51	pcs	1770.04	2023-09-04 19:17:04.535236+00
772	397	Laptop - Basic	2	453.52	pcs	907.04	2022-09-30 19:17:04.535236+00
773	397	Laptop - Premium	4	568.45	pcs	2273.80	2022-09-30 19:17:04.535236+00
774	397	Laptop - Standard	2	697.20	pcs	1394.40	2022-09-30 19:17:04.535236+00
775	398	Headset - Premium	2	139.93	pcs	279.86	2020-12-29 19:17:04.535236+00
776	398	Headset - Standard	2	30.93	pcs	61.86	2020-12-29 19:17:04.535236+00
777	399	Notebook - Basic	3	8.08	pcs	24.24	2025-05-12 19:17:04.535236+00
778	400	Stapler - Basic	2	16.65	pcs	33.30	2023-01-29 19:17:04.535236+00
779	400	Stapler - Premium	4	10.85	pcs	43.40	2023-01-29 19:17:04.535236+00
780	401	Pen Set - Premium	5	9.18	set	45.90	2023-09-27 19:17:04.535236+00
781	401	Pen Set - Basic	4	12.11	set	48.44	2023-09-27 19:17:04.535236+00
782	402	Conference Table - Basic	1	1311.46	pcs	1311.46	2024-06-02 19:17:04.535236+00
783	403	Bookshelf - Basic	5	151.94	pcs	759.70	2023-10-28 19:17:04.535236+00
784	403	Bookshelf - Premium	3	208.92	pcs	626.76	2023-10-28 19:17:04.535236+00
785	404	Mouse - Standard	1	26.41	pcs	26.41	2024-11-03 19:17:04.535236+00
786	404	Mouse - Standard	2	41.73	pcs	83.46	2024-11-03 19:17:04.535236+00
787	405	Keyboard - Standard	1	89.00	pcs	89.00	2024-09-07 19:17:04.535236+00
788	405	Keyboard - Basic	3	69.60	pcs	208.80	2024-09-07 19:17:04.535236+00
789	406	Stapler - Basic	5	12.54	pcs	62.70	2025-04-04 19:17:04.535236+00
790	406	Stapler - Premium	2	11.15	pcs	22.30	2025-04-04 19:17:04.535236+00
791	407	Printing Paper - Standard	2	11.86	box	23.72	2023-01-18 19:17:04.535236+00
792	407	Printing Paper - Basic	4	10.52	box	42.08	2023-01-18 19:17:04.535236+00
793	407	Printing Paper - Premium	3	13.81	box	41.43	2023-01-18 19:17:04.535236+00
794	408	Conference Table - Basic	2	913.13	pcs	1826.26	2023-10-27 19:17:04.535236+00
795	408	Conference Table - Standard	4	1134.00	pcs	4536.00	2023-10-27 19:17:04.535236+00
796	408	Conference Table - Premium	3	589.66	pcs	1768.98	2023-10-27 19:17:04.535236+00
797	409	Headset - Premium	2	73.22	pcs	146.44	2024-06-10 19:17:04.535236+00
798	409	Headset - Basic	4	90.89	pcs	363.56	2024-06-10 19:17:04.535236+00
799	410	Keyboard - Basic	2	77.37	pcs	154.74	2025-04-25 19:17:04.535236+00
800	410	Keyboard - Premium	5	72.26	pcs	361.30	2025-04-25 19:17:04.535236+00
801	411	Headset - Standard	5	72.54	pcs	362.70	2025-04-18 19:17:04.535236+00
802	411	Headset - Basic	1	106.63	pcs	106.63	2025-04-18 19:17:04.535236+00
803	411	Headset - Standard	1	103.94	pcs	103.94	2025-04-18 19:17:04.535236+00
804	412	Stapler - Basic	3	21.52	pcs	64.56	2024-02-10 19:17:04.535236+00
805	413	Desk - Basic	2	478.29	pcs	956.58	2024-09-08 19:17:04.535236+00
806	413	Desk - Standard	5	424.45	pcs	2122.25	2024-09-08 19:17:04.535236+00
807	414	Filing Cabinet - Basic	3	343.71	pcs	1031.13	2024-12-15 19:17:04.535236+00
808	415	Stapler - Premium	1	26.18	pcs	26.18	2024-06-18 19:17:04.535236+00
809	416	Notebook - Basic	5	9.63	pcs	48.15	2024-12-06 19:17:04.535236+00
810	416	Notebook - Basic	5	5.80	pcs	29.00	2024-12-06 19:17:04.535236+00
811	416	Notebook - Premium	2	4.22	pcs	8.44	2024-12-06 19:17:04.535236+00
812	417	Monitor - Standard	3	182.89	pcs	548.67	2023-12-11 19:17:04.535236+00
813	417	Monitor - Standard	5	146.18	pcs	730.90	2023-12-11 19:17:04.535236+00
814	417	Monitor - Basic	4	198.08	pcs	792.32	2023-12-11 19:17:04.535236+00
815	418	Laptop - Standard	1	422.85	pcs	422.85	2025-01-29 19:17:04.535236+00
816	418	Laptop - Premium	2	770.29	pcs	1540.58	2025-01-29 19:17:04.535236+00
817	418	Laptop - Premium	3	573.92	pcs	1721.76	2025-01-29 19:17:04.535236+00
818	419	Notebook - Premium	5	6.40	pcs	32.00	2024-06-14 19:17:04.535236+00
819	419	Notebook - Basic	4	7.36	pcs	29.44	2024-06-14 19:17:04.535236+00
820	420	Stapler - Basic	5	10.86	pcs	54.30	2024-08-24 19:17:04.535236+00
821	420	Stapler - Basic	5	19.75	pcs	98.75	2024-08-24 19:17:04.535236+00
822	421	Keyboard - Basic	5	89.47	pcs	447.35	2023-04-16 19:17:04.535236+00
823	422	Laptop - Basic	1	451.88	pcs	451.88	2023-08-24 19:17:04.535236+00
824	423	Conference Table - Basic	4	866.27	pcs	3465.08	2024-07-23 19:17:04.535236+00
825	423	Conference Table - Standard	4	1468.61	pcs	5874.44	2024-07-23 19:17:04.535236+00
826	424	Sticky Notes - Standard	3	2.91	pack	8.73	2025-01-07 19:17:04.535236+00
827	424	Sticky Notes - Premium	2	6.32	pack	12.64	2025-01-07 19:17:04.535236+00
828	425	Office Chair - Premium	1	111.98	pcs	111.98	2025-01-07 19:17:04.535236+00
829	425	Office Chair - Standard	4	186.51	pcs	746.04	2025-01-07 19:17:04.535236+00
830	426	Conference Table - Premium	3	1652.31	pcs	4956.93	2025-02-16 19:17:04.535236+00
831	426	Conference Table - Basic	5	1364.61	pcs	6823.05	2025-02-16 19:17:04.535236+00
832	426	Conference Table - Standard	3	678.59	pcs	2035.77	2025-02-16 19:17:04.535236+00
833	427	Stapler - Basic	2	15.91	pcs	31.82	2024-05-31 19:17:04.535236+00
834	428	Stapler - Basic	2	14.84	pcs	29.68	2025-01-28 19:17:04.535236+00
835	428	Stapler - Premium	4	18.58	pcs	74.32	2025-01-28 19:17:04.535236+00
836	429	Stapler - Standard	1	17.69	pcs	17.69	2025-04-13 19:17:04.535236+00
837	429	Stapler - Premium	2	17.26	pcs	34.52	2025-04-13 19:17:04.535236+00
838	430	Filing Cabinet - Premium	5	235.15	pcs	1175.75	2023-01-25 19:17:04.535236+00
839	430	Filing Cabinet - Basic	4	198.16	pcs	792.64	2023-01-25 19:17:04.535236+00
840	431	Sticky Notes - Basic	3	2.17	pack	6.51	2022-09-21 19:17:04.535236+00
841	431	Sticky Notes - Premium	5	6.75	pack	33.75	2022-09-21 19:17:04.535236+00
842	431	Sticky Notes - Basic	3	4.28	pack	12.84	2022-09-21 19:17:04.535236+00
843	432	Printing Paper - Basic	2	7.60	box	15.20	2025-04-09 19:17:04.535236+00
844	432	Printing Paper - Premium	5	14.36	box	71.80	2025-04-09 19:17:04.535236+00
845	433	Pen Set - Basic	2	10.22	set	20.44	2024-07-10 19:17:04.535236+00
846	433	Pen Set - Premium	3	7.96	set	23.88	2024-07-10 19:17:04.535236+00
847	433	Pen Set - Standard	1	15.56	set	15.56	2024-07-10 19:17:04.535236+00
848	434	Pen Set - Premium	1	19.20	set	19.20	2025-04-06 19:17:04.535236+00
849	435	Desk - Premium	2	301.60	pcs	603.20	2023-05-03 19:17:04.535236+00
850	435	Desk - Basic	1	384.82	pcs	384.82	2023-05-03 19:17:04.535236+00
851	435	Desk - Standard	4	302.62	pcs	1210.48	2023-05-03 19:17:04.535236+00
852	436	Sticky Notes - Premium	2	3.35	pack	6.70	2024-10-10 19:17:04.535236+00
853	436	Sticky Notes - Standard	3	7.09	pack	21.27	2024-10-10 19:17:04.535236+00
854	436	Sticky Notes - Basic	3	7.59	pack	22.77	2024-10-10 19:17:04.535236+00
855	437	Stapler - Basic	3	15.92	pcs	47.76	2025-03-19 19:17:04.535236+00
856	437	Stapler - Basic	4	15.29	pcs	61.16	2025-03-19 19:17:04.535236+00
857	437	Stapler - Premium	5	23.30	pcs	116.50	2025-03-19 19:17:04.535236+00
858	438	Office Chair - Basic	3	259.12	pcs	777.36	2025-04-06 19:17:04.535236+00
859	438	Office Chair - Premium	4	225.04	pcs	900.16	2025-04-06 19:17:04.535236+00
860	438	Office Chair - Basic	2	200.96	pcs	401.92	2025-04-06 19:17:04.535236+00
861	439	Office Chair - Premium	5	243.91	pcs	1219.55	2023-02-07 19:17:04.535236+00
862	439	Office Chair - Basic	4	265.29	pcs	1061.16	2023-02-07 19:17:04.535236+00
863	439	Office Chair - Premium	1	215.83	pcs	215.83	2023-02-07 19:17:04.535236+00
864	440	Pen Set - Standard	5	8.83	set	44.15	2023-01-08 19:17:04.535236+00
865	440	Pen Set - Standard	3	12.69	set	38.07	2023-01-08 19:17:04.535236+00
866	440	Pen Set - Basic	1	14.49	set	14.49	2023-01-08 19:17:04.535236+00
867	441	Sticky Notes - Standard	4	2.68	pack	10.72	2025-05-29 19:17:04.535236+00
868	442	Notebook - Premium	5	8.40	pcs	42.00	2024-07-22 19:17:04.535236+00
869	442	Notebook - Premium	2	4.05	pcs	8.10	2024-07-22 19:17:04.535236+00
870	443	Stapler - Premium	5	22.84	pcs	114.20	2024-12-26 19:17:04.535236+00
871	444	Printing Paper - Standard	3	8.39	box	25.17	2025-03-15 19:17:04.535236+00
872	444	Printing Paper - Basic	3	12.75	box	38.25	2025-03-15 19:17:04.535236+00
873	445	Printing Paper - Basic	1	5.51	box	5.51	2023-05-07 19:17:04.535236+00
874	445	Printing Paper - Standard	1	15.47	box	15.47	2023-05-07 19:17:04.535236+00
875	445	Printing Paper - Premium	2	8.10	box	16.20	2023-05-07 19:17:04.535236+00
876	446	Printing Paper - Standard	3	8.06	box	24.18	2024-11-14 19:17:04.535236+00
877	446	Printing Paper - Premium	1	13.56	box	13.56	2024-11-14 19:17:04.535236+00
878	446	Printing Paper - Basic	4	12.11	box	48.44	2024-11-14 19:17:04.535236+00
879	447	Sticky Notes - Basic	1	2.37	pack	2.37	2025-01-02 19:17:04.535236+00
880	447	Sticky Notes - Basic	1	6.89	pack	6.89	2025-01-02 19:17:04.535236+00
881	447	Sticky Notes - Premium	4	6.62	pack	26.48	2025-01-02 19:17:04.535236+00
882	448	Sticky Notes - Basic	5	5.05	pack	25.25	2023-12-29 19:17:04.535236+00
883	448	Sticky Notes - Standard	2	6.55	pack	13.10	2023-12-29 19:17:04.535236+00
884	449	Printing Paper - Basic	4	5.65	box	22.60	2025-04-30 19:17:04.535236+00
885	450	Mouse - Basic	4	25.78	pcs	103.12	2022-04-13 19:17:04.535236+00
886	451	Printing Paper - Premium	1	7.94	box	7.94	2025-04-18 19:17:04.535236+00
887	451	Printing Paper - Premium	1	11.38	box	11.38	2025-04-18 19:17:04.535236+00
888	451	Printing Paper - Premium	2	12.11	box	24.22	2025-04-18 19:17:04.535236+00
889	452	Printing Paper - Basic	4	11.34	box	45.36	2024-03-11 19:17:04.535236+00
890	453	Stapler - Premium	3	13.51	pcs	40.53	2020-09-23 19:17:04.535236+00
891	453	Stapler - Premium	5	16.48	pcs	82.40	2020-09-23 19:17:04.535236+00
892	453	Stapler - Premium	3	21.33	pcs	63.99	2020-09-23 19:17:04.535236+00
893	454	Printing Paper - Basic	4	6.43	box	25.72	2025-01-27 19:17:04.535236+00
894	454	Printing Paper - Standard	2	11.30	box	22.60	2025-01-27 19:17:04.535236+00
895	454	Printing Paper - Basic	3	9.06	box	27.18	2025-01-27 19:17:04.535236+00
896	455	Notebook - Basic	3	9.24	pcs	27.72	2024-05-14 19:17:04.535236+00
897	456	Printing Paper - Premium	1	13.03	box	13.03	2022-12-16 19:17:04.535236+00
898	457	Office Chair - Standard	4	277.54	pcs	1110.16	2024-02-15 19:17:04.535236+00
899	457	Office Chair - Standard	4	302.07	pcs	1208.28	2024-02-15 19:17:04.535236+00
900	458	Stapler - Basic	5	9.89	pcs	49.45	2024-07-22 19:17:04.535236+00
901	458	Stapler - Basic	2	25.00	pcs	50.00	2024-07-22 19:17:04.535236+00
902	459	Notebook - Premium	3	5.65	pcs	16.95	2023-03-22 19:17:04.535236+00
903	460	Printing Paper - Standard	1	6.49	box	6.49	2023-08-03 19:17:04.535236+00
904	460	Printing Paper - Basic	3	5.00	box	15.00	2023-08-03 19:17:04.535236+00
905	461	Pen Set - Basic	2	15.16	set	30.32	2023-03-10 19:17:04.535236+00
906	461	Pen Set - Standard	3	11.91	set	35.73	2023-03-10 19:17:04.535236+00
907	461	Pen Set - Basic	1	12.60	set	12.60	2023-03-10 19:17:04.535236+00
908	462	Desk - Premium	1	459.29	pcs	459.29	2025-01-11 19:17:04.535236+00
909	463	Notebook - Premium	1	3.47	pcs	3.47	2020-12-23 19:17:04.535236+00
910	463	Notebook - Standard	2	7.33	pcs	14.66	2020-12-23 19:17:04.535236+00
911	463	Notebook - Standard	2	8.96	pcs	17.92	2020-12-23 19:17:04.535236+00
912	464	Stapler - Premium	1	19.58	pcs	19.58	2023-02-19 19:17:04.535236+00
913	464	Stapler - Basic	3	13.79	pcs	41.37	2023-02-19 19:17:04.535236+00
914	464	Stapler - Basic	1	12.87	pcs	12.87	2023-02-19 19:17:04.535236+00
915	465	Pen Set - Standard	5	18.62	set	93.10	2024-03-06 19:17:04.535236+00
916	466	Pen Set - Standard	5	9.74	set	48.70	2020-11-27 19:17:04.535236+00
917	466	Pen Set - Premium	5	12.10	set	60.50	2020-11-27 19:17:04.535236+00
918	467	Desk - Basic	4	266.22	pcs	1064.88	2021-01-20 19:17:04.535236+00
919	467	Desk - Standard	5	474.16	pcs	2370.80	2021-01-20 19:17:04.535236+00
920	468	Pen Set - Premium	3	9.71	set	29.13	2023-03-02 19:17:04.535236+00
921	469	Pen Set - Standard	3	17.04	set	51.12	2023-08-01 19:17:04.535236+00
922	469	Pen Set - Premium	3	17.78	set	53.34	2023-08-01 19:17:04.535236+00
923	469	Pen Set - Standard	4	16.39	set	65.56	2023-08-01 19:17:04.535236+00
924	470	Notebook - Standard	5	4.68	pcs	23.40	2025-04-22 19:17:04.535236+00
925	471	Sticky Notes - Standard	3	2.43	pack	7.29	2022-07-05 19:17:04.535236+00
926	472	Printing Paper - Standard	4	8.65	box	34.60	2024-10-18 19:17:04.535236+00
927	472	Printing Paper - Basic	1	9.73	box	9.73	2024-10-18 19:17:04.535236+00
928	472	Printing Paper - Basic	3	13.59	box	40.77	2024-10-18 19:17:04.535236+00
929	473	Keyboard - Premium	4	98.54	pcs	394.16	2025-05-24 19:17:04.535236+00
930	474	Headset - Basic	5	38.00	pcs	190.00	2022-09-16 19:17:04.535236+00
931	474	Headset - Standard	2	116.24	pcs	232.48	2022-09-16 19:17:04.535236+00
932	474	Headset - Premium	3	117.61	pcs	352.83	2022-09-16 19:17:04.535236+00
933	475	Printing Paper - Premium	1	8.78	box	8.78	2024-02-06 19:17:04.535236+00
934	475	Printing Paper - Standard	2	8.51	box	17.02	2024-02-06 19:17:04.535236+00
935	476	Pen Set - Basic	3	15.05	set	45.15	2025-04-19 19:17:04.535236+00
936	476	Pen Set - Premium	3	14.86	set	44.58	2025-04-19 19:17:04.535236+00
937	476	Pen Set - Basic	1	16.04	set	16.04	2025-04-19 19:17:04.535236+00
938	477	Laptop - Premium	3	595.22	pcs	1785.66	2025-05-13 19:17:04.535236+00
939	477	Laptop - Standard	4	475.46	pcs	1901.84	2025-05-13 19:17:04.535236+00
940	478	Notebook - Standard	2	8.05	pcs	16.10	2024-06-15 19:17:04.535236+00
941	479	Pen Set - Standard	3	9.49	set	28.47	2024-03-17 19:17:04.535236+00
942	479	Pen Set - Premium	3	9.63	set	28.89	2024-03-17 19:17:04.535236+00
943	480	Filing Cabinet - Basic	4	194.31	pcs	777.24	2025-04-17 19:17:04.535236+00
944	481	Sticky Notes - Premium	5	2.98	pack	14.90	2024-11-14 19:17:04.535236+00
945	481	Sticky Notes - Premium	5	4.72	pack	23.60	2024-11-14 19:17:04.535236+00
946	482	Office Chair - Premium	1	134.03	pcs	134.03	2023-12-25 19:17:04.535236+00
947	483	Headset - Basic	5	110.04	pcs	550.20	2024-10-28 19:17:04.535236+00
948	483	Headset - Standard	4	41.04	pcs	164.16	2024-10-28 19:17:04.535236+00
949	484	Filing Cabinet - Basic	4	179.17	pcs	716.68	2024-06-23 19:17:04.535236+00
950	484	Filing Cabinet - Basic	2	335.75	pcs	671.50	2024-06-23 19:17:04.535236+00
951	485	Stapler - Standard	5	19.55	pcs	97.75	2023-10-17 19:17:04.535236+00
952	486	Pen Set - Basic	1	11.50	set	11.50	2023-08-10 19:17:04.535236+00
953	486	Pen Set - Standard	3	10.62	set	31.86	2023-08-10 19:17:04.535236+00
954	486	Pen Set - Basic	2	15.79	set	31.58	2023-08-10 19:17:04.535236+00
955	487	Headset - Premium	2	127.02	pcs	254.04	2024-09-18 19:17:04.535236+00
956	488	Notebook - Basic	5	9.21	pcs	46.05	2021-12-05 19:17:04.535236+00
957	488	Notebook - Basic	1	6.31	pcs	6.31	2021-12-05 19:17:04.535236+00
958	488	Notebook - Standard	4	3.60	pcs	14.40	2021-12-05 19:17:04.535236+00
959	489	Pen Set - Basic	1	19.07	set	19.07	2024-05-26 19:17:04.535236+00
960	489	Pen Set - Standard	1	10.30	set	10.30	2024-05-26 19:17:04.535236+00
961	489	Pen Set - Premium	5	9.58	set	47.90	2024-05-26 19:17:04.535236+00
962	490	Filing Cabinet - Basic	5	253.96	pcs	1269.80	2024-07-21 19:17:04.535236+00
963	490	Filing Cabinet - Premium	4	191.11	pcs	764.44	2024-07-21 19:17:04.535236+00
964	490	Filing Cabinet - Standard	2	240.66	pcs	481.32	2024-07-21 19:17:04.535236+00
965	491	Office Chair - Basic	2	237.05	pcs	474.10	2025-01-24 19:17:04.535236+00
966	492	Stapler - Standard	2	13.69	pcs	27.38	2021-12-19 19:17:04.535236+00
967	493	Filing Cabinet - Standard	4	377.28	pcs	1509.12	2023-12-14 19:17:04.535236+00
968	493	Filing Cabinet - Standard	5	406.49	pcs	2032.45	2023-12-14 19:17:04.535236+00
969	494	Printing Paper - Basic	4	10.92	box	43.68	2023-05-14 19:17:04.535236+00
970	494	Printing Paper - Basic	5	10.88	box	54.40	2023-05-14 19:17:04.535236+00
971	495	Sticky Notes - Basic	5	4.51	pack	22.55	2025-04-13 19:17:04.535236+00
972	495	Sticky Notes - Basic	3	6.18	pack	18.54	2025-04-13 19:17:04.535236+00
973	495	Sticky Notes - Standard	2	5.29	pack	10.58	2025-04-13 19:17:04.535236+00
974	496	Notebook - Basic	5	3.26	pcs	16.30	2021-04-21 19:17:04.535236+00
975	497	Sticky Notes - Premium	4	8.16	pack	32.64	2023-10-21 19:17:04.535236+00
976	498	Printing Paper - Standard	3	7.92	box	23.76	2023-03-01 19:17:04.535236+00
977	498	Printing Paper - Standard	5	6.30	box	31.50	2023-03-01 19:17:04.535236+00
978	499	Laptop - Standard	3	570.31	pcs	1710.93	2025-02-13 19:17:04.535236+00
979	499	Laptop - Basic	3	668.48	pcs	2005.44	2025-02-13 19:17:04.535236+00
980	500	Conference Table - Standard	2	751.48	pcs	1502.96	2025-04-03 19:17:04.535236+00
981	500	Conference Table - Premium	3	1270.76	pcs	3812.28	2025-04-03 19:17:04.535236+00
982	501	Pen Set - Standard	4	17.69	set	70.76	2023-04-25 19:17:04.535236+00
983	502	Printing Paper - Basic	3	14.17	box	42.51	2024-07-18 19:17:04.535236+00
984	503	Headset - Basic	3	35.00	pcs	105.00	2023-07-17 19:17:04.535236+00
985	504	Stapler - Basic	5	16.21	pcs	81.05	2025-03-20 19:17:04.535236+00
986	504	Stapler - Basic	4	19.95	pcs	79.80	2025-03-20 19:17:04.535236+00
987	504	Stapler - Premium	3	20.39	pcs	61.17	2025-03-20 19:17:04.535236+00
988	505	Conference Table - Premium	3	1913.56	pcs	5740.68	2022-10-08 19:17:04.535236+00
989	506	Monitor - Premium	5	223.97	pcs	1119.85	2024-07-06 19:17:04.535236+00
990	506	Monitor - Premium	3	197.28	pcs	591.84	2024-07-06 19:17:04.535236+00
991	506	Monitor - Standard	4	302.65	pcs	1210.60	2024-07-06 19:17:04.535236+00
992	507	Notebook - Standard	3	8.34	pcs	25.02	2022-02-19 19:17:04.535236+00
993	507	Notebook - Basic	4	9.82	pcs	39.28	2022-02-19 19:17:04.535236+00
994	508	Keyboard - Basic	4	95.13	pcs	380.52	2024-04-26 19:17:04.535236+00
995	509	Stapler - Premium	1	16.98	pcs	16.98	2024-11-04 19:17:04.535236+00
996	509	Stapler - Standard	1	13.68	pcs	13.68	2024-11-04 19:17:04.535236+00
997	510	Office Chair - Premium	5	196.96	pcs	984.80	2024-02-08 19:17:04.535236+00
998	511	Sticky Notes - Standard	4	3.14	pack	12.56	2024-09-20 19:17:04.535236+00
999	512	Stapler - Standard	2	11.71	pcs	23.42	2025-02-06 19:17:04.535236+00
1000	512	Stapler - Standard	3	13.44	pcs	40.32	2025-02-06 19:17:04.535236+00
1001	513	Pen Set - Premium	5	19.02	set	95.10	2024-05-26 19:17:04.535236+00
1002	513	Pen Set - Basic	2	16.36	set	32.72	2024-05-26 19:17:04.535236+00
1003	513	Pen Set - Basic	2	18.21	set	36.42	2024-05-26 19:17:04.535236+00
1004	514	Laptop - Standard	5	488.87	pcs	2444.35	2024-05-01 19:17:04.535236+00
1005	514	Laptop - Standard	4	741.16	pcs	2964.64	2024-05-01 19:17:04.535236+00
1006	515	Printing Paper - Basic	2	8.31	box	16.62	2024-05-08 19:17:04.535236+00
1007	516	Notebook - Premium	1	6.25	pcs	6.25	2024-01-13 19:17:04.535236+00
1008	516	Notebook - Premium	4	8.43	pcs	33.72	2024-01-13 19:17:04.535236+00
1009	516	Notebook - Standard	4	4.12	pcs	16.48	2024-01-13 19:17:04.535236+00
1010	517	Sticky Notes - Premium	3	6.67	pack	20.01	2022-03-17 19:17:04.535236+00
1011	518	Notebook - Premium	2	4.67	pcs	9.34	2023-09-25 19:17:04.535236+00
1012	518	Notebook - Standard	1	3.87	pcs	3.87	2023-09-25 19:17:04.535236+00
1013	518	Notebook - Basic	1	5.92	pcs	5.92	2023-09-25 19:17:04.535236+00
1014	519	Desk - Basic	5	359.91	pcs	1799.55	2023-01-08 19:17:04.535236+00
1015	519	Desk - Premium	1	344.55	pcs	344.55	2023-01-08 19:17:04.535236+00
1016	519	Desk - Basic	4	273.77	pcs	1095.08	2023-01-08 19:17:04.535236+00
1017	520	Notebook - Basic	2	6.71	pcs	13.42	2025-05-17 19:17:04.535236+00
1018	520	Notebook - Basic	2	5.20	pcs	10.40	2025-05-17 19:17:04.535236+00
1019	520	Notebook - Standard	3	4.07	pcs	12.21	2025-05-17 19:17:04.535236+00
1020	521	Bookshelf - Standard	2	139.70	pcs	279.40	2025-04-12 19:17:04.535236+00
1021	521	Bookshelf - Basic	5	125.64	pcs	628.20	2025-04-12 19:17:04.535236+00
1022	521	Bookshelf - Premium	2	168.42	pcs	336.84	2025-04-12 19:17:04.535236+00
1023	522	Pen Set - Basic	4	20.13	set	80.52	2023-10-15 19:17:04.535236+00
1024	522	Pen Set - Standard	5	8.45	set	42.25	2023-10-15 19:17:04.535236+00
1025	522	Pen Set - Standard	3	8.30	set	24.90	2023-10-15 19:17:04.535236+00
1026	523	Desk - Premium	3	315.81	pcs	947.43	2022-08-11 19:17:04.535236+00
1027	523	Desk - Standard	5	315.34	pcs	1576.70	2022-08-11 19:17:04.535236+00
1028	523	Desk - Premium	5	208.41	pcs	1042.05	2022-08-11 19:17:04.535236+00
1029	524	Printing Paper - Basic	5	11.50	box	57.50	2025-03-16 19:17:04.535236+00
1030	525	Keyboard - Basic	5	64.13	pcs	320.65	2024-10-19 19:17:04.535236+00
1031	525	Keyboard - Basic	4	79.32	pcs	317.28	2024-10-19 19:17:04.535236+00
1032	525	Keyboard - Premium	4	83.72	pcs	334.88	2024-10-19 19:17:04.535236+00
1033	526	Stapler - Premium	4	20.39	pcs	81.56	2022-10-11 19:17:04.535236+00
1034	526	Stapler - Premium	1	12.33	pcs	12.33	2022-10-11 19:17:04.535236+00
1035	527	Notebook - Premium	4	9.58	pcs	38.32	2024-06-25 19:17:04.535236+00
1036	528	Keyboard - Premium	1	72.25	pcs	72.25	2025-05-28 19:17:04.535236+00
1037	528	Keyboard - Standard	1	78.38	pcs	78.38	2025-05-28 19:17:04.535236+00
1038	529	Conference Table - Basic	3	573.57	pcs	1720.71	2023-06-16 19:17:04.535236+00
1039	529	Conference Table - Basic	2	1313.41	pcs	2626.82	2023-06-16 19:17:04.535236+00
1040	529	Conference Table - Basic	5	1679.88	pcs	8399.40	2023-06-16 19:17:04.535236+00
1041	530	Printing Paper - Premium	2	14.88	box	29.76	2022-10-13 19:17:04.535236+00
1042	531	Notebook - Standard	5	3.14	pcs	15.70	2023-01-26 19:17:04.535236+00
1043	531	Notebook - Premium	1	7.00	pcs	7.00	2023-01-26 19:17:04.535236+00
1044	531	Notebook - Basic	1	3.78	pcs	3.78	2023-01-26 19:17:04.535236+00
1045	532	Notebook - Standard	5	3.65	pcs	18.25	2023-01-01 19:17:04.535236+00
1046	532	Notebook - Standard	5	8.90	pcs	44.50	2023-01-01 19:17:04.535236+00
1047	532	Notebook - Standard	2	5.60	pcs	11.20	2023-01-01 19:17:04.535236+00
1048	533	Pen Set - Premium	5	11.29	set	56.45	2024-05-30 19:17:04.535236+00
1049	533	Pen Set - Basic	1	12.45	set	12.45	2024-05-30 19:17:04.535236+00
1050	534	Pen Set - Basic	2	17.37	set	34.74	2024-11-23 19:17:04.535236+00
1051	534	Pen Set - Basic	4	15.56	set	62.24	2024-11-23 19:17:04.535236+00
1052	534	Pen Set - Basic	2	11.52	set	23.04	2024-11-23 19:17:04.535236+00
1053	535	Mouse - Premium	5	46.31	pcs	231.55	2023-09-30 19:17:04.535236+00
1054	535	Mouse - Premium	1	36.19	pcs	36.19	2023-09-30 19:17:04.535236+00
1055	536	Pen Set - Basic	3	12.54	set	37.62	2021-10-31 19:17:04.535236+00
1056	537	Stapler - Standard	5	19.80	pcs	99.00	2024-11-20 19:17:04.535236+00
1057	537	Stapler - Basic	2	15.72	pcs	31.44	2024-11-20 19:17:04.535236+00
1058	537	Stapler - Premium	3	20.50	pcs	61.50	2024-11-20 19:17:04.535236+00
1059	538	Stapler - Premium	1	19.78	pcs	19.78	2024-09-18 19:17:04.535236+00
1060	538	Stapler - Standard	4	13.62	pcs	54.48	2024-09-18 19:17:04.535236+00
1061	538	Stapler - Premium	1	23.54	pcs	23.54	2024-09-18 19:17:04.535236+00
1062	539	Stapler - Standard	5	14.43	pcs	72.15	2020-12-29 19:17:04.535236+00
1063	540	Notebook - Premium	3	3.15	pcs	9.45	2025-04-20 19:17:04.535236+00
1064	541	Printing Paper - Standard	3	7.14	box	21.42	2024-11-13 19:17:04.535236+00
1065	541	Printing Paper - Standard	1	12.18	box	12.18	2024-11-13 19:17:04.535236+00
1066	542	Stapler - Premium	2	18.72	pcs	37.44	2025-01-22 19:17:04.535236+00
1067	543	Printing Paper - Premium	2	10.08	box	20.16	2022-06-07 19:17:04.535236+00
1068	544	Sticky Notes - Standard	3	3.50	pack	10.50	2024-01-31 19:17:04.535236+00
1069	544	Sticky Notes - Standard	1	6.21	pack	6.21	2024-01-31 19:17:04.535236+00
1070	545	Printing Paper - Basic	2	6.61	box	13.22	2024-09-21 19:17:04.535236+00
1071	545	Printing Paper - Standard	2	8.58	box	17.16	2024-09-21 19:17:04.535236+00
1072	546	Printing Paper - Premium	2	8.73	box	17.46	2025-01-24 19:17:04.535236+00
1073	546	Printing Paper - Standard	1	14.22	box	14.22	2025-01-24 19:17:04.535236+00
1074	547	Pen Set - Basic	1	10.08	set	10.08	2021-04-17 19:17:04.535236+00
1075	548	Conference Table - Basic	4	947.57	pcs	3790.28	2025-05-23 19:17:04.535236+00
1076	548	Conference Table - Premium	1	561.41	pcs	561.41	2025-05-23 19:17:04.535236+00
1077	549	Printing Paper - Standard	3	9.22	box	27.66	2024-06-23 19:17:04.535236+00
1078	550	Filing Cabinet - Standard	4	384.59	pcs	1538.36	2025-05-29 19:17:04.535236+00
1079	550	Filing Cabinet - Standard	5	279.71	pcs	1398.55	2025-05-29 19:17:04.535236+00
1080	550	Filing Cabinet - Standard	2	199.35	pcs	398.70	2025-05-29 19:17:04.535236+00
1081	551	Printing Paper - Basic	3	9.41	box	28.23	2024-02-07 19:17:04.535236+00
1082	551	Printing Paper - Standard	1	6.39	box	6.39	2024-02-07 19:17:04.535236+00
1083	551	Printing Paper - Premium	1	12.72	box	12.72	2024-02-07 19:17:04.535236+00
1084	552	Printing Paper - Premium	5	10.81	box	54.05	2024-12-25 19:17:04.535236+00
1085	552	Printing Paper - Basic	1	7.97	box	7.97	2024-12-25 19:17:04.535236+00
1086	552	Printing Paper - Premium	1	11.22	box	11.22	2024-12-25 19:17:04.535236+00
1087	553	Sticky Notes - Premium	3	2.69	pack	8.07	2024-07-07 19:17:04.535236+00
1088	553	Sticky Notes - Basic	3	4.51	pack	13.53	2024-07-07 19:17:04.535236+00
1089	553	Sticky Notes - Standard	3	5.19	pack	15.57	2024-07-07 19:17:04.535236+00
1090	554	Keyboard - Standard	2	68.43	pcs	136.86	2025-02-14 19:17:04.535236+00
1091	555	Pen Set - Basic	2	17.27	set	34.54	2024-04-27 19:17:04.535236+00
1092	555	Pen Set - Basic	1	14.61	set	14.61	2024-04-27 19:17:04.535236+00
1093	556	Pen Set - Premium	2	13.15	set	26.30	2024-03-21 19:17:04.535236+00
1094	557	Stapler - Standard	3	19.40	pcs	58.20	2024-11-01 19:17:04.535236+00
1095	557	Stapler - Basic	4	14.88	pcs	59.52	2024-11-01 19:17:04.535236+00
1096	557	Stapler - Premium	5	20.34	pcs	101.70	2024-11-01 19:17:04.535236+00
1097	558	Bookshelf - Basic	3	179.94	pcs	539.82	2025-01-16 19:17:04.535236+00
1098	558	Bookshelf - Standard	1	126.81	pcs	126.81	2025-01-16 19:17:04.535236+00
1099	558	Bookshelf - Standard	5	232.49	pcs	1162.45	2025-01-16 19:17:04.535236+00
1100	559	Notebook - Standard	5	9.20	pcs	46.00	2024-07-10 19:17:04.535236+00
1101	560	Filing Cabinet - Standard	4	409.60	pcs	1638.40	2024-01-25 19:17:04.535236+00
1102	561	Sticky Notes - Premium	5	6.28	pack	31.40	2024-12-20 19:17:04.535236+00
1103	562	Printing Paper - Basic	2	9.06	box	18.12	2025-05-19 19:17:04.535236+00
1104	562	Printing Paper - Basic	1	10.08	box	10.08	2025-05-19 19:17:04.535236+00
1105	563	Printing Paper - Standard	3	12.22	box	36.66	2024-12-14 19:17:04.535236+00
1106	563	Printing Paper - Premium	2	9.35	box	18.70	2024-12-14 19:17:04.535236+00
1107	564	Pen Set - Premium	5	14.95	set	74.75	2025-03-30 19:17:04.535236+00
1108	565	Office Chair - Standard	3	145.19	pcs	435.57	2025-05-08 19:17:04.535236+00
1109	566	Desk - Standard	2	372.64	pcs	745.28	2025-04-07 19:17:04.535236+00
1110	566	Desk - Standard	3	303.08	pcs	909.24	2025-04-07 19:17:04.535236+00
1111	567	Bookshelf - Premium	1	201.74	pcs	201.74	2023-05-22 19:17:04.535236+00
1112	568	Sticky Notes - Basic	3	3.55	pack	10.65	2023-08-03 19:17:04.535236+00
1113	569	Office Chair - Standard	3	134.70	pcs	404.10	2023-08-12 19:17:04.535236+00
1114	569	Office Chair - Standard	3	109.97	pcs	329.91	2023-08-12 19:17:04.535236+00
1115	570	Pen Set - Premium	1	16.50	set	16.50	2024-02-01 19:17:04.535236+00
1116	570	Pen Set - Premium	4	11.15	set	44.60	2024-02-01 19:17:04.535236+00
1117	571	Office Chair - Standard	2	210.52	pcs	421.04	2024-05-30 19:17:04.535236+00
1118	572	Sticky Notes - Standard	1	6.74	pack	6.74	2022-12-04 19:17:04.535236+00
1119	572	Sticky Notes - Premium	3	8.00	pack	24.00	2022-12-04 19:17:04.535236+00
1120	572	Sticky Notes - Standard	1	7.38	pack	7.38	2022-12-04 19:17:04.535236+00
1121	573	Laptop - Standard	2	531.02	pcs	1062.04	2024-04-22 19:17:04.535236+00
1122	573	Laptop - Basic	5	679.23	pcs	3396.15	2024-04-22 19:17:04.535236+00
1123	573	Laptop - Basic	4	637.28	pcs	2549.12	2024-04-22 19:17:04.535236+00
1124	574	Sticky Notes - Basic	1	4.03	pack	4.03	2024-05-17 19:17:04.535236+00
1125	575	Filing Cabinet - Standard	4	203.06	pcs	812.24	2025-04-18 19:17:04.535236+00
1126	575	Filing Cabinet - Basic	1	205.78	pcs	205.78	2025-04-18 19:17:04.535236+00
1127	576	Printing Paper - Standard	4	5.91	box	23.64	2022-08-06 19:17:04.535236+00
1128	576	Printing Paper - Premium	5	7.16	box	35.80	2022-08-06 19:17:04.535236+00
1129	576	Printing Paper - Standard	1	7.48	box	7.48	2022-08-06 19:17:04.535236+00
1130	577	Sticky Notes - Standard	4	7.51	pack	30.04	2024-02-11 19:17:04.535236+00
1131	577	Sticky Notes - Premium	4	4.34	pack	17.36	2024-02-11 19:17:04.535236+00
1132	578	Desk - Standard	5	375.55	pcs	1877.75	2023-06-13 19:17:04.535236+00
1133	578	Desk - Basic	3	314.19	pcs	942.57	2023-06-13 19:17:04.535236+00
1134	578	Desk - Basic	4	302.14	pcs	1208.56	2023-06-13 19:17:04.535236+00
1135	579	Printing Paper - Standard	3	6.33	box	18.99	2025-04-11 19:17:04.535236+00
1136	580	Notebook - Standard	3	3.16	pcs	9.48	2023-05-04 19:17:04.535236+00
1137	580	Notebook - Standard	5	6.52	pcs	32.60	2023-05-04 19:17:04.535236+00
1138	581	Desk - Basic	4	231.97	pcs	927.88	2022-06-17 19:17:04.535236+00
1139	581	Desk - Basic	4	473.21	pcs	1892.84	2022-06-17 19:17:04.535236+00
1140	581	Desk - Standard	1	248.55	pcs	248.55	2022-06-17 19:17:04.535236+00
1141	582	Laptop - Premium	2	748.18	pcs	1496.36	2025-05-15 19:17:04.535236+00
1142	583	Printing Paper - Premium	3	14.88	box	44.64	2022-12-15 19:17:04.535236+00
1143	583	Printing Paper - Standard	2	9.43	box	18.86	2022-12-15 19:17:04.535236+00
1144	583	Printing Paper - Standard	3	8.69	box	26.07	2022-12-15 19:17:04.535236+00
1145	584	Sticky Notes - Standard	2	4.57	pack	9.14	2025-05-14 19:17:04.535236+00
1146	585	Laptop - Basic	3	558.70	pcs	1676.10	2022-11-28 19:17:04.535236+00
1147	585	Laptop - Standard	2	658.91	pcs	1317.82	2022-11-28 19:17:04.535236+00
1148	585	Laptop - Standard	3	679.12	pcs	2037.36	2022-11-28 19:17:04.535236+00
1149	586	Notebook - Standard	1	6.99	pcs	6.99	2022-08-07 19:17:04.535236+00
1150	586	Notebook - Premium	2	6.27	pcs	12.54	2022-08-07 19:17:04.535236+00
1151	586	Notebook - Standard	2	4.55	pcs	9.10	2022-08-07 19:17:04.535236+00
1152	587	Office Chair - Basic	4	181.08	pcs	724.32	2023-07-02 19:17:04.535236+00
1153	587	Office Chair - Standard	2	153.22	pcs	306.44	2023-07-02 19:17:04.535236+00
1154	587	Office Chair - Basic	3	210.00	pcs	630.00	2023-07-02 19:17:04.535236+00
1155	588	Laptop - Standard	5	425.17	pcs	2125.85	2024-07-25 19:17:04.535236+00
1156	588	Laptop - Premium	5	797.92	pcs	3989.60	2024-07-25 19:17:04.535236+00
1157	588	Laptop - Premium	4	607.51	pcs	2430.04	2024-07-25 19:17:04.535236+00
1158	589	Sticky Notes - Basic	1	4.48	pack	4.48	2024-04-03 19:17:04.535236+00
1159	589	Sticky Notes - Basic	5	7.43	pack	37.15	2024-04-03 19:17:04.535236+00
1160	590	Mouse - Basic	2	22.28	pcs	44.56	2024-10-12 19:17:04.535236+00
1161	590	Mouse - Basic	4	27.48	pcs	109.92	2024-10-12 19:17:04.535236+00
1162	590	Mouse - Premium	4	25.26	pcs	101.04	2024-10-12 19:17:04.535236+00
1163	591	Pen Set - Premium	1	9.55	set	9.55	2025-04-20 19:17:04.535236+00
1164	591	Pen Set - Premium	5	16.07	set	80.35	2025-04-20 19:17:04.535236+00
1165	591	Pen Set - Basic	3	12.44	set	37.32	2025-04-20 19:17:04.535236+00
1166	592	Sticky Notes - Basic	2	2.99	pack	5.98	2024-10-30 19:17:04.535236+00
1167	593	Mouse - Basic	2	38.88	pcs	77.76	2022-01-27 19:17:04.535236+00
1168	593	Mouse - Standard	2	44.20	pcs	88.40	2022-01-27 19:17:04.535236+00
1169	594	Sticky Notes - Basic	5	6.63	pack	33.15	2023-11-29 19:17:04.535236+00
1170	594	Sticky Notes - Standard	2	5.54	pack	11.08	2023-11-29 19:17:04.535236+00
1171	595	Stapler - Premium	3	23.90	pcs	71.70	2025-02-23 19:17:04.535236+00
1172	596	Printing Paper - Standard	5	14.86	box	74.30	2024-06-08 19:17:04.535236+00
1173	597	Filing Cabinet - Premium	2	222.62	pcs	445.24	2023-03-06 19:17:04.535236+00
1174	597	Filing Cabinet - Standard	4	395.96	pcs	1583.84	2023-03-06 19:17:04.535236+00
1175	597	Filing Cabinet - Premium	2	334.99	pcs	669.98	2023-03-06 19:17:04.535236+00
1176	598	Office Chair - Basic	1	117.27	pcs	117.27	2023-01-15 19:17:04.535236+00
1177	599	Conference Table - Premium	2	1495.83	pcs	2991.66	2024-12-16 19:17:04.535236+00
1178	599	Conference Table - Standard	5	1843.84	pcs	9219.20	2024-12-16 19:17:04.535236+00
1179	600	Stapler - Premium	4	23.41	pcs	93.64	2023-07-23 19:17:04.535236+00
1180	601	Stapler - Standard	4	12.77	pcs	51.08	2023-06-05 19:17:04.535236+00
1181	602	Laptop - Standard	4	478.62	pcs	1914.48	2024-04-06 19:17:04.535236+00
1182	602	Laptop - Standard	3	734.80	pcs	2204.40	2024-04-06 19:17:04.535236+00
1183	603	Conference Table - Standard	3	1195.99	pcs	3587.97	2025-01-02 19:17:04.535236+00
1184	603	Conference Table - Basic	4	1797.14	pcs	7188.56	2025-01-02 19:17:04.535236+00
1185	604	Keyboard - Basic	1	90.87	pcs	90.87	2021-05-28 19:17:04.535236+00
1186	605	Stapler - Standard	3	20.82	pcs	62.46	2024-06-13 19:17:04.535236+00
1187	606	Bookshelf - Standard	5	196.90	pcs	984.50	2025-05-30 19:17:04.535236+00
1188	607	Notebook - Basic	2	8.81	pcs	17.62	2024-08-05 19:17:04.535236+00
1189	608	Sticky Notes - Premium	4	5.08	pack	20.32	2021-12-09 19:17:04.535236+00
1190	608	Sticky Notes - Basic	5	2.15	pack	10.75	2021-12-09 19:17:04.535236+00
1191	609	Printing Paper - Premium	5	5.92	box	29.60	2024-10-18 19:17:04.535236+00
1192	609	Printing Paper - Premium	2	11.74	box	23.48	2024-10-18 19:17:04.535236+00
1193	609	Printing Paper - Standard	1	14.55	box	14.55	2024-10-18 19:17:04.535236+00
1194	610	Conference Table - Premium	1	1703.77	pcs	1703.77	2024-06-06 19:17:04.535236+00
1195	611	Sticky Notes - Basic	3	6.72	pack	20.16	2024-07-31 19:17:04.535236+00
1196	611	Sticky Notes - Basic	4	4.64	pack	18.56	2024-07-31 19:17:04.535236+00
1197	611	Sticky Notes - Premium	2	7.41	pack	14.82	2024-07-31 19:17:04.535236+00
1198	612	Filing Cabinet - Basic	3	364.13	pcs	1092.39	2024-03-23 19:17:04.535236+00
1199	612	Filing Cabinet - Premium	3	323.01	pcs	969.03	2024-03-23 19:17:04.535236+00
1200	612	Filing Cabinet - Premium	2	333.81	pcs	667.62	2024-03-23 19:17:04.535236+00
1201	613	Printing Paper - Basic	2	15.00	box	30.00	2024-10-22 19:17:04.535236+00
1202	614	Pen Set - Standard	2	17.11	set	34.22	2024-10-20 19:17:04.535236+00
1203	614	Pen Set - Premium	1	17.16	set	17.16	2024-10-20 19:17:04.535236+00
1204	615	Sticky Notes - Basic	4	2.62	pack	10.48	2024-09-17 19:17:04.535236+00
1205	615	Sticky Notes - Premium	5	7.92	pack	39.60	2024-09-17 19:17:04.535236+00
1206	616	Notebook - Premium	5	4.47	pcs	22.35	2024-08-14 19:17:04.535236+00
1207	617	Notebook - Standard	3	5.15	pcs	15.45	2024-09-01 19:17:04.535236+00
1208	618	Stapler - Standard	4	11.90	pcs	47.60	2022-02-07 19:17:04.535236+00
1209	619	Sticky Notes - Premium	3	2.23	pack	6.69	2025-04-08 19:17:04.535236+00
1210	620	Stapler - Standard	4	23.92	pcs	95.68	2024-04-10 19:17:04.535236+00
1211	620	Stapler - Basic	2	18.79	pcs	37.58	2024-04-10 19:17:04.535236+00
1212	620	Stapler - Standard	3	19.37	pcs	58.11	2024-04-10 19:17:04.535236+00
1213	621	Bookshelf - Standard	4	247.97	pcs	991.88	2024-06-13 19:17:04.535236+00
1214	621	Bookshelf - Basic	5	197.91	pcs	989.55	2024-06-13 19:17:04.535236+00
1215	622	Mouse - Standard	3	37.84	pcs	113.52	2024-04-10 19:17:04.535236+00
1216	623	Sticky Notes - Premium	2	3.40	pack	6.80	2023-08-14 19:17:04.535236+00
1217	623	Sticky Notes - Standard	4	6.24	pack	24.96	2023-08-14 19:17:04.535236+00
1218	623	Sticky Notes - Standard	4	4.51	pack	18.04	2023-08-14 19:17:04.535236+00
1219	624	Bookshelf - Standard	1	255.57	pcs	255.57	2023-07-14 19:17:04.535236+00
1220	624	Bookshelf - Basic	2	243.96	pcs	487.92	2023-07-14 19:17:04.535236+00
1221	625	Mouse - Basic	4	49.34	pcs	197.36	2023-11-29 19:17:04.535236+00
1222	625	Mouse - Premium	4	50.96	pcs	203.84	2023-11-29 19:17:04.535236+00
1223	626	Sticky Notes - Basic	2	6.78	pack	13.56	2025-03-10 19:17:04.535236+00
1224	626	Sticky Notes - Basic	1	3.56	pack	3.56	2025-03-10 19:17:04.535236+00
1225	626	Sticky Notes - Standard	1	4.26	pack	4.26	2025-03-10 19:17:04.535236+00
1226	627	Printing Paper - Basic	1	9.44	box	9.44	2022-06-19 19:17:04.535236+00
1227	627	Printing Paper - Premium	3	6.81	box	20.43	2022-06-19 19:17:04.535236+00
1228	627	Printing Paper - Standard	1	8.05	box	8.05	2022-06-19 19:17:04.535236+00
1229	628	Laptop - Standard	4	707.41	pcs	2829.64	2024-08-14 19:17:04.535236+00
1230	629	Mouse - Premium	4	48.94	pcs	195.76	2024-11-02 19:17:04.535236+00
1231	630	Filing Cabinet - Basic	2	321.02	pcs	642.04	2022-05-01 19:17:04.535236+00
1232	630	Filing Cabinet - Basic	4	232.51	pcs	930.04	2022-05-01 19:17:04.535236+00
1233	630	Filing Cabinet - Standard	1	178.27	pcs	178.27	2022-05-01 19:17:04.535236+00
1234	631	Sticky Notes - Standard	1	5.96	pack	5.96	2025-03-08 19:17:04.535236+00
1235	631	Sticky Notes - Basic	2	2.17	pack	4.34	2025-03-08 19:17:04.535236+00
1236	632	Printing Paper - Premium	3	14.51	box	43.53	2025-03-02 19:17:04.535236+00
1237	632	Printing Paper - Basic	2	10.82	box	21.64	2025-03-02 19:17:04.535236+00
1238	633	Notebook - Basic	4	7.51	pcs	30.04	2023-03-23 19:17:04.535236+00
1239	633	Notebook - Premium	4	3.32	pcs	13.28	2023-03-23 19:17:04.535236+00
1240	634	Printing Paper - Basic	5	15.60	box	78.00	2025-05-30 19:17:04.535236+00
1241	634	Printing Paper - Standard	5	12.30	box	61.50	2025-05-30 19:17:04.535236+00
1242	634	Printing Paper - Basic	5	5.94	box	29.70	2025-05-30 19:17:04.535236+00
1243	635	Notebook - Premium	2	3.75	pcs	7.50	2025-05-06 19:17:04.535236+00
1244	635	Notebook - Premium	4	4.72	pcs	18.88	2025-05-06 19:17:04.535236+00
1245	635	Notebook - Standard	4	4.57	pcs	18.28	2025-05-06 19:17:04.535236+00
1246	636	Keyboard - Basic	2	62.16	pcs	124.32	2022-04-11 19:17:04.535236+00
1247	636	Keyboard - Standard	4	71.33	pcs	285.32	2022-04-11 19:17:04.535236+00
1248	637	Pen Set - Premium	3	7.80	set	23.40	2024-12-05 19:17:04.535236+00
1249	638	Monitor - Basic	4	296.28	pcs	1185.12	2025-04-01 19:17:04.535236+00
1250	639	Pen Set - Premium	1	11.91	set	11.91	2024-02-05 19:17:04.535236+00
1251	639	Pen Set - Premium	2	11.21	set	22.42	2024-02-05 19:17:04.535236+00
1252	640	Office Chair - Basic	1	212.58	pcs	212.58	2025-04-11 19:17:04.535236+00
1253	640	Office Chair - Premium	5	129.70	pcs	648.50	2025-04-11 19:17:04.535236+00
1254	641	Notebook - Premium	5	6.21	pcs	31.05	2025-04-05 19:17:04.535236+00
1255	641	Notebook - Premium	1	3.76	pcs	3.76	2025-04-05 19:17:04.535236+00
1256	641	Notebook - Standard	2	8.85	pcs	17.70	2025-04-05 19:17:04.535236+00
1257	642	Notebook - Premium	3	4.16	pcs	12.48	2025-03-30 19:17:04.535236+00
1258	642	Notebook - Premium	2	6.72	pcs	13.44	2025-03-30 19:17:04.535236+00
1259	643	Pen Set - Premium	3	17.20	set	51.60	2022-11-15 19:17:04.535236+00
1260	644	Notebook - Basic	1	7.97	pcs	7.97	2022-03-31 19:17:04.535236+00
1261	644	Notebook - Standard	2	3.85	pcs	7.70	2022-03-31 19:17:04.535236+00
1262	644	Notebook - Premium	5	4.64	pcs	23.20	2022-03-31 19:17:04.535236+00
1263	645	Printing Paper - Basic	1	8.62	box	8.62	2024-03-31 19:17:04.535236+00
1264	646	Printing Paper - Premium	5	10.69	box	53.45	2024-04-02 19:17:04.535236+00
1265	646	Printing Paper - Premium	4	8.27	box	33.08	2024-04-02 19:17:04.535236+00
1266	646	Printing Paper - Standard	5	9.26	box	46.30	2024-04-02 19:17:04.535236+00
1267	647	Sticky Notes - Standard	2	7.53	pack	15.06	2025-05-23 19:17:04.535236+00
1268	647	Sticky Notes - Premium	2	2.13	pack	4.26	2025-05-23 19:17:04.535236+00
1269	648	Monitor - Basic	5	233.89	pcs	1169.45	2025-02-06 19:17:04.535236+00
1270	649	Pen Set - Basic	3	19.26	set	57.78	2024-03-27 19:17:04.535236+00
1271	649	Pen Set - Standard	2	19.18	set	38.36	2024-03-27 19:17:04.535236+00
1272	650	Keyboard - Premium	4	63.34	pcs	253.36	2025-03-04 19:17:04.535236+00
1273	650	Keyboard - Standard	1	56.72	pcs	56.72	2025-03-04 19:17:04.535236+00
1274	650	Keyboard - Standard	5	90.49	pcs	452.45	2025-03-04 19:17:04.535236+00
1275	651	Pen Set - Premium	5	12.83	set	64.15	2024-09-05 19:17:04.535236+00
1276	651	Pen Set - Basic	5	12.95	set	64.75	2024-09-05 19:17:04.535236+00
1277	651	Pen Set - Premium	3	11.35	set	34.05	2024-09-05 19:17:04.535236+00
1278	652	Notebook - Premium	5	3.78	pcs	18.90	2025-05-29 19:17:04.535236+00
1279	653	Keyboard - Standard	3	90.00	pcs	270.00	2024-06-06 19:17:04.535236+00
1280	653	Keyboard - Basic	3	81.73	pcs	245.19	2024-06-06 19:17:04.535236+00
1281	654	Stapler - Basic	1	10.33	pcs	10.33	2023-10-21 19:17:04.535236+00
1282	654	Stapler - Standard	5	15.56	pcs	77.80	2023-10-21 19:17:04.535236+00
1283	654	Stapler - Standard	5	23.85	pcs	119.25	2023-10-21 19:17:04.535236+00
1284	655	Pen Set - Standard	5	9.36	set	46.80	2023-08-20 19:17:04.535236+00
1285	655	Pen Set - Basic	5	12.22	set	61.10	2023-08-20 19:17:04.535236+00
1286	655	Pen Set - Standard	1	10.00	set	10.00	2023-08-20 19:17:04.535236+00
1287	656	Pen Set - Basic	2	17.93	set	35.86	2025-05-19 19:17:04.535236+00
1288	656	Pen Set - Standard	5	10.51	set	52.55	2025-05-19 19:17:04.535236+00
1289	657	Stapler - Basic	3	18.16	pcs	54.48	2025-01-18 19:17:04.535236+00
1290	657	Stapler - Basic	2	17.48	pcs	34.96	2025-01-18 19:17:04.535236+00
1291	658	Laptop - Standard	5	727.15	pcs	3635.75	2025-04-15 19:17:04.535236+00
1292	658	Laptop - Premium	2	445.81	pcs	891.62	2025-04-15 19:17:04.535236+00
1293	659	Sticky Notes - Basic	5	3.97	pack	19.85	2025-04-30 19:17:04.535236+00
1294	659	Sticky Notes - Premium	5	5.69	pack	28.45	2025-04-30 19:17:04.535236+00
1295	659	Sticky Notes - Standard	5	5.51	pack	27.55	2025-04-30 19:17:04.535236+00
1296	660	Desk - Basic	4	443.11	pcs	1772.44	2022-10-03 19:17:04.535236+00
1297	660	Desk - Standard	1	458.62	pcs	458.62	2022-10-03 19:17:04.535236+00
1298	661	Printing Paper - Basic	5	9.15	box	45.75	2023-02-25 19:17:04.535236+00
1299	662	Keyboard - Standard	4	103.93	pcs	415.72	2024-05-10 19:17:04.535236+00
1300	662	Keyboard - Basic	5	75.95	pcs	379.75	2024-05-10 19:17:04.535236+00
1301	662	Keyboard - Basic	3	52.76	pcs	158.28	2024-05-10 19:17:04.535236+00
1302	663	Notebook - Standard	1	5.39	pcs	5.39	2022-10-08 19:17:04.535236+00
1303	663	Notebook - Basic	3	7.61	pcs	22.83	2022-10-08 19:17:04.535236+00
1304	663	Notebook - Premium	2	9.39	pcs	18.78	2022-10-08 19:17:04.535236+00
1305	664	Filing Cabinet - Standard	4	260.74	pcs	1042.96	2024-09-12 19:17:04.535236+00
1306	665	Sticky Notes - Standard	4	6.37	pack	25.48	2024-06-20 19:17:04.535236+00
1307	666	Sticky Notes - Standard	2	7.33	pack	14.66	2023-02-19 19:17:04.535236+00
1308	666	Sticky Notes - Standard	5	4.00	pack	20.00	2023-02-19 19:17:04.535236+00
1309	667	Stapler - Premium	4	15.54	pcs	62.16	2024-05-11 19:17:04.535236+00
1310	667	Stapler - Premium	1	14.04	pcs	14.04	2024-05-11 19:17:04.535236+00
1311	668	Conference Table - Premium	3	1522.57	pcs	4567.71	2023-03-26 19:17:04.535236+00
1312	668	Conference Table - Basic	3	1023.26	pcs	3069.78	2023-03-26 19:17:04.535236+00
1313	669	Pen Set - Premium	3	13.78	set	41.34	2023-09-01 19:17:04.535236+00
1314	670	Stapler - Basic	1	14.47	pcs	14.47	2022-11-16 19:17:04.535236+00
1315	670	Stapler - Standard	3	16.47	pcs	49.41	2022-11-16 19:17:04.535236+00
1316	670	Stapler - Basic	1	20.16	pcs	20.16	2022-11-16 19:17:04.535236+00
1317	671	Stapler - Premium	1	21.52	pcs	21.52	2024-07-09 19:17:04.535236+00
1318	672	Bookshelf - Premium	2	124.33	pcs	248.66	2022-07-19 19:17:04.535236+00
1319	672	Bookshelf - Premium	1	90.22	pcs	90.22	2022-07-19 19:17:04.535236+00
1320	673	Printing Paper - Standard	3	8.86	box	26.58	2023-01-27 19:17:04.535236+00
1321	673	Printing Paper - Premium	1	11.25	box	11.25	2023-01-27 19:17:04.535236+00
1322	674	Notebook - Standard	3	8.36	pcs	25.08	2024-01-31 19:17:04.535236+00
1323	674	Notebook - Standard	4	9.27	pcs	37.08	2024-01-31 19:17:04.535236+00
1324	674	Notebook - Premium	5	4.48	pcs	22.40	2024-01-31 19:17:04.535236+00
1325	675	Laptop - Premium	1	527.90	pcs	527.90	2025-05-18 19:17:04.535236+00
1326	675	Laptop - Standard	2	566.61	pcs	1133.22	2025-05-18 19:17:04.535236+00
1327	676	Monitor - Basic	2	209.01	pcs	418.02	2024-07-24 19:17:04.535236+00
1328	676	Monitor - Premium	1	152.33	pcs	152.33	2024-07-24 19:17:04.535236+00
1329	677	Desk - Premium	2	303.62	pcs	607.24	2025-02-09 19:17:04.535236+00
1330	678	Filing Cabinet - Premium	2	158.43	pcs	316.86	2025-05-23 19:17:04.535236+00
1331	678	Filing Cabinet - Standard	2	198.00	pcs	396.00	2025-05-23 19:17:04.535236+00
1332	679	Desk - Standard	2	240.92	pcs	481.84	2023-10-08 19:17:04.535236+00
1333	679	Desk - Basic	2	424.31	pcs	848.62	2023-10-08 19:17:04.535236+00
1334	680	Stapler - Standard	5	22.54	pcs	112.70	2023-12-31 19:17:04.535236+00
1335	680	Stapler - Basic	5	20.16	pcs	100.80	2023-12-31 19:17:04.535236+00
1336	681	Sticky Notes - Premium	5	7.94	pack	39.70	2025-04-14 19:17:04.535236+00
1337	681	Sticky Notes - Premium	1	3.10	pack	3.10	2025-04-14 19:17:04.535236+00
1338	682	Headset - Premium	3	48.71	pcs	146.13	2024-05-03 19:17:04.535236+00
1339	682	Headset - Standard	3	150.23	pcs	450.69	2024-05-03 19:17:04.535236+00
1340	683	Desk - Premium	4	388.18	pcs	1552.72	2022-01-22 19:17:04.535236+00
1341	683	Desk - Premium	4	270.64	pcs	1082.56	2022-01-22 19:17:04.535236+00
1342	683	Desk - Basic	3	365.20	pcs	1095.60	2022-01-22 19:17:04.535236+00
1343	684	Pen Set - Basic	5	9.09	set	45.45	2025-03-25 19:17:04.535236+00
1344	684	Pen Set - Basic	1	9.96	set	9.96	2025-03-25 19:17:04.535236+00
1345	685	Stapler - Standard	1	17.64	pcs	17.64	2025-02-14 19:17:04.535236+00
1346	685	Stapler - Basic	5	20.47	pcs	102.35	2025-02-14 19:17:04.535236+00
1347	686	Sticky Notes - Standard	1	2.19	pack	2.19	2024-10-23 19:17:04.535236+00
1348	686	Sticky Notes - Standard	5	2.57	pack	12.85	2024-10-23 19:17:04.535236+00
1349	686	Sticky Notes - Standard	1	2.27	pack	2.27	2024-10-23 19:17:04.535236+00
1350	687	Notebook - Premium	1	9.07	pcs	9.07	2024-10-19 19:17:04.535236+00
1351	687	Notebook - Premium	4	4.15	pcs	16.60	2024-10-19 19:17:04.535236+00
1352	688	Stapler - Basic	5	14.25	pcs	71.25	2024-04-20 19:17:04.535236+00
1353	688	Stapler - Premium	2	17.29	pcs	34.58	2024-04-20 19:17:04.535236+00
1354	688	Stapler - Basic	4	24.29	pcs	97.16	2024-04-20 19:17:04.535236+00
1355	689	Notebook - Premium	3	6.34	pcs	19.02	2025-04-23 19:17:04.535236+00
1356	689	Notebook - Standard	4	6.28	pcs	25.12	2025-04-23 19:17:04.535236+00
1357	690	Printing Paper - Standard	4	11.85	box	47.40	2023-12-05 19:17:04.535236+00
1358	690	Printing Paper - Standard	5	13.56	box	67.80	2023-12-05 19:17:04.535236+00
1359	690	Printing Paper - Basic	2	6.79	box	13.58	2023-12-05 19:17:04.535236+00
1360	691	Sticky Notes - Standard	5	2.83	pack	14.15	2024-07-12 19:17:04.535236+00
1361	692	Stapler - Basic	5	17.15	pcs	85.75	2025-01-29 19:17:04.535236+00
1362	692	Stapler - Standard	2	11.20	pcs	22.40	2025-01-29 19:17:04.535236+00
1363	693	Desk - Basic	5	448.49	pcs	2242.45	2023-04-25 19:17:04.535236+00
1364	693	Desk - Basic	2	315.84	pcs	631.68	2023-04-25 19:17:04.535236+00
1365	694	Printing Paper - Basic	2	6.32	box	12.64	2025-05-03 19:17:04.535236+00
1366	695	Office Chair - Basic	2	175.68	pcs	351.36	2024-02-17 19:17:04.535236+00
1367	696	Desk - Premium	4	375.46	pcs	1501.84	2024-01-23 19:17:04.535236+00
1368	696	Desk - Basic	2	332.71	pcs	665.42	2024-01-23 19:17:04.535236+00
1369	697	Desk - Basic	4	471.07	pcs	1884.28	2023-07-29 19:17:04.535236+00
1370	697	Desk - Premium	4	367.28	pcs	1469.12	2023-07-29 19:17:04.535236+00
1371	697	Desk - Basic	2	223.56	pcs	447.12	2023-07-29 19:17:04.535236+00
1372	698	Monitor - Basic	1	185.43	pcs	185.43	2022-04-25 19:17:04.535236+00
1373	698	Monitor - Premium	4	247.80	pcs	991.20	2022-04-25 19:17:04.535236+00
1374	698	Monitor - Basic	5	164.23	pcs	821.15	2022-04-25 19:17:04.535236+00
1375	699	Office Chair - Premium	3	111.60	pcs	334.80	2021-10-10 19:17:04.535236+00
1376	700	Bookshelf - Basic	5	212.69	pcs	1063.45	2024-10-05 19:17:04.535236+00
1377	701	Sticky Notes - Premium	1	3.71	pack	3.71	2020-11-10 19:17:04.535236+00
1378	701	Sticky Notes - Basic	2	5.34	pack	10.68	2020-11-10 19:17:04.535236+00
1379	702	Bookshelf - Standard	5	173.30	pcs	866.50	2024-03-12 19:17:04.535236+00
1380	702	Bookshelf - Standard	3	195.07	pcs	585.21	2024-03-12 19:17:04.535236+00
1381	703	Notebook - Standard	2	8.48	pcs	16.96	2025-02-24 19:17:04.535236+00
1382	704	Notebook - Standard	2	3.78	pcs	7.56	2025-04-20 19:17:04.535236+00
1383	704	Notebook - Basic	3	7.87	pcs	23.61	2025-04-20 19:17:04.535236+00
1384	705	Pen Set - Basic	3	16.68	set	50.04	2024-06-20 19:17:04.535236+00
1385	705	Pen Set - Premium	1	13.26	set	13.26	2024-06-20 19:17:04.535236+00
1386	706	Bookshelf - Premium	3	162.83	pcs	488.49	2021-07-28 19:17:04.535236+00
1387	706	Bookshelf - Premium	1	100.86	pcs	100.86	2021-07-28 19:17:04.535236+00
1388	706	Bookshelf - Standard	4	197.27	pcs	789.08	2021-07-28 19:17:04.535236+00
1389	707	Office Chair - Basic	3	219.82	pcs	659.46	2025-05-27 19:17:04.535236+00
1390	708	Pen Set - Standard	3	15.98	set	47.94	2024-01-18 19:17:04.535236+00
1391	709	Notebook - Premium	5	4.84	pcs	24.20	2025-04-04 19:17:04.535236+00
1392	709	Notebook - Standard	5	4.18	pcs	20.90	2025-04-04 19:17:04.535236+00
1393	710	Sticky Notes - Basic	2	7.91	pack	15.82	2024-06-15 19:17:04.535236+00
1394	710	Sticky Notes - Standard	4	5.79	pack	23.16	2024-06-15 19:17:04.535236+00
1395	710	Sticky Notes - Standard	5	4.46	pack	22.30	2024-06-15 19:17:04.535236+00
1396	711	Sticky Notes - Basic	4	4.93	pack	19.72	2024-12-14 19:17:04.535236+00
1397	711	Sticky Notes - Premium	3	2.65	pack	7.95	2024-12-14 19:17:04.535236+00
1398	711	Sticky Notes - Standard	5	4.05	pack	20.25	2024-12-14 19:17:04.535236+00
1399	712	Stapler - Premium	1	10.72	pcs	10.72	2023-05-03 19:17:04.535236+00
1400	712	Stapler - Basic	5	12.93	pcs	64.65	2023-05-03 19:17:04.535236+00
1401	712	Stapler - Standard	2	25.12	pcs	50.24	2023-05-03 19:17:04.535236+00
1402	713	Stapler - Basic	2	24.83	pcs	49.66	2025-05-17 19:17:04.535236+00
1403	713	Stapler - Premium	3	17.01	pcs	51.03	2025-05-17 19:17:04.535236+00
1404	714	Desk - Premium	1	497.13	pcs	497.13	2025-04-19 19:17:04.535236+00
1405	714	Desk - Basic	1	336.11	pcs	336.11	2025-04-19 19:17:04.535236+00
1406	715	Keyboard - Basic	4	56.92	pcs	227.68	2023-12-26 19:17:04.535236+00
1407	715	Keyboard - Standard	4	69.56	pcs	278.24	2023-12-26 19:17:04.535236+00
1408	716	Pen Set - Premium	4	19.13	set	76.52	2023-04-24 19:17:04.535236+00
1409	717	Notebook - Basic	3	4.41	pcs	13.23	2022-12-20 19:17:04.535236+00
1410	717	Notebook - Standard	1	9.32	pcs	9.32	2022-12-20 19:17:04.535236+00
1411	717	Notebook - Standard	5	6.04	pcs	30.20	2022-12-20 19:17:04.535236+00
1412	718	Printing Paper - Premium	2	12.40	box	24.80	2024-11-13 19:17:04.535236+00
1413	718	Printing Paper - Standard	1	12.82	box	12.82	2024-11-13 19:17:04.535236+00
1414	718	Printing Paper - Basic	4	5.42	box	21.68	2024-11-13 19:17:04.535236+00
1415	719	Desk - Standard	1	373.75	pcs	373.75	2021-01-05 19:17:04.535236+00
1416	719	Desk - Premium	3	379.98	pcs	1139.94	2021-01-05 19:17:04.535236+00
1417	720	Keyboard - Standard	1	75.82	pcs	75.82	2023-04-22 19:17:04.535236+00
1418	720	Keyboard - Basic	4	76.90	pcs	307.60	2023-04-22 19:17:04.535236+00
1419	721	Notebook - Standard	5	3.58	pcs	17.90	2023-09-25 19:17:04.535236+00
1420	722	Notebook - Basic	4	4.47	pcs	17.88	2022-02-05 19:17:04.535236+00
1421	723	Conference Table - Basic	5	1346.76	pcs	6733.80	2025-02-02 19:17:04.535236+00
1422	723	Conference Table - Premium	4	1320.30	pcs	5281.20	2025-02-02 19:17:04.535236+00
1423	723	Conference Table - Premium	1	1883.76	pcs	1883.76	2025-02-02 19:17:04.535236+00
1424	724	Stapler - Standard	3	12.77	pcs	38.31	2025-02-03 19:17:04.535236+00
1425	724	Stapler - Standard	5	24.62	pcs	123.10	2025-02-03 19:17:04.535236+00
1426	724	Stapler - Standard	2	12.04	pcs	24.08	2025-02-03 19:17:04.535236+00
1427	725	Printing Paper - Standard	1	11.46	box	11.46	2023-05-08 19:17:04.535236+00
1428	725	Printing Paper - Premium	4	13.72	box	54.88	2023-05-08 19:17:04.535236+00
1429	726	Printing Paper - Premium	5	7.54	box	37.70	2025-03-14 19:17:04.535236+00
1430	727	Headset - Basic	3	140.80	pcs	422.40	2024-03-09 19:17:04.535236+00
1431	728	Filing Cabinet - Premium	4	333.09	pcs	1332.36	2025-03-02 19:17:04.535236+00
1432	728	Filing Cabinet - Premium	1	393.49	pcs	393.49	2025-03-02 19:17:04.535236+00
1433	728	Filing Cabinet - Standard	2	261.89	pcs	523.78	2025-03-02 19:17:04.535236+00
1434	729	Office Chair - Basic	5	160.43	pcs	802.15	2022-03-07 19:17:04.535236+00
1435	730	Printing Paper - Premium	5	13.30	box	66.50	2021-07-13 19:17:04.535236+00
1436	730	Printing Paper - Premium	1	12.02	box	12.02	2021-07-13 19:17:04.535236+00
1437	731	Desk - Premium	1	380.87	pcs	380.87	2025-05-22 19:17:04.535236+00
1438	731	Desk - Basic	3	487.96	pcs	1463.88	2025-05-22 19:17:04.535236+00
1439	732	Stapler - Basic	2	23.65	pcs	47.30	2024-09-03 19:17:04.535236+00
1440	733	Sticky Notes - Premium	4	7.42	pack	29.68	2025-04-23 19:17:04.535236+00
1441	733	Sticky Notes - Basic	5	2.76	pack	13.80	2025-04-23 19:17:04.535236+00
1442	734	Headset - Standard	3	42.82	pcs	128.46	2025-03-17 19:17:04.535236+00
1443	735	Notebook - Premium	5	7.61	pcs	38.05	2023-09-01 19:17:04.535236+00
1444	735	Notebook - Premium	5	8.71	pcs	43.55	2023-09-01 19:17:04.535236+00
1445	736	Stapler - Basic	3	22.21	pcs	66.63	2024-03-25 19:17:04.535236+00
1446	736	Stapler - Standard	3	15.95	pcs	47.85	2024-03-25 19:17:04.535236+00
1447	736	Stapler - Premium	3	21.41	pcs	64.23	2024-03-25 19:17:04.535236+00
1448	737	Notebook - Premium	5	6.90	pcs	34.50	2022-10-04 19:17:04.535236+00
1449	737	Notebook - Standard	5	10.43	pcs	52.15	2022-10-04 19:17:04.535236+00
1450	738	Stapler - Premium	5	23.74	pcs	118.70	2025-04-07 19:17:04.535236+00
1451	739	Conference Table - Basic	4	1975.79	pcs	7903.16	2022-10-28 19:17:04.535236+00
1452	739	Conference Table - Premium	5	1624.76	pcs	8123.80	2022-10-28 19:17:04.535236+00
1453	739	Conference Table - Standard	2	735.82	pcs	1471.64	2022-10-28 19:17:04.535236+00
1454	740	Sticky Notes - Premium	4	4.53	pack	18.12	2025-02-08 19:17:04.535236+00
1455	740	Sticky Notes - Premium	3	5.03	pack	15.09	2025-02-08 19:17:04.535236+00
1456	740	Sticky Notes - Standard	5	7.07	pack	35.35	2025-02-08 19:17:04.535236+00
1457	741	Keyboard - Premium	3	103.20	pcs	309.60	2023-09-07 19:17:04.535236+00
1458	741	Keyboard - Standard	2	63.86	pcs	127.72	2023-09-07 19:17:04.535236+00
1459	742	Printing Paper - Standard	3	5.83	box	17.49	2022-06-11 19:17:04.535236+00
1460	742	Printing Paper - Basic	1	10.19	box	10.19	2022-06-11 19:17:04.535236+00
1461	743	Desk - Basic	3	342.07	pcs	1026.21	2022-09-10 19:17:04.535236+00
1462	743	Desk - Basic	3	244.85	pcs	734.55	2022-09-10 19:17:04.535236+00
1463	744	Sticky Notes - Premium	5	5.59	pack	27.95	2023-03-27 19:17:04.535236+00
1464	745	Pen Set - Standard	2	15.66	set	31.32	2025-03-12 19:17:04.535236+00
1465	746	Sticky Notes - Basic	4	3.29	pack	13.16	2022-09-26 19:17:04.535236+00
1466	746	Sticky Notes - Premium	2	2.30	pack	4.60	2022-09-26 19:17:04.535236+00
1467	747	Headset - Standard	1	64.40	pcs	64.40	2025-03-17 19:17:04.535236+00
1468	748	Keyboard - Premium	3	78.87	pcs	236.61	2023-02-01 19:17:04.535236+00
1469	748	Keyboard - Basic	2	65.36	pcs	130.72	2023-02-01 19:17:04.535236+00
1470	749	Printing Paper - Premium	1	5.28	box	5.28	2025-05-18 19:17:04.535236+00
1471	749	Printing Paper - Premium	2	12.77	box	25.54	2025-05-18 19:17:04.535236+00
1472	750	Sticky Notes - Basic	2	4.48	pack	8.96	2022-11-13 19:17:04.535236+00
1473	751	Office Chair - Premium	3	270.33	pcs	810.99	2025-01-19 19:17:04.535236+00
1474	751	Office Chair - Standard	1	146.33	pcs	146.33	2025-01-19 19:17:04.535236+00
1475	751	Office Chair - Standard	5	289.37	pcs	1446.85	2025-01-19 19:17:04.535236+00
1476	752	Notebook - Standard	5	8.16	pcs	40.80	2024-10-16 19:17:04.535236+00
1477	752	Notebook - Standard	2	7.84	pcs	15.68	2024-10-16 19:17:04.535236+00
1478	753	Conference Table - Basic	5	1624.00	pcs	8120.00	2024-07-11 19:17:04.535236+00
1479	753	Conference Table - Standard	4	1003.87	pcs	4015.48	2024-07-11 19:17:04.535236+00
1480	753	Conference Table - Basic	4	1449.61	pcs	5798.44	2024-07-11 19:17:04.535236+00
1481	754	Mouse - Premium	5	40.79	pcs	203.95	2025-05-21 19:17:04.535236+00
1482	754	Mouse - Basic	4	41.03	pcs	164.12	2025-05-21 19:17:04.535236+00
1483	754	Mouse - Premium	4	24.76	pcs	99.04	2025-05-21 19:17:04.535236+00
1484	755	Printing Paper - Standard	2	8.53	box	17.06	2024-06-10 19:17:04.535236+00
1485	756	Stapler - Basic	4	14.80	pcs	59.20	2025-05-29 19:17:04.535236+00
1486	756	Stapler - Standard	1	12.59	pcs	12.59	2025-05-29 19:17:04.535236+00
1487	757	Filing Cabinet - Premium	2	245.92	pcs	491.84	2024-02-16 19:17:04.535236+00
1488	757	Filing Cabinet - Standard	5	329.85	pcs	1649.25	2024-02-16 19:17:04.535236+00
1489	757	Filing Cabinet - Standard	3	213.29	pcs	639.87	2024-02-16 19:17:04.535236+00
1490	758	Pen Set - Standard	3	14.09	set	42.27	2021-09-12 19:17:04.535236+00
1491	758	Pen Set - Basic	5	11.01	set	55.05	2021-09-12 19:17:04.535236+00
1492	758	Pen Set - Basic	5	11.22	set	56.10	2021-09-12 19:17:04.535236+00
1493	759	Monitor - Standard	5	256.52	pcs	1282.60	2023-10-28 19:17:04.535236+00
1494	760	Sticky Notes - Basic	3	3.21	pack	9.63	2025-05-11 19:17:04.535236+00
1495	761	Sticky Notes - Basic	4	7.19	pack	28.76	2024-05-14 19:17:04.535236+00
1496	761	Sticky Notes - Basic	2	3.48	pack	6.96	2024-05-14 19:17:04.535236+00
1497	761	Sticky Notes - Standard	1	6.58	pack	6.58	2024-05-14 19:17:04.535236+00
1498	762	Pen Set - Basic	2	18.65	set	37.30	2025-05-26 19:17:04.535236+00
1499	763	Mouse - Standard	3	28.84	pcs	86.52	2024-08-04 19:17:04.535236+00
1500	763	Mouse - Standard	2	48.73	pcs	97.46	2024-08-04 19:17:04.535236+00
1501	764	Notebook - Standard	2	3.67	pcs	7.34	2023-02-15 19:17:04.535236+00
1502	764	Notebook - Standard	2	4.31	pcs	8.62	2023-02-15 19:17:04.535236+00
1503	764	Notebook - Standard	5	3.43	pcs	17.15	2023-02-15 19:17:04.535236+00
1504	765	Mouse - Premium	5	42.73	pcs	213.65	2023-08-03 19:17:04.535236+00
1505	765	Mouse - Premium	4	43.58	pcs	174.32	2023-08-03 19:17:04.535236+00
1506	765	Mouse - Premium	1	47.48	pcs	47.48	2023-08-03 19:17:04.535236+00
1507	766	Pen Set - Standard	2	12.34	set	24.68	2023-08-31 19:17:04.535236+00
1508	766	Pen Set - Basic	4	11.35	set	45.40	2023-08-31 19:17:04.535236+00
1509	766	Pen Set - Standard	1	16.82	set	16.82	2023-08-31 19:17:04.535236+00
1510	767	Office Chair - Basic	2	253.48	pcs	506.96	2025-04-23 19:17:04.535236+00
1511	767	Office Chair - Standard	1	280.64	pcs	280.64	2025-04-23 19:17:04.535236+00
1512	767	Office Chair - Premium	3	299.68	pcs	899.04	2025-04-23 19:17:04.535236+00
1513	768	Mouse - Standard	4	49.49	pcs	197.96	2024-03-30 19:17:04.535236+00
1514	768	Mouse - Standard	5	29.47	pcs	147.35	2024-03-30 19:17:04.535236+00
1515	768	Mouse - Premium	1	19.59	pcs	19.59	2024-03-30 19:17:04.535236+00
1516	769	Keyboard - Basic	3	78.64	pcs	235.92	2023-01-17 19:17:04.535236+00
1517	770	Notebook - Standard	4	6.31	pcs	25.24	2025-05-11 19:17:04.535236+00
1518	770	Notebook - Standard	5	9.85	pcs	49.25	2025-05-11 19:17:04.535236+00
1519	771	Printing Paper - Basic	5	8.12	box	40.60	2021-08-19 19:17:04.535236+00
1520	771	Printing Paper - Premium	4	12.54	box	50.16	2021-08-19 19:17:04.535236+00
1521	771	Printing Paper - Premium	1	8.43	box	8.43	2021-08-19 19:17:04.535236+00
1522	772	Printing Paper - Basic	1	7.09	box	7.09	2024-08-11 19:17:04.535236+00
1523	772	Printing Paper - Standard	4	12.74	box	50.96	2024-08-11 19:17:04.535236+00
1524	772	Printing Paper - Standard	4	8.06	box	32.24	2024-08-11 19:17:04.535236+00
1525	773	Filing Cabinet - Basic	2	350.05	pcs	700.10	2024-10-24 19:17:04.535236+00
1526	774	Notebook - Basic	5	5.39	pcs	26.95	2023-02-09 19:17:04.535236+00
1527	774	Notebook - Basic	2	6.83	pcs	13.66	2023-02-09 19:17:04.535236+00
1528	775	Notebook - Basic	4	3.85	pcs	15.40	2022-03-25 19:17:04.535236+00
1529	776	Pen Set - Standard	2	11.65	set	23.30	2025-03-03 19:17:04.535236+00
1530	776	Pen Set - Basic	2	19.74	set	39.48	2025-03-03 19:17:04.535236+00
1531	776	Pen Set - Basic	5	14.95	set	74.75	2025-03-03 19:17:04.535236+00
1532	777	Bookshelf - Basic	1	229.35	pcs	229.35	2024-08-26 19:17:04.535236+00
1533	777	Bookshelf - Standard	2	233.30	pcs	466.60	2024-08-26 19:17:04.535236+00
1534	778	Mouse - Premium	2	42.63	pcs	85.26	2023-05-11 19:17:04.535236+00
1535	779	Mouse - Premium	4	23.03	pcs	92.12	2025-04-26 19:17:04.535236+00
1536	779	Mouse - Premium	3	27.87	pcs	83.61	2025-04-26 19:17:04.535236+00
1537	780	Keyboard - Premium	3	101.41	pcs	304.23	2024-08-25 19:17:04.535236+00
1538	780	Keyboard - Premium	2	55.59	pcs	111.18	2024-08-25 19:17:04.535236+00
1539	781	Laptop - Basic	4	536.33	pcs	2145.32	2025-03-16 19:17:04.535236+00
1540	781	Laptop - Standard	5	448.51	pcs	2242.55	2025-03-16 19:17:04.535236+00
1541	782	Conference Table - Standard	4	1769.14	pcs	7076.56	2022-11-07 19:17:04.535236+00
1542	782	Conference Table - Premium	2	1808.26	pcs	3616.52	2022-11-07 19:17:04.535236+00
1543	782	Conference Table - Premium	4	973.22	pcs	3892.88	2022-11-07 19:17:04.535236+00
1544	783	Notebook - Standard	4	3.22	pcs	12.88	2025-04-27 19:17:04.535236+00
1545	783	Notebook - Premium	4	5.24	pcs	20.96	2025-04-27 19:17:04.535236+00
1546	784	Stapler - Standard	1	12.89	pcs	12.89	2024-12-04 19:17:04.535236+00
1547	784	Stapler - Basic	4	11.40	pcs	45.60	2024-12-04 19:17:04.535236+00
1548	784	Stapler - Premium	2	22.12	pcs	44.24	2024-12-04 19:17:04.535236+00
1549	785	Stapler - Basic	5	10.94	pcs	54.70	2025-05-09 19:17:04.535236+00
1550	786	Monitor - Premium	2	306.51	pcs	613.02	2025-04-13 19:17:04.535236+00
1551	787	Printing Paper - Basic	2	12.61	box	25.22	2025-05-18 19:17:04.535236+00
1552	787	Printing Paper - Standard	4	11.99	box	47.96	2025-05-18 19:17:04.535236+00
1553	788	Office Chair - Premium	1	147.35	pcs	147.35	2025-04-17 19:17:04.535236+00
1554	789	Headset - Standard	5	122.07	pcs	610.35	2025-05-01 19:17:04.535236+00
1555	790	Pen Set - Basic	1	12.75	set	12.75	2025-03-19 19:17:04.535236+00
1556	790	Pen Set - Premium	3	13.46	set	40.38	2025-03-19 19:17:04.535236+00
1557	790	Pen Set - Basic	2	15.51	set	31.02	2025-03-19 19:17:04.535236+00
1558	791	Printing Paper - Basic	2	14.24	box	28.48	2024-04-23 19:17:04.535236+00
1559	792	Printing Paper - Premium	2	8.70	box	17.40	2025-03-30 19:17:04.535236+00
1560	793	Mouse - Basic	4	21.63	pcs	86.52	2025-05-20 19:17:04.535236+00
1561	793	Mouse - Basic	4	30.01	pcs	120.04	2025-05-20 19:17:04.535236+00
1562	794	Printing Paper - Premium	3	7.11	box	21.33	2025-05-24 19:17:04.535236+00
1563	795	Conference Table - Standard	5	1199.94	pcs	5999.70	2024-07-13 19:17:04.535236+00
1564	796	Headset - Basic	4	38.51	pcs	154.04	2024-07-23 19:17:04.535236+00
1565	796	Headset - Standard	1	77.41	pcs	77.41	2024-07-23 19:17:04.535236+00
1566	796	Headset - Basic	5	114.70	pcs	573.50	2024-07-23 19:17:04.535236+00
1567	797	Pen Set - Standard	1	17.72	set	17.72	2022-07-13 19:17:04.535236+00
1568	797	Pen Set - Premium	5	14.89	set	74.45	2022-07-13 19:17:04.535236+00
1569	798	Notebook - Premium	2	5.10	pcs	10.20	2023-04-08 19:17:04.535236+00
1570	798	Notebook - Basic	5	4.20	pcs	21.00	2023-04-08 19:17:04.535236+00
1571	799	Stapler - Basic	4	18.14	pcs	72.56	2023-12-23 19:17:04.535236+00
1572	799	Stapler - Premium	1	23.71	pcs	23.71	2023-12-23 19:17:04.535236+00
1573	799	Stapler - Standard	2	14.91	pcs	29.82	2023-12-23 19:17:04.535236+00
1574	800	Pen Set - Standard	3	16.77	set	50.31	2022-06-06 19:17:04.535236+00
1575	800	Pen Set - Standard	4	14.66	set	58.64	2022-06-06 19:17:04.535236+00
1576	800	Pen Set - Basic	2	11.75	set	23.50	2022-06-06 19:17:04.535236+00
1577	801	Sticky Notes - Basic	4	2.72	pack	10.88	2024-10-31 19:17:04.535236+00
1578	801	Sticky Notes - Premium	5	6.62	pack	33.10	2024-10-31 19:17:04.535236+00
1579	801	Sticky Notes - Premium	1	2.33	pack	2.33	2024-10-31 19:17:04.535236+00
1580	802	Bookshelf - Standard	4	170.20	pcs	680.80	2022-12-27 19:17:04.535236+00
1581	802	Bookshelf - Basic	4	217.37	pcs	869.48	2022-12-27 19:17:04.535236+00
1582	802	Bookshelf - Premium	4	123.23	pcs	492.92	2022-12-27 19:17:04.535236+00
1583	803	Pen Set - Standard	4	19.25	set	77.00	2023-05-03 19:17:04.535236+00
1584	804	Pen Set - Premium	5	16.23	set	81.15	2024-11-26 19:17:04.535236+00
1585	804	Pen Set - Standard	1	11.61	set	11.61	2024-11-26 19:17:04.535236+00
1586	805	Conference Table - Basic	5	1698.87	pcs	8494.35	2025-02-21 19:17:04.535236+00
1587	805	Conference Table - Basic	3	788.69	pcs	2366.07	2025-02-21 19:17:04.535236+00
1588	805	Conference Table - Basic	1	1379.10	pcs	1379.10	2025-02-21 19:17:04.535236+00
1589	806	Filing Cabinet - Premium	3	209.07	pcs	627.21	2023-05-17 19:17:04.535236+00
1590	806	Filing Cabinet - Premium	5	287.53	pcs	1437.65	2023-05-17 19:17:04.535236+00
1591	807	Pen Set - Premium	5	18.28	set	91.40	2025-03-01 19:17:04.535236+00
1592	807	Pen Set - Standard	5	16.26	set	81.30	2025-03-01 19:17:04.535236+00
1593	807	Pen Set - Standard	1	8.92	set	8.92	2025-03-01 19:17:04.535236+00
1594	808	Headset - Premium	4	154.32	pcs	617.28	2025-04-29 19:17:04.535236+00
1595	808	Headset - Premium	3	94.60	pcs	283.80	2025-04-29 19:17:04.535236+00
1596	809	Conference Table - Premium	5	676.99	pcs	3384.95	2024-06-27 19:17:04.535236+00
1597	809	Conference Table - Premium	4	1899.16	pcs	7596.64	2024-06-27 19:17:04.535236+00
1598	809	Conference Table - Basic	5	1542.67	pcs	7713.35	2024-06-27 19:17:04.535236+00
1599	810	Notebook - Standard	5	4.43	pcs	22.15	2023-08-02 19:17:04.535236+00
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: company_user
--

COPY public.purchase_orders (id, purchase_request_id, supplier_id, order_number, order_date, expected_delivery_date, actual_delivery_date, total_amount, currency, status, payment_status, notes, created_at, updated_at) FROM stdin;
1	1	3	PO-2023-001	2023-04-16 19:17:04.535236+00	2023-04-23 19:17:04.535236+00	2023-04-23 19:17:04.535236+00	9.86	USD	Delivered	Pending	Order for Request for Stapler	2023-04-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
2	3	3	PO-2024-002	2024-12-04 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	2024-12-10 19:17:04.535236+00	1710.36	USD	Delivered	Pending	Order for Request for Filing Cabinet	2024-12-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
3	4	1	PO-2025-003	2025-04-22 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	65.18	USD	Delivered	Pending	Order for Request for Pen Set	2025-04-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
4	5	2	PO-2024-004	2024-11-16 19:17:04.535236+00	2024-11-21 19:17:04.535236+00	\N	2345.54	USD	Cancelled	Cancelled	Order for Request for Filing Cabinet	2024-11-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
5	6	1	PO-2024-005	2024-09-17 19:17:04.535236+00	2024-09-20 19:17:04.535236+00	2024-09-19 19:17:04.535236+00	67.51	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-09-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
6	8	4	PO-2024-006	2024-07-29 19:17:04.535236+00	2024-08-02 19:17:04.535236+00	2024-08-04 19:17:04.535236+00	41.56	USD	Delivered	Paid	Order for Request for Notebook	2024-07-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
7	9	5	PO-2023-007	2023-03-02 19:17:04.535236+00	2023-03-04 19:17:04.535236+00	2023-03-05 19:17:04.535236+00	804.40	USD	Delivered	Paid	Order for Request for Headset	2023-03-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
8	10	5	PO-2025-008	2025-04-20 19:17:04.535236+00	2025-04-22 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	1850.80	USD	Delivered	Paid	Order for Request for Desk	2025-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
9	11	1	PO-2023-009	2023-06-22 19:17:04.535236+00	2023-06-25 19:17:04.535236+00	2023-06-27 19:17:04.535236+00	87.47	USD	Delivered	Pending	Order for Request for Headset	2023-06-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
10	12	2	PO-2025-010	2025-02-05 19:17:04.535236+00	2025-02-10 19:17:04.535236+00	\N	63.93	USD	Shipped	Pending	Order for Request for Stapler	2025-02-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
11	13	4	PO-2024-011	2024-09-03 19:17:04.535236+00	2024-09-07 19:17:04.535236+00	2024-09-07 19:17:04.535236+00	17.03	USD	Delivered	Pending	Order for Request for Notebook	2024-09-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
12	14	3	PO-2023-012	2023-11-21 19:17:04.535236+00	2023-11-28 19:17:04.535236+00	2023-11-29 19:17:04.535236+00	3357.48	USD	Delivered	Paid	Order for Request for Conference Table	2023-11-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
13	15	5	PO-2025-013	2025-05-18 19:17:04.535236+00	2025-05-20 19:17:04.535236+00	\N	1109.13	USD	Cancelled	Cancelled	Order for Request for Bookshelf	2025-05-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
14	16	3	PO-2025-014	2025-01-27 19:17:04.535236+00	2025-02-03 19:17:04.535236+00	2025-02-03 19:17:04.535236+00	33.91	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-01-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
15	17	5	PO-2024-015	2024-06-01 19:17:04.535236+00	2024-06-03 19:17:04.535236+00	2024-06-01 19:17:04.535236+00	3467.08	USD	Delivered	Pending	Order for Request for Keyboard	2024-06-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
16	18	4	PO-2024-016	2024-12-07 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	2024-12-12 19:17:04.535236+00	10.81	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-12-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
17	20	3	PO-2025-017	2025-04-08 19:17:04.535236+00	2025-04-15 19:17:04.535236+00	2025-04-13 19:17:04.535236+00	113.57	USD	Delivered	Pending	Order for Request for Stapler	2025-04-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
18	21	5	PO-2024-018	2024-05-05 19:17:04.535236+00	2024-05-07 19:17:04.535236+00	\N	78.28	USD	Ordered	Pending	Order for Request for Stapler	2024-05-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
19	22	5	PO-2023-019	2023-06-02 19:17:04.535236+00	2023-06-04 19:17:04.535236+00	2023-06-04 19:17:04.535236+00	4685.84	USD	Delivered	Paid	Order for Request for Mouse	2023-06-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
20	24	5	PO-2024-020	2024-12-30 19:17:04.535236+00	2025-01-01 19:17:04.535236+00	\N	4968.26	USD	Shipped	Pending	Order for Request for Headset	2024-12-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
21	25	2	PO-2024-021	2024-06-10 19:17:04.535236+00	2024-06-15 19:17:04.535236+00	2024-06-13 19:17:04.535236+00	236.65	USD	Delivered	Paid	Order for Request for Keyboard	2024-06-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
22	26	5	PO-2020-022	2020-09-02 19:17:04.535236+00	2020-09-04 19:17:04.535236+00	2020-09-04 19:17:04.535236+00	54.18	USD	Delivered	Pending	Order for Request for Printing Paper	2020-09-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
23	27	5	PO-2024-023	2024-08-08 19:17:04.535236+00	2024-08-10 19:17:04.535236+00	\N	24.93	USD	Ordered	Pending	Order for Request for Sticky Notes	2024-08-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
24	28	1	PO-2025-024	2025-03-15 19:17:04.535236+00	2025-03-18 19:17:04.535236+00	\N	38.49	USD	Shipped	Pending	Order for Request for Notebook	2025-03-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
25	29	1	PO-2024-025	2024-03-10 19:17:04.535236+00	2024-03-13 19:17:04.535236+00	\N	2868.68	USD	Ordered	Pending	Order for Request for Office Chair	2024-03-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
26	30	1	PO-2023-026	2023-09-10 19:17:04.535236+00	2023-09-13 19:17:04.535236+00	2023-09-14 19:17:04.535236+00	12.18	USD	Delivered	Paid	Order for Request for Notebook	2023-09-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
27	31	2	PO-2024-027	2024-12-12 19:17:04.535236+00	2024-12-17 19:17:04.535236+00	2024-12-18 19:17:04.535236+00	90.97	USD	Delivered	Paid	Order for Request for Keyboard	2024-12-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
28	32	4	PO-2023-028	2023-07-31 19:17:04.535236+00	2023-08-04 19:17:04.535236+00	2023-08-02 19:17:04.535236+00	16.72	USD	Delivered	Paid	Order for Request for Notebook	2023-07-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
29	33	3	PO-2024-029	2024-12-14 19:17:04.535236+00	2024-12-21 19:17:04.535236+00	\N	31.09	USD	Ordered	Pending	Order for Request for Sticky Notes	2024-12-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
30	34	3	PO-2024-030	2024-02-19 19:17:04.535236+00	2024-02-26 19:17:04.535236+00	2024-02-26 19:17:04.535236+00	65.00	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-02-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
31	36	3	PO-2025-031	2025-01-08 19:17:04.535236+00	2025-01-15 19:17:04.535236+00	\N	58.12	USD	Ordered	Pending	Order for Request for Pen Set	2025-01-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
32	37	3	PO-2025-032	2025-05-07 19:17:04.535236+00	2025-05-14 19:17:04.535236+00	2025-05-16 19:17:04.535236+00	73.41	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-05-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
33	38	1	PO-2025-033	2025-05-03 19:17:04.535236+00	2025-05-06 19:17:04.535236+00	2025-05-06 19:17:04.535236+00	35.04	USD	Delivered	Pending	Order for Request for Pen Set	2025-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
34	39	5	PO-2024-034	2024-10-10 19:17:04.535236+00	2024-10-12 19:17:04.535236+00	\N	85.10	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-10-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
35	40	5	PO-2023-035	2023-09-19 19:17:04.535236+00	2023-09-21 19:17:04.535236+00	2023-09-23 19:17:04.535236+00	1683.37	USD	Delivered	Paid	Order for Request for Office Chair	2023-09-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
36	41	5	PO-2025-036	2025-05-14 19:17:04.535236+00	2025-05-16 19:17:04.535236+00	\N	130.30	USD	Cancelled	Cancelled	Order for Request for Stapler	2025-05-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
37	42	5	PO-2024-037	2024-11-04 19:17:04.535236+00	2024-11-06 19:17:04.535236+00	2024-11-05 19:17:04.535236+00	95.51	USD	Delivered	Pending	Order for Request for Pen Set	2024-11-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
38	43	5	PO-2023-038	2023-12-10 19:17:04.535236+00	2023-12-12 19:17:04.535236+00	2023-12-14 19:17:04.535236+00	143.14	USD	Delivered	Paid	Order for Request for Notebook	2023-12-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
39	44	4	PO-2023-039	2023-11-15 19:17:04.535236+00	2023-11-19 19:17:04.535236+00	2023-11-20 19:17:04.535236+00	168.14	USD	Delivered	Paid	Order for Request for Printing Paper	2023-11-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
40	45	4	PO-2023-040	2023-07-10 19:17:04.535236+00	2023-07-14 19:17:04.535236+00	\N	85.42	USD	Cancelled	Cancelled	Order for Request for Keyboard	2023-07-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
41	46	3	PO-2023-041	2023-08-01 19:17:04.535236+00	2023-08-08 19:17:04.535236+00	2023-08-07 19:17:04.535236+00	1886.36	USD	Delivered	Pending	Order for Request for Monitor	2023-08-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
42	47	2	PO-2023-042	2023-04-28 19:17:04.535236+00	2023-05-03 19:17:04.535236+00	2023-05-02 19:17:04.535236+00	99.53	USD	Delivered	Pending	Order for Request for Printing Paper	2023-04-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
43	48	5	PO-2024-043	2024-12-08 19:17:04.535236+00	2024-12-10 19:17:04.535236+00	2024-12-12 19:17:04.535236+00	53.10	USD	Delivered	Paid	Order for Request for Stapler	2024-12-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
44	49	1	PO-2024-044	2024-12-30 19:17:04.535236+00	2025-01-02 19:17:04.535236+00	\N	7.63	USD	Cancelled	Cancelled	Order for Request for Pen Set	2024-12-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
45	50	1	PO-2025-045	2025-02-28 19:17:04.535236+00	2025-03-03 19:17:04.535236+00	\N	42.31	USD	Shipped	Pending	Order for Request for Stapler	2025-02-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
46	51	5	PO-2024-046	2024-10-09 19:17:04.535236+00	2024-10-11 19:17:04.535236+00	\N	130.21	USD	Cancelled	Cancelled	Order for Request for Stapler	2024-10-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
47	52	3	PO-2024-047	2024-01-18 19:17:04.535236+00	2024-01-25 19:17:04.535236+00	2024-01-24 19:17:04.535236+00	205.72	USD	Delivered	Paid	Order for Request for Bookshelf	2024-01-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
48	53	3	PO-2025-048	2025-05-08 19:17:04.535236+00	2025-05-15 19:17:04.535236+00	2025-05-14 19:17:04.535236+00	60.06	USD	Delivered	Paid	Order for Request for Printing Paper	2025-05-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
49	54	3	PO-2025-049	2025-03-18 19:17:04.535236+00	2025-03-25 19:17:04.535236+00	\N	7195.58	USD	Shipped	Pending	Order for Request for Keyboard	2025-03-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
50	55	2	PO-2023-050	2023-10-27 19:17:04.535236+00	2023-11-01 19:17:04.535236+00	2023-10-30 19:17:04.535236+00	55.20	USD	Delivered	Pending	Order for Request for Pen Set	2023-10-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
51	56	3	PO-2023-051	2023-09-11 19:17:04.535236+00	2023-09-18 19:17:04.535236+00	\N	60.71	USD	Ordered	Pending	Order for Request for Printing Paper	2023-09-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
52	57	2	PO-2024-052	2024-12-30 19:17:04.535236+00	2025-01-04 19:17:04.535236+00	\N	52.72	USD	Shipped	Pending	Order for Request for Notebook	2024-12-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
53	59	3	PO-2023-053	2023-01-30 19:17:04.535236+00	2023-02-06 19:17:04.535236+00	2023-02-07 19:17:04.535236+00	30.64	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-01-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
54	60	2	PO-2022-054	2022-01-09 19:17:04.535236+00	2022-01-14 19:17:04.535236+00	\N	910.40	USD	Cancelled	Cancelled	Order for Request for Bookshelf	2022-01-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
55	61	1	PO-2023-055	2023-09-08 19:17:04.535236+00	2023-09-11 19:17:04.535236+00	\N	1111.45	USD	Shipped	Pending	Order for Request for Desk	2023-09-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
56	62	3	PO-2024-056	2024-11-19 19:17:04.535236+00	2024-11-26 19:17:04.535236+00	\N	53.10	USD	Ordered	Pending	Order for Request for Notebook	2024-11-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
57	63	1	PO-2022-057	2022-08-22 19:17:04.535236+00	2022-08-25 19:17:04.535236+00	2022-08-27 19:17:04.535236+00	235.12	USD	Delivered	Paid	Order for Request for Laptop	2022-08-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
58	64	5	PO-2021-058	2021-02-05 19:17:04.535236+00	2021-02-07 19:17:04.535236+00	2021-02-09 19:17:04.535236+00	62.12	USD	Delivered	Pending	Order for Request for Printing Paper	2021-02-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
59	65	2	PO-2023-059	2023-09-26 19:17:04.535236+00	2023-10-01 19:17:04.535236+00	2023-09-30 19:17:04.535236+00	1627.15	USD	Delivered	Paid	Order for Request for Desk	2023-09-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
60	66	3	PO-2025-060	2025-04-19 19:17:04.535236+00	2025-04-26 19:17:04.535236+00	2025-04-27 19:17:04.535236+00	17.53	USD	Delivered	Pending	Order for Request for Stapler	2025-04-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
61	67	2	PO-2023-061	2023-10-13 19:17:04.535236+00	2023-10-18 19:17:04.535236+00	2023-10-18 19:17:04.535236+00	85.70	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-10-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
62	68	4	PO-2025-062	2025-05-29 19:17:04.535236+00	2025-06-02 19:17:04.535236+00	2025-05-31 19:17:04.535236+00	67.91	USD	Delivered	Paid	Order for Request for Stapler	2025-05-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
63	69	1	PO-2024-063	2024-10-01 19:17:04.535236+00	2024-10-04 19:17:04.535236+00	2024-10-06 19:17:04.535236+00	93.62	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-10-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
64	70	3	PO-2025-064	2025-05-05 19:17:04.535236+00	2025-05-12 19:17:04.535236+00	\N	3111.93	USD	Shipped	Pending	Order for Request for Monitor	2025-05-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
65	71	1	PO-2023-065	2023-07-11 19:17:04.535236+00	2023-07-14 19:17:04.535236+00	2023-07-15 19:17:04.535236+00	18.66	USD	Delivered	Pending	Order for Request for Notebook	2023-07-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
66	72	4	PO-2024-066	2024-11-29 19:17:04.535236+00	2024-12-03 19:17:04.535236+00	2024-12-02 19:17:04.535236+00	10.77	USD	Delivered	Paid	Order for Request for Pen Set	2024-11-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
67	74	3	PO-2022-067	2022-09-13 19:17:04.535236+00	2022-09-20 19:17:04.535236+00	2022-09-18 19:17:04.535236+00	16.02	USD	Delivered	Paid	Order for Request for Notebook	2022-09-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
68	75	5	PO-2022-068	2022-03-23 19:17:04.535236+00	2022-03-25 19:17:04.535236+00	2022-03-23 19:17:04.535236+00	1802.94	USD	Delivered	Paid	Order for Request for Bookshelf	2022-03-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
69	76	2	PO-2024-069	2024-04-07 19:17:04.535236+00	2024-04-12 19:17:04.535236+00	\N	5729.58	USD	Ordered	Pending	Order for Request for Conference Table	2024-04-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
70	78	5	PO-2025-070	2025-02-23 19:17:04.535236+00	2025-02-25 19:17:04.535236+00	2025-02-26 19:17:04.535236+00	38.53	USD	Delivered	Paid	Order for Request for Printing Paper	2025-02-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
71	79	3	PO-2024-071	2024-01-10 19:17:04.535236+00	2024-01-17 19:17:04.535236+00	2024-01-19 19:17:04.535236+00	37.20	USD	Delivered	Pending	Order for Request for Stapler	2024-01-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
72	81	3	PO-2024-072	2024-07-06 19:17:04.535236+00	2024-07-13 19:17:04.535236+00	2024-07-11 19:17:04.535236+00	34.45	USD	Delivered	Pending	Order for Request for Stapler	2024-07-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
73	83	5	PO-2024-073	2024-03-22 19:17:04.535236+00	2024-03-24 19:17:04.535236+00	\N	48.33	USD	Shipped	Pending	Order for Request for Stapler	2024-03-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
74	84	1	PO-2023-074	2023-01-22 19:17:04.535236+00	2023-01-25 19:17:04.535236+00	2023-01-23 19:17:04.535236+00	125.12	USD	Delivered	Paid	Order for Request for Laptop	2023-01-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
75	85	5	PO-2025-075	2025-05-10 19:17:04.535236+00	2025-05-12 19:17:04.535236+00	2025-05-12 19:17:04.535236+00	6524.79	USD	Delivered	Pending	Order for Request for Laptop	2025-05-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
76	86	2	PO-2025-076	2025-02-08 19:17:04.535236+00	2025-02-13 19:17:04.535236+00	2025-02-15 19:17:04.535236+00	24.63	USD	Delivered	Pending	Order for Request for Printing Paper	2025-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
77	87	4	PO-2024-077	2024-05-07 19:17:04.535236+00	2024-05-11 19:17:04.535236+00	2024-05-10 19:17:04.535236+00	10.23	USD	Delivered	Paid	Order for Request for Notebook	2024-05-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
78	88	1	PO-2021-078	2021-11-05 19:17:04.535236+00	2021-11-08 19:17:04.535236+00	\N	234.17	USD	Cancelled	Cancelled	Order for Request for Bookshelf	2021-11-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
79	89	4	PO-2024-079	2024-07-27 19:17:04.535236+00	2024-07-31 19:17:04.535236+00	2024-08-02 19:17:04.535236+00	50.14	USD	Delivered	Paid	Order for Request for Pen Set	2024-07-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
80	90	5	PO-2023-080	2023-12-28 19:17:04.535236+00	2023-12-30 19:17:04.535236+00	2023-12-28 19:17:04.535236+00	78.36	USD	Delivered	Paid	Order for Request for Pen Set	2023-12-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
81	91	2	PO-2023-081	2023-11-22 19:17:04.535236+00	2023-11-27 19:17:04.535236+00	2023-11-29 19:17:04.535236+00	3008.57	USD	Delivered	Paid	Order for Request for Office Chair	2023-11-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
82	93	1	PO-2024-082	2024-06-03 19:17:04.535236+00	2024-06-06 19:17:04.535236+00	2024-06-08 19:17:04.535236+00	3.67	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-06-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
83	95	2	PO-2025-083	2025-05-19 19:17:04.535236+00	2025-05-24 19:17:04.535236+00	2025-05-24 19:17:04.535236+00	92.68	USD	Delivered	Pending	Order for Request for Notebook	2025-05-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
84	96	2	PO-2024-084	2024-12-10 19:17:04.535236+00	2024-12-15 19:17:04.535236+00	2024-12-14 19:17:04.535236+00	191.61	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-12-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
85	97	4	PO-2024-085	2024-07-12 19:17:04.535236+00	2024-07-16 19:17:04.535236+00	\N	344.14	USD	Shipped	Pending	Order for Request for Headset	2024-07-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
86	99	2	PO-2025-086	2025-01-20 19:17:04.535236+00	2025-01-25 19:17:04.535236+00	2025-01-26 19:17:04.535236+00	1737.48	USD	Delivered	Paid	Order for Request for Bookshelf	2025-01-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
87	100	3	PO-2024-087	2024-11-12 19:17:04.535236+00	2024-11-19 19:17:04.535236+00	2024-11-20 19:17:04.535236+00	92.25	USD	Delivered	Paid	Order for Request for Stapler	2024-11-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
88	101	4	PO-2025-088	2025-04-17 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	106.59	USD	Delivered	Paid	Order for Request for Notebook	2025-04-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
89	104	4	PO-2023-089	2023-12-06 19:17:04.535236+00	2023-12-10 19:17:04.535236+00	\N	2337.47	USD	Shipped	Pending	Order for Request for Headset	2023-12-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
90	105	2	PO-2024-090	2024-04-15 19:17:04.535236+00	2024-04-20 19:17:04.535236+00	2024-04-19 19:17:04.535236+00	986.35	USD	Delivered	Pending	Order for Request for Bookshelf	2024-04-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
91	106	5	PO-2023-091	2023-06-03 19:17:04.535236+00	2023-06-05 19:17:04.535236+00	2023-06-03 19:17:04.535236+00	38.44	USD	Delivered	Paid	Order for Request for Stapler	2023-06-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
92	108	2	PO-2023-092	2023-12-08 19:17:04.535236+00	2023-12-13 19:17:04.535236+00	\N	204.65	USD	Ordered	Pending	Order for Request for Keyboard	2023-12-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
93	109	1	PO-2025-093	2025-02-09 19:17:04.535236+00	2025-02-12 19:17:04.535236+00	2025-02-12 19:17:04.535236+00	1562.99	USD	Delivered	Pending	Order for Request for Conference Table	2025-02-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
94	110	4	PO-2022-094	2022-12-25 19:17:04.535236+00	2022-12-29 19:17:04.535236+00	\N	3915.28	USD	Cancelled	Cancelled	Order for Request for Office Chair	2022-12-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
95	111	3	PO-2024-095	2024-02-02 19:17:04.535236+00	2024-02-09 19:17:04.535236+00	2024-02-11 19:17:04.535236+00	79.14	USD	Delivered	Pending	Order for Request for Notebook	2024-02-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
96	113	3	PO-2025-096	2025-03-14 19:17:04.535236+00	2025-03-21 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	217.48	USD	Delivered	Pending	Order for Request for Stapler	2025-03-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
97	114	4	PO-2024-097	2024-12-03 19:17:04.535236+00	2024-12-07 19:17:04.535236+00	\N	15.10	USD	Ordered	Pending	Order for Request for Notebook	2024-12-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
98	115	1	PO-2022-098	2022-11-29 19:17:04.535236+00	2022-12-02 19:17:04.535236+00	\N	86.65	USD	Ordered	Pending	Order for Request for Notebook	2022-11-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
99	116	5	PO-2025-099	2025-03-14 19:17:04.535236+00	2025-03-16 19:17:04.535236+00	2025-03-18 19:17:04.535236+00	4113.50	USD	Delivered	Paid	Order for Request for Desk	2025-03-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
100	117	4	PO-2024-100	2024-12-28 19:17:04.535236+00	2025-01-01 19:17:04.535236+00	\N	780.84	USD	Cancelled	Cancelled	Order for Request for Bookshelf	2024-12-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
101	118	1	PO-2022-101	2022-09-11 19:17:04.535236+00	2022-09-14 19:17:04.535236+00	\N	15.44	USD	Cancelled	Cancelled	Order for Request for Printing Paper	2022-09-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
102	119	3	PO-2023-102	2023-06-05 19:17:04.535236+00	2023-06-12 19:17:04.535236+00	2023-06-13 19:17:04.535236+00	591.75	USD	Delivered	Paid	Order for Request for Bookshelf	2023-06-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
103	120	4	PO-2024-103	2024-04-20 19:17:04.535236+00	2024-04-24 19:17:04.535236+00	2024-04-22 19:17:04.535236+00	92.77	USD	Delivered	Pending	Order for Request for Notebook	2024-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
104	121	4	PO-2023-104	2023-07-13 19:17:04.535236+00	2023-07-17 19:17:04.535236+00	2023-07-18 19:17:04.535236+00	288.10	USD	Delivered	Paid	Order for Request for Monitor	2023-07-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
105	122	2	PO-2025-105	2025-03-18 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	54.02	USD	Delivered	Pending	Order for Request for Pen Set	2025-03-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
106	124	3	PO-2025-106	2025-02-27 19:17:04.535236+00	2025-03-06 19:17:04.535236+00	\N	94.92	USD	Ordered	Pending	Order for Request for Printing Paper	2025-02-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
107	125	4	PO-2020-107	2020-12-11 19:17:04.535236+00	2020-12-15 19:17:04.535236+00	2020-12-17 19:17:04.535236+00	32.35	USD	Delivered	Pending	Order for Request for Pen Set	2020-12-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
108	126	1	PO-2022-108	2022-07-01 19:17:04.535236+00	2022-07-04 19:17:04.535236+00	\N	6.24	USD	Cancelled	Cancelled	Order for Request for Pen Set	2022-07-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
109	127	4	PO-2024-109	2024-05-09 19:17:04.535236+00	2024-05-13 19:17:04.535236+00	2024-05-11 19:17:04.535236+00	1689.79	USD	Delivered	Paid	Order for Request for Monitor	2024-05-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
110	129	4	PO-2021-110	2021-02-12 19:17:04.535236+00	2021-02-16 19:17:04.535236+00	2021-02-18 19:17:04.535236+00	3386.41	USD	Delivered	Pending	Order for Request for Filing Cabinet	2021-02-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
111	130	4	PO-2024-111	2024-09-14 19:17:04.535236+00	2024-09-18 19:17:04.535236+00	2024-09-17 19:17:04.535236+00	18243.10	USD	Delivered	Pending	Order for Request for Desk	2024-09-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
112	131	4	PO-2025-112	2025-04-13 19:17:04.535236+00	2025-04-17 19:17:04.535236+00	2025-04-15 19:17:04.535236+00	91.92	USD	Delivered	Paid	Order for Request for Pen Set	2025-04-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
113	132	4	PO-2023-113	2023-06-16 19:17:04.535236+00	2023-06-20 19:17:04.535236+00	\N	118.37	USD	Shipped	Pending	Order for Request for Laptop	2023-06-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
114	133	1	PO-2024-114	2024-03-16 19:17:04.535236+00	2024-03-19 19:17:04.535236+00	2024-03-17 19:17:04.535236+00	234.45	USD	Delivered	Pending	Order for Request for Mouse	2024-03-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
115	134	1	PO-2025-115	2025-02-17 19:17:04.535236+00	2025-02-20 19:17:04.535236+00	2025-02-19 19:17:04.535236+00	121.63	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-02-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
116	135	2	PO-2023-116	2023-06-30 19:17:04.535236+00	2023-07-05 19:17:04.535236+00	2023-07-05 19:17:04.535236+00	2479.10	USD	Delivered	Paid	Order for Request for Filing Cabinet	2023-06-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
117	136	5	PO-2025-117	2025-05-30 19:17:04.535236+00	2025-06-01 19:17:04.535236+00	\N	384.97	USD	Ordered	Pending	Order for Request for Headset	2025-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
118	137	4	PO-2025-118	2025-04-29 19:17:04.535236+00	2025-05-03 19:17:04.535236+00	2025-05-04 19:17:04.535236+00	492.41	USD	Delivered	Paid	Order for Request for Keyboard	2025-04-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
119	138	1	PO-2024-119	2024-02-06 19:17:04.535236+00	2024-02-09 19:17:04.535236+00	\N	27.75	USD	Shipped	Pending	Order for Request for Stapler	2024-02-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
120	140	1	PO-2025-120	2025-04-30 19:17:04.535236+00	2025-05-03 19:17:04.535236+00	2025-05-04 19:17:04.535236+00	1007.23	USD	Delivered	Pending	Order for Request for Mouse	2025-04-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
121	141	1	PO-2024-121	2024-11-01 19:17:04.535236+00	2024-11-04 19:17:04.535236+00	\N	1646.10	USD	Shipped	Pending	Order for Request for Bookshelf	2024-11-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
122	142	5	PO-2024-122	2024-09-22 19:17:04.535236+00	2024-09-24 19:17:04.535236+00	2024-09-23 19:17:04.535236+00	907.24	USD	Delivered	Pending	Order for Request for Conference Table	2024-09-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
123	143	4	PO-2022-123	2022-01-04 19:17:04.535236+00	2022-01-08 19:17:04.535236+00	2022-01-09 19:17:04.535236+00	3492.29	USD	Delivered	Paid	Order for Request for Filing Cabinet	2022-01-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
124	144	1	PO-2021-124	2021-08-29 19:17:04.535236+00	2021-09-01 19:17:04.535236+00	\N	7353.23	USD	Shipped	Pending	Order for Request for Filing Cabinet	2021-08-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
125	145	2	PO-2025-125	2025-03-08 19:17:04.535236+00	2025-03-13 19:17:04.535236+00	2025-03-13 19:17:04.535236+00	43.41	USD	Delivered	Paid	Order for Request for Pen Set	2025-03-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
126	146	2	PO-2021-126	2021-10-24 19:17:04.535236+00	2021-10-29 19:17:04.535236+00	2021-10-29 19:17:04.535236+00	16.44	USD	Delivered	Paid	Order for Request for Sticky Notes	2021-10-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
127	147	2	PO-2024-127	2024-11-05 19:17:04.535236+00	2024-11-10 19:17:04.535236+00	2024-11-08 19:17:04.535236+00	13.24	USD	Delivered	Paid	Order for Request for Notebook	2024-11-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
128	148	3	PO-2025-128	2025-05-30 19:17:04.535236+00	2025-06-06 19:17:04.535236+00	\N	6853.69	USD	Ordered	Pending	Order for Request for Bookshelf	2025-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
129	149	1	PO-2024-129	2024-01-13 19:17:04.535236+00	2024-01-16 19:17:04.535236+00	\N	10.97	USD	Ordered	Pending	Order for Request for Notebook	2024-01-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
130	150	3	PO-2023-130	2023-12-03 19:17:04.535236+00	2023-12-10 19:17:04.535236+00	\N	1451.70	USD	Ordered	Pending	Order for Request for Conference Table	2023-12-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
131	151	3	PO-2024-131	2024-06-18 19:17:04.535236+00	2024-06-25 19:17:04.535236+00	\N	93.84	USD	Cancelled	Cancelled	Order for Request for Pen Set	2024-06-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
132	152	3	PO-2024-132	2024-12-14 19:17:04.535236+00	2024-12-21 19:17:04.535236+00	2024-12-20 19:17:04.535236+00	319.96	USD	Delivered	Pending	Order for Request for Laptop	2024-12-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
133	154	2	PO-2023-133	2023-10-13 19:17:04.535236+00	2023-10-18 19:17:04.535236+00	2023-10-20 19:17:04.535236+00	230.52	USD	Delivered	Paid	Order for Request for Keyboard	2023-10-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
134	155	2	PO-2024-134	2024-11-05 19:17:04.535236+00	2024-11-10 19:17:04.535236+00	\N	8453.80	USD	Cancelled	Cancelled	Order for Request for Desk	2024-11-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
135	157	5	PO-2024-135	2024-05-18 19:17:04.535236+00	2024-05-20 19:17:04.535236+00	\N	171.86	USD	Shipped	Pending	Order for Request for Pen Set	2024-05-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
136	158	3	PO-2024-136	2024-12-02 19:17:04.535236+00	2024-12-09 19:17:04.535236+00	2024-12-07 19:17:04.535236+00	9.61	USD	Delivered	Pending	Order for Request for Pen Set	2024-12-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
137	159	1	PO-2025-137	2025-01-14 19:17:04.535236+00	2025-01-17 19:17:04.535236+00	2025-01-15 19:17:04.535236+00	54.94	USD	Delivered	Paid	Order for Request for Printing Paper	2025-01-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
138	160	5	PO-2025-138	2025-03-12 19:17:04.535236+00	2025-03-14 19:17:04.535236+00	\N	28.32	USD	Shipped	Pending	Order for Request for Sticky Notes	2025-03-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
139	161	2	PO-2024-139	2024-08-18 19:17:04.535236+00	2024-08-23 19:17:04.535236+00	2024-08-22 19:17:04.535236+00	22.95	USD	Delivered	Pending	Order for Request for Notebook	2024-08-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
140	162	5	PO-2025-140	2025-03-21 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	\N	1865.72	USD	Ordered	Pending	Order for Request for Conference Table	2025-03-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
141	163	1	PO-2023-141	2023-10-01 19:17:04.535236+00	2023-10-04 19:17:04.535236+00	2023-10-03 19:17:04.535236+00	4339.48	USD	Delivered	Pending	Order for Request for Laptop	2023-10-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
142	164	4	PO-2021-142	2021-08-28 19:17:04.535236+00	2021-09-01 19:17:04.535236+00	\N	36.20	USD	Shipped	Pending	Order for Request for Pen Set	2021-08-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
143	165	3	PO-2023-143	2023-10-25 19:17:04.535236+00	2023-11-01 19:17:04.535236+00	2023-10-30 19:17:04.535236+00	31.80	USD	Delivered	Pending	Order for Request for Pen Set	2023-10-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
144	167	4	PO-2023-144	2023-09-03 19:17:04.535236+00	2023-09-07 19:17:04.535236+00	2023-09-08 19:17:04.535236+00	54.48	USD	Delivered	Paid	Order for Request for Keyboard	2023-09-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
145	168	3	PO-2024-145	2024-05-05 19:17:04.535236+00	2024-05-12 19:17:04.535236+00	2024-05-10 19:17:04.535236+00	1059.04	USD	Delivered	Pending	Order for Request for Keyboard	2024-05-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
146	169	3	PO-2023-146	2023-12-22 19:17:04.535236+00	2023-12-29 19:17:04.535236+00	\N	56.28	USD	Shipped	Pending	Order for Request for Notebook	2023-12-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
147	170	3	PO-2024-147	2024-12-06 19:17:04.535236+00	2024-12-13 19:17:04.535236+00	2024-12-12 19:17:04.535236+00	40.59	USD	Delivered	Pending	Order for Request for Stapler	2024-12-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
148	171	4	PO-2024-148	2024-02-11 19:17:04.535236+00	2024-02-15 19:17:04.535236+00	2024-02-17 19:17:04.535236+00	3111.70	USD	Delivered	Pending	Order for Request for Monitor	2024-02-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
149	172	3	PO-2024-149	2024-03-08 19:17:04.535236+00	2024-03-15 19:17:04.535236+00	2024-03-17 19:17:04.535236+00	1715.94	USD	Delivered	Paid	Order for Request for Headset	2024-03-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
150	175	5	PO-2024-150	2024-01-14 19:17:04.535236+00	2024-01-16 19:17:04.535236+00	2024-01-17 19:17:04.535236+00	2719.26	USD	Delivered	Pending	Order for Request for Headset	2024-01-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
151	176	3	PO-2022-151	2022-12-14 19:17:04.535236+00	2022-12-21 19:17:04.535236+00	2022-12-21 19:17:04.535236+00	30.74	USD	Delivered	Pending	Order for Request for Stapler	2022-12-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
152	177	1	PO-2023-152	2023-12-16 19:17:04.535236+00	2023-12-19 19:17:04.535236+00	\N	11.52	USD	Shipped	Pending	Order for Request for Pen Set	2023-12-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
153	178	5	PO-2024-153	2024-01-28 19:17:04.535236+00	2024-01-30 19:17:04.535236+00	2024-01-28 19:17:04.535236+00	280.65	USD	Delivered	Pending	Order for Request for Headset	2024-01-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
154	179	5	PO-2025-154	2025-05-19 19:17:04.535236+00	2025-05-21 19:17:04.535236+00	\N	132.77	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2025-05-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
155	180	2	PO-2024-155	2024-04-30 19:17:04.535236+00	2024-05-05 19:17:04.535236+00	2024-05-06 19:17:04.535236+00	18.66	USD	Delivered	Pending	Order for Request for Stapler	2024-04-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
156	182	4	PO-2025-156	2025-02-08 19:17:04.535236+00	2025-02-12 19:17:04.535236+00	2025-02-10 19:17:04.535236+00	41.72	USD	Delivered	Pending	Order for Request for Printing Paper	2025-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
157	185	1	PO-2024-157	2024-01-01 19:17:04.535236+00	2024-01-04 19:17:04.535236+00	2024-01-05 19:17:04.535236+00	37.40	USD	Delivered	Paid	Order for Request for Pen Set	2024-01-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
158	186	5	PO-2023-158	2023-03-08 19:17:04.535236+00	2023-03-10 19:17:04.535236+00	2023-03-10 19:17:04.535236+00	492.90	USD	Delivered	Paid	Order for Request for Bookshelf	2023-03-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
159	187	2	PO-2025-159	2025-03-25 19:17:04.535236+00	2025-03-30 19:17:04.535236+00	2025-03-31 19:17:04.535236+00	225.33	USD	Delivered	Paid	Order for Request for Bookshelf	2025-03-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
160	188	2	PO-2024-160	2024-08-22 19:17:04.535236+00	2024-08-27 19:17:04.535236+00	2024-08-26 19:17:04.535236+00	7653.96	USD	Delivered	Pending	Order for Request for Filing Cabinet	2024-08-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
161	189	4	PO-2021-161	2021-05-11 19:17:04.535236+00	2021-05-15 19:17:04.535236+00	\N	41.40	USD	Cancelled	Cancelled	Order for Request for Printing Paper	2021-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
162	190	2	PO-2022-162	2022-07-16 19:17:04.535236+00	2022-07-21 19:17:04.535236+00	2022-07-21 19:17:04.535236+00	1850.54	USD	Delivered	Paid	Order for Request for Desk	2022-07-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
163	191	3	PO-2024-163	2024-10-21 19:17:04.535236+00	2024-10-28 19:17:04.535236+00	2024-10-30 19:17:04.535236+00	1438.06	USD	Delivered	Pending	Order for Request for Office Chair	2024-10-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
164	193	1	PO-2025-164	2025-05-01 19:17:04.535236+00	2025-05-04 19:17:04.535236+00	2025-05-03 19:17:04.535236+00	1747.46	USD	Delivered	Pending	Order for Request for Desk	2025-05-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
165	194	2	PO-2023-165	2023-05-30 19:17:04.535236+00	2023-06-04 19:17:04.535236+00	\N	75.44	USD	Cancelled	Cancelled	Order for Request for Printing Paper	2023-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
166	195	1	PO-2023-166	2023-09-30 19:17:04.535236+00	2023-10-03 19:17:04.535236+00	2023-10-04 19:17:04.535236+00	27.14	USD	Delivered	Pending	Order for Request for Sticky Notes	2023-09-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
167	196	3	PO-2025-167	2025-02-03 19:17:04.535236+00	2025-02-10 19:17:04.535236+00	\N	500.39	USD	Shipped	Pending	Order for Request for Conference Table	2025-02-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
168	198	5	PO-2025-168	2025-03-21 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	2025-03-21 19:17:04.535236+00	14.28	USD	Delivered	Pending	Order for Request for Printing Paper	2025-03-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
169	199	1	PO-2024-169	2024-04-20 19:17:04.535236+00	2024-04-23 19:17:04.535236+00	\N	26.90	USD	Cancelled	Cancelled	Order for Request for Pen Set	2024-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
170	200	3	PO-2022-170	2022-02-25 19:17:04.535236+00	2022-03-04 19:17:04.535236+00	2022-03-06 19:17:04.535236+00	78.98	USD	Delivered	Pending	Order for Request for Stapler	2022-02-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
171	202	1	PO-2021-171	2021-09-27 19:17:04.535236+00	2021-09-30 19:17:04.535236+00	2021-10-01 19:17:04.535236+00	80.73	USD	Delivered	Paid	Order for Request for Notebook	2021-09-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
172	203	5	PO-2022-172	2022-03-11 19:17:04.535236+00	2022-03-13 19:17:04.535236+00	\N	10.16	USD	Shipped	Pending	Order for Request for Notebook	2022-03-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
173	205	5	PO-2024-173	2024-10-10 19:17:04.535236+00	2024-10-12 19:17:04.535236+00	2024-10-10 19:17:04.535236+00	65.28	USD	Delivered	Paid	Order for Request for Stapler	2024-10-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
174	206	3	PO-2025-174	2025-03-03 19:17:04.535236+00	2025-03-10 19:17:04.535236+00	2025-03-12 19:17:04.535236+00	224.53	USD	Delivered	Pending	Order for Request for Desk	2025-03-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
175	207	1	PO-2024-175	2024-09-05 19:17:04.535236+00	2024-09-08 19:17:04.535236+00	2024-09-09 19:17:04.535236+00	1381.80	USD	Delivered	Pending	Order for Request for Desk	2024-09-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
176	208	5	PO-2024-176	2024-04-21 19:17:04.535236+00	2024-04-23 19:17:04.535236+00	2024-04-23 19:17:04.535236+00	7798.72	USD	Delivered	Pending	Order for Request for Filing Cabinet	2024-04-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
177	209	1	PO-2023-177	2023-01-23 19:17:04.535236+00	2023-01-26 19:17:04.535236+00	2023-01-28 19:17:04.535236+00	26.58	USD	Delivered	Paid	Order for Request for Notebook	2023-01-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
178	210	3	PO-2024-178	2024-04-29 19:17:04.535236+00	2024-05-06 19:17:04.535236+00	\N	84.58	USD	Cancelled	Cancelled	Order for Request for Notebook	2024-04-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
179	212	5	PO-2024-179	2024-05-14 19:17:04.535236+00	2024-05-16 19:17:04.535236+00	2024-05-14 19:17:04.535236+00	575.60	USD	Delivered	Paid	Order for Request for Laptop	2024-05-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
180	213	4	PO-2023-180	2023-07-06 19:17:04.535236+00	2023-07-10 19:17:04.535236+00	2023-07-08 19:17:04.535236+00	1614.44	USD	Delivered	Pending	Order for Request for Filing Cabinet	2023-07-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
181	214	1	PO-2023-181	2023-12-03 19:17:04.535236+00	2023-12-06 19:17:04.535236+00	2023-12-07 19:17:04.535236+00	2973.70	USD	Delivered	Pending	Order for Request for Headset	2023-12-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
182	215	3	PO-2024-182	2024-05-26 19:17:04.535236+00	2024-06-02 19:17:04.535236+00	2024-06-04 19:17:04.535236+00	35.88	USD	Delivered	Paid	Order for Request for Notebook	2024-05-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
183	216	3	PO-2024-183	2024-07-06 19:17:04.535236+00	2024-07-13 19:17:04.535236+00	2024-07-11 19:17:04.535236+00	53.55	USD	Delivered	Paid	Order for Request for Pen Set	2024-07-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
184	217	1	PO-2023-184	2023-04-13 19:17:04.535236+00	2023-04-16 19:17:04.535236+00	\N	52.07	USD	Shipped	Pending	Order for Request for Printing Paper	2023-04-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
185	218	3	PO-2025-185	2025-05-23 19:17:04.535236+00	2025-05-30 19:17:04.535236+00	2025-05-30 19:17:04.535236+00	20.84	USD	Delivered	Pending	Order for Request for Notebook	2025-05-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
186	219	1	PO-2025-186	2025-01-10 19:17:04.535236+00	2025-01-13 19:17:04.535236+00	2025-01-12 19:17:04.535236+00	1294.50	USD	Delivered	Pending	Order for Request for Desk	2025-01-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
187	220	2	PO-2024-187	2024-07-28 19:17:04.535236+00	2024-08-02 19:17:04.535236+00	\N	1291.28	USD	Ordered	Pending	Order for Request for Bookshelf	2024-07-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
188	221	1	PO-2024-188	2024-03-30 19:17:04.535236+00	2024-04-02 19:17:04.535236+00	2024-04-03 19:17:04.535236+00	40.60	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-03-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
189	222	4	PO-2021-189	2021-06-01 19:17:04.535236+00	2021-06-05 19:17:04.535236+00	2021-06-03 19:17:04.535236+00	75.16	USD	Delivered	Pending	Order for Request for Pen Set	2021-06-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
190	223	5	PO-2022-190	2022-11-23 19:17:04.535236+00	2022-11-25 19:17:04.535236+00	2022-11-26 19:17:04.535236+00	2487.60	USD	Delivered	Pending	Order for Request for Desk	2022-11-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
191	224	5	PO-2025-191	2025-02-08 19:17:04.535236+00	2025-02-10 19:17:04.535236+00	\N	3912.30	USD	Cancelled	Cancelled	Order for Request for Mouse	2025-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
192	226	1	PO-2024-192	2024-03-05 19:17:04.535236+00	2024-03-08 19:17:04.535236+00	2024-03-10 19:17:04.535236+00	266.32	USD	Delivered	Paid	Order for Request for Pen Set	2024-03-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
193	227	5	PO-2024-193	2024-09-24 19:17:04.535236+00	2024-09-26 19:17:04.535236+00	2024-09-27 19:17:04.535236+00	61.54	USD	Delivered	Pending	Order for Request for Laptop	2024-09-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
194	228	2	PO-2022-194	2022-08-28 19:17:04.535236+00	2022-09-02 19:17:04.535236+00	2022-09-04 19:17:04.535236+00	38.17	USD	Delivered	Paid	Order for Request for Pen Set	2022-08-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
195	229	3	PO-2025-195	2025-05-06 19:17:04.535236+00	2025-05-13 19:17:04.535236+00	\N	48.08	USD	Shipped	Pending	Order for Request for Notebook	2025-05-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
196	230	3	PO-2024-196	2024-12-12 19:17:04.535236+00	2024-12-19 19:17:04.535236+00	2024-12-19 19:17:04.535236+00	501.76	USD	Delivered	Pending	Order for Request for Laptop	2024-12-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
197	231	4	PO-2023-197	2023-07-17 19:17:04.535236+00	2023-07-21 19:17:04.535236+00	\N	45.35	USD	Cancelled	Cancelled	Order for Request for Pen Set	2023-07-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
198	232	1	PO-2020-198	2020-09-27 19:17:04.535236+00	2020-09-30 19:17:04.535236+00	2020-09-28 19:17:04.535236+00	1507.38	USD	Delivered	Paid	Order for Request for Desk	2020-09-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
199	233	4	PO-2022-199	2022-06-08 19:17:04.535236+00	2022-06-12 19:17:04.535236+00	2022-06-14 19:17:04.535236+00	388.62	USD	Delivered	Pending	Order for Request for Laptop	2022-06-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
200	234	1	PO-2023-200	2023-12-03 19:17:04.535236+00	2023-12-06 19:17:04.535236+00	\N	16134.41	USD	Cancelled	Cancelled	Order for Request for Conference Table	2023-12-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
201	235	5	PO-2024-201	2024-07-26 19:17:04.535236+00	2024-07-28 19:17:04.535236+00	2024-07-30 19:17:04.535236+00	20.65	USD	Delivered	Paid	Order for Request for Printing Paper	2024-07-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
202	236	5	PO-2024-202	2024-09-19 19:17:04.535236+00	2024-09-21 19:17:04.535236+00	2024-09-19 19:17:04.535236+00	1812.55	USD	Delivered	Pending	Order for Request for Office Chair	2024-09-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
203	237	5	PO-2022-203	2022-04-09 19:17:04.535236+00	2022-04-11 19:17:04.535236+00	2022-04-09 19:17:04.535236+00	8.88	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-04-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
204	238	5	PO-2025-204	2025-03-25 19:17:04.535236+00	2025-03-27 19:17:04.535236+00	2025-03-26 19:17:04.535236+00	219.80	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-03-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
205	239	5	PO-2024-205	2024-08-02 19:17:04.535236+00	2024-08-04 19:17:04.535236+00	2024-08-06 19:17:04.535236+00	3791.73	USD	Delivered	Paid	Order for Request for Keyboard	2024-08-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
206	241	3	PO-2024-206	2024-12-24 19:17:04.535236+00	2024-12-31 19:17:04.535236+00	2025-01-01 19:17:04.535236+00	30.18	USD	Delivered	Paid	Order for Request for Stapler	2024-12-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
207	242	1	PO-2024-207	2024-08-11 19:17:04.535236+00	2024-08-14 19:17:04.535236+00	2024-08-13 19:17:04.535236+00	2063.65	USD	Delivered	Paid	Order for Request for Filing Cabinet	2024-08-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
208	243	4	PO-2023-208	2023-11-18 19:17:04.535236+00	2023-11-22 19:17:04.535236+00	2023-11-23 19:17:04.535236+00	84.64	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-11-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
209	244	5	PO-2024-209	2024-08-10 19:17:04.535236+00	2024-08-12 19:17:04.535236+00	\N	69.21	USD	Shipped	Pending	Order for Request for Printing Paper	2024-08-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
210	245	2	PO-2021-210	2021-06-29 19:17:04.535236+00	2021-07-04 19:17:04.535236+00	2021-07-05 19:17:04.535236+00	821.58	USD	Delivered	Paid	Order for Request for Monitor	2021-06-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
211	246	5	PO-2024-211	2024-01-17 19:17:04.535236+00	2024-01-19 19:17:04.535236+00	2024-01-19 19:17:04.535236+00	231.29	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-01-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
212	248	5	PO-2022-212	2022-02-23 19:17:04.535236+00	2022-02-25 19:17:04.535236+00	2022-02-27 19:17:04.535236+00	1881.38	USD	Delivered	Pending	Order for Request for Laptop	2022-02-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
213	249	1	PO-2025-213	2025-04-20 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	42.38	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
214	250	2	PO-2024-214	2024-02-02 19:17:04.535236+00	2024-02-07 19:17:04.535236+00	\N	84.40	USD	Ordered	Pending	Order for Request for Stapler	2024-02-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
215	252	3	PO-2024-215	2024-01-07 19:17:04.535236+00	2024-01-14 19:17:04.535236+00	\N	57.56	USD	Cancelled	Cancelled	Order for Request for Stapler	2024-01-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
216	253	5	PO-2024-216	2024-10-07 19:17:04.535236+00	2024-10-09 19:17:04.535236+00	2024-10-09 19:17:04.535236+00	3424.93	USD	Delivered	Pending	Order for Request for Desk	2024-10-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
217	254	4	PO-2023-217	2023-01-17 19:17:04.535236+00	2023-01-21 19:17:04.535236+00	\N	88.66	USD	Ordered	Pending	Order for Request for Printing Paper	2023-01-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
218	255	5	PO-2022-218	2022-08-16 19:17:04.535236+00	2022-08-18 19:17:04.535236+00	2022-08-19 19:17:04.535236+00	41.85	USD	Delivered	Pending	Order for Request for Notebook	2022-08-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
219	258	3	PO-2025-219	2025-02-17 19:17:04.535236+00	2025-02-24 19:17:04.535236+00	2025-02-23 19:17:04.535236+00	39.92	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-02-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
220	259	3	PO-2023-220	2023-08-11 19:17:04.535236+00	2023-08-18 19:17:04.535236+00	\N	55.52	USD	Shipped	Pending	Order for Request for Sticky Notes	2023-08-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
221	261	2	PO-2023-221	2023-08-20 19:17:04.535236+00	2023-08-25 19:17:04.535236+00	2023-08-26 19:17:04.535236+00	88.07	USD	Delivered	Paid	Order for Request for Pen Set	2023-08-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
222	262	1	PO-2023-222	2023-09-28 19:17:04.535236+00	2023-10-01 19:17:04.535236+00	2023-09-30 19:17:04.535236+00	30.30	USD	Delivered	Paid	Order for Request for Stapler	2023-09-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
223	263	5	PO-2024-223	2024-11-10 19:17:04.535236+00	2024-11-12 19:17:04.535236+00	2024-11-10 19:17:04.535236+00	136.66	USD	Delivered	Pending	Order for Request for Pen Set	2024-11-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
224	264	4	PO-2024-224	2024-08-18 19:17:04.535236+00	2024-08-22 19:17:04.535236+00	2024-08-22 19:17:04.535236+00	1301.04	USD	Delivered	Paid	Order for Request for Mouse	2024-08-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
225	265	2	PO-2023-225	2023-09-20 19:17:04.535236+00	2023-09-25 19:17:04.535236+00	\N	546.94	USD	Shipped	Pending	Order for Request for Keyboard	2023-09-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
226	266	3	PO-2022-226	2022-12-13 19:17:04.535236+00	2022-12-20 19:17:04.535236+00	2022-12-22 19:17:04.535236+00	19.98	USD	Delivered	Pending	Order for Request for Stapler	2022-12-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
227	270	1	PO-2022-227	2022-02-08 19:17:04.535236+00	2022-02-11 19:17:04.535236+00	2022-02-12 19:17:04.535236+00	96.37	USD	Delivered	Paid	Order for Request for Printing Paper	2022-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
228	271	2	PO-2025-228	2025-04-19 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	104.32	USD	Delivered	Pending	Order for Request for Stapler	2025-04-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
229	272	4	PO-2023-229	2023-12-05 19:17:04.535236+00	2023-12-09 19:17:04.535236+00	2023-12-09 19:17:04.535236+00	875.08	USD	Delivered	Paid	Order for Request for Filing Cabinet	2023-12-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
230	275	5	PO-2025-230	2025-02-16 19:17:04.535236+00	2025-02-18 19:17:04.535236+00	2025-02-18 19:17:04.535236+00	93.51	USD	Delivered	Pending	Order for Request for Notebook	2025-02-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
231	276	4	PO-2025-231	2025-04-07 19:17:04.535236+00	2025-04-11 19:17:04.535236+00	\N	34.66	USD	Shipped	Pending	Order for Request for Stapler	2025-04-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
232	277	3	PO-2022-232	2022-07-19 19:17:04.535236+00	2022-07-26 19:17:04.535236+00	2022-07-26 19:17:04.535236+00	8755.28	USD	Delivered	Pending	Order for Request for Mouse	2022-07-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
233	278	4	PO-2021-233	2021-02-20 19:17:04.535236+00	2021-02-24 19:17:04.535236+00	2021-02-22 19:17:04.535236+00	68.90	USD	Delivered	Pending	Order for Request for Notebook	2021-02-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
234	279	3	PO-2025-234	2025-03-20 19:17:04.535236+00	2025-03-27 19:17:04.535236+00	2025-03-28 19:17:04.535236+00	23.84	USD	Delivered	Pending	Order for Request for Pen Set	2025-03-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
235	280	2	PO-2023-235	2023-06-04 19:17:04.535236+00	2023-06-09 19:17:04.535236+00	\N	623.74	USD	Cancelled	Cancelled	Order for Request for Mouse	2023-06-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
236	281	2	PO-2022-236	2022-11-16 19:17:04.535236+00	2022-11-21 19:17:04.535236+00	2022-11-21 19:17:04.535236+00	63.60	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-11-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
237	282	3	PO-2025-237	2025-03-17 19:17:04.535236+00	2025-03-24 19:17:04.535236+00	\N	39.63	USD	Shipped	Pending	Order for Request for Stapler	2025-03-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
238	284	1	PO-2024-238	2024-11-26 19:17:04.535236+00	2024-11-29 19:17:04.535236+00	2024-12-01 19:17:04.535236+00	7203.04	USD	Delivered	Paid	Order for Request for Bookshelf	2024-11-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
239	285	3	PO-2022-239	2022-04-20 19:17:04.535236+00	2022-04-27 19:17:04.535236+00	2022-04-28 19:17:04.535236+00	6509.66	USD	Delivered	Pending	Order for Request for Office Chair	2022-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
240	286	2	PO-2022-240	2022-08-22 19:17:04.535236+00	2022-08-27 19:17:04.535236+00	\N	1919.52	USD	Ordered	Pending	Order for Request for Conference Table	2022-08-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
241	287	4	PO-2022-241	2022-04-25 19:17:04.535236+00	2022-04-29 19:17:04.535236+00	2022-04-28 19:17:04.535236+00	97.26	USD	Delivered	Paid	Order for Request for Printing Paper	2022-04-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
242	288	3	PO-2025-242	2025-03-25 19:17:04.535236+00	2025-04-01 19:17:04.535236+00	2025-03-31 19:17:04.535236+00	465.36	USD	Delivered	Pending	Order for Request for Mouse	2025-03-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
243	289	4	PO-2024-243	2024-07-02 19:17:04.535236+00	2024-07-06 19:17:04.535236+00	\N	19.18	USD	Ordered	Pending	Order for Request for Stapler	2024-07-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
244	290	3	PO-2025-244	2025-05-19 19:17:04.535236+00	2025-05-26 19:17:04.535236+00	2025-05-25 19:17:04.535236+00	41.70	USD	Delivered	Pending	Order for Request for Stapler	2025-05-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
245	292	3	PO-2024-245	2024-08-31 19:17:04.535236+00	2024-09-07 19:17:04.535236+00	2024-09-06 19:17:04.535236+00	5.18	USD	Delivered	Paid	Order for Request for Stapler	2024-08-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
246	293	2	PO-2024-246	2024-10-03 19:17:04.535236+00	2024-10-08 19:17:04.535236+00	\N	26.60	USD	Shipped	Pending	Order for Request for Sticky Notes	2024-10-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
247	294	5	PO-2024-247	2024-05-27 19:17:04.535236+00	2024-05-29 19:17:04.535236+00	2024-05-31 19:17:04.535236+00	124.30	USD	Delivered	Paid	Order for Request for Notebook	2024-05-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
248	295	1	PO-2024-248	2024-09-16 19:17:04.535236+00	2024-09-19 19:17:04.535236+00	\N	70.60	USD	Ordered	Pending	Order for Request for Sticky Notes	2024-09-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
249	296	3	PO-2025-249	2025-05-11 19:17:04.535236+00	2025-05-18 19:17:04.535236+00	2025-05-18 19:17:04.535236+00	593.30	USD	Delivered	Pending	Order for Request for Desk	2025-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
250	297	1	PO-2024-250	2024-08-19 19:17:04.535236+00	2024-08-22 19:17:04.535236+00	2024-08-20 19:17:04.535236+00	1978.74	USD	Delivered	Paid	Order for Request for Laptop	2024-08-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
251	298	3	PO-2025-251	2025-02-09 19:17:04.535236+00	2025-02-16 19:17:04.535236+00	2025-02-18 19:17:04.535236+00	481.80	USD	Delivered	Paid	Order for Request for Mouse	2025-02-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
252	299	4	PO-2022-252	2022-11-28 19:17:04.535236+00	2022-12-02 19:17:04.535236+00	\N	1032.63	USD	Ordered	Pending	Order for Request for Keyboard	2022-11-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
253	301	2	PO-2024-253	2024-07-10 19:17:04.535236+00	2024-07-15 19:17:04.535236+00	2024-07-14 19:17:04.535236+00	28.80	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-07-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
254	302	2	PO-2024-254	2024-12-13 19:17:04.535236+00	2024-12-18 19:17:04.535236+00	\N	1327.30	USD	Ordered	Pending	Order for Request for Keyboard	2024-12-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
255	304	5	PO-2024-255	2024-02-22 19:17:04.535236+00	2024-02-24 19:17:04.535236+00	2024-02-24 19:17:04.535236+00	106.51	USD	Delivered	Pending	Order for Request for Notebook	2024-02-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
256	305	1	PO-2023-256	2023-05-09 19:17:04.535236+00	2023-05-12 19:17:04.535236+00	2023-05-12 19:17:04.535236+00	205.89	USD	Delivered	Paid	Order for Request for Keyboard	2023-05-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
257	306	4	PO-2025-257	2025-03-23 19:17:04.535236+00	2025-03-27 19:17:04.535236+00	2025-03-25 19:17:04.535236+00	88.50	USD	Delivered	Paid	Order for Request for Stapler	2025-03-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
258	307	1	PO-2023-258	2023-04-21 19:17:04.535236+00	2023-04-24 19:17:04.535236+00	2023-04-22 19:17:04.535236+00	71.35	USD	Delivered	Paid	Order for Request for Notebook	2023-04-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
259	311	1	PO-2024-259	2024-12-13 19:17:04.535236+00	2024-12-16 19:17:04.535236+00	\N	19.29	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-12-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
260	312	2	PO-2023-260	2023-06-20 19:17:04.535236+00	2023-06-25 19:17:04.535236+00	2023-06-26 19:17:04.535236+00	58.17	USD	Delivered	Pending	Order for Request for Stapler	2023-06-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
261	313	2	PO-2023-261	2023-09-02 19:17:04.535236+00	2023-09-07 19:17:04.535236+00	2023-09-05 19:17:04.535236+00	24.45	USD	Delivered	Paid	Order for Request for Notebook	2023-09-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
262	314	4	PO-2025-262	2025-01-27 19:17:04.535236+00	2025-01-31 19:17:04.535236+00	2025-01-30 19:17:04.535236+00	148.48	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-01-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
263	315	3	PO-2024-263	2024-08-27 19:17:04.535236+00	2024-09-03 19:17:04.535236+00	2024-09-03 19:17:04.535236+00	162.19	USD	Delivered	Paid	Order for Request for Stapler	2024-08-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
264	316	2	PO-2023-264	2023-06-03 19:17:04.535236+00	2023-06-08 19:17:04.535236+00	2023-06-07 19:17:04.535236+00	31.20	USD	Delivered	Pending	Order for Request for Printing Paper	2023-06-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
265	317	2	PO-2021-265	2021-07-09 19:17:04.535236+00	2021-07-14 19:17:04.535236+00	\N	3908.11	USD	Shipped	Pending	Order for Request for Headset	2021-07-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
266	318	3	PO-2025-266	2025-01-21 19:17:04.535236+00	2025-01-28 19:17:04.535236+00	2025-01-29 19:17:04.535236+00	22.72	USD	Delivered	Paid	Order for Request for Stapler	2025-01-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
267	319	1	PO-2025-267	2025-01-22 19:17:04.535236+00	2025-01-25 19:17:04.535236+00	2025-01-27 19:17:04.535236+00	44.24	USD	Delivered	Paid	Order for Request for Pen Set	2025-01-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
268	320	3	PO-2023-268	2023-11-12 19:17:04.535236+00	2023-11-19 19:17:04.535236+00	\N	34.44	USD	Ordered	Pending	Order for Request for Stapler	2023-11-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
269	321	2	PO-2024-269	2024-07-26 19:17:04.535236+00	2024-07-31 19:17:04.535236+00	2024-07-31 19:17:04.535236+00	2326.46	USD	Delivered	Pending	Order for Request for Conference Table	2024-07-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
270	322	2	PO-2024-270	2024-11-24 19:17:04.535236+00	2024-11-29 19:17:04.535236+00	\N	9.22	USD	Ordered	Pending	Order for Request for Stapler	2024-11-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
271	325	3	PO-2024-271	2024-04-08 19:17:04.535236+00	2024-04-15 19:17:04.535236+00	2024-04-15 19:17:04.535236+00	47.34	USD	Delivered	Pending	Order for Request for Notebook	2024-04-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
272	326	1	PO-2024-272	2024-03-08 19:17:04.535236+00	2024-03-11 19:17:04.535236+00	2024-03-11 19:17:04.535236+00	1072.39	USD	Delivered	Pending	Order for Request for Filing Cabinet	2024-03-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
273	327	4	PO-2025-273	2025-05-07 19:17:04.535236+00	2025-05-11 19:17:04.535236+00	2025-05-09 19:17:04.535236+00	21.08	USD	Delivered	Paid	Order for Request for Stapler	2025-05-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
274	329	2	PO-2023-274	2023-11-13 19:17:04.535236+00	2023-11-18 19:17:04.535236+00	2023-11-18 19:17:04.535236+00	1715.42	USD	Delivered	Pending	Order for Request for Office Chair	2023-11-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
275	330	4	PO-2023-275	2023-11-04 19:17:04.535236+00	2023-11-08 19:17:04.535236+00	\N	55.71	USD	Shipped	Pending	Order for Request for Sticky Notes	2023-11-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
276	331	1	PO-2024-276	2024-02-06 19:17:04.535236+00	2024-02-09 19:17:04.535236+00	2024-02-07 19:17:04.535236+00	92.75	USD	Delivered	Pending	Order for Request for Stapler	2024-02-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
277	332	5	PO-2025-277	2025-05-28 19:17:04.535236+00	2025-05-30 19:17:04.535236+00	2025-05-28 19:17:04.535236+00	70.19	USD	Delivered	Pending	Order for Request for Printing Paper	2025-05-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
278	333	2	PO-2025-278	2025-04-12 19:17:04.535236+00	2025-04-17 19:17:04.535236+00	2025-04-16 19:17:04.535236+00	104.52	USD	Delivered	Pending	Order for Request for Printing Paper	2025-04-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
279	334	4	PO-2025-279	2025-03-11 19:17:04.535236+00	2025-03-15 19:17:04.535236+00	2025-03-17 19:17:04.535236+00	48.94	USD	Delivered	Pending	Order for Request for Stapler	2025-03-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
280	335	5	PO-2021-280	2021-08-31 19:17:04.535236+00	2021-09-02 19:17:04.535236+00	2021-09-01 19:17:04.535236+00	27.00	USD	Delivered	Paid	Order for Request for Printing Paper	2021-08-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
281	338	4	PO-2023-281	2023-09-10 19:17:04.535236+00	2023-09-14 19:17:04.535236+00	\N	17.82	USD	Shipped	Pending	Order for Request for Sticky Notes	2023-09-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
282	339	1	PO-2025-282	2025-04-17 19:17:04.535236+00	2025-04-20 19:17:04.535236+00	\N	2003.15	USD	Cancelled	Cancelled	Order for Request for Keyboard	2025-04-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
283	340	2	PO-2025-283	2025-04-18 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	230.51	USD	Delivered	Paid	Order for Request for Notebook	2025-04-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
284	341	1	PO-2024-284	2024-08-03 19:17:04.535236+00	2024-08-06 19:17:04.535236+00	2024-08-05 19:17:04.535236+00	111.21	USD	Delivered	Pending	Order for Request for Pen Set	2024-08-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
285	342	3	PO-2025-285	2025-02-08 19:17:04.535236+00	2025-02-15 19:17:04.535236+00	\N	29.45	USD	Ordered	Pending	Order for Request for Stapler	2025-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
286	343	3	PO-2023-286	2023-11-17 19:17:04.535236+00	2023-11-24 19:17:04.535236+00	2023-11-23 19:17:04.535236+00	69.80	USD	Delivered	Paid	Order for Request for Notebook	2023-11-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
287	345	3	PO-2024-287	2024-10-04 19:17:04.535236+00	2024-10-11 19:17:04.535236+00	2024-10-13 19:17:04.535236+00	76.00	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-10-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
288	347	1	PO-2023-288	2023-08-24 19:17:04.535236+00	2023-08-27 19:17:04.535236+00	2023-08-28 19:17:04.535236+00	129.20	USD	Delivered	Pending	Order for Request for Printing Paper	2023-08-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
289	348	1	PO-2022-289	2022-10-29 19:17:04.535236+00	2022-11-01 19:17:04.535236+00	2022-10-31 19:17:04.535236+00	16.42	USD	Delivered	Pending	Order for Request for Printing Paper	2022-10-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
290	349	3	PO-2024-290	2024-10-24 19:17:04.535236+00	2024-10-31 19:17:04.535236+00	2024-11-02 19:17:04.535236+00	18.48	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-10-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
291	350	2	PO-2025-291	2025-05-02 19:17:04.535236+00	2025-05-07 19:17:04.535236+00	2025-05-05 19:17:04.535236+00	1153.80	USD	Delivered	Paid	Order for Request for Desk	2025-05-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
292	352	4	PO-2025-292	2025-04-14 19:17:04.535236+00	2025-04-18 19:17:04.535236+00	2025-04-19 19:17:04.535236+00	58.50	USD	Delivered	Pending	Order for Request for Pen Set	2025-04-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
293	353	1	PO-2024-293	2024-08-11 19:17:04.535236+00	2024-08-14 19:17:04.535236+00	\N	36.98	USD	Ordered	Pending	Order for Request for Notebook	2024-08-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
294	354	1	PO-2024-294	2024-07-15 19:17:04.535236+00	2024-07-18 19:17:04.535236+00	2024-07-20 19:17:04.535236+00	138.28	USD	Delivered	Paid	Order for Request for Printing Paper	2024-07-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
295	355	1	PO-2025-295	2025-01-26 19:17:04.535236+00	2025-01-29 19:17:04.535236+00	2025-01-31 19:17:04.535236+00	20.19	USD	Delivered	Paid	Order for Request for Printing Paper	2025-01-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
296	356	3	PO-2022-296	2022-09-07 19:17:04.535236+00	2022-09-14 19:17:04.535236+00	2022-09-13 19:17:04.535236+00	67.47	USD	Delivered	Pending	Order for Request for Notebook	2022-09-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
297	357	3	PO-2024-297	2024-11-07 19:17:04.535236+00	2024-11-14 19:17:04.535236+00	\N	9.08	USD	Cancelled	Cancelled	Order for Request for Stapler	2024-11-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
298	358	5	PO-2024-298	2024-01-09 19:17:04.535236+00	2024-01-11 19:17:04.535236+00	2024-01-10 19:17:04.535236+00	786.50	USD	Delivered	Pending	Order for Request for Conference Table	2024-01-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
299	361	2	PO-2021-299	2021-10-05 19:17:04.535236+00	2021-10-10 19:17:04.535236+00	2021-10-10 19:17:04.535236+00	6950.27	USD	Delivered	Paid	Order for Request for Monitor	2021-10-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
300	362	4	PO-2023-300	2023-05-04 19:17:04.535236+00	2023-05-08 19:17:04.535236+00	2023-05-07 19:17:04.535236+00	9.38	USD	Delivered	Pending	Order for Request for Printing Paper	2023-05-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
301	363	1	PO-2024-301	2024-11-29 19:17:04.535236+00	2024-12-02 19:17:04.535236+00	2024-11-30 19:17:04.535236+00	1236.93	USD	Delivered	Paid	Order for Request for Bookshelf	2024-11-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
302	364	1	PO-2022-302	2022-06-23 19:17:04.535236+00	2022-06-26 19:17:04.535236+00	2022-06-25 19:17:04.535236+00	301.80	USD	Delivered	Paid	Order for Request for Headset	2022-06-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
303	365	4	PO-2024-303	2024-07-19 19:17:04.535236+00	2024-07-23 19:17:04.535236+00	\N	414.89	USD	Ordered	Pending	Order for Request for Laptop	2024-07-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
304	366	3	PO-2021-304	2021-09-23 19:17:04.535236+00	2021-09-30 19:17:04.535236+00	2021-10-01 19:17:04.535236+00	4.21	USD	Delivered	Pending	Order for Request for Sticky Notes	2021-09-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
305	367	2	PO-2024-305	2024-12-07 19:17:04.535236+00	2024-12-12 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	83.89	USD	Delivered	Pending	Order for Request for Printing Paper	2024-12-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
306	368	3	PO-2022-306	2022-03-28 19:17:04.535236+00	2022-04-04 19:17:04.535236+00	2022-04-05 19:17:04.535236+00	6938.73	USD	Delivered	Paid	Order for Request for Bookshelf	2022-03-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
307	369	4	PO-2025-307	2025-02-28 19:17:04.535236+00	2025-03-04 19:17:04.535236+00	2025-03-02 19:17:04.535236+00	791.78	USD	Delivered	Paid	Order for Request for Filing Cabinet	2025-02-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
308	370	2	PO-2024-308	2024-11-03 19:17:04.535236+00	2024-11-08 19:17:04.535236+00	2024-11-09 19:17:04.535236+00	1848.67	USD	Delivered	Pending	Order for Request for Desk	2024-11-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
309	371	1	PO-2024-309	2024-09-29 19:17:04.535236+00	2024-10-02 19:17:04.535236+00	2024-10-03 19:17:04.535236+00	7502.38	USD	Delivered	Pending	Order for Request for Conference Table	2024-09-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
310	372	5	PO-2023-310	2023-04-08 19:17:04.535236+00	2023-04-10 19:17:04.535236+00	2023-04-09 19:17:04.535236+00	6.90	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-04-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
311	373	5	PO-2025-311	2025-05-02 19:17:04.535236+00	2025-05-04 19:17:04.535236+00	2025-05-03 19:17:04.535236+00	46.70	USD	Delivered	Pending	Order for Request for Printing Paper	2025-05-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
312	374	5	PO-2021-312	2021-08-26 19:17:04.535236+00	2021-08-28 19:17:04.535236+00	2021-08-27 19:17:04.535236+00	18.62	USD	Delivered	Paid	Order for Request for Printing Paper	2021-08-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
313	375	5	PO-2023-313	2023-09-24 19:17:04.535236+00	2023-09-26 19:17:04.535236+00	2023-09-26 19:17:04.535236+00	1105.68	USD	Delivered	Paid	Order for Request for Monitor	2023-09-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
314	376	5	PO-2023-314	2023-04-02 19:17:04.535236+00	2023-04-04 19:17:04.535236+00	2023-04-05 19:17:04.535236+00	13088.21	USD	Delivered	Pending	Order for Request for Conference Table	2023-04-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
315	377	3	PO-2025-315	2025-02-11 19:17:04.535236+00	2025-02-18 19:17:04.535236+00	2025-02-19 19:17:04.535236+00	47.65	USD	Delivered	Paid	Order for Request for Notebook	2025-02-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
316	378	5	PO-2025-316	2025-05-25 19:17:04.535236+00	2025-05-27 19:17:04.535236+00	2025-05-26 19:17:04.535236+00	66.72	USD	Delivered	Pending	Order for Request for Notebook	2025-05-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
317	379	4	PO-2021-317	2021-02-27 19:17:04.535236+00	2021-03-03 19:17:04.535236+00	2021-03-03 19:17:04.535236+00	36.04	USD	Delivered	Paid	Order for Request for Notebook	2021-02-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
318	381	3	PO-2024-318	2024-12-31 19:17:04.535236+00	2025-01-07 19:17:04.535236+00	2025-01-08 19:17:04.535236+00	28.56	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-12-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
319	383	1	PO-2023-319	2023-01-14 19:17:04.535236+00	2023-01-17 19:17:04.535236+00	2023-01-17 19:17:04.535236+00	1530.44	USD	Delivered	Paid	Order for Request for Office Chair	2023-01-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
320	384	3	PO-2024-320	2024-11-07 19:17:04.535236+00	2024-11-14 19:17:04.535236+00	2024-11-16 19:17:04.535236+00	94.24	USD	Delivered	Paid	Order for Request for Notebook	2024-11-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
321	385	3	PO-2023-321	2023-05-17 19:17:04.535236+00	2023-05-24 19:17:04.535236+00	\N	17.13	USD	Shipped	Pending	Order for Request for Stapler	2023-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
322	387	2	PO-2024-322	2024-09-22 19:17:04.535236+00	2024-09-27 19:17:04.535236+00	2024-09-25 19:17:04.535236+00	1121.92	USD	Delivered	Paid	Order for Request for Filing Cabinet	2024-09-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
323	388	4	PO-2025-323	2025-05-12 19:17:04.535236+00	2025-05-16 19:17:04.535236+00	\N	2966.45	USD	Ordered	Pending	Order for Request for Bookshelf	2025-05-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
324	390	1	PO-2025-324	2025-03-28 19:17:04.535236+00	2025-03-31 19:17:04.535236+00	\N	169.36	USD	Shipped	Pending	Order for Request for Notebook	2025-03-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
325	392	5	PO-2025-325	2025-04-22 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	14.00	USD	Delivered	Paid	Order for Request for Printing Paper	2025-04-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
326	393	2	PO-2025-326	2025-03-01 19:17:04.535236+00	2025-03-06 19:17:04.535236+00	2025-03-08 19:17:04.535236+00	23.00	USD	Delivered	Paid	Order for Request for Pen Set	2025-03-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
327	394	2	PO-2024-327	2024-02-23 19:17:04.535236+00	2024-02-28 19:17:04.535236+00	\N	123.07	USD	Ordered	Pending	Order for Request for Notebook	2024-02-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
328	395	2	PO-2025-328	2025-01-19 19:17:04.535236+00	2025-01-24 19:17:04.535236+00	2025-01-25 19:17:04.535236+00	74.63	USD	Delivered	Paid	Order for Request for Stapler	2025-01-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
329	396	2	PO-2024-329	2024-12-04 19:17:04.535236+00	2024-12-09 19:17:04.535236+00	2024-12-09 19:17:04.535236+00	145.90	USD	Delivered	Paid	Order for Request for Pen Set	2024-12-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
330	397	4	PO-2024-330	2024-03-09 19:17:04.535236+00	2024-03-13 19:17:04.535236+00	2024-03-12 19:17:04.535236+00	33.45	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-03-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
331	399	2	PO-2025-331	2025-04-12 19:17:04.535236+00	2025-04-17 19:17:04.535236+00	\N	2453.24	USD	Ordered	Pending	Order for Request for Bookshelf	2025-04-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
332	400	2	PO-2025-332	2025-03-19 19:17:04.535236+00	2025-03-24 19:17:04.535236+00	2025-03-24 19:17:04.535236+00	10.86	USD	Delivered	Paid	Order for Request for Pen Set	2025-03-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
333	401	2	PO-2025-333	2025-03-19 19:17:04.535236+00	2025-03-24 19:17:04.535236+00	\N	6412.71	USD	Ordered	Pending	Order for Request for Laptop	2025-03-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
334	402	2	PO-2022-334	2022-01-29 19:17:04.535236+00	2022-02-03 19:17:04.535236+00	2022-02-01 19:17:04.535236+00	5916.47	USD	Delivered	Pending	Order for Request for Conference Table	2022-01-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
335	404	1	PO-2024-335	2024-10-15 19:17:04.535236+00	2024-10-18 19:17:04.535236+00	2024-10-18 19:17:04.535236+00	3836.98	USD	Delivered	Pending	Order for Request for Headset	2024-10-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
336	405	1	PO-2024-336	2024-05-01 19:17:04.535236+00	2024-05-04 19:17:04.535236+00	2024-05-02 19:17:04.535236+00	11.40	USD	Delivered	Paid	Order for Request for Pen Set	2024-05-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
337	407	4	PO-2025-337	2025-02-15 19:17:04.535236+00	2025-02-19 19:17:04.535236+00	\N	60.60	USD	Ordered	Pending	Order for Request for Sticky Notes	2025-02-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
338	408	2	PO-2024-338	2024-02-19 19:17:04.535236+00	2024-02-24 19:17:04.535236+00	2024-02-25 19:17:04.535236+00	37.26	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-02-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
339	409	1	PO-2024-339	2024-05-22 19:17:04.535236+00	2024-05-25 19:17:04.535236+00	2024-05-27 19:17:04.535236+00	43.91	USD	Delivered	Paid	Order for Request for Printing Paper	2024-05-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
340	410	3	PO-2023-340	2023-12-04 19:17:04.535236+00	2023-12-11 19:17:04.535236+00	2023-12-12 19:17:04.535236+00	82.36	USD	Delivered	Pending	Order for Request for Printing Paper	2023-12-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
341	412	4	PO-2024-341	2024-01-30 19:17:04.535236+00	2024-02-03 19:17:04.535236+00	\N	133.46	USD	Ordered	Pending	Order for Request for Pen Set	2024-01-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
342	413	3	PO-2022-342	2022-03-10 19:17:04.535236+00	2022-03-17 19:17:04.535236+00	\N	45.14	USD	Ordered	Pending	Order for Request for Printing Paper	2022-03-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
343	414	2	PO-2025-343	2025-05-24 19:17:04.535236+00	2025-05-29 19:17:04.535236+00	2025-05-27 19:17:04.535236+00	139.60	USD	Delivered	Pending	Order for Request for Notebook	2025-05-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
344	415	5	PO-2024-344	2024-12-12 19:17:04.535236+00	2024-12-14 19:17:04.535236+00	\N	28.82	USD	Shipped	Pending	Order for Request for Notebook	2024-12-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
345	416	3	PO-2025-345	2025-05-17 19:17:04.535236+00	2025-05-24 19:17:04.535236+00	\N	287.16	USD	Cancelled	Cancelled	Order for Request for Mouse	2025-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
346	417	2	PO-2024-346	2024-09-19 19:17:04.535236+00	2024-09-24 19:17:04.535236+00	2024-09-23 19:17:04.535236+00	44.35	USD	Delivered	Paid	Order for Request for Stapler	2024-09-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
347	418	2	PO-2023-347	2023-12-11 19:17:04.535236+00	2023-12-16 19:17:04.535236+00	\N	1163.22	USD	Shipped	Pending	Order for Request for Desk	2023-12-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
348	419	5	PO-2025-348	2025-05-05 19:17:04.535236+00	2025-05-07 19:17:04.535236+00	\N	5065.35	USD	Shipped	Pending	Order for Request for Bookshelf	2025-05-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
349	420	2	PO-2024-349	2024-12-23 19:17:04.535236+00	2024-12-28 19:17:04.535236+00	2024-12-27 19:17:04.535236+00	31.88	USD	Delivered	Paid	Order for Request for Pen Set	2024-12-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
350	421	3	PO-2024-350	2024-06-01 19:17:04.535236+00	2024-06-08 19:17:04.535236+00	2024-06-08 19:17:04.535236+00	91.51	USD	Delivered	Pending	Order for Request for Printing Paper	2024-06-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
351	423	4	PO-2025-351	2025-04-24 19:17:04.535236+00	2025-04-28 19:17:04.535236+00	2025-04-26 19:17:04.535236+00	112.34	USD	Delivered	Pending	Order for Request for Stapler	2025-04-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
352	424	3	PO-2025-352	2025-02-05 19:17:04.535236+00	2025-02-12 19:17:04.535236+00	2025-02-13 19:17:04.535236+00	113.91	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-02-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
353	425	1	PO-2022-353	2022-06-11 19:17:04.535236+00	2022-06-14 19:17:04.535236+00	2022-06-13 19:17:04.535236+00	128.05	USD	Delivered	Pending	Order for Request for Stapler	2022-06-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
354	426	4	PO-2025-354	2025-04-30 19:17:04.535236+00	2025-05-04 19:17:04.535236+00	2025-05-06 19:17:04.535236+00	4772.18	USD	Delivered	Pending	Order for Request for Filing Cabinet	2025-04-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
355	428	4	PO-2023-355	2023-08-19 19:17:04.535236+00	2023-08-23 19:17:04.535236+00	\N	46.00	USD	Ordered	Pending	Order for Request for Pen Set	2023-08-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
356	429	5	PO-2024-356	2024-05-03 19:17:04.535236+00	2024-05-05 19:17:04.535236+00	2024-05-04 19:17:04.535236+00	377.07	USD	Delivered	Pending	Order for Request for Filing Cabinet	2024-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
357	430	2	PO-2023-357	2023-11-24 19:17:04.535236+00	2023-11-29 19:17:04.535236+00	2023-11-27 19:17:04.535236+00	99.10	USD	Delivered	Pending	Order for Request for Pen Set	2023-11-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
358	431	4	PO-2024-358	2024-05-11 19:17:04.535236+00	2024-05-15 19:17:04.535236+00	2024-05-15 19:17:04.535236+00	36.42	USD	Delivered	Pending	Order for Request for Stapler	2024-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
359	432	3	PO-2025-359	2025-05-05 19:17:04.535236+00	2025-05-12 19:17:04.535236+00	2025-05-13 19:17:04.535236+00	25.35	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-05-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
360	433	3	PO-2023-360	2023-03-06 19:17:04.535236+00	2023-03-13 19:17:04.535236+00	2023-03-12 19:17:04.535236+00	45.90	USD	Delivered	Paid	Order for Request for Pen Set	2023-03-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
361	434	2	PO-2023-361	2023-08-23 19:17:04.535236+00	2023-08-28 19:17:04.535236+00	2023-08-28 19:17:04.535236+00	20.76	USD	Delivered	Pending	Order for Request for Printing Paper	2023-08-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
362	436	3	PO-2024-362	2024-09-08 19:17:04.535236+00	2024-09-15 19:17:04.535236+00	2024-09-16 19:17:04.535236+00	1891.48	USD	Delivered	Pending	Order for Request for Mouse	2024-09-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
363	437	2	PO-2025-363	2025-05-01 19:17:04.535236+00	2025-05-06 19:17:04.535236+00	2025-05-07 19:17:04.535236+00	123.91	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-05-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
364	438	5	PO-2025-364	2025-04-22 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	\N	1320.77	USD	Shipped	Pending	Order for Request for Office Chair	2025-04-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
365	440	4	PO-2025-365	2025-04-17 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	2025-04-20 19:17:04.535236+00	352.39	USD	Delivered	Paid	Order for Request for Mouse	2025-04-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
366	441	4	PO-2022-366	2022-06-10 19:17:04.535236+00	2022-06-14 19:17:04.535236+00	2022-06-15 19:17:04.535236+00	28.84	USD	Delivered	Paid	Order for Request for Notebook	2022-06-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
367	442	3	PO-2024-367	2024-07-15 19:17:04.535236+00	2024-07-22 19:17:04.535236+00	\N	706.06	USD	Ordered	Pending	Order for Request for Bookshelf	2024-07-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
368	443	5	PO-2025-368	2025-04-30 19:17:04.535236+00	2025-05-02 19:17:04.535236+00	\N	33.25	USD	Shipped	Pending	Order for Request for Notebook	2025-04-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
369	444	4	PO-2025-369	2025-01-28 19:17:04.535236+00	2025-02-01 19:17:04.535236+00	\N	116.34	USD	Cancelled	Cancelled	Order for Request for Stapler	2025-01-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
370	445	3	PO-2025-370	2025-01-01 19:17:04.535236+00	2025-01-08 19:17:04.535236+00	2025-01-07 19:17:04.535236+00	5858.31	USD	Delivered	Pending	Order for Request for Office Chair	2025-01-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
371	446	4	PO-2025-371	2025-02-19 19:17:04.535236+00	2025-02-23 19:17:04.535236+00	2025-02-21 19:17:04.535236+00	50.17	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-02-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
372	447	5	PO-2021-372	2021-04-14 19:17:04.535236+00	2021-04-16 19:17:04.535236+00	2021-04-17 19:17:04.535236+00	28.40	USD	Delivered	Pending	Order for Request for Notebook	2021-04-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
373	449	3	PO-2025-373	2025-05-29 19:17:04.535236+00	2025-06-05 19:17:04.535236+00	2025-06-06 19:17:04.535236+00	13.97	USD	Delivered	Pending	Order for Request for Notebook	2025-05-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
374	450	1	PO-2025-374	2025-02-01 19:17:04.535236+00	2025-02-04 19:17:04.535236+00	2025-02-02 19:17:04.535236+00	3453.38	USD	Delivered	Paid	Order for Request for Bookshelf	2025-02-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
375	451	1	PO-2024-375	2024-11-01 19:17:04.535236+00	2024-11-04 19:17:04.535236+00	\N	861.57	USD	Ordered	Pending	Order for Request for Laptop	2024-11-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
376	452	1	PO-2024-376	2024-10-16 19:17:04.535236+00	2024-10-19 19:17:04.535236+00	2024-10-21 19:17:04.535236+00	1710.89	USD	Delivered	Paid	Order for Request for Filing Cabinet	2024-10-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
377	453	4	PO-2024-377	2024-06-14 19:17:04.535236+00	2024-06-18 19:17:04.535236+00	\N	3.65	USD	Shipped	Pending	Order for Request for Sticky Notes	2024-06-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
378	454	4	PO-2025-378	2025-03-27 19:17:04.535236+00	2025-03-31 19:17:04.535236+00	2025-04-02 19:17:04.535236+00	27.33	USD	Delivered	Pending	Order for Request for Stapler	2025-03-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
379	455	2	PO-2025-379	2025-05-12 19:17:04.535236+00	2025-05-17 19:17:04.535236+00	2025-05-18 19:17:04.535236+00	38.77	USD	Delivered	Pending	Order for Request for Mouse	2025-05-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
380	456	4	PO-2023-380	2023-09-06 19:17:04.535236+00	2023-09-10 19:17:04.535236+00	2023-09-08 19:17:04.535236+00	78.68	USD	Delivered	Paid	Order for Request for Mouse	2023-09-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
381	457	2	PO-2022-381	2022-08-15 19:17:04.535236+00	2022-08-20 19:17:04.535236+00	\N	11.97	USD	Ordered	Pending	Order for Request for Pen Set	2022-08-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
382	458	1	PO-2023-382	2023-08-04 19:17:04.535236+00	2023-08-07 19:17:04.535236+00	2023-08-08 19:17:04.535236+00	161.20	USD	Delivered	Paid	Order for Request for Pen Set	2023-08-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
383	460	4	PO-2025-383	2025-02-03 19:17:04.535236+00	2025-02-07 19:17:04.535236+00	\N	36.82	USD	Cancelled	Cancelled	Order for Request for Pen Set	2025-02-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
384	461	4	PO-2024-384	2024-07-11 19:17:04.535236+00	2024-07-15 19:17:04.535236+00	2024-07-17 19:17:04.535236+00	29.11	USD	Delivered	Paid	Order for Request for Notebook	2024-07-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
385	462	5	PO-2024-385	2024-06-25 19:17:04.535236+00	2024-06-27 19:17:04.535236+00	2024-06-28 19:17:04.535236+00	294.18	USD	Delivered	Pending	Order for Request for Laptop	2024-06-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
386	463	1	PO-2022-386	2022-08-28 19:17:04.535236+00	2022-08-31 19:17:04.535236+00	2022-08-29 19:17:04.535236+00	18.78	USD	Delivered	Paid	Order for Request for Stapler	2022-08-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
387	464	2	PO-2022-387	2022-09-26 19:17:04.535236+00	2022-10-01 19:17:04.535236+00	2022-10-03 19:17:04.535236+00	189.63	USD	Delivered	Paid	Order for Request for Conference Table	2022-09-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
388	465	3	PO-2022-388	2022-07-08 19:17:04.535236+00	2022-07-15 19:17:04.535236+00	2022-07-14 19:17:04.535236+00	497.59	USD	Delivered	Pending	Order for Request for Headset	2022-07-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
389	466	5	PO-2023-389	2023-06-02 19:17:04.535236+00	2023-06-04 19:17:04.535236+00	2023-06-04 19:17:04.535236+00	27.26	USD	Delivered	Pending	Order for Request for Printing Paper	2023-06-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
390	467	3	PO-2024-390	2024-01-15 19:17:04.535236+00	2024-01-22 19:17:04.535236+00	\N	31.44	USD	Cancelled	Cancelled	Order for Request for Stapler	2024-01-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
391	468	1	PO-2025-391	2025-05-17 19:17:04.535236+00	2025-05-20 19:17:04.535236+00	2025-05-22 19:17:04.535236+00	1570.31	USD	Delivered	Paid	Order for Request for Desk	2025-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
392	470	1	PO-2021-392	2021-05-22 19:17:04.535236+00	2021-05-25 19:17:04.535236+00	2021-05-24 19:17:04.535236+00	61.97	USD	Delivered	Paid	Order for Request for Pen Set	2021-05-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
393	471	2	PO-2024-393	2024-12-10 19:17:04.535236+00	2024-12-15 19:17:04.535236+00	2024-12-17 19:17:04.535236+00	76.30	USD	Delivered	Paid	Order for Request for Stapler	2024-12-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
394	472	1	PO-2022-394	2022-06-04 19:17:04.535236+00	2022-06-07 19:17:04.535236+00	\N	1054.66	USD	Shipped	Pending	Order for Request for Desk	2022-06-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
395	473	2	PO-2025-395	2025-05-08 19:17:04.535236+00	2025-05-13 19:17:04.535236+00	\N	116.60	USD	Cancelled	Cancelled	Order for Request for Printing Paper	2025-05-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
396	474	4	PO-2023-396	2023-09-04 19:17:04.535236+00	2023-09-08 19:17:04.535236+00	2023-09-06 19:17:04.535236+00	1770.04	USD	Delivered	Paid	Order for Request for Laptop	2023-09-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
397	476	3	PO-2022-397	2022-09-30 19:17:04.535236+00	2022-10-07 19:17:04.535236+00	2022-10-08 19:17:04.535236+00	4575.24	USD	Delivered	Pending	Order for Request for Monitor	2022-09-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
398	477	1	PO-2020-398	2020-12-29 19:17:04.535236+00	2021-01-01 19:17:04.535236+00	2021-01-02 19:17:04.535236+00	341.72	USD	Delivered	Pending	Order for Request for Monitor	2020-12-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
399	478	5	PO-2025-399	2025-05-12 19:17:04.535236+00	2025-05-14 19:17:04.535236+00	2025-05-12 19:17:04.535236+00	24.24	USD	Delivered	Paid	Order for Request for Stapler	2025-05-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
400	479	3	PO-2023-400	2023-01-29 19:17:04.535236+00	2023-02-05 19:17:04.535236+00	2023-02-07 19:17:04.535236+00	76.70	USD	Delivered	Paid	Order for Request for Stapler	2023-01-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
401	480	5	PO-2023-401	2023-09-27 19:17:04.535236+00	2023-09-29 19:17:04.535236+00	2023-09-29 19:17:04.535236+00	94.34	USD	Delivered	Pending	Order for Request for Notebook	2023-09-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
402	482	3	PO-2024-402	2024-06-02 19:17:04.535236+00	2024-06-09 19:17:04.535236+00	2024-06-09 19:17:04.535236+00	1311.46	USD	Delivered	Paid	Order for Request for Filing Cabinet	2024-06-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
403	483	3	PO-2023-403	2023-10-28 19:17:04.535236+00	2023-11-04 19:17:04.535236+00	2023-11-03 19:17:04.535236+00	1386.46	USD	Delivered	Pending	Order for Request for Desk	2023-10-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
404	484	2	PO-2024-404	2024-11-03 19:17:04.535236+00	2024-11-08 19:17:04.535236+00	\N	109.87	USD	Ordered	Pending	Order for Request for Laptop	2024-11-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
405	485	4	PO-2024-405	2024-09-07 19:17:04.535236+00	2024-09-11 19:17:04.535236+00	2024-09-13 19:17:04.535236+00	297.80	USD	Delivered	Paid	Order for Request for Keyboard	2024-09-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
406	486	4	PO-2025-406	2025-04-04 19:17:04.535236+00	2025-04-08 19:17:04.535236+00	\N	85.00	USD	Shipped	Pending	Order for Request for Stapler	2025-04-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
407	487	3	PO-2023-407	2023-01-18 19:17:04.535236+00	2023-01-25 19:17:04.535236+00	2023-01-26 19:17:04.535236+00	107.23	USD	Delivered	Paid	Order for Request for Stapler	2023-01-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
408	488	3	PO-2023-408	2023-10-27 19:17:04.535236+00	2023-11-03 19:17:04.535236+00	\N	8131.24	USD	Shipped	Pending	Order for Request for Conference Table	2023-10-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
409	489	2	PO-2024-409	2024-06-10 19:17:04.535236+00	2024-06-15 19:17:04.535236+00	2024-06-15 19:17:04.535236+00	510.00	USD	Delivered	Pending	Order for Request for Monitor	2024-06-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
410	490	4	PO-2025-410	2025-04-25 19:17:04.535236+00	2025-04-29 19:17:04.535236+00	2025-04-28 19:17:04.535236+00	516.04	USD	Delivered	Pending	Order for Request for Keyboard	2025-04-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
411	491	5	PO-2025-411	2025-04-18 19:17:04.535236+00	2025-04-20 19:17:04.535236+00	\N	573.27	USD	Cancelled	Cancelled	Order for Request for Mouse	2025-04-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
412	492	4	PO-2024-412	2024-02-10 19:17:04.535236+00	2024-02-14 19:17:04.535236+00	2024-02-12 19:17:04.535236+00	64.56	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-02-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
413	493	5	PO-2024-413	2024-09-08 19:17:04.535236+00	2024-09-10 19:17:04.535236+00	2024-09-10 19:17:04.535236+00	3078.83	USD	Delivered	Paid	Order for Request for Desk	2024-09-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
414	494	2	PO-2024-414	2024-12-15 19:17:04.535236+00	2024-12-20 19:17:04.535236+00	2024-12-18 19:17:04.535236+00	1031.13	USD	Delivered	Pending	Order for Request for Bookshelf	2024-12-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
415	496	3	PO-2024-415	2024-06-18 19:17:04.535236+00	2024-06-25 19:17:04.535236+00	2024-06-25 19:17:04.535236+00	26.18	USD	Delivered	Pending	Order for Request for Stapler	2024-06-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
416	498	2	PO-2024-416	2024-12-06 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	85.59	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-12-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
417	499	1	PO-2023-417	2023-12-11 19:17:04.535236+00	2023-12-14 19:17:04.535236+00	\N	2071.89	USD	Cancelled	Cancelled	Order for Request for Mouse	2023-12-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
418	502	2	PO-2025-418	2025-01-29 19:17:04.535236+00	2025-02-03 19:17:04.535236+00	2025-02-04 19:17:04.535236+00	3685.19	USD	Delivered	Pending	Order for Request for Laptop	2025-01-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
419	503	2	PO-2024-419	2024-06-14 19:17:04.535236+00	2024-06-19 19:17:04.535236+00	2024-06-17 19:17:04.535236+00	61.44	USD	Delivered	Pending	Order for Request for Notebook	2024-06-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
420	504	5	PO-2024-420	2024-08-24 19:17:04.535236+00	2024-08-26 19:17:04.535236+00	2024-08-27 19:17:04.535236+00	153.05	USD	Delivered	Pending	Order for Request for Stapler	2024-08-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
421	506	2	PO-2023-421	2023-04-16 19:17:04.535236+00	2023-04-21 19:17:04.535236+00	2023-04-20 19:17:04.535236+00	447.35	USD	Delivered	Paid	Order for Request for Monitor	2023-04-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
422	507	4	PO-2023-422	2023-08-24 19:17:04.535236+00	2023-08-28 19:17:04.535236+00	2023-08-27 19:17:04.535236+00	451.88	USD	Delivered	Pending	Order for Request for Monitor	2023-08-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
423	508	3	PO-2024-423	2024-07-23 19:17:04.535236+00	2024-07-30 19:17:04.535236+00	\N	9339.52	USD	Shipped	Pending	Order for Request for Office Chair	2024-07-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
424	509	3	PO-2025-424	2025-01-07 19:17:04.535236+00	2025-01-14 19:17:04.535236+00	2025-01-16 19:17:04.535236+00	21.37	USD	Delivered	Paid	Order for Request for Printing Paper	2025-01-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
425	510	3	PO-2025-425	2025-01-07 19:17:04.535236+00	2025-01-14 19:17:04.535236+00	2025-01-13 19:17:04.535236+00	858.02	USD	Delivered	Paid	Order for Request for Filing Cabinet	2025-01-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
426	513	2	PO-2025-426	2025-02-16 19:17:04.535236+00	2025-02-21 19:17:04.535236+00	\N	13815.75	USD	Ordered	Pending	Order for Request for Bookshelf	2025-02-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
427	515	5	PO-2024-427	2024-05-31 19:17:04.535236+00	2024-06-02 19:17:04.535236+00	2024-06-03 19:17:04.535236+00	31.82	USD	Delivered	Pending	Order for Request for Pen Set	2024-05-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
428	516	5	PO-2025-428	2025-01-28 19:17:04.535236+00	2025-01-30 19:17:04.535236+00	2025-01-31 19:17:04.535236+00	104.00	USD	Delivered	Paid	Order for Request for Pen Set	2025-01-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
429	517	3	PO-2025-429	2025-04-13 19:17:04.535236+00	2025-04-20 19:17:04.535236+00	2025-04-19 19:17:04.535236+00	52.21	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-04-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
430	520	3	PO-2023-430	2023-01-25 19:17:04.535236+00	2023-02-01 19:17:04.535236+00	\N	1968.39	USD	Ordered	Pending	Order for Request for Office Chair	2023-01-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
431	522	3	PO-2022-431	2022-09-21 19:17:04.535236+00	2022-09-28 19:17:04.535236+00	\N	53.10	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2022-09-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
432	523	4	PO-2025-432	2025-04-09 19:17:04.535236+00	2025-04-13 19:17:04.535236+00	2025-04-14 19:17:04.535236+00	87.00	USD	Delivered	Paid	Order for Request for Notebook	2025-04-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
433	524	1	PO-2024-433	2024-07-10 19:17:04.535236+00	2024-07-13 19:17:04.535236+00	2024-07-11 19:17:04.535236+00	59.88	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-07-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
434	525	2	PO-2025-434	2025-04-06 19:17:04.535236+00	2025-04-11 19:17:04.535236+00	2025-04-13 19:17:04.535236+00	19.20	USD	Delivered	Pending	Order for Request for Notebook	2025-04-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
435	526	4	PO-2023-435	2023-05-03 19:17:04.535236+00	2023-05-07 19:17:04.535236+00	2023-05-05 19:17:04.535236+00	2198.50	USD	Delivered	Paid	Order for Request for Conference Table	2023-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
436	527	4	PO-2024-436	2024-10-10 19:17:04.535236+00	2024-10-14 19:17:04.535236+00	2024-10-16 19:17:04.535236+00	50.74	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-10-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
437	529	3	PO-2025-437	2025-03-19 19:17:04.535236+00	2025-03-26 19:17:04.535236+00	\N	225.42	USD	Shipped	Pending	Order for Request for Printing Paper	2025-03-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
438	530	5	PO-2025-438	2025-04-06 19:17:04.535236+00	2025-04-08 19:17:04.535236+00	\N	2079.44	USD	Shipped	Pending	Order for Request for Desk	2025-04-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
439	531	3	PO-2023-439	2023-02-07 19:17:04.535236+00	2023-02-14 19:17:04.535236+00	2023-02-15 19:17:04.535236+00	2496.54	USD	Delivered	Pending	Order for Request for Desk	2023-02-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
440	532	3	PO-2023-440	2023-01-08 19:17:04.535236+00	2023-01-15 19:17:04.535236+00	\N	96.71	USD	Ordered	Pending	Order for Request for Stapler	2023-01-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
441	534	2	PO-2025-441	2025-05-29 19:17:04.535236+00	2025-06-03 19:17:04.535236+00	2025-06-02 19:17:04.535236+00	10.72	USD	Delivered	Paid	Order for Request for Notebook	2025-05-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
442	535	3	PO-2024-442	2024-07-22 19:17:04.535236+00	2024-07-29 19:17:04.535236+00	2024-07-31 19:17:04.535236+00	50.10	USD	Delivered	Paid	Order for Request for Pen Set	2024-07-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
443	536	1	PO-2024-443	2024-12-26 19:17:04.535236+00	2024-12-29 19:17:04.535236+00	\N	114.20	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-12-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
444	538	4	PO-2025-444	2025-03-15 19:17:04.535236+00	2025-03-19 19:17:04.535236+00	\N	63.42	USD	Ordered	Pending	Order for Request for Sticky Notes	2025-03-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
445	539	4	PO-2023-445	2023-05-07 19:17:04.535236+00	2023-05-11 19:17:04.535236+00	2023-05-13 19:17:04.535236+00	37.18	USD	Delivered	Pending	Order for Request for Printing Paper	2023-05-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
446	540	4	PO-2024-446	2024-11-14 19:17:04.535236+00	2024-11-18 19:17:04.535236+00	2024-11-19 19:17:04.535236+00	86.18	USD	Delivered	Paid	Order for Request for Pen Set	2024-11-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
447	541	1	PO-2025-447	2025-01-02 19:17:04.535236+00	2025-01-05 19:17:04.535236+00	2025-01-05 19:17:04.535236+00	35.74	USD	Delivered	Pending	Order for Request for Printing Paper	2025-01-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
448	543	4	PO-2023-448	2023-12-29 19:17:04.535236+00	2024-01-02 19:17:04.535236+00	2023-12-31 19:17:04.535236+00	38.35	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-12-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
449	544	5	PO-2025-449	2025-04-30 19:17:04.535236+00	2025-05-02 19:17:04.535236+00	2025-05-04 19:17:04.535236+00	22.60	USD	Delivered	Paid	Order for Request for Notebook	2025-04-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
450	545	2	PO-2022-450	2022-04-13 19:17:04.535236+00	2022-04-18 19:17:04.535236+00	2022-04-20 19:17:04.535236+00	103.12	USD	Delivered	Paid	Order for Request for Keyboard	2022-04-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
451	546	4	PO-2025-451	2025-04-18 19:17:04.535236+00	2025-04-22 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	43.54	USD	Delivered	Pending	Order for Request for Notebook	2025-04-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
452	547	5	PO-2024-452	2024-03-11 19:17:04.535236+00	2024-03-13 19:17:04.535236+00	2024-03-15 19:17:04.535236+00	45.36	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-03-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
453	548	2	PO-2020-453	2020-09-23 19:17:04.535236+00	2020-09-28 19:17:04.535236+00	\N	186.92	USD	Cancelled	Cancelled	Order for Request for Notebook	2020-09-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
454	549	3	PO-2025-454	2025-01-27 19:17:04.535236+00	2025-02-03 19:17:04.535236+00	2025-02-02 19:17:04.535236+00	75.50	USD	Delivered	Pending	Order for Request for Notebook	2025-01-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
455	550	2	PO-2024-455	2024-05-14 19:17:04.535236+00	2024-05-19 19:17:04.535236+00	\N	27.72	USD	Cancelled	Cancelled	Order for Request for Pen Set	2024-05-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
456	551	2	PO-2022-456	2022-12-16 19:17:04.535236+00	2022-12-21 19:17:04.535236+00	2022-12-20 19:17:04.535236+00	13.03	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-12-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
457	552	1	PO-2024-457	2024-02-15 19:17:04.535236+00	2024-02-18 19:17:04.535236+00	2024-02-19 19:17:04.535236+00	2318.44	USD	Delivered	Pending	Order for Request for Bookshelf	2024-02-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
458	553	5	PO-2024-458	2024-07-22 19:17:04.535236+00	2024-07-24 19:17:04.535236+00	2024-07-26 19:17:04.535236+00	99.45	USD	Delivered	Paid	Order for Request for Stapler	2024-07-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
459	555	1	PO-2023-459	2023-03-22 19:17:04.535236+00	2023-03-25 19:17:04.535236+00	\N	16.95	USD	Cancelled	Cancelled	Order for Request for Printing Paper	2023-03-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
460	557	1	PO-2023-460	2023-08-03 19:17:04.535236+00	2023-08-06 19:17:04.535236+00	2023-08-06 19:17:04.535236+00	21.49	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-08-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
461	558	4	PO-2023-461	2023-03-10 19:17:04.535236+00	2023-03-14 19:17:04.535236+00	\N	78.65	USD	Shipped	Pending	Order for Request for Printing Paper	2023-03-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
462	559	1	PO-2025-462	2025-01-11 19:17:04.535236+00	2025-01-14 19:17:04.535236+00	2025-01-13 19:17:04.535236+00	459.29	USD	Delivered	Pending	Order for Request for Filing Cabinet	2025-01-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
463	560	5	PO-2020-463	2020-12-23 19:17:04.535236+00	2020-12-25 19:17:04.535236+00	2020-12-27 19:17:04.535236+00	36.05	USD	Delivered	Paid	Order for Request for Notebook	2020-12-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
464	562	2	PO-2023-464	2023-02-19 19:17:04.535236+00	2023-02-24 19:17:04.535236+00	2023-02-23 19:17:04.535236+00	73.82	USD	Delivered	Paid	Order for Request for Notebook	2023-02-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
465	563	2	PO-2024-465	2024-03-06 19:17:04.535236+00	2024-03-11 19:17:04.535236+00	2024-03-11 19:17:04.535236+00	93.10	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-03-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
466	564	5	PO-2020-466	2020-11-27 19:17:04.535236+00	2020-11-29 19:17:04.535236+00	2020-11-27 19:17:04.535236+00	109.20	USD	Delivered	Pending	Order for Request for Printing Paper	2020-11-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
467	566	3	PO-2021-467	2021-01-20 19:17:04.535236+00	2021-01-27 19:17:04.535236+00	2021-01-29 19:17:04.535236+00	3435.68	USD	Delivered	Paid	Order for Request for Office Chair	2021-01-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
468	567	1	PO-2023-468	2023-03-02 19:17:04.535236+00	2023-03-05 19:17:04.535236+00	2023-03-07 19:17:04.535236+00	29.13	USD	Delivered	Pending	Order for Request for Printing Paper	2023-03-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
469	569	2	PO-2023-469	2023-08-01 19:17:04.535236+00	2023-08-06 19:17:04.535236+00	2023-08-05 19:17:04.535236+00	170.02	USD	Delivered	Paid	Order for Request for Printing Paper	2023-08-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
470	570	2	PO-2025-470	2025-04-22 19:17:04.535236+00	2025-04-27 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	23.40	USD	Delivered	Paid	Order for Request for Pen Set	2025-04-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
471	572	5	PO-2022-471	2022-07-05 19:17:04.535236+00	2022-07-07 19:17:04.535236+00	2022-07-05 19:17:04.535236+00	7.29	USD	Delivered	Pending	Order for Request for Stapler	2022-07-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
472	573	4	PO-2024-472	2024-10-18 19:17:04.535236+00	2024-10-22 19:17:04.535236+00	2024-10-20 19:17:04.535236+00	85.10	USD	Delivered	Pending	Order for Request for Stapler	2024-10-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
473	574	1	PO-2025-473	2025-05-24 19:17:04.535236+00	2025-05-27 19:17:04.535236+00	2025-05-28 19:17:04.535236+00	394.16	USD	Delivered	Pending	Order for Request for Keyboard	2025-05-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
474	575	3	PO-2022-474	2022-09-16 19:17:04.535236+00	2022-09-23 19:17:04.535236+00	\N	775.31	USD	Ordered	Pending	Order for Request for Monitor	2022-09-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
475	576	2	PO-2024-475	2024-02-06 19:17:04.535236+00	2024-02-11 19:17:04.535236+00	\N	25.80	USD	Cancelled	Cancelled	Order for Request for Pen Set	2024-02-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
476	577	4	PO-2025-476	2025-04-19 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	\N	105.77	USD	Cancelled	Cancelled	Order for Request for Pen Set	2025-04-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
477	579	4	PO-2025-477	2025-05-13 19:17:04.535236+00	2025-05-17 19:17:04.535236+00	\N	3687.50	USD	Shipped	Pending	Order for Request for Monitor	2025-05-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
478	580	1	PO-2024-478	2024-06-15 19:17:04.535236+00	2024-06-18 19:17:04.535236+00	\N	16.10	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-06-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
479	581	2	PO-2024-479	2024-03-17 19:17:04.535236+00	2024-03-22 19:17:04.535236+00	\N	57.36	USD	Ordered	Pending	Order for Request for Notebook	2024-03-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
480	582	5	PO-2025-480	2025-04-17 19:17:04.535236+00	2025-04-19 19:17:04.535236+00	2025-04-20 19:17:04.535236+00	777.24	USD	Delivered	Paid	Order for Request for Filing Cabinet	2025-04-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
481	583	5	PO-2024-481	2024-11-14 19:17:04.535236+00	2024-11-16 19:17:04.535236+00	2024-11-15 19:17:04.535236+00	38.50	USD	Delivered	Paid	Order for Request for Stapler	2024-11-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
482	586	3	PO-2023-482	2023-12-25 19:17:04.535236+00	2024-01-01 19:17:04.535236+00	2023-12-30 19:17:04.535236+00	134.03	USD	Delivered	Pending	Order for Request for Desk	2023-12-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
483	587	3	PO-2024-483	2024-10-28 19:17:04.535236+00	2024-11-04 19:17:04.535236+00	2024-11-04 19:17:04.535236+00	714.36	USD	Delivered	Paid	Order for Request for Mouse	2024-10-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
484	589	5	PO-2024-484	2024-06-23 19:17:04.535236+00	2024-06-25 19:17:04.535236+00	2024-06-25 19:17:04.535236+00	1388.18	USD	Delivered	Pending	Order for Request for Conference Table	2024-06-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
485	590	4	PO-2023-485	2023-10-17 19:17:04.535236+00	2023-10-21 19:17:04.535236+00	2023-10-23 19:17:04.535236+00	97.75	USD	Delivered	Paid	Order for Request for Stapler	2023-10-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
486	591	3	PO-2023-486	2023-08-10 19:17:04.535236+00	2023-08-17 19:17:04.535236+00	2023-08-15 19:17:04.535236+00	74.94	USD	Delivered	Pending	Order for Request for Pen Set	2023-08-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
487	592	3	PO-2024-487	2024-09-18 19:17:04.535236+00	2024-09-25 19:17:04.535236+00	2024-09-24 19:17:04.535236+00	254.04	USD	Delivered	Paid	Order for Request for Monitor	2024-09-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
488	594	2	PO-2021-488	2021-12-05 19:17:04.535236+00	2021-12-10 19:17:04.535236+00	2021-12-11 19:17:04.535236+00	66.76	USD	Delivered	Pending	Order for Request for Pen Set	2021-12-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
489	595	5	PO-2024-489	2024-05-26 19:17:04.535236+00	2024-05-28 19:17:04.535236+00	\N	77.27	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-05-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
490	596	2	PO-2024-490	2024-07-21 19:17:04.535236+00	2024-07-26 19:17:04.535236+00	\N	2515.56	USD	Shipped	Pending	Order for Request for Bookshelf	2024-07-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
491	597	1	PO-2025-491	2025-01-24 19:17:04.535236+00	2025-01-27 19:17:04.535236+00	2025-01-27 19:17:04.535236+00	474.10	USD	Delivered	Paid	Order for Request for Filing Cabinet	2025-01-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
492	598	5	PO-2021-492	2021-12-19 19:17:04.535236+00	2021-12-21 19:17:04.535236+00	\N	27.38	USD	Shipped	Pending	Order for Request for Pen Set	2021-12-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
493	599	4	PO-2023-493	2023-12-14 19:17:04.535236+00	2023-12-18 19:17:04.535236+00	2023-12-17 19:17:04.535236+00	3541.57	USD	Delivered	Pending	Order for Request for Bookshelf	2023-12-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
494	600	3	PO-2023-494	2023-05-14 19:17:04.535236+00	2023-05-21 19:17:04.535236+00	\N	98.08	USD	Shipped	Pending	Order for Request for Pen Set	2023-05-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
495	601	3	PO-2025-495	2025-04-13 19:17:04.535236+00	2025-04-20 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	51.67	USD	Delivered	Paid	Order for Request for Stapler	2025-04-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
496	602	2	PO-2021-496	2021-04-21 19:17:04.535236+00	2021-04-26 19:17:04.535236+00	2021-04-25 19:17:04.535236+00	16.30	USD	Delivered	Pending	Order for Request for Stapler	2021-04-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
497	603	5	PO-2023-497	2023-10-21 19:17:04.535236+00	2023-10-23 19:17:04.535236+00	2023-10-25 19:17:04.535236+00	32.64	USD	Delivered	Pending	Order for Request for Pen Set	2023-10-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
498	604	5	PO-2023-498	2023-03-01 19:17:04.535236+00	2023-03-03 19:17:04.535236+00	2023-03-03 19:17:04.535236+00	55.26	USD	Delivered	Paid	Order for Request for Notebook	2023-03-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
499	606	4	PO-2025-499	2025-02-13 19:17:04.535236+00	2025-02-17 19:17:04.535236+00	2025-02-18 19:17:04.535236+00	3716.37	USD	Delivered	Pending	Order for Request for Keyboard	2025-02-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
500	607	1	PO-2025-500	2025-04-03 19:17:04.535236+00	2025-04-06 19:17:04.535236+00	2025-04-04 19:17:04.535236+00	5315.24	USD	Delivered	Paid	Order for Request for Desk	2025-04-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
501	608	2	PO-2023-501	2023-04-25 19:17:04.535236+00	2023-04-30 19:17:04.535236+00	2023-04-28 19:17:04.535236+00	70.76	USD	Delivered	Pending	Order for Request for Notebook	2023-04-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
502	609	5	PO-2024-502	2024-07-18 19:17:04.535236+00	2024-07-20 19:17:04.535236+00	2024-07-22 19:17:04.535236+00	42.51	USD	Delivered	Paid	Order for Request for Stapler	2024-07-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
503	610	5	PO-2023-503	2023-07-17 19:17:04.535236+00	2023-07-19 19:17:04.535236+00	2023-07-19 19:17:04.535236+00	105.00	USD	Delivered	Paid	Order for Request for Laptop	2023-07-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
504	612	1	PO-2025-504	2025-03-20 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	\N	222.02	USD	Ordered	Pending	Order for Request for Printing Paper	2025-03-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
505	613	2	PO-2022-505	2022-10-08 19:17:04.535236+00	2022-10-13 19:17:04.535236+00	2022-10-13 19:17:04.535236+00	5740.68	USD	Delivered	Paid	Order for Request for Desk	2022-10-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
506	616	1	PO-2024-506	2024-07-06 19:17:04.535236+00	2024-07-09 19:17:04.535236+00	2024-07-08 19:17:04.535236+00	2922.29	USD	Delivered	Pending	Order for Request for Headset	2024-07-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
507	618	1	PO-2022-507	2022-02-19 19:17:04.535236+00	2022-02-22 19:17:04.535236+00	\N	64.30	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2022-02-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
508	619	4	PO-2024-508	2024-04-26 19:17:04.535236+00	2024-04-30 19:17:04.535236+00	2024-04-28 19:17:04.535236+00	380.52	USD	Delivered	Pending	Order for Request for Mouse	2024-04-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
509	621	2	PO-2024-509	2024-11-04 19:17:04.535236+00	2024-11-09 19:17:04.535236+00	2024-11-10 19:17:04.535236+00	30.66	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-11-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
510	623	1	PO-2024-510	2024-02-08 19:17:04.535236+00	2024-02-11 19:17:04.535236+00	2024-02-13 19:17:04.535236+00	984.80	USD	Delivered	Paid	Order for Request for Desk	2024-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
511	624	2	PO-2024-511	2024-09-20 19:17:04.535236+00	2024-09-25 19:17:04.535236+00	\N	12.56	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-09-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
512	625	2	PO-2025-512	2025-02-06 19:17:04.535236+00	2025-02-11 19:17:04.535236+00	2025-02-12 19:17:04.535236+00	63.74	USD	Delivered	Pending	Order for Request for Printing Paper	2025-02-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
513	626	5	PO-2024-513	2024-05-26 19:17:04.535236+00	2024-05-28 19:17:04.535236+00	2024-05-27 19:17:04.535236+00	164.24	USD	Delivered	Paid	Order for Request for Notebook	2024-05-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
514	628	3	PO-2024-514	2024-05-01 19:17:04.535236+00	2024-05-08 19:17:04.535236+00	2024-05-09 19:17:04.535236+00	5408.99	USD	Delivered	Paid	Order for Request for Mouse	2024-05-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
515	629	3	PO-2024-515	2024-05-08 19:17:04.535236+00	2024-05-15 19:17:04.535236+00	2024-05-13 19:17:04.535236+00	16.62	USD	Delivered	Pending	Order for Request for Notebook	2024-05-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
516	630	4	PO-2024-516	2024-01-13 19:17:04.535236+00	2024-01-17 19:17:04.535236+00	\N	56.45	USD	Ordered	Pending	Order for Request for Pen Set	2024-01-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
517	631	2	PO-2022-517	2022-03-17 19:17:04.535236+00	2022-03-22 19:17:04.535236+00	2022-03-24 19:17:04.535236+00	20.01	USD	Delivered	Paid	Order for Request for Notebook	2022-03-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
518	632	3	PO-2023-518	2023-09-25 19:17:04.535236+00	2023-10-02 19:17:04.535236+00	2023-10-01 19:17:04.535236+00	19.13	USD	Delivered	Paid	Order for Request for Pen Set	2023-09-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
519	634	5	PO-2023-519	2023-01-08 19:17:04.535236+00	2023-01-10 19:17:04.535236+00	2023-01-09 19:17:04.535236+00	3239.18	USD	Delivered	Pending	Order for Request for Desk	2023-01-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
520	635	5	PO-2025-520	2025-05-17 19:17:04.535236+00	2025-05-19 19:17:04.535236+00	\N	36.03	USD	Shipped	Pending	Order for Request for Pen Set	2025-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
521	636	3	PO-2025-521	2025-04-12 19:17:04.535236+00	2025-04-19 19:17:04.535236+00	\N	1244.44	USD	Cancelled	Cancelled	Order for Request for Conference Table	2025-04-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
522	637	3	PO-2023-522	2023-10-15 19:17:04.535236+00	2023-10-22 19:17:04.535236+00	\N	147.67	USD	Ordered	Pending	Order for Request for Notebook	2023-10-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
523	638	1	PO-2022-523	2022-08-11 19:17:04.535236+00	2022-08-14 19:17:04.535236+00	2022-08-14 19:17:04.535236+00	3566.18	USD	Delivered	Pending	Order for Request for Office Chair	2022-08-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
524	639	5	PO-2025-524	2025-03-16 19:17:04.535236+00	2025-03-18 19:17:04.535236+00	\N	57.50	USD	Cancelled	Cancelled	Order for Request for Pen Set	2025-03-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
525	640	1	PO-2024-525	2024-10-19 19:17:04.535236+00	2024-10-22 19:17:04.535236+00	\N	972.81	USD	Cancelled	Cancelled	Order for Request for Mouse	2024-10-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
526	641	5	PO-2022-526	2022-10-11 19:17:04.535236+00	2022-10-13 19:17:04.535236+00	2022-10-11 19:17:04.535236+00	93.89	USD	Delivered	Paid	Order for Request for Stapler	2022-10-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
527	642	3	PO-2024-527	2024-06-25 19:17:04.535236+00	2024-07-02 19:17:04.535236+00	2024-06-30 19:17:04.535236+00	38.32	USD	Delivered	Paid	Order for Request for Stapler	2024-06-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
528	643	3	PO-2025-528	2025-05-28 19:17:04.535236+00	2025-06-04 19:17:04.535236+00	\N	150.63	USD	Shipped	Pending	Order for Request for Monitor	2025-05-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
529	644	1	PO-2023-529	2023-06-16 19:17:04.535236+00	2023-06-19 19:17:04.535236+00	\N	12746.93	USD	Cancelled	Cancelled	Order for Request for Filing Cabinet	2023-06-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
530	645	3	PO-2022-530	2022-10-13 19:17:04.535236+00	2022-10-20 19:17:04.535236+00	2022-10-22 19:17:04.535236+00	29.76	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-10-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
531	646	1	PO-2023-531	2023-01-26 19:17:04.535236+00	2023-01-29 19:17:04.535236+00	2023-01-28 19:17:04.535236+00	26.48	USD	Delivered	Pending	Order for Request for Printing Paper	2023-01-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
532	647	4	PO-2023-532	2023-01-01 19:17:04.535236+00	2023-01-05 19:17:04.535236+00	2023-01-03 19:17:04.535236+00	73.95	USD	Delivered	Pending	Order for Request for Sticky Notes	2023-01-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
533	649	2	PO-2024-533	2024-05-30 19:17:04.535236+00	2024-06-04 19:17:04.535236+00	\N	68.90	USD	Ordered	Pending	Order for Request for Printing Paper	2024-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
534	650	5	PO-2024-534	2024-11-23 19:17:04.535236+00	2024-11-25 19:17:04.535236+00	\N	120.02	USD	Shipped	Pending	Order for Request for Sticky Notes	2024-11-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
535	652	3	PO-2023-535	2023-09-30 19:17:04.535236+00	2023-10-07 19:17:04.535236+00	2023-10-06 19:17:04.535236+00	267.74	USD	Delivered	Paid	Order for Request for Headset	2023-09-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
536	654	1	PO-2021-536	2021-10-31 19:17:04.535236+00	2021-11-03 19:17:04.535236+00	2021-11-02 19:17:04.535236+00	37.62	USD	Delivered	Paid	Order for Request for Stapler	2021-10-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
537	655	3	PO-2024-537	2024-11-20 19:17:04.535236+00	2024-11-27 19:17:04.535236+00	\N	191.94	USD	Cancelled	Cancelled	Order for Request for Notebook	2024-11-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
538	656	2	PO-2024-538	2024-09-18 19:17:04.535236+00	2024-09-23 19:17:04.535236+00	\N	97.80	USD	Cancelled	Cancelled	Order for Request for Notebook	2024-09-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
539	657	1	PO-2020-539	2020-12-29 19:17:04.535236+00	2021-01-01 19:17:04.535236+00	2020-12-30 19:17:04.535236+00	72.15	USD	Delivered	Pending	Order for Request for Notebook	2020-12-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
540	659	2	PO-2025-540	2025-04-20 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	9.45	USD	Delivered	Pending	Order for Request for Pen Set	2025-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
541	661	2	PO-2024-541	2024-11-13 19:17:04.535236+00	2024-11-18 19:17:04.535236+00	2024-11-20 19:17:04.535236+00	33.60	USD	Delivered	Pending	Order for Request for Notebook	2024-11-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
542	662	1	PO-2025-542	2025-01-22 19:17:04.535236+00	2025-01-25 19:17:04.535236+00	\N	37.44	USD	Ordered	Pending	Order for Request for Pen Set	2025-01-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
543	663	4	PO-2022-543	2022-06-07 19:17:04.535236+00	2022-06-11 19:17:04.535236+00	2022-06-12 19:17:04.535236+00	20.16	USD	Delivered	Pending	Order for Request for Sticky Notes	2022-06-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
544	666	1	PO-2024-544	2024-01-31 19:17:04.535236+00	2024-02-03 19:17:04.535236+00	2024-02-02 19:17:04.535236+00	16.71	USD	Delivered	Paid	Order for Request for Stapler	2024-01-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
545	667	1	PO-2024-545	2024-09-21 19:17:04.535236+00	2024-09-24 19:17:04.535236+00	2024-09-22 19:17:04.535236+00	30.38	USD	Delivered	Paid	Order for Request for Pen Set	2024-09-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
546	668	4	PO-2025-546	2025-01-24 19:17:04.535236+00	2025-01-28 19:17:04.535236+00	2025-01-28 19:17:04.535236+00	31.68	USD	Delivered	Pending	Order for Request for Pen Set	2025-01-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
547	669	1	PO-2021-547	2021-04-17 19:17:04.535236+00	2021-04-20 19:17:04.535236+00	2021-04-22 19:17:04.535236+00	10.08	USD	Delivered	Paid	Order for Request for Sticky Notes	2021-04-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
548	670	5	PO-2025-548	2025-05-23 19:17:04.535236+00	2025-05-25 19:17:04.535236+00	\N	4351.69	USD	Ordered	Pending	Order for Request for Filing Cabinet	2025-05-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
549	671	2	PO-2024-549	2024-06-23 19:17:04.535236+00	2024-06-28 19:17:04.535236+00	2024-06-27 19:17:04.535236+00	27.66	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-06-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
550	672	1	PO-2025-550	2025-05-29 19:17:04.535236+00	2025-06-01 19:17:04.535236+00	2025-05-31 19:17:04.535236+00	3335.61	USD	Delivered	Paid	Order for Request for Desk	2025-05-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
551	675	1	PO-2024-551	2024-02-07 19:17:04.535236+00	2024-02-10 19:17:04.535236+00	2024-02-09 19:17:04.535236+00	47.34	USD	Delivered	Pending	Order for Request for Pen Set	2024-02-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
552	676	4	PO-2024-552	2024-12-25 19:17:04.535236+00	2024-12-29 19:17:04.535236+00	2024-12-29 19:17:04.535236+00	73.24	USD	Delivered	Paid	Order for Request for Printing Paper	2024-12-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
553	677	3	PO-2024-553	2024-07-07 19:17:04.535236+00	2024-07-14 19:17:04.535236+00	2024-07-15 19:17:04.535236+00	37.17	USD	Delivered	Paid	Order for Request for Pen Set	2024-07-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
554	678	4	PO-2025-554	2025-02-14 19:17:04.535236+00	2025-02-18 19:17:04.535236+00	2025-02-19 19:17:04.535236+00	136.86	USD	Delivered	Pending	Order for Request for Monitor	2025-02-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
555	679	2	PO-2024-555	2024-04-27 19:17:04.535236+00	2024-05-02 19:17:04.535236+00	\N	49.15	USD	Ordered	Pending	Order for Request for Printing Paper	2024-04-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
556	680	2	PO-2024-556	2024-03-21 19:17:04.535236+00	2024-03-26 19:17:04.535236+00	\N	26.30	USD	Ordered	Pending	Order for Request for Printing Paper	2024-03-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
557	681	3	PO-2024-557	2024-11-01 19:17:04.535236+00	2024-11-08 19:17:04.535236+00	2024-11-10 19:17:04.535236+00	219.42	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-11-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
558	683	1	PO-2025-558	2025-01-16 19:17:04.535236+00	2025-01-19 19:17:04.535236+00	2025-01-20 19:17:04.535236+00	1829.08	USD	Delivered	Pending	Order for Request for Filing Cabinet	2025-01-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
559	684	5	PO-2024-559	2024-07-10 19:17:04.535236+00	2024-07-12 19:17:04.535236+00	\N	46.00	USD	Shipped	Pending	Order for Request for Notebook	2024-07-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
560	685	3	PO-2024-560	2024-01-25 19:17:04.535236+00	2024-02-01 19:17:04.535236+00	2024-02-01 19:17:04.535236+00	1638.40	USD	Delivered	Paid	Order for Request for Desk	2024-01-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
561	686	5	PO-2024-561	2024-12-20 19:17:04.535236+00	2024-12-22 19:17:04.535236+00	2024-12-23 19:17:04.535236+00	31.40	USD	Delivered	Pending	Order for Request for Printing Paper	2024-12-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
562	687	3	PO-2025-562	2025-05-19 19:17:04.535236+00	2025-05-26 19:17:04.535236+00	\N	28.20	USD	Cancelled	Cancelled	Order for Request for Notebook	2025-05-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
563	688	5	PO-2024-563	2024-12-14 19:17:04.535236+00	2024-12-16 19:17:04.535236+00	\N	55.36	USD	Cancelled	Cancelled	Order for Request for Sticky Notes	2024-12-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
564	689	1	PO-2025-564	2025-03-30 19:17:04.535236+00	2025-04-02 19:17:04.535236+00	\N	74.75	USD	Cancelled	Cancelled	Order for Request for Notebook	2025-03-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
565	690	3	PO-2025-565	2025-05-08 19:17:04.535236+00	2025-05-15 19:17:04.535236+00	\N	435.57	USD	Cancelled	Cancelled	Order for Request for Office Chair	2025-05-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
566	691	2	PO-2025-566	2025-04-07 19:17:04.535236+00	2025-04-12 19:17:04.535236+00	2025-04-11 19:17:04.535236+00	1654.52	USD	Delivered	Paid	Order for Request for Conference Table	2025-04-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
567	692	4	PO-2023-567	2023-05-22 19:17:04.535236+00	2023-05-26 19:17:04.535236+00	2023-05-28 19:17:04.535236+00	201.74	USD	Delivered	Paid	Order for Request for Office Chair	2023-05-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
568	693	4	PO-2023-568	2023-08-03 19:17:04.535236+00	2023-08-07 19:17:04.535236+00	2023-08-05 19:17:04.535236+00	10.65	USD	Delivered	Paid	Order for Request for Notebook	2023-08-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
569	694	1	PO-2023-569	2023-08-12 19:17:04.535236+00	2023-08-15 19:17:04.535236+00	2023-08-17 19:17:04.535236+00	734.01	USD	Delivered	Pending	Order for Request for Bookshelf	2023-08-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
570	696	5	PO-2024-570	2024-02-01 19:17:04.535236+00	2024-02-03 19:17:04.535236+00	\N	61.10	USD	Shipped	Pending	Order for Request for Sticky Notes	2024-02-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
571	697	4	PO-2024-571	2024-05-30 19:17:04.535236+00	2024-06-03 19:17:04.535236+00	2024-06-01 19:17:04.535236+00	421.04	USD	Delivered	Pending	Order for Request for Conference Table	2024-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
572	700	2	PO-2022-572	2022-12-04 19:17:04.535236+00	2022-12-09 19:17:04.535236+00	\N	38.12	USD	Shipped	Pending	Order for Request for Stapler	2022-12-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
573	701	3	PO-2024-573	2024-04-22 19:17:04.535236+00	2024-04-29 19:17:04.535236+00	\N	7007.31	USD	Shipped	Pending	Order for Request for Keyboard	2024-04-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
574	702	5	PO-2024-574	2024-05-17 19:17:04.535236+00	2024-05-19 19:17:04.535236+00	2024-05-18 19:17:04.535236+00	4.03	USD	Delivered	Paid	Order for Request for Stapler	2024-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
575	703	4	PO-2025-575	2025-04-18 19:17:04.535236+00	2025-04-22 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	1018.02	USD	Delivered	Pending	Order for Request for Desk	2025-04-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
576	704	1	PO-2022-576	2022-08-06 19:17:04.535236+00	2022-08-09 19:17:04.535236+00	2022-08-07 19:17:04.535236+00	66.92	USD	Delivered	Pending	Order for Request for Printing Paper	2022-08-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
577	705	3	PO-2024-577	2024-02-11 19:17:04.535236+00	2024-02-18 19:17:04.535236+00	\N	47.40	USD	Ordered	Pending	Order for Request for Pen Set	2024-02-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
578	707	3	PO-2023-578	2023-06-13 19:17:04.535236+00	2023-06-20 19:17:04.535236+00	2023-06-20 19:17:04.535236+00	4028.88	USD	Delivered	Paid	Order for Request for Filing Cabinet	2023-06-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
579	708	2	PO-2025-579	2025-04-11 19:17:04.535236+00	2025-04-16 19:17:04.535236+00	2025-04-14 19:17:04.535236+00	18.99	USD	Delivered	Paid	Order for Request for Printing Paper	2025-04-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
580	709	5	PO-2023-580	2023-05-04 19:17:04.535236+00	2023-05-06 19:17:04.535236+00	2023-05-08 19:17:04.535236+00	42.08	USD	Delivered	Pending	Order for Request for Stapler	2023-05-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
581	710	1	PO-2022-581	2022-06-17 19:17:04.535236+00	2022-06-20 19:17:04.535236+00	\N	3069.27	USD	Shipped	Pending	Order for Request for Office Chair	2022-06-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
582	711	1	PO-2025-582	2025-05-15 19:17:04.535236+00	2025-05-18 19:17:04.535236+00	2025-05-20 19:17:04.535236+00	1496.36	USD	Delivered	Paid	Order for Request for Mouse	2025-05-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
583	712	3	PO-2022-583	2022-12-15 19:17:04.535236+00	2022-12-22 19:17:04.535236+00	2022-12-24 19:17:04.535236+00	89.57	USD	Delivered	Pending	Order for Request for Printing Paper	2022-12-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
584	713	4	PO-2025-584	2025-05-14 19:17:04.535236+00	2025-05-18 19:17:04.535236+00	2025-05-19 19:17:04.535236+00	9.14	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-05-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
585	714	2	PO-2022-585	2022-11-28 19:17:04.535236+00	2022-12-03 19:17:04.535236+00	\N	5031.28	USD	Cancelled	Cancelled	Order for Request for Keyboard	2022-11-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
586	715	4	PO-2022-586	2022-08-07 19:17:04.535236+00	2022-08-11 19:17:04.535236+00	\N	28.63	USD	Cancelled	Cancelled	Order for Request for Notebook	2022-08-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
587	716	5	PO-2023-587	2023-07-02 19:17:04.535236+00	2023-07-04 19:17:04.535236+00	2023-07-02 19:17:04.535236+00	1660.76	USD	Delivered	Pending	Order for Request for Filing Cabinet	2023-07-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
588	717	5	PO-2024-588	2024-07-25 19:17:04.535236+00	2024-07-27 19:17:04.535236+00	\N	8545.49	USD	Cancelled	Cancelled	Order for Request for Keyboard	2024-07-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
589	718	2	PO-2024-589	2024-04-03 19:17:04.535236+00	2024-04-08 19:17:04.535236+00	2024-04-07 19:17:04.535236+00	41.63	USD	Delivered	Pending	Order for Request for Stapler	2024-04-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
590	719	5	PO-2024-590	2024-10-12 19:17:04.535236+00	2024-10-14 19:17:04.535236+00	\N	255.52	USD	Ordered	Pending	Order for Request for Keyboard	2024-10-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
591	720	5	PO-2025-591	2025-04-20 19:17:04.535236+00	2025-04-22 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	127.22	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
592	721	4	PO-2024-592	2024-10-30 19:17:04.535236+00	2024-11-03 19:17:04.535236+00	2024-11-05 19:17:04.535236+00	5.98	USD	Delivered	Paid	Order for Request for Notebook	2024-10-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
593	722	5	PO-2022-593	2022-01-27 19:17:04.535236+00	2022-01-29 19:17:04.535236+00	2022-01-31 19:17:04.535236+00	166.16	USD	Delivered	Pending	Order for Request for Monitor	2022-01-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
594	723	3	PO-2023-594	2023-11-29 19:17:04.535236+00	2023-12-06 19:17:04.535236+00	2023-12-07 19:17:04.535236+00	44.23	USD	Delivered	Paid	Order for Request for Notebook	2023-11-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
595	724	3	PO-2025-595	2025-02-23 19:17:04.535236+00	2025-03-02 19:17:04.535236+00	2025-03-01 19:17:04.535236+00	71.70	USD	Delivered	Paid	Order for Request for Printing Paper	2025-02-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
596	727	1	PO-2024-596	2024-06-08 19:17:04.535236+00	2024-06-11 19:17:04.535236+00	2024-06-12 19:17:04.535236+00	74.30	USD	Delivered	Pending	Order for Request for Printing Paper	2024-06-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
597	728	3	PO-2023-597	2023-03-06 19:17:04.535236+00	2023-03-13 19:17:04.535236+00	2023-03-11 19:17:04.535236+00	2699.06	USD	Delivered	Pending	Order for Request for Filing Cabinet	2023-03-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
598	729	2	PO-2023-598	2023-01-15 19:17:04.535236+00	2023-01-20 19:17:04.535236+00	\N	117.27	USD	Cancelled	Cancelled	Order for Request for Desk	2023-01-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
599	730	3	PO-2024-599	2024-12-16 19:17:04.535236+00	2024-12-23 19:17:04.535236+00	2024-12-24 19:17:04.535236+00	12210.86	USD	Delivered	Paid	Order for Request for Desk	2024-12-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
600	731	1	PO-2023-600	2023-07-23 19:17:04.535236+00	2023-07-26 19:17:04.535236+00	2023-07-25 19:17:04.535236+00	93.64	USD	Delivered	Pending	Order for Request for Pen Set	2023-07-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
601	732	2	PO-2023-601	2023-06-05 19:17:04.535236+00	2023-06-10 19:17:04.535236+00	\N	51.08	USD	Cancelled	Cancelled	Order for Request for Pen Set	2023-06-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
602	734	5	PO-2024-602	2024-04-06 19:17:04.535236+00	2024-04-08 19:17:04.535236+00	2024-04-08 19:17:04.535236+00	4118.88	USD	Delivered	Paid	Order for Request for Mouse	2024-04-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
603	735	2	PO-2025-603	2025-01-02 19:17:04.535236+00	2025-01-07 19:17:04.535236+00	2025-01-08 19:17:04.535236+00	10776.53	USD	Delivered	Paid	Order for Request for Conference Table	2025-01-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
604	736	3	PO-2021-604	2021-05-28 19:17:04.535236+00	2021-06-04 19:17:04.535236+00	2021-06-03 19:17:04.535236+00	90.87	USD	Delivered	Pending	Order for Request for Mouse	2021-05-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
605	737	4	PO-2024-605	2024-06-13 19:17:04.535236+00	2024-06-17 19:17:04.535236+00	2024-06-18 19:17:04.535236+00	62.46	USD	Delivered	Pending	Order for Request for Sticky Notes	2024-06-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
606	738	3	PO-2025-606	2025-05-30 19:17:04.535236+00	2025-06-06 19:17:04.535236+00	2025-06-07 19:17:04.535236+00	984.50	USD	Delivered	Pending	Order for Request for Conference Table	2025-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
607	739	5	PO-2024-607	2024-08-05 19:17:04.535236+00	2024-08-07 19:17:04.535236+00	2024-08-05 19:17:04.535236+00	17.62	USD	Delivered	Pending	Order for Request for Notebook	2024-08-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
608	741	3	PO-2021-608	2021-12-09 19:17:04.535236+00	2021-12-16 19:17:04.535236+00	2021-12-18 19:17:04.535236+00	31.07	USD	Delivered	Pending	Order for Request for Pen Set	2021-12-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
609	742	2	PO-2024-609	2024-10-18 19:17:04.535236+00	2024-10-23 19:17:04.535236+00	2024-10-23 19:17:04.535236+00	67.63	USD	Delivered	Pending	Order for Request for Stapler	2024-10-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
610	743	1	PO-2024-610	2024-06-06 19:17:04.535236+00	2024-06-09 19:17:04.535236+00	2024-06-09 19:17:04.535236+00	1703.77	USD	Delivered	Paid	Order for Request for Bookshelf	2024-06-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
611	745	5	PO-2024-611	2024-07-31 19:17:04.535236+00	2024-08-02 19:17:04.535236+00	2024-08-01 19:17:04.535236+00	53.54	USD	Delivered	Pending	Order for Request for Notebook	2024-07-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
612	746	3	PO-2024-612	2024-03-23 19:17:04.535236+00	2024-03-30 19:17:04.535236+00	2024-03-31 19:17:04.535236+00	2729.04	USD	Delivered	Paid	Order for Request for Filing Cabinet	2024-03-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
613	747	4	PO-2024-613	2024-10-22 19:17:04.535236+00	2024-10-26 19:17:04.535236+00	2024-10-27 19:17:04.535236+00	30.00	USD	Delivered	Pending	Order for Request for Stapler	2024-10-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
614	748	2	PO-2024-614	2024-10-20 19:17:04.535236+00	2024-10-25 19:17:04.535236+00	\N	51.38	USD	Ordered	Pending	Order for Request for Stapler	2024-10-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
615	749	1	PO-2024-615	2024-09-17 19:17:04.535236+00	2024-09-20 19:17:04.535236+00	\N	50.08	USD	Cancelled	Cancelled	Order for Request for Stapler	2024-09-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
616	750	2	PO-2024-616	2024-08-14 19:17:04.535236+00	2024-08-19 19:17:04.535236+00	2024-08-17 19:17:04.535236+00	22.35	USD	Delivered	Paid	Order for Request for Pen Set	2024-08-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
617	751	1	PO-2024-617	2024-09-01 19:17:04.535236+00	2024-09-04 19:17:04.535236+00	\N	15.45	USD	Cancelled	Cancelled	Order for Request for Stapler	2024-09-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
618	752	1	PO-2022-618	2022-02-07 19:17:04.535236+00	2022-02-10 19:17:04.535236+00	2022-02-08 19:17:04.535236+00	47.60	USD	Delivered	Pending	Order for Request for Notebook	2022-02-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
619	753	1	PO-2025-619	2025-04-08 19:17:04.535236+00	2025-04-11 19:17:04.535236+00	2025-04-11 19:17:04.535236+00	6.69	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-04-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
620	755	2	PO-2024-620	2024-04-10 19:17:04.535236+00	2024-04-15 19:17:04.535236+00	2024-04-15 19:17:04.535236+00	191.37	USD	Delivered	Paid	Order for Request for Pen Set	2024-04-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
621	756	1	PO-2024-621	2024-06-13 19:17:04.535236+00	2024-06-16 19:17:04.535236+00	\N	1981.43	USD	Cancelled	Cancelled	Order for Request for Desk	2024-06-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
622	757	2	PO-2024-622	2024-04-10 19:17:04.535236+00	2024-04-15 19:17:04.535236+00	2024-04-16 19:17:04.535236+00	113.52	USD	Delivered	Paid	Order for Request for Mouse	2024-04-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
623	758	2	PO-2023-623	2023-08-14 19:17:04.535236+00	2023-08-19 19:17:04.535236+00	\N	49.80	USD	Shipped	Pending	Order for Request for Printing Paper	2023-08-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
624	759	1	PO-2023-624	2023-07-14 19:17:04.535236+00	2023-07-17 19:17:04.535236+00	\N	743.49	USD	Ordered	Pending	Order for Request for Office Chair	2023-07-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
625	760	1	PO-2023-625	2023-11-29 19:17:04.535236+00	2023-12-02 19:17:04.535236+00	\N	401.20	USD	Shipped	Pending	Order for Request for Keyboard	2023-11-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
626	761	5	PO-2025-626	2025-03-10 19:17:04.535236+00	2025-03-12 19:17:04.535236+00	\N	21.38	USD	Ordered	Pending	Order for Request for Sticky Notes	2025-03-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
627	762	4	PO-2022-627	2022-06-19 19:17:04.535236+00	2022-06-23 19:17:04.535236+00	\N	37.92	USD	Ordered	Pending	Order for Request for Notebook	2022-06-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
628	763	5	PO-2024-628	2024-08-14 19:17:04.535236+00	2024-08-16 19:17:04.535236+00	2024-08-17 19:17:04.535236+00	2829.64	USD	Delivered	Pending	Order for Request for Keyboard	2024-08-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
629	764	4	PO-2024-629	2024-11-02 19:17:04.535236+00	2024-11-06 19:17:04.535236+00	2024-11-04 19:17:04.535236+00	195.76	USD	Delivered	Pending	Order for Request for Headset	2024-11-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
630	765	4	PO-2022-630	2022-05-01 19:17:04.535236+00	2022-05-05 19:17:04.535236+00	2022-05-07 19:17:04.535236+00	1750.35	USD	Delivered	Paid	Order for Request for Conference Table	2022-05-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
631	766	4	PO-2025-631	2025-03-08 19:17:04.535236+00	2025-03-12 19:17:04.535236+00	2025-03-12 19:17:04.535236+00	10.30	USD	Delivered	Paid	Order for Request for Stapler	2025-03-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
632	767	2	PO-2025-632	2025-03-02 19:17:04.535236+00	2025-03-07 19:17:04.535236+00	2025-03-07 19:17:04.535236+00	65.17	USD	Delivered	Pending	Order for Request for Sticky Notes	2025-03-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
633	768	4	PO-2023-633	2023-03-23 19:17:04.535236+00	2023-03-27 19:17:04.535236+00	2023-03-25 19:17:04.535236+00	43.32	USD	Delivered	Paid	Order for Request for Printing Paper	2023-03-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
634	769	3	PO-2025-634	2025-05-30 19:17:04.535236+00	2025-06-06 19:17:04.535236+00	\N	169.20	USD	Shipped	Pending	Order for Request for Stapler	2025-05-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
635	771	1	PO-2025-635	2025-05-06 19:17:04.535236+00	2025-05-09 19:17:04.535236+00	2025-05-08 19:17:04.535236+00	44.66	USD	Delivered	Pending	Order for Request for Stapler	2025-05-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
636	772	4	PO-2022-636	2022-04-11 19:17:04.535236+00	2022-04-15 19:17:04.535236+00	2022-04-17 19:17:04.535236+00	409.64	USD	Delivered	Pending	Order for Request for Laptop	2022-04-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
637	774	5	PO-2024-637	2024-12-05 19:17:04.535236+00	2024-12-07 19:17:04.535236+00	2024-12-09 19:17:04.535236+00	23.40	USD	Delivered	Paid	Order for Request for Notebook	2024-12-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
638	775	4	PO-2025-638	2025-04-01 19:17:04.535236+00	2025-04-05 19:17:04.535236+00	\N	1185.12	USD	Ordered	Pending	Order for Request for Laptop	2025-04-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
639	776	3	PO-2024-639	2024-02-05 19:17:04.535236+00	2024-02-12 19:17:04.535236+00	2024-02-14 19:17:04.535236+00	34.33	USD	Delivered	Paid	Order for Request for Printing Paper	2024-02-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
640	778	2	PO-2025-640	2025-04-11 19:17:04.535236+00	2025-04-16 19:17:04.535236+00	2025-04-14 19:17:04.535236+00	861.08	USD	Delivered	Pending	Order for Request for Office Chair	2025-04-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
641	781	4	PO-2025-641	2025-04-05 19:17:04.535236+00	2025-04-09 19:17:04.535236+00	\N	52.51	USD	Ordered	Pending	Order for Request for Stapler	2025-04-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
642	782	3	PO-2025-642	2025-03-30 19:17:04.535236+00	2025-04-06 19:17:04.535236+00	2025-04-05 19:17:04.535236+00	25.92	USD	Delivered	Pending	Order for Request for Stapler	2025-03-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
643	784	1	PO-2022-643	2022-11-15 19:17:04.535236+00	2022-11-18 19:17:04.535236+00	2022-11-20 19:17:04.535236+00	51.60	USD	Delivered	Pending	Order for Request for Notebook	2022-11-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
644	785	2	PO-2022-644	2022-03-31 19:17:04.535236+00	2022-04-05 19:17:04.535236+00	\N	38.87	USD	Ordered	Pending	Order for Request for Sticky Notes	2022-03-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
645	786	4	PO-2024-645	2024-03-31 19:17:04.535236+00	2024-04-04 19:17:04.535236+00	2024-04-05 19:17:04.535236+00	8.62	USD	Delivered	Pending	Order for Request for Pen Set	2024-03-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
646	787	4	PO-2024-646	2024-04-02 19:17:04.535236+00	2024-04-06 19:17:04.535236+00	2024-04-04 19:17:04.535236+00	132.83	USD	Delivered	Paid	Order for Request for Stapler	2024-04-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
647	788	3	PO-2025-647	2025-05-23 19:17:04.535236+00	2025-05-30 19:17:04.535236+00	2025-05-28 19:17:04.535236+00	19.32	USD	Delivered	Paid	Order for Request for Stapler	2025-05-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
648	789	5	PO-2025-648	2025-02-06 19:17:04.535236+00	2025-02-08 19:17:04.535236+00	2025-02-06 19:17:04.535236+00	1169.45	USD	Delivered	Paid	Order for Request for Mouse	2025-02-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
649	790	1	PO-2024-649	2024-03-27 19:17:04.535236+00	2024-03-30 19:17:04.535236+00	2024-03-29 19:17:04.535236+00	96.14	USD	Delivered	Paid	Order for Request for Printing Paper	2024-03-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
650	791	1	PO-2025-650	2025-03-04 19:17:04.535236+00	2025-03-07 19:17:04.535236+00	2025-03-08 19:17:04.535236+00	762.53	USD	Delivered	Paid	Order for Request for Mouse	2025-03-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
651	792	2	PO-2024-651	2024-09-05 19:17:04.535236+00	2024-09-10 19:17:04.535236+00	2024-09-12 19:17:04.535236+00	162.95	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-09-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
652	793	5	PO-2025-652	2025-05-29 19:17:04.535236+00	2025-05-31 19:17:04.535236+00	\N	18.90	USD	Ordered	Pending	Order for Request for Sticky Notes	2025-05-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
653	794	4	PO-2024-653	2024-06-06 19:17:04.535236+00	2024-06-10 19:17:04.535236+00	2024-06-10 19:17:04.535236+00	515.19	USD	Delivered	Paid	Order for Request for Keyboard	2024-06-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
654	795	4	PO-2023-654	2023-10-21 19:17:04.535236+00	2023-10-25 19:17:04.535236+00	2023-10-23 19:17:04.535236+00	207.38	USD	Delivered	Paid	Order for Request for Stapler	2023-10-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
655	796	3	PO-2023-655	2023-08-20 19:17:04.535236+00	2023-08-27 19:17:04.535236+00	2023-08-25 19:17:04.535236+00	117.90	USD	Delivered	Paid	Order for Request for Notebook	2023-08-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
656	797	4	PO-2025-656	2025-05-19 19:17:04.535236+00	2025-05-23 19:17:04.535236+00	2025-05-21 19:17:04.535236+00	88.41	USD	Delivered	Pending	Order for Request for Stapler	2025-05-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
657	798	4	PO-2025-657	2025-01-18 19:17:04.535236+00	2025-01-22 19:17:04.535236+00	\N	89.44	USD	Shipped	Pending	Order for Request for Printing Paper	2025-01-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
658	799	1	PO-2025-658	2025-04-15 19:17:04.535236+00	2025-04-18 19:17:04.535236+00	\N	4527.37	USD	Shipped	Pending	Order for Request for Monitor	2025-04-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
659	800	2	PO-2025-659	2025-04-30 19:17:04.535236+00	2025-05-05 19:17:04.535236+00	2025-05-07 19:17:04.535236+00	75.85	USD	Delivered	Paid	Order for Request for Pen Set	2025-04-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
660	801	2	PO-2022-660	2022-10-03 19:17:04.535236+00	2022-10-08 19:17:04.535236+00	\N	2231.06	USD	Cancelled	Cancelled	Order for Request for Desk	2022-10-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
661	802	4	PO-2023-661	2023-02-25 19:17:04.535236+00	2023-03-01 19:17:04.535236+00	2023-02-28 19:17:04.535236+00	45.75	USD	Delivered	Pending	Order for Request for Sticky Notes	2023-02-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
662	803	3	PO-2024-662	2024-05-10 19:17:04.535236+00	2024-05-17 19:17:04.535236+00	2024-05-15 19:17:04.535236+00	953.75	USD	Delivered	Pending	Order for Request for Monitor	2024-05-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
663	804	2	PO-2022-663	2022-10-08 19:17:04.535236+00	2022-10-13 19:17:04.535236+00	2022-10-14 19:17:04.535236+00	47.00	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-10-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
664	805	2	PO-2024-664	2024-09-12 19:17:04.535236+00	2024-09-17 19:17:04.535236+00	2024-09-16 19:17:04.535236+00	1042.96	USD	Delivered	Pending	Order for Request for Office Chair	2024-09-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
665	806	4	PO-2024-665	2024-06-20 19:17:04.535236+00	2024-06-24 19:17:04.535236+00	2024-06-25 19:17:04.535236+00	25.48	USD	Delivered	Pending	Order for Request for Notebook	2024-06-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
666	807	5	PO-2023-666	2023-02-19 19:17:04.535236+00	2023-02-21 19:17:04.535236+00	2023-02-21 19:17:04.535236+00	34.66	USD	Delivered	Paid	Order for Request for Stapler	2023-02-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
667	809	4	PO-2024-667	2024-05-11 19:17:04.535236+00	2024-05-15 19:17:04.535236+00	\N	76.20	USD	Shipped	Pending	Order for Request for Pen Set	2024-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
668	811	2	PO-2023-668	2023-03-26 19:17:04.535236+00	2023-03-31 19:17:04.535236+00	2023-04-02 19:17:04.535236+00	7637.49	USD	Delivered	Pending	Order for Request for Office Chair	2023-03-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
669	812	4	PO-2023-669	2023-09-01 19:17:04.535236+00	2023-09-05 19:17:04.535236+00	2023-09-03 19:17:04.535236+00	41.34	USD	Delivered	Pending	Order for Request for Stapler	2023-09-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
670	813	4	PO-2022-670	2022-11-16 19:17:04.535236+00	2022-11-20 19:17:04.535236+00	2022-11-20 19:17:04.535236+00	84.04	USD	Delivered	Pending	Order for Request for Printing Paper	2022-11-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
671	814	5	PO-2024-671	2024-07-09 19:17:04.535236+00	2024-07-11 19:17:04.535236+00	2024-07-09 19:17:04.535236+00	21.52	USD	Delivered	Paid	Order for Request for Printing Paper	2024-07-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
672	815	3	PO-2022-672	2022-07-19 19:17:04.535236+00	2022-07-26 19:17:04.535236+00	2022-07-28 19:17:04.535236+00	338.88	USD	Delivered	Pending	Order for Request for Conference Table	2022-07-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
673	816	2	PO-2023-673	2023-01-27 19:17:04.535236+00	2023-02-01 19:17:04.535236+00	2023-01-30 19:17:04.535236+00	37.83	USD	Delivered	Pending	Order for Request for Notebook	2023-01-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
674	818	3	PO-2024-674	2024-01-31 19:17:04.535236+00	2024-02-07 19:17:04.535236+00	\N	84.56	USD	Cancelled	Cancelled	Order for Request for Pen Set	2024-01-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
675	820	4	PO-2025-675	2025-05-18 19:17:04.535236+00	2025-05-22 19:17:04.535236+00	2025-05-22 19:17:04.535236+00	1661.12	USD	Delivered	Paid	Order for Request for Keyboard	2025-05-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
676	821	2	PO-2024-676	2024-07-24 19:17:04.535236+00	2024-07-29 19:17:04.535236+00	2024-07-28 19:17:04.535236+00	570.35	USD	Delivered	Pending	Order for Request for Headset	2024-07-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
677	822	1	PO-2025-677	2025-02-09 19:17:04.535236+00	2025-02-12 19:17:04.535236+00	2025-02-11 19:17:04.535236+00	607.24	USD	Delivered	Pending	Order for Request for Desk	2025-02-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
678	823	1	PO-2025-678	2025-05-23 19:17:04.535236+00	2025-05-26 19:17:04.535236+00	2025-05-24 19:17:04.535236+00	712.86	USD	Delivered	Paid	Order for Request for Office Chair	2025-05-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
679	824	1	PO-2023-679	2023-10-08 19:17:04.535236+00	2023-10-11 19:17:04.535236+00	2023-10-09 19:17:04.535236+00	1330.46	USD	Delivered	Pending	Order for Request for Bookshelf	2023-10-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
680	825	5	PO-2023-680	2023-12-31 19:17:04.535236+00	2024-01-02 19:17:04.535236+00	2024-01-01 19:17:04.535236+00	213.50	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-12-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
681	826	4	PO-2025-681	2025-04-14 19:17:04.535236+00	2025-04-18 19:17:04.535236+00	2025-04-16 19:17:04.535236+00	42.80	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-04-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
682	828	3	PO-2024-682	2024-05-03 19:17:04.535236+00	2024-05-10 19:17:04.535236+00	2024-05-11 19:17:04.535236+00	596.82	USD	Delivered	Pending	Order for Request for Keyboard	2024-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
683	829	4	PO-2022-683	2022-01-22 19:17:04.535236+00	2022-01-26 19:17:04.535236+00	2022-01-24 19:17:04.535236+00	3730.88	USD	Delivered	Paid	Order for Request for Conference Table	2022-01-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
684	830	4	PO-2025-684	2025-03-25 19:17:04.535236+00	2025-03-29 19:17:04.535236+00	2025-03-29 19:17:04.535236+00	55.41	USD	Delivered	Pending	Order for Request for Stapler	2025-03-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
685	831	3	PO-2025-685	2025-02-14 19:17:04.535236+00	2025-02-21 19:17:04.535236+00	2025-02-22 19:17:04.535236+00	119.99	USD	Delivered	Paid	Order for Request for Pen Set	2025-02-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
686	832	3	PO-2024-686	2024-10-23 19:17:04.535236+00	2024-10-30 19:17:04.535236+00	\N	17.31	USD	Ordered	Pending	Order for Request for Pen Set	2024-10-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
687	833	1	PO-2024-687	2024-10-19 19:17:04.535236+00	2024-10-22 19:17:04.535236+00	\N	25.67	USD	Shipped	Pending	Order for Request for Pen Set	2024-10-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
688	834	2	PO-2024-688	2024-04-20 19:17:04.535236+00	2024-04-25 19:17:04.535236+00	\N	202.99	USD	Ordered	Pending	Order for Request for Pen Set	2024-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
689	836	5	PO-2025-689	2025-04-23 19:17:04.535236+00	2025-04-25 19:17:04.535236+00	2025-04-27 19:17:04.535236+00	44.14	USD	Delivered	Pending	Order for Request for Stapler	2025-04-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
690	837	1	PO-2023-690	2023-12-05 19:17:04.535236+00	2023-12-08 19:17:04.535236+00	2023-12-09 19:17:04.535236+00	128.78	USD	Delivered	Pending	Order for Request for Printing Paper	2023-12-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
691	838	4	PO-2024-691	2024-07-12 19:17:04.535236+00	2024-07-16 19:17:04.535236+00	\N	14.15	USD	Cancelled	Cancelled	Order for Request for Notebook	2024-07-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
692	840	5	PO-2025-692	2025-01-29 19:17:04.535236+00	2025-01-31 19:17:04.535236+00	2025-01-31 19:17:04.535236+00	108.15	USD	Delivered	Paid	Order for Request for Notebook	2025-01-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
693	841	5	PO-2023-693	2023-04-25 19:17:04.535236+00	2023-04-27 19:17:04.535236+00	2023-04-27 19:17:04.535236+00	2874.13	USD	Delivered	Pending	Order for Request for Bookshelf	2023-04-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
694	843	5	PO-2025-694	2025-05-03 19:17:04.535236+00	2025-05-05 19:17:04.535236+00	\N	12.64	USD	Cancelled	Cancelled	Order for Request for Pen Set	2025-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
695	847	2	PO-2024-695	2024-02-17 19:17:04.535236+00	2024-02-22 19:17:04.535236+00	\N	351.36	USD	Shipped	Pending	Order for Request for Filing Cabinet	2024-02-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
696	849	1	PO-2024-696	2024-01-23 19:17:04.535236+00	2024-01-26 19:17:04.535236+00	2024-01-28 19:17:04.535236+00	2167.26	USD	Delivered	Pending	Order for Request for Filing Cabinet	2024-01-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
697	850	4	PO-2023-697	2023-07-29 19:17:04.535236+00	2023-08-02 19:17:04.535236+00	2023-08-02 19:17:04.535236+00	3800.52	USD	Delivered	Pending	Order for Request for Desk	2023-07-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
698	851	2	PO-2022-698	2022-04-25 19:17:04.535236+00	2022-04-30 19:17:04.535236+00	2022-04-28 19:17:04.535236+00	1997.78	USD	Delivered	Paid	Order for Request for Mouse	2022-04-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
699	852	5	PO-2021-699	2021-10-10 19:17:04.535236+00	2021-10-12 19:17:04.535236+00	2021-10-12 19:17:04.535236+00	334.80	USD	Delivered	Paid	Order for Request for Bookshelf	2021-10-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
700	854	4	PO-2024-700	2024-10-05 19:17:04.535236+00	2024-10-09 19:17:04.535236+00	2024-10-10 19:17:04.535236+00	1063.45	USD	Delivered	Paid	Order for Request for Conference Table	2024-10-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
701	855	4	PO-2020-701	2020-11-10 19:17:04.535236+00	2020-11-14 19:17:04.535236+00	\N	14.39	USD	Shipped	Pending	Order for Request for Pen Set	2020-11-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
702	856	4	PO-2024-702	2024-03-12 19:17:04.535236+00	2024-03-16 19:17:04.535236+00	2024-03-16 19:17:04.535236+00	1451.71	USD	Delivered	Pending	Order for Request for Bookshelf	2024-03-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
703	859	4	PO-2025-703	2025-02-24 19:17:04.535236+00	2025-02-28 19:17:04.535236+00	\N	16.96	USD	Shipped	Pending	Order for Request for Pen Set	2025-02-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
704	860	5	PO-2025-704	2025-04-20 19:17:04.535236+00	2025-04-22 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	31.17	USD	Delivered	Paid	Order for Request for Pen Set	2025-04-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
705	861	1	PO-2024-705	2024-06-20 19:17:04.535236+00	2024-06-23 19:17:04.535236+00	2024-06-21 19:17:04.535236+00	63.30	USD	Delivered	Pending	Order for Request for Stapler	2024-06-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
706	863	5	PO-2021-706	2021-07-28 19:17:04.535236+00	2021-07-30 19:17:04.535236+00	2021-07-30 19:17:04.535236+00	1378.43	USD	Delivered	Pending	Order for Request for Bookshelf	2021-07-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
707	864	1	PO-2025-707	2025-05-27 19:17:04.535236+00	2025-05-30 19:17:04.535236+00	2025-05-31 19:17:04.535236+00	659.46	USD	Delivered	Pending	Order for Request for Desk	2025-05-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
708	865	5	PO-2024-708	2024-01-18 19:17:04.535236+00	2024-01-20 19:17:04.535236+00	2024-01-22 19:17:04.535236+00	47.94	USD	Delivered	Paid	Order for Request for Pen Set	2024-01-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
709	866	1	PO-2025-709	2025-04-04 19:17:04.535236+00	2025-04-07 19:17:04.535236+00	2025-04-06 19:17:04.535236+00	45.10	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-04-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
710	867	1	PO-2024-710	2024-06-15 19:17:04.535236+00	2024-06-18 19:17:04.535236+00	2024-06-17 19:17:04.535236+00	61.28	USD	Delivered	Paid	Order for Request for Notebook	2024-06-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
711	868	4	PO-2024-711	2024-12-14 19:17:04.535236+00	2024-12-18 19:17:04.535236+00	2024-12-16 19:17:04.535236+00	47.92	USD	Delivered	Paid	Order for Request for Pen Set	2024-12-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
712	870	3	PO-2023-712	2023-05-03 19:17:04.535236+00	2023-05-10 19:17:04.535236+00	2023-05-08 19:17:04.535236+00	125.61	USD	Delivered	Paid	Order for Request for Sticky Notes	2023-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
713	871	3	PO-2025-713	2025-05-17 19:17:04.535236+00	2025-05-24 19:17:04.535236+00	2025-05-22 19:17:04.535236+00	100.69	USD	Delivered	Paid	Order for Request for Sticky Notes	2025-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
714	872	2	PO-2025-714	2025-04-19 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	2025-04-24 19:17:04.535236+00	833.24	USD	Delivered	Pending	Order for Request for Filing Cabinet	2025-04-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
715	874	3	PO-2023-715	2023-12-26 19:17:04.535236+00	2024-01-02 19:17:04.535236+00	\N	505.92	USD	Ordered	Pending	Order for Request for Keyboard	2023-12-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
716	875	2	PO-2023-716	2023-04-24 19:17:04.535236+00	2023-04-29 19:17:04.535236+00	2023-04-29 19:17:04.535236+00	76.52	USD	Delivered	Paid	Order for Request for Pen Set	2023-04-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
717	876	3	PO-2022-717	2022-12-20 19:17:04.535236+00	2022-12-27 19:17:04.535236+00	2022-12-29 19:17:04.535236+00	52.75	USD	Delivered	Paid	Order for Request for Pen Set	2022-12-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
718	877	3	PO-2024-718	2024-11-13 19:17:04.535236+00	2024-11-20 19:17:04.535236+00	2024-11-22 19:17:04.535236+00	59.30	USD	Delivered	Pending	Order for Request for Notebook	2024-11-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
719	878	5	PO-2021-719	2021-01-05 19:17:04.535236+00	2021-01-07 19:17:04.535236+00	2021-01-09 19:17:04.535236+00	1513.69	USD	Delivered	Paid	Order for Request for Filing Cabinet	2021-01-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
720	879	5	PO-2023-720	2023-04-22 19:17:04.535236+00	2023-04-24 19:17:04.535236+00	2023-04-24 19:17:04.535236+00	383.42	USD	Delivered	Pending	Order for Request for Mouse	2023-04-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
721	880	1	PO-2023-721	2023-09-25 19:17:04.535236+00	2023-09-28 19:17:04.535236+00	2023-09-26 19:17:04.535236+00	17.90	USD	Delivered	Paid	Order for Request for Stapler	2023-09-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
722	883	5	PO-2022-722	2022-02-05 19:17:04.535236+00	2022-02-07 19:17:04.535236+00	2022-02-07 19:17:04.535236+00	17.88	USD	Delivered	Pending	Order for Request for Sticky Notes	2022-02-05 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
723	885	5	PO-2025-723	2025-02-02 19:17:04.535236+00	2025-02-04 19:17:04.535236+00	2025-02-04 19:17:04.535236+00	13898.76	USD	Delivered	Pending	Order for Request for Office Chair	2025-02-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
724	886	2	PO-2025-724	2025-02-03 19:17:04.535236+00	2025-02-08 19:17:04.535236+00	2025-02-07 19:17:04.535236+00	185.49	USD	Delivered	Pending	Order for Request for Notebook	2025-02-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
725	887	4	PO-2023-725	2023-05-08 19:17:04.535236+00	2023-05-12 19:17:04.535236+00	2023-05-10 19:17:04.535236+00	66.34	USD	Delivered	Pending	Order for Request for Notebook	2023-05-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
726	888	5	PO-2025-726	2025-03-14 19:17:04.535236+00	2025-03-16 19:17:04.535236+00	2025-03-16 19:17:04.535236+00	37.70	USD	Delivered	Pending	Order for Request for Printing Paper	2025-03-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
727	889	2	PO-2024-727	2024-03-09 19:17:04.535236+00	2024-03-14 19:17:04.535236+00	\N	422.40	USD	Ordered	Pending	Order for Request for Keyboard	2024-03-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
728	891	1	PO-2025-728	2025-03-02 19:17:04.535236+00	2025-03-05 19:17:04.535236+00	\N	2249.63	USD	Shipped	Pending	Order for Request for Desk	2025-03-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
729	893	3	PO-2022-729	2022-03-07 19:17:04.535236+00	2022-03-14 19:17:04.535236+00	2022-03-15 19:17:04.535236+00	802.15	USD	Delivered	Paid	Order for Request for Filing Cabinet	2022-03-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
730	894	2	PO-2021-730	2021-07-13 19:17:04.535236+00	2021-07-18 19:17:04.535236+00	\N	78.52	USD	Cancelled	Cancelled	Order for Request for Stapler	2021-07-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
731	895	3	PO-2025-731	2025-05-22 19:17:04.535236+00	2025-05-29 19:17:04.535236+00	\N	1844.75	USD	Ordered	Pending	Order for Request for Desk	2025-05-22 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
732	896	3	PO-2024-732	2024-09-03 19:17:04.535236+00	2024-09-10 19:17:04.535236+00	2024-09-12 19:17:04.535236+00	47.30	USD	Delivered	Pending	Order for Request for Printing Paper	2024-09-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
733	897	2	PO-2025-733	2025-04-23 19:17:04.535236+00	2025-04-28 19:17:04.535236+00	2025-04-26 19:17:04.535236+00	43.48	USD	Delivered	Paid	Order for Request for Notebook	2025-04-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
734	898	2	PO-2025-734	2025-03-17 19:17:04.535236+00	2025-03-22 19:17:04.535236+00	\N	128.46	USD	Cancelled	Cancelled	Order for Request for Mouse	2025-03-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
735	899	1	PO-2023-735	2023-09-01 19:17:04.535236+00	2023-09-04 19:17:04.535236+00	2023-09-02 19:17:04.535236+00	81.60	USD	Delivered	Paid	Order for Request for Stapler	2023-09-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
736	900	5	PO-2024-736	2024-03-25 19:17:04.535236+00	2024-03-27 19:17:04.535236+00	2024-03-28 19:17:04.535236+00	178.71	USD	Delivered	Paid	Order for Request for Notebook	2024-03-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
737	901	2	PO-2022-737	2022-10-04 19:17:04.535236+00	2022-10-09 19:17:04.535236+00	2022-10-10 19:17:04.535236+00	86.65	USD	Delivered	Paid	Order for Request for Pen Set	2022-10-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
738	903	5	PO-2025-738	2025-04-07 19:17:04.535236+00	2025-04-09 19:17:04.535236+00	\N	118.70	USD	Cancelled	Cancelled	Order for Request for Notebook	2025-04-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
739	904	4	PO-2022-739	2022-10-28 19:17:04.535236+00	2022-11-01 19:17:04.535236+00	2022-11-02 19:17:04.535236+00	17498.60	USD	Delivered	Pending	Order for Request for Desk	2022-10-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
740	905	2	PO-2025-740	2025-02-08 19:17:04.535236+00	2025-02-13 19:17:04.535236+00	\N	68.56	USD	Shipped	Pending	Order for Request for Pen Set	2025-02-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
741	906	2	PO-2023-741	2023-09-07 19:17:04.535236+00	2023-09-12 19:17:04.535236+00	2023-09-14 19:17:04.535236+00	437.32	USD	Delivered	Pending	Order for Request for Laptop	2023-09-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
742	907	4	PO-2022-742	2022-06-11 19:17:04.535236+00	2022-06-15 19:17:04.535236+00	2022-06-16 19:17:04.535236+00	27.68	USD	Delivered	Paid	Order for Request for Notebook	2022-06-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
743	908	4	PO-2022-743	2022-09-10 19:17:04.535236+00	2022-09-14 19:17:04.535236+00	\N	1760.76	USD	Shipped	Pending	Order for Request for Filing Cabinet	2022-09-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
744	909	2	PO-2023-744	2023-03-27 19:17:04.535236+00	2023-04-01 19:17:04.535236+00	\N	27.95	USD	Shipped	Pending	Order for Request for Pen Set	2023-03-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
745	910	2	PO-2025-745	2025-03-12 19:17:04.535236+00	2025-03-17 19:17:04.535236+00	\N	31.32	USD	Cancelled	Cancelled	Order for Request for Pen Set	2025-03-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
746	911	5	PO-2022-746	2022-09-26 19:17:04.535236+00	2022-09-28 19:17:04.535236+00	2022-09-29 19:17:04.535236+00	17.76	USD	Delivered	Paid	Order for Request for Pen Set	2022-09-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
747	912	4	PO-2025-747	2025-03-17 19:17:04.535236+00	2025-03-21 19:17:04.535236+00	\N	64.40	USD	Cancelled	Cancelled	Order for Request for Mouse	2025-03-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
748	913	3	PO-2023-748	2023-02-01 19:17:04.535236+00	2023-02-08 19:17:04.535236+00	2023-02-10 19:17:04.535236+00	367.33	USD	Delivered	Pending	Order for Request for Laptop	2023-02-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
749	914	3	PO-2025-749	2025-05-18 19:17:04.535236+00	2025-05-25 19:17:04.535236+00	2025-05-23 19:17:04.535236+00	30.82	USD	Delivered	Paid	Order for Request for Stapler	2025-05-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
750	915	5	PO-2022-750	2022-11-13 19:17:04.535236+00	2022-11-15 19:17:04.535236+00	\N	8.96	USD	Shipped	Pending	Order for Request for Sticky Notes	2022-11-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
751	916	5	PO-2025-751	2025-01-19 19:17:04.535236+00	2025-01-21 19:17:04.535236+00	\N	2404.17	USD	Shipped	Pending	Order for Request for Bookshelf	2025-01-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
752	917	4	PO-2024-752	2024-10-16 19:17:04.535236+00	2024-10-20 19:17:04.535236+00	\N	56.48	USD	Ordered	Pending	Order for Request for Notebook	2024-10-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
753	920	2	PO-2024-753	2024-07-11 19:17:04.535236+00	2024-07-16 19:17:04.535236+00	2024-07-18 19:17:04.535236+00	17933.92	USD	Delivered	Pending	Order for Request for Conference Table	2024-07-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
754	924	5	PO-2025-754	2025-05-21 19:17:04.535236+00	2025-05-23 19:17:04.535236+00	\N	467.11	USD	Cancelled	Cancelled	Order for Request for Monitor	2025-05-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
755	925	2	PO-2024-755	2024-06-10 19:17:04.535236+00	2024-06-15 19:17:04.535236+00	2024-06-14 19:17:04.535236+00	17.06	USD	Delivered	Paid	Order for Request for Stapler	2024-06-10 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
756	927	3	PO-2025-756	2025-05-29 19:17:04.535236+00	2025-06-05 19:17:04.535236+00	\N	71.79	USD	Shipped	Pending	Order for Request for Printing Paper	2025-05-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
757	928	2	PO-2024-757	2024-02-16 19:17:04.535236+00	2024-02-21 19:17:04.535236+00	2024-02-19 19:17:04.535236+00	2780.96	USD	Delivered	Pending	Order for Request for Conference Table	2024-02-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
758	931	4	PO-2021-758	2021-09-12 19:17:04.535236+00	2021-09-16 19:17:04.535236+00	2021-09-15 19:17:04.535236+00	153.42	USD	Delivered	Pending	Order for Request for Sticky Notes	2021-09-12 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
759	932	3	PO-2023-759	2023-10-28 19:17:04.535236+00	2023-11-04 19:17:04.535236+00	\N	1282.60	USD	Cancelled	Cancelled	Order for Request for Headset	2023-10-28 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
760	934	2	PO-2025-760	2025-05-11 19:17:04.535236+00	2025-05-16 19:17:04.535236+00	2025-05-16 19:17:04.535236+00	9.63	USD	Delivered	Pending	Order for Request for Notebook	2025-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
761	935	3	PO-2024-761	2024-05-14 19:17:04.535236+00	2024-05-21 19:17:04.535236+00	\N	42.30	USD	Shipped	Pending	Order for Request for Pen Set	2024-05-14 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
762	936	4	PO-2025-762	2025-05-26 19:17:04.535236+00	2025-05-30 19:17:04.535236+00	\N	37.30	USD	Ordered	Pending	Order for Request for Printing Paper	2025-05-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
763	939	5	PO-2024-763	2024-08-04 19:17:04.535236+00	2024-08-06 19:17:04.535236+00	2024-08-08 19:17:04.535236+00	183.98	USD	Delivered	Paid	Order for Request for Headset	2024-08-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
764	941	2	PO-2023-764	2023-02-15 19:17:04.535236+00	2023-02-20 19:17:04.535236+00	2023-02-21 19:17:04.535236+00	33.11	USD	Delivered	Paid	Order for Request for Stapler	2023-02-15 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
765	942	4	PO-2023-765	2023-08-03 19:17:04.535236+00	2023-08-07 19:17:04.535236+00	\N	435.45	USD	Ordered	Pending	Order for Request for Laptop	2023-08-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
766	943	3	PO-2023-766	2023-08-31 19:17:04.535236+00	2023-09-07 19:17:04.535236+00	\N	86.90	USD	Ordered	Pending	Order for Request for Stapler	2023-08-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
767	944	3	PO-2025-767	2025-04-23 19:17:04.535236+00	2025-04-30 19:17:04.535236+00	\N	1686.64	USD	Shipped	Pending	Order for Request for Desk	2025-04-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
768	945	3	PO-2024-768	2024-03-30 19:17:04.535236+00	2024-04-06 19:17:04.535236+00	2024-04-08 19:17:04.535236+00	364.90	USD	Delivered	Paid	Order for Request for Keyboard	2024-03-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
769	947	3	PO-2023-769	2023-01-17 19:17:04.535236+00	2023-01-24 19:17:04.535236+00	2023-01-22 19:17:04.535236+00	235.92	USD	Delivered	Pending	Order for Request for Laptop	2023-01-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
770	948	1	PO-2025-770	2025-05-11 19:17:04.535236+00	2025-05-14 19:17:04.535236+00	2025-05-12 19:17:04.535236+00	74.49	USD	Delivered	Paid	Order for Request for Notebook	2025-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
771	949	3	PO-2021-771	2021-08-19 19:17:04.535236+00	2021-08-26 19:17:04.535236+00	2021-08-24 19:17:04.535236+00	99.19	USD	Delivered	Paid	Order for Request for Printing Paper	2021-08-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
772	950	3	PO-2024-772	2024-08-11 19:17:04.535236+00	2024-08-18 19:17:04.535236+00	2024-08-16 19:17:04.535236+00	90.29	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-08-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
773	951	4	PO-2024-773	2024-10-24 19:17:04.535236+00	2024-10-28 19:17:04.535236+00	2024-10-28 19:17:04.535236+00	700.10	USD	Delivered	Paid	Order for Request for Bookshelf	2024-10-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
774	952	3	PO-2023-774	2023-02-09 19:17:04.535236+00	2023-02-16 19:17:04.535236+00	\N	40.61	USD	Ordered	Pending	Order for Request for Printing Paper	2023-02-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
775	953	3	PO-2022-775	2022-03-25 19:17:04.535236+00	2022-04-01 19:17:04.535236+00	2022-04-02 19:17:04.535236+00	15.40	USD	Delivered	Pending	Order for Request for Sticky Notes	2022-03-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
776	954	1	PO-2025-776	2025-03-03 19:17:04.535236+00	2025-03-06 19:17:04.535236+00	\N	137.53	USD	Shipped	Pending	Order for Request for Stapler	2025-03-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
777	955	2	PO-2024-777	2024-08-26 19:17:04.535236+00	2024-08-31 19:17:04.535236+00	2024-09-02 19:17:04.535236+00	695.95	USD	Delivered	Paid	Order for Request for Filing Cabinet	2024-08-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
778	956	3	PO-2023-778	2023-05-11 19:17:04.535236+00	2023-05-18 19:17:04.535236+00	2023-05-19 19:17:04.535236+00	85.26	USD	Delivered	Pending	Order for Request for Keyboard	2023-05-11 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
779	957	3	PO-2025-779	2025-04-26 19:17:04.535236+00	2025-05-03 19:17:04.535236+00	2025-05-01 19:17:04.535236+00	175.73	USD	Delivered	Paid	Order for Request for Headset	2025-04-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
780	958	2	PO-2024-780	2024-08-25 19:17:04.535236+00	2024-08-30 19:17:04.535236+00	2024-09-01 19:17:04.535236+00	415.41	USD	Delivered	Pending	Order for Request for Monitor	2024-08-25 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
781	960	4	PO-2025-781	2025-03-16 19:17:04.535236+00	2025-03-20 19:17:04.535236+00	2025-03-20 19:17:04.535236+00	4387.87	USD	Delivered	Paid	Order for Request for Mouse	2025-03-16 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
782	961	5	PO-2022-782	2022-11-07 19:17:04.535236+00	2022-11-09 19:17:04.535236+00	2022-11-08 19:17:04.535236+00	14585.96	USD	Delivered	Pending	Order for Request for Filing Cabinet	2022-11-07 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
783	963	1	PO-2025-783	2025-04-27 19:17:04.535236+00	2025-04-30 19:17:04.535236+00	2025-04-30 19:17:04.535236+00	33.84	USD	Delivered	Pending	Order for Request for Notebook	2025-04-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
784	964	3	PO-2024-784	2024-12-04 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	2024-12-11 19:17:04.535236+00	102.73	USD	Delivered	Paid	Order for Request for Printing Paper	2024-12-04 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
785	966	3	PO-2025-785	2025-05-09 19:17:04.535236+00	2025-05-16 19:17:04.535236+00	\N	54.70	USD	Ordered	Pending	Order for Request for Stapler	2025-05-09 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
786	968	4	PO-2025-786	2025-04-13 19:17:04.535236+00	2025-04-17 19:17:04.535236+00	\N	613.02	USD	Ordered	Pending	Order for Request for Laptop	2025-04-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
787	969	1	PO-2025-787	2025-05-18 19:17:04.535236+00	2025-05-21 19:17:04.535236+00	2025-05-20 19:17:04.535236+00	73.18	USD	Delivered	Paid	Order for Request for Printing Paper	2025-05-18 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
788	970	4	PO-2025-788	2025-04-17 19:17:04.535236+00	2025-04-21 19:17:04.535236+00	2025-04-23 19:17:04.535236+00	147.35	USD	Delivered	Paid	Order for Request for Office Chair	2025-04-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
789	971	4	PO-2025-789	2025-05-01 19:17:04.535236+00	2025-05-05 19:17:04.535236+00	2025-05-05 19:17:04.535236+00	610.35	USD	Delivered	Paid	Order for Request for Headset	2025-05-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
790	972	4	PO-2025-790	2025-03-19 19:17:04.535236+00	2025-03-23 19:17:04.535236+00	2025-03-24 19:17:04.535236+00	84.15	USD	Delivered	Pending	Order for Request for Notebook	2025-03-19 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
791	973	2	PO-2024-791	2024-04-23 19:17:04.535236+00	2024-04-28 19:17:04.535236+00	\N	28.48	USD	Ordered	Pending	Order for Request for Sticky Notes	2024-04-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
792	974	2	PO-2025-792	2025-03-30 19:17:04.535236+00	2025-04-04 19:17:04.535236+00	\N	17.40	USD	Shipped	Pending	Order for Request for Sticky Notes	2025-03-30 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
793	976	5	PO-2025-793	2025-05-20 19:17:04.535236+00	2025-05-22 19:17:04.535236+00	2025-05-20 19:17:04.535236+00	206.56	USD	Delivered	Paid	Order for Request for Keyboard	2025-05-20 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
794	978	3	PO-2025-794	2025-05-24 19:17:04.535236+00	2025-05-31 19:17:04.535236+00	2025-05-31 19:17:04.535236+00	21.33	USD	Delivered	Pending	Order for Request for Printing Paper	2025-05-24 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
795	979	5	PO-2024-795	2024-07-13 19:17:04.535236+00	2024-07-15 19:17:04.535236+00	2024-07-13 19:17:04.535236+00	5999.70	USD	Delivered	Pending	Order for Request for Desk	2024-07-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
796	980	3	PO-2024-796	2024-07-23 19:17:04.535236+00	2024-07-30 19:17:04.535236+00	\N	804.95	USD	Shipped	Pending	Order for Request for Mouse	2024-07-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
797	981	3	PO-2022-797	2022-07-13 19:17:04.535236+00	2022-07-20 19:17:04.535236+00	2022-07-18 19:17:04.535236+00	92.17	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-07-13 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
798	983	2	PO-2023-798	2023-04-08 19:17:04.535236+00	2023-04-13 19:17:04.535236+00	2023-04-12 19:17:04.535236+00	31.20	USD	Delivered	Pending	Order for Request for Pen Set	2023-04-08 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
799	984	1	PO-2023-799	2023-12-23 19:17:04.535236+00	2023-12-26 19:17:04.535236+00	2023-12-27 19:17:04.535236+00	126.09	USD	Delivered	Paid	Order for Request for Stapler	2023-12-23 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
800	986	2	PO-2022-800	2022-06-06 19:17:04.535236+00	2022-06-11 19:17:04.535236+00	2022-06-10 19:17:04.535236+00	132.45	USD	Delivered	Paid	Order for Request for Sticky Notes	2022-06-06 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
801	988	3	PO-2024-801	2024-10-31 19:17:04.535236+00	2024-11-07 19:17:04.535236+00	2024-11-09 19:17:04.535236+00	46.31	USD	Delivered	Paid	Order for Request for Sticky Notes	2024-10-31 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
802	989	4	PO-2022-802	2022-12-27 19:17:04.535236+00	2022-12-31 19:17:04.535236+00	2023-01-01 19:17:04.535236+00	2043.20	USD	Delivered	Pending	Order for Request for Office Chair	2022-12-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
803	992	2	PO-2023-803	2023-05-03 19:17:04.535236+00	2023-05-08 19:17:04.535236+00	2023-05-10 19:17:04.535236+00	77.00	USD	Delivered	Paid	Order for Request for Notebook	2023-05-03 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
804	993	4	PO-2024-804	2024-11-26 19:17:04.535236+00	2024-11-30 19:17:04.535236+00	\N	92.76	USD	Ordered	Pending	Order for Request for Stapler	2024-11-26 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
805	994	4	PO-2025-805	2025-02-21 19:17:04.535236+00	2025-02-25 19:17:04.535236+00	\N	12239.52	USD	Ordered	Pending	Order for Request for Office Chair	2025-02-21 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
806	996	2	PO-2023-806	2023-05-17 19:17:04.535236+00	2023-05-22 19:17:04.535236+00	2023-05-20 19:17:04.535236+00	2064.86	USD	Delivered	Paid	Order for Request for Office Chair	2023-05-17 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
807	997	5	PO-2025-807	2025-03-01 19:17:04.535236+00	2025-03-03 19:17:04.535236+00	2025-03-02 19:17:04.535236+00	181.62	USD	Delivered	Pending	Order for Request for Stapler	2025-03-01 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
808	998	3	PO-2025-808	2025-04-29 19:17:04.535236+00	2025-05-06 19:17:04.535236+00	2025-05-07 19:17:04.535236+00	901.08	USD	Delivered	Paid	Order for Request for Mouse	2025-04-29 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
809	999	4	PO-2024-809	2024-06-27 19:17:04.535236+00	2024-07-01 19:17:04.535236+00	2024-07-01 19:17:04.535236+00	18694.94	USD	Delivered	Pending	Order for Request for Bookshelf	2024-06-27 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
810	1000	5	PO-2023-810	2023-08-02 19:17:04.535236+00	2023-08-04 19:17:04.535236+00	2023-08-02 19:17:04.535236+00	22.15	USD	Delivered	Paid	Order for Request for Notebook	2023-08-02 19:17:04.535236+00	2025-05-31 19:26:10.934503+00
\.


--
-- Data for Name: purchase_requests; Type: TABLE DATA; Schema: public; Owner: company_user
--

COPY public.purchase_requests (id, requester_name, department, description, category, quantity, unit, budget, urgency_level, status, created_at, updated_at) FROM stdin;
1	Employee 39	Finance	Request for Stapler	Software	3	pcs	16.60	Medium	Pending	2022-04-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
2	Employee 99	Operations	Request for Sticky Notes	Office Supplies	9	pack	7.08	High	Pending	2021-03-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
3	Employee 78	HR	Request for Filing Cabinet	Furniture	1	pcs	312.30	Medium	Pending	2023-11-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
4	Employee 19	IT	Request for Pen Set	Office Supplies	2	set	9.00	Medium	Pending	2025-03-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
5	Employee 58	HR	Request for Filing Cabinet	Furniture	4	pcs	307.98	Medium	Pending	2024-02-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
6	Employee 28	HR	Request for Sticky Notes	Services	4	pack	6.57	Medium	Pending	2022-03-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
7	Employee 99	Marketing	Request for Notebook	Office Supplies	7	pcs	6.01	High	Pending	2021-07-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
8	Employee 54	Operations	Request for Notebook	Software	4	pcs	8.35	High	Pending	2023-04-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
9	Employee 21	Finance	Request for Headset	Electronics	5	pcs	109.26	Low	Pending	2023-01-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
10	Employee 30	Operations	Request for Desk	Furniture	10	pcs	214.34	High	Pending	2023-05-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
11	Employee 38	Finance	Request for Headset	Electronics	6	pcs	60.36	High	Pending	2023-04-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
12	Employee 29	HR	Request for Stapler	Services	7	pcs	22.80	Medium	Pending	2025-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
13	Employee 25	Marketing	Request for Notebook	Services	6	pcs	8.19	Medium	Pending	2021-12-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
14	Employee 58	Marketing	Request for Conference Table	Furniture	1	pcs	1780.06	Low	Pending	2021-04-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
15	Employee 93	Operations	Request for Bookshelf	Furniture	5	pcs	237.40	Medium	Pending	2024-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
16	Employee 33	Marketing	Request for Sticky Notes	Office Supplies	7	pack	5.73	Low	Pending	2021-10-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
17	Employee 71	Marketing	Request for Keyboard	Electronics	10	pcs	89.85	Medium	Pending	2024-01-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
18	Employee 37	Operations	Request for Sticky Notes	Office Supplies	10	pack	3.47	Low	Pending	2024-08-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
19	Employee 94	Operations	Request for Printing Paper	Services	4	box	7.29	Low	Pending	2021-08-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
20	Employee 13	IT	Request for Stapler	Software	4	pcs	10.93	Medium	Pending	2024-07-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
21	Employee 32	HR	Request for Stapler	Services	10	pcs	13.68	Medium	Pending	2023-12-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
22	Employee 99	Finance	Request for Mouse	Electronics	4	pcs	48.87	Low	Pending	2021-11-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
23	Employee 47	Finance	Request for Sticky Notes	Services	8	pack	6.26	High	Pending	2020-06-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
24	Employee 76	HR	Request for Headset	Electronics	3	pcs	106.79	Medium	Pending	2021-06-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
25	Employee 15	IT	Request for Keyboard	Electronics	5	pcs	89.46	Low	Pending	2021-01-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
26	Employee 33	IT	Request for Printing Paper	Office Supplies	5	box	14.55	Low	Pending	2020-07-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
27	Employee 87	Finance	Request for Sticky Notes	Software	1	pack	6.61	High	Pending	2020-06-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
28	Employee 7	Marketing	Request for Notebook	Services	1	pcs	7.45	High	Pending	2024-07-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
29	Employee 50	Operations	Request for Office Chair	Furniture	9	pcs	202.33	High	Pending	2022-04-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
30	Employee 64	HR	Request for Notebook	Office Supplies	6	pcs	5.11	High	Pending	2021-05-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
31	Employee 80	IT	Request for Keyboard	Electronics	3	pcs	69.05	Medium	Pending	2024-11-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
32	Employee 9	Operations	Request for Notebook	Software	7	pcs	6.49	High	Pending	2022-12-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
33	Employee 11	IT	Request for Sticky Notes	Services	9	pack	2.84	Medium	Pending	2022-09-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
34	Employee 77	Operations	Request for Sticky Notes	Software	9	pack	5.30	High	Pending	2021-06-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
35	Employee 55	IT	Request for Stapler	Services	4	pcs	20.02	Medium	Pending	2024-09-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
36	Employee 39	IT	Request for Pen Set	Software	6	set	16.07	High	Pending	2021-07-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
37	Employee 31	IT	Request for Sticky Notes	Services	7	pack	4.13	High	Pending	2025-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
38	Employee 12	HR	Request for Pen Set	Office Supplies	4	set	15.93	High	Pending	2024-03-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
39	Employee 46	Operations	Request for Sticky Notes	Services	3	pack	7.75	Low	Pending	2024-02-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
40	Employee 1	IT	Request for Office Chair	Furniture	4	pcs	143.72	High	Pending	2021-09-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
41	Employee 92	HR	Request for Stapler	Services	9	pcs	23.29	Medium	Pending	2025-04-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
42	Employee 88	Marketing	Request for Pen Set	Services	7	set	12.84	Medium	Pending	2024-01-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
43	Employee 87	IT	Request for Notebook	Services	9	pcs	6.78	Low	Pending	2022-05-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
44	Employee 60	Operations	Request for Printing Paper	Software	7	box	14.09	High	Pending	2021-12-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
45	Employee 27	HR	Request for Keyboard	Electronics	4	pcs	74.97	High	Pending	2021-07-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
46	Employee 60	Finance	Request for Monitor	Electronics	10	pcs	236.24	Low	Pending	2023-06-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
47	Employee 24	Marketing	Request for Printing Paper	Services	6	box	6.43	High	Pending	2022-06-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
48	Employee 8	Operations	Request for Stapler	Software	4	pcs	24.77	High	Pending	2021-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
49	Employee 85	Operations	Request for Pen Set	Office Supplies	2	set	15.21	Medium	Pending	2024-12-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
50	Employee 97	Marketing	Request for Stapler	Services	6	pcs	14.35	Medium	Pending	2022-06-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
51	Employee 41	Operations	Request for Stapler	Services	2	pcs	17.29	Low	Pending	2023-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
52	Employee 41	IT	Request for Bookshelf	Furniture	4	pcs	203.65	High	Pending	2023-10-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
53	Employee 86	Finance	Request for Printing Paper	Software	1	box	13.53	Medium	Pending	2025-01-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
54	Employee 1	Finance	Request for Keyboard	Electronics	2	pcs	62.80	Low	Pending	2023-10-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
55	Employee 39	Marketing	Request for Pen Set	Office Supplies	10	set	11.13	Medium	Pending	2021-09-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
56	Employee 11	HR	Request for Printing Paper	Software	4	box	7.02	High	Pending	2021-05-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
57	Employee 69	Operations	Request for Notebook	Office Supplies	7	pcs	6.80	High	Pending	2023-09-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
58	Employee 36	Finance	Request for Keyboard	Electronics	4	pcs	75.27	Low	Pending	2022-10-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
59	Employee 79	HR	Request for Sticky Notes	Software	6	pack	3.94	Medium	Pending	2023-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
60	Employee 66	IT	Request for Bookshelf	Furniture	4	pcs	208.18	High	Pending	2020-10-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
61	Employee 46	Marketing	Request for Desk	Furniture	1	pcs	306.40	High	Pending	2022-12-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
62	Employee 41	Marketing	Request for Notebook	Services	3	pcs	3.92	Low	Pending	2024-06-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
63	Employee 80	HR	Request for Laptop	Electronics	7	pcs	477.40	Low	Pending	2022-04-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
64	Employee 86	IT	Request for Printing Paper	Office Supplies	1	box	12.79	Low	Pending	2020-11-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
65	Employee 60	HR	Request for Desk	Furniture	3	pcs	306.73	High	Pending	2022-04-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
66	Employee 53	Operations	Request for Stapler	Office Supplies	6	pcs	10.87	Medium	Pending	2025-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
67	Employee 17	Operations	Request for Sticky Notes	Software	2	pack	3.75	Low	Pending	2021-03-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
68	Employee 39	Finance	Request for Stapler	Software	2	pcs	23.75	Low	Pending	2025-03-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
69	Employee 90	Finance	Request for Sticky Notes	Services	1	pack	2.62	High	Pending	2022-02-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
70	Employee 94	Operations	Request for Monitor	Electronics	8	pcs	233.22	Low	Pending	2024-06-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
71	Employee 57	Marketing	Request for Notebook	Software	8	pcs	5.06	High	Pending	2023-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
72	Employee 74	Finance	Request for Pen Set	Office Supplies	8	set	10.38	Low	Pending	2022-03-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
73	Employee 83	IT	Request for Printing Paper	Services	8	box	7.73	Medium	Pending	2023-02-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
74	Employee 52	Finance	Request for Notebook	Software	6	pcs	7.16	Low	Pending	2021-07-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
75	Employee 26	HR	Request for Bookshelf	Furniture	5	pcs	240.63	High	Pending	2021-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
76	Employee 71	Operations	Request for Conference Table	Furniture	6	pcs	1779.83	Medium	Pending	2022-06-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
77	Employee 74	IT	Request for Stapler	Software	1	pcs	21.67	Medium	Pending	2021-11-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
78	Employee 53	Marketing	Request for Printing Paper	Services	2	box	14.30	Low	Pending	2022-08-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
79	Employee 22	IT	Request for Stapler	Office Supplies	1	pcs	24.38	Low	Pending	2022-06-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
80	Employee 27	HR	Request for Stapler	Software	2	pcs	20.45	Low	Pending	2023-11-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
81	Employee 40	Finance	Request for Stapler	Services	7	pcs	15.34	High	Pending	2022-09-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
82	Employee 11	Finance	Request for Desk	Furniture	5	pcs	412.05	High	Pending	2022-05-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
83	Employee 58	IT	Request for Stapler	Office Supplies	4	pcs	23.56	Medium	Pending	2024-01-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
84	Employee 98	Finance	Request for Laptop	Electronics	10	pcs	566.87	Low	Pending	2020-09-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
85	Employee 46	IT	Request for Laptop	Electronics	5	pcs	585.39	Medium	Pending	2023-03-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
86	Employee 19	Marketing	Request for Printing Paper	Services	7	box	14.82	High	Pending	2023-02-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
87	Employee 11	Operations	Request for Notebook	Software	3	pcs	5.49	Medium	Pending	2021-04-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
88	Employee 79	Finance	Request for Bookshelf	Furniture	2	pcs	191.01	High	Pending	2021-10-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
89	Employee 57	Operations	Request for Pen Set	Office Supplies	2	set	19.16	Low	Pending	2020-07-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
90	Employee 64	HR	Request for Pen Set	Services	5	set	10.88	Low	Pending	2021-12-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
91	Employee 44	Marketing	Request for Office Chair	Furniture	3	pcs	218.68	High	Pending	2020-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
92	Employee 100	Marketing	Request for Mouse	Electronics	4	pcs	24.01	Medium	Pending	2023-09-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
93	Employee 14	IT	Request for Sticky Notes	Office Supplies	5	pack	5.52	High	Pending	2022-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
94	Employee 56	Operations	Request for Keyboard	Electronics	1	pcs	77.77	Medium	Pending	2023-02-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
95	Employee 84	Finance	Request for Notebook	Services	3	pcs	7.87	Low	Pending	2025-01-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
96	Employee 64	IT	Request for Sticky Notes	Office Supplies	2	pack	3.66	High	Pending	2024-07-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
97	Employee 11	IT	Request for Headset	Electronics	6	pcs	74.47	Medium	Pending	2022-02-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
98	Employee 71	Marketing	Request for Pen Set	Office Supplies	7	set	12.46	Low	Pending	2023-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
99	Employee 28	Operations	Request for Bookshelf	Furniture	7	pcs	109.11	High	Pending	2022-01-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
100	Employee 50	Operations	Request for Stapler	Software	6	pcs	19.45	High	Pending	2024-05-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
101	Employee 81	IT	Request for Notebook	Office Supplies	4	pcs	6.52	Low	Pending	2025-04-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
102	Employee 90	Finance	Request for Bookshelf	Furniture	10	pcs	146.12	Low	Pending	2022-04-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
103	Employee 85	Finance	Request for Headset	Electronics	7	pcs	108.10	Medium	Pending	2022-04-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
104	Employee 22	HR	Request for Headset	Electronics	1	pcs	48.85	High	Pending	2020-06-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
105	Employee 28	Finance	Request for Bookshelf	Furniture	4	pcs	118.86	High	Pending	2023-08-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
106	Employee 95	HR	Request for Stapler	Software	1	pcs	21.22	High	Pending	2022-01-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
107	Employee 28	Finance	Request for Pen Set	Software	3	set	9.14	High	Pending	2023-04-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
108	Employee 70	Finance	Request for Keyboard	Electronics	9	pcs	92.45	Medium	Pending	2023-11-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
109	Employee 9	HR	Request for Conference Table	Furniture	10	pcs	1885.10	Medium	Pending	2024-02-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
110	Employee 77	Finance	Request for Office Chair	Furniture	9	pcs	142.00	High	Pending	2022-11-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
111	Employee 67	Finance	Request for Notebook	Office Supplies	6	pcs	7.72	Medium	Pending	2023-11-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
112	Employee 59	Marketing	Request for Laptop	Electronics	3	pcs	488.60	Low	Pending	2025-02-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
113	Employee 60	Marketing	Request for Stapler	Services	4	pcs	15.31	Medium	Pending	2023-02-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
114	Employee 7	IT	Request for Notebook	Office Supplies	9	pcs	9.93	Low	Pending	2023-09-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
115	Employee 31	Operations	Request for Notebook	Office Supplies	4	pcs	5.28	High	Pending	2021-10-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
116	Employee 29	HR	Request for Desk	Furniture	5	pcs	215.21	Low	Pending	2024-04-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
117	Employee 61	IT	Request for Bookshelf	Furniture	10	pcs	215.95	High	Pending	2023-05-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
118	Employee 17	IT	Request for Printing Paper	Software	6	box	10.72	Medium	Pending	2022-07-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
119	Employee 16	IT	Request for Bookshelf	Furniture	7	pcs	229.54	Low	Pending	2022-10-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
120	Employee 45	IT	Request for Notebook	Office Supplies	4	pcs	8.08	High	Pending	2024-02-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
121	Employee 66	Finance	Request for Monitor	Electronics	3	pcs	201.89	High	Pending	2022-04-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
122	Employee 57	HR	Request for Pen Set	Services	2	set	9.59	Medium	Pending	2024-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
123	Employee 95	HR	Request for Sticky Notes	Software	7	pack	2.89	Medium	Pending	2021-10-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
124	Employee 83	Finance	Request for Printing Paper	Services	7	box	13.23	High	Pending	2022-09-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
125	Employee 12	IT	Request for Pen Set	Services	3	set	17.06	High	Pending	2020-08-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
126	Employee 39	HR	Request for Pen Set	Office Supplies	7	set	9.20	Medium	Pending	2022-06-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
127	Employee 33	IT	Request for Monitor	Electronics	1	pcs	230.22	High	Pending	2021-09-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
128	Employee 45	HR	Request for Notebook	Services	4	pcs	7.72	High	Pending	2024-10-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
129	Employee 29	Operations	Request for Filing Cabinet	Furniture	10	pcs	261.19	Medium	Pending	2021-01-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
130	Employee 17	IT	Request for Desk	Furniture	8	pcs	484.65	Low	Pending	2024-05-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
131	Employee 52	Marketing	Request for Pen Set	Services	8	set	8.63	Medium	Pending	2023-08-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
132	Employee 45	Marketing	Request for Laptop	Electronics	4	pcs	609.76	Low	Pending	2022-11-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
133	Employee 42	IT	Request for Mouse	Electronics	3	pcs	29.41	Low	Pending	2022-07-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
134	Employee 27	IT	Request for Sticky Notes	Software	6	pack	4.90	Medium	Pending	2024-08-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
135	Employee 3	Marketing	Request for Filing Cabinet	Furniture	1	pcs	352.69	Medium	Pending	2023-03-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
136	Employee 38	IT	Request for Headset	Electronics	5	pcs	114.95	High	Pending	2020-07-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
137	Employee 12	Marketing	Request for Keyboard	Electronics	5	pcs	58.19	Medium	Pending	2025-03-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
138	Employee 32	Marketing	Request for Stapler	Software	8	pcs	17.65	Low	Pending	2022-12-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
139	Employee 43	IT	Request for Notebook	Services	9	pcs	6.78	Low	Pending	2022-04-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
140	Employee 54	Finance	Request for Mouse	Electronics	7	pcs	38.92	High	Pending	2023-06-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
141	Employee 78	Finance	Request for Bookshelf	Furniture	8	pcs	249.79	Low	Pending	2021-10-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
142	Employee 64	IT	Request for Conference Table	Furniture	7	pcs	1984.62	Low	Pending	2021-11-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
143	Employee 49	IT	Request for Filing Cabinet	Furniture	1	pcs	273.95	High	Pending	2021-11-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
144	Employee 9	Finance	Request for Filing Cabinet	Furniture	1	pcs	173.58	Medium	Pending	2021-03-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
145	Employee 37	Operations	Request for Pen Set	Software	9	set	12.52	Low	Pending	2022-01-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
146	Employee 58	Marketing	Request for Sticky Notes	Office Supplies	5	pack	3.87	Medium	Pending	2021-05-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
147	Employee 4	IT	Request for Notebook	Software	1	pcs	4.08	Medium	Pending	2022-08-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
148	Employee 8	HR	Request for Bookshelf	Furniture	5	pcs	129.81	Low	Pending	2025-05-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
149	Employee 88	Marketing	Request for Notebook	Services	6	pcs	6.29	Medium	Pending	2022-04-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
150	Employee 58	Operations	Request for Conference Table	Furniture	2	pcs	1826.63	Low	Pending	2022-09-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
151	Employee 47	IT	Request for Pen Set	Office Supplies	4	set	18.69	Low	Pending	2023-07-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
152	Employee 50	Finance	Request for Laptop	Electronics	5	pcs	424.85	Medium	Pending	2023-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
153	Employee 7	Marketing	Request for Desk	Furniture	7	pcs	254.57	Medium	Pending	2023-02-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
154	Employee 23	HR	Request for Keyboard	Electronics	6	pcs	65.64	Medium	Pending	2021-11-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
155	Employee 36	Finance	Request for Desk	Furniture	1	pcs	454.51	Low	Pending	2024-04-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
156	Employee 68	IT	Request for Printing Paper	Services	8	box	6.29	Medium	Pending	2021-10-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
157	Employee 33	IT	Request for Pen Set	Services	5	set	9.29	High	Pending	2023-07-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
158	Employee 91	Marketing	Request for Pen Set	Software	6	set	18.14	High	Pending	2020-11-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
159	Employee 39	Operations	Request for Printing Paper	Services	5	box	11.89	High	Pending	2024-07-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
160	Employee 17	HR	Request for Sticky Notes	Services	9	pack	5.33	Medium	Pending	2025-01-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
161	Employee 46	IT	Request for Notebook	Software	1	pcs	8.80	Low	Pending	2023-04-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
162	Employee 86	HR	Request for Conference Table	Furniture	9	pcs	1297.93	High	Pending	2025-02-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
163	Employee 65	Operations	Request for Laptop	Electronics	10	pcs	418.41	High	Pending	2022-08-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
164	Employee 91	Operations	Request for Pen Set	Services	7	set	9.61	Low	Pending	2021-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
165	Employee 49	Operations	Request for Pen Set	Software	10	set	19.11	High	Pending	2021-11-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
166	Employee 37	Operations	Request for Filing Cabinet	Furniture	5	pcs	345.85	Low	Pending	2025-02-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
167	Employee 42	HR	Request for Keyboard	Electronics	6	pcs	53.72	Low	Pending	2020-07-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
168	Employee 85	Marketing	Request for Keyboard	Electronics	1	pcs	53.86	Low	Pending	2024-02-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
169	Employee 77	HR	Request for Notebook	Office Supplies	3	pcs	5.57	Medium	Pending	2023-07-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
170	Employee 66	IT	Request for Stapler	Office Supplies	10	pcs	23.62	Medium	Pending	2024-02-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
171	Employee 94	IT	Request for Monitor	Electronics	6	pcs	175.75	High	Pending	2021-09-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
172	Employee 48	Finance	Request for Headset	Electronics	9	pcs	93.14	Low	Pending	2022-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
173	Employee 40	IT	Request for Notebook	Services	3	pcs	5.21	Medium	Pending	2020-07-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
174	Employee 44	HR	Request for Sticky Notes	Software	5	pack	7.18	Low	Pending	2020-10-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
175	Employee 45	Operations	Request for Headset	Electronics	4	pcs	44.31	Medium	Pending	2023-02-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
176	Employee 73	Marketing	Request for Stapler	Office Supplies	10	pcs	11.57	Low	Pending	2022-07-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
177	Employee 55	IT	Request for Pen Set	Software	10	set	8.12	Medium	Pending	2023-11-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
178	Employee 40	Marketing	Request for Headset	Electronics	3	pcs	81.97	Medium	Pending	2023-05-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
179	Employee 87	Marketing	Request for Sticky Notes	Services	3	pack	7.14	High	Pending	2025-01-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
180	Employee 76	Operations	Request for Stapler	Office Supplies	9	pcs	14.16	Low	Pending	2023-08-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
181	Employee 68	Marketing	Request for Printing Paper	Office Supplies	3	box	14.58	Low	Pending	2021-02-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
182	Employee 32	Marketing	Request for Printing Paper	Software	8	box	6.93	Low	Pending	2024-02-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
183	Employee 18	HR	Request for Notebook	Software	9	pcs	3.44	Medium	Pending	2021-10-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
184	Employee 43	IT	Request for Stapler	Services	8	pcs	15.52	High	Pending	2024-02-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
185	Employee 85	Marketing	Request for Pen Set	Office Supplies	2	set	19.88	Low	Pending	2023-06-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
186	Employee 51	Operations	Request for Bookshelf	Furniture	5	pcs	222.21	High	Pending	2022-11-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
187	Employee 68	IT	Request for Bookshelf	Furniture	10	pcs	137.94	Low	Pending	2024-12-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
188	Employee 64	Operations	Request for Filing Cabinet	Furniture	9	pcs	362.63	Medium	Pending	2020-09-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
189	Employee 93	HR	Request for Printing Paper	Services	5	box	8.13	Low	Pending	2020-12-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
190	Employee 77	HR	Request for Desk	Furniture	4	pcs	269.83	High	Pending	2022-01-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
191	Employee 46	IT	Request for Office Chair	Furniture	9	pcs	265.14	High	Pending	2022-10-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
192	Employee 55	Finance	Request for Conference Table	Furniture	5	pcs	996.29	Low	Pending	2020-11-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
193	Employee 39	Finance	Request for Desk	Furniture	7	pcs	458.47	Low	Pending	2025-03-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
194	Employee 43	HR	Request for Printing Paper	Software	8	box	12.36	Medium	Pending	2022-10-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
195	Employee 77	IT	Request for Sticky Notes	Services	4	pack	5.03	High	Pending	2023-09-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
196	Employee 6	HR	Request for Conference Table	Furniture	4	pcs	1012.17	High	Pending	2024-11-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
197	Employee 83	Finance	Request for Stapler	Software	9	pcs	12.83	Low	Pending	2021-06-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
198	Employee 90	Operations	Request for Printing Paper	Services	6	box	6.59	Low	Pending	2020-10-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
199	Employee 94	Finance	Request for Pen Set	Software	4	set	17.94	Low	Pending	2024-04-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
200	Employee 63	Marketing	Request for Stapler	Software	5	pcs	24.62	Medium	Pending	2021-06-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
201	Employee 16	Operations	Request for Desk	Furniture	5	pcs	331.11	Medium	Pending	2020-09-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
202	Employee 56	HR	Request for Notebook	Services	4	pcs	6.62	High	Pending	2020-12-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
203	Employee 43	Marketing	Request for Notebook	Software	6	pcs	8.38	Low	Pending	2021-08-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
204	Employee 8	Operations	Request for Pen Set	Software	9	set	12.35	High	Pending	2023-04-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
205	Employee 68	Operations	Request for Stapler	Services	5	pcs	15.93	High	Pending	2024-05-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
206	Employee 12	Finance	Request for Desk	Furniture	7	pcs	440.05	Low	Pending	2024-08-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
207	Employee 32	Operations	Request for Desk	Furniture	6	pcs	455.09	Low	Pending	2022-05-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
208	Employee 44	Marketing	Request for Filing Cabinet	Furniture	10	pcs	294.15	Medium	Pending	2020-09-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
209	Employee 43	HR	Request for Notebook	Services	6	pcs	8.65	Low	Pending	2022-10-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
210	Employee 99	Marketing	Request for Notebook	Office Supplies	4	pcs	5.67	High	Pending	2022-07-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
211	Employee 5	Marketing	Request for Notebook	Office Supplies	1	pcs	4.61	High	Pending	2023-04-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
212	Employee 30	Operations	Request for Laptop	Electronics	7	pcs	791.83	Medium	Pending	2022-10-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
213	Employee 2	Finance	Request for Filing Cabinet	Furniture	2	pcs	294.32	Medium	Pending	2023-03-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
214	Employee 20	Marketing	Request for Headset	Electronics	4	pcs	136.82	Low	Pending	2022-05-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
215	Employee 52	HR	Request for Notebook	Office Supplies	3	pcs	6.91	Medium	Pending	2023-11-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
216	Employee 66	Finance	Request for Pen Set	Software	5	set	11.60	Medium	Pending	2020-12-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
217	Employee 5	Marketing	Request for Printing Paper	Services	8	box	9.72	Medium	Pending	2022-08-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
218	Employee 29	HR	Request for Notebook	Services	1	pcs	7.80	Low	Pending	2025-05-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
219	Employee 49	Operations	Request for Desk	Furniture	7	pcs	285.85	Medium	Pending	2023-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
220	Employee 58	IT	Request for Bookshelf	Furniture	10	pcs	97.31	Medium	Pending	2022-09-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
221	Employee 68	IT	Request for Sticky Notes	Office Supplies	9	pack	7.57	High	Pending	2024-01-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
222	Employee 21	Finance	Request for Pen Set	Office Supplies	6	set	14.46	Low	Pending	2021-04-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
223	Employee 16	IT	Request for Desk	Furniture	4	pcs	492.44	Medium	Pending	2021-05-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
224	Employee 26	Finance	Request for Mouse	Electronics	10	pcs	25.49	High	Pending	2022-12-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
225	Employee 3	Finance	Request for Pen Set	Software	8	set	19.54	High	Pending	2024-10-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
226	Employee 21	Marketing	Request for Pen Set	Office Supplies	7	set	14.52	Low	Pending	2023-12-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
227	Employee 32	Marketing	Request for Laptop	Electronics	5	pcs	478.07	Low	Pending	2020-11-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
228	Employee 27	Finance	Request for Pen Set	Office Supplies	7	set	8.87	Low	Pending	2021-02-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
229	Employee 83	Finance	Request for Notebook	Services	3	pcs	5.57	Medium	Pending	2024-10-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
230	Employee 51	Marketing	Request for Laptop	Electronics	10	pcs	622.47	Medium	Pending	2020-09-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
231	Employee 95	Marketing	Request for Pen Set	Services	7	set	19.30	Low	Pending	2021-08-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
232	Employee 11	HR	Request for Desk	Furniture	8	pcs	406.72	Low	Pending	2020-06-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
233	Employee 61	IT	Request for Laptop	Electronics	3	pcs	577.75	High	Pending	2020-10-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
234	Employee 81	HR	Request for Conference Table	Furniture	8	pcs	1967.61	Low	Pending	2022-09-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
235	Employee 52	Operations	Request for Printing Paper	Services	5	box	5.70	High	Pending	2022-05-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
236	Employee 93	Marketing	Request for Office Chair	Furniture	5	pcs	187.38	Medium	Pending	2024-08-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
237	Employee 61	Finance	Request for Sticky Notes	Office Supplies	10	pack	3.31	Low	Pending	2021-09-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
238	Employee 99	Marketing	Request for Sticky Notes	Services	1	pack	2.38	High	Pending	2024-08-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
239	Employee 46	HR	Request for Keyboard	Electronics	1	pcs	75.13	High	Pending	2024-02-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
240	Employee 17	Finance	Request for Monitor	Electronics	2	pcs	235.89	Low	Pending	2022-01-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
241	Employee 48	Marketing	Request for Stapler	Office Supplies	3	pcs	18.93	Low	Pending	2023-06-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
242	Employee 27	HR	Request for Filing Cabinet	Furniture	3	pcs	155.18	Low	Pending	2023-03-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
243	Employee 43	Finance	Request for Sticky Notes	Software	10	pack	5.99	Low	Pending	2022-05-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
244	Employee 31	Marketing	Request for Printing Paper	Software	6	box	13.20	High	Pending	2024-05-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
245	Employee 85	Marketing	Request for Monitor	Electronics	8	pcs	216.01	Low	Pending	2021-03-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
246	Employee 79	IT	Request for Sticky Notes	Services	1	pack	6.44	High	Pending	2023-09-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
247	Employee 86	Finance	Request for Sticky Notes	Services	7	pack	4.13	High	Pending	2023-03-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
248	Employee 10	HR	Request for Laptop	Electronics	4	pcs	715.50	High	Pending	2021-06-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
249	Employee 67	IT	Request for Sticky Notes	Software	4	pack	2.41	Medium	Pending	2024-06-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
250	Employee 3	Marketing	Request for Stapler	Office Supplies	9	pcs	16.28	Medium	Pending	2020-07-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
251	Employee 95	Operations	Request for Mouse	Electronics	2	pcs	23.77	High	Pending	2021-07-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
252	Employee 91	Finance	Request for Stapler	Office Supplies	10	pcs	14.65	Medium	Pending	2021-12-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
253	Employee 27	Operations	Request for Desk	Furniture	9	pcs	453.65	Medium	Pending	2024-08-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
254	Employee 52	Finance	Request for Printing Paper	Software	4	box	9.77	Medium	Pending	2022-02-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
255	Employee 48	Operations	Request for Notebook	Office Supplies	7	pcs	6.46	Low	Pending	2021-01-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
256	Employee 77	IT	Request for Printing Paper	Office Supplies	2	box	6.64	Medium	Pending	2022-09-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
257	Employee 84	HR	Request for Filing Cabinet	Furniture	10	pcs	272.68	Medium	Pending	2024-04-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
258	Employee 28	Finance	Request for Sticky Notes	Services	3	pack	6.68	High	Pending	2021-08-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
259	Employee 64	Finance	Request for Sticky Notes	Services	6	pack	5.95	Low	Pending	2023-07-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
260	Employee 26	Finance	Request for Notebook	Services	3	pcs	8.65	Low	Pending	2020-06-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
261	Employee 84	Operations	Request for Pen Set	Services	3	set	14.03	High	Pending	2020-07-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
262	Employee 35	Finance	Request for Stapler	Office Supplies	5	pcs	11.44	Low	Pending	2021-06-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
263	Employee 34	Marketing	Request for Pen Set	Services	2	set	9.46	Low	Pending	2024-10-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
264	Employee 28	HR	Request for Mouse	Electronics	9	pcs	29.36	High	Pending	2023-08-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
265	Employee 90	Finance	Request for Keyboard	Electronics	10	pcs	52.87	Medium	Pending	2023-03-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
266	Employee 2	Finance	Request for Stapler	Software	10	pcs	17.65	Low	Pending	2021-12-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
267	Employee 4	IT	Request for Notebook	Services	9	pcs	6.74	Low	Pending	2025-04-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
268	Employee 26	Finance	Request for Pen Set	Software	4	set	15.48	High	Pending	2021-01-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
269	Employee 67	Finance	Request for Mouse	Electronics	6	pcs	38.25	Low	Pending	2024-01-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
270	Employee 19	Marketing	Request for Printing Paper	Software	1	box	5.69	Medium	Pending	2020-06-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
271	Employee 97	IT	Request for Stapler	Office Supplies	2	pcs	17.74	High	Pending	2025-04-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
272	Employee 28	Finance	Request for Filing Cabinet	Furniture	9	pcs	395.38	Medium	Pending	2020-08-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
273	Employee 79	Operations	Request for Keyboard	Electronics	6	pcs	69.31	Medium	Pending	2025-03-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
274	Employee 64	Marketing	Request for Bookshelf	Furniture	7	pcs	94.92	Medium	Pending	2024-03-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
275	Employee 34	IT	Request for Notebook	Office Supplies	7	pcs	8.55	Low	Pending	2024-09-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
276	Employee 32	Finance	Request for Stapler	Software	6	pcs	18.23	High	Pending	2024-06-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
277	Employee 33	HR	Request for Mouse	Electronics	2	pcs	43.95	Low	Pending	2021-10-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
278	Employee 88	Marketing	Request for Notebook	Services	5	pcs	9.25	High	Pending	2020-11-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
279	Employee 36	IT	Request for Pen Set	Office Supplies	7	set	14.24	Low	Pending	2024-05-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
280	Employee 97	HR	Request for Mouse	Electronics	9	pcs	31.07	Medium	Pending	2021-04-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
281	Employee 57	Finance	Request for Sticky Notes	Software	5	pack	6.56	Medium	Pending	2021-11-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
282	Employee 33	Marketing	Request for Stapler	Office Supplies	10	pcs	11.88	Medium	Pending	2024-09-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
283	Employee 77	Finance	Request for Headset	Electronics	4	pcs	55.77	High	Pending	2023-12-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
284	Employee 96	Operations	Request for Bookshelf	Furniture	10	pcs	98.36	Low	Pending	2021-05-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
285	Employee 6	HR	Request for Office Chair	Furniture	5	pcs	155.12	Medium	Pending	2020-10-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
286	Employee 58	Finance	Request for Conference Table	Furniture	5	pcs	773.60	Low	Pending	2022-02-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
287	Employee 90	Operations	Request for Printing Paper	Office Supplies	3	box	7.20	High	Pending	2021-04-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
288	Employee 88	Marketing	Request for Mouse	Electronics	3	pcs	48.68	High	Pending	2025-01-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
289	Employee 80	Finance	Request for Stapler	Services	5	pcs	11.88	Low	Pending	2022-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
290	Employee 28	Marketing	Request for Stapler	Office Supplies	8	pcs	20.18	Low	Pending	2023-04-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
291	Employee 33	HR	Request for Conference Table	Furniture	6	pcs	1813.99	Low	Pending	2024-09-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
292	Employee 91	Operations	Request for Stapler	Software	2	pcs	19.25	High	Pending	2023-06-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
293	Employee 38	Operations	Request for Sticky Notes	Software	1	pack	2.05	High	Pending	2020-07-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
294	Employee 57	Finance	Request for Notebook	Office Supplies	8	pcs	3.75	Low	Pending	2022-07-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
295	Employee 53	Marketing	Request for Sticky Notes	Software	9	pack	3.46	Low	Pending	2024-06-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
296	Employee 3	Marketing	Request for Desk	Furniture	7	pcs	256.10	Low	Pending	2023-04-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
297	Employee 33	Finance	Request for Laptop	Electronics	3	pcs	482.98	High	Pending	2024-05-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
298	Employee 57	IT	Request for Mouse	Electronics	5	pcs	42.10	High	Pending	2023-12-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
299	Employee 95	Marketing	Request for Keyboard	Electronics	7	pcs	97.55	High	Pending	2022-05-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
300	Employee 71	Finance	Request for Sticky Notes	Software	7	pack	7.23	Medium	Pending	2022-08-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
301	Employee 13	IT	Request for Sticky Notes	Services	10	pack	5.84	Low	Pending	2023-04-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
302	Employee 44	HR	Request for Keyboard	Electronics	2	pcs	63.89	Medium	Pending	2023-07-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
303	Employee 89	HR	Request for Keyboard	Electronics	1	pcs	57.37	Medium	Pending	2024-01-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
304	Employee 87	Marketing	Request for Notebook	Software	8	pcs	8.55	High	Pending	2023-08-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
305	Employee 48	IT	Request for Keyboard	Electronics	8	pcs	78.44	High	Pending	2021-01-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
306	Employee 42	Marketing	Request for Stapler	Services	3	pcs	18.83	Medium	Pending	2024-09-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
307	Employee 38	Finance	Request for Notebook	Software	9	pcs	9.43	High	Pending	2022-08-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
308	Employee 60	HR	Request for Desk	Furniture	8	pcs	208.67	High	Pending	2023-03-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
309	Employee 9	HR	Request for Sticky Notes	Software	7	pack	4.38	High	Pending	2020-09-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
310	Employee 20	IT	Request for Stapler	Services	9	pcs	18.53	Medium	Pending	2024-07-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
311	Employee 100	HR	Request for Sticky Notes	Office Supplies	3	pack	5.38	Medium	Pending	2023-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
312	Employee 69	Finance	Request for Stapler	Software	4	pcs	11.85	High	Pending	2022-05-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
313	Employee 3	Finance	Request for Notebook	Office Supplies	6	pcs	3.56	High	Pending	2023-08-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
314	Employee 99	IT	Request for Sticky Notes	Services	1	pack	4.23	High	Pending	2022-06-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
315	Employee 56	Operations	Request for Stapler	Services	3	pcs	19.68	High	Pending	2022-10-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
316	Employee 52	Finance	Request for Printing Paper	Office Supplies	2	box	9.34	High	Pending	2021-05-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
317	Employee 53	Operations	Request for Headset	Electronics	4	pcs	90.36	Medium	Pending	2021-01-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
318	Employee 19	Operations	Request for Stapler	Services	3	pcs	17.08	High	Pending	2021-08-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
319	Employee 87	IT	Request for Pen Set	Software	10	set	13.63	High	Pending	2024-09-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
320	Employee 34	Marketing	Request for Stapler	Office Supplies	10	pcs	16.49	Low	Pending	2021-04-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
321	Employee 91	HR	Request for Conference Table	Furniture	3	pcs	1362.61	High	Pending	2024-04-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
322	Employee 12	Operations	Request for Stapler	Software	8	pcs	19.96	High	Pending	2022-03-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
323	Employee 29	IT	Request for Notebook	Office Supplies	6	pcs	8.50	High	Pending	2020-08-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
324	Employee 11	Marketing	Request for Pen Set	Services	8	set	11.09	Medium	Pending	2021-09-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
325	Employee 1	Operations	Request for Notebook	Office Supplies	7	pcs	5.06	Medium	Pending	2024-03-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
326	Employee 21	Marketing	Request for Filing Cabinet	Furniture	1	pcs	305.90	High	Pending	2024-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
327	Employee 15	Marketing	Request for Stapler	Services	6	pcs	16.56	High	Pending	2024-07-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
328	Employee 41	Operations	Request for Pen Set	Software	4	set	15.84	Medium	Pending	2025-02-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
329	Employee 9	Operations	Request for Office Chair	Furniture	10	pcs	159.55	Low	Pending	2020-12-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
330	Employee 81	Finance	Request for Sticky Notes	Office Supplies	6	pack	5.31	High	Pending	2022-04-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
331	Employee 72	IT	Request for Stapler	Office Supplies	10	pcs	22.33	High	Pending	2021-07-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
332	Employee 89	Operations	Request for Printing Paper	Services	7	box	6.20	High	Pending	2020-10-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
333	Employee 57	IT	Request for Printing Paper	Office Supplies	2	box	8.29	Medium	Pending	2025-01-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
334	Employee 81	Operations	Request for Stapler	Software	5	pcs	19.49	Low	Pending	2024-07-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
335	Employee 31	Operations	Request for Printing Paper	Services	9	box	12.11	Medium	Pending	2020-12-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
336	Employee 27	Operations	Request for Stapler	Software	9	pcs	20.40	High	Pending	2021-09-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
337	Employee 56	Finance	Request for Notebook	Services	7	pcs	5.45	Low	Pending	2024-09-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
338	Employee 99	Operations	Request for Sticky Notes	Software	3	pack	4.55	High	Pending	2023-09-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
339	Employee 37	HR	Request for Keyboard	Electronics	6	pcs	98.14	Medium	Pending	2025-02-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
340	Employee 51	Marketing	Request for Notebook	Services	5	pcs	7.85	Low	Pending	2025-03-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
341	Employee 73	Marketing	Request for Pen Set	Services	1	set	15.00	Medium	Pending	2023-10-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
342	Employee 42	Operations	Request for Stapler	Software	4	pcs	20.34	Medium	Pending	2023-04-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
343	Employee 77	Finance	Request for Notebook	Office Supplies	10	pcs	6.24	Low	Pending	2021-10-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
344	Employee 76	IT	Request for Printing Paper	Services	1	box	10.75	Low	Pending	2020-12-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
345	Employee 2	Marketing	Request for Sticky Notes	Office Supplies	2	pack	3.70	High	Pending	2023-04-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
346	Employee 47	Finance	Request for Stapler	Software	10	pcs	14.36	High	Pending	2020-11-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
347	Employee 81	IT	Request for Printing Paper	Services	9	box	14.18	Medium	Pending	2022-04-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
348	Employee 47	Finance	Request for Printing Paper	Office Supplies	2	box	8.80	High	Pending	2020-08-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
349	Employee 94	HR	Request for Sticky Notes	Software	3	pack	7.93	High	Pending	2024-10-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
350	Employee 65	Operations	Request for Desk	Furniture	4	pcs	485.15	Medium	Pending	2025-01-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
351	Employee 39	Marketing	Request for Stapler	Services	8	pcs	15.65	High	Pending	2025-03-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
352	Employee 91	IT	Request for Pen Set	Software	10	set	10.72	Low	Pending	2025-04-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
353	Employee 39	HR	Request for Notebook	Software	8	pcs	3.31	Low	Pending	2023-01-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
354	Employee 79	Finance	Request for Printing Paper	Software	2	box	13.17	High	Pending	2021-02-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
355	Employee 6	Finance	Request for Printing Paper	Software	7	box	10.15	Medium	Pending	2025-01-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
356	Employee 1	IT	Request for Notebook	Office Supplies	7	pcs	9.46	High	Pending	2021-07-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
357	Employee 84	HR	Request for Stapler	Services	10	pcs	16.38	Medium	Pending	2021-11-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
358	Employee 96	Marketing	Request for Conference Table	Furniture	8	pcs	729.56	High	Pending	2023-04-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
359	Employee 38	IT	Request for Sticky Notes	Office Supplies	10	pack	2.66	Low	Pending	2024-12-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
360	Employee 25	Finance	Request for Conference Table	Furniture	7	pcs	1067.78	Low	Pending	2024-01-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
361	Employee 74	Operations	Request for Monitor	Electronics	4	pcs	259.69	Medium	Pending	2021-08-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
362	Employee 87	IT	Request for Printing Paper	Office Supplies	3	box	13.75	Medium	Pending	2022-09-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
363	Employee 71	Marketing	Request for Bookshelf	Furniture	1	pcs	94.12	Low	Pending	2024-09-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
364	Employee 21	Operations	Request for Headset	Electronics	9	pcs	70.81	Low	Pending	2022-03-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
365	Employee 82	IT	Request for Laptop	Electronics	7	pcs	554.13	Medium	Pending	2023-10-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
366	Employee 96	IT	Request for Sticky Notes	Services	1	pack	3.67	Low	Pending	2021-03-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
367	Employee 30	Marketing	Request for Printing Paper	Software	5	box	11.93	High	Pending	2024-03-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
368	Employee 18	Marketing	Request for Bookshelf	Furniture	6	pcs	144.13	Low	Pending	2021-07-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
369	Employee 35	Marketing	Request for Filing Cabinet	Furniture	2	pcs	173.64	Medium	Pending	2023-06-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
370	Employee 72	Operations	Request for Desk	Furniture	6	pcs	229.08	Low	Pending	2024-08-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
371	Employee 40	HR	Request for Conference Table	Furniture	4	pcs	1356.07	Low	Pending	2024-08-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
372	Employee 95	HR	Request for Sticky Notes	Services	5	pack	3.36	High	Pending	2022-06-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
373	Employee 13	Operations	Request for Printing Paper	Software	1	box	11.20	High	Pending	2025-04-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
374	Employee 5	HR	Request for Printing Paper	Office Supplies	2	box	9.17	High	Pending	2021-05-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
375	Employee 29	Marketing	Request for Monitor	Electronics	2	pcs	170.68	High	Pending	2022-10-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
376	Employee 35	Finance	Request for Conference Table	Furniture	3	pcs	1339.07	Medium	Pending	2020-10-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
377	Employee 83	HR	Request for Notebook	Services	4	pcs	3.66	Low	Pending	2024-04-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
378	Employee 35	HR	Request for Notebook	Software	10	pcs	3.86	High	Pending	2023-12-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
379	Employee 99	Finance	Request for Notebook	Software	9	pcs	3.22	Medium	Pending	2020-06-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
380	Employee 59	IT	Request for Notebook	Office Supplies	4	pcs	8.04	Low	Pending	2021-05-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
381	Employee 29	Marketing	Request for Sticky Notes	Office Supplies	10	pack	7.96	High	Pending	2023-12-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
382	Employee 16	Operations	Request for Printing Paper	Office Supplies	2	box	8.66	Low	Pending	2021-11-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
383	Employee 7	Operations	Request for Office Chair	Furniture	3	pcs	221.45	Medium	Pending	2021-03-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
384	Employee 5	HR	Request for Notebook	Services	5	pcs	5.41	High	Pending	2023-03-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
385	Employee 26	Finance	Request for Stapler	Services	2	pcs	20.30	Medium	Pending	2021-11-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
386	Employee 13	Finance	Request for Stapler	Software	2	pcs	22.66	Medium	Pending	2022-12-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
387	Employee 32	HR	Request for Filing Cabinet	Furniture	8	pcs	367.51	High	Pending	2021-02-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
388	Employee 79	Operations	Request for Bookshelf	Furniture	4	pcs	138.69	Medium	Pending	2025-01-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
389	Employee 46	Marketing	Request for Monitor	Electronics	3	pcs	297.63	Low	Pending	2022-12-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
390	Employee 52	Operations	Request for Notebook	Software	9	pcs	6.24	Low	Pending	2024-11-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
391	Employee 12	HR	Request for Notebook	Office Supplies	4	pcs	7.09	Medium	Pending	2024-03-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
392	Employee 17	IT	Request for Printing Paper	Services	4	box	10.65	Low	Pending	2025-04-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
393	Employee 26	IT	Request for Pen Set	Services	9	set	11.51	High	Pending	2023-12-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
394	Employee 22	Finance	Request for Notebook	Office Supplies	2	pcs	9.53	Medium	Pending	2021-11-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
395	Employee 36	Marketing	Request for Stapler	Office Supplies	8	pcs	16.48	High	Pending	2021-12-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
396	Employee 16	Operations	Request for Pen Set	Services	8	set	12.71	Low	Pending	2023-05-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
397	Employee 18	Marketing	Request for Sticky Notes	Office Supplies	5	pack	3.03	Low	Pending	2024-02-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
398	Employee 53	HR	Request for Notebook	Office Supplies	4	pcs	4.91	High	Pending	2021-07-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
399	Employee 73	Finance	Request for Bookshelf	Furniture	1	pcs	94.85	High	Pending	2023-01-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
400	Employee 72	Marketing	Request for Pen Set	Software	3	set	16.57	Medium	Pending	2024-06-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
401	Employee 95	Finance	Request for Laptop	Electronics	3	pcs	496.55	High	Pending	2020-10-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
402	Employee 53	Marketing	Request for Conference Table	Furniture	8	pcs	1810.15	Medium	Pending	2020-08-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
403	Employee 79	Operations	Request for Monitor	Electronics	3	pcs	241.58	Medium	Pending	2024-03-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
404	Employee 2	HR	Request for Headset	Electronics	1	pcs	79.68	High	Pending	2024-06-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
405	Employee 94	Operations	Request for Pen Set	Office Supplies	7	set	12.90	Low	Pending	2022-11-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
406	Employee 87	HR	Request for Printing Paper	Software	1	box	14.02	Medium	Pending	2024-10-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
407	Employee 53	Operations	Request for Sticky Notes	Services	3	pack	2.93	Medium	Pending	2022-05-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
408	Employee 53	IT	Request for Sticky Notes	Services	8	pack	2.00	High	Pending	2024-02-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
409	Employee 7	IT	Request for Printing Paper	Software	9	box	12.61	Medium	Pending	2021-07-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
410	Employee 87	Operations	Request for Printing Paper	Services	7	box	14.29	Low	Pending	2021-11-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
411	Employee 85	HR	Request for Sticky Notes	Services	3	pack	7.96	High	Pending	2024-01-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
412	Employee 25	Operations	Request for Pen Set	Software	1	set	18.38	Medium	Pending	2021-03-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
413	Employee 96	IT	Request for Printing Paper	Software	3	box	13.18	High	Pending	2020-09-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
414	Employee 16	IT	Request for Notebook	Services	5	pcs	7.31	Medium	Pending	2025-02-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
415	Employee 62	Marketing	Request for Notebook	Services	4	pcs	7.82	Low	Pending	2023-05-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
416	Employee 64	Finance	Request for Mouse	Electronics	4	pcs	21.64	Low	Pending	2025-05-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
417	Employee 62	IT	Request for Stapler	Software	9	pcs	23.63	Medium	Pending	2022-03-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
418	Employee 64	HR	Request for Desk	Furniture	8	pcs	218.85	Low	Pending	2023-04-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
419	Employee 66	Marketing	Request for Bookshelf	Furniture	1	pcs	249.93	Medium	Pending	2023-01-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
420	Employee 32	Marketing	Request for Pen Set	Services	3	set	14.80	Low	Pending	2023-11-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
421	Employee 29	HR	Request for Printing Paper	Software	7	box	8.85	Medium	Pending	2023-05-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
422	Employee 23	Marketing	Request for Office Chair	Furniture	2	pcs	296.12	Low	Pending	2023-07-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
423	Employee 68	IT	Request for Stapler	Office Supplies	10	pcs	18.40	High	Pending	2025-04-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
424	Employee 96	HR	Request for Sticky Notes	Services	4	pack	3.49	High	Pending	2021-05-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
425	Employee 18	Finance	Request for Stapler	Services	2	pcs	20.95	Low	Pending	2021-05-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
426	Employee 63	Operations	Request for Filing Cabinet	Furniture	8	pcs	350.95	Medium	Pending	2023-08-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
427	Employee 57	IT	Request for Monitor	Electronics	5	pcs	232.32	Low	Pending	2020-06-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
428	Employee 35	HR	Request for Pen Set	Office Supplies	7	set	14.30	Low	Pending	2022-10-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
429	Employee 32	Finance	Request for Filing Cabinet	Furniture	2	pcs	181.27	Medium	Pending	2023-11-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
430	Employee 33	IT	Request for Pen Set	Services	2	set	15.15	Medium	Pending	2023-04-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
431	Employee 43	Marketing	Request for Stapler	Services	5	pcs	20.29	High	Pending	2023-02-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
432	Employee 100	Finance	Request for Sticky Notes	Software	9	pack	6.70	Medium	Pending	2025-05-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
433	Employee 81	IT	Request for Pen Set	Office Supplies	5	set	9.42	High	Pending	2022-02-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
434	Employee 56	Operations	Request for Printing Paper	Office Supplies	4	box	13.33	High	Pending	2020-10-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
435	Employee 81	Marketing	Request for Stapler	Services	2	pcs	12.63	Medium	Pending	2020-09-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
436	Employee 27	Finance	Request for Mouse	Electronics	8	pcs	44.32	High	Pending	2022-11-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
437	Employee 83	Marketing	Request for Sticky Notes	Software	7	pack	7.16	High	Pending	2023-03-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
438	Employee 21	IT	Request for Office Chair	Furniture	1	pcs	273.07	Low	Pending	2022-02-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
439	Employee 15	Finance	Request for Notebook	Services	10	pcs	7.87	High	Pending	2022-09-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
440	Employee 88	Finance	Request for Mouse	Electronics	4	pcs	26.26	Low	Pending	2024-11-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
441	Employee 40	Finance	Request for Notebook	Software	6	pcs	7.90	Low	Pending	2021-08-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
442	Employee 39	Marketing	Request for Bookshelf	Furniture	6	pcs	192.01	Low	Pending	2024-06-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
443	Employee 67	HR	Request for Notebook	Office Supplies	2	pcs	4.22	Low	Pending	2024-05-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
444	Employee 48	Marketing	Request for Stapler	Services	9	pcs	15.98	Low	Pending	2023-08-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
445	Employee 47	Marketing	Request for Office Chair	Furniture	5	pcs	174.92	Low	Pending	2024-03-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
446	Employee 66	HR	Request for Sticky Notes	Software	4	pack	3.77	High	Pending	2023-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
447	Employee 37	HR	Request for Notebook	Services	9	pcs	3.38	High	Pending	2020-12-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
448	Employee 36	HR	Request for Sticky Notes	Services	6	pack	3.37	High	Pending	2021-05-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
449	Employee 17	IT	Request for Notebook	Services	3	pcs	3.44	Low	Pending	2024-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
450	Employee 6	Operations	Request for Bookshelf	Furniture	4	pcs	143.97	Medium	Pending	2022-08-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
451	Employee 23	IT	Request for Laptop	Electronics	7	pcs	428.00	Medium	Pending	2024-06-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
452	Employee 64	Finance	Request for Filing Cabinet	Furniture	4	pcs	358.40	Medium	Pending	2020-07-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
453	Employee 69	IT	Request for Sticky Notes	Office Supplies	10	pack	7.97	Medium	Pending	2021-03-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
454	Employee 66	Operations	Request for Stapler	Services	6	pcs	13.32	Low	Pending	2023-04-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
455	Employee 49	Operations	Request for Mouse	Electronics	1	pcs	48.79	Low	Pending	2023-12-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
456	Employee 10	Marketing	Request for Mouse	Electronics	2	pcs	38.69	High	Pending	2023-03-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
457	Employee 73	IT	Request for Pen Set	Software	10	set	14.35	High	Pending	2021-05-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
458	Employee 68	Marketing	Request for Pen Set	Software	5	set	14.40	High	Pending	2023-03-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
459	Employee 5	Finance	Request for Office Chair	Furniture	10	pcs	206.60	Medium	Pending	2023-05-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
460	Employee 27	Marketing	Request for Pen Set	Software	4	set	10.75	Low	Pending	2025-01-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
461	Employee 37	Finance	Request for Notebook	Software	5	pcs	7.40	High	Pending	2021-03-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
462	Employee 70	IT	Request for Laptop	Electronics	10	pcs	523.81	Low	Pending	2024-03-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
463	Employee 48	IT	Request for Stapler	Software	1	pcs	10.89	Low	Pending	2022-01-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
464	Employee 5	IT	Request for Conference Table	Furniture	9	pcs	1596.05	High	Pending	2021-10-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
465	Employee 17	HR	Request for Headset	Electronics	5	pcs	119.80	Low	Pending	2021-03-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
466	Employee 25	Operations	Request for Printing Paper	Software	2	box	8.17	Low	Pending	2020-12-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
467	Employee 82	Marketing	Request for Stapler	Office Supplies	6	pcs	10.91	High	Pending	2023-05-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
468	Employee 27	Marketing	Request for Desk	Furniture	4	pcs	305.15	High	Pending	2024-01-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
469	Employee 41	Marketing	Request for Notebook	Services	1	pcs	8.24	Medium	Pending	2024-03-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
470	Employee 58	Marketing	Request for Pen Set	Software	10	set	9.34	High	Pending	2021-01-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
471	Employee 64	IT	Request for Stapler	Office Supplies	9	pcs	17.30	Medium	Pending	2022-04-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
472	Employee 51	Marketing	Request for Desk	Furniture	2	pcs	318.45	Medium	Pending	2020-06-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
473	Employee 62	IT	Request for Printing Paper	Software	2	box	12.70	High	Pending	2025-03-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
474	Employee 31	IT	Request for Laptop	Electronics	1	pcs	440.72	Medium	Pending	2022-01-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
475	Employee 26	IT	Request for Laptop	Electronics	5	pcs	438.76	Low	Pending	2020-11-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
476	Employee 80	HR	Request for Monitor	Electronics	8	pcs	293.70	Low	Pending	2022-04-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
477	Employee 78	IT	Request for Monitor	Electronics	8	pcs	202.09	High	Pending	2020-12-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
478	Employee 10	Marketing	Request for Stapler	Software	10	pcs	12.58	Low	Pending	2024-05-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
479	Employee 13	Operations	Request for Stapler	Office Supplies	3	pcs	13.30	Medium	Pending	2022-03-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
480	Employee 86	HR	Request for Notebook	Software	9	pcs	7.11	Low	Pending	2021-08-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
481	Employee 92	Marketing	Request for Printing Paper	Office Supplies	7	box	14.58	Low	Pending	2022-12-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
482	Employee 68	Marketing	Request for Filing Cabinet	Furniture	6	pcs	390.18	Medium	Pending	2020-09-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
483	Employee 4	IT	Request for Desk	Furniture	4	pcs	349.37	Low	Pending	2020-06-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
484	Employee 41	IT	Request for Laptop	Electronics	4	pcs	719.71	Low	Pending	2024-05-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
485	Employee 46	IT	Request for Keyboard	Electronics	10	pcs	97.24	Low	Pending	2022-04-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
486	Employee 2	Marketing	Request for Stapler	Software	6	pcs	14.95	Low	Pending	2025-03-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
487	Employee 64	Marketing	Request for Stapler	Office Supplies	10	pcs	19.51	High	Pending	2021-09-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
488	Employee 37	Finance	Request for Conference Table	Furniture	9	pcs	572.30	Medium	Pending	2023-02-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
489	Employee 99	Finance	Request for Monitor	Electronics	2	pcs	268.12	Low	Pending	2020-07-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
490	Employee 7	Finance	Request for Keyboard	Electronics	2	pcs	59.20	High	Pending	2025-04-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
491	Employee 96	Operations	Request for Mouse	Electronics	2	pcs	25.94	High	Pending	2025-03-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
492	Employee 38	IT	Request for Sticky Notes	Software	5	pack	6.66	Medium	Pending	2023-04-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
493	Employee 92	Finance	Request for Desk	Furniture	6	pcs	243.03	High	Pending	2023-11-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
494	Employee 29	Finance	Request for Bookshelf	Furniture	7	pcs	235.29	High	Pending	2023-06-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
495	Employee 10	Operations	Request for Desk	Furniture	9	pcs	426.90	Medium	Pending	2020-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
496	Employee 72	HR	Request for Stapler	Software	7	pcs	18.81	Low	Pending	2020-06-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
497	Employee 64	IT	Request for Sticky Notes	Services	1	pack	7.83	Low	Pending	2022-07-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
498	Employee 69	IT	Request for Sticky Notes	Software	7	pack	4.71	Low	Pending	2022-08-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
499	Employee 46	Operations	Request for Mouse	Electronics	10	pcs	48.71	High	Pending	2020-08-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
500	Employee 50	HR	Request for Sticky Notes	Software	2	pack	2.79	Low	Pending	2021-01-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
501	Employee 51	Marketing	Request for Filing Cabinet	Furniture	7	pcs	357.10	Medium	Pending	2021-03-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
502	Employee 16	Marketing	Request for Laptop	Electronics	4	pcs	731.87	Medium	Pending	2021-04-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
503	Employee 22	Marketing	Request for Notebook	Software	1	pcs	3.03	Low	Pending	2022-09-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
504	Employee 67	IT	Request for Stapler	Software	5	pcs	23.64	High	Pending	2020-09-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
505	Employee 85	IT	Request for Notebook	Office Supplies	6	pcs	6.51	High	Pending	2021-12-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
506	Employee 82	Finance	Request for Monitor	Electronics	9	pcs	216.71	Medium	Pending	2021-07-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
507	Employee 91	Marketing	Request for Monitor	Electronics	2	pcs	233.05	Medium	Pending	2023-07-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
508	Employee 16	Marketing	Request for Office Chair	Furniture	7	pcs	249.62	High	Pending	2024-04-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
509	Employee 100	Finance	Request for Printing Paper	Services	1	box	7.35	High	Pending	2024-10-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
510	Employee 92	Finance	Request for Filing Cabinet	Furniture	10	pcs	236.51	Low	Pending	2021-12-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
511	Employee 77	Marketing	Request for Notebook	Services	10	pcs	4.70	High	Pending	2021-06-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
512	Employee 43	IT	Request for Pen Set	Software	10	set	9.98	High	Pending	2022-10-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
513	Employee 73	Marketing	Request for Bookshelf	Furniture	1	pcs	201.74	High	Pending	2024-06-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
514	Employee 2	Marketing	Request for Printing Paper	Services	3	box	9.59	High	Pending	2021-09-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
515	Employee 54	IT	Request for Pen Set	Software	5	set	8.26	Medium	Pending	2023-01-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
516	Employee 84	Finance	Request for Pen Set	Office Supplies	9	set	12.91	High	Pending	2024-08-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
517	Employee 91	Marketing	Request for Sticky Notes	Services	7	pack	2.10	Medium	Pending	2024-12-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
518	Employee 36	Operations	Request for Office Chair	Furniture	3	pcs	272.91	Low	Pending	2023-12-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
519	Employee 63	Operations	Request for Pen Set	Software	2	set	15.51	Low	Pending	2023-10-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
520	Employee 100	Marketing	Request for Office Chair	Furniture	6	pcs	210.01	Medium	Pending	2022-06-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
521	Employee 25	HR	Request for Sticky Notes	Software	8	pack	3.62	High	Pending	2022-05-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
522	Employee 21	HR	Request for Sticky Notes	Software	6	pack	3.88	Low	Pending	2022-01-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
523	Employee 85	HR	Request for Notebook	Services	3	pcs	8.01	Medium	Pending	2024-02-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
524	Employee 26	Finance	Request for Sticky Notes	Office Supplies	1	pack	6.22	Medium	Pending	2020-10-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
525	Employee 14	IT	Request for Notebook	Software	1	pcs	5.80	Low	Pending	2024-01-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
526	Employee 42	Marketing	Request for Conference Table	Furniture	9	pcs	1796.76	Medium	Pending	2022-01-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
527	Employee 67	Operations	Request for Sticky Notes	Software	7	pack	7.29	Medium	Pending	2022-07-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
528	Employee 97	Finance	Request for Notebook	Office Supplies	4	pcs	4.23	High	Pending	2021-04-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
529	Employee 76	Marketing	Request for Printing Paper	Services	8	box	8.72	Low	Pending	2024-10-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
530	Employee 64	Finance	Request for Desk	Furniture	10	pcs	347.10	High	Pending	2024-12-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
531	Employee 39	Marketing	Request for Desk	Furniture	8	pcs	456.21	Medium	Pending	2020-06-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
532	Employee 19	Marketing	Request for Stapler	Services	1	pcs	20.17	High	Pending	2020-09-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
533	Employee 29	Marketing	Request for Stapler	Office Supplies	9	pcs	12.57	Low	Pending	2025-01-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
534	Employee 84	HR	Request for Notebook	Software	10	pcs	9.38	Medium	Pending	2025-05-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
535	Employee 80	HR	Request for Pen Set	Software	2	set	18.19	Low	Pending	2024-04-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
536	Employee 10	Finance	Request for Sticky Notes	Software	6	pack	5.44	Medium	Pending	2024-04-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
537	Employee 80	HR	Request for Stapler	Office Supplies	5	pcs	15.60	Low	Pending	2023-02-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
538	Employee 34	IT	Request for Sticky Notes	Office Supplies	7	pack	7.99	High	Pending	2023-12-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
539	Employee 57	HR	Request for Printing Paper	Office Supplies	7	box	14.87	Medium	Pending	2021-05-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
540	Employee 31	Finance	Request for Pen Set	Office Supplies	7	set	19.23	Medium	Pending	2023-07-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
541	Employee 100	Finance	Request for Printing Paper	Services	8	box	7.49	High	Pending	2024-12-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
542	Employee 77	Marketing	Request for Pen Set	Services	10	set	19.88	Low	Pending	2023-05-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
543	Employee 65	IT	Request for Sticky Notes	Software	3	pack	4.02	High	Pending	2021-12-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
544	Employee 53	Finance	Request for Notebook	Software	8	pcs	5.98	High	Pending	2022-10-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
545	Employee 79	Finance	Request for Keyboard	Electronics	3	pcs	77.60	High	Pending	2021-10-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
546	Employee 39	IT	Request for Notebook	Office Supplies	10	pcs	4.15	High	Pending	2024-10-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
547	Employee 36	Marketing	Request for Sticky Notes	Services	9	pack	6.61	Low	Pending	2021-08-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
548	Employee 44	Marketing	Request for Notebook	Software	9	pcs	5.57	Low	Pending	2020-06-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
549	Employee 79	Operations	Request for Notebook	Software	8	pcs	7.31	Low	Pending	2025-01-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
550	Employee 73	Marketing	Request for Pen Set	Office Supplies	1	set	12.35	Low	Pending	2024-05-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
551	Employee 12	Finance	Request for Sticky Notes	Software	9	pack	3.21	Medium	Pending	2022-08-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
552	Employee 48	Finance	Request for Bookshelf	Furniture	9	pcs	111.43	High	Pending	2022-09-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
553	Employee 86	IT	Request for Stapler	Services	7	pcs	13.33	High	Pending	2024-06-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
554	Employee 4	Finance	Request for Keyboard	Electronics	6	pcs	87.55	Low	Pending	2023-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
555	Employee 62	HR	Request for Printing Paper	Office Supplies	7	box	10.58	Medium	Pending	2021-09-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
556	Employee 27	Operations	Request for Monitor	Electronics	4	pcs	226.15	Low	Pending	2022-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
557	Employee 72	Operations	Request for Sticky Notes	Office Supplies	1	pack	5.94	Low	Pending	2020-09-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
558	Employee 3	IT	Request for Printing Paper	Software	5	box	12.78	Low	Pending	2022-10-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
559	Employee 95	Operations	Request for Filing Cabinet	Furniture	1	pcs	266.21	Low	Pending	2022-02-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
560	Employee 69	Finance	Request for Notebook	Software	9	pcs	9.59	High	Pending	2020-12-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
561	Employee 74	HR	Request for Desk	Furniture	2	pcs	376.19	High	Pending	2024-08-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
562	Employee 21	IT	Request for Notebook	Office Supplies	9	pcs	7.54	Medium	Pending	2021-08-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
563	Employee 15	Marketing	Request for Sticky Notes	Services	2	pack	4.60	Medium	Pending	2024-02-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
564	Employee 72	IT	Request for Printing Paper	Office Supplies	9	box	9.78	Low	Pending	2020-09-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
565	Employee 99	HR	Request for Printing Paper	Office Supplies	3	box	7.54	Medium	Pending	2022-04-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
566	Employee 96	HR	Request for Office Chair	Furniture	6	pcs	130.15	Low	Pending	2020-08-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
567	Employee 75	Finance	Request for Printing Paper	Services	7	box	5.05	Medium	Pending	2022-09-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
568	Employee 55	Finance	Request for Pen Set	Software	4	set	14.48	High	Pending	2021-02-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
569	Employee 84	Finance	Request for Printing Paper	Office Supplies	7	box	12.62	Medium	Pending	2022-04-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
570	Employee 72	HR	Request for Pen Set	Software	2	set	13.49	High	Pending	2025-04-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
571	Employee 16	HR	Request for Laptop	Electronics	5	pcs	467.20	High	Pending	2021-12-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
572	Employee 60	IT	Request for Stapler	Office Supplies	9	pcs	23.36	Medium	Pending	2020-06-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
573	Employee 42	HR	Request for Stapler	Office Supplies	9	pcs	17.49	Medium	Pending	2023-09-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
574	Employee 54	Operations	Request for Keyboard	Electronics	10	pcs	70.47	Low	Pending	2024-10-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
575	Employee 6	Marketing	Request for Monitor	Electronics	8	pcs	170.65	Low	Pending	2022-05-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
576	Employee 91	Marketing	Request for Pen Set	Software	7	set	17.49	High	Pending	2023-03-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
577	Employee 4	HR	Request for Pen Set	Office Supplies	1	set	19.30	Medium	Pending	2022-10-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
578	Employee 18	Operations	Request for Notebook	Software	1	pcs	9.52	Low	Pending	2023-11-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
579	Employee 25	Operations	Request for Monitor	Electronics	10	pcs	264.09	Medium	Pending	2025-04-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
580	Employee 70	Finance	Request for Sticky Notes	Software	8	pack	5.63	High	Pending	2021-12-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
581	Employee 75	Finance	Request for Notebook	Services	9	pcs	8.28	Low	Pending	2021-07-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
582	Employee 92	Marketing	Request for Filing Cabinet	Furniture	3	pcs	190.61	Medium	Pending	2024-04-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
583	Employee 94	HR	Request for Stapler	Office Supplies	3	pcs	23.45	Low	Pending	2024-01-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
584	Employee 51	Finance	Request for Filing Cabinet	Furniture	6	pcs	173.33	Medium	Pending	2023-03-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
585	Employee 74	Marketing	Request for Sticky Notes	Software	7	pack	6.20	Low	Pending	2024-02-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
586	Employee 53	Marketing	Request for Desk	Furniture	10	pcs	459.44	Medium	Pending	2022-09-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
587	Employee 78	Finance	Request for Mouse	Electronics	4	pcs	35.37	High	Pending	2024-03-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
588	Employee 100	Marketing	Request for Sticky Notes	Services	10	pack	3.13	Low	Pending	2020-08-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
589	Employee 51	IT	Request for Conference Table	Furniture	7	pcs	543.31	Low	Pending	2022-10-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
590	Employee 16	HR	Request for Stapler	Software	9	pcs	20.26	Low	Pending	2020-11-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
591	Employee 37	IT	Request for Pen Set	Office Supplies	8	set	19.62	High	Pending	2022-08-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
592	Employee 96	Marketing	Request for Monitor	Electronics	7	pcs	226.89	Medium	Pending	2024-05-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
593	Employee 7	Finance	Request for Laptop	Electronics	10	pcs	772.69	Low	Pending	2023-10-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
594	Employee 89	Marketing	Request for Pen Set	Office Supplies	2	set	10.54	Medium	Pending	2021-09-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
595	Employee 60	Marketing	Request for Sticky Notes	Office Supplies	7	pack	6.24	High	Pending	2023-05-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
596	Employee 42	Finance	Request for Bookshelf	Furniture	9	pcs	203.01	High	Pending	2022-11-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
597	Employee 62	IT	Request for Filing Cabinet	Furniture	8	pcs	178.96	High	Pending	2023-02-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
598	Employee 75	Finance	Request for Pen Set	Services	1	set	9.37	High	Pending	2021-07-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
599	Employee 3	IT	Request for Bookshelf	Furniture	2	pcs	130.03	High	Pending	2022-04-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
600	Employee 75	Marketing	Request for Pen Set	Office Supplies	4	set	14.70	Low	Pending	2023-05-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
601	Employee 93	HR	Request for Stapler	Office Supplies	8	pcs	21.10	Medium	Pending	2024-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
602	Employee 62	Operations	Request for Stapler	Software	9	pcs	12.73	Low	Pending	2020-07-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
603	Employee 41	Operations	Request for Pen Set	Software	4	set	14.51	High	Pending	2022-02-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
604	Employee 19	HR	Request for Notebook	Services	10	pcs	5.02	Low	Pending	2021-06-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
605	Employee 42	Marketing	Request for Keyboard	Electronics	8	pcs	65.29	High	Pending	2021-09-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
606	Employee 12	IT	Request for Keyboard	Electronics	2	pcs	76.37	Medium	Pending	2025-02-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
607	Employee 54	Marketing	Request for Desk	Furniture	8	pcs	429.19	Medium	Pending	2024-01-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
608	Employee 85	HR	Request for Notebook	Software	9	pcs	5.10	Low	Pending	2021-07-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
609	Employee 17	IT	Request for Stapler	Office Supplies	3	pcs	21.88	Low	Pending	2023-02-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
610	Employee 87	Operations	Request for Laptop	Electronics	8	pcs	454.08	High	Pending	2022-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
611	Employee 58	Marketing	Request for Stapler	Office Supplies	1	pcs	18.74	Low	Pending	2022-12-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
612	Employee 52	HR	Request for Printing Paper	Services	4	box	6.51	High	Pending	2024-05-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
613	Employee 39	IT	Request for Desk	Furniture	10	pcs	385.58	Medium	Pending	2022-01-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
614	Employee 43	Operations	Request for Printing Paper	Office Supplies	5	box	10.10	Low	Pending	2024-10-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
615	Employee 67	Finance	Request for Printing Paper	Services	6	box	14.62	Medium	Pending	2021-01-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
616	Employee 14	HR	Request for Headset	Electronics	5	pcs	108.10	High	Pending	2022-08-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
617	Employee 42	Operations	Request for Keyboard	Electronics	4	pcs	87.04	High	Pending	2021-04-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
618	Employee 21	Marketing	Request for Sticky Notes	Software	6	pack	6.47	Medium	Pending	2022-01-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
619	Employee 85	Finance	Request for Mouse	Electronics	3	pcs	24.99	Low	Pending	2023-06-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
620	Employee 14	Finance	Request for Pen Set	Software	10	set	10.14	Low	Pending	2023-06-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
621	Employee 92	Operations	Request for Sticky Notes	Services	3	pack	5.44	Low	Pending	2024-05-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
622	Employee 21	Finance	Request for Stapler	Services	7	pcs	17.53	Low	Pending	2024-06-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
623	Employee 78	HR	Request for Desk	Furniture	2	pcs	409.32	Medium	Pending	2021-03-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
624	Employee 25	HR	Request for Sticky Notes	Services	6	pack	2.09	Medium	Pending	2024-05-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
625	Employee 59	HR	Request for Printing Paper	Services	3	box	12.55	Low	Pending	2022-04-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
626	Employee 91	Marketing	Request for Notebook	Office Supplies	8	pcs	9.27	High	Pending	2023-05-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
627	Employee 44	Marketing	Request for Notebook	Software	2	pcs	7.25	High	Pending	2024-11-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
628	Employee 36	IT	Request for Mouse	Electronics	8	pcs	30.23	Low	Pending	2021-08-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
629	Employee 4	IT	Request for Notebook	Office Supplies	3	pcs	3.31	High	Pending	2023-01-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
630	Employee 36	HR	Request for Pen Set	Services	9	set	8.52	Medium	Pending	2023-04-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
631	Employee 76	IT	Request for Notebook	Software	10	pcs	6.29	Low	Pending	2020-08-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
632	Employee 46	IT	Request for Pen Set	Software	1	set	12.85	High	Pending	2023-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
633	Employee 55	Finance	Request for Notebook	Office Supplies	7	pcs	9.30	Low	Pending	2025-03-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
634	Employee 49	Finance	Request for Desk	Furniture	4	pcs	413.58	Medium	Pending	2022-07-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
635	Employee 51	IT	Request for Pen Set	Services	3	set	18.57	Medium	Pending	2021-10-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
636	Employee 60	Marketing	Request for Conference Table	Furniture	7	pcs	1953.96	Low	Pending	2025-02-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
637	Employee 20	IT	Request for Notebook	Services	5	pcs	9.26	Low	Pending	2020-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
638	Employee 95	IT	Request for Office Chair	Furniture	1	pcs	187.29	Low	Pending	2022-06-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
639	Employee 90	HR	Request for Pen Set	Services	9	set	15.31	Medium	Pending	2025-02-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
640	Employee 75	IT	Request for Mouse	Electronics	3	pcs	25.68	Low	Pending	2023-05-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
641	Employee 49	HR	Request for Stapler	Services	8	pcs	14.16	Low	Pending	2022-08-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
642	Employee 26	IT	Request for Stapler	Office Supplies	5	pcs	16.75	Medium	Pending	2021-04-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
643	Employee 60	Operations	Request for Monitor	Electronics	9	pcs	265.65	High	Pending	2025-05-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
644	Employee 20	HR	Request for Filing Cabinet	Furniture	6	pcs	185.23	High	Pending	2023-03-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
645	Employee 49	IT	Request for Sticky Notes	Services	9	pack	4.94	Medium	Pending	2021-07-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
646	Employee 61	IT	Request for Printing Paper	Software	3	box	6.30	High	Pending	2022-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
647	Employee 58	Operations	Request for Sticky Notes	Office Supplies	3	pack	5.01	Medium	Pending	2022-10-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
648	Employee 78	Finance	Request for Stapler	Office Supplies	9	pcs	16.72	High	Pending	2021-11-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
649	Employee 1	Finance	Request for Printing Paper	Office Supplies	6	box	5.55	Low	Pending	2024-05-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
650	Employee 31	Marketing	Request for Sticky Notes	Software	5	pack	2.05	High	Pending	2022-07-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
651	Employee 97	Operations	Request for Sticky Notes	Software	4	pack	6.20	High	Pending	2020-09-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
652	Employee 10	Marketing	Request for Headset	Electronics	5	pcs	84.69	Medium	Pending	2022-05-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
653	Employee 66	Marketing	Request for Laptop	Electronics	1	pcs	768.40	Low	Pending	2024-05-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
654	Employee 100	Operations	Request for Stapler	Software	7	pcs	19.80	Low	Pending	2021-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
655	Employee 17	Finance	Request for Notebook	Services	4	pcs	9.54	Medium	Pending	2022-08-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
656	Employee 78	Finance	Request for Notebook	Office Supplies	6	pcs	4.07	High	Pending	2020-12-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
657	Employee 50	Marketing	Request for Notebook	Software	10	pcs	7.18	Medium	Pending	2020-06-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
658	Employee 73	Operations	Request for Printing Paper	Office Supplies	7	box	10.36	High	Pending	2021-03-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
659	Employee 45	IT	Request for Pen Set	Office Supplies	10	set	9.99	Medium	Pending	2022-12-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
660	Employee 22	Operations	Request for Sticky Notes	Services	2	pack	3.63	Low	Pending	2023-06-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
661	Employee 63	IT	Request for Notebook	Services	1	pcs	8.64	Low	Pending	2023-12-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
662	Employee 63	Marketing	Request for Pen Set	Services	10	set	11.64	High	Pending	2023-05-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
663	Employee 86	Operations	Request for Sticky Notes	Office Supplies	1	pack	5.07	Medium	Pending	2021-11-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
664	Employee 13	Marketing	Request for Notebook	Office Supplies	7	pcs	8.25	High	Pending	2021-03-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
665	Employee 57	IT	Request for Mouse	Electronics	4	pcs	31.17	High	Pending	2022-07-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
666	Employee 77	HR	Request for Stapler	Services	6	pcs	21.13	Low	Pending	2023-12-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
667	Employee 84	Marketing	Request for Pen Set	Office Supplies	5	set	8.12	Low	Pending	2021-07-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
668	Employee 73	Finance	Request for Pen Set	Office Supplies	3	set	8.54	High	Pending	2024-07-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
669	Employee 89	Operations	Request for Sticky Notes	Services	4	pack	6.71	Medium	Pending	2020-12-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
670	Employee 60	IT	Request for Filing Cabinet	Furniture	1	pcs	306.18	Medium	Pending	2025-05-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
671	Employee 8	Finance	Request for Sticky Notes	Services	4	pack	5.48	Low	Pending	2024-03-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
672	Employee 40	Finance	Request for Desk	Furniture	7	pcs	468.13	Medium	Pending	2021-01-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
673	Employee 21	Finance	Request for Mouse	Electronics	4	pcs	43.54	Low	Pending	2021-12-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
674	Employee 60	Operations	Request for Pen Set	Office Supplies	1	set	16.58	Low	Pending	2020-06-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
675	Employee 96	Operations	Request for Pen Set	Software	1	set	16.39	Low	Pending	2023-10-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
676	Employee 8	Finance	Request for Printing Paper	Services	5	box	6.22	High	Pending	2024-01-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
677	Employee 63	Marketing	Request for Pen Set	Software	7	set	18.05	Medium	Pending	2024-04-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
678	Employee 32	Marketing	Request for Monitor	Electronics	10	pcs	239.11	Medium	Pending	2024-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
679	Employee 16	IT	Request for Printing Paper	Software	10	box	12.76	Low	Pending	2022-01-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
680	Employee 48	Marketing	Request for Printing Paper	Services	6	box	8.23	Medium	Pending	2021-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
681	Employee 39	Marketing	Request for Sticky Notes	Software	5	pack	6.35	High	Pending	2021-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
682	Employee 58	IT	Request for Desk	Furniture	4	pcs	246.52	Medium	Pending	2023-04-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
683	Employee 12	IT	Request for Filing Cabinet	Furniture	9	pcs	217.30	Low	Pending	2024-09-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
684	Employee 82	HR	Request for Notebook	Software	8	pcs	6.12	High	Pending	2020-11-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
685	Employee 4	Operations	Request for Desk	Furniture	10	pcs	478.74	Medium	Pending	2021-06-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
686	Employee 44	IT	Request for Printing Paper	Office Supplies	10	box	13.37	Medium	Pending	2023-12-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
687	Employee 32	Marketing	Request for Notebook	Software	3	pcs	5.90	High	Pending	2023-01-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
688	Employee 92	Marketing	Request for Sticky Notes	Office Supplies	10	pack	6.94	Low	Pending	2021-06-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
689	Employee 33	Finance	Request for Notebook	Software	7	pcs	5.95	Low	Pending	2024-08-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
690	Employee 44	Marketing	Request for Office Chair	Furniture	8	pcs	140.11	Medium	Pending	2024-05-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
691	Employee 83	HR	Request for Conference Table	Furniture	6	pcs	920.45	Low	Pending	2025-02-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
692	Employee 51	Finance	Request for Office Chair	Furniture	8	pcs	127.61	Low	Pending	2021-09-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
693	Employee 21	Finance	Request for Notebook	Services	9	pcs	7.15	Medium	Pending	2021-11-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
694	Employee 71	Marketing	Request for Bookshelf	Furniture	3	pcs	178.70	Low	Pending	2023-07-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
695	Employee 66	Marketing	Request for Stapler	Software	10	pcs	19.46	Low	Pending	2023-12-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
696	Employee 51	HR	Request for Sticky Notes	Services	4	pack	4.52	Medium	Pending	2023-08-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
697	Employee 93	Finance	Request for Conference Table	Furniture	5	pcs	849.13	High	Pending	2021-06-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
698	Employee 91	HR	Request for Pen Set	Services	6	set	8.32	Low	Pending	2021-02-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
699	Employee 40	Finance	Request for Filing Cabinet	Furniture	9	pcs	157.07	High	Pending	2020-08-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
700	Employee 1	HR	Request for Stapler	Services	7	pcs	14.69	Low	Pending	2022-11-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
701	Employee 63	Finance	Request for Keyboard	Electronics	10	pcs	74.07	High	Pending	2023-03-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
702	Employee 32	HR	Request for Stapler	Software	5	pcs	17.39	Medium	Pending	2023-07-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
703	Employee 18	Marketing	Request for Desk	Furniture	9	pcs	304.01	Low	Pending	2025-03-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
704	Employee 61	Marketing	Request for Printing Paper	Services	1	box	11.12	High	Pending	2021-12-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
705	Employee 53	Finance	Request for Pen Set	Office Supplies	5	set	10.65	Medium	Pending	2022-09-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
706	Employee 8	Marketing	Request for Sticky Notes	Software	10	pack	4.46	Medium	Pending	2021-05-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
707	Employee 79	Operations	Request for Filing Cabinet	Furniture	9	pcs	201.62	Medium	Pending	2020-11-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
708	Employee 51	Operations	Request for Printing Paper	Office Supplies	6	box	12.17	Medium	Pending	2023-04-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
709	Employee 23	Marketing	Request for Stapler	Services	10	pcs	15.32	Medium	Pending	2022-07-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
710	Employee 13	HR	Request for Office Chair	Furniture	3	pcs	141.69	Medium	Pending	2021-10-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
711	Employee 84	Operations	Request for Mouse	Electronics	9	pcs	34.50	High	Pending	2024-05-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
712	Employee 38	IT	Request for Printing Paper	Office Supplies	1	box	11.04	Low	Pending	2022-09-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
713	Employee 55	Operations	Request for Sticky Notes	Services	8	pack	7.39	Low	Pending	2025-04-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
714	Employee 17	Operations	Request for Keyboard	Electronics	10	pcs	92.93	Medium	Pending	2022-02-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
715	Employee 85	IT	Request for Notebook	Services	2	pcs	3.71	High	Pending	2021-06-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
716	Employee 91	IT	Request for Filing Cabinet	Furniture	9	pcs	221.83	Low	Pending	2021-01-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
717	Employee 51	Operations	Request for Keyboard	Electronics	4	pcs	59.15	Low	Pending	2021-12-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
718	Employee 65	Marketing	Request for Stapler	Software	6	pcs	13.62	Low	Pending	2024-02-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
719	Employee 37	Finance	Request for Keyboard	Electronics	5	pcs	95.25	Medium	Pending	2024-01-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
720	Employee 21	Operations	Request for Sticky Notes	Office Supplies	2	pack	6.41	High	Pending	2022-04-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
721	Employee 78	HR	Request for Notebook	Software	5	pcs	9.72	Low	Pending	2022-08-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
722	Employee 63	Finance	Request for Monitor	Electronics	6	pcs	254.96	Low	Pending	2020-10-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
723	Employee 42	Operations	Request for Notebook	Office Supplies	5	pcs	9.92	Medium	Pending	2023-07-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
724	Employee 15	Marketing	Request for Printing Paper	Office Supplies	7	box	8.54	Medium	Pending	2024-02-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
725	Employee 59	Operations	Request for Headset	Electronics	1	pcs	146.71	Low	Pending	2022-03-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
726	Employee 24	Operations	Request for Desk	Furniture	4	pcs	361.02	High	Pending	2022-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
727	Employee 7	IT	Request for Printing Paper	Software	5	box	10.53	Medium	Pending	2024-05-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
728	Employee 66	Operations	Request for Filing Cabinet	Furniture	1	pcs	269.26	Medium	Pending	2021-03-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
729	Employee 57	Marketing	Request for Desk	Furniture	10	pcs	316.91	High	Pending	2022-03-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
730	Employee 94	Finance	Request for Desk	Furniture	4	pcs	231.01	Medium	Pending	2024-02-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
731	Employee 63	HR	Request for Pen Set	Services	9	set	19.80	Low	Pending	2023-07-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
732	Employee 61	Finance	Request for Pen Set	Office Supplies	1	set	15.21	High	Pending	2020-11-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
733	Employee 3	Finance	Request for Printing Paper	Office Supplies	8	box	10.70	High	Pending	2021-02-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
734	Employee 84	Operations	Request for Mouse	Electronics	5	pcs	23.81	Low	Pending	2024-02-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
735	Employee 83	IT	Request for Conference Table	Furniture	4	pcs	1897.97	Medium	Pending	2022-01-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
736	Employee 11	Finance	Request for Mouse	Electronics	9	pcs	28.87	Medium	Pending	2020-08-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
737	Employee 61	Finance	Request for Sticky Notes	Services	6	pack	4.09	Medium	Pending	2021-04-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
738	Employee 80	Marketing	Request for Conference Table	Furniture	4	pcs	1026.43	High	Pending	2025-05-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
739	Employee 97	HR	Request for Notebook	Services	4	pcs	9.84	Medium	Pending	2024-02-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
740	Employee 30	Marketing	Request for Mouse	Electronics	5	pcs	43.63	Low	Pending	2022-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
741	Employee 18	Finance	Request for Pen Set	Software	6	set	14.04	High	Pending	2021-08-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
742	Employee 89	HR	Request for Stapler	Software	9	pcs	23.02	Low	Pending	2024-10-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
743	Employee 85	Marketing	Request for Bookshelf	Furniture	5	pcs	175.48	High	Pending	2021-03-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
744	Employee 64	Operations	Request for Stapler	Services	3	pcs	11.77	Medium	Pending	2024-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
745	Employee 76	Finance	Request for Notebook	Office Supplies	6	pcs	3.18	Low	Pending	2023-09-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
746	Employee 89	Operations	Request for Filing Cabinet	Furniture	3	pcs	353.43	Medium	Pending	2022-10-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
747	Employee 28	Operations	Request for Stapler	Services	8	pcs	18.14	Low	Pending	2024-09-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
748	Employee 38	Marketing	Request for Stapler	Software	5	pcs	13.25	High	Pending	2021-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
749	Employee 62	Finance	Request for Stapler	Software	7	pcs	13.67	Medium	Pending	2023-06-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
750	Employee 65	HR	Request for Pen Set	Office Supplies	3	set	12.57	Low	Pending	2024-07-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
751	Employee 21	Marketing	Request for Stapler	Office Supplies	10	pcs	14.11	Low	Pending	2023-07-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
752	Employee 35	Marketing	Request for Notebook	Services	7	pcs	4.32	Low	Pending	2021-01-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
753	Employee 14	Finance	Request for Sticky Notes	Services	3	pack	5.15	Medium	Pending	2025-03-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
754	Employee 20	Operations	Request for Notebook	Software	6	pcs	8.36	High	Pending	2020-12-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
755	Employee 8	Marketing	Request for Pen Set	Services	6	set	17.03	Medium	Pending	2024-04-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
756	Employee 43	Finance	Request for Desk	Furniture	6	pcs	228.71	High	Pending	2024-05-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
757	Employee 24	HR	Request for Mouse	Electronics	7	pcs	49.55	Medium	Pending	2024-04-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
758	Employee 37	Marketing	Request for Printing Paper	Services	9	box	9.24	Medium	Pending	2022-11-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
759	Employee 52	Finance	Request for Office Chair	Furniture	2	pcs	281.77	Medium	Pending	2021-12-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
760	Employee 73	Finance	Request for Keyboard	Electronics	8	pcs	59.22	High	Pending	2022-04-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
761	Employee 83	HR	Request for Sticky Notes	Office Supplies	8	pack	5.40	Medium	Pending	2023-09-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
762	Employee 86	HR	Request for Notebook	Office Supplies	2	pcs	4.48	High	Pending	2022-05-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
763	Employee 38	HR	Request for Keyboard	Electronics	4	pcs	51.16	Low	Pending	2021-06-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
764	Employee 56	IT	Request for Headset	Electronics	9	pcs	44.96	Low	Pending	2024-05-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
765	Employee 68	IT	Request for Conference Table	Furniture	2	pcs	1345.70	High	Pending	2021-12-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
766	Employee 67	IT	Request for Stapler	Services	3	pcs	17.50	Medium	Pending	2022-08-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
767	Employee 53	IT	Request for Sticky Notes	Software	3	pack	6.97	Medium	Pending	2025-02-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
768	Employee 91	HR	Request for Printing Paper	Services	1	box	5.89	Medium	Pending	2022-08-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
769	Employee 72	Finance	Request for Stapler	Office Supplies	4	pcs	10.78	Medium	Pending	2025-05-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
770	Employee 11	HR	Request for Sticky Notes	Software	3	pack	5.47	High	Pending	2022-03-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
771	Employee 29	Marketing	Request for Stapler	Office Supplies	9	pcs	21.70	High	Pending	2023-01-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
772	Employee 75	Finance	Request for Laptop	Electronics	5	pcs	460.83	High	Pending	2021-10-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
773	Employee 14	Marketing	Request for Pen Set	Office Supplies	5	set	12.31	Low	Pending	2023-06-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
774	Employee 28	Operations	Request for Notebook	Services	4	pcs	6.76	High	Pending	2024-10-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
775	Employee 3	Operations	Request for Laptop	Electronics	5	pcs	544.93	Medium	Pending	2023-05-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
776	Employee 58	Marketing	Request for Printing Paper	Office Supplies	10	box	14.56	High	Pending	2020-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
777	Employee 58	HR	Request for Desk	Furniture	4	pcs	296.42	Medium	Pending	2023-09-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
778	Employee 47	IT	Request for Office Chair	Furniture	6	pcs	107.71	Low	Pending	2025-03-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
779	Employee 88	Operations	Request for Monitor	Electronics	10	pcs	216.87	Low	Pending	2024-04-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
780	Employee 38	Operations	Request for Notebook	Office Supplies	8	pcs	9.97	Low	Pending	2021-08-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
781	Employee 26	HR	Request for Stapler	Office Supplies	4	pcs	17.21	High	Pending	2024-03-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
782	Employee 76	Marketing	Request for Stapler	Office Supplies	1	pcs	24.76	Low	Pending	2023-08-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
783	Employee 45	Finance	Request for Sticky Notes	Services	4	pack	2.22	High	Pending	2023-08-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
784	Employee 43	IT	Request for Notebook	Office Supplies	5	pcs	3.23	High	Pending	2021-02-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
785	Employee 71	HR	Request for Sticky Notes	Services	8	pack	5.86	High	Pending	2022-03-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
786	Employee 32	HR	Request for Pen Set	Services	8	set	19.68	Low	Pending	2022-08-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
787	Employee 50	Operations	Request for Stapler	Office Supplies	7	pcs	19.78	Medium	Pending	2022-04-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
788	Employee 97	IT	Request for Stapler	Office Supplies	1	pcs	16.00	Low	Pending	2025-05-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
789	Employee 70	Operations	Request for Mouse	Electronics	7	pcs	48.16	High	Pending	2024-03-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
790	Employee 49	HR	Request for Printing Paper	Office Supplies	4	box	14.72	Low	Pending	2023-10-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
791	Employee 53	HR	Request for Mouse	Electronics	10	pcs	21.32	Low	Pending	2024-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
792	Employee 73	Operations	Request for Sticky Notes	Services	9	pack	4.75	Medium	Pending	2023-11-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
793	Employee 36	Operations	Request for Sticky Notes	Office Supplies	6	pack	4.77	Low	Pending	2024-07-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
794	Employee 94	Finance	Request for Keyboard	Electronics	4	pcs	65.64	Low	Pending	2024-03-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
795	Employee 23	Marketing	Request for Stapler	Office Supplies	7	pcs	19.21	Low	Pending	2021-02-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
796	Employee 37	Operations	Request for Notebook	Office Supplies	6	pcs	7.65	Medium	Pending	2021-01-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
797	Employee 87	Finance	Request for Stapler	Office Supplies	4	pcs	17.64	High	Pending	2024-02-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
798	Employee 80	IT	Request for Printing Paper	Software	4	box	6.80	Medium	Pending	2020-08-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
799	Employee 16	HR	Request for Monitor	Electronics	5	pcs	195.30	High	Pending	2024-04-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
800	Employee 62	Finance	Request for Pen Set	Office Supplies	9	set	18.89	Low	Pending	2024-09-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
801	Employee 16	Finance	Request for Desk	Furniture	10	pcs	307.69	High	Pending	2021-07-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
802	Employee 55	Marketing	Request for Sticky Notes	Services	1	pack	2.18	High	Pending	2022-03-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
803	Employee 86	Marketing	Request for Monitor	Electronics	6	pcs	175.90	High	Pending	2022-02-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
804	Employee 83	HR	Request for Sticky Notes	Services	8	pack	3.85	Low	Pending	2020-08-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
805	Employee 29	Marketing	Request for Office Chair	Furniture	5	pcs	131.94	Low	Pending	2023-05-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
806	Employee 96	IT	Request for Notebook	Office Supplies	5	pcs	8.64	High	Pending	2022-11-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
807	Employee 74	Operations	Request for Stapler	Software	10	pcs	18.83	High	Pending	2022-04-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
808	Employee 74	IT	Request for Notebook	Office Supplies	7	pcs	3.74	High	Pending	2021-10-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
809	Employee 12	Finance	Request for Pen Set	Software	9	set	15.97	Low	Pending	2024-02-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
810	Employee 51	Marketing	Request for Headset	Electronics	2	pcs	106.88	High	Pending	2020-11-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
811	Employee 71	HR	Request for Office Chair	Furniture	2	pcs	110.80	Medium	Pending	2021-10-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
812	Employee 51	IT	Request for Stapler	Office Supplies	7	pcs	14.38	High	Pending	2021-02-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
813	Employee 12	Finance	Request for Printing Paper	Services	5	box	8.00	High	Pending	2022-08-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
814	Employee 99	IT	Request for Printing Paper	Services	7	box	9.04	High	Pending	2024-04-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
815	Employee 2	IT	Request for Conference Table	Furniture	4	pcs	562.71	High	Pending	2022-04-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
816	Employee 18	Operations	Request for Notebook	Services	3	pcs	6.23	Low	Pending	2022-09-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
817	Employee 33	Marketing	Request for Printing Paper	Office Supplies	1	box	9.99	Medium	Pending	2023-03-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
818	Employee 11	IT	Request for Pen Set	Office Supplies	9	set	18.00	High	Pending	2021-04-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
819	Employee 64	Operations	Request for Laptop	Electronics	4	pcs	447.16	High	Pending	2023-09-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
820	Employee 90	IT	Request for Keyboard	Electronics	1	pcs	94.91	High	Pending	2024-05-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
821	Employee 91	IT	Request for Headset	Electronics	6	pcs	55.24	Low	Pending	2023-12-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
822	Employee 23	Marketing	Request for Desk	Furniture	4	pcs	322.06	High	Pending	2024-08-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
823	Employee 59	IT	Request for Office Chair	Furniture	10	pcs	217.48	Low	Pending	2025-05-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
824	Employee 81	Marketing	Request for Bookshelf	Furniture	3	pcs	105.88	High	Pending	2021-12-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
825	Employee 55	Finance	Request for Sticky Notes	Software	7	pack	3.22	Medium	Pending	2021-11-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
826	Employee 26	Marketing	Request for Sticky Notes	Office Supplies	2	pack	4.24	Medium	Pending	2024-07-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
827	Employee 34	IT	Request for Printing Paper	Services	2	box	12.61	Low	Pending	2024-12-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
828	Employee 56	HR	Request for Keyboard	Electronics	6	pcs	74.00	Medium	Pending	2024-03-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
829	Employee 83	IT	Request for Conference Table	Furniture	1	pcs	1555.12	Medium	Pending	2020-09-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
830	Employee 74	IT	Request for Stapler	Office Supplies	5	pcs	18.03	High	Pending	2023-08-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
831	Employee 76	Finance	Request for Pen Set	Office Supplies	4	set	18.87	Medium	Pending	2021-03-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
832	Employee 89	Marketing	Request for Pen Set	Office Supplies	9	set	8.59	Low	Pending	2024-08-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
833	Employee 21	Marketing	Request for Pen Set	Software	10	set	13.30	Low	Pending	2024-10-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
834	Employee 59	Finance	Request for Pen Set	Software	10	set	12.12	High	Pending	2023-08-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
835	Employee 29	Finance	Request for Pen Set	Office Supplies	6	set	11.28	Medium	Pending	2024-08-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
836	Employee 77	HR	Request for Stapler	Software	2	pcs	24.64	Low	Pending	2025-02-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
837	Employee 96	IT	Request for Printing Paper	Software	3	box	8.31	Medium	Pending	2022-06-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
838	Employee 34	HR	Request for Notebook	Office Supplies	2	pcs	5.94	High	Pending	2024-05-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
839	Employee 79	Finance	Request for Keyboard	Electronics	9	pcs	65.65	Medium	Pending	2021-12-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
840	Employee 2	IT	Request for Notebook	Office Supplies	3	pcs	3.29	Medium	Pending	2024-12-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
841	Employee 10	Finance	Request for Bookshelf	Furniture	3	pcs	159.28	High	Pending	2021-08-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
842	Employee 8	Marketing	Request for Headset	Electronics	2	pcs	93.54	High	Pending	2021-11-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
843	Employee 8	IT	Request for Pen Set	Office Supplies	6	set	11.95	Medium	Pending	2024-10-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
844	Employee 100	IT	Request for Bookshelf	Furniture	1	pcs	130.21	Medium	Pending	2021-08-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
845	Employee 95	HR	Request for Filing Cabinet	Furniture	5	pcs	263.09	Medium	Pending	2021-10-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
846	Employee 14	Finance	Request for Printing Paper	Office Supplies	6	box	8.29	Low	Pending	2021-07-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
847	Employee 60	Finance	Request for Filing Cabinet	Furniture	5	pcs	179.36	High	Pending	2023-06-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
848	Employee 21	Finance	Request for Desk	Furniture	3	pcs	381.82	Low	Pending	2021-07-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
849	Employee 79	Operations	Request for Filing Cabinet	Furniture	10	pcs	356.87	Medium	Pending	2022-01-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
850	Employee 96	Operations	Request for Desk	Furniture	9	pcs	370.71	Medium	Pending	2021-10-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
851	Employee 76	Marketing	Request for Mouse	Electronics	10	pcs	47.93	Medium	Pending	2021-05-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
852	Employee 71	Finance	Request for Bookshelf	Furniture	8	pcs	232.90	High	Pending	2020-08-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
853	Employee 29	Operations	Request for Mouse	Electronics	3	pcs	37.55	High	Pending	2023-01-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
854	Employee 3	HR	Request for Conference Table	Furniture	3	pcs	1008.51	Low	Pending	2020-08-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
855	Employee 1	IT	Request for Pen Set	Office Supplies	4	set	16.85	Low	Pending	2020-09-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
856	Employee 47	Finance	Request for Bookshelf	Furniture	5	pcs	89.12	Medium	Pending	2024-01-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
857	Employee 75	Finance	Request for Headset	Electronics	10	pcs	66.76	Medium	Pending	2023-10-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
858	Employee 62	IT	Request for Stapler	Software	7	pcs	20.91	Medium	Pending	2023-05-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
859	Employee 47	Operations	Request for Pen Set	Services	7	set	15.49	Low	Pending	2022-10-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
860	Employee 68	Finance	Request for Pen Set	Services	3	set	9.86	Medium	Pending	2023-09-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
861	Employee 23	HR	Request for Stapler	Services	3	pcs	15.21	Low	Pending	2021-10-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
862	Employee 49	IT	Request for Bookshelf	Furniture	6	pcs	145.93	Low	Pending	2025-02-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
863	Employee 62	Marketing	Request for Bookshelf	Furniture	6	pcs	182.56	High	Pending	2020-11-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
864	Employee 41	Marketing	Request for Desk	Furniture	10	pcs	319.32	Medium	Pending	2023-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
865	Employee 45	Operations	Request for Pen Set	Services	10	set	18.33	High	Pending	2021-10-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
866	Employee 14	IT	Request for Sticky Notes	Office Supplies	6	pack	5.60	Low	Pending	2024-11-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
867	Employee 56	HR	Request for Notebook	Office Supplies	3	pcs	8.05	Low	Pending	2024-02-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
868	Employee 44	Marketing	Request for Pen Set	Office Supplies	9	set	18.82	Low	Pending	2024-09-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
869	Employee 14	IT	Request for Keyboard	Electronics	4	pcs	58.46	High	Pending	2021-12-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
870	Employee 58	HR	Request for Sticky Notes	Services	2	pack	7.36	Low	Pending	2021-05-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
871	Employee 41	IT	Request for Sticky Notes	Office Supplies	1	pack	5.75	Medium	Pending	2024-12-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
872	Employee 87	HR	Request for Filing Cabinet	Furniture	6	pcs	274.32	Low	Pending	2025-02-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
873	Employee 44	Marketing	Request for Bookshelf	Furniture	10	pcs	120.12	Low	Pending	2023-05-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
874	Employee 99	Operations	Request for Keyboard	Electronics	5	pcs	96.66	High	Pending	2023-04-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
875	Employee 35	IT	Request for Pen Set	Software	1	set	11.30	Medium	Pending	2022-08-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
876	Employee 64	Marketing	Request for Pen Set	Office Supplies	1	set	9.48	Medium	Pending	2021-09-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
877	Employee 86	HR	Request for Notebook	Software	10	pcs	9.53	Medium	Pending	2024-11-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
878	Employee 42	Finance	Request for Filing Cabinet	Furniture	7	pcs	347.91	Low	Pending	2020-12-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
879	Employee 63	HR	Request for Mouse	Electronics	9	pcs	35.29	High	Pending	2022-05-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
880	Employee 57	Operations	Request for Stapler	Software	10	pcs	18.86	High	Pending	2022-07-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
881	Employee 83	Operations	Request for Notebook	Office Supplies	8	pcs	3.89	High	Pending	2021-10-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
882	Employee 80	Marketing	Request for Printing Paper	Office Supplies	6	box	13.35	High	Pending	2020-06-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
883	Employee 12	Finance	Request for Sticky Notes	Services	10	pack	6.97	Medium	Pending	2022-01-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
884	Employee 48	IT	Request for Printing Paper	Software	6	box	9.17	Low	Pending	2024-08-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
885	Employee 54	Finance	Request for Office Chair	Furniture	9	pcs	270.58	Medium	Pending	2024-09-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
886	Employee 25	Operations	Request for Notebook	Office Supplies	8	pcs	7.86	Medium	Pending	2022-02-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
887	Employee 6	IT	Request for Notebook	Office Supplies	3	pcs	5.34	Medium	Pending	2022-03-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
888	Employee 14	IT	Request for Printing Paper	Software	3	box	7.05	High	Pending	2025-02-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
889	Employee 93	Finance	Request for Keyboard	Electronics	4	pcs	87.04	High	Pending	2021-05-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
890	Employee 86	Marketing	Request for Printing Paper	Services	7	box	7.97	Low	Pending	2020-08-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
891	Employee 4	IT	Request for Desk	Furniture	9	pcs	380.85	High	Pending	2024-07-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
892	Employee 23	Operations	Request for Pen Set	Software	4	set	9.08	High	Pending	2021-12-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
893	Employee 37	IT	Request for Filing Cabinet	Furniture	9	pcs	297.05	High	Pending	2020-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
894	Employee 86	Marketing	Request for Stapler	Services	10	pcs	23.71	Low	Pending	2020-11-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
895	Employee 93	IT	Request for Desk	Furniture	10	pcs	235.96	Low	Pending	2022-03-14 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
896	Employee 53	Finance	Request for Printing Paper	Office Supplies	7	box	7.15	High	Pending	2022-09-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
897	Employee 41	HR	Request for Notebook	Services	5	pcs	3.95	Low	Pending	2024-08-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
898	Employee 39	Finance	Request for Mouse	Electronics	1	pcs	21.29	Low	Pending	2025-03-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
899	Employee 47	Operations	Request for Stapler	Software	6	pcs	21.42	Low	Pending	2020-06-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
900	Employee 69	IT	Request for Notebook	Software	8	pcs	8.47	High	Pending	2023-07-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
901	Employee 12	Marketing	Request for Pen Set	Office Supplies	5	set	18.96	High	Pending	2022-05-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
902	Employee 38	Marketing	Request for Printing Paper	Software	3	box	7.69	High	Pending	2023-08-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
903	Employee 99	Marketing	Request for Notebook	Office Supplies	7	pcs	7.65	High	Pending	2024-07-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
904	Employee 61	HR	Request for Desk	Furniture	1	pcs	266.15	High	Pending	2022-10-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
905	Employee 52	Operations	Request for Pen Set	Software	8	set	15.76	Medium	Pending	2024-09-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
906	Employee 74	IT	Request for Laptop	Electronics	9	pcs	678.42	Medium	Pending	2023-07-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
907	Employee 55	Marketing	Request for Notebook	Services	2	pcs	4.03	High	Pending	2021-11-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
908	Employee 52	HR	Request for Filing Cabinet	Furniture	3	pcs	349.10	High	Pending	2022-04-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
909	Employee 84	Operations	Request for Pen Set	Office Supplies	1	set	8.19	High	Pending	2023-02-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
910	Employee 16	Operations	Request for Pen Set	Software	1	set	16.84	High	Pending	2025-02-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
911	Employee 36	Finance	Request for Pen Set	Services	5	set	18.46	High	Pending	2022-08-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
912	Employee 20	Finance	Request for Mouse	Electronics	10	pcs	26.26	Low	Pending	2025-01-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
913	Employee 42	IT	Request for Laptop	Electronics	5	pcs	475.96	Low	Pending	2022-10-04 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
914	Employee 86	Marketing	Request for Stapler	Office Supplies	2	pcs	12.84	Medium	Pending	2024-10-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
915	Employee 78	Operations	Request for Sticky Notes	Services	6	pack	6.59	High	Pending	2022-05-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
916	Employee 88	Marketing	Request for Bookshelf	Furniture	6	pcs	90.73	Medium	Pending	2021-07-21 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
917	Employee 55	Finance	Request for Notebook	Services	9	pcs	7.05	Medium	Pending	2020-08-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
918	Employee 96	Finance	Request for Sticky Notes	Software	5	pack	5.36	High	Pending	2021-07-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
919	Employee 6	IT	Request for Conference Table	Furniture	2	pcs	1356.30	Low	Pending	2021-02-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
920	Employee 17	Finance	Request for Conference Table	Furniture	1	pcs	767.82	Medium	Pending	2022-12-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
921	Employee 27	Operations	Request for Headset	Electronics	6	pcs	119.96	High	Pending	2024-04-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
922	Employee 14	Operations	Request for Printing Paper	Office Supplies	9	box	9.94	Low	Pending	2021-01-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
923	Employee 30	IT	Request for Monitor	Electronics	3	pcs	189.33	Medium	Pending	2023-04-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
924	Employee 20	IT	Request for Monitor	Electronics	5	pcs	296.81	Low	Pending	2021-05-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
925	Employee 100	Marketing	Request for Stapler	Office Supplies	5	pcs	13.82	Low	Pending	2022-04-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
926	Employee 100	HR	Request for Desk	Furniture	4	pcs	289.34	Medium	Pending	2022-01-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
927	Employee 84	Finance	Request for Printing Paper	Services	1	box	9.29	Low	Pending	2025-05-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
928	Employee 40	Marketing	Request for Conference Table	Furniture	7	pcs	1761.89	High	Pending	2023-09-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
929	Employee 91	Operations	Request for Notebook	Office Supplies	1	pcs	7.22	Low	Pending	2024-03-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
930	Employee 44	IT	Request for Pen Set	Services	10	set	12.68	High	Pending	2021-06-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
931	Employee 56	HR	Request for Sticky Notes	Software	4	pack	3.20	Medium	Pending	2021-02-02 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
932	Employee 84	Marketing	Request for Headset	Electronics	1	pcs	46.98	Medium	Pending	2021-08-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
933	Employee 4	HR	Request for Conference Table	Furniture	8	pcs	1914.09	High	Pending	2020-11-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
934	Employee 27	IT	Request for Notebook	Services	6	pcs	7.72	Low	Pending	2024-12-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
935	Employee 37	IT	Request for Pen Set	Services	4	set	16.40	Medium	Pending	2023-10-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
936	Employee 86	Operations	Request for Printing Paper	Services	5	box	7.62	High	Pending	2024-09-03 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
937	Employee 32	Finance	Request for Mouse	Electronics	3	pcs	44.48	High	Pending	2022-08-31 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
938	Employee 100	Marketing	Request for Keyboard	Electronics	4	pcs	73.06	Low	Pending	2023-03-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
939	Employee 83	HR	Request for Headset	Electronics	3	pcs	107.65	High	Pending	2023-01-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
940	Employee 31	HR	Request for Notebook	Services	4	pcs	4.19	Medium	Pending	2023-02-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
941	Employee 78	Finance	Request for Stapler	Office Supplies	5	pcs	20.05	Medium	Pending	2022-02-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
942	Employee 30	Marketing	Request for Laptop	Electronics	3	pcs	691.24	Medium	Pending	2021-09-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
943	Employee 37	Marketing	Request for Stapler	Software	9	pcs	12.04	Medium	Pending	2022-09-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
944	Employee 43	IT	Request for Desk	Furniture	9	pcs	307.54	Low	Pending	2025-01-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
945	Employee 6	HR	Request for Keyboard	Electronics	5	pcs	91.62	Low	Pending	2022-06-17 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
946	Employee 19	HR	Request for Keyboard	Electronics	6	pcs	93.35	Medium	Pending	2022-11-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
947	Employee 21	Finance	Request for Laptop	Electronics	4	pcs	611.90	High	Pending	2020-07-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
948	Employee 24	Finance	Request for Notebook	Software	7	pcs	4.78	Medium	Pending	2025-01-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
949	Employee 10	Operations	Request for Printing Paper	Services	8	box	12.04	High	Pending	2021-01-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
950	Employee 4	Finance	Request for Sticky Notes	Services	5	pack	2.06	Medium	Pending	2023-08-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
951	Employee 68	HR	Request for Bookshelf	Furniture	4	pcs	231.12	Low	Pending	2024-09-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
952	Employee 61	Operations	Request for Printing Paper	Services	7	box	5.83	Medium	Pending	2022-05-30 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
953	Employee 96	HR	Request for Sticky Notes	Software	2	pack	6.97	Low	Pending	2021-12-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
954	Employee 99	Marketing	Request for Stapler	Software	4	pcs	15.74	Medium	Pending	2025-01-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
955	Employee 14	Marketing	Request for Filing Cabinet	Furniture	2	pcs	257.14	Medium	Pending	2024-08-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
956	Employee 4	HR	Request for Keyboard	Electronics	5	pcs	55.87	High	Pending	2021-10-11 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
957	Employee 16	Operations	Request for Headset	Electronics	8	pcs	115.55	Low	Pending	2024-06-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
958	Employee 29	Operations	Request for Monitor	Electronics	2	pcs	209.53	Low	Pending	2023-08-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
959	Employee 37	Finance	Request for Printing Paper	Software	6	box	8.41	Medium	Pending	2025-02-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
960	Employee 4	HR	Request for Mouse	Electronics	3	pcs	46.49	Low	Pending	2025-03-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
961	Employee 3	IT	Request for Filing Cabinet	Furniture	5	pcs	308.66	Medium	Pending	2021-09-13 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
962	Employee 42	IT	Request for Printing Paper	Office Supplies	5	box	13.68	Medium	Pending	2023-09-12 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
963	Employee 27	Marketing	Request for Notebook	Office Supplies	8	pcs	8.74	High	Pending	2025-03-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
964	Employee 33	HR	Request for Printing Paper	Services	2	box	11.16	Medium	Pending	2024-12-01 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
965	Employee 28	IT	Request for Pen Set	Services	4	set	18.79	Medium	Pending	2021-12-16 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
966	Employee 85	Marketing	Request for Stapler	Services	8	pcs	10.41	High	Pending	2025-02-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
967	Employee 55	Finance	Request for Printing Paper	Services	1	box	10.94	Low	Pending	2023-04-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
968	Employee 12	HR	Request for Laptop	Electronics	1	pcs	738.82	High	Pending	2023-04-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
969	Employee 7	IT	Request for Printing Paper	Software	2	box	13.22	Low	Pending	2025-03-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
970	Employee 71	Marketing	Request for Office Chair	Furniture	8	pcs	244.02	Low	Pending	2022-01-10 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
971	Employee 48	Marketing	Request for Headset	Electronics	2	pcs	69.82	Low	Pending	2025-04-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
972	Employee 69	Operations	Request for Notebook	Software	4	pcs	6.11	Medium	Pending	2024-01-20 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
973	Employee 7	HR	Request for Sticky Notes	Services	6	pack	7.09	Low	Pending	2024-04-05 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
974	Employee 19	Finance	Request for Sticky Notes	Software	5	pack	3.04	Low	Pending	2023-06-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
975	Employee 66	HR	Request for Printing Paper	Office Supplies	1	box	7.77	Low	Pending	2022-11-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
976	Employee 59	Finance	Request for Keyboard	Electronics	7	pcs	61.79	High	Pending	2025-05-08 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
977	Employee 96	IT	Request for Printing Paper	Software	1	box	6.70	High	Pending	2023-04-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
978	Employee 44	IT	Request for Printing Paper	Services	2	box	14.47	Low	Pending	2023-12-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
979	Employee 56	Finance	Request for Desk	Furniture	4	pcs	230.19	Low	Pending	2022-04-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
980	Employee 90	IT	Request for Mouse	Electronics	4	pcs	46.88	Low	Pending	2024-04-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
981	Employee 41	IT	Request for Sticky Notes	Services	9	pack	7.31	High	Pending	2021-02-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
982	Employee 98	HR	Request for Stapler	Office Supplies	7	pcs	20.75	Low	Pending	2022-06-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
983	Employee 78	Operations	Request for Pen Set	Services	8	set	10.89	High	Pending	2021-11-06 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
984	Employee 92	Operations	Request for Stapler	Office Supplies	10	pcs	24.10	Medium	Pending	2022-08-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
985	Employee 96	HR	Request for Office Chair	Furniture	5	pcs	157.32	High	Pending	2024-11-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
986	Employee 15	Finance	Request for Sticky Notes	Software	9	pack	6.37	High	Pending	2020-07-22 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
987	Employee 24	IT	Request for Keyboard	Electronics	9	pcs	52.61	High	Pending	2020-09-25 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
988	Employee 21	Marketing	Request for Sticky Notes	Office Supplies	4	pack	5.49	Medium	Pending	2024-06-18 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
989	Employee 75	Operations	Request for Office Chair	Furniture	7	pcs	174.01	Low	Pending	2020-07-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
990	Employee 37	HR	Request for Stapler	Services	7	pcs	23.06	Low	Pending	2024-11-26 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
991	Employee 86	Marketing	Request for Keyboard	Electronics	6	pcs	52.37	Medium	Pending	2022-09-19 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
992	Employee 84	IT	Request for Notebook	Services	2	pcs	4.80	Low	Pending	2023-03-28 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
993	Employee 79	HR	Request for Stapler	Services	1	pcs	22.55	High	Pending	2021-12-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
994	Employee 55	IT	Request for Office Chair	Furniture	2	pcs	138.82	Low	Pending	2024-10-27 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
995	Employee 50	Marketing	Request for Sticky Notes	Office Supplies	3	pack	4.58	Low	Pending	2024-09-29 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
996	Employee 54	HR	Request for Office Chair	Furniture	2	pcs	114.67	High	Pending	2021-12-09 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
997	Employee 4	HR	Request for Stapler	Software	7	pcs	17.46	Medium	Pending	2020-11-15 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
998	Employee 80	Operations	Request for Mouse	Electronics	4	pcs	27.69	Low	Pending	2023-07-07 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
999	Employee 4	HR	Request for Bookshelf	Furniture	2	pcs	220.56	Medium	Pending	2024-03-23 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
1000	Employee 12	Operations	Request for Notebook	Services	8	pcs	5.64	Low	Pending	2022-06-24 19:17:04.535236+00	2025-05-31 19:17:04.707858+00
\.


--
-- Data for Name: supplier_performance; Type: TABLE DATA; Schema: public; Owner: company_user
--

COPY public.supplier_performance (id, supplier_id, purchase_order_id, delivery_rating, quality_rating, communication_rating, notes, created_at) FROM stdin;
1	3	1	5	5	5	Would order again	2023-04-23 19:17:04.535236+00
2	3	2	5	4	3	On-time delivery	2024-12-10 19:17:04.535236+00
3	1	3	4	5	3	Quality as expected	2025-04-25 19:17:04.535236+00
4	1	5	3	5	5	Excellent communication	2024-09-19 19:17:04.535236+00
5	4	6	3	4	5	Excellent communication	2024-08-04 19:17:04.535236+00
6	5	7	4	3	4	Good service	2023-03-05 19:17:04.535236+00
7	5	8	3	3	4	On-time delivery	2025-04-23 19:17:04.535236+00
8	1	9	3	3	5	On-time delivery	2023-06-27 19:17:04.535236+00
9	4	11	5	4	3	Would order again	2024-09-07 19:17:04.535236+00
10	3	12	5	3	4	On-time delivery	2023-11-29 19:17:04.535236+00
11	3	14	3	5	3	Excellent communication	2025-02-03 19:17:04.535236+00
12	5	15	4	3	4	On-time delivery	2024-06-01 19:17:04.535236+00
13	4	16	3	3	3	Quality as expected	2024-12-12 19:17:04.535236+00
14	3	17	3	3	3	On-time delivery	2025-04-13 19:17:04.535236+00
15	5	19	5	5	3	Good service	2023-06-04 19:17:04.535236+00
16	2	21	5	3	5	Excellent communication	2024-06-13 19:17:04.535236+00
17	5	22	5	3	5	On-time delivery	2020-09-04 19:17:04.535236+00
18	1	26	5	5	4	Good service	2023-09-14 19:17:04.535236+00
19	2	27	4	4	4	Quality as expected	2024-12-18 19:17:04.535236+00
20	4	28	4	4	5	Quality as expected	2023-08-02 19:17:04.535236+00
21	3	30	4	5	5	Quality as expected	2024-02-26 19:17:04.535236+00
22	3	32	4	3	3	Good service	2025-05-16 19:17:04.535236+00
23	1	33	3	4	5	Excellent communication	2025-05-06 19:17:04.535236+00
24	5	35	5	3	4	Excellent communication	2023-09-23 19:17:04.535236+00
25	5	37	5	5	3	Would order again	2024-11-05 19:17:04.535236+00
26	5	38	3	4	3	Quality as expected	2023-12-14 19:17:04.535236+00
27	4	39	3	3	4	Would order again	2023-11-20 19:17:04.535236+00
28	3	41	4	4	3	Good service	2023-08-07 19:17:04.535236+00
29	2	42	4	5	3	Would order again	2023-05-02 19:17:04.535236+00
30	5	43	5	3	3	Good service	2024-12-12 19:17:04.535236+00
31	3	47	4	5	4	On-time delivery	2024-01-24 19:17:04.535236+00
32	3	48	5	4	4	Quality as expected	2025-05-14 19:17:04.535236+00
33	2	50	5	5	5	Quality as expected	2023-10-30 19:17:04.535236+00
34	3	53	4	5	4	Good service	2023-02-07 19:17:04.535236+00
35	1	57	3	4	5	Excellent communication	2022-08-27 19:17:04.535236+00
36	5	58	5	5	4	Good service	2021-02-09 19:17:04.535236+00
37	2	59	4	4	3	Good service	2023-09-30 19:17:04.535236+00
38	3	60	5	4	4	Good service	2025-04-27 19:17:04.535236+00
39	2	61	4	3	3	Quality as expected	2023-10-18 19:17:04.535236+00
40	4	62	5	4	4	Good service	2025-05-31 19:17:04.535236+00
41	1	63	3	4	4	On-time delivery	2024-10-06 19:17:04.535236+00
42	1	65	3	4	4	Quality as expected	2023-07-15 19:17:04.535236+00
43	4	66	3	4	4	Good service	2024-12-02 19:17:04.535236+00
44	3	67	5	3	3	Quality as expected	2022-09-18 19:17:04.535236+00
45	5	68	3	5	4	Quality as expected	2022-03-23 19:17:04.535236+00
46	5	70	3	3	5	Good service	2025-02-26 19:17:04.535236+00
47	3	71	5	3	4	Would order again	2024-01-19 19:17:04.535236+00
48	3	72	5	3	4	On-time delivery	2024-07-11 19:17:04.535236+00
49	1	74	4	4	5	Quality as expected	2023-01-23 19:17:04.535236+00
50	5	75	4	3	4	Excellent communication	2025-05-12 19:17:04.535236+00
51	2	76	3	5	5	Good service	2025-02-15 19:17:04.535236+00
52	4	77	4	4	4	Quality as expected	2024-05-10 19:17:04.535236+00
53	4	79	3	4	5	Good service	2024-08-02 19:17:04.535236+00
54	5	80	5	3	5	Would order again	2023-12-28 19:17:04.535236+00
55	2	81	3	5	3	On-time delivery	2023-11-29 19:17:04.535236+00
56	1	82	4	5	3	Excellent communication	2024-06-08 19:17:04.535236+00
57	2	83	4	3	4	Would order again	2025-05-24 19:17:04.535236+00
58	2	84	4	3	5	On-time delivery	2024-12-14 19:17:04.535236+00
59	2	86	3	3	5	On-time delivery	2025-01-26 19:17:04.535236+00
60	3	87	5	4	5	Excellent communication	2024-11-20 19:17:04.535236+00
61	4	88	5	4	4	Quality as expected	2025-04-21 19:17:04.535236+00
62	2	90	5	3	4	On-time delivery	2024-04-19 19:17:04.535236+00
63	5	91	5	4	3	On-time delivery	2023-06-03 19:17:04.535236+00
64	1	93	3	4	4	Good service	2025-02-12 19:17:04.535236+00
65	3	95	4	4	4	Quality as expected	2024-02-11 19:17:04.535236+00
66	3	96	4	4	4	On-time delivery	2025-03-23 19:17:04.535236+00
67	5	99	4	5	3	Would order again	2025-03-18 19:17:04.535236+00
68	3	102	3	3	3	Good service	2023-06-13 19:17:04.535236+00
69	4	103	3	5	4	On-time delivery	2024-04-22 19:17:04.535236+00
70	4	104	5	4	3	On-time delivery	2023-07-18 19:17:04.535236+00
71	2	105	4	5	3	Quality as expected	2025-03-23 19:17:04.535236+00
72	4	107	5	3	5	Would order again	2020-12-17 19:17:04.535236+00
73	4	109	4	5	4	Good service	2024-05-11 19:17:04.535236+00
74	4	110	3	5	4	Would order again	2021-02-18 19:17:04.535236+00
75	4	111	5	4	5	Would order again	2024-09-17 19:17:04.535236+00
76	4	112	5	4	5	On-time delivery	2025-04-15 19:17:04.535236+00
77	1	114	4	3	5	On-time delivery	2024-03-17 19:17:04.535236+00
78	1	115	4	5	5	Quality as expected	2025-02-19 19:17:04.535236+00
79	2	116	4	4	4	On-time delivery	2023-07-05 19:17:04.535236+00
80	4	118	4	5	3	On-time delivery	2025-05-04 19:17:04.535236+00
81	1	120	3	4	4	On-time delivery	2025-05-04 19:17:04.535236+00
82	5	122	3	5	4	On-time delivery	2024-09-23 19:17:04.535236+00
83	4	123	4	4	5	Good service	2022-01-09 19:17:04.535236+00
84	2	125	5	5	3	Good service	2025-03-13 19:17:04.535236+00
85	2	126	3	3	3	Good service	2021-10-29 19:17:04.535236+00
86	2	127	5	5	3	Good service	2024-11-08 19:17:04.535236+00
87	3	132	4	5	3	On-time delivery	2024-12-20 19:17:04.535236+00
88	2	133	3	3	3	Good service	2023-10-20 19:17:04.535236+00
89	3	136	3	4	5	Good service	2024-12-07 19:17:04.535236+00
90	1	137	5	3	3	Excellent communication	2025-01-15 19:17:04.535236+00
91	2	139	5	4	3	Good service	2024-08-22 19:17:04.535236+00
92	1	141	4	5	4	Would order again	2023-10-03 19:17:04.535236+00
93	3	143	3	3	4	Quality as expected	2023-10-30 19:17:04.535236+00
94	4	144	3	5	4	On-time delivery	2023-09-08 19:17:04.535236+00
95	3	145	3	5	3	Quality as expected	2024-05-10 19:17:04.535236+00
96	3	147	3	5	4	Quality as expected	2024-12-12 19:17:04.535236+00
97	4	148	3	4	5	Quality as expected	2024-02-17 19:17:04.535236+00
98	3	149	4	4	5	Quality as expected	2024-03-17 19:17:04.535236+00
99	5	150	3	3	3	Good service	2024-01-17 19:17:04.535236+00
100	3	151	4	3	3	Would order again	2022-12-21 19:17:04.535236+00
101	5	153	4	5	4	Excellent communication	2024-01-28 19:17:04.535236+00
102	2	155	5	5	4	Good service	2024-05-06 19:17:04.535236+00
103	4	156	4	4	4	Would order again	2025-02-10 19:17:04.535236+00
104	1	157	5	4	3	Quality as expected	2024-01-05 19:17:04.535236+00
105	5	158	5	5	3	Quality as expected	2023-03-10 19:17:04.535236+00
106	2	159	5	4	3	Quality as expected	2025-03-31 19:17:04.535236+00
107	2	160	5	4	3	Quality as expected	2024-08-26 19:17:04.535236+00
108	2	162	5	4	3	Quality as expected	2022-07-21 19:17:04.535236+00
109	3	163	3	4	4	On-time delivery	2024-10-30 19:17:04.535236+00
110	1	164	5	5	4	Excellent communication	2025-05-03 19:17:04.535236+00
111	1	166	5	5	4	Quality as expected	2023-10-04 19:17:04.535236+00
112	5	168	4	4	3	Quality as expected	2025-03-21 19:17:04.535236+00
113	3	170	5	3	5	On-time delivery	2022-03-06 19:17:04.535236+00
114	1	171	5	3	3	Quality as expected	2021-10-01 19:17:04.535236+00
115	5	173	4	3	3	Would order again	2024-10-10 19:17:04.535236+00
116	3	174	5	4	5	Quality as expected	2025-03-12 19:17:04.535236+00
117	1	175	4	4	4	Quality as expected	2024-09-09 19:17:04.535236+00
118	5	176	5	4	4	Excellent communication	2024-04-23 19:17:04.535236+00
119	1	177	4	3	5	Good service	2023-01-28 19:17:04.535236+00
120	5	179	5	3	5	Would order again	2024-05-14 19:17:04.535236+00
121	4	180	5	3	5	Quality as expected	2023-07-08 19:17:04.535236+00
122	1	181	5	4	5	On-time delivery	2023-12-07 19:17:04.535236+00
123	3	182	5	3	4	Excellent communication	2024-06-04 19:17:04.535236+00
124	3	183	5	5	3	Excellent communication	2024-07-11 19:17:04.535236+00
125	3	185	5	5	3	Quality as expected	2025-05-30 19:17:04.535236+00
126	1	186	3	4	4	Would order again	2025-01-12 19:17:04.535236+00
127	1	188	5	3	3	Quality as expected	2024-04-03 19:17:04.535236+00
128	4	189	5	3	4	Good service	2021-06-03 19:17:04.535236+00
129	5	190	5	3	5	Quality as expected	2022-11-26 19:17:04.535236+00
130	1	192	5	4	5	Good service	2024-03-10 19:17:04.535236+00
131	5	193	5	3	4	On-time delivery	2024-09-27 19:17:04.535236+00
132	2	194	3	5	5	On-time delivery	2022-09-04 19:17:04.535236+00
133	3	196	4	4	5	Excellent communication	2024-12-19 19:17:04.535236+00
134	1	198	3	3	4	Would order again	2020-09-28 19:17:04.535236+00
135	4	199	5	3	4	On-time delivery	2022-06-14 19:17:04.535236+00
136	5	201	5	5	5	On-time delivery	2024-07-30 19:17:04.535236+00
137	5	202	3	5	5	On-time delivery	2024-09-19 19:17:04.535236+00
138	5	203	3	5	4	Excellent communication	2022-04-09 19:17:04.535236+00
139	5	204	5	3	5	On-time delivery	2025-03-26 19:17:04.535236+00
140	5	205	5	5	3	On-time delivery	2024-08-06 19:17:04.535236+00
141	3	206	4	4	4	On-time delivery	2025-01-01 19:17:04.535236+00
142	1	207	5	3	5	Would order again	2024-08-13 19:17:04.535236+00
143	4	208	3	5	4	Quality as expected	2023-11-23 19:17:04.535236+00
144	2	210	5	4	3	Would order again	2021-07-05 19:17:04.535236+00
145	5	211	3	4	4	Quality as expected	2024-01-19 19:17:04.535236+00
146	5	212	3	3	3	On-time delivery	2022-02-27 19:17:04.535236+00
147	1	213	5	5	3	Excellent communication	2025-04-23 19:17:04.535236+00
148	5	216	3	5	4	Good service	2024-10-09 19:17:04.535236+00
149	5	218	4	4	3	Excellent communication	2022-08-19 19:17:04.535236+00
150	3	219	3	4	4	On-time delivery	2025-02-23 19:17:04.535236+00
151	2	221	4	5	5	Would order again	2023-08-26 19:17:04.535236+00
152	1	222	3	5	3	Excellent communication	2023-09-30 19:17:04.535236+00
153	5	223	3	3	4	On-time delivery	2024-11-10 19:17:04.535236+00
154	4	224	4	3	5	Would order again	2024-08-22 19:17:04.535236+00
155	3	226	3	4	4	Good service	2022-12-22 19:17:04.535236+00
156	1	227	4	4	4	Good service	2022-02-12 19:17:04.535236+00
157	2	228	4	3	3	Would order again	2025-04-24 19:17:04.535236+00
158	4	229	5	4	3	Would order again	2023-12-09 19:17:04.535236+00
159	5	230	5	5	5	Good service	2025-02-18 19:17:04.535236+00
160	3	232	3	4	3	Would order again	2022-07-26 19:17:04.535236+00
161	4	233	4	5	4	Would order again	2021-02-22 19:17:04.535236+00
162	3	234	5	4	3	Would order again	2025-03-28 19:17:04.535236+00
163	2	236	3	4	3	Quality as expected	2022-11-21 19:17:04.535236+00
164	1	238	5	3	4	Quality as expected	2024-12-01 19:17:04.535236+00
165	3	239	5	5	4	Quality as expected	2022-04-28 19:17:04.535236+00
166	4	241	5	3	3	Quality as expected	2022-04-28 19:17:04.535236+00
167	3	242	5	4	3	Quality as expected	2025-03-31 19:17:04.535236+00
168	3	244	5	5	4	Quality as expected	2025-05-25 19:17:04.535236+00
169	3	245	4	4	4	Would order again	2024-09-06 19:17:04.535236+00
170	5	247	3	5	5	On-time delivery	2024-05-31 19:17:04.535236+00
171	3	249	3	5	5	Would order again	2025-05-18 19:17:04.535236+00
172	1	250	5	4	3	On-time delivery	2024-08-20 19:17:04.535236+00
173	3	251	5	4	3	Excellent communication	2025-02-18 19:17:04.535236+00
174	2	253	4	5	5	Good service	2024-07-14 19:17:04.535236+00
175	5	255	4	4	3	On-time delivery	2024-02-24 19:17:04.535236+00
176	1	256	4	5	5	On-time delivery	2023-05-12 19:17:04.535236+00
177	4	257	3	5	3	On-time delivery	2025-03-25 19:17:04.535236+00
178	1	258	3	4	4	Quality as expected	2023-04-22 19:17:04.535236+00
179	2	260	5	4	5	Excellent communication	2023-06-26 19:17:04.535236+00
180	2	261	3	4	4	Good service	2023-09-05 19:17:04.535236+00
181	4	262	3	5	5	Quality as expected	2025-01-30 19:17:04.535236+00
182	3	263	3	4	5	Good service	2024-09-03 19:17:04.535236+00
183	2	264	3	4	3	On-time delivery	2023-06-07 19:17:04.535236+00
184	3	266	4	5	3	Good service	2025-01-29 19:17:04.535236+00
185	1	267	4	5	3	On-time delivery	2025-01-27 19:17:04.535236+00
186	2	269	3	4	4	Excellent communication	2024-07-31 19:17:04.535236+00
187	3	271	5	5	5	Good service	2024-04-15 19:17:04.535236+00
188	1	272	3	4	5	Excellent communication	2024-03-11 19:17:04.535236+00
189	4	273	5	3	4	Excellent communication	2025-05-09 19:17:04.535236+00
190	2	274	4	4	5	Excellent communication	2023-11-18 19:17:04.535236+00
191	1	276	3	4	4	On-time delivery	2024-02-07 19:17:04.535236+00
192	5	277	4	3	4	On-time delivery	2025-05-28 19:17:04.535236+00
193	2	278	4	3	4	On-time delivery	2025-04-16 19:17:04.535236+00
194	4	279	4	3	5	Would order again	2025-03-17 19:17:04.535236+00
195	5	280	3	4	5	Good service	2021-09-01 19:17:04.535236+00
196	2	283	4	4	3	Good service	2025-04-23 19:17:04.535236+00
197	1	284	5	5	5	On-time delivery	2024-08-05 19:17:04.535236+00
198	3	286	3	5	5	Quality as expected	2023-11-23 19:17:04.535236+00
199	3	287	4	4	5	On-time delivery	2024-10-13 19:17:04.535236+00
200	1	288	3	3	3	Excellent communication	2023-08-28 19:17:04.535236+00
201	1	289	3	5	5	Quality as expected	2022-10-31 19:17:04.535236+00
202	3	290	5	5	3	Quality as expected	2024-11-02 19:17:04.535236+00
203	2	291	3	4	4	Would order again	2025-05-05 19:17:04.535236+00
204	4	292	4	5	3	Quality as expected	2025-04-19 19:17:04.535236+00
205	1	294	5	3	5	Good service	2024-07-20 19:17:04.535236+00
206	1	295	5	4	3	Excellent communication	2025-01-31 19:17:04.535236+00
207	3	296	5	3	3	Would order again	2022-09-13 19:17:04.535236+00
208	5	298	5	3	3	Good service	2024-01-10 19:17:04.535236+00
209	2	299	5	5	3	Would order again	2021-10-10 19:17:04.535236+00
210	4	300	5	3	3	Would order again	2023-05-07 19:17:04.535236+00
211	1	301	5	3	4	Good service	2024-11-30 19:17:04.535236+00
212	1	302	5	4	4	Quality as expected	2022-06-25 19:17:04.535236+00
213	3	304	3	4	5	Good service	2021-10-01 19:17:04.535236+00
214	2	305	4	3	4	Excellent communication	2024-12-11 19:17:04.535236+00
215	3	306	4	4	5	Excellent communication	2022-04-05 19:17:04.535236+00
216	4	307	4	5	5	Excellent communication	2025-03-02 19:17:04.535236+00
217	2	308	5	4	5	Excellent communication	2024-11-09 19:17:04.535236+00
218	1	309	3	4	5	Good service	2024-10-03 19:17:04.535236+00
219	5	310	4	5	4	Good service	2023-04-09 19:17:04.535236+00
220	5	311	5	4	5	Excellent communication	2025-05-03 19:17:04.535236+00
221	5	312	3	3	5	On-time delivery	2021-08-27 19:17:04.535236+00
222	5	313	3	3	4	On-time delivery	2023-09-26 19:17:04.535236+00
223	5	314	4	4	3	On-time delivery	2023-04-05 19:17:04.535236+00
224	3	315	4	5	4	Good service	2025-02-19 19:17:04.535236+00
225	5	316	4	4	5	Excellent communication	2025-05-26 19:17:04.535236+00
226	4	317	5	5	4	Quality as expected	2021-03-03 19:17:04.535236+00
227	3	318	5	4	3	On-time delivery	2025-01-08 19:17:04.535236+00
228	1	319	4	3	3	Excellent communication	2023-01-17 19:17:04.535236+00
229	3	320	5	4	3	Would order again	2024-11-16 19:17:04.535236+00
230	2	322	4	5	5	On-time delivery	2024-09-25 19:17:04.535236+00
231	5	325	5	3	5	Quality as expected	2025-04-25 19:17:04.535236+00
232	2	326	3	4	3	Quality as expected	2025-03-08 19:17:04.535236+00
233	2	328	3	4	3	On-time delivery	2025-01-25 19:17:04.535236+00
234	2	329	3	4	3	Would order again	2024-12-09 19:17:04.535236+00
235	4	330	5	5	3	On-time delivery	2024-03-12 19:17:04.535236+00
236	2	332	3	3	5	On-time delivery	2025-03-24 19:17:04.535236+00
237	2	334	5	4	4	Would order again	2022-02-01 19:17:04.535236+00
238	1	335	3	4	5	Quality as expected	2024-10-18 19:17:04.535236+00
239	1	336	3	5	4	Excellent communication	2024-05-02 19:17:04.535236+00
240	2	338	4	5	3	On-time delivery	2024-02-25 19:17:04.535236+00
241	1	339	5	5	4	Good service	2024-05-27 19:17:04.535236+00
242	3	340	4	5	3	On-time delivery	2023-12-12 19:17:04.535236+00
243	2	343	4	5	4	Good service	2025-05-27 19:17:04.535236+00
244	2	346	5	4	3	Good service	2024-09-23 19:17:04.535236+00
245	2	349	4	5	5	Quality as expected	2024-12-27 19:17:04.535236+00
246	3	350	4	3	3	Excellent communication	2024-06-08 19:17:04.535236+00
247	4	351	3	3	5	Excellent communication	2025-04-26 19:17:04.535236+00
248	3	352	3	4	3	Good service	2025-02-13 19:17:04.535236+00
249	1	353	5	3	3	Would order again	2022-06-13 19:17:04.535236+00
250	4	354	4	5	4	On-time delivery	2025-05-06 19:17:04.535236+00
251	5	356	4	3	5	Would order again	2024-05-04 19:17:04.535236+00
252	2	357	4	4	5	Would order again	2023-11-27 19:17:04.535236+00
253	4	358	5	5	3	Excellent communication	2024-05-15 19:17:04.535236+00
254	3	359	3	5	5	Good service	2025-05-13 19:17:04.535236+00
255	3	360	3	5	3	Quality as expected	2023-03-12 19:17:04.535236+00
256	2	361	5	5	5	Excellent communication	2023-08-28 19:17:04.535236+00
257	3	362	5	4	4	On-time delivery	2024-09-16 19:17:04.535236+00
258	2	363	5	5	3	Good service	2025-05-07 19:17:04.535236+00
259	4	365	3	5	5	Good service	2025-04-20 19:17:04.535236+00
260	4	366	4	4	5	Excellent communication	2022-06-15 19:17:04.535236+00
261	3	370	3	5	3	Excellent communication	2025-01-07 19:17:04.535236+00
262	4	371	5	3	3	Would order again	2025-02-21 19:17:04.535236+00
263	5	372	5	5	3	Excellent communication	2021-04-17 19:17:04.535236+00
264	3	373	5	4	3	Excellent communication	2025-06-06 19:17:04.535236+00
265	1	374	4	4	5	Good service	2025-02-02 19:17:04.535236+00
266	1	376	3	5	4	Quality as expected	2024-10-21 19:17:04.535236+00
267	4	378	4	4	3	On-time delivery	2025-04-02 19:17:04.535236+00
268	2	379	4	5	5	Excellent communication	2025-05-18 19:17:04.535236+00
269	4	380	3	3	3	Good service	2023-09-08 19:17:04.535236+00
270	1	382	5	3	3	Quality as expected	2023-08-08 19:17:04.535236+00
271	4	384	5	4	5	On-time delivery	2024-07-17 19:17:04.535236+00
272	5	385	4	5	3	Good service	2024-06-28 19:17:04.535236+00
273	1	386	4	5	3	Good service	2022-08-29 19:17:04.535236+00
274	2	387	5	5	5	Excellent communication	2022-10-03 19:17:04.535236+00
275	3	388	4	4	3	On-time delivery	2022-07-14 19:17:04.535236+00
276	5	389	3	3	4	Quality as expected	2023-06-04 19:17:04.535236+00
277	1	391	5	4	3	Quality as expected	2025-05-22 19:17:04.535236+00
278	1	392	3	4	3	Good service	2021-05-24 19:17:04.535236+00
279	2	393	3	4	4	Would order again	2024-12-17 19:17:04.535236+00
280	4	396	3	5	5	On-time delivery	2023-09-06 19:17:04.535236+00
281	3	397	4	3	3	Good service	2022-10-08 19:17:04.535236+00
282	1	398	4	4	3	Quality as expected	2021-01-02 19:17:04.535236+00
283	5	399	4	3	4	Would order again	2025-05-12 19:17:04.535236+00
284	3	400	4	4	5	Excellent communication	2023-02-07 19:17:04.535236+00
285	5	401	4	3	3	Would order again	2023-09-29 19:17:04.535236+00
286	3	402	3	5	5	Quality as expected	2024-06-09 19:17:04.535236+00
287	3	403	3	4	3	Quality as expected	2023-11-03 19:17:04.535236+00
288	4	405	5	5	3	Excellent communication	2024-09-13 19:17:04.535236+00
289	3	407	4	4	4	Would order again	2023-01-26 19:17:04.535236+00
290	2	409	4	5	5	On-time delivery	2024-06-15 19:17:04.535236+00
291	4	410	4	5	3	Quality as expected	2025-04-28 19:17:04.535236+00
292	4	412	3	5	5	Quality as expected	2024-02-12 19:17:04.535236+00
293	5	413	3	4	5	Would order again	2024-09-10 19:17:04.535236+00
294	2	414	5	3	3	Excellent communication	2024-12-18 19:17:04.535236+00
295	3	415	5	5	3	On-time delivery	2024-06-25 19:17:04.535236+00
296	2	416	5	4	3	On-time delivery	2024-12-11 19:17:04.535236+00
297	2	418	5	3	5	On-time delivery	2025-02-04 19:17:04.535236+00
298	2	419	3	3	5	Quality as expected	2024-06-17 19:17:04.535236+00
299	5	420	4	3	5	Excellent communication	2024-08-27 19:17:04.535236+00
300	2	421	4	3	3	Quality as expected	2023-04-20 19:17:04.535236+00
301	4	422	5	4	4	Quality as expected	2023-08-27 19:17:04.535236+00
302	3	424	4	5	3	On-time delivery	2025-01-16 19:17:04.535236+00
303	3	425	3	4	3	Would order again	2025-01-13 19:17:04.535236+00
304	5	427	5	4	5	Would order again	2024-06-03 19:17:04.535236+00
305	5	428	5	4	5	Good service	2025-01-31 19:17:04.535236+00
306	3	429	4	3	5	Good service	2025-04-19 19:17:04.535236+00
307	4	432	4	3	4	On-time delivery	2025-04-14 19:17:04.535236+00
308	1	433	3	4	3	On-time delivery	2024-07-11 19:17:04.535236+00
309	2	434	3	5	4	Excellent communication	2025-04-13 19:17:04.535236+00
310	4	435	5	4	5	Quality as expected	2023-05-05 19:17:04.535236+00
311	4	436	3	4	3	Excellent communication	2024-10-16 19:17:04.535236+00
312	3	439	4	4	3	Good service	2023-02-15 19:17:04.535236+00
313	2	441	5	5	5	Excellent communication	2025-06-02 19:17:04.535236+00
314	3	442	3	4	5	Would order again	2024-07-31 19:17:04.535236+00
315	4	445	5	4	5	On-time delivery	2023-05-13 19:17:04.535236+00
316	4	446	5	3	5	On-time delivery	2024-11-19 19:17:04.535236+00
317	1	447	3	4	5	Quality as expected	2025-01-05 19:17:04.535236+00
318	4	448	5	4	5	Would order again	2023-12-31 19:17:04.535236+00
319	5	449	4	4	3	Would order again	2025-05-04 19:17:04.535236+00
320	2	450	5	4	5	On-time delivery	2022-04-20 19:17:04.535236+00
321	4	451	5	3	4	On-time delivery	2025-04-24 19:17:04.535236+00
322	5	452	5	5	4	Would order again	2024-03-15 19:17:04.535236+00
323	3	454	3	5	3	On-time delivery	2025-02-02 19:17:04.535236+00
324	2	456	3	4	4	Good service	2022-12-20 19:17:04.535236+00
325	1	457	3	3	4	Quality as expected	2024-02-19 19:17:04.535236+00
326	5	458	4	4	5	Would order again	2024-07-26 19:17:04.535236+00
327	1	460	4	5	3	Quality as expected	2023-08-06 19:17:04.535236+00
328	1	462	4	4	4	Would order again	2025-01-13 19:17:04.535236+00
329	5	463	5	4	5	On-time delivery	2020-12-27 19:17:04.535236+00
330	2	464	3	4	5	Excellent communication	2023-02-23 19:17:04.535236+00
331	2	465	3	5	3	Quality as expected	2024-03-11 19:17:04.535236+00
332	5	466	3	3	4	Excellent communication	2020-11-27 19:17:04.535236+00
333	3	467	5	3	5	Good service	2021-01-29 19:17:04.535236+00
334	1	468	5	4	3	On-time delivery	2023-03-07 19:17:04.535236+00
335	2	469	4	4	4	Excellent communication	2023-08-05 19:17:04.535236+00
336	2	470	3	5	4	Good service	2025-04-25 19:17:04.535236+00
337	5	471	3	4	4	Good service	2022-07-05 19:17:04.535236+00
338	4	472	5	5	3	Good service	2024-10-20 19:17:04.535236+00
339	1	473	3	3	3	On-time delivery	2025-05-28 19:17:04.535236+00
340	5	480	3	3	4	Excellent communication	2025-04-20 19:17:04.535236+00
341	5	481	4	4	3	Excellent communication	2024-11-15 19:17:04.535236+00
342	3	482	3	3	4	Good service	2023-12-30 19:17:04.535236+00
343	3	483	4	4	3	Quality as expected	2024-11-04 19:17:04.535236+00
344	5	484	5	5	5	Would order again	2024-06-25 19:17:04.535236+00
345	4	485	5	5	4	Excellent communication	2023-10-23 19:17:04.535236+00
346	3	486	5	5	3	Excellent communication	2023-08-15 19:17:04.535236+00
347	3	487	5	3	3	Quality as expected	2024-09-24 19:17:04.535236+00
348	2	488	4	4	3	On-time delivery	2021-12-11 19:17:04.535236+00
349	1	491	3	5	4	On-time delivery	2025-01-27 19:17:04.535236+00
350	4	493	5	4	4	On-time delivery	2023-12-17 19:17:04.535236+00
351	3	495	4	5	5	On-time delivery	2025-04-21 19:17:04.535236+00
352	2	496	4	5	3	On-time delivery	2021-04-25 19:17:04.535236+00
353	5	497	4	4	5	Quality as expected	2023-10-25 19:17:04.535236+00
354	5	498	3	4	3	Excellent communication	2023-03-03 19:17:04.535236+00
355	4	499	3	4	4	Would order again	2025-02-18 19:17:04.535236+00
356	1	500	3	5	3	Excellent communication	2025-04-04 19:17:04.535236+00
357	2	501	4	3	5	Quality as expected	2023-04-28 19:17:04.535236+00
358	5	502	4	4	3	Quality as expected	2024-07-22 19:17:04.535236+00
359	5	503	5	4	3	Good service	2023-07-19 19:17:04.535236+00
360	2	505	4	4	3	On-time delivery	2022-10-13 19:17:04.535236+00
361	1	506	5	3	3	Excellent communication	2024-07-08 19:17:04.535236+00
362	4	508	4	4	3	On-time delivery	2024-04-28 19:17:04.535236+00
363	2	509	5	5	3	Excellent communication	2024-11-10 19:17:04.535236+00
364	1	510	5	3	3	Good service	2024-02-13 19:17:04.535236+00
365	2	512	3	4	4	Good service	2025-02-12 19:17:04.535236+00
366	5	513	4	3	4	Excellent communication	2024-05-27 19:17:04.535236+00
367	3	514	4	3	4	Quality as expected	2024-05-09 19:17:04.535236+00
368	3	515	5	3	5	Quality as expected	2024-05-13 19:17:04.535236+00
369	2	517	5	3	5	Excellent communication	2022-03-24 19:17:04.535236+00
370	3	518	3	3	4	Quality as expected	2023-10-01 19:17:04.535236+00
371	5	519	3	3	4	On-time delivery	2023-01-09 19:17:04.535236+00
372	1	523	5	4	5	Quality as expected	2022-08-14 19:17:04.535236+00
373	5	526	5	5	3	Quality as expected	2022-10-11 19:17:04.535236+00
374	3	527	3	4	5	On-time delivery	2024-06-30 19:17:04.535236+00
375	3	530	4	5	4	Excellent communication	2022-10-22 19:17:04.535236+00
376	1	531	3	3	5	On-time delivery	2023-01-28 19:17:04.535236+00
377	4	532	4	5	3	Good service	2023-01-03 19:17:04.535236+00
378	3	535	3	5	3	On-time delivery	2023-10-06 19:17:04.535236+00
379	1	536	4	5	4	Excellent communication	2021-11-02 19:17:04.535236+00
380	1	539	4	3	5	Quality as expected	2020-12-30 19:17:04.535236+00
381	2	540	5	3	3	On-time delivery	2025-04-25 19:17:04.535236+00
382	2	541	5	4	3	Would order again	2024-11-20 19:17:04.535236+00
383	4	543	3	5	4	Would order again	2022-06-12 19:17:04.535236+00
384	1	544	5	5	5	Good service	2024-02-02 19:17:04.535236+00
385	1	545	5	4	4	Would order again	2024-09-22 19:17:04.535236+00
386	4	546	3	4	5	Good service	2025-01-28 19:17:04.535236+00
387	1	547	3	4	4	Excellent communication	2021-04-22 19:17:04.535236+00
388	2	549	3	3	4	Would order again	2024-06-27 19:17:04.535236+00
389	1	550	3	3	3	Good service	2025-05-31 19:17:04.535236+00
390	1	551	3	3	4	Quality as expected	2024-02-09 19:17:04.535236+00
391	4	552	4	5	5	Quality as expected	2024-12-29 19:17:04.535236+00
392	3	553	4	3	5	Quality as expected	2024-07-15 19:17:04.535236+00
393	4	554	5	4	5	Good service	2025-02-19 19:17:04.535236+00
394	3	557	4	3	4	Would order again	2024-11-10 19:17:04.535236+00
395	1	558	5	3	5	Good service	2025-01-20 19:17:04.535236+00
396	3	560	4	3	3	Quality as expected	2024-02-01 19:17:04.535236+00
397	5	561	4	4	5	Good service	2024-12-23 19:17:04.535236+00
398	2	566	3	4	3	On-time delivery	2025-04-11 19:17:04.535236+00
399	4	567	3	4	3	Excellent communication	2023-05-28 19:17:04.535236+00
400	4	568	3	4	4	Excellent communication	2023-08-05 19:17:04.535236+00
401	1	569	5	4	3	Excellent communication	2023-08-17 19:17:04.535236+00
402	4	571	3	5	5	On-time delivery	2024-06-01 19:17:04.535236+00
403	5	574	4	3	3	On-time delivery	2024-05-18 19:17:04.535236+00
404	4	575	4	3	5	Quality as expected	2025-04-21 19:17:04.535236+00
405	1	576	4	3	5	On-time delivery	2022-08-07 19:17:04.535236+00
406	3	578	4	4	5	Would order again	2023-06-20 19:17:04.535236+00
407	2	579	5	4	4	Excellent communication	2025-04-14 19:17:04.535236+00
408	5	580	5	4	4	Would order again	2023-05-08 19:17:04.535236+00
409	1	582	4	5	3	Excellent communication	2025-05-20 19:17:04.535236+00
410	3	583	5	4	3	Quality as expected	2022-12-24 19:17:04.535236+00
411	4	584	5	5	5	Quality as expected	2025-05-19 19:17:04.535236+00
412	5	587	5	3	3	Excellent communication	2023-07-02 19:17:04.535236+00
413	2	589	4	3	4	Would order again	2024-04-07 19:17:04.535236+00
414	5	591	3	3	3	Would order again	2025-04-23 19:17:04.535236+00
415	4	592	3	5	5	Excellent communication	2024-11-05 19:17:04.535236+00
416	5	593	4	4	5	Quality as expected	2022-01-31 19:17:04.535236+00
417	3	594	3	3	3	Quality as expected	2023-12-07 19:17:04.535236+00
418	3	595	5	5	5	Quality as expected	2025-03-01 19:17:04.535236+00
419	1	596	3	4	3	Good service	2024-06-12 19:17:04.535236+00
420	3	597	4	5	4	On-time delivery	2023-03-11 19:17:04.535236+00
421	3	599	3	3	4	Good service	2024-12-24 19:17:04.535236+00
422	1	600	5	3	3	Would order again	2023-07-25 19:17:04.535236+00
423	5	602	3	5	4	Would order again	2024-04-08 19:17:04.535236+00
424	2	603	4	5	3	Good service	2025-01-08 19:17:04.535236+00
425	3	604	4	4	4	Good service	2021-06-03 19:17:04.535236+00
426	4	605	3	5	4	Good service	2024-06-18 19:17:04.535236+00
427	3	606	5	4	5	Good service	2025-06-07 19:17:04.535236+00
428	5	607	3	4	4	Quality as expected	2024-08-05 19:17:04.535236+00
429	3	608	5	3	4	Would order again	2021-12-18 19:17:04.535236+00
430	2	609	5	3	5	Good service	2024-10-23 19:17:04.535236+00
431	1	610	3	5	5	Excellent communication	2024-06-09 19:17:04.535236+00
432	5	611	5	5	3	On-time delivery	2024-08-01 19:17:04.535236+00
433	3	612	4	3	4	Would order again	2024-03-31 19:17:04.535236+00
434	4	613	4	5	5	On-time delivery	2024-10-27 19:17:04.535236+00
435	2	616	3	5	5	Good service	2024-08-17 19:17:04.535236+00
436	1	618	3	5	5	On-time delivery	2022-02-08 19:17:04.535236+00
437	1	619	5	3	4	Quality as expected	2025-04-11 19:17:04.535236+00
438	2	620	4	5	5	On-time delivery	2024-04-15 19:17:04.535236+00
439	2	622	5	3	4	Good service	2024-04-16 19:17:04.535236+00
440	5	628	3	4	3	Quality as expected	2024-08-17 19:17:04.535236+00
441	4	629	5	3	4	On-time delivery	2024-11-04 19:17:04.535236+00
442	4	630	3	5	4	Excellent communication	2022-05-07 19:17:04.535236+00
443	4	631	5	4	3	On-time delivery	2025-03-12 19:17:04.535236+00
444	2	632	4	5	4	On-time delivery	2025-03-07 19:17:04.535236+00
445	4	633	4	3	4	On-time delivery	2023-03-25 19:17:04.535236+00
446	1	635	4	3	5	Would order again	2025-05-08 19:17:04.535236+00
447	4	636	4	5	5	Would order again	2022-04-17 19:17:04.535236+00
448	5	637	4	3	5	Good service	2024-12-09 19:17:04.535236+00
449	3	639	4	4	4	Quality as expected	2024-02-14 19:17:04.535236+00
450	2	640	4	3	4	Good service	2025-04-14 19:17:04.535236+00
451	3	642	4	5	4	Excellent communication	2025-04-05 19:17:04.535236+00
452	1	643	4	3	3	Quality as expected	2022-11-20 19:17:04.535236+00
453	4	645	3	3	3	Quality as expected	2024-04-05 19:17:04.535236+00
454	4	646	5	3	3	Excellent communication	2024-04-04 19:17:04.535236+00
455	3	647	5	4	3	On-time delivery	2025-05-28 19:17:04.535236+00
456	5	648	5	3	3	Quality as expected	2025-02-06 19:17:04.535236+00
457	1	649	3	3	3	Quality as expected	2024-03-29 19:17:04.535236+00
458	1	650	4	3	3	Would order again	2025-03-08 19:17:04.535236+00
459	2	651	4	3	3	Good service	2024-09-12 19:17:04.535236+00
460	4	653	3	5	3	Quality as expected	2024-06-10 19:17:04.535236+00
461	4	654	3	4	5	On-time delivery	2023-10-23 19:17:04.535236+00
462	3	655	3	5	3	Good service	2023-08-25 19:17:04.535236+00
463	4	656	4	4	5	Excellent communication	2025-05-21 19:17:04.535236+00
464	2	659	4	3	4	Excellent communication	2025-05-07 19:17:04.535236+00
465	4	661	3	4	5	Excellent communication	2023-02-28 19:17:04.535236+00
466	3	662	3	4	5	Good service	2024-05-15 19:17:04.535236+00
467	2	663	3	4	3	Good service	2022-10-14 19:17:04.535236+00
468	2	664	3	3	5	On-time delivery	2024-09-16 19:17:04.535236+00
469	4	665	5	3	3	Excellent communication	2024-06-25 19:17:04.535236+00
470	5	666	4	3	3	Quality as expected	2023-02-21 19:17:04.535236+00
471	2	668	4	3	5	Good service	2023-04-02 19:17:04.535236+00
472	4	669	5	4	3	On-time delivery	2023-09-03 19:17:04.535236+00
473	4	670	4	3	5	Quality as expected	2022-11-20 19:17:04.535236+00
474	5	671	5	5	5	On-time delivery	2024-07-09 19:17:04.535236+00
475	3	672	5	4	3	Good service	2022-07-28 19:17:04.535236+00
476	2	673	3	3	5	On-time delivery	2023-01-30 19:17:04.535236+00
477	4	675	5	5	5	Would order again	2025-05-22 19:17:04.535236+00
478	2	676	4	5	3	Excellent communication	2024-07-28 19:17:04.535236+00
479	1	677	5	4	4	Quality as expected	2025-02-11 19:17:04.535236+00
480	1	678	5	5	3	Excellent communication	2025-05-24 19:17:04.535236+00
481	1	679	4	5	4	Good service	2023-10-09 19:17:04.535236+00
482	5	680	5	3	4	Excellent communication	2024-01-01 19:17:04.535236+00
483	4	681	3	3	3	On-time delivery	2025-04-16 19:17:04.535236+00
484	3	682	4	3	4	Good service	2024-05-11 19:17:04.535236+00
485	4	683	5	5	3	Would order again	2022-01-24 19:17:04.535236+00
486	4	684	5	3	5	Excellent communication	2025-03-29 19:17:04.535236+00
487	3	685	5	5	3	Would order again	2025-02-22 19:17:04.535236+00
488	5	689	5	5	3	Quality as expected	2025-04-27 19:17:04.535236+00
489	1	690	4	3	4	Excellent communication	2023-12-09 19:17:04.535236+00
490	5	692	5	5	3	Quality as expected	2025-01-31 19:17:04.535236+00
491	5	693	3	3	3	Good service	2023-04-27 19:17:04.535236+00
492	1	696	3	3	3	Good service	2024-01-28 19:17:04.535236+00
493	4	697	4	4	3	Excellent communication	2023-08-02 19:17:04.535236+00
494	2	698	4	4	5	Excellent communication	2022-04-28 19:17:04.535236+00
495	5	699	4	3	5	Quality as expected	2021-10-12 19:17:04.535236+00
496	4	700	3	4	5	Good service	2024-10-10 19:17:04.535236+00
497	4	702	4	4	3	Good service	2024-03-16 19:17:04.535236+00
498	5	704	3	3	4	On-time delivery	2025-04-21 19:17:04.535236+00
499	1	705	5	5	5	Quality as expected	2024-06-21 19:17:04.535236+00
500	5	706	3	5	3	On-time delivery	2021-07-30 19:17:04.535236+00
501	1	707	4	4	5	Excellent communication	2025-05-31 19:17:04.535236+00
502	5	708	4	5	4	Quality as expected	2024-01-22 19:17:04.535236+00
503	1	709	4	5	3	Quality as expected	2025-04-06 19:17:04.535236+00
504	1	710	4	3	3	Would order again	2024-06-17 19:17:04.535236+00
505	4	711	4	3	5	On-time delivery	2024-12-16 19:17:04.535236+00
506	3	712	3	4	5	Quality as expected	2023-05-08 19:17:04.535236+00
507	3	713	4	4	5	Excellent communication	2025-05-22 19:17:04.535236+00
508	2	714	4	4	4	Good service	2025-04-24 19:17:04.535236+00
509	2	716	3	3	3	Quality as expected	2023-04-29 19:17:04.535236+00
510	3	717	3	5	5	Quality as expected	2022-12-29 19:17:04.535236+00
511	3	718	3	3	5	Would order again	2024-11-22 19:17:04.535236+00
512	5	719	5	5	5	Quality as expected	2021-01-09 19:17:04.535236+00
513	5	720	3	3	3	Would order again	2023-04-24 19:17:04.535236+00
514	1	721	3	5	4	Excellent communication	2023-09-26 19:17:04.535236+00
515	5	722	5	3	4	Excellent communication	2022-02-07 19:17:04.535236+00
516	5	723	3	5	4	Good service	2025-02-04 19:17:04.535236+00
517	2	724	3	4	5	On-time delivery	2025-02-07 19:17:04.535236+00
518	4	725	4	4	4	Quality as expected	2023-05-10 19:17:04.535236+00
519	5	726	3	4	3	Good service	2025-03-16 19:17:04.535236+00
520	3	729	3	5	4	Would order again	2022-03-15 19:17:04.535236+00
521	3	732	4	4	5	On-time delivery	2024-09-12 19:17:04.535236+00
522	2	733	4	3	3	Excellent communication	2025-04-26 19:17:04.535236+00
523	1	735	5	3	5	Excellent communication	2023-09-02 19:17:04.535236+00
524	5	736	5	4	3	Excellent communication	2024-03-28 19:17:04.535236+00
525	2	737	3	3	4	On-time delivery	2022-10-10 19:17:04.535236+00
526	4	739	5	4	3	Excellent communication	2022-11-02 19:17:04.535236+00
527	2	741	5	4	3	Good service	2023-09-14 19:17:04.535236+00
528	4	742	5	3	5	Excellent communication	2022-06-16 19:17:04.535236+00
529	5	746	3	5	4	Would order again	2022-09-29 19:17:04.535236+00
530	3	748	3	3	3	On-time delivery	2023-02-10 19:17:04.535236+00
531	3	749	3	5	5	Good service	2025-05-23 19:17:04.535236+00
532	2	753	4	4	3	Good service	2024-07-18 19:17:04.535236+00
533	2	755	4	3	3	Quality as expected	2024-06-14 19:17:04.535236+00
534	2	757	3	4	4	Good service	2024-02-19 19:17:04.535236+00
535	4	758	5	3	4	Would order again	2021-09-15 19:17:04.535236+00
536	2	760	3	3	3	Quality as expected	2025-05-16 19:17:04.535236+00
537	5	763	3	4	3	Quality as expected	2024-08-08 19:17:04.535236+00
538	2	764	3	5	4	On-time delivery	2023-02-21 19:17:04.535236+00
539	3	768	3	5	4	Would order again	2024-04-08 19:17:04.535236+00
540	3	769	5	3	3	Would order again	2023-01-22 19:17:04.535236+00
541	1	770	4	5	3	Excellent communication	2025-05-12 19:17:04.535236+00
542	3	771	5	4	5	Would order again	2021-08-24 19:17:04.535236+00
543	3	772	3	5	3	Quality as expected	2024-08-16 19:17:04.535236+00
544	4	773	3	4	3	On-time delivery	2024-10-28 19:17:04.535236+00
545	3	775	3	3	4	Excellent communication	2022-04-02 19:17:04.535236+00
546	2	777	5	3	4	Good service	2024-09-02 19:17:04.535236+00
547	3	778	4	4	3	Would order again	2023-05-19 19:17:04.535236+00
548	3	779	3	4	5	Quality as expected	2025-05-01 19:17:04.535236+00
549	2	780	5	3	5	On-time delivery	2024-09-01 19:17:04.535236+00
550	4	781	3	3	3	On-time delivery	2025-03-20 19:17:04.535236+00
551	5	782	4	3	4	Excellent communication	2022-11-08 19:17:04.535236+00
552	1	783	3	5	4	Would order again	2025-04-30 19:17:04.535236+00
553	3	784	3	4	3	Good service	2024-12-11 19:17:04.535236+00
554	1	787	4	3	4	On-time delivery	2025-05-20 19:17:04.535236+00
555	4	788	5	5	4	Would order again	2025-04-23 19:17:04.535236+00
556	4	789	5	5	3	Good service	2025-05-05 19:17:04.535236+00
557	4	790	4	5	4	Would order again	2025-03-24 19:17:04.535236+00
558	5	793	4	5	5	Excellent communication	2025-05-20 19:17:04.535236+00
559	3	794	4	4	5	Quality as expected	2025-05-31 19:17:04.535236+00
560	5	795	4	3	5	On-time delivery	2024-07-13 19:17:04.535236+00
561	3	797	3	3	5	Quality as expected	2022-07-18 19:17:04.535236+00
562	2	798	5	3	4	Quality as expected	2023-04-12 19:17:04.535236+00
563	1	799	4	3	5	Quality as expected	2023-12-27 19:17:04.535236+00
564	2	800	5	4	3	On-time delivery	2022-06-10 19:17:04.535236+00
565	3	801	3	3	3	Good service	2024-11-09 19:17:04.535236+00
566	4	802	4	3	5	Would order again	2023-01-01 19:17:04.535236+00
567	2	803	4	3	5	Excellent communication	2023-05-10 19:17:04.535236+00
568	2	806	4	4	5	Quality as expected	2023-05-20 19:17:04.535236+00
569	5	807	5	4	5	Good service	2025-03-02 19:17:04.535236+00
570	3	808	4	5	3	Good service	2025-05-07 19:17:04.535236+00
571	4	809	5	3	5	Excellent communication	2024-07-01 19:17:04.535236+00
572	5	810	4	4	3	On-time delivery	2023-08-02 19:17:04.535236+00
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: company_user
--

COPY public.suppliers (id, name, category, rating, contact_email, contact_phone, payment_terms, delivery_lead_time, is_active, created_at, updated_at) FROM stdin;
1	Office Supplies Co	Office Supplies	4.50	contact@officesupplies.com	+1-555-0101	Net 30	3	t	2025-05-31 19:17:04.519326+00	2025-05-31 19:17:04.519326+00
2	Tech Solutions Inc	Electronics	4.80	sales@techsolutions.com	+1-555-0102	Net 45	5	t	2025-05-31 19:17:04.519326+00	2025-05-31 19:17:04.519326+00
3	Furniture World	Furniture	4.20	orders@furnitureworld.com	+1-555-0103	Net 60	7	t	2025-05-31 19:17:04.519326+00	2025-05-31 19:17:04.519326+00
4	Digital Solutions	Electronics	4.60	support@digitalsolutions.com	+1-555-0104	Net 30	4	t	2025-05-31 19:17:04.519326+00	2025-05-31 19:17:04.519326+00
5	Office Essentials	Office Supplies	4.30	info@officeessentials.com	+1-555-0105	Net 30	2	t	2025-05-31 19:17:04.519326+00	2025-05-31 19:17:04.519326+00
\.


--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: company_user
--

SELECT pg_catalog.setval('public.purchase_order_items_id_seq', 1599, true);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: company_user
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 810, true);


--
-- Name: purchase_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: company_user
--

SELECT pg_catalog.setval('public.purchase_requests_id_seq', 1000, true);


--
-- Name: supplier_performance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: company_user
--

SELECT pg_catalog.setval('public.supplier_performance_id_seq', 572, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: company_user
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_order_number_key UNIQUE (order_number);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: purchase_requests purchase_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pkey PRIMARY KEY (id);


--
-- Name: supplier_performance supplier_performance_pkey; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.supplier_performance
    ADD CONSTRAINT supplier_performance_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id);


--
-- Name: purchase_orders purchase_orders_purchase_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_purchase_request_id_fkey FOREIGN KEY (purchase_request_id) REFERENCES public.purchase_requests(id);


--
-- Name: purchase_orders purchase_orders_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: supplier_performance supplier_performance_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.supplier_performance
    ADD CONSTRAINT supplier_performance_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id);


--
-- Name: supplier_performance supplier_performance_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: company_user
--

ALTER TABLE ONLY public.supplier_performance
    ADD CONSTRAINT supplier_performance_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- PostgreSQL database dump complete
--

