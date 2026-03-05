drop extension if exists "pg_net";

create extension if not exists "pgrouting" with schema "public";

create extension if not exists "postgis" with schema "public";

create sequence "public"."calibrations_calibration_id_seq";

create sequence "public"."edge_edge_id_seq";

create sequence "public"."floor_floor_id_seq";

create sequence "public"."landmark_landmark_id_seq";

create sequence "public"."node_node_id_seq";

create sequence "public"."route_paths_path_id_seq";

create sequence "public"."routes_route_id_seq";


  create table "public"."calibrations" (
    "calibration_id" integer not null default nextval('public.calibrations_calibration_id_seq'::regclass),
    "guest_id" character varying,
    "geom" public.geometry,
    "floor_id" integer,
    "created_at" timestamp without time zone default now()
      );


alter table "public"."calibrations" enable row level security;


  create table "public"."edge" (
    "edge_id" integer not null default nextval('public.edge_edge_id_seq'::regclass),
    "source" integer,
    "target" integer,
    "cost" double precision,
    "geom" public.geometry(LineString,4326),
    "floor_id" integer
      );


alter table "public"."edge" enable row level security;


  create table "public"."floor" (
    "floor_id" integer not null default nextval('public.floor_floor_id_seq'::regclass),
    "floor_number" integer not null
      );


alter table "public"."floor" enable row level security;


  create table "public"."guest_users" (
    "guest_id" character varying not null,
    "created_at" timestamp without time zone default now(),
    "last_active" timestamp without time zone
      );


alter table "public"."guest_users" enable row level security;


  create table "public"."landmark" (
    "landmark_id" integer not null default nextval('public.landmark_landmark_id_seq'::regclass),
    "floor_id" integer not null,
    "name_th" text,
    "type" text,
    "node_id" integer not null default 1,
    "name_eng" text not null,
    "image_url" text
      );


alter table "public"."landmark" enable row level security;


  create table "public"."node" (
    "node_id" integer not null default nextval('public.node_node_id_seq'::regclass),
    "floor_id" integer not null default 1,
    "node_type" text,
    "geom" public.geometry(Point,4326)
      );


alter table "public"."node" enable row level security;


  create table "public"."route_paths" (
    "path_id" integer not null default nextval('public.route_paths_path_id_seq'::regclass),
    "route_id" integer,
    "seq" integer,
    "node_id" integer,
    "geom" public.geometry,
    "floor_id" integer
      );


alter table "public"."route_paths" enable row level security;


  create table "public"."routes" (
    "route_id" integer not null default nextval('public.routes_route_id_seq'::regclass),
    "guest_id" character varying,
    "start_node" integer,
    "end_node" integer,
    "mode" character varying,
    "created_at" timestamp without time zone default now()
      );


alter table "public"."routes" enable row level security;

alter sequence "public"."calibrations_calibration_id_seq" owned by "public"."calibrations"."calibration_id";

alter sequence "public"."edge_edge_id_seq" owned by "public"."edge"."edge_id";

alter sequence "public"."floor_floor_id_seq" owned by "public"."floor"."floor_id";

alter sequence "public"."landmark_landmark_id_seq" owned by "public"."landmark"."landmark_id";

alter sequence "public"."node_node_id_seq" owned by "public"."node"."node_id";

alter sequence "public"."route_paths_path_id_seq" owned by "public"."route_paths"."path_id";

alter sequence "public"."routes_route_id_seq" owned by "public"."routes"."route_id";

CREATE UNIQUE INDEX calibrations_pkey ON public.calibrations USING btree (calibration_id);

CREATE UNIQUE INDEX edge_pkey ON public.edge USING btree (edge_id);

CREATE UNIQUE INDEX floor_pkey ON public.floor USING btree (floor_id);

CREATE UNIQUE INDEX guest_users_pkey ON public.guest_users USING btree (guest_id);

CREATE UNIQUE INDEX landmark_pkey ON public.landmark USING btree (landmark_id);

CREATE UNIQUE INDEX node_pkey ON public.node USING btree (node_id);

CREATE UNIQUE INDEX route_paths_pkey ON public.route_paths USING btree (path_id);

CREATE UNIQUE INDEX routes_pkey ON public.routes USING btree (route_id);

alter table "public"."calibrations" add constraint "calibrations_pkey" PRIMARY KEY using index "calibrations_pkey";

alter table "public"."edge" add constraint "edge_pkey" PRIMARY KEY using index "edge_pkey";

alter table "public"."floor" add constraint "floor_pkey" PRIMARY KEY using index "floor_pkey";

alter table "public"."guest_users" add constraint "guest_users_pkey" PRIMARY KEY using index "guest_users_pkey";

alter table "public"."landmark" add constraint "landmark_pkey" PRIMARY KEY using index "landmark_pkey";

alter table "public"."node" add constraint "node_pkey" PRIMARY KEY using index "node_pkey";

alter table "public"."route_paths" add constraint "route_paths_pkey" PRIMARY KEY using index "route_paths_pkey";

alter table "public"."routes" add constraint "routes_pkey" PRIMARY KEY using index "routes_pkey";

alter table "public"."calibrations" add constraint "calibrations_floor_id_fkey" FOREIGN KEY (floor_id) REFERENCES public.floor(floor_id) ON DELETE CASCADE not valid;

alter table "public"."calibrations" validate constraint "calibrations_floor_id_fkey";

alter table "public"."calibrations" add constraint "calibrations_guest_id_fkey" FOREIGN KEY (guest_id) REFERENCES public.guest_users(guest_id) ON DELETE CASCADE not valid;

alter table "public"."calibrations" validate constraint "calibrations_guest_id_fkey";

alter table "public"."edge" add constraint "fk_edge_floor" FOREIGN KEY (floor_id) REFERENCES public.floor(floor_id) not valid;

alter table "public"."edge" validate constraint "fk_edge_floor";

alter table "public"."edge" add constraint "fk_edge_source" FOREIGN KEY (source) REFERENCES public.node(node_id) not valid;

alter table "public"."edge" validate constraint "fk_edge_source";

alter table "public"."edge" add constraint "fk_edge_target" FOREIGN KEY (target) REFERENCES public.node(node_id) not valid;

alter table "public"."edge" validate constraint "fk_edge_target";

alter table "public"."landmark" add constraint "fk_landmark_floor" FOREIGN KEY (floor_id) REFERENCES public.floor(floor_id) ON DELETE CASCADE not valid;

alter table "public"."landmark" validate constraint "fk_landmark_floor";

alter table "public"."landmark" add constraint "landmark_node_id_fkey" FOREIGN KEY (node_id) REFERENCES public.node(node_id) ON DELETE CASCADE not valid;

alter table "public"."landmark" validate constraint "landmark_node_id_fkey";

alter table "public"."node" add constraint "fk_node_floor" FOREIGN KEY (floor_id) REFERENCES public.floor(floor_id) ON DELETE CASCADE not valid;

alter table "public"."node" validate constraint "fk_node_floor";

alter table "public"."route_paths" add constraint "route_paths_floor_id_fkey" FOREIGN KEY (floor_id) REFERENCES public.floor(floor_id) ON DELETE CASCADE not valid;

alter table "public"."route_paths" validate constraint "route_paths_floor_id_fkey";

alter table "public"."route_paths" add constraint "route_paths_node_id_fkey" FOREIGN KEY (node_id) REFERENCES public.node(node_id) ON DELETE CASCADE not valid;

alter table "public"."route_paths" validate constraint "route_paths_node_id_fkey";

alter table "public"."route_paths" add constraint "route_paths_route_id_fkey" FOREIGN KEY (route_id) REFERENCES public.routes(route_id) ON DELETE CASCADE not valid;

alter table "public"."route_paths" validate constraint "route_paths_route_id_fkey";

alter table "public"."routes" add constraint "routes_end_node_fkey" FOREIGN KEY (end_node) REFERENCES public.node(node_id) ON DELETE CASCADE not valid;

alter table "public"."routes" validate constraint "routes_end_node_fkey";

alter table "public"."routes" add constraint "routes_guest_id_fkey" FOREIGN KEY (guest_id) REFERENCES public.guest_users(guest_id) ON DELETE CASCADE not valid;

alter table "public"."routes" validate constraint "routes_guest_id_fkey";

alter table "public"."routes" add constraint "routes_start_node_fkey" FOREIGN KEY (start_node) REFERENCES public.node(node_id) ON DELETE CASCADE not valid;

alter table "public"."routes" validate constraint "routes_start_node_fkey";

create type "public"."geometry_dump" as ("path" integer[], "geom" public.geometry);

create type "public"."valid_detail" as ("valid" boolean, "reason" character varying, "location" public.geometry);

grant delete on table "public"."calibrations" to "anon";

grant insert on table "public"."calibrations" to "anon";

grant references on table "public"."calibrations" to "anon";

grant select on table "public"."calibrations" to "anon";

grant trigger on table "public"."calibrations" to "anon";

grant truncate on table "public"."calibrations" to "anon";

grant update on table "public"."calibrations" to "anon";

grant delete on table "public"."calibrations" to "authenticated";

grant insert on table "public"."calibrations" to "authenticated";

grant references on table "public"."calibrations" to "authenticated";

grant select on table "public"."calibrations" to "authenticated";

grant trigger on table "public"."calibrations" to "authenticated";

grant truncate on table "public"."calibrations" to "authenticated";

grant update on table "public"."calibrations" to "authenticated";

grant delete on table "public"."calibrations" to "service_role";

grant insert on table "public"."calibrations" to "service_role";

grant references on table "public"."calibrations" to "service_role";

grant select on table "public"."calibrations" to "service_role";

grant trigger on table "public"."calibrations" to "service_role";

grant truncate on table "public"."calibrations" to "service_role";

grant update on table "public"."calibrations" to "service_role";

grant delete on table "public"."edge" to "anon";

grant insert on table "public"."edge" to "anon";

grant references on table "public"."edge" to "anon";

grant select on table "public"."edge" to "anon";

grant trigger on table "public"."edge" to "anon";

grant truncate on table "public"."edge" to "anon";

grant update on table "public"."edge" to "anon";

grant delete on table "public"."edge" to "authenticated";

grant insert on table "public"."edge" to "authenticated";

grant references on table "public"."edge" to "authenticated";

grant select on table "public"."edge" to "authenticated";

grant trigger on table "public"."edge" to "authenticated";

grant truncate on table "public"."edge" to "authenticated";

grant update on table "public"."edge" to "authenticated";

grant delete on table "public"."edge" to "service_role";

grant insert on table "public"."edge" to "service_role";

grant references on table "public"."edge" to "service_role";

grant select on table "public"."edge" to "service_role";

grant trigger on table "public"."edge" to "service_role";

grant truncate on table "public"."edge" to "service_role";

grant update on table "public"."edge" to "service_role";

grant delete on table "public"."floor" to "anon";

grant insert on table "public"."floor" to "anon";

grant references on table "public"."floor" to "anon";

grant select on table "public"."floor" to "anon";

grant trigger on table "public"."floor" to "anon";

grant truncate on table "public"."floor" to "anon";

grant update on table "public"."floor" to "anon";

grant delete on table "public"."floor" to "authenticated";

grant insert on table "public"."floor" to "authenticated";

grant references on table "public"."floor" to "authenticated";

grant select on table "public"."floor" to "authenticated";

grant trigger on table "public"."floor" to "authenticated";

grant truncate on table "public"."floor" to "authenticated";

grant update on table "public"."floor" to "authenticated";

grant delete on table "public"."floor" to "service_role";

grant insert on table "public"."floor" to "service_role";

grant references on table "public"."floor" to "service_role";

grant select on table "public"."floor" to "service_role";

grant trigger on table "public"."floor" to "service_role";

grant truncate on table "public"."floor" to "service_role";

grant update on table "public"."floor" to "service_role";

grant delete on table "public"."guest_users" to "anon";

grant insert on table "public"."guest_users" to "anon";

grant references on table "public"."guest_users" to "anon";

grant select on table "public"."guest_users" to "anon";

grant trigger on table "public"."guest_users" to "anon";

grant truncate on table "public"."guest_users" to "anon";

grant update on table "public"."guest_users" to "anon";

grant delete on table "public"."guest_users" to "authenticated";

grant insert on table "public"."guest_users" to "authenticated";

grant references on table "public"."guest_users" to "authenticated";

grant select on table "public"."guest_users" to "authenticated";

grant trigger on table "public"."guest_users" to "authenticated";

grant truncate on table "public"."guest_users" to "authenticated";

grant update on table "public"."guest_users" to "authenticated";

grant delete on table "public"."guest_users" to "service_role";

grant insert on table "public"."guest_users" to "service_role";

grant references on table "public"."guest_users" to "service_role";

grant select on table "public"."guest_users" to "service_role";

grant trigger on table "public"."guest_users" to "service_role";

grant truncate on table "public"."guest_users" to "service_role";

grant update on table "public"."guest_users" to "service_role";

grant delete on table "public"."landmark" to "anon";

grant insert on table "public"."landmark" to "anon";

grant references on table "public"."landmark" to "anon";

grant select on table "public"."landmark" to "anon";

grant trigger on table "public"."landmark" to "anon";

grant truncate on table "public"."landmark" to "anon";

grant update on table "public"."landmark" to "anon";

grant delete on table "public"."landmark" to "authenticated";

grant insert on table "public"."landmark" to "authenticated";

grant references on table "public"."landmark" to "authenticated";

grant select on table "public"."landmark" to "authenticated";

grant trigger on table "public"."landmark" to "authenticated";

grant truncate on table "public"."landmark" to "authenticated";

grant update on table "public"."landmark" to "authenticated";

grant delete on table "public"."landmark" to "service_role";

grant insert on table "public"."landmark" to "service_role";

grant references on table "public"."landmark" to "service_role";

grant select on table "public"."landmark" to "service_role";

grant trigger on table "public"."landmark" to "service_role";

grant truncate on table "public"."landmark" to "service_role";

grant update on table "public"."landmark" to "service_role";

grant delete on table "public"."node" to "anon";

grant insert on table "public"."node" to "anon";

grant references on table "public"."node" to "anon";

grant select on table "public"."node" to "anon";

grant trigger on table "public"."node" to "anon";

grant truncate on table "public"."node" to "anon";

grant update on table "public"."node" to "anon";

grant delete on table "public"."node" to "authenticated";

grant insert on table "public"."node" to "authenticated";

grant references on table "public"."node" to "authenticated";

grant select on table "public"."node" to "authenticated";

grant trigger on table "public"."node" to "authenticated";

grant truncate on table "public"."node" to "authenticated";

grant update on table "public"."node" to "authenticated";

grant delete on table "public"."node" to "service_role";

grant insert on table "public"."node" to "service_role";

grant references on table "public"."node" to "service_role";

grant select on table "public"."node" to "service_role";

grant trigger on table "public"."node" to "service_role";

grant truncate on table "public"."node" to "service_role";

grant update on table "public"."node" to "service_role";

grant delete on table "public"."route_paths" to "anon";

grant insert on table "public"."route_paths" to "anon";

grant references on table "public"."route_paths" to "anon";

grant select on table "public"."route_paths" to "anon";

grant trigger on table "public"."route_paths" to "anon";

grant truncate on table "public"."route_paths" to "anon";

grant update on table "public"."route_paths" to "anon";

grant delete on table "public"."route_paths" to "authenticated";

grant insert on table "public"."route_paths" to "authenticated";

grant references on table "public"."route_paths" to "authenticated";

grant select on table "public"."route_paths" to "authenticated";

grant trigger on table "public"."route_paths" to "authenticated";

grant truncate on table "public"."route_paths" to "authenticated";

grant update on table "public"."route_paths" to "authenticated";

grant delete on table "public"."route_paths" to "service_role";

grant insert on table "public"."route_paths" to "service_role";

grant references on table "public"."route_paths" to "service_role";

grant select on table "public"."route_paths" to "service_role";

grant trigger on table "public"."route_paths" to "service_role";

grant truncate on table "public"."route_paths" to "service_role";

grant update on table "public"."route_paths" to "service_role";

grant delete on table "public"."routes" to "anon";

grant insert on table "public"."routes" to "anon";

grant references on table "public"."routes" to "anon";

grant select on table "public"."routes" to "anon";

grant trigger on table "public"."routes" to "anon";

grant truncate on table "public"."routes" to "anon";

grant update on table "public"."routes" to "anon";

grant delete on table "public"."routes" to "authenticated";

grant insert on table "public"."routes" to "authenticated";

grant references on table "public"."routes" to "authenticated";

grant select on table "public"."routes" to "authenticated";

grant trigger on table "public"."routes" to "authenticated";

grant truncate on table "public"."routes" to "authenticated";

grant update on table "public"."routes" to "authenticated";

grant delete on table "public"."routes" to "service_role";

grant insert on table "public"."routes" to "service_role";

grant references on table "public"."routes" to "service_role";

grant select on table "public"."routes" to "service_role";

grant trigger on table "public"."routes" to "service_role";

grant truncate on table "public"."routes" to "service_role";

grant update on table "public"."routes" to "service_role";

grant delete on table "public"."spatial_ref_sys" to "anon";

grant insert on table "public"."spatial_ref_sys" to "anon";

grant references on table "public"."spatial_ref_sys" to "anon";

grant select on table "public"."spatial_ref_sys" to "anon";

grant trigger on table "public"."spatial_ref_sys" to "anon";

grant truncate on table "public"."spatial_ref_sys" to "anon";

grant update on table "public"."spatial_ref_sys" to "anon";

grant delete on table "public"."spatial_ref_sys" to "authenticated";

grant insert on table "public"."spatial_ref_sys" to "authenticated";

grant references on table "public"."spatial_ref_sys" to "authenticated";

grant select on table "public"."spatial_ref_sys" to "authenticated";

grant trigger on table "public"."spatial_ref_sys" to "authenticated";

grant truncate on table "public"."spatial_ref_sys" to "authenticated";

grant update on table "public"."spatial_ref_sys" to "authenticated";

grant delete on table "public"."spatial_ref_sys" to "postgres";

grant insert on table "public"."spatial_ref_sys" to "postgres";

grant references on table "public"."spatial_ref_sys" to "postgres";

grant select on table "public"."spatial_ref_sys" to "postgres";

grant trigger on table "public"."spatial_ref_sys" to "postgres";

grant truncate on table "public"."spatial_ref_sys" to "postgres";

grant update on table "public"."spatial_ref_sys" to "postgres";

grant delete on table "public"."spatial_ref_sys" to "service_role";

grant insert on table "public"."spatial_ref_sys" to "service_role";

grant references on table "public"."spatial_ref_sys" to "service_role";

grant select on table "public"."spatial_ref_sys" to "service_role";

grant trigger on table "public"."spatial_ref_sys" to "service_role";

grant truncate on table "public"."spatial_ref_sys" to "service_role";

grant update on table "public"."spatial_ref_sys" to "service_role";


  create policy "Enable read access for all users"
  on "public"."edge"
  as permissive
  for select
  to public
using (true);



  create policy "Enable read access for all users"
  on "public"."floor"
  as permissive
  for select
  to public
using (true);



  create policy "Enable read access for all users"
  on "public"."landmark"
  as permissive
  for select
  to public
using (true);



  create policy "Enable read access for all users"
  on "public"."node"
  as permissive
  for select
  to public
using (true);



