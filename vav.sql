--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: imagen_eliminar(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

        	imagen.imagen_id,

        	imagen.imagen_objeto,

        	imagen.imagen_tipo,

        	imagen.imagen_extension

	    FROM

	        imagen

	    WHERE

	        imagen.imagen_id = in_imagen_id AND

	        imagen.imagen_objeto = in_imagen_objeto

	    LIMIT 1

	    ;

	--	Eliminar Imagen

        DELETE FROM

        	imagen

        WHERE

        	imagen.imagen_id = in_imagen_id AND

        	imagen.imagen_objeto = in_imagen_objeto

        ;

	END $$;


ALTER FUNCTION public.imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) OWNER TO postgres;

--
-- Name: imagen_listado(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_orden bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying, imagen_cambio bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

        	imagen.imagen_id,

        	imagen.imagen_orden,

        	imagen.imagen_objeto,

        	imagen.imagen_tipo,

        	imagen.imagen_extension,

        	imagen.imagen_cambio

	    FROM

	        imagen

	    WHERE

	        imagen.imagen_objeto = in_imagen_objeto AND

	        imagen.imagen_tipo = in_imagen_tipo

		ORDER BY

			imagen_orden ASC

	    LIMIT 50

	    ;

	END $$;


ALTER FUNCTION public.imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) OWNER TO postgres;

--
-- Name: imagen_nueva(bigint, bigint, character varying, character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_imagen_id bigint;

			v_orden bigint;

		BEGIN

		-- verificar si email ya esta registrado

		select count(*) from imagen where imagen_objeto = in_imagen_objeto INTO v_orden;

        INSERT INTO imagen

        (

        	imagen_id,

        	imagen_orden,

        	imagen_objeto,

        	imagen_tipo,

        	imagen_extension,

        	imagen_cambio

        )

		VALUES

		(

        	in_imagen_id,

        	v_orden,

        	in_imagen_objeto,

        	in_imagen_tipo,

        	in_imagen_extension,

        	in_imagen_cambio

		);

        RETURN v_imagen_id;

	END $$;


ALTER FUNCTION public.imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) OWNER TO postgres;

--
-- Name: mesa_activar(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

		UPDATE

			mesa

		SET

			mesa_estado = 1,

			mesa_numero = in_mesa_numero,

			mesa_cambio = now()

		WHERE mesa_id = in_mesa_id;

		return 1;

	END $$;


ALTER FUNCTION public.mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) OWNER TO postgres;

--
-- Name: mesa_candidato_guardar(bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--  Actualizar Candidato

		UPDATE

			candidato

		SET

			candidato_nombres = in_candidato_nombres,

			candidato_apellidos = in_candidato_apellidos

		WHERE

			candidato_id = in_candidato_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) OWNER TO app_vav;

--
-- Name: mesa_candidatos(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_candidatos(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombre character varying, candidato_nombres character varying, candidato_apellidos character varying, candidato_lista character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            voto.voto_id,

            voto.voto_total,

            voto.candidato_id,

            candidato.candidato_nombre,

			candidato.candidato_nombres,

			candidato.candidato_apellidos,

			candidato.candidato_lista

	    FROM

            candidato,

            voto

	    WHERE

	        candidato.candidato_id  =   voto.candidato_id AND

	        voto.mesa_id = in_mesa_id

		ORDER BY candidato.candidato_orden ASC

	    ;

	END $$;


ALTER FUNCTION public.mesa_candidatos(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_candidatos_swich(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_candidatos_swich(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_orden smallint, candidato_nombres character varying, candidato_apellidos character varying, candidato_genero character varying, candidato_independiente boolean, candidato_lista character varying, partido_codigo character varying, partido_id bigint, pacto_codigo character varying, pacto_id bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            voto.voto_id,

            voto.voto_total,

            voto.candidato_id,

			candidato.candidato_orden,

			candidato.candidato_nombres,

			candidato.candidato_apellidos,

			candidato.candidato_genero,

			candidato.candidato_independiente,

			candidato.candidato_lista,

			partido.partido_codigo,

			partido.partido_id,

			pacto.pacto_nombre,

			pacto.pacto_id

	    FROM

			pacto,

			partido,

            candidato,

            voto

	    WHERE

			pacto.pacto_id = candidato.pacto_id AND

			partido.partido_id = candidato.partido_id AND

	        candidato.candidato_id = voto.candidato_id AND

	        voto.mesa_id = in_mesa_id

		ORDER BY candidato.candidato_orden ASC;

	END $$;


ALTER FUNCTION public.mesa_candidatos_swich(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_contar_total(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_contar_total() RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(mesa_id) AS objetos 

		FROM

			mesa

	    ;

	END $$;


ALTER FUNCTION public.mesa_contar_total() OWNER TO postgres;

--
-- Name: mesa_contar_total_switch(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_contar_total_switch() RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(mesa_id) AS objetos 

		FROM

			mesa

		WHERE

            mesa.mesa_estado = 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_contar_total_switch() OWNER TO postgres;

--
-- Name: mesa_destacada(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_destacada(in_mesa_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_id bigint;

			v_estado bigint;

		BEGIN

	--	Obtener Estado Actual

		SELECT mesa_destacada FROM mesa WHERE mesa_id = in_mesa_id INTO v_estado;

		IF v_estado = 1 THEN

			UPDATE

				mesa

			SET

				mesa_destacada = 0,

				mesa_cambio = now()

			WHERE mesa_id = in_mesa_id;

			return 0;

		ELSE

			UPDATE

				mesa

			SET

				mesa_destacada = 1,

				mesa_cambio = now()

			WHERE mesa_id = in_mesa_id;

			return 1;

		END IF;

	END $$;


ALTER FUNCTION public.mesa_destacada(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_detalles(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_detalles(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_orden smallint, mesa_estado smallint, mesa_destacada smallint, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.usuario_id,

            mesa.mesa_tipo,

            mesa.mesa_zona,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero,

            mesa.mesa_orden,

            mesa.mesa_estado,

            mesa.mesa_destacada,

            mesa.mesa_votos_blancos,

            mesa.mesa_votos_nulos,

            mesa.mesa_cambio,

            mesa.mesa_creado,

			usuario.usuario_nombre

	    FROM

			usuario,

	        mesa

	    WHERE

			usuario.usuario_id = mesa.usuario_id AND

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_detalles(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_detalles_swich(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_detalles_swich(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.mesa_tipo,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero

	    FROM

	        mesa

	    WHERE

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_detalles_swich(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_editar(bigint, bigint, bigint, character varying, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--	Editar mesa

		UPDATE

			mesa

		SET

			usuario_id	= in_usuario_id,

			mesa_estado = in_mesa_estado,

			mesa_nombre = in_mesa_nombre,

			mesa_numero = in_mesa_numero,

			mesa_region = in_mesa_region,

			mesa_ciudad = in_mesa_ciudad,

			mesa_voto_a = in_mesa_voto_a,

			mesa_voto_r = in_mesa_voto_r,

			mesa_voto_ar_blanco = in_mesa_voto_ar_blanco,

			mesa_voto_ar_nulo = in_mesa_voto_ar_nulo,

			mesa_voto_cm = in_mesa_voto_cm,

			mesa_voto_cc = in_mesa_voto_cc,

			mesa_voto_cmcc_blanco = in_mesa_voto_cmcc_blanco,

			mesa_voto_cmcc_nulo = in_mesa_voto_cmcc_nulo,

			mesa_cambio = now()

		WHERE

			mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) OWNER TO postgres;

--
-- Name: mesa_eliminar(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_eliminar(in_mesa_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--	Eliminar votos

        DELETE FROM voto WHERE voto.mesa_id = in_mesa_id;

	--	Eliminar mesa

        DELETE FROM mesa WHERE mesa.mesa_id = in_mesa_id;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_eliminar(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_guardar(bigint, bigint, bigint, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying, in_mesa_publicado character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--	Editar mesa

		UPDATE

			mesa

		SET

			usuario_id	= in_usuario_id,

			mesa_estado = in_mesa_estado,

			mesa_comuna = in_mesa_comuna,

			mesa_local = in_mesa_local,

			mesa_numero = in_mesa_numero,

			mesa_publicado = in_mesa_publicado,

			mesa_cambio = now()

		WHERE

			mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying, in_mesa_publicado character varying) OWNER TO app_vav;

--
-- Name: mesa_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, mesa_publicado character varying, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    mesa.mesa_id,

		    mesa.usuario_id,

			mesa.mesa_tipo,

			mesa.mesa_orden,

		    mesa.mesa_destacada,

		    mesa.mesa_estado,

			mesa.mesa_zona,

			mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

		    mesa.mesa_local,

		    mesa.mesa_numero,

		    mesa.mesa_votos_blancos,

		    mesa.mesa_votos_nulos,

			mesa.mesa_cambio,

			mesa.mesa_creado,

			mesa.mesa_publicado,

			usuario.usuario_nombre

	    FROM

	        mesa,

	        usuario

		WHERE

			mesa.usuario_id = usuario.usuario_id

	    ORDER BY

	        mesa.mesa_cambio DESC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.mesa_listado(in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: mesa_nuevo(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			in_mesa_id bigint;

		BEGIN

        SELECT nextval('mesa_id_seq') INTO in_mesa_id;

        INSERT INTO mesa

        (

        	mesa_id,

        	usuario_id,

            mesa_tipo,

            mesa_zona,

            mesa_zona_titulo,

			mesa_comuna

        )

		VALUES

		(

			in_mesa_id,

			in_usuario_id,

            in_mesa_tipo,

            in_mesa_zona,

            in_mesa_zona_titulo,

			in_mesa_comuna

		);

    --  AGREGAR CANDIDATOS A LA MESA

		INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo AND candidato_zona = in_mesa_zona;

	--	INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo;

        RETURN in_mesa_id;

	END $$;


ALTER FUNCTION public.mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) OWNER TO postgres;

--
-- Name: mesa_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_obtener_datos(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_destacada smallint, mesa_estado smallint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_ar_blanco smallint, mesa_voto_ar_nulo smallint, mesa_voto_cm smallint, mesa_voto_cc smallint, mesa_voto_cmcc_blanco smallint, mesa_voto_cmcc_nulo smallint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    mesa.mesa_id,

		    mesa.usuario_id,

		    mesa.mesa_destacada,

		    mesa.mesa_estado,

		    mesa.mesa_nombre,

		    mesa.mesa_numero,

		    mesa.mesa_region,

		    mesa.mesa_ciudad,

		    mesa.mesa_voto_a,

		    mesa.mesa_voto_r,

		    mesa.mesa_voto_ar_blanco,

		    mesa.mesa_voto_ar_nulo,

		    mesa.mesa_voto_cm,

		    mesa.mesa_voto_cc,

		    mesa.mesa_voto_cmcc_blanco,

		    mesa.mesa_voto_cmcc_nulo

	    FROM

	        mesa

	    WHERE

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_obtener_datos(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_switch_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_switch_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_cambio timestamp without time zone, mesa_publicado character varying, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    mesa.mesa_id,

		    mesa.usuario_id,

			mesa.mesa_tipo,

			mesa.mesa_orden,

		    mesa.mesa_destacada,

		    mesa.mesa_estado,

			mesa.mesa_zona,

			mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

		    mesa.mesa_local,

		    mesa.mesa_numero,

			mesa.mesa_cambio,

			mesa.mesa_publicado,

			usuario.usuario_nombre

	    FROM

	        mesa,

	        usuario

		WHERE

			mesa.usuario_id = usuario.usuario_id AND

            mesa.mesa_estado = 1

	    ORDER BY

	        mesa.mesa_publicado DESC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.mesa_switch_listado(in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: mesa_usuario_contar_total(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_usuario_contar_total(in_usuario_id bigint) RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(mesa_id) AS objetos

		FROM

			mesa

		WHERE

			usuario_id = in_usuario_id

	    ;

	END $$;


ALTER FUNCTION public.mesa_usuario_contar_total(in_usuario_id bigint) OWNER TO app_vav;

--
-- Name: mesa_usuario_listado(bigint, integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    mesa.mesa_id,

		    mesa.usuario_id,

			mesa.mesa_tipo,

			mesa.mesa_orden,

		    mesa.mesa_destacada,

		    mesa.mesa_estado,

			mesa.mesa_zona,

			mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

		    mesa.mesa_local,

		    mesa.mesa_numero,

		    mesa.mesa_votos_blancos,

		    mesa.mesa_votos_nulos,

			mesa.mesa_cambio,

			mesa.mesa_creado,

			usuario.usuario_nombre

	    FROM

	        mesa,

	        usuario

		WHERE

			mesa.usuario_id = usuario.usuario_id AND

            mesa.usuario_id = in_usuario_id

	    ORDER BY

	        mesa.mesa_destacada DESC,

			mesa.mesa_estado DESC,

	        mesa.mesa_cambio DESC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_voto(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--  Actualizar Votos

		UPDATE

			voto

		SET

			voto_total = in_voto_total

		WHERE

		    voto.voto_id = in_voto_id

		;

	--  Actualizar Mesa

		UPDATE

			mesa

		SET

			mesa_cambio = now()

		WHERE

			mesa.mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) OWNER TO app_vav;

--
-- Name: objeto_estado(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_id bigint;

			v_estado bigint;

		BEGIN

	--	Validar Tipo de Objeto 

		CASE 

		--	Usuarios

			WHEN in_objeto_tipo = 'USU' THEN

			--	Obtener Estado Actual

				SELECT usuario_estado FROM usuario WHERE usuario_id = in_objeto_id INTO v_estado;

				IF v_estado = 1 THEN

					UPDATE usuario SET usuario_estado = 0 WHERE usuario_id = in_objeto_id;

					return 0;

			    ELSE

					UPDATE usuario SET usuario_estado = 1 WHERE usuario_id = in_objeto_id;

					return 1;

			    END IF;

		--	Mesas

			WHEN in_objeto_tipo = 'MES' THEN

			--	Obtener Estado Actual

				SELECT mesa_estado FROM mesa WHERE mesa_id = in_objeto_id INTO v_estado;

				IF v_estado = 1 THEN

					UPDATE

						mesa

					SET

						mesa_estado = 0,

						mesa_cambio = now()

					WHERE mesa_id = in_objeto_id;

					return 0;

			    ELSE

					UPDATE

						mesa

					SET

						mesa_estado = 1,

						mesa_cambio = now()

					WHERE mesa_id = in_objeto_id;

					return 1;

			    END IF;

			ELSE

		END CASE;

	END $$;


ALTER FUNCTION public.objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) OWNER TO postgres;

--
-- Name: swich_actual(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_actual() RETURNS TABLE(swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    swich.swich_mesa_1,

		    swich.swich_mesa_2,

		    swich.swich_mesa_3

	    FROM

	        swich

		WHERE

			swich.swich_id = 1

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.swich_actual() OWNER TO postgres;

--
-- Name: swich_consolidados_mesas(character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_consolidados_mesas(in_mesa_tipo character varying, in_mesa_zona bigint) RETURNS TABLE(votos_total bigint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_independiente boolean, partido_id bigint, pacto_id bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

			SELECT

				sum(voto.voto_total) as votos_total,

				candidato.candidato_id,

				candidato.candidato_nombres,

				candidato.candidato_apellidos,

				candidato.candidato_independiente,

				partido.partido_id,

				pacto.pacto_id

			FROM

				mesa,

				voto,

				candidato,

				partido,

				pacto

			WHERE

				mesa.mesa_tipo = in_mesa_tipo AND

				mesa.mesa_estado IN(1,2) AND

				mesa.mesa_zona = in_mesa_zona AND

				voto.mesa_id = mesa.mesa_id AND

				candidato.candidato_id = voto.candidato_id AND

				partido.partido_id = candidato.partido_id AND

				pacto.pacto_id = candidato.pacto_id

			group by

				candidato.candidato_id,

				partido.partido_id,

				pacto.pacto_id

			ORDER BY

				votos_total DESC

	    ;

	END $$;


ALTER FUNCTION public.swich_consolidados_mesas(in_mesa_tipo character varying, in_mesa_zona bigint) OWNER TO postgres;

--
-- Name: swich_consolidados_presidenciales(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_consolidados_presidenciales() RETURNS TABLE(total bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

				SELECT

					COUNT( mesa.mesa_id ) as total

				FROM

					mesa

				WHERE

					mesa.mesa_tipo = 'P' AND

					mesa.mesa_estado IN(1,2)

	    ;

	END $$;


ALTER FUNCTION public.swich_consolidados_presidenciales() OWNER TO postgres;

--
-- Name: swich_consolidados_presidenciales_totales(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_consolidados_presidenciales_totales(in_mesa_tipo character varying) RETURNS TABLE(votos_total bigint, candidato_id bigint, candidato_orden smallint, candidato_nombres character varying, candidato_apellidos character varying, candidato_independiente boolean, partido_id bigint, pacto_id bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

			SELECT

				sum(voto.voto_total) as votos_total,

				candidato.candidato_id,

				candidato.candidato_orden,

				candidato.candidato_nombres,

				candidato.candidato_apellidos,

				candidato.candidato_independiente,

				partido.partido_id,

				pacto.pacto_id

			FROM

				mesa,

				voto,

				candidato,

				partido,

				pacto

			WHERE

				mesa.mesa_tipo = in_mesa_tipo AND

				mesa.mesa_estado IN(1,2) AND

				voto.mesa_id = mesa.mesa_id AND

				candidato.candidato_id = voto.candidato_id AND

				partido.partido_id = candidato.partido_id AND

				pacto.pacto_id = candidato.pacto_id

			group by

				candidato.candidato_id,

				partido.partido_id,

				pacto.pacto_id

			ORDER BY

				votos_total DESC

	    ;

	END $$;


ALTER FUNCTION public.swich_consolidados_presidenciales_totales(in_mesa_tipo character varying) OWNER TO postgres;

--
-- Name: swich_consolidados_totales(character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_consolidados_totales(in_mesa_tipo character varying, in_mesa_zona bigint) RETURNS TABLE(total bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

				SELECT

					COUNT( mesa.mesa_id ) as total

				FROM

					mesa

				WHERE

					mesa.mesa_tipo = in_mesa_tipo AND

					mesa.mesa_estado IN(1,2) AND

					mesa.mesa_zona = in_mesa_zona

	    ;

	END $$;


ALTER FUNCTION public.swich_consolidados_totales(in_mesa_tipo character varying, in_mesa_zona bigint) OWNER TO postgres;

--
-- Name: swich_editar(bigint, bigint, bigint, bigint, bigint, bigint, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

		UPDATE

			swich

		SET

			swich_mesas = in_swich_mesas,

			swich_modo = in_swich_modo,

			swich_mesa_1 = in_swich_mesa_1,

			swich_mesa_2 = in_swich_mesa_2,

			swich_mesa_3 = in_swich_mesa_3,

			swich_mesa_4 = in_swich_mesa_4,

			swich_votos = in_swich_votos,

			swich_cambio = now()

		WHERE

			swich_id = in_swich_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) OWNER TO postgres;

--
-- Name: swich_mesas(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.mesa_tipo,

			mesa.mesa_zona,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero

	    FROM

	        mesa

		WHERE

			mesa.mesa_id IN ( in_mesa_1 , in_mesa_2 , in_mesa_3 )

	    LIMIT 3

	    ;

	END $$;


ALTER FUNCTION public.swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) OWNER TO app_vav;

--
-- Name: swich_mesas_total(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas_total() RETURNS TABLE(voto_total smallint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_independiente boolean, partido_codigo character varying, partido_id bigint, pacto_codigo character varying, pacto_id bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

            sum(voto.voto_total) as votos_total,

            candidato.candidato_id,

            candidato.candidato_nombres,

            candidato.candidato_apellidos,

            candidato.candidato_independiente,

            partido.partido_codigo,

            partido.partido_id,

            pacto.pacto_codigo,

            pacto.pacto_id

        from

            mesa,

            voto,

            candidato,

            partido,

            pacto

        WHERE

            mesa.mesa_tipo = 'P' AND

            mesa.mesa_zona = 3013 AND

            mesa.mesa_estado = 1 AND

            voto.mesa_id = mesa.mesa_id AND

            candidato.candidato_id = voto.candidato_id AND

            partido.partido_id = candidato.partido_id AND

            pacto.pacto_id = candidato.pacto_id

        group by

            candidato.candidato_id,

            candidato.candidato_apellidos,

            partido.partido_codigo,

            partido.partido_id,

            pacto.pacto_codigo,

            pacto.pacto_id

        ORDER BY

            votos_total DESC;

	END $$;


ALTER FUNCTION public.swich_mesas_total() OWNER TO app_vav;

--
-- Name: swich_mesas_total_actuales(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas_total_actuales() RETURNS TABLE(mesa bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		select t0.mesa_id AS mesa from (

		select t1.mesa_id, row_number() over (ORDER BY t1.mesa_id) as rownum

		from mesa t1 

		where t1.mesa_tipo = 'P' 

		and t1.mesa_estado = 1 

		order by t1.mesa_id ) as t0

		where t0.rownum <= 20;

	END $$;


ALTER FUNCTION public.swich_mesas_total_actuales() OWNER TO app_vav;

--
-- Name: swich_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_obtener_datos(in_swich_id bigint) RETURNS TABLE(swich_mesas smallint, swich_modo smallint, swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint, swich_mesa_4 smallint, swich_votos character varying, swich_cambio timestamp without time zone)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        swich.swich_mesas,

			swich.swich_modo,

	        swich.swich_mesa_1,

	        swich.swich_mesa_2,

	        swich.swich_mesa_3,

	        swich.swich_mesa_4,

			swich.swich_votos,

			swich.swich_cambio

	    FROM

	        swich

		WHERE

			swich.swich_id = in_swich_id

		LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.swich_obtener_datos(in_swich_id bigint) OWNER TO postgres;

--
-- Name: swich_quad_actual(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_quad_actual() RETURNS TABLE(swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint, swich_mesa_4 smallint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    swich.swich_mesa_1,

		    swich.swich_mesa_2,

		    swich.swich_mesa_3,

			swich.swich_mesa_4

	    FROM

	        swich

		WHERE

			swich.swich_id = 2

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.swich_quad_actual() OWNER TO postgres;

--
-- Name: swich_quad_mesas(bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_quad_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint, in_mesa_4 bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.mesa_tipo,

			mesa.mesa_zona,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero

	    FROM

	        mesa

		WHERE

			mesa.mesa_id IN ( in_mesa_1 , in_mesa_2 , in_mesa_3 , in_mesa_4 )

	    LIMIT 4

	    ;

	END $$;


ALTER FUNCTION public.swich_quad_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint, in_mesa_4 bigint) OWNER TO postgres;

--
-- Name: usuario_contar_total(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION usuario_contar_total() RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(usuario_id) AS objetos 

		FROM

			usuario

	    ;

	END $$;


ALTER FUNCTION public.usuario_contar_total() OWNER TO app_vav;

--
-- Name: usuario_editar(bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_orden int;

			v_imagenes bigint;

			v_imagenes_array varchar[];

		BEGIN

	--	Comienzo del Orden

		v_orden = 0;

	--	Separar los ID de las Imagenes

        SELECT string_to_array(in_imagenes, ',') INTO v_imagenes_array;

	--	Actualizar Posicion de las imagenes

        FOREACH v_imagenes IN ARRAY v_imagenes_array LOOP

	        UPDATE

	        	imagen

	        SET

	        	imagen_orden = v_orden

	        WHERE

	        	imagen_id = v_imagenes AND

	        	imagen_objeto = in_usuario_id

	        ;

			v_orden = v_orden + 1;

        END LOOP;

	--	Editar Usuario

		UPDATE

			usuario

		SET

			usuario_rol = in_usuario_rol,

			usuario_nombre = in_usuario_nombre,

			usuario_email = in_usuario_email,

			usuario_genero = in_usuario_genero,

			usuario_etiqueta = in_usuario_etiqueta

		WHERE

			usuario_id = in_usuario_id

		;

	--	Validar Cambio de Password

		CASE 

		--	Sin Cambio de Password

			WHEN in_usuario_password = 'NULL' THEN

		--	Cambio de Password

			ELSE

				UPDATE

					usuario

				SET

					usuario_password = in_usuario_password

				WHERE

					usuario_id = in_usuario_id

				;

		END CASE;

		RETURN 1;

	END $$;


ALTER FUNCTION public.usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) OWNER TO postgres;

--
-- Name: usuario_eliminar(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

        	imagen.imagen_id,

        	imagen.imagen_objeto,

        	imagen.imagen_tipo,

        	imagen.imagen_extension

	    FROM

	        imagen

	    WHERE

	        imagen.imagen_objeto = in_usuario_id AND

	        imagen.imagen_tipo = in_imagen_tipo

	    ;

	--	Eliminar Imagenes

        DELETE FROM

        	imagen

        WHERE

	        imagen.imagen_objeto = in_usuario_id AND

	        imagen.imagen_tipo = in_imagen_tipo

        ;

	--	Eliminar Usuario

        DELETE FROM

        	usuario

        WHERE

	        usuario.usuario_id = in_usuario_id

        ;

	END $$;


ALTER FUNCTION public.usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) OWNER TO postgres;

--
-- Name: usuario_iniciar_sesion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_usuario bigint;

		BEGIN

	--	VALIDAR CREDENCIALES

		SELECT usuario_id FROM usuario WHERE usuario_email = in_usuario_email AND usuario_password = in_usuario_password INTO v_usuario;

	--	RESPUESTA DE LA QUERY

		IF v_usuario <1 THEN

	        RETURN 0;

	    ELSE

			RETURN v_usuario;

        END IF;

	END $$;


ALTER FUNCTION public.usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) OWNER TO postgres;

--
-- Name: usuario_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_listado(in_limit integer, in_offset integer) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_nombre character varying, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        usuario.usuario_id,

	        usuario.usuario_rol,

	        usuario.usuario_estado,

	        usuario.usuario_nombre,

	        usuario.usuario_login,

	        usuario.usuario_creado,

			(

				SELECT

					CONCAT( usuario.usuario_id , '|' , imagen.imagen_id , '|' , imagen.imagen_extension ) AS usuario_poster

				FROM

					imagen

				WHERE

					imagen_objeto = usuario.usuario_id AND

					imagen_tipo = 'USU'

				ORDER BY imagen.imagen_orden ASC

				LIMIT 1

			)

	    FROM

	        usuario

	    ORDER BY

	        usuario.usuario_id DESC,

	        usuario.usuario_nombre ASC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.usuario_listado(in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: usuario_listado_movil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_listado_movil() RETURNS TABLE(usuario_id bigint, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_password character varying, usuario_etiqueta bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        usuario.usuario_id,

			usuario.usuario_estado,

			usuario.usuario_genero,

	        usuario.usuario_nombre,

	        usuario.usuario_password,

	        usuario.usuario_etiqueta

	    FROM

	        usuario

	    ORDER BY

	        usuario.usuario_id DESC,

	        usuario.usuario_nombre ASC

		;

	END $$;


ALTER FUNCTION public.usuario_listado_movil() OWNER TO postgres;

--
-- Name: usuario_nuevo(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION usuario_nuevo() RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_id bigint;

		BEGIN

        SELECT nextval('usuario_id_seq') INTO v_id;

        INSERT INTO usuario

        (

        	usuario_id

        )

		VALUES

		(

			v_id

		);

        RETURN v_id;

	END $$;


ALTER FUNCTION public.usuario_nuevo() OWNER TO app_vav;

--
-- Name: usuario_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_obtener_datos(in_usuario_id bigint) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_email character varying, usuario_etiqueta bigint, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        usuario.usuario_id,

	        usuario.usuario_rol,

	        usuario.usuario_estado,

	        usuario.usuario_genero,

	        usuario.usuario_nombre,

	        usuario.usuario_email,

	        usuario.usuario_etiqueta,

	        usuario.usuario_login,

	        usuario.usuario_creado,

			(

				SELECT

					CONCAT( usuario.usuario_id , '|' , imagen.imagen_id , '|' , imagen.imagen_extension ) AS usuario_poster

				FROM

					imagen

				WHERE

					imagen_objeto = usuario.usuario_id AND

					imagen_tipo = 'USU'

				ORDER BY imagen.imagen_orden ASC

				LIMIT 1

			)

	    FROM

	        usuario

	    WHERE

	        usuario.usuario_id = in_usuario_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.usuario_obtener_datos(in_usuario_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: candidato; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE candidato (
    candidato_id bigint NOT NULL,
    candidato_tipo character varying(3) DEFAULT 'ALC'::character varying,
    candidato_orden smallint DEFAULT 1 NOT NULL,
    candidato_zona bigint DEFAULT 0 NOT NULL,
    pacto_id bigint DEFAULT 1 NOT NULL,
    partido_id bigint DEFAULT 1 NOT NULL,
    candidato_nombre character varying(128),
    candidato_nombre_corto character varying(128),
    candidato_genero character varying(1) DEFAULT 'n'::character varying,
    candidato_independiente boolean DEFAULT false,
    candidato_lista character varying(12),
    candidato_nombres character varying(64),
    candidato_apellidos character varying(64)
);


ALTER TABLE public.candidato OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE candidato_candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE candidato_candidato_id_seq OWNED BY candidato.candidato_id;


--
-- Name: candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE candidato_id_seq OWNED BY candidato.candidato_id;


--
-- Name: comuna; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE comuna (
    comuna_id bigint NOT NULL,
    region_id bigint DEFAULT 1 NOT NULL,
    distrito_id smallint NOT NULL,
    comuna_nombre character varying(64)
);


ALTER TABLE public.comuna OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE comuna_comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE comuna_comuna_id_seq OWNED BY comuna.comuna_id;


--
-- Name: comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE comuna_id_seq OWNED BY comuna.comuna_id;


--
-- Name: imagen; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE imagen (
    imagen_id bigint NOT NULL,
    imagen_orden bigint NOT NULL,
    imagen_objeto bigint NOT NULL,
    imagen_tipo character varying(3) NOT NULL,
    imagen_estado smallint DEFAULT 1,
    imagen_titulo character varying(32),
    imagen_bajada character varying(64),
    imagen_tags character varying(128),
    imagen_extension character varying(4) NOT NULL,
    imagen_cambio bigint,
    imagen_creado timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT imagen_imagen_extension_check CHECK (((imagen_extension)::text = ANY (ARRAY[('.jpg'::character varying)::text, ('.gif'::character varying)::text, ('.png'::character varying)::text]))),
    CONSTRAINT imagen_imagen_tipo_check CHECK (((imagen_tipo)::text = 'USU'::text))
);


ALTER TABLE public.imagen OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE imagen_id_seq OWNED BY imagen.imagen_id;


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE imagen_imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE imagen_imagen_id_seq OWNED BY imagen.imagen_id;


--
-- Name: mesa; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE mesa (
    mesa_id bigint NOT NULL,
    usuario_id bigint DEFAULT 1 NOT NULL,
    mesa_tipo character varying(3) DEFAULT 'ALC'::character varying,
    mesa_zona bigint DEFAULT 0 NOT NULL,
    mesa_zona_titulo character varying(64),
    mesa_comuna character varying(64),
    mesa_local character varying(64),
    mesa_numero character varying(64) DEFAULT 'MESA  '::character varying,
    mesa_orden smallint DEFAULT 1 NOT NULL,
    mesa_estado smallint DEFAULT 0 NOT NULL,
    mesa_destacada smallint DEFAULT 0 NOT NULL,
    mesa_votos_blancos smallint DEFAULT 0 NOT NULL,
    mesa_votos_nulos smallint DEFAULT 0 NOT NULL,
    mesa_cambio timestamp without time zone DEFAULT now() NOT NULL,
    mesa_creado timestamp without time zone DEFAULT now() NOT NULL,
    mesa_publicado character varying(64)
);


ALTER TABLE public.mesa OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE mesa_id_seq OWNED BY mesa.mesa_id;


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE mesa_mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE mesa_mesa_id_seq OWNED BY mesa.mesa_id;


--
-- Name: pacto; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE pacto (
    pacto_id bigint NOT NULL,
    pacto_codigo character varying(24),
    pacto_nombre character varying(64)
);


ALTER TABLE public.pacto OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE pacto_id_seq OWNED BY pacto.pacto_id;


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE pacto_pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE pacto_pacto_id_seq OWNED BY pacto.pacto_id;


--
-- Name: partido; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE partido (
    partido_id bigint NOT NULL,
    partido_nombre character varying(64),
    partido_codigo character varying(16)
);


ALTER TABLE public.partido OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_id_seq OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE partido_id_seq OWNED BY partido.partido_id;


--
-- Name: partido_partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE partido_partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_partido_id_seq OWNER TO app_vav;

--
-- Name: partido_partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE partido_partido_id_seq OWNED BY partido.partido_id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE region (
    region_id bigint NOT NULL,
    region_nombre character varying(32),
    region_codigo character varying(5)
);


ALTER TABLE public.region OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE region_id_seq OWNED BY region.region_id;


--
-- Name: region_region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE region_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_region_id_seq OWNER TO app_vav;

--
-- Name: region_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE region_region_id_seq OWNED BY region.region_id;


--
-- Name: swich; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE swich (
    swich_id bigint NOT NULL,
    swich_mesas smallint DEFAULT 0,
    swich_mesa_1 smallint DEFAULT 0,
    swich_mesa_2 smallint DEFAULT 0,
    swich_mesa_3 smallint DEFAULT 0,
    swich_mesa_4 smallint DEFAULT 0,
    swich_votos character varying(1) DEFAULT 'p'::character varying,
    swich_cambio timestamp without time zone DEFAULT now() NOT NULL,
    swich_modo smallint
);


ALTER TABLE public.swich OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_id_seq OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE swich_id_seq OWNED BY swich.swich_id;


--
-- Name: swich_swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE swich_swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_swich_id_seq OWNER TO app_vav;

--
-- Name: swich_swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE swich_swich_id_seq OWNED BY swich.swich_id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE usuario (
    usuario_id bigint NOT NULL,
    usuario_rol character varying(2) DEFAULT 'OP'::character varying,
    usuario_estado smallint DEFAULT 1,
    usuario_genero character varying(1) DEFAULT 'n'::character varying,
    usuario_nombre character varying(32),
    usuario_email character varying(64),
    usuario_password character varying(32),
    usuario_etiqueta bigint DEFAULT 1,
    usuario_login timestamp without time zone DEFAULT now(),
    usuario_creado timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT usuario_usuario_genero_check CHECK (((usuario_genero)::text = ANY (ARRAY[('n'::character varying)::text, ('f'::character varying)::text, ('m'::character varying)::text]))),
    CONSTRAINT usuario_usuario_rol_check CHECK (((usuario_rol)::text = ANY (ARRAY[('AD'::character varying)::text, ('AM'::character varying)::text, ('OP'::character varying)::text, ('VZ'::character varying)::text])))
);


ALTER TABLE public.usuario OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE usuario_id_seq OWNED BY usuario.usuario_id;


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE usuario_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE usuario_usuario_id_seq OWNED BY usuario.usuario_id;


--
-- Name: voto; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE voto (
    voto_id bigint NOT NULL,
    candidato_id bigint DEFAULT 1 NOT NULL,
    mesa_id bigint DEFAULT 1 NOT NULL,
    voto_total smallint NOT NULL
);


ALTER TABLE public.voto OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_id_seq OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE voto_id_seq OWNED BY voto.voto_id;


--
-- Name: voto_voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE voto_voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_voto_id_seq OWNER TO app_vav;

--
-- Name: voto_voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE voto_voto_id_seq OWNED BY voto.voto_id;


--
-- Name: candidato_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato ALTER COLUMN candidato_id SET DEFAULT nextval('candidato_id_seq'::regclass);


--
-- Name: comuna_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY comuna ALTER COLUMN comuna_id SET DEFAULT nextval('comuna_id_seq'::regclass);


--
-- Name: imagen_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY imagen ALTER COLUMN imagen_id SET DEFAULT nextval('imagen_id_seq'::regclass);


--
-- Name: mesa_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa ALTER COLUMN mesa_id SET DEFAULT nextval('mesa_id_seq'::regclass);


--
-- Name: pacto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY pacto ALTER COLUMN pacto_id SET DEFAULT nextval('pacto_id_seq'::regclass);


--
-- Name: partido_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY partido ALTER COLUMN partido_id SET DEFAULT nextval('partido_id_seq'::regclass);


--
-- Name: region_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY region ALTER COLUMN region_id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: swich_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY swich ALTER COLUMN swich_id SET DEFAULT nextval('swich_id_seq'::regclass);


--
-- Name: usuario_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY usuario ALTER COLUMN usuario_id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- Name: voto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto ALTER COLUMN voto_id SET DEFAULT nextval('voto_id_seq'::regclass);


--
-- Data for Name: candidato; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO candidato VALUES (55001011, 'S', 11, 5001, 486, 130, 'MAURICIO PAREDES ESCANILLA', 'MAURICIO PAREDES ESCANILLA', '', false, 'None', 'MAURICIO', 'PAREDES ESCANILLA');
INSERT INTO candidato VALUES (55001012, 'S', 12, 5001, 482, 5, 'CINTHIA VARGAS MORALES', 'CINTHIA VARGAS MORALES', '', true, 'None', 'CINTHIA', 'VARGAS MORALES');
INSERT INTO candidato VALUES (55001013, 'S', 13, 5001, 482, 137, 'VLADO MIROSEVIC VERDUGO', 'VLADO MIROSEVIC VERDUGO', '', false, 'None', 'VLADO', 'MIROSEVIC VERDUGO');
INSERT INTO candidato VALUES (55001014, 'S', 14, 5001, 482, 6, 'CARMEN HERTZ CADIZ', 'CARMEN HERTZ CADIZ', '', false, 'None', 'CARMEN', 'HERTZ CADIZ');
INSERT INTO candidato VALUES (55001015, 'S', 15, 5001, 480, 188, 'CLAUDIO VICENTE OJEDA MURILLO', 'CLAUDIO VICENTE OJEDA MURILLO', '', false, 'None', 'CLAUDIO VICENTE', 'OJEDA MURILLO');
INSERT INTO candidato VALUES (55001016, 'S', 16, 5001, 480, 188, 'ANDREA ROSITA CHELLEW STAMBUK', 'ANDREA ROSITA CHELLEW STAMBUK', '', false, 'None', 'ANDREA ROSITA', 'CHELLEW STAMBUK');
INSERT INTO candidato VALUES (55001017, 'S', 17, 5001, 494, 203, 'FERNANDO ALEX FERNANDEZ BARRAZA', 'FERNANDO ALEX FERNANDEZ BARRAZA', '', false, 'None', 'FERNANDO ALEX', 'FERNANDEZ BARRAZA');
INSERT INTO candidato VALUES (55001018, 'S', 18, 5001, 488, 157, 'FRIEDRICH RENARD MENCIA POCONI', 'FRIEDRICH RENARD MENCIA POCONI', '', false, 'None', 'FRIEDRICH RENARD', 'MENCIA POCONI');
INSERT INTO candidato VALUES (55001019, 'S', 19, 5001, 484, 3, 'JOSE PILO DURANA SEMIR', 'JOSE PILO DURANA SEMIR', '', false, 'None', 'JOSE PILO', 'DURANA SEMIR');
INSERT INTO candidato VALUES (55001020, 'S', 20, 5001, 484, 198, 'ENRIQUE LEE FLORES', 'ENRIQUE LEE FLORES', '', true, 'None', 'ENRIQUE', 'LEE FLORES');
INSERT INTO candidato VALUES (55001021, 'S', 21, 5001, 484, 1, 'SANDRA ZAPATA VELASQUEZ', 'SANDRA ZAPATA VELASQUEZ', '', true, 'None', 'SANDRA', 'ZAPATA VELASQUEZ');
INSERT INTO candidato VALUES (55001022, 'S', 22, 5001, 478, 235, 'IRENE MAMANI LOVERA', 'IRENE MAMANI LOVERA', '', false, 'None', 'IRENE', 'MAMANI LOVERA');
INSERT INTO candidato VALUES (55002011, 'S', 11, 5002, 486, 190, 'PAOLA ALZAMORA AGUIRRE', 'PAOLA ALZAMORA AGUIRRE', '', false, 'None', 'PAOLA', 'ALZAMORA AGUIRRE');
INSERT INTO candidato VALUES (55002012, 'S', 12, 5002, 482, 5, 'DANISA ASTUDILLO PEIRETTI', 'DANISA ASTUDILLO PEIRETTI', '', false, 'None', 'DANISA', 'ASTUDILLO PEIRETTI');
INSERT INTO candidato VALUES (55002013, 'S', 13, 5002, 482, 4, 'GONZALO PRIETO NAVARRETE', 'GONZALO PRIETO NAVARRETE', '', false, 'None', 'GONZALO', 'PRIETO NAVARRETE');
INSERT INTO candidato VALUES (55002014, 'S', 14, 5002, 482, 6, 'HUGO GUTIERREZ GALVEZ', 'HUGO GUTIERREZ GALVEZ', '', false, 'None', 'HUGO', 'GUTIERREZ GALVEZ');
INSERT INTO candidato VALUES (55002015, 'S', 15, 5002, 480, 188, 'JUAN CARLOS HUERTA MORAGA', 'JUAN CARLOS HUERTA MORAGA', '', false, 'None', 'JUAN CARLOS', 'HUERTA MORAGA');
INSERT INTO candidato VALUES (55002016, 'S', 16, 5002, 488, 157, 'MARTA CORTES ZAPATA', 'MARTA CORTES ZAPATA', '', false, 'None', 'MARTA', 'CORTES ZAPATA');
INSERT INTO candidato VALUES (55002017, 'S', 17, 5002, 488, 157, 'JOSE LUIS PAREDES CORTES', 'JOSE LUIS PAREDES CORTES', '', false, 'None', 'JOSE LUIS', 'PAREDES CORTES');
INSERT INTO candidato VALUES (55002018, 'S', 18, 5002, 484, 3, 'LUZ EBENSPERGER ORREGO', 'LUZ EBENSPERGER ORREGO', '', false, 'None', 'LUZ', 'EBENSPERGER ORREGO');
INSERT INTO candidato VALUES (55002019, 'S', 19, 5002, 484, 1, 'LUCRECIA MENA ACOSTA', 'LUCRECIA MENA ACOSTA', '', false, 'None', 'LUCRECIA', 'MENA ACOSTA');
INSERT INTO candidato VALUES (55002020, 'S', 20, 5002, 484, 198, 'JORGE ZAVALA VALENZUELA', 'JORGE ZAVALA VALENZUELA', '', false, 'None', 'JORGE', 'ZAVALA VALENZUELA');
INSERT INTO candidato VALUES (55002021, 'S', 21, 5002, 478, 150, 'RENZO TRISOTTI MARTINEZ', 'RENZO TRISOTTI MARTINEZ', '', false, 'None', 'RENZO', 'TRISOTTI MARTINEZ');
INSERT INTO candidato VALUES (55002022, 'S', 22, 5002, 478, 150, 'KAREN HEYNE BOLADOS', 'KAREN HEYNE BOLADOS', '', false, 'None', 'KAREN', 'HEYNE BOLADOS');
INSERT INTO candidato VALUES (55002023, 'S', 23, 5002, 478, 197, 'SOLANGE JIMENEZ DINAMARCA', 'SOLANGE JIMENEZ DINAMARCA', '', false, 'None', 'SOLANGE', 'JIMENEZ DINAMARCA');
INSERT INTO candidato VALUES (55004011, 'S', 11, 5004, 482, 2, 'YASNA PROVOSTE CAMPILLAY', 'YASNA PROVOSTE CAMPILLAY', '', false, 'None', 'YASNA', 'PROVOSTE CAMPILLAY');
INSERT INTO candidato VALUES (55004012, 'S', 12, 5004, 482, 5, 'DANIELLA CICARDINI MILLA', 'DANIELLA CICARDINI MILLA', '', false, 'None', 'DANIELLA', 'CICARDINI MILLA');
INSERT INTO candidato VALUES (55004013, 'S', 13, 5004, 480, 201, 'ARTURO FERNANDEZ DIAZ', 'ARTURO FERNANDEZ DIAZ', '', true, 'None', 'ARTURO', 'FERNANDEZ DIAZ');
INSERT INTO candidato VALUES (55004014, 'S', 14, 5004, 480, 201, 'MARINA CACERES CARVAJAL', 'MARINA CACERES CARVAJAL', '', false, 'None', 'MARINA', 'CACERES CARVAJAL');
INSERT INTO candidato VALUES (55004015, 'S', 15, 5004, 488, 157, 'SEBASTIAN VICENTE CARMONA ORQUERA', 'SEBASTIAN VICENTE CARMONA ORQUERA', '', false, 'None', 'SEBASTIAN VICENTE', 'CARMONA ORQUERA');
INSERT INTO candidato VALUES (55004016, 'S', 16, 5004, 484, 1, 'RAFAEL PROHENS ESPINOSA', 'RAFAEL PROHENS ESPINOSA', '', false, 'None', 'RAFAEL', 'PROHENS ESPINOSA');
INSERT INTO candidato VALUES (55004017, 'S', 17, 5004, 484, 37, 'GIOVANNI CALDERON BASSI', 'GIOVANNI CALDERON BASSI', '', true, 'None', 'GIOVANNI', 'CALDERON BASSI');
INSERT INTO candidato VALUES (55004018, 'S', 18, 5004, 484, 3, 'NICOLAS NOMAN GARRIDO', 'NICOLAS NOMAN GARRIDO', '', false, 'None', 'NICOLAS', 'NOMAN GARRIDO');
INSERT INTO candidato VALUES (55004019, 'S', 19, 5004, 478, 150, 'SOFIA CID VERSALOVIC', 'SOFIA CID VERSALOVIC', '', false, 'None', 'SOFIA', 'CID VERSALOVIC');
INSERT INTO candidato VALUES (55004020, 'S', 20, 5004, 478, 150, 'ULISES CARABANTES AHUMADA', 'ULISES CARABANTES AHUMADA', '', false, 'None', 'ULISES', 'CARABANTES AHUMADA');
INSERT INTO candidato VALUES (55004021, 'S', 21, 5004, 478, 197, 'MILKA DEL CANTO URRELO', 'MILKA DEL CANTO URRELO', '', true, 'None', 'MILKA', 'DEL CANTO URRELO');
INSERT INTO candidato VALUES (55006011, 'S', 11, 5006, 486, 190, 'MANUEL WOLDARSKY GONZALEZ', 'MANUEL WOLDARSKY GONZALEZ', '', false, 'None', 'MANUEL', 'WOLDARSKY GONZALEZ');
INSERT INTO candidato VALUES (55006012, 'S', 12, 5006, 486, 190, 'ANDREA ARAYA TORO', 'ANDREA ARAYA TORO', '', false, 'None', 'ANDREA', 'ARAYA TORO');
INSERT INTO candidato VALUES (55006013, 'S', 13, 5006, 486, 130, 'GERMAN CORREA DIAZ', 'GERMAN CORREA DIAZ', '', true, 'None', 'GERMAN', 'CORREA DIAZ');
INSERT INTO candidato VALUES (55006014, 'S', 14, 5006, 486, 130, 'YESSICA FLANDEZ FLANDEZ', 'YESSICA FLANDEZ FLANDEZ', '', false, 'None', 'YESSICA', 'FLANDEZ FLANDEZ');
INSERT INTO candidato VALUES (55006015, 'S', 15, 5006, 482, 6, 'KAROL CARIOLA OLIVA', 'KAROL CARIOLA OLIVA', '', false, 'None', 'KAROL', 'CARIOLA OLIVA');
INSERT INTO candidato VALUES (55006016, 'S', 16, 5006, 482, 4, 'CAROLINA MARZAN PINTO', 'CAROLINA MARZAN PINTO', '', false, 'None', 'CAROLINA', 'MARZAN PINTO');
INSERT INTO candidato VALUES (55006017, 'S', 17, 5006, 482, 232, 'DIEGO IBAÑEZ COTRONEO', 'DIEGO IBAÑEZ COTRONEO', '', false, 'None', 'DIEGO', 'IBAÑEZ COTRONEO');
INSERT INTO candidato VALUES (55006018, 'S', 18, 5006, 482, 137, 'MONICA ALICIA VALENCIA BECERRA', 'MONICA ALICIA VALENCIA BECERRA', '', true, 'None', 'MONICA ALICIA', 'VALENCIA BECERRA');
INSERT INTO candidato VALUES (55006019, 'S', 19, 5006, 482, 7, 'JAZMIN AGUILAR ORTIZ', 'JAZMIN AGUILAR ORTIZ', '', false, 'None', 'JAZMIN', 'AGUILAR ORTIZ');
INSERT INTO candidato VALUES (41900105, 'P', 5, 19001, 999, 150, 'JOSE ANTONIO KAST RIST', 'JOSE ANTONIO KAST RIST', '', false, 'None', 'JOSE ANTONIO', 'KAST');
INSERT INTO candidato VALUES (41900103, 'P', 3, 19001, 999, 99, 'MARCO ANTONIO ENRIQUEZ-OMINAMI GUMUCIO', 'MARCO ANTONIO ENRIQUEZ-OMINAMI GUMUCIO', '', true, 'None', 'MARCO', 'ME-o');
INSERT INTO candidato VALUES (41900107, 'P', 7, 19001, 999, 3, 'EVELYN MATTHEI FORNET', 'EVELYN MATTHEI FORNET', '', false, 'None', 'EVELYN', 'MATTHEI');
INSERT INTO candidato VALUES (41900108, 'P', 8, 19001, 999, 99, 'HAROLD MAYNE-NICHOLLS SECUL', 'HAROLD MAYNE-NICHOLLS SECUL', '', true, 'None', 'HAROLD', 'MAYNE-N');
INSERT INTO candidato VALUES (41900104, 'P', 4, 19001, 999, 235, 'JOHANNES KAISER BARENTS-VON HOHENHAGEN', 'JOHANNES KAISER BARENTS-VON HOHENHAGEN', '', false, 'None', 'JOHANNES', 'KAISER');
INSERT INTO candidato VALUES (41900102, 'P', 2, 19001, 999, 6, 'JEANNETTE JARA ROMAN', 'JEANNETTE JARA ROMAN', '', false, 'None', 'JEANNETTE', 'JARA');
INSERT INTO candidato VALUES (41900106, 'P', 6, 19001, 999, 99, 'EDUARDO ANTONIO ARTES BRICHETTI', 'EDUARDO ANTONIO ARTES BRICHETTI', '', true, 'None', 'EDUARDO', 'ARTES');
INSERT INTO candidato VALUES (55006020, 'S', 20, 5006, 482, 5, 'JOSE MIGUEL INSULZA SALINAS', 'JOSE MIGUEL INSULZA SALINAS', '', false, 'None', 'JOSE MIGUEL', 'INSULZA SALINAS');
INSERT INTO candidato VALUES (55006021, 'S', 21, 5006, 488, 157, 'MARCELA PATRICIA DEL SOL HALLETT', 'MARCELA PATRICIA DEL SOL HALLETT', '', false, 'None', 'MARCELA PATRICIA', 'DEL SOL HALLETT');
INSERT INTO candidato VALUES (55006022, 'S', 22, 5006, 488, 157, 'CLAUDIO ABRAHAM URIBE HERNANDEZ', 'CLAUDIO ABRAHAM URIBE HERNANDEZ', '', false, 'None', 'CLAUDIO ABRAHAM', 'URIBE HERNANDEZ');
INSERT INTO candidato VALUES (55006023, 'S', 23, 5006, 488, 157, 'ELIAS CANELO PEREZ', 'ELIAS CANELO PEREZ', '', false, 'None', 'ELIAS', 'CANELO PEREZ');
INSERT INTO candidato VALUES (55006024, 'S', 24, 5006, 488, 157, 'DIEGO ALONSO CORTEZ BARRERA', 'DIEGO ALONSO CORTEZ BARRERA', '', false, 'None', 'DIEGO ALONSO', 'CORTEZ BARRERA');
INSERT INTO candidato VALUES (55006025, 'S', 25, 5006, 484, 1, 'ANDRES LONGTON HERRERA', 'ANDRES LONGTON HERRERA', '', false, 'None', 'ANDRES', 'LONGTON HERRERA');
INSERT INTO candidato VALUES (55006026, 'S', 26, 5006, 484, 1, 'CAMILA FLORES OPORTO', 'CAMILA FLORES OPORTO', '', false, 'None', 'CAMILA', 'FLORES OPORTO');
INSERT INTO candidato VALUES (55006027, 'S', 27, 5006, 484, 198, 'DANIEL VERDESSI BELEMMI', 'DANIEL VERDESSI BELEMMI', '', false, 'None', 'DANIEL', 'VERDESSI BELEMMI');
INSERT INTO candidato VALUES (55006028, 'S', 28, 5006, 484, 198, 'MONSERRAT ALESSANDRI SPENCER', 'MONSERRAT ALESSANDRI SPENCER', '', false, 'None', 'MONSERRAT', 'ALESSANDRI SPENCER');
INSERT INTO candidato VALUES (55006029, 'S', 29, 5006, 484, 3, 'MARIA PAZ SANTELICES CAÑAS', 'MARIA PAZ SANTELICES CAÑAS', '', true, 'None', 'MARIA PAZ', 'SANTELICES CAÑAS');
INSERT INTO candidato VALUES (55006030, 'S', 30, 5006, 484, 3, 'MARIA JOSE HOFFMANN OPAZO', 'MARIA JOSE HOFFMANN OPAZO', '', false, 'None', 'MARIA JOSE', 'HOFFMANN OPAZO');
INSERT INTO candidato VALUES (55006031, 'S', 31, 5006, 478, 150, 'ARTURO SQUELLA OVALLE', 'ARTURO SQUELLA OVALLE', '', false, 'None', 'ARTURO', 'SQUELLA OVALLE');
INSERT INTO candidato VALUES (55006032, 'S', 32, 5006, 478, 150, 'ALBERTO SOTO VALENZUELA', 'ALBERTO SOTO VALENZUELA', '', true, 'None', 'ALBERTO', 'SOTO VALENZUELA');
INSERT INTO candidato VALUES (55006033, 'S', 33, 5006, 478, 150, 'SOLEDAD LOYOLA VERA', 'SOLEDAD LOYOLA VERA', '', false, 'None', 'SOLEDAD', 'LOYOLA VERA');
INSERT INTO candidato VALUES (55006034, 'S', 34, 5006, 478, 235, 'JULIO MARTINEZ COLINA', 'JULIO MARTINEZ COLINA', '', false, 'None', 'JULIO', 'MARTINEZ COLINA');
INSERT INTO candidato VALUES (55006035, 'S', 35, 5006, 478, 235, 'VERONICA VEGA ORELLANA', 'VERONICA VEGA ORELLANA', '', false, 'None', 'VERONICA', 'VEGA ORELLANA');
INSERT INTO candidato VALUES (55006036, 'S', 36, 5006, 478, 197, 'ESTEBAN BARAHONA CONTRERAS', 'ESTEBAN BARAHONA CONTRERAS', '', false, 'None', 'ESTEBAN', 'BARAHONA CONTRERAS');
INSERT INTO candidato VALUES (55009011, 'S', 11, 5009, 486, 190, 'FELIPE DURAN MARTINEZ', 'FELIPE DURAN MARTINEZ', '', false, 'None', 'FELIPE', 'DURAN MARTINEZ');
INSERT INTO candidato VALUES (55009012, 'S', 12, 5009, 486, 190, 'TOMAS BIZE BRINTRUP', 'TOMAS BIZE BRINTRUP', '', false, 'None', 'TOMAS', 'BIZE BRINTRUP');
INSERT INTO candidato VALUES (55009013, 'S', 13, 5009, 486, 130, 'ALEJANDRA MOLINA TOBAR', 'ALEJANDRA MOLINA TOBAR', '', false, 'None', 'ALEJANDRA', 'MOLINA TOBAR');
INSERT INTO candidato VALUES (55009014, 'S', 14, 5009, 486, 130, 'JAIME NARANJO ORTIZ', 'JAIME NARANJO ORTIZ', '', true, 'None', 'JAIME', 'NARANJO ORTIZ');
INSERT INTO candidato VALUES (55009015, 'S', 15, 5009, 486, 130, 'CARLA FERNANDEZ RIFFO', 'CARLA FERNANDEZ RIFFO', '', true, 'None', 'CARLA', 'FERNANDEZ RIFFO');
INSERT INTO candidato VALUES (55009016, 'S', 16, 5009, 482, 5, 'PAULINA VODANOVIC ROJAS', 'PAULINA VODANOVIC ROJAS', '', false, 'None', 'PAULINA', 'VODANOVIC ROJAS');
INSERT INTO candidato VALUES (55009017, 'S', 17, 5009, 482, 6, 'SIXTO GONZALEZ SOTO', 'SIXTO GONZALEZ SOTO', '', false, 'None', 'SIXTO', 'GONZALEZ SOTO');
INSERT INTO candidato VALUES (55009018, 'S', 18, 5009, 482, 232, 'BEATRIZ SANCHEZ MUÑOZ', 'BEATRIZ SANCHEZ MUÑOZ', '', false, 'None', 'BEATRIZ', 'SANCHEZ MUÑOZ');
INSERT INTO candidato VALUES (55009019, 'S', 19, 5009, 482, 4, 'RICARDO LIZAMA SOTO', 'RICARDO LIZAMA SOTO', '', false, 'None', 'RICARDO', 'LIZAMA SOTO');
INSERT INTO candidato VALUES (55009020, 'S', 20, 5009, 482, 2, 'JUAN CARLOS FIGUEROA URRUTIA', 'JUAN CARLOS FIGUEROA URRUTIA', '', false, 'None', 'JUAN CARLOS', 'FIGUEROA URRUTIA');
INSERT INTO candidato VALUES (55009021, 'S', 21, 5009, 482, 7, 'ALEXIS SEPULVEDA SOTO', 'ALEXIS SEPULVEDA SOTO', '', false, 'None', 'ALEXIS', 'SEPULVEDA SOTO');
INSERT INTO candidato VALUES (55009022, 'S', 22, 5009, 492, 200, 'KIM NIKKI GUTIERREZ ULLOA', 'KIM NIKKI GUTIERREZ ULLOA', '', false, 'None', 'KIM NIKKI', 'GUTIERREZ ULLOA');
INSERT INTO candidato VALUES (55009023, 'S', 23, 5009, 492, 200, 'CARLOS EUGENIO RAVERA FERNANDEZ', 'CARLOS EUGENIO RAVERA FERNANDEZ', '', false, 'None', 'CARLOS EUGENIO', 'RAVERA FERNANDEZ');
INSERT INTO candidato VALUES (55009024, 'S', 24, 5009, 488, 157, 'MARIO CAMPOS ROJAS', 'MARIO CAMPOS ROJAS', '', false, 'None', 'MARIO', 'CAMPOS ROJAS');
INSERT INTO candidato VALUES (55009025, 'S', 25, 5009, 488, 157, 'CLAUDIA SOSA FLORES', 'CLAUDIA SOSA FLORES', '', false, 'None', 'CLAUDIA', 'SOSA FLORES');
INSERT INTO candidato VALUES (55009026, 'S', 26, 5009, 488, 157, 'PAULINA MIRANDA BARRIGA', 'PAULINA MIRANDA BARRIGA', '', false, 'None', 'PAULINA', 'MIRANDA BARRIGA');
INSERT INTO candidato VALUES (55009027, 'S', 27, 5009, 488, 157, 'CECILIA GONZALEZ BELLO', 'CECILIA GONZALEZ BELLO', '', false, 'None', 'CECILIA', 'GONZALEZ BELLO');
INSERT INTO candidato VALUES (55009028, 'S', 28, 5009, 488, 157, 'YENNY SOTO AVENDAÑO', 'YENNY SOTO AVENDAÑO', '', false, 'None', 'YENNY', 'SOTO AVENDAÑO');
INSERT INTO candidato VALUES (55009029, 'S', 29, 5009, 484, 198, 'IAN MAC-NIVEN CARLSSON', 'IAN MAC-NIVEN CARLSSON', '', true, 'None', 'IAN', 'MAC-NIVEN CARLSSON');
INSERT INTO candidato VALUES (55009030, 'S', 30, 5009, 484, 1, 'HUGO REY MARTINEZ', 'HUGO REY MARTINEZ', '', false, 'None', 'HUGO', 'REY MARTINEZ');
INSERT INTO candidato VALUES (55009031, 'S', 31, 5009, 484, 1, 'ANDREA BALLADARES LETELIER', 'ANDREA BALLADARES LETELIER', '', false, 'None', 'ANDREA', 'BALLADARES LETELIER');
INSERT INTO candidato VALUES (55009032, 'S', 32, 5009, 484, 3, 'PATRICIA LABRA BESSERER', 'PATRICIA LABRA BESSERER', '', true, 'None', 'PATRICIA', 'LABRA BESSERER');
INSERT INTO candidato VALUES (55009033, 'S', 33, 5009, 484, 3, 'JUAN ANTONIO COLOMA ALAMOS', 'JUAN ANTONIO COLOMA ALAMOS', '', false, 'None', 'JUAN ANTONIO', 'COLOMA ALAMOS');
INSERT INTO candidato VALUES (55009034, 'S', 34, 5009, 478, 197, 'JUAN CASTRO PRIETO', 'JUAN CASTRO PRIETO', '', false, 'None', 'JUAN', 'CASTRO PRIETO');
INSERT INTO candidato VALUES (55009035, 'S', 35, 5009, 478, 197, 'CAMILA SOTO RODRIGUEZ', 'CAMILA SOTO RODRIGUEZ', '', false, 'None', 'CAMILA', 'SOTO RODRIGUEZ');
INSERT INTO candidato VALUES (55009036, 'S', 36, 5009, 478, 197, 'FELIPE GONZALEZ LOPEZ', 'FELIPE GONZALEZ LOPEZ', '', false, 'None', 'FELIPE', 'GONZALEZ LOPEZ');
INSERT INTO candidato VALUES (55009037, 'S', 37, 5009, 478, 150, 'IGNACIO URRUTIA BONILLA', 'IGNACIO URRUTIA BONILLA', '', false, 'None', 'IGNACIO', 'URRUTIA BONILLA');
INSERT INTO candidato VALUES (55009038, 'S', 38, 5009, 478, 150, 'CRISTIAN VIAL MACERATTA', 'CRISTIAN VIAL MACERATTA', '', true, 'None', 'CRISTIAN', 'VIAL MACERATTA');
INSERT INTO candidato VALUES (55009039, 'S', 39, 5009, 478, 235, 'PABLO CATALAN RAMIREZ', 'PABLO CATALAN RAMIREZ', '', false, 'None', 'PABLO', 'CATALAN RAMIREZ');
INSERT INTO candidato VALUES (55009040, 'S', 40, 5009, 999, 99, 'JUAN FRANCISCO PULGAR CASTILLO', 'JUAN FRANCISCO PULGAR CASTILLO', '', true, 'None', 'JUAN FRANCISCO', 'PULGAR CASTILLO');
INSERT INTO candidato VALUES (55011011, 'S', 11, 5011, 498, 236, 'AUCAN HUILCAMAN PAILLAMA', 'AUCAN HUILCAMAN PAILLAMA', '', false, 'None', 'AUCAN', 'HUILCAMAN PAILLAMA');
INSERT INTO candidato VALUES (55011012, 'S', 12, 5011, 498, 236, 'JAL YJADE EVILA', 'JAL YJADE EVILA', '', false, 'None', 'JAL', 'YJADE EVILA');
INSERT INTO candidato VALUES (55011013, 'S', 13, 5011, 482, 2, 'FRANCISCO HUENCHUMILLA JARAMILLO', 'FRANCISCO HUENCHUMILLA JARAMILLO', '', false, 'None', 'FRANCISCO', 'HUENCHUMILLA JARAMILLO');
INSERT INTO candidato VALUES (55011014, 'S', 14, 5011, 482, 6, 'ELISA LONCON ANTILEO', 'ELISA LONCON ANTILEO', '', true, 'None', 'ELISA', 'LONCON ANTILEO');
INSERT INTO candidato VALUES (55011015, 'S', 15, 5011, 482, 4, 'RICARDO CELIS ARAYA', 'RICARDO CELIS ARAYA', '', true, 'None', 'RICARDO', 'CELIS ARAYA');
INSERT INTO candidato VALUES (55011016, 'S', 16, 5011, 482, 137, 'EUGENIO TUMA ZEDAN', 'EUGENIO TUMA ZEDAN', '', true, 'None', 'EUGENIO', 'TUMA ZEDAN');
INSERT INTO candidato VALUES (55011017, 'S', 17, 5011, 482, 5, 'RONALD KLIEBS YAÑEZ', 'RONALD KLIEBS YAÑEZ', '', false, 'None', 'RONALD', 'KLIEBS YAÑEZ');
INSERT INTO candidato VALUES (55011018, 'S', 18, 5011, 482, 7, 'CRISTIAN EPUIN BREVIS', 'CRISTIAN EPUIN BREVIS', '', false, 'None', 'CRISTIAN', 'EPUIN BREVIS');
INSERT INTO candidato VALUES (55011019, 'S', 19, 5011, 488, 157, 'VIVIANA MANRIQUEZ MORA', 'VIVIANA MANRIQUEZ MORA', '', false, 'None', 'VIVIANA', 'MANRIQUEZ MORA');
INSERT INTO candidato VALUES (66012067, 'D', 67, 6012, 481, 188, 'RENE  VALLE TORO', 'RENE  VALLE TORO', '', true, 'None', 'RENE ', 'VALLE TORO');
INSERT INTO candidato VALUES (55011020, 'S', 20, 5011, 488, 157, 'JUAN FRANCISCO MADARIAGA MENDEZ', 'JUAN FRANCISCO MADARIAGA MENDEZ', '', false, 'None', 'JUAN FRANCISCO', 'MADARIAGA MENDEZ');
INSERT INTO candidato VALUES (55011021, 'S', 21, 5011, 488, 157, 'PAMELA CORREA QUEZADA', 'PAMELA CORREA QUEZADA', '', false, 'None', 'PAMELA', 'CORREA QUEZADA');
INSERT INTO candidato VALUES (55011022, 'S', 22, 5011, 488, 157, 'MARISEL PEDREROS VENEGAS', 'MARISEL PEDREROS VENEGAS', '', false, 'None', 'MARISEL', 'PEDREROS VENEGAS');
INSERT INTO candidato VALUES (55011023, 'S', 23, 5011, 484, 3, 'HENRY LEAL BIZAMA', 'HENRY LEAL BIZAMA', '', false, 'None', 'HENRY', 'LEAL BIZAMA');
INSERT INTO candidato VALUES (55011024, 'S', 24, 5011, 484, 3, 'JORGE ANDRES LUCHSINGER MACKAY', 'JORGE ANDRES LUCHSINGER MACKAY', '', true, 'None', 'JORGE ANDRES', 'LUCHSINGER MACKAY');
INSERT INTO candidato VALUES (55011025, 'S', 25, 5011, 484, 198, 'CAROLA ELGUETA FERNANDEZ', 'CAROLA ELGUETA FERNANDEZ', '', true, 'None', 'CAROLA', 'ELGUETA FERNANDEZ');
INSERT INTO candidato VALUES (55011026, 'S', 26, 5011, 484, 198, 'PATRICIA LAGOS MEIER', 'PATRICIA LAGOS MEIER', '', true, 'None', 'PATRICIA', 'LAGOS MEIER');
INSERT INTO candidato VALUES (55011027, 'S', 27, 5011, 484, 1, 'JORGE RATHGEB SCHIFFERLI', 'JORGE RATHGEB SCHIFFERLI', '', false, 'None', 'JORGE', 'RATHGEB SCHIFFERLI');
INSERT INTO candidato VALUES (55011028, 'S', 28, 5011, 484, 1, 'MIGUEL BECKER ALVEAR', 'MIGUEL BECKER ALVEAR', '', false, 'None', 'MIGUEL', 'BECKER ALVEAR');
INSERT INTO candidato VALUES (55011029, 'S', 29, 5011, 478, 235, 'VANESSA KAISER BARENTS-VON HOHENHAGEN', 'VANESSA KAISER BARENTS-VON HOHENHAGEN', '', false, 'None', 'VANESSA', 'KAISER BARENTS-VON HOHENHAGEN');
INSERT INTO candidato VALUES (55011030, 'S', 30, 5011, 478, 235, 'CESAR VARGAS ZURITA', 'CESAR VARGAS ZURITA', '', false, 'None', 'CESAR', 'VARGAS ZURITA');
INSERT INTO candidato VALUES (55011031, 'S', 31, 5011, 478, 197, 'ANITA DE ARZUMENDI CIFUENTES', 'ANITA DE ARZUMENDI CIFUENTES', '', false, 'None', 'ANITA', 'DE ARZUMENDI CIFUENTES');
INSERT INTO candidato VALUES (55011032, 'S', 32, 5011, 478, 197, 'PABLO BECKER VASQUEZ', 'PABLO BECKER VASQUEZ', '', false, 'None', 'PABLO', 'BECKER VASQUEZ');
INSERT INTO candidato VALUES (55011033, 'S', 33, 5011, 478, 150, 'RUTH HURTADO OLAVE', 'RUTH HURTADO OLAVE', '', false, 'None', 'RUTH', 'HURTADO OLAVE');
INSERT INTO candidato VALUES (55011034, 'S', 34, 5011, 478, 150, 'RODOLFO CARTER FERNANDEZ', 'RODOLFO CARTER FERNANDEZ', '', true, 'None', 'RODOLFO', 'CARTER FERNANDEZ');
INSERT INTO candidato VALUES (55011035, 'S', 35, 5011, 999, 99, 'ROSA ELIZABETH CATRILEO ARIAS', 'ROSA ELIZABETH CATRILEO ARIAS', '', true, 'None', 'ROSA ELIZABETH', 'CATRILEO ARIAS');
INSERT INTO candidato VALUES (55014011, 'S', 11, 5014, 486, 130, 'MIGUEL ANGEL CALISTO AGUILA', 'MIGUEL ANGEL CALISTO AGUILA', '', true, 'None', 'MIGUEL ANGEL', 'CALISTO AGUILA');
INSERT INTO candidato VALUES (55014012, 'S', 12, 5014, 486, 130, 'JORGE ABELLO MOLL', 'JORGE ABELLO MOLL', '', true, 'None', 'JORGE', 'ABELLO MOLL');
INSERT INTO candidato VALUES (55014013, 'S', 13, 5014, 482, 4, 'XIMENA ORDENES NEIRA', 'XIMENA ORDENES NEIRA', '', true, 'None', 'XIMENA', 'ORDENES NEIRA');
INSERT INTO candidato VALUES (55014014, 'S', 14, 5014, 482, 5, 'TOMAS LAIBE SAEZ', 'TOMAS LAIBE SAEZ', '', false, 'None', 'TOMAS', 'LAIBE SAEZ');
INSERT INTO candidato VALUES (55014015, 'S', 15, 5014, 482, 232, 'RODRIGO ARAYA MORALES', 'RODRIGO ARAYA MORALES', '', false, 'None', 'RODRIGO', 'ARAYA MORALES');
INSERT INTO candidato VALUES (55014016, 'S', 16, 5014, 478, 197, 'MANUEL ANABALON JELDRES', 'MANUEL ANABALON JELDRES', '', true, 'None', 'MANUEL', 'ANABALON JELDRES');
INSERT INTO candidato VALUES (55014017, 'S', 17, 5014, 478, 150, 'BELEN OYARZUN EIHHORST', 'BELEN OYARZUN EIHHORST', '', false, 'None', 'BELEN', 'OYARZUN EIHHORST');
INSERT INTO candidato VALUES (55014018, 'S', 18, 5014, 478, 235, 'FELIPE HENRIQUEZ RAGLIANTI', 'FELIPE HENRIQUEZ RAGLIANTI', '', true, 'None', 'FELIPE', 'HENRIQUEZ RAGLIANTI');
INSERT INTO candidato VALUES (66001051, 'D', 51, 6001, 487, 190, 'RICARDO  SANZANA OTEIZA', 'RICARDO  SANZANA OTEIZA', '', true, 'None', 'RICARDO ', 'SANZANA OTEIZA');
INSERT INTO candidato VALUES (66001052, 'D', 52, 6001, 487, 190, 'LEONARDO VALENZUELA ATENAS', 'LEONARDO VALENZUELA ATENAS', '', false, 'None', 'LEONARDO', 'VALENZUELA ATENAS');
INSERT INTO candidato VALUES (66001053, 'D', 53, 6001, 487, 190, 'PAULINA SALDIA PINTO', 'PAULINA SALDIA PINTO', '', true, 'None', 'PAULINA', 'SALDIA PINTO');
INSERT INTO candidato VALUES (66001054, 'D', 54, 6001, 487, 130, 'LUIS ALEJANDRO PAREDES ESCANILLA', 'LUIS ALEJANDRO PAREDES ESCANILLA', '', false, 'None', 'LUIS ALEJANDRO', 'PAREDES ESCANILLA');
INSERT INTO candidato VALUES (66001055, 'D', 55, 6001, 483, 137, 'LUIS MALLA VALENZUELA', 'LUIS MALLA VALENZUELA', '', false, 'None', 'LUIS', 'MALLA VALENZUELA');
INSERT INTO candidato VALUES (66001056, 'D', 56, 6001, 483, 2, 'JORGE DIAZ IBARRA', 'JORGE DIAZ IBARRA', '', false, 'None', 'JORGE', 'DIAZ IBARRA');
INSERT INTO candidato VALUES (66001057, 'D', 57, 6001, 483, 4, 'GIOVANNA CALLE CAPUMA', 'GIOVANNA CALLE CAPUMA', '', false, 'None', 'GIOVANNA', 'CALLE CAPUMA');
INSERT INTO candidato VALUES (66001058, 'D', 58, 6001, 483, 5, 'SANDRA FLORES CONTRERAS', 'SANDRA FLORES CONTRERAS', '', false, 'None', 'SANDRA', 'FLORES CONTRERAS');
INSERT INTO candidato VALUES (66001059, 'D', 59, 6001, 481, 188, 'JUAN JACOBO TANCARA CHAMBE', 'JUAN JACOBO TANCARA CHAMBE', '', false, 'None', 'JUAN JACOBO', 'TANCARA CHAMBE');
INSERT INTO candidato VALUES (66001060, 'D', 60, 6001, 481, 188, 'ANA ANDREA CARVAJAL MARIPAN', 'ANA ANDREA CARVAJAL MARIPAN', '', true, 'None', 'ANA ANDREA', 'CARVAJAL MARIPAN');
INSERT INTO candidato VALUES (66001061, 'D', 61, 6001, 481, 188, 'ROBERTO SAMUEL FLORES SALGADO', 'ROBERTO SAMUEL FLORES SALGADO', '', true, 'None', 'ROBERTO SAMUEL', 'FLORES SALGADO');
INSERT INTO candidato VALUES (66001062, 'D', 62, 6001, 497, 220, 'CAMILO MARTIN JOFRE CAÑIPA', 'CAMILO MARTIN JOFRE CAÑIPA', '', false, 'None', 'CAMILO MARTIN', 'JOFRE CAÑIPA');
INSERT INTO candidato VALUES (66001063, 'D', 63, 6001, 495, 203, 'OSCAR BORIS PALLERES FLORES', 'OSCAR BORIS PALLERES FLORES', '', false, 'None', 'OSCAR BORIS', 'PALLERES FLORES');
INSERT INTO candidato VALUES (66001064, 'D', 64, 6001, 495, 203, 'DALDYM EUGENIA PINOCHET PEREZ', 'DALDYM EUGENIA PINOCHET PEREZ', '', false, 'None', 'DALDYM EUGENIA', 'PINOCHET PEREZ');
INSERT INTO candidato VALUES (66001065, 'D', 65, 6001, 489, 157, 'RODRIGO CUEVAS TRONCOSO', 'RODRIGO CUEVAS TRONCOSO', '', false, 'None', 'RODRIGO', 'CUEVAS TRONCOSO');
INSERT INTO candidato VALUES (66001066, 'D', 66, 6001, 489, 157, 'ERNESTO PLASENCIA ROJAS', 'ERNESTO PLASENCIA ROJAS', '', false, 'None', 'ERNESTO', 'PLASENCIA ROJAS');
INSERT INTO candidato VALUES (66001067, 'D', 67, 6001, 489, 157, 'RAUL PARADA FLORES', 'RAUL PARADA FLORES', '', false, 'None', 'RAUL', 'PARADA FLORES');
INSERT INTO candidato VALUES (66001068, 'D', 68, 6001, 489, 157, 'CANDY ANDRADE JARA', 'CANDY ANDRADE JARA', '', false, 'None', 'CANDY', 'ANDRADE JARA');
INSERT INTO candidato VALUES (66001069, 'D', 69, 6001, 485, 1, 'JUAN CARLOS CHINGA PALMA', 'JUAN CARLOS CHINGA PALMA', '', true, 'None', 'JUAN CARLOS', 'CHINGA PALMA');
INSERT INTO candidato VALUES (66001070, 'D', 70, 6001, 485, 3, 'SEBASTIAN HUERTA GONZALEZ', 'SEBASTIAN HUERTA GONZALEZ', '', false, 'None', 'SEBASTIAN', 'HUERTA GONZALEZ');
INSERT INTO candidato VALUES (66001071, 'D', 71, 6001, 485, 37, 'ARACELY BERRIOS GAJARDO', 'ARACELY BERRIOS GAJARDO', '', false, 'None', 'ARACELY', 'BERRIOS GAJARDO');
INSERT INTO candidato VALUES (66001072, 'D', 72, 6001, 479, 235, 'MARCELO  ZARA PIZARRO', 'MARCELO  ZARA PIZARRO', '', false, 'None', 'MARCELO ', 'ZARA PIZARRO');
INSERT INTO candidato VALUES (66001073, 'D', 73, 6001, 479, 197, 'JOSE LEE RODRIGUEZ', 'JOSE LEE RODRIGUEZ', '', false, 'None', 'JOSE', 'LEE RODRIGUEZ');
INSERT INTO candidato VALUES (66001074, 'D', 74, 6001, 479, 150, 'STEPHANIE JELDREZ ORTIZ', 'STEPHANIE JELDREZ ORTIZ', '', false, 'None', 'STEPHANIE', 'JELDREZ ORTIZ');
INSERT INTO candidato VALUES (66001075, 'D', 75, 6001, 479, 150, 'POLLYANA RIVERA BIGAS', 'POLLYANA RIVERA BIGAS', '', false, 'None', 'POLLYANA', 'RIVERA BIGAS');
INSERT INTO candidato VALUES (66002051, 'D', 51, 6002, 487, 190, 'MARCO CALCAGNO ZULETA', 'MARCO CALCAGNO ZULETA', '', true, 'None', 'MARCO', 'CALCAGNO ZULETA');
INSERT INTO candidato VALUES (66002052, 'D', 52, 6002, 487, 190, 'RUBEN ROJO SEMBLER', 'RUBEN ROJO SEMBLER', '', false, 'None', 'RUBEN', 'ROJO SEMBLER');
INSERT INTO candidato VALUES (66002053, 'D', 53, 6002, 487, 130, 'ANGEL CAMPOS DIAZ', 'ANGEL CAMPOS DIAZ', '', true, 'None', 'ANGEL', 'CAMPOS DIAZ');
INSERT INTO candidato VALUES (66002054, 'D', 54, 6002, 487, 130, 'ENZO MORALES NORAMBUENA', 'ENZO MORALES NORAMBUENA', '', true, 'None', 'ENZO', 'MORALES NORAMBUENA');
INSERT INTO candidato VALUES (66002055, 'D', 55, 6002, 483, 6, 'MATIAS RAMIREZ PASCAL', 'MATIAS RAMIREZ PASCAL', '', false, 'None', 'MATIAS', 'RAMIREZ PASCAL');
INSERT INTO candidato VALUES (66002056, 'D', 56, 6002, 483, 4, 'CARLOS JOSE CARVAJAL GALLARDO', 'CARLOS JOSE CARVAJAL GALLARDO', '', true, 'None', 'CARLOS JOSE', 'CARVAJAL GALLARDO');
INSERT INTO candidato VALUES (66002057, 'D', 57, 6002, 483, 2, 'ABRAHAM DIAZ MAMANI', 'ABRAHAM DIAZ MAMANI', '', false, 'None', 'ABRAHAM', 'DIAZ MAMANI');
INSERT INTO candidato VALUES (66002058, 'D', 58, 6002, 483, 232, 'NOEMI SALINAS POLANCO', 'NOEMI SALINAS POLANCO', '', false, 'None', 'NOEMI', 'SALINAS POLANCO');
INSERT INTO candidato VALUES (66002059, 'D', 59, 6002, 489, 157, 'PATRICIO QUISBERT LAZO', 'PATRICIO QUISBERT LAZO', '', false, 'None', 'PATRICIO', 'QUISBERT LAZO');
INSERT INTO candidato VALUES (66002060, 'D', 60, 6002, 489, 157, 'ANA TORO OJANE', 'ANA TORO OJANE', '', false, 'None', 'ANA', 'TORO OJANE');
INSERT INTO candidato VALUES (66002061, 'D', 61, 6002, 489, 157, 'CLAUDIO SAEZ MUÑOZ', 'CLAUDIO SAEZ MUÑOZ', '', false, 'None', 'CLAUDIO', 'SAEZ MUÑOZ');
INSERT INTO candidato VALUES (66002062, 'D', 62, 6002, 485, 3, 'XIMENA NARANJO PINTO', 'XIMENA NARANJO PINTO', '', true, 'None', 'XIMENA', 'NARANJO PINTO');
INSERT INTO candidato VALUES (66002063, 'D', 63, 6002, 485, 37, 'VITTORIO CANESSA MORALES', 'VITTORIO CANESSA MORALES', '', true, 'None', 'VITTORIO', 'CANESSA MORALES');
INSERT INTO candidato VALUES (66002064, 'D', 64, 6002, 485, 198, 'IVAN JIMENEZ CORREA', 'IVAN JIMENEZ CORREA', '', false, 'None', 'IVAN', 'JIMENEZ CORREA');
INSERT INTO candidato VALUES (66002065, 'D', 65, 6002, 485, 1, 'RAMON GALLEGUILLOS CASTILLO', 'RAMON GALLEGUILLOS CASTILLO', '', false, 'None', 'RAMON', 'GALLEGUILLOS CASTILLO');
INSERT INTO candidato VALUES (66002066, 'D', 66, 6002, 479, 150, 'JORGE MUÑOZ OYARCE', 'JORGE MUÑOZ OYARCE', '', false, 'None', 'JORGE', 'MUÑOZ OYARCE');
INSERT INTO candidato VALUES (66002067, 'D', 67, 6002, 479, 197, 'CRISTIAN CABEZAS MUNDACA', 'CRISTIAN CABEZAS MUNDACA', '', false, 'None', 'CRISTIAN', 'CABEZAS MUNDACA');
INSERT INTO candidato VALUES (66002068, 'D', 68, 6002, 479, 235, 'ALVARO JOFRE CACERES', 'ALVARO JOFRE CACERES', '', false, 'None', 'ALVARO', 'JOFRE CACERES');
INSERT INTO candidato VALUES (66002069, 'D', 69, 6002, 479, 235, 'AGUSTIN RENDIC GALLEGUILLOS', 'AGUSTIN RENDIC GALLEGUILLOS', '', false, 'None', 'AGUSTIN', 'RENDIC GALLEGUILLOS');
INSERT INTO candidato VALUES (66003051, 'D', 51, 6003, 487, 130, 'HERNAN VELASQUEZ NUÑEZ', 'HERNAN VELASQUEZ NUÑEZ', '', false, 'None', 'HERNAN', 'VELASQUEZ NUÑEZ');
INSERT INTO candidato VALUES (66003052, 'D', 52, 6003, 487, 130, 'MARION TAPIA GONZALEZ', 'MARION TAPIA GONZALEZ', '', false, 'None', 'MARION', 'TAPIA GONZALEZ');
INSERT INTO candidato VALUES (66003053, 'D', 53, 6003, 487, 130, 'DANAHE ROJAS MAMANI', 'DANAHE ROJAS MAMANI', '', false, 'None', 'DANAHE', 'ROJAS MAMANI');
INSERT INTO candidato VALUES (66003054, 'D', 54, 6003, 487, 190, 'MARIA GLORIA LAZCANO TORRES', 'MARIA GLORIA LAZCANO TORRES', '', false, 'None', 'MARIA GLORIA', 'LAZCANO TORRES');
INSERT INTO candidato VALUES (66003055, 'D', 55, 6003, 487, 190, 'EDUARDO SOTOMAYOR ORTIZ', 'EDUARDO SOTOMAYOR ORTIZ', '', false, 'None', 'EDUARDO', 'SOTOMAYOR ORTIZ');
INSERT INTO candidato VALUES (66003056, 'D', 56, 6003, 487, 190, 'MARCO RAMO PAEZ', 'MARCO RAMO PAEZ', '', false, 'None', 'MARCO', 'RAMO PAEZ');
INSERT INTO candidato VALUES (66003057, 'D', 57, 6003, 483, 137, 'SEBASTIAN PATRICIO VIDELA CASTILLO', 'SEBASTIAN PATRICIO VIDELA CASTILLO', '', true, 'None', 'SEBASTIAN PATRICIO', 'VIDELA CASTILLO');
INSERT INTO candidato VALUES (66003058, 'D', 58, 6003, 483, 4, 'JAIME ARAYA GUERRERO', 'JAIME ARAYA GUERRERO', '', true, 'None', 'JAIME', 'ARAYA GUERRERO');
INSERT INTO candidato VALUES (66003059, 'D', 59, 6003, 483, 6, 'PAULINA LIZANA MARTINEZ', 'PAULINA LIZANA MARTINEZ', '', false, 'None', 'PAULINA', 'LIZANA MARTINEZ');
INSERT INTO candidato VALUES (66003060, 'D', 60, 6003, 483, 7, 'MARCELA HERNANDO PEREZ', 'MARCELA HERNANDO PEREZ', '', false, 'None', 'MARCELA', 'HERNANDO PEREZ');
INSERT INTO candidato VALUES (66003061, 'D', 61, 6003, 483, 2, 'MARGARITA MONTECINO CORTEZ', 'MARGARITA MONTECINO CORTEZ', '', false, 'None', 'MARGARITA', 'MONTECINO CORTEZ');
INSERT INTO candidato VALUES (66003062, 'D', 62, 6003, 483, 232, 'GABRIELA CARRASCO URQUIETA', 'GABRIELA CARRASCO URQUIETA', '', false, 'None', 'GABRIELA', 'CARRASCO URQUIETA');
INSERT INTO candidato VALUES (66003063, 'D', 63, 6003, 481, 188, 'ADELA MARIA PIZARRO GONCALVEZ', 'ADELA MARIA PIZARRO GONCALVEZ', '', false, 'None', 'ADELA MARIA', 'PIZARRO GONCALVEZ');
INSERT INTO candidato VALUES (66003064, 'D', 64, 6003, 481, 201, 'DAN IBACACHE PANIAGUA', 'DAN IBACACHE PANIAGUA', '', false, 'None', 'DAN', 'IBACACHE PANIAGUA');
INSERT INTO candidato VALUES (66003065, 'D', 65, 6003, 497, 220, 'NATALIA VALENTINA SANCHEZ MUÑOZ', 'NATALIA VALENTINA SANCHEZ MUÑOZ', '', false, 'None', 'NATALIA VALENTINA', 'SANCHEZ MUÑOZ');
INSERT INTO candidato VALUES (66003066, 'D', 66, 6003, 497, 220, 'DANIEL ANDRES VARGAS DOWNING', 'DANIEL ANDRES VARGAS DOWNING', '', false, 'None', 'DANIEL ANDRES', 'VARGAS DOWNING');
INSERT INTO candidato VALUES (66003067, 'D', 67, 6003, 497, 220, 'DANIELA BEATRIZ AVILES HONORES', 'DANIELA BEATRIZ AVILES HONORES', '', false, 'None', 'DANIELA BEATRIZ', 'AVILES HONORES');
INSERT INTO candidato VALUES (66003068, 'D', 68, 6003, 497, 220, 'NESTOR LUIS VERA ROJAS', 'NESTOR LUIS VERA ROJAS', '', false, 'None', 'NESTOR LUIS', 'VERA ROJAS');
INSERT INTO candidato VALUES (66003069, 'D', 69, 6003, 495, 203, 'NELCY NIEVES CASTILLO SARAVIA', 'NELCY NIEVES CASTILLO SARAVIA', '', false, 'None', 'NELCY NIEVES', 'CASTILLO SARAVIA');
INSERT INTO candidato VALUES (66003070, 'D', 70, 6003, 489, 157, 'FABIAN OSSANDON BRICEÑO', 'FABIAN OSSANDON BRICEÑO', '', false, 'None', 'FABIAN', 'OSSANDON BRICEÑO');
INSERT INTO candidato VALUES (66003071, 'D', 71, 6003, 489, 157, 'PAOLA DEBIA GONZALEZ', 'PAOLA DEBIA GONZALEZ', '', false, 'None', 'PAOLA', 'DEBIA GONZALEZ');
INSERT INTO candidato VALUES (66003072, 'D', 72, 6003, 489, 157, 'SERGIO MARMIE IBARRONDO', 'SERGIO MARMIE IBARRONDO', '', false, 'None', 'SERGIO', 'MARMIE IBARRONDO');
INSERT INTO candidato VALUES (66003073, 'D', 73, 6003, 489, 157, 'JESSIE GONZALEZ BUGUEÑO', 'JESSIE GONZALEZ BUGUEÑO', '', false, 'None', 'JESSIE', 'GONZALEZ BUGUEÑO');
INSERT INTO candidato VALUES (66003074, 'D', 74, 6003, 489, 157, 'VILMA DE LOURDES  ESQUIVEL CESPEDES', 'VILMA DE LOURDES  ESQUIVEL CESPEDES', '', false, 'None', 'VILMA DE LOURDES ', 'ESQUIVEL CESPEDES');
INSERT INTO candidato VALUES (66003075, 'D', 75, 6003, 489, 157, 'LUIS RAMOS BUSTOS', 'LUIS RAMOS BUSTOS', '', false, 'None', 'LUIS', 'RAMOS BUSTOS');
INSERT INTO candidato VALUES (66003076, 'D', 76, 6003, 485, 1, 'JOSE MIGUEL CASTRO BASCUÑAN', 'JOSE MIGUEL CASTRO BASCUÑAN', '', false, 'None', 'JOSE MIGUEL', 'CASTRO BASCUÑAN');
INSERT INTO candidato VALUES (66003077, 'D', 77, 6003, 485, 1, 'DANIELA CASTRO ARAYA', 'DANIELA CASTRO ARAYA', '', false, 'None', 'DANIELA', 'CASTRO ARAYA');
INSERT INTO candidato VALUES (66003078, 'D', 78, 6003, 485, 198, 'CAROLINA LATORRE CRUZ', 'CAROLINA LATORRE CRUZ', '', false, 'None', 'CAROLINA', 'LATORRE CRUZ');
INSERT INTO candidato VALUES (66003079, 'D', 79, 6003, 485, 198, 'JOSE LUIS VELIZ VELIZ', 'JOSE LUIS VELIZ VELIZ', '', true, 'None', 'JOSE LUIS', 'VELIZ VELIZ');
INSERT INTO candidato VALUES (66003080, 'D', 80, 6003, 485, 37, 'JORGE OLIVARES PUENTES', 'JORGE OLIVARES PUENTES', '', false, 'None', 'JORGE', 'OLIVARES PUENTES');
INSERT INTO candidato VALUES (66003081, 'D', 81, 6003, 485, 37, 'YANTIEL CALDERON VALENZUELA', 'YANTIEL CALDERON VALENZUELA', '', false, 'None', 'YANTIEL', 'CALDERON VALENZUELA');
INSERT INTO candidato VALUES (66003082, 'D', 82, 6003, 479, 197, 'YOVANA AHUMADA PALMA', 'YOVANA AHUMADA PALMA', '', false, 'None', 'YOVANA', 'AHUMADA PALMA');
INSERT INTO candidato VALUES (66003083, 'D', 83, 6003, 479, 197, 'CAROLINA MOSCOSO CARRASCO', 'CAROLINA MOSCOSO CARRASCO', '', false, 'None', 'CAROLINA', 'MOSCOSO CARRASCO');
INSERT INTO candidato VALUES (66003084, 'D', 84, 6003, 479, 197, 'LESLIE MOLL VERA', 'LESLIE MOLL VERA', '', false, 'None', 'LESLIE', 'MOLL VERA');
INSERT INTO candidato VALUES (66003085, 'D', 85, 6003, 479, 235, 'ADRIANA JIMENEZ RETAMAL', 'ADRIANA JIMENEZ RETAMAL', '', false, 'None', 'ADRIANA', 'JIMENEZ RETAMAL');
INSERT INTO candidato VALUES (66003086, 'D', 86, 6003, 479, 150, 'CARLO ARQUEROS PIZARRO', 'CARLO ARQUEROS PIZARRO', '', false, 'None', 'CARLO', 'ARQUEROS PIZARRO');
INSERT INTO candidato VALUES (66003087, 'D', 87, 6003, 479, 150, 'SILVANA UBILLO ROJAS', 'SILVANA UBILLO ROJAS', '', false, 'None', 'SILVANA', 'UBILLO ROJAS');
INSERT INTO candidato VALUES (66004051, 'D', 51, 6004, 487, 130, 'JAIME MULET MARTINEZ', 'JAIME MULET MARTINEZ', '', false, 'None', 'JAIME', 'MULET MARTINEZ');
INSERT INTO candidato VALUES (66004052, 'D', 52, 6004, 487, 130, 'CAROLINA ARMENAKIS DAHER', 'CAROLINA ARMENAKIS DAHER', '', false, 'None', 'CAROLINA', 'ARMENAKIS DAHER');
INSERT INTO candidato VALUES (66004053, 'D', 53, 6004, 487, 130, 'CARLO PEZO CORREA', 'CARLO PEZO CORREA', '', true, 'None', 'CARLO', 'PEZO CORREA');
INSERT INTO candidato VALUES (66004054, 'D', 54, 6004, 487, 130, 'JAIME VARGAS GUERRA', 'JAIME VARGAS GUERRA', '', false, 'None', 'JAIME', 'VARGAS GUERRA');
INSERT INTO candidato VALUES (66004055, 'D', 55, 6004, 487, 130, 'JULIETA VARAS SILVA', 'JULIETA VARAS SILVA', '', true, 'None', 'JULIETA', 'VARAS SILVA');
INSERT INTO candidato VALUES (66004056, 'D', 56, 6004, 483, 4, 'CRISTIAN TAPIA RAMOS', 'CRISTIAN TAPIA RAMOS', '', true, 'None', 'CRISTIAN', 'TAPIA RAMOS');
INSERT INTO candidato VALUES (66004057, 'D', 57, 6004, 483, 4, 'CARLA MATUS GONZALEZ', 'CARLA MATUS GONZALEZ', '', true, 'None', 'CARLA', 'MATUS GONZALEZ');
INSERT INTO candidato VALUES (66004058, 'D', 58, 6004, 483, 6, 'ERICKA PORTILLA BARRIOS', 'ERICKA PORTILLA BARRIOS', '', false, 'None', 'ERICKA', 'PORTILLA BARRIOS');
INSERT INTO candidato VALUES (66004059, 'D', 59, 6004, 483, 6, 'PABLO ZENTENO MUÑOZ', 'PABLO ZENTENO MUÑOZ', '', false, 'None', 'PABLO', 'ZENTENO MUÑOZ');
INSERT INTO candidato VALUES (66004060, 'D', 60, 6004, 483, 5, 'PAMELA BORDONES OLIVARES', 'PAMELA BORDONES OLIVARES', '', true, 'None', 'PAMELA', 'BORDONES OLIVARES');
INSERT INTO candidato VALUES (66004061, 'D', 61, 6004, 483, 5, 'JUAN SANTANA CASTILLO', 'JUAN SANTANA CASTILLO', '', false, 'None', 'JUAN', 'SANTANA CASTILLO');
INSERT INTO candidato VALUES (66004062, 'D', 62, 6004, 495, 203, 'INTI ELEODORO SALAMANCA FERNANDEZ', 'INTI ELEODORO SALAMANCA FERNANDEZ', '', false, 'None', 'INTI ELEODORO', 'SALAMANCA FERNANDEZ');
INSERT INTO candidato VALUES (66004063, 'D', 63, 6004, 495, 203, 'JOANA ANDREA BARRIOS PAEZ', 'JOANA ANDREA BARRIOS PAEZ', '', false, 'None', 'JOANA ANDREA', 'BARRIOS PAEZ');
INSERT INTO candidato VALUES (66004064, 'D', 64, 6004, 495, 203, 'JORGE DAVID VARAS HENRIQUEZ', 'JORGE DAVID VARAS HENRIQUEZ', '', false, 'None', 'JORGE DAVID', 'VARAS HENRIQUEZ');
INSERT INTO candidato VALUES (66004065, 'D', 65, 6004, 495, 203, 'MARCELO ISMAEL RUIZ TAGLE ESCOBAR', 'MARCELO ISMAEL RUIZ TAGLE ESCOBAR', '', false, 'None', 'MARCELO ISMAEL', 'RUIZ TAGLE ESCOBAR');
INSERT INTO candidato VALUES (66004066, 'D', 66, 6004, 495, 203, 'OSCAR ALEJANDRO NUÑEZ VENEROS', 'OSCAR ALEJANDRO NUÑEZ VENEROS', '', false, 'None', 'OSCAR ALEJANDRO', 'NUÑEZ VENEROS');
INSERT INTO candidato VALUES (66004067, 'D', 67, 6004, 489, 157, 'PAULA ANDREA OLMOS CONTRERAS', 'PAULA ANDREA OLMOS CONTRERAS', '', false, 'None', 'PAULA ANDREA', 'OLMOS CONTRERAS');
INSERT INTO candidato VALUES (66004068, 'D', 68, 6004, 489, 157, 'JESSICA ALEJANDRA LIQUITAY MARTINEZ', 'JESSICA ALEJANDRA LIQUITAY MARTINEZ', '', false, 'None', 'JESSICA ALEJANDRA', 'LIQUITAY MARTINEZ');
INSERT INTO candidato VALUES (66004069, 'D', 69, 6004, 489, 157, 'ALEX ALEJANDRO FARIAS PEREZ', 'ALEX ALEJANDRO FARIAS PEREZ', '', false, 'None', 'ALEX ALEJANDRO', 'FARIAS PEREZ');
INSERT INTO candidato VALUES (66004070, 'D', 70, 6004, 489, 157, 'FRANCISCO JAVIER VARGAS MERY', 'FRANCISCO JAVIER VARGAS MERY', '', false, 'None', 'FRANCISCO JAVIER', 'VARGAS MERY');
INSERT INTO candidato VALUES (66004071, 'D', 71, 6004, 489, 157, 'HECTOR RAUL VERGARA SEURA', 'HECTOR RAUL VERGARA SEURA', '', false, 'None', 'HECTOR RAUL', 'VERGARA SEURA');
INSERT INTO candidato VALUES (66004072, 'D', 72, 6004, 485, 1, 'MAXIMILIANO BARRIONUEVO GARCIA', 'MAXIMILIANO BARRIONUEVO GARCIA', '', false, 'None', 'MAXIMILIANO', 'BARRIONUEVO GARCIA');
INSERT INTO candidato VALUES (66004073, 'D', 73, 6004, 485, 1, 'CARLA GUAITA CARRIZO', 'CARLA GUAITA CARRIZO', '', true, 'None', 'CARLA', 'GUAITA CARRIZO');
INSERT INTO candidato VALUES (66004074, 'D', 74, 6004, 485, 3, 'TANIA BORCOSKY RAMIREZ', 'TANIA BORCOSKY RAMIREZ', '', true, 'None', 'TANIA', 'BORCOSKY RAMIREZ');
INSERT INTO candidato VALUES (66004075, 'D', 75, 6004, 485, 3, 'KYLE CAMPBELL CAMPBELL', 'KYLE CAMPBELL CAMPBELL', '', false, 'None', 'KYLE', 'CAMPBELL CAMPBELL');
INSERT INTO candidato VALUES (66004076, 'D', 76, 6004, 485, 37, 'NAYARET OVIEDO ALVAREZ', 'NAYARET OVIEDO ALVAREZ', '', false, 'None', 'NAYARET', 'OVIEDO ALVAREZ');
INSERT INTO candidato VALUES (66004077, 'D', 77, 6004, 485, 37, 'GUILLERMO COFRE MUÑOZ', 'GUILLERMO COFRE MUÑOZ', '', false, 'None', 'GUILLERMO', 'COFRE MUÑOZ');
INSERT INTO candidato VALUES (66004078, 'D', 78, 6004, 479, 150, 'IGNACIO URCULLU CLEMENT-LUND', 'IGNACIO URCULLU CLEMENT-LUND', '', false, 'None', 'IGNACIO', 'URCULLU CLEMENT-LUND');
INSERT INTO candidato VALUES (66004079, 'D', 79, 6004, 479, 150, 'SUSANA HIPLAN ESTEFFAN', 'SUSANA HIPLAN ESTEFFAN', '', false, 'None', 'SUSANA', 'HIPLAN ESTEFFAN');
INSERT INTO candidato VALUES (66004080, 'D', 80, 6004, 479, 150, 'KARINA PALLERES GUZMAN', 'KARINA PALLERES GUZMAN', '', false, 'None', 'KARINA', 'PALLERES GUZMAN');
INSERT INTO candidato VALUES (66004081, 'D', 81, 6004, 479, 197, 'DANIELA GALLEGOS PORCILE', 'DANIELA GALLEGOS PORCILE', '', false, 'None', 'DANIELA', 'GALLEGOS PORCILE');
INSERT INTO candidato VALUES (66004082, 'D', 82, 6004, 479, 235, 'LUIS NUÑEZ BARRIENTOS', 'LUIS NUÑEZ BARRIENTOS', '', false, 'None', 'LUIS', 'NUÑEZ BARRIENTOS');
INSERT INTO candidato VALUES (66004083, 'D', 83, 6004, 479, 235, 'MARGARITA CONTRERAS RIOS', 'MARGARITA CONTRERAS RIOS', '', false, 'None', 'MARGARITA', 'CONTRERAS RIOS');
INSERT INTO candidato VALUES (66005051, 'D', 51, 6005, 487, 190, 'DANIELA  MOLINA BARRERA', 'DANIELA  MOLINA BARRERA', '', false, 'None', 'DANIELA ', 'MOLINA BARRERA');
INSERT INTO candidato VALUES (66005052, 'D', 52, 6005, 487, 190, 'CLAUDIA VALENZUELA TORRES', 'CLAUDIA VALENZUELA TORRES', '', true, 'None', 'CLAUDIA', 'VALENZUELA TORRES');
INSERT INTO candidato VALUES (66005053, 'D', 53, 6005, 487, 190, 'EDUARDO VARGAS GONZALEZ', 'EDUARDO VARGAS GONZALEZ', '', true, 'None', 'EDUARDO', 'VARGAS GONZALEZ');
INSERT INTO candidato VALUES (66005054, 'D', 54, 6005, 487, 190, 'MIREYA  CORONA CONTRERAS', 'MIREYA  CORONA CONTRERAS', '', true, 'None', 'MIREYA ', 'CORONA CONTRERAS');
INSERT INTO candidato VALUES (66005055, 'D', 55, 6005, 487, 190, 'PABLO RAMIREZ INOSTROZA', 'PABLO RAMIREZ INOSTROZA', '', false, 'None', 'PABLO', 'RAMIREZ INOSTROZA');
INSERT INTO candidato VALUES (66005056, 'D', 56, 6005, 487, 130, 'CLAUDIO IBAÑEZ GONZALEZ', 'CLAUDIO IBAÑEZ GONZALEZ', '', true, 'None', 'CLAUDIO', 'IBAÑEZ GONZALEZ');
INSERT INTO candidato VALUES (66005057, 'D', 57, 6005, 487, 130, 'ALEJANDRO CAMPUSANO MASSAD', 'ALEJANDRO CAMPUSANO MASSAD', '', true, 'None', 'ALEJANDRO', 'CAMPUSANO MASSAD');
INSERT INTO candidato VALUES (66005058, 'D', 58, 6005, 487, 130, 'ROSA PINTO ROJAS', 'ROSA PINTO ROJAS', '', false, 'None', 'ROSA', 'PINTO ROJAS');
INSERT INTO candidato VALUES (66005059, 'D', 59, 6005, 483, 232, 'CAROLINA TELLO ROJAS', 'CAROLINA TELLO ROJAS', '', false, 'None', 'CAROLINA', 'TELLO ROJAS');
INSERT INTO candidato VALUES (66005060, 'D', 60, 6005, 483, 5, 'DANIEL MANOUCHEHRI MOGHADAM KASHAN LOBOS', 'DANIEL MANOUCHEHRI MOGHADAM KASHAN LOBOS', '', false, 'None', 'DANIEL', 'MANOUCHEHRI MOGHADAM KASHAN LOBOS');
INSERT INTO candidato VALUES (66005061, 'D', 61, 6005, 483, 6, 'NATHALIE CASTILLO ROJAS', 'NATHALIE CASTILLO ROJAS', '', false, 'None', 'NATHALIE', 'CASTILLO ROJAS');
INSERT INTO candidato VALUES (66005062, 'D', 62, 6005, 483, 6, 'BERNARDO SALINAS MAYA', 'BERNARDO SALINAS MAYA', '', true, 'None', 'BERNARDO', 'SALINAS MAYA');
INSERT INTO candidato VALUES (66005063, 'D', 63, 6005, 483, 4, 'JORGE INSUNZA GREGORIO DE LAS HERAS', 'JORGE INSUNZA GREGORIO DE LAS HERAS', '', false, 'None', 'JORGE', 'INSUNZA GREGORIO DE LAS HERAS');
INSERT INTO candidato VALUES (66005064, 'D', 64, 6005, 483, 7, 'RAFAEL VERA CASTILLO', 'RAFAEL VERA CASTILLO', '', true, 'None', 'RAFAEL', 'VERA CASTILLO');
INSERT INTO candidato VALUES (66005065, 'D', 65, 6005, 483, 2, 'RICARDO CIFUENTES LILLO', 'RICARDO CIFUENTES LILLO', '', false, 'None', 'RICARDO', 'CIFUENTES LILLO');
INSERT INTO candidato VALUES (66005066, 'D', 66, 6005, 481, 201, 'MARIA GALLEGUILLOS TORRES', 'MARIA GALLEGUILLOS TORRES', '', false, 'None', 'MARIA', 'GALLEGUILLOS TORRES');
INSERT INTO candidato VALUES (66005067, 'D', 67, 6005, 481, 201, 'RODRIGO ANDRADE RAMIREZ', 'RODRIGO ANDRADE RAMIREZ', '', false, 'None', 'RODRIGO', 'ANDRADE RAMIREZ');
INSERT INTO candidato VALUES (66005068, 'D', 68, 6005, 481, 201, 'ARTURO ELLIS CATALDO', 'ARTURO ELLIS CATALDO', '', true, 'None', 'ARTURO', 'ELLIS CATALDO');
INSERT INTO candidato VALUES (66005069, 'D', 69, 6005, 481, 201, 'FRANCISCA PEMJEAN LETELIER', 'FRANCISCA PEMJEAN LETELIER', '', true, 'None', 'FRANCISCA', 'PEMJEAN LETELIER');
INSERT INTO candidato VALUES (66005070, 'D', 70, 6005, 481, 201, 'CRISTOPHER SUAZO BENAVIDES', 'CRISTOPHER SUAZO BENAVIDES', '', true, 'None', 'CRISTOPHER', 'SUAZO BENAVIDES');
INSERT INTO candidato VALUES (66017076, 'D', 76, 6017, 485, 1, 'ARIEL AMIGO VIDAL', 'ARIEL AMIGO VIDAL', '', false, 'None', 'ARIEL', 'AMIGO VIDAL');
INSERT INTO candidato VALUES (66005071, 'D', 71, 6005, 481, 201, 'RAFAEL MUÑOZ URRUTIA', 'RAFAEL MUÑOZ URRUTIA', '', true, 'None', 'RAFAEL', 'MUÑOZ URRUTIA');
INSERT INTO candidato VALUES (66005072, 'D', 72, 6005, 481, 201, 'ANA MARIA ITURRALDE PEÑA', 'ANA MARIA ITURRALDE PEÑA', '', true, 'None', 'ANA MARIA', 'ITURRALDE PEÑA');
INSERT INTO candidato VALUES (66005073, 'D', 73, 6005, 481, 201, 'CATERINA SIMONCELLI FRACCHIA', 'CATERINA SIMONCELLI FRACCHIA', '', false, 'None', 'CATERINA', 'SIMONCELLI FRACCHIA');
INSERT INTO candidato VALUES (66005074, 'D', 74, 6005, 491, 191, 'CARLOS EDUARDO RUIZ BENITEZ', 'CARLOS EDUARDO RUIZ BENITEZ', '', false, 'None', 'CARLOS EDUARDO', 'RUIZ BENITEZ');
INSERT INTO candidato VALUES (66005075, 'D', 75, 6005, 491, 191, 'MONTSERRAT MARGARITA PIZARRO CARREÑO', 'MONTSERRAT MARGARITA PIZARRO CARREÑO', '', false, 'None', 'MONTSERRAT MARGARITA', 'PIZARRO CARREÑO');
INSERT INTO candidato VALUES (66005076, 'D', 76, 6005, 491, 191, 'PABLO ALEJANDRO YAÑEZ PIZARRO', 'PABLO ALEJANDRO YAÑEZ PIZARRO', '', false, 'None', 'PABLO ALEJANDRO', 'YAÑEZ PIZARRO');
INSERT INTO candidato VALUES (66005077, 'D', 77, 6005, 491, 191, 'FRANCHESCA NICOLE PLAZA GONZALEZ', 'FRANCHESCA NICOLE PLAZA GONZALEZ', '', false, 'None', 'FRANCHESCA NICOLE', 'PLAZA GONZALEZ');
INSERT INTO candidato VALUES (66005078, 'D', 78, 6005, 491, 191, 'YERKO NEFTALI ZAMBRA VILLALOBOS', 'YERKO NEFTALI ZAMBRA VILLALOBOS', '', false, 'None', 'YERKO NEFTALI', 'ZAMBRA VILLALOBOS');
INSERT INTO candidato VALUES (66005079, 'D', 79, 6005, 491, 191, 'ELIZABETH SOLANGE FREDES ROSALES', 'ELIZABETH SOLANGE FREDES ROSALES', '', false, 'None', 'ELIZABETH SOLANGE', 'FREDES ROSALES');
INSERT INTO candidato VALUES (66005080, 'D', 80, 6005, 491, 191, 'TOMAS FELIPE YAVAR AGUILERA', 'TOMAS FELIPE YAVAR AGUILERA', '', false, 'None', 'TOMAS FELIPE', 'YAVAR AGUILERA');
INSERT INTO candidato VALUES (66005081, 'D', 81, 6005, 491, 191, 'FELIX ALONSO VELASCO LADRON DE GUEVARA', 'FELIX ALONSO VELASCO LADRON DE GUEVARA', '', false, 'None', 'FELIX ALONSO', 'VELASCO LADRON DE GUEVARA');
INSERT INTO candidato VALUES (66005082, 'D', 82, 6005, 489, 157, 'EILEEN PATRICIA URQUETA ROJAS', 'EILEEN PATRICIA URQUETA ROJAS', '', false, 'None', 'EILEEN PATRICIA', 'URQUETA ROJAS');
INSERT INTO candidato VALUES (66005083, 'D', 83, 6005, 489, 157, 'JUAN CARLOS THENOUX CIUDAD', 'JUAN CARLOS THENOUX CIUDAD', '', false, 'None', 'JUAN CARLOS', 'THENOUX CIUDAD');
INSERT INTO candidato VALUES (66005084, 'D', 84, 6005, 489, 157, 'MARICEL ANDREA TAPIA SALGUEIRO', 'MARICEL ANDREA TAPIA SALGUEIRO', '', false, 'None', 'MARICEL ANDREA', 'TAPIA SALGUEIRO');
INSERT INTO candidato VALUES (66005085, 'D', 85, 6005, 489, 157, 'FRANCISCO JAVIER NUÑEZ RENCORET', 'FRANCISCO JAVIER NUÑEZ RENCORET', '', false, 'None', 'FRANCISCO JAVIER', 'NUÑEZ RENCORET');
INSERT INTO candidato VALUES (66005086, 'D', 86, 6005, 489, 157, 'FERNANDA CRISTINA NUÑEZ ARAOS', 'FERNANDA CRISTINA NUÑEZ ARAOS', '', false, 'None', 'FERNANDA CRISTINA', 'NUÑEZ ARAOS');
INSERT INTO candidato VALUES (66005087, 'D', 87, 6005, 489, 157, 'JUAN SALVADOR SAUL DABED TOZO', 'JUAN SALVADOR SAUL DABED TOZO', '', false, 'None', 'JUAN SALVADOR SAUL', 'DABED TOZO');
INSERT INTO candidato VALUES (66005088, 'D', 88, 6005, 489, 157, 'JORGE FRANKLIN DUNSTAN PAVEZ', 'JORGE FRANKLIN DUNSTAN PAVEZ', '', false, 'None', 'JORGE FRANKLIN', 'DUNSTAN PAVEZ');
INSERT INTO candidato VALUES (66005089, 'D', 89, 6005, 485, 3, 'MARCO ANTONIO SULANTAY OLIVARES', 'MARCO ANTONIO SULANTAY OLIVARES', '', false, 'None', 'MARCO ANTONIO', 'SULANTAY OLIVARES');
INSERT INTO candidato VALUES (66005090, 'D', 90, 6005, 485, 3, 'JUAN MANUEL FUENZALIDA COBO', 'JUAN MANUEL FUENZALIDA COBO', '', false, 'None', 'JUAN MANUEL', 'FUENZALIDA COBO');
INSERT INTO candidato VALUES (66005091, 'D', 91, 6005, 485, 1, 'GIANNINA GONZALEZ MICHEA', 'GIANNINA GONZALEZ MICHEA', '', false, 'None', 'GIANNINA', 'GONZALEZ MICHEA');
INSERT INTO candidato VALUES (66005092, 'D', 92, 6005, 485, 1, 'ROBERTO VEGA CAMPUSANO', 'ROBERTO VEGA CAMPUSANO', '', false, 'None', 'ROBERTO', 'VEGA CAMPUSANO');
INSERT INTO candidato VALUES (66005093, 'D', 93, 6005, 485, 37, 'ROSETTA PARIS AVALOS', 'ROSETTA PARIS AVALOS', '', false, 'None', 'ROSETTA', 'PARIS AVALOS');
INSERT INTO candidato VALUES (66005094, 'D', 94, 6005, 485, 37, 'RODRIGO ORREGO GALVEZ', 'RODRIGO ORREGO GALVEZ', '', false, 'None', 'RODRIGO', 'ORREGO GALVEZ');
INSERT INTO candidato VALUES (66005095, 'D', 95, 6005, 485, 198, 'FRANCISCO MARTINEZ RIVERA', 'FRANCISCO MARTINEZ RIVERA', '', false, 'None', 'FRANCISCO', 'MARTINEZ RIVERA');
INSERT INTO candidato VALUES (66005096, 'D', 96, 6005, 485, 198, 'VICTOR PINO FUENTES', 'VICTOR PINO FUENTES', '', false, 'None', 'VICTOR', 'PINO FUENTES');
INSERT INTO candidato VALUES (66005097, 'D', 97, 6005, 479, 197, 'TATIANA CASTILLO GONZALEZ', 'TATIANA CASTILLO GONZALEZ', '', false, 'None', 'TATIANA', 'CASTILLO GONZALEZ');
INSERT INTO candidato VALUES (66005098, 'D', 98, 6005, 479, 197, 'ANDREA BARRERA ESCOBAR', 'ANDREA BARRERA ESCOBAR', '', false, 'None', 'ANDREA', 'BARRERA ESCOBAR');
INSERT INTO candidato VALUES (66005099, 'D', 99, 6005, 479, 197, 'MATIAS GUZMAN GALLEGUILLOS', 'MATIAS GUZMAN GALLEGUILLOS', '', false, 'None', 'MATIAS', 'GUZMAN GALLEGUILLOS');
INSERT INTO candidato VALUES (66005100, 'D', 100, 6005, 479, 235, 'ERICH GROHS MARIN', 'ERICH GROHS MARIN', '', false, 'None', 'ERICH', 'GROHS MARIN');
INSERT INTO candidato VALUES (66005101, 'D', 101, 6005, 479, 235, 'CONSTANZA PEÑA CONTRERAS', 'CONSTANZA PEÑA CONTRERAS', '', false, 'None', 'CONSTANZA', 'PEÑA CONTRERAS');
INSERT INTO candidato VALUES (66005102, 'D', 102, 6005, 479, 235, 'MARIA SOLEDAD ROBLES ESPINOSA', 'MARIA SOLEDAD ROBLES ESPINOSA', '', false, 'None', 'MARIA SOLEDAD', 'ROBLES ESPINOSA');
INSERT INTO candidato VALUES (66005103, 'D', 103, 6005, 479, 150, 'VERONICA PIZARRO GARCIA', 'VERONICA PIZARRO GARCIA', '', false, 'None', 'VERONICA', 'PIZARRO GARCIA');
INSERT INTO candidato VALUES (66005104, 'D', 104, 6005, 479, 150, 'PAMELA RISHMAGUE BUZZO', 'PAMELA RISHMAGUE BUZZO', '', false, 'None', 'PAMELA', 'RISHMAGUE BUZZO');
INSERT INTO candidato VALUES (66006051, 'D', 51, 6006, 487, 130, 'OCTAVIO GONZALEZ OJEDA', 'OCTAVIO GONZALEZ OJEDA', '', false, 'None', 'OCTAVIO', 'GONZALEZ OJEDA');
INSERT INTO candidato VALUES (66006052, 'D', 52, 6006, 487, 130, 'CLAUDIA JOFRE VIDAL', 'CLAUDIA JOFRE VIDAL', '', true, 'None', 'CLAUDIA', 'JOFRE VIDAL');
INSERT INTO candidato VALUES (66006053, 'D', 53, 6006, 487, 130, 'ROBERTO VIDELA PAVEZ', 'ROBERTO VIDELA PAVEZ', '', false, 'None', 'ROBERTO', 'VIDELA PAVEZ');
INSERT INTO candidato VALUES (66006054, 'D', 54, 6006, 487, 130, 'MARIA CLAUDIA CANALES LEMUS', 'MARIA CLAUDIA CANALES LEMUS', '', true, 'None', 'MARIA CLAUDIA', 'CANALES LEMUS');
INSERT INTO candidato VALUES (66006055, 'D', 55, 6006, 487, 190, 'JAVIERA  TOLEDO MUÑOZ', 'JAVIERA  TOLEDO MUÑOZ', '', true, 'None', 'JAVIERA ', 'TOLEDO MUÑOZ');
INSERT INTO candidato VALUES (66006056, 'D', 56, 6006, 487, 190, 'YANIXSA  AGUILERA CATALAN', 'YANIXSA  AGUILERA CATALAN', '', true, 'None', 'YANIXSA ', 'AGUILERA CATALAN');
INSERT INTO candidato VALUES (66006057, 'D', 57, 6006, 487, 190, 'PAMELA  GONZALEZ MUÑOZ', 'PAMELA  GONZALEZ MUÑOZ', '', true, 'None', 'PAMELA ', 'GONZALEZ MUÑOZ');
INSERT INTO candidato VALUES (66006058, 'D', 58, 6006, 487, 190, 'FRANCISCA SALAMA PIMENTEL', 'FRANCISCA SALAMA PIMENTEL', '', true, 'None', 'FRANCISCA', 'SALAMA PIMENTEL');
INSERT INTO candidato VALUES (66006059, 'D', 59, 6006, 487, 190, 'LUIS HURTADO MUÑOZ', 'LUIS HURTADO MUÑOZ', '', true, 'None', 'LUIS', 'HURTADO MUÑOZ');
INSERT INTO candidato VALUES (66006060, 'D', 60, 6006, 483, 232, 'JUAN LATORRE RIVEROS', 'JUAN LATORRE RIVEROS', '', false, 'None', 'JUAN', 'LATORRE RIVEROS');
INSERT INTO candidato VALUES (66006061, 'D', 61, 6006, 483, 232, 'FRANCISCA BELLO CAMPOS', 'FRANCISCA BELLO CAMPOS', '', false, 'None', 'FRANCISCA', 'BELLO CAMPOS');
INSERT INTO candidato VALUES (66006062, 'D', 62, 6006, 483, 5, 'NELSON VENEGAS SALAZAR', 'NELSON VENEGAS SALAZAR', '', false, 'None', 'NELSON', 'VENEGAS SALAZAR');
INSERT INTO candidato VALUES (66006063, 'D', 63, 6006, 483, 7, 'MAURICIO VIÑAMBRES ADASME', 'MAURICIO VIÑAMBRES ADASME', '', true, 'None', 'MAURICIO', 'VIÑAMBRES ADASME');
INSERT INTO candidato VALUES (66006064, 'D', 64, 6006, 483, 4, 'LUIS FONCEA CALDERON', 'LUIS FONCEA CALDERON', '', true, 'None', 'LUIS', 'FONCEA CALDERON');
INSERT INTO candidato VALUES (66006065, 'D', 65, 6006, 483, 137, 'SABAS IVAN CHAHUAN SARRAS', 'SABAS IVAN CHAHUAN SARRAS', '', true, 'None', 'SABAS IVAN', 'CHAHUAN SARRAS');
INSERT INTO candidato VALUES (66006066, 'D', 66, 6006, 483, 6, 'SOFIA GONZALEZ CORTES', 'SOFIA GONZALEZ CORTES', '', false, 'None', 'SOFIA', 'GONZALEZ CORTES');
INSERT INTO candidato VALUES (66006067, 'D', 67, 6006, 483, 2, 'CRISTIAN MELLA ANDAUR', 'CRISTIAN MELLA ANDAUR', '', false, 'None', 'CRISTIAN', 'MELLA ANDAUR');
INSERT INTO candidato VALUES (66006068, 'D', 68, 6006, 483, 2, 'GASPAR RIVAS SANCHEZ', 'GASPAR RIVAS SANCHEZ', '', true, 'None', 'GASPAR', 'RIVAS SANCHEZ');
INSERT INTO candidato VALUES (66006069, 'D', 69, 6006, 489, 157, 'JAVIER OLIVARES AVENDAÑO', 'JAVIER OLIVARES AVENDAÑO', '', false, 'None', 'JAVIER', 'OLIVARES AVENDAÑO');
INSERT INTO candidato VALUES (66006070, 'D', 70, 6006, 489, 157, 'MAYKOL CASTILLO FERNANDEZ', 'MAYKOL CASTILLO FERNANDEZ', '', false, 'None', 'MAYKOL', 'CASTILLO FERNANDEZ');
INSERT INTO candidato VALUES (66006071, 'D', 71, 6006, 489, 157, 'JORGE CRISTI RAMIREZ', 'JORGE CRISTI RAMIREZ', '', false, 'None', 'JORGE', 'CRISTI RAMIREZ');
INSERT INTO candidato VALUES (66006072, 'D', 72, 6006, 489, 157, 'GONZALO MARCELO SOTO PIZARRO', 'GONZALO MARCELO SOTO PIZARRO', '', false, 'None', 'GONZALO MARCELO', 'SOTO PIZARRO');
INSERT INTO candidato VALUES (66006073, 'D', 73, 6006, 489, 157, 'CAMILA FRANCESCA DOÑAS VARGAS', 'CAMILA FRANCESCA DOÑAS VARGAS', '', false, 'None', 'CAMILA FRANCESCA', 'DOÑAS VARGAS');
INSERT INTO candidato VALUES (66006074, 'D', 74, 6006, 489, 157, 'BONNIE SILVA VILLARROEL', 'BONNIE SILVA VILLARROEL', '', false, 'None', 'BONNIE', 'SILVA VILLARROEL');
INSERT INTO candidato VALUES (66006075, 'D', 75, 6006, 489, 157, 'BLANCA ESTHER CURRIECO SOTO', 'BLANCA ESTHER CURRIECO SOTO', '', false, 'None', 'BLANCA ESTHER', 'CURRIECO SOTO');
INSERT INTO candidato VALUES (66006076, 'D', 76, 6006, 489, 157, 'MARCIA XIMENA MARCHANT FARIAS', 'MARCIA XIMENA MARCHANT FARIAS', '', false, 'None', 'MARCIA XIMENA', 'MARCHANT FARIAS');
INSERT INTO candidato VALUES (66006077, 'D', 77, 6006, 489, 157, 'RUBY VILLALOBOS ARACENA', 'RUBY VILLALOBOS ARACENA', '', false, 'None', 'RUBY', 'VILLALOBOS ARACENA');
INSERT INTO candidato VALUES (66006078, 'D', 78, 6006, 485, 1, 'LUIS PARDO SAINZ', 'LUIS PARDO SAINZ', '', false, 'None', 'LUIS', 'PARDO SAINZ');
INSERT INTO candidato VALUES (66006079, 'D', 79, 6006, 485, 1, 'PERCY MARIN VERA', 'PERCY MARIN VERA', '', false, 'None', 'PERCY', 'MARIN VERA');
INSERT INTO candidato VALUES (66006080, 'D', 80, 6006, 485, 37, 'DANILO QUIROZ CROVETTO', 'DANILO QUIROZ CROVETTO', '', true, 'None', 'DANILO', 'QUIROZ CROVETTO');
INSERT INTO candidato VALUES (66006081, 'D', 81, 6006, 485, 37, 'CAROLINA JULIO LATORRE', 'CAROLINA JULIO LATORRE', '', true, 'None', 'CAROLINA', 'JULIO LATORRE');
INSERT INTO candidato VALUES (66006082, 'D', 82, 6006, 485, 37, 'JORDAN GUAJARDO VICENCIO', 'JORDAN GUAJARDO VICENCIO', '', true, 'None', 'JORDAN', 'GUAJARDO VICENCIO');
INSERT INTO candidato VALUES (66006083, 'D', 83, 6006, 485, 3, 'JAVIER CRASEMANN ALFONSO', 'JAVIER CRASEMANN ALFONSO', '', true, 'None', 'JAVIER', 'CRASEMANN ALFONSO');
INSERT INTO candidato VALUES (66006084, 'D', 84, 6006, 485, 3, 'CATALINA OTERO PEREZ', 'CATALINA OTERO PEREZ', '', true, 'None', 'CATALINA', 'OTERO PEREZ');
INSERT INTO candidato VALUES (66006085, 'D', 85, 6006, 485, 3, 'VIVIANA NUÑEZ CARRASCO', 'VIVIANA NUÑEZ CARRASCO', '', false, 'None', 'VIVIANA', 'NUÑEZ CARRASCO');
INSERT INTO candidato VALUES (66006086, 'D', 86, 6006, 479, 150, 'CHIARA BARCHIESI CHAVEZ', 'CHIARA BARCHIESI CHAVEZ', '', false, 'None', 'CHIARA', 'BARCHIESI CHAVEZ');
INSERT INTO candidato VALUES (66006087, 'D', 87, 6006, 479, 150, 'BENJAMIN LORCA INZUNZA', 'BENJAMIN LORCA INZUNZA', '', false, 'None', 'BENJAMIN', 'LORCA INZUNZA');
INSERT INTO candidato VALUES (66006088, 'D', 88, 6006, 479, 150, 'MANUEL MILLONES CHIRINO', 'MANUEL MILLONES CHIRINO', '', true, 'None', 'MANUEL', 'MILLONES CHIRINO');
INSERT INTO candidato VALUES (66006089, 'D', 89, 6006, 479, 197, 'MARLENE GONZALEZ AHUMADA', 'MARLENE GONZALEZ AHUMADA', '', false, 'None', 'MARLENE', 'GONZALEZ AHUMADA');
INSERT INTO candidato VALUES (66006090, 'D', 90, 6006, 479, 197, 'RODOLFO PONCE VARGAS', 'RODOLFO PONCE VARGAS', '', true, 'None', 'RODOLFO', 'PONCE VARGAS');
INSERT INTO candidato VALUES (66006091, 'D', 91, 6006, 479, 235, 'JOSE VALLEJO KNOCKAERT', 'JOSE VALLEJO KNOCKAERT', '', false, 'None', 'JOSE', 'VALLEJO KNOCKAERT');
INSERT INTO candidato VALUES (66006092, 'D', 92, 6006, 479, 235, 'SOLEDAD CALVO HERRERA', 'SOLEDAD CALVO HERRERA', '', false, 'None', 'SOLEDAD', 'CALVO HERRERA');
INSERT INTO candidato VALUES (66006093, 'D', 93, 6006, 479, 235, 'VERONICA BECERRA VERGARA', 'VERONICA BECERRA VERGARA', '', false, 'None', 'VERONICA', 'BECERRA VERGARA');
INSERT INTO candidato VALUES (66006094, 'D', 94, 6006, 479, 235, 'JORGE VILLARROEL PEREZ', 'JORGE VILLARROEL PEREZ', '', false, 'None', 'JORGE', 'VILLARROEL PEREZ');
INSERT INTO candidato VALUES (66007051, 'D', 51, 6007, 487, 130, 'JORGE SHARP FAJARDO', 'JORGE SHARP FAJARDO', '', true, 'None', 'JORGE', 'SHARP FAJARDO');
INSERT INTO candidato VALUES (66007052, 'D', 52, 6007, 487, 130, 'RENE LUES ESCOBAR', 'RENE LUES ESCOBAR', '', true, 'None', 'RENE', 'LUES ESCOBAR');
INSERT INTO candidato VALUES (66007053, 'D', 53, 6007, 487, 130, 'PRISCILA FLEMING ARANGUIZ', 'PRISCILA FLEMING ARANGUIZ', '', true, 'None', 'PRISCILA', 'FLEMING ARANGUIZ');
INSERT INTO candidato VALUES (66007054, 'D', 54, 6007, 487, 130, 'ANGELA CABEZON CONTRERAS', 'ANGELA CABEZON CONTRERAS', '', false, 'None', 'ANGELA', 'CABEZON CONTRERAS');
INSERT INTO candidato VALUES (66007055, 'D', 55, 6007, 487, 130, 'RODRIGO RUIZ ENCINA', 'RODRIGO RUIZ ENCINA', '', true, 'None', 'RODRIGO', 'RUIZ ENCINA');
INSERT INTO candidato VALUES (66007056, 'D', 56, 6007, 487, 190, 'TANIA MADRIAGA FLORES', 'TANIA MADRIAGA FLORES', '', false, 'None', 'TANIA', 'MADRIAGA FLORES');
INSERT INTO candidato VALUES (66007057, 'D', 57, 6007, 487, 190, 'CARLOS MUÑOZ LECERF', 'CARLOS MUÑOZ LECERF', '', true, 'None', 'CARLOS', 'MUÑOZ LECERF');
INSERT INTO candidato VALUES (66007058, 'D', 58, 6007, 487, 190, 'LUCIA ORTIZ LEON', 'LUCIA ORTIZ LEON', '', true, 'None', 'LUCIA', 'ORTIZ LEON');
INSERT INTO candidato VALUES (66007059, 'D', 59, 6007, 487, 190, 'CLAUDIO VALLE FIGUEROA', 'CLAUDIO VALLE FIGUEROA', '', true, 'None', 'CLAUDIO', 'VALLE FIGUEROA');
INSERT INTO candidato VALUES (66007060, 'D', 60, 6007, 483, 7, 'TOMAS LAGOMARSINO GUZMAN', 'TOMAS LAGOMARSINO GUZMAN', '', false, 'None', 'TOMAS', 'LAGOMARSINO GUZMAN');
INSERT INTO candidato VALUES (66007061, 'D', 61, 6007, 483, 232, 'JORGE BRITO HASBUN', 'JORGE BRITO HASBUN', '', false, 'None', 'JORGE', 'BRITO HASBUN');
INSERT INTO candidato VALUES (66007062, 'D', 62, 6007, 483, 232, 'JAIME BASSA MERCADO', 'JAIME BASSA MERCADO', '', false, 'None', 'JAIME', 'BASSA MERCADO');
INSERT INTO candidato VALUES (66007063, 'D', 63, 6007, 483, 6, 'LUIS CUELLO PEÑA Y LILLO', 'LUIS CUELLO PEÑA Y LILLO', '', false, 'None', 'LUIS', 'CUELLO PEÑA Y LILLO');
INSERT INTO candidato VALUES (66007064, 'D', 64, 6007, 483, 2, 'ROY CRICHTON ORELLANA', 'ROY CRICHTON ORELLANA', '', false, 'None', 'ROY', 'CRICHTON ORELLANA');
INSERT INTO candidato VALUES (66007065, 'D', 65, 6007, 483, 137, 'FELIPE ALFREDO RIOS CUEVAS', 'FELIPE ALFREDO RIOS CUEVAS', '', false, 'None', 'FELIPE ALFREDO', 'RIOS CUEVAS');
INSERT INTO candidato VALUES (66007066, 'D', 66, 6007, 483, 4, 'MANUEL MURILLO CALDERON', 'MANUEL MURILLO CALDERON', '', true, 'None', 'MANUEL', 'MURILLO CALDERON');
INSERT INTO candidato VALUES (66007067, 'D', 67, 6007, 483, 5, 'TOMAS DE REMENTERIA VENEGAS', 'TOMAS DE REMENTERIA VENEGAS', '', false, 'None', 'TOMAS', 'DE REMENTERIA VENEGAS');
INSERT INTO candidato VALUES (66007068, 'D', 68, 6007, 483, 5, 'ARTURO BARRIOS OTEIZA', 'ARTURO BARRIOS OTEIZA', '', false, 'None', 'ARTURO', 'BARRIOS OTEIZA');
INSERT INTO candidato VALUES (66007069, 'D', 69, 6007, 497, 220, 'ANTONIO ALEJANDRO PAEZ AGUILAR', 'ANTONIO ALEJANDRO PAEZ AGUILAR', '', false, 'None', 'ANTONIO ALEJANDRO', 'PAEZ AGUILAR');
INSERT INTO candidato VALUES (66007070, 'D', 70, 6007, 497, 220, 'ALEJANDRA VALDERRAMA ZUÑIGA', 'ALEJANDRA VALDERRAMA ZUÑIGA', '', false, 'None', 'ALEJANDRA', 'VALDERRAMA ZUÑIGA');
INSERT INTO candidato VALUES (66007071, 'D', 71, 6007, 497, 220, 'ROMINA FERNANDA IBAÑEZ SAN MARTIN', 'ROMINA FERNANDA IBAÑEZ SAN MARTIN', '', false, 'None', 'ROMINA FERNANDA', 'IBAÑEZ SAN MARTIN');
INSERT INTO candidato VALUES (66007072, 'D', 72, 6007, 495, 203, 'CRISTIAN EDUARDO CUEVAS ZAMBRANO', 'CRISTIAN EDUARDO CUEVAS ZAMBRANO', '', false, 'None', 'CRISTIAN EDUARDO', 'CUEVAS ZAMBRANO');
INSERT INTO candidato VALUES (66007073, 'D', 73, 6007, 495, 203, 'CONSTANZA LORETO AHUMADA FUENTES', 'CONSTANZA LORETO AHUMADA FUENTES', '', false, 'None', 'CONSTANZA LORETO', 'AHUMADA FUENTES');
INSERT INTO candidato VALUES (66007074, 'D', 74, 6007, 495, 203, 'MONSERRAT MICHEL ESPAÑA VALDIVIA', 'MONSERRAT MICHEL ESPAÑA VALDIVIA', '', false, 'None', 'MONSERRAT MICHEL', 'ESPAÑA VALDIVIA');
INSERT INTO candidato VALUES (66007075, 'D', 75, 6007, 495, 203, 'AMARO ENRIQUE RAMIREZ GARCIA', 'AMARO ENRIQUE RAMIREZ GARCIA', '', false, 'None', 'AMARO ENRIQUE', 'RAMIREZ GARCIA');
INSERT INTO candidato VALUES (66007076, 'D', 76, 6007, 495, 203, 'RODRIGO ANDRES WITTWER SALINAS', 'RODRIGO ANDRES WITTWER SALINAS', '', false, 'None', 'RODRIGO ANDRES', 'WITTWER SALINAS');
INSERT INTO candidato VALUES (66007077, 'D', 77, 6007, 495, 203, 'MATIAS GAZMURI KRUBERG', 'MATIAS GAZMURI KRUBERG', '', false, 'None', 'MATIAS', 'GAZMURI KRUBERG');
INSERT INTO candidato VALUES (66007078, 'D', 78, 6007, 495, 203, 'FRANCISCO-JESUS PEÑALOZA AGUILERA', 'FRANCISCO-JESUS PEÑALOZA AGUILERA', '', false, 'None', 'FRANCISCO-JESUS', 'PEÑALOZA AGUILERA');
INSERT INTO candidato VALUES (66007079, 'D', 79, 6007, 495, 203, 'VALENTINA RAYEN NUÑEZ GODOY', 'VALENTINA RAYEN NUÑEZ GODOY', '', false, 'None', 'VALENTINA RAYEN', 'NUÑEZ GODOY');
INSERT INTO candidato VALUES (66007080, 'D', 80, 6007, 495, 203, 'MARIELA DEL CARMEN HIDALGO DIAZ', 'MARIELA DEL CARMEN HIDALGO DIAZ', '', false, 'None', 'MARIELA DEL CARMEN', 'HIDALGO DIAZ');
INSERT INTO candidato VALUES (66007081, 'D', 81, 6007, 489, 157, 'JUAN MARCELO VALENZUELA HENRIQUEZ', 'JUAN MARCELO VALENZUELA HENRIQUEZ', '', false, 'None', 'JUAN MARCELO', 'VALENZUELA HENRIQUEZ');
INSERT INTO candidato VALUES (66007082, 'D', 82, 6007, 489, 157, 'NICOLAS EDUARDO FARFAN VEGA', 'NICOLAS EDUARDO FARFAN VEGA', '', false, 'None', 'NICOLAS EDUARDO', 'FARFAN VEGA');
INSERT INTO candidato VALUES (66007083, 'D', 83, 6007, 489, 157, 'VANESSA FERRER RADOVICH', 'VANESSA FERRER RADOVICH', '', false, 'None', 'VANESSA', 'FERRER RADOVICH');
INSERT INTO candidato VALUES (66007084, 'D', 84, 6007, 489, 157, 'GUILLERMO ESCOBAR ARRIAGADA', 'GUILLERMO ESCOBAR ARRIAGADA', '', false, 'None', 'GUILLERMO', 'ESCOBAR ARRIAGADA');
INSERT INTO candidato VALUES (66007085, 'D', 85, 6007, 489, 157, 'VERONICA ROJAS ARENAS', 'VERONICA ROJAS ARENAS', '', false, 'None', 'VERONICA', 'ROJAS ARENAS');
INSERT INTO candidato VALUES (66007086, 'D', 86, 6007, 489, 157, 'CAROLL SALOME MEYER MEYER', 'CAROLL SALOME MEYER MEYER', '', false, 'None', 'CAROLL SALOME', 'MEYER MEYER');
INSERT INTO candidato VALUES (66007087, 'D', 87, 6007, 489, 157, 'NATALIA VANESSA NAVARRO ALDAY', 'NATALIA VANESSA NAVARRO ALDAY', '', false, 'None', 'NATALIA VANESSA', 'NAVARRO ALDAY');
INSERT INTO candidato VALUES (66007088, 'D', 88, 6007, 485, 1, 'ANDRES CELIS MONTT', 'ANDRES CELIS MONTT', '', false, 'None', 'ANDRES', 'CELIS MONTT');
INSERT INTO candidato VALUES (66007089, 'D', 89, 6007, 485, 1, 'SAMIRA CHAHUAN AKLE', 'SAMIRA CHAHUAN AKLE', '', false, 'None', 'SAMIRA', 'CHAHUAN AKLE');
INSERT INTO candidato VALUES (66007090, 'D', 90, 6007, 485, 1, 'LEOPOLDO MORENO CONTARDO', 'LEOPOLDO MORENO CONTARDO', '', true, 'None', 'LEOPOLDO', 'MORENO CONTARDO');
INSERT INTO candidato VALUES (66007091, 'D', 91, 6007, 485, 37, 'CARLOS MONDACA MATZNER', 'CARLOS MONDACA MATZNER', '', true, 'None', 'CARLOS', 'MONDACA MATZNER');
INSERT INTO candidato VALUES (66007092, 'D', 92, 6007, 485, 37, 'JORGE GARCES ROJAS', 'JORGE GARCES ROJAS', '', true, 'None', 'JORGE', 'GARCES ROJAS');
INSERT INTO candidato VALUES (66007093, 'D', 93, 6007, 485, 37, 'MARLEN OLIVARI MAYER', 'MARLEN OLIVARI MAYER', '', true, 'None', 'MARLEN', 'OLIVARI MAYER');
INSERT INTO candidato VALUES (66007094, 'D', 94, 6007, 485, 3, 'JORGE CASTRO MUÑOZ', 'JORGE CASTRO MUÑOZ', '', false, 'None', 'JORGE', 'CASTRO MUÑOZ');
INSERT INTO candidato VALUES (66007095, 'D', 95, 6007, 485, 3, 'MACARENA URENDA SALAMANCA', 'MACARENA URENDA SALAMANCA', '', false, 'None', 'MACARENA', 'URENDA SALAMANCA');
INSERT INTO candidato VALUES (66007096, 'D', 96, 6007, 485, 3, 'HOTUITI TEAO DRAGO', 'HOTUITI TEAO DRAGO', '', true, 'None', 'HOTUITI', 'TEAO DRAGO');
INSERT INTO candidato VALUES (66007097, 'D', 97, 6007, 479, 150, 'LUIS FERNANDO SANCHEZ OSSA', 'LUIS FERNANDO SANCHEZ OSSA', '', false, 'None', 'LUIS FERNANDO', 'SANCHEZ OSSA');
INSERT INTO candidato VALUES (66007098, 'D', 98, 6007, 479, 150, 'RAFAEL GONZALEZ CAMUS', 'RAFAEL GONZALEZ CAMUS', '', false, 'None', 'RAFAEL', 'GONZALEZ CAMUS');
INSERT INTO candidato VALUES (66007099, 'D', 99, 6007, 479, 150, 'ANGELA CARRASCO JOFRE', 'ANGELA CARRASCO JOFRE', '', false, 'None', 'ANGELA', 'CARRASCO JOFRE');
INSERT INTO candidato VALUES (66007100, 'D', 100, 6007, 479, 150, 'SEBASTIAN ZAMORA SOTO', 'SEBASTIAN ZAMORA SOTO', '', true, 'None', 'SEBASTIAN', 'ZAMORA SOTO');
INSERT INTO candidato VALUES (66007101, 'D', 101, 6007, 479, 235, 'JAIME MORALES OTAROLA', 'JAIME MORALES OTAROLA', '', true, 'None', 'JAIME', 'MORALES OTAROLA');
INSERT INTO candidato VALUES (66007102, 'D', 102, 6007, 479, 235, 'PEDRO SCHWEDELBACH PUGA', 'PEDRO SCHWEDELBACH PUGA', '', false, 'None', 'PEDRO', 'SCHWEDELBACH PUGA');
INSERT INTO candidato VALUES (66007103, 'D', 103, 6007, 479, 235, 'ALEJANDRA CARRASCO PEREZ', 'ALEJANDRA CARRASCO PEREZ', '', false, 'None', 'ALEJANDRA', 'CARRASCO PEREZ');
INSERT INTO candidato VALUES (66007104, 'D', 104, 6007, 479, 197, 'BARBARA VERA SEPULVEDA', 'BARBARA VERA SEPULVEDA', '', false, 'None', 'BARBARA', 'VERA SEPULVEDA');
INSERT INTO candidato VALUES (66007105, 'D', 105, 6007, 479, 197, 'JUAN ALBERTO SEPULVEDA QUEZADA', 'JUAN ALBERTO SEPULVEDA QUEZADA', '', false, 'None', 'JUAN ALBERTO', 'SEPULVEDA QUEZADA');
INSERT INTO candidato VALUES (66008051, 'D', 51, 6008, 487, 190, 'CESAR LEIVA RUBIO', 'CESAR LEIVA RUBIO', '', true, 'None', 'CESAR', 'LEIVA RUBIO');
INSERT INTO candidato VALUES (66008052, 'D', 52, 6008, 487, 190, 'CARLOS ASTUDILLO ULLOA', 'CARLOS ASTUDILLO ULLOA', '', true, 'None', 'CARLOS', 'ASTUDILLO ULLOA');
INSERT INTO candidato VALUES (66008053, 'D', 53, 6008, 487, 190, 'JAVIER IBARRA REYES', 'JAVIER IBARRA REYES', '', false, 'None', 'JAVIER', 'IBARRA REYES');
INSERT INTO candidato VALUES (66008054, 'D', 54, 6008, 487, 130, 'GUILLERMO FLORES CONTRERAS', 'GUILLERMO FLORES CONTRERAS', '', false, 'None', 'GUILLERMO', 'FLORES CONTRERAS');
INSERT INTO candidato VALUES (66008055, 'D', 55, 6008, 487, 130, 'CHRISTIAN VITTORI MUÑOZ', 'CHRISTIAN VITTORI MUÑOZ', '', false, 'None', 'CHRISTIAN', 'VITTORI MUÑOZ');
INSERT INTO candidato VALUES (66008056, 'D', 56, 6008, 487, 130, 'DAVID QUEZADA GOMEZ', 'DAVID QUEZADA GOMEZ', '', false, 'None', 'DAVID', 'QUEZADA GOMEZ');
INSERT INTO candidato VALUES (66008057, 'D', 57, 6008, 487, 130, 'ERICA VELASQUEZ MONTENEGRO', 'ERICA VELASQUEZ MONTENEGRO', '', true, 'None', 'ERICA', 'VELASQUEZ MONTENEGRO');
INSERT INTO candidato VALUES (66008058, 'D', 58, 6008, 487, 130, 'JAIME CAYUQUEO ZAMBRANO', 'JAIME CAYUQUEO ZAMBRANO', '', true, 'None', 'JAIME', 'CAYUQUEO ZAMBRANO');
INSERT INTO candidato VALUES (66008059, 'D', 59, 6008, 483, 7, 'RUBEN OYARZO FIGUEROA', 'RUBEN OYARZO FIGUEROA', '', false, 'None', 'RUBEN', 'OYARZO FIGUEROA');
INSERT INTO candidato VALUES (66008060, 'D', 60, 6008, 483, 137, 'VIVIANA SOLEDAD DELGADO RIQUELME', 'VIVIANA SOLEDAD DELGADO RIQUELME', '', false, 'None', 'VIVIANA SOLEDAD', 'DELGADO RIQUELME');
INSERT INTO candidato VALUES (66008061, 'D', 61, 6008, 483, 137, 'CRISTOPHER VALDIVIA OLATE', 'CRISTOPHER VALDIVIA OLATE', '', false, 'None', 'CRISTOPHER', 'VALDIVIA OLATE');
INSERT INTO candidato VALUES (66008062, 'D', 62, 6008, 483, 6, 'GUSTAVO GATICA VILLARROEL', 'GUSTAVO GATICA VILLARROEL', '', true, 'None', 'GUSTAVO', 'GATICA VILLARROEL');
INSERT INTO candidato VALUES (66008063, 'D', 63, 6008, 483, 6, 'MARCOS BARRAZA GOMEZ', 'MARCOS BARRAZA GOMEZ', '', false, 'None', 'MARCOS', 'BARRAZA GOMEZ');
INSERT INTO candidato VALUES (66008064, 'D', 64, 6008, 483, 2, 'CLAUDIA ATENAS SOZA', 'CLAUDIA ATENAS SOZA', '', false, 'None', 'CLAUDIA', 'ATENAS SOZA');
INSERT INTO candidato VALUES (66008065, 'D', 65, 6008, 483, 2, 'JUAN CARLOS VALDIVIA LENA', 'JUAN CARLOS VALDIVIA LENA', '', true, 'None', 'JUAN CARLOS', 'VALDIVIA LENA');
INSERT INTO candidato VALUES (66008066, 'D', 66, 6008, 483, 232, 'TATIANA URRUTIA HERRERA', 'TATIANA URRUTIA HERRERA', '', false, 'None', 'TATIANA', 'URRUTIA HERRERA');
INSERT INTO candidato VALUES (66008067, 'D', 67, 6008, 483, 232, 'CLAUDIA MIX JIMENEZ', 'CLAUDIA MIX JIMENEZ', '', false, 'None', 'CLAUDIA', 'MIX JIMENEZ');
INSERT INTO candidato VALUES (66008068, 'D', 68, 6008, 481, 188, 'ELISA ANDREA ROJAS HERRERA', 'ELISA ANDREA ROJAS HERRERA', '', true, 'None', 'ELISA ANDREA', 'ROJAS HERRERA');
INSERT INTO candidato VALUES (66008069, 'D', 69, 6008, 481, 188, 'MARIA TERESA ALVAREZ AGUILAR', 'MARIA TERESA ALVAREZ AGUILAR', '', false, 'None', 'MARIA TERESA', 'ALVAREZ AGUILAR');
INSERT INTO candidato VALUES (66008070, 'D', 70, 6008, 481, 188, 'MAXIMO QUITRAL ROJAS', 'MAXIMO QUITRAL ROJAS', '', true, 'None', 'MAXIMO', 'QUITRAL ROJAS');
INSERT INTO candidato VALUES (66008071, 'D', 71, 6008, 481, 188, 'ROSSANA DEL PILAR TARSETTI GUAJARDO', 'ROSSANA DEL PILAR TARSETTI GUAJARDO', '', true, 'None', 'ROSSANA DEL PILAR', 'TARSETTI GUAJARDO');
INSERT INTO candidato VALUES (66008072, 'D', 72, 6008, 481, 188, 'PABLO ANDRES MORALES MONTOYA', 'PABLO ANDRES MORALES MONTOYA', '', true, 'None', 'PABLO ANDRES', 'MORALES MONTOYA');
INSERT INTO candidato VALUES (66008073, 'D', 73, 6008, 481, 188, 'YESSENIA LIA CRISOSTOMO VALENZUELA', 'YESSENIA LIA CRISOSTOMO VALENZUELA', '', true, 'None', 'YESSENIA LIA', 'CRISOSTOMO VALENZUELA');
INSERT INTO candidato VALUES (66008074, 'D', 74, 6008, 481, 188, 'RICHARD TAPIA FUENTES', 'RICHARD TAPIA FUENTES', '', true, 'None', 'RICHARD', 'TAPIA FUENTES');
INSERT INTO candidato VALUES (66008075, 'D', 75, 6008, 481, 188, 'AMAURI ALEN QUILALEO VALENCIA', 'AMAURI ALEN QUILALEO VALENCIA', '', true, 'None', 'AMAURI ALEN', 'QUILALEO VALENCIA');
INSERT INTO candidato VALUES (66008076, 'D', 76, 6008, 497, 220, 'FRANCISCO VLADIMIR FLORES COBO', 'FRANCISCO VLADIMIR FLORES COBO', '', false, 'None', 'FRANCISCO VLADIMIR', 'FLORES COBO');
INSERT INTO candidato VALUES (66008077, 'D', 77, 6008, 489, 157, 'CRISTIAN CONTRERAS RADOVIC', 'CRISTIAN CONTRERAS RADOVIC', '', false, 'None', 'CRISTIAN', 'CONTRERAS RADOVIC');
INSERT INTO candidato VALUES (66008078, 'D', 78, 6008, 489, 157, 'LEYLA MASSIEL JARA LOPEZ', 'LEYLA MASSIEL JARA LOPEZ', '', false, 'None', 'LEYLA MASSIEL', 'JARA LOPEZ');
INSERT INTO candidato VALUES (66008079, 'D', 79, 6008, 489, 157, 'RICHARD MATTA PARRA', 'RICHARD MATTA PARRA', '', false, 'None', 'RICHARD', 'MATTA PARRA');
INSERT INTO candidato VALUES (66008080, 'D', 80, 6008, 489, 157, 'LUCY MUÑOZ MARTICORENA', 'LUCY MUÑOZ MARTICORENA', '', false, 'None', 'LUCY', 'MUÑOZ MARTICORENA');
INSERT INTO candidato VALUES (66008081, 'D', 81, 6008, 489, 157, 'SANDRA LUZ VERGARA CASTRO', 'SANDRA LUZ VERGARA CASTRO', '', false, 'None', 'SANDRA LUZ', 'VERGARA CASTRO');
INSERT INTO candidato VALUES (66008082, 'D', 82, 6008, 489, 157, 'FELIX ENRIQUE MOLINA RIQUELME', 'FELIX ENRIQUE MOLINA RIQUELME', '', false, 'None', 'FELIX ENRIQUE', 'MOLINA RIQUELME');
INSERT INTO candidato VALUES (66008083, 'D', 83, 6008, 489, 157, 'JACQUELINE PATRICIA ALARCON BORQUEZ', 'JACQUELINE PATRICIA ALARCON BORQUEZ', '', false, 'None', 'JACQUELINE PATRICIA', 'ALARCON BORQUEZ');
INSERT INTO candidato VALUES (66008084, 'D', 84, 6008, 489, 157, 'ANDRES HENRIQUEZ RIQUELME', 'ANDRES HENRIQUEZ RIQUELME', '', false, 'None', 'ANDRES', 'HENRIQUEZ RIQUELME');
INSERT INTO candidato VALUES (66008085, 'D', 85, 6008, 485, 198, 'JORGE GALDAMES HOROSTICA', 'JORGE GALDAMES HOROSTICA', '', false, 'None', 'JORGE', 'GALDAMES HOROSTICA');
INSERT INTO candidato VALUES (66008086, 'D', 86, 6008, 485, 198, 'GONZALO EGAS POURAILLY', 'GONZALO EGAS POURAILLY', '', false, 'None', 'GONZALO', 'EGAS POURAILLY');
INSERT INTO candidato VALUES (66008087, 'D', 87, 6008, 485, 198, 'ELIZABETH CARRASCO URRUTIA', 'ELIZABETH CARRASCO URRUTIA', '', false, 'None', 'ELIZABETH', 'CARRASCO URRUTIA');
INSERT INTO candidato VALUES (66008088, 'D', 88, 6008, 485, 1, 'ROSA OYARCE SUAZO', 'ROSA OYARCE SUAZO', '', false, 'None', 'ROSA', 'OYARCE SUAZO');
INSERT INTO candidato VALUES (66008089, 'D', 89, 6008, 485, 1, 'CESAR VEGA LAZO', 'CESAR VEGA LAZO', '', false, 'None', 'CESAR', 'VEGA LAZO');
INSERT INTO candidato VALUES (66008090, 'D', 90, 6008, 485, 1, 'NATALY ORTUZAR MENDEZ', 'NATALY ORTUZAR MENDEZ', '', false, 'None', 'NATALY', 'ORTUZAR MENDEZ');
INSERT INTO candidato VALUES (66008091, 'D', 91, 6008, 485, 3, 'SEBASTIAN KEITEL RONDON', 'SEBASTIAN KEITEL RONDON', '', true, 'None', 'SEBASTIAN', 'KEITEL RONDON');
INSERT INTO candidato VALUES (66008092, 'D', 92, 6008, 485, 3, 'BEATRIZ LAGOS CAMPOS', 'BEATRIZ LAGOS CAMPOS', '', false, 'None', 'BEATRIZ', 'LAGOS CAMPOS');
INSERT INTO candidato VALUES (66008093, 'D', 93, 6008, 485, 3, 'MARIO OLAVARRIA RODRIGUEZ', 'MARIO OLAVARRIA RODRIGUEZ', '', false, 'None', 'MARIO', 'OLAVARRIA RODRIGUEZ');
INSERT INTO candidato VALUES (66008094, 'D', 94, 6008, 479, 150, 'AGUSTIN ROMERO LEIVA', 'AGUSTIN ROMERO LEIVA', '', false, 'None', 'AGUSTIN', 'ROMERO LEIVA');
INSERT INTO candidato VALUES (66008095, 'D', 95, 6008, 479, 150, 'ENRIQUE BASSALETTI RIESS', 'ENRIQUE BASSALETTI RIESS', '', true, 'None', 'ENRIQUE', 'BASSALETTI RIESS');
INSERT INTO candidato VALUES (66008096, 'D', 96, 6008, 479, 150, 'CATHERINE CEBULJ NAVARRETE', 'CATHERINE CEBULJ NAVARRETE', '', false, 'None', 'CATHERINE', 'CEBULJ NAVARRETE');
INSERT INTO candidato VALUES (66008097, 'D', 97, 6008, 479, 197, 'ENRIQUE MUÑOZ LAGOS', 'ENRIQUE MUÑOZ LAGOS', '', false, 'None', 'ENRIQUE', 'MUÑOZ LAGOS');
INSERT INTO candidato VALUES (66008098, 'D', 98, 6008, 479, 197, 'FELIPE CORVALAN DESTEFANI', 'FELIPE CORVALAN DESTEFANI', '', false, 'None', 'FELIPE', 'CORVALAN DESTEFANI');
INSERT INTO candidato VALUES (66008099, 'D', 99, 6008, 479, 235, 'ITALO OMEGNA VERGARA', 'ITALO OMEGNA VERGARA', '', false, 'None', 'ITALO', 'OMEGNA VERGARA');
INSERT INTO candidato VALUES (66008100, 'D', 100, 6008, 479, 235, 'ANITA ESCOBAR GATTAS', 'ANITA ESCOBAR GATTAS', '', true, 'None', 'ANITA', 'ESCOBAR GATTAS');
INSERT INTO candidato VALUES (66008101, 'D', 101, 6008, 479, 235, 'JUAN CARLOS GOMEZ ESCOBAR', 'JUAN CARLOS GOMEZ ESCOBAR', '', false, 'None', 'JUAN CARLOS', 'GOMEZ ESCOBAR');
INSERT INTO candidato VALUES (66008102, 'D', 102, 6008, 479, 235, 'PIER KARLEZI HAZLEBY', 'PIER KARLEZI HAZLEBY', '', false, 'None', 'PIER', 'KARLEZI HAZLEBY');
INSERT INTO candidato VALUES (66009051, 'D', 51, 6009, 487, 190, 'ALEJANDRA PEREZ ESPINA', 'ALEJANDRA PEREZ ESPINA', '', false, 'None', 'ALEJANDRA', 'PEREZ ESPINA');
INSERT INTO candidato VALUES (66009052, 'D', 52, 6009, 487, 190, 'ARIEL MATELUNA MATELUNA', 'ARIEL MATELUNA MATELUNA', '', true, 'None', 'ARIEL', 'MATELUNA MATELUNA');
INSERT INTO candidato VALUES (66009053, 'D', 53, 6009, 487, 190, 'WALESKA UBIERNA NAVARRO', 'WALESKA UBIERNA NAVARRO', '', false, 'None', 'WALESKA', 'UBIERNA NAVARRO');
INSERT INTO candidato VALUES (66009054, 'D', 54, 6009, 487, 190, 'JOSE LUIS VILLAGRAN BARAHONA', 'JOSE LUIS VILLAGRAN BARAHONA', '', true, 'None', 'JOSE LUIS', 'VILLAGRAN BARAHONA');
INSERT INTO candidato VALUES (66009055, 'D', 55, 6009, 487, 130, 'PAOLA CADIZ NUÑEZ', 'PAOLA CADIZ NUÑEZ', '', false, 'None', 'PAOLA', 'CADIZ NUÑEZ');
INSERT INTO candidato VALUES (66009056, 'D', 56, 6009, 487, 130, 'EVELYN FARIAS AILIO', 'EVELYN FARIAS AILIO', '', true, 'None', 'EVELYN', 'FARIAS AILIO');
INSERT INTO candidato VALUES (66009057, 'D', 57, 6009, 487, 130, 'JOSE SEPULVEDA ZELADA', 'JOSE SEPULVEDA ZELADA', '', true, 'None', 'JOSE', 'SEPULVEDA ZELADA');
INSERT INTO candidato VALUES (66009058, 'D', 58, 6009, 483, 232, 'ANDRES GIORDANO SALAZAR', 'ANDRES GIORDANO SALAZAR', '', false, 'None', 'ANDRES', 'GIORDANO SALAZAR');
INSERT INTO candidato VALUES (66009059, 'D', 59, 6009, 483, 232, 'LEONARDO JOFRE RIOS', 'LEONARDO JOFRE RIOS', '', false, 'None', 'LEONARDO', 'JOFRE RIOS');
INSERT INTO candidato VALUES (66009060, 'D', 60, 6009, 483, 6, 'BORIS BARRERA MORENO', 'BORIS BARRERA MORENO', '', false, 'None', 'BORIS', 'BARRERA MORENO');
INSERT INTO candidato VALUES (66009061, 'D', 61, 6009, 483, 5, 'CAROLA RIVERO CANALES', 'CAROLA RIVERO CANALES', '', false, 'None', 'CAROLA', 'RIVERO CANALES');
INSERT INTO candidato VALUES (66009062, 'D', 62, 6009, 483, 5, 'CESAR VALENZUELA MAASS', 'CESAR VALENZUELA MAASS', '', false, 'None', 'CESAR', 'VALENZUELA MAASS');
INSERT INTO candidato VALUES (66009063, 'D', 63, 6009, 483, 4, 'SANDRA GONZALEZ ZAMORANO', 'SANDRA GONZALEZ ZAMORANO', '', true, 'None', 'SANDRA', 'GONZALEZ ZAMORANO');
INSERT INTO candidato VALUES (66009064, 'D', 64, 6009, 483, 4, 'CARLOS CUADRADO PRATS', 'CARLOS CUADRADO PRATS', '', false, 'None', 'CARLOS', 'CUADRADO PRATS');
INSERT INTO candidato VALUES (66009065, 'D', 65, 6009, 481, 188, 'AMELIA DEL CARMEN GALLEGOS RAMIREZ', 'AMELIA DEL CARMEN GALLEGOS RAMIREZ', '', false, 'None', 'AMELIA DEL CARMEN', 'GALLEGOS RAMIREZ');
INSERT INTO candidato VALUES (66009066, 'D', 66, 6009, 481, 188, 'VIVIANA MONTECINOS SUAZO', 'VIVIANA MONTECINOS SUAZO', '', true, 'None', 'VIVIANA', 'MONTECINOS SUAZO');
INSERT INTO candidato VALUES (66009067, 'D', 67, 6009, 481, 188, 'ADRIAN ANTONIO LIZAMA BARRA', 'ADRIAN ANTONIO LIZAMA BARRA', '', true, 'None', 'ADRIAN ANTONIO', 'LIZAMA BARRA');
INSERT INTO candidato VALUES (66009068, 'D', 68, 6009, 481, 188, 'JUAN ANDRES PINO MADRID', 'JUAN ANDRES PINO MADRID', '', true, 'None', 'JUAN ANDRES', 'PINO MADRID');
INSERT INTO candidato VALUES (66009069, 'D', 69, 6009, 481, 188, 'SERGIO ENRIQUE FLORES RAMIREZ', 'SERGIO ENRIQUE FLORES RAMIREZ', '', true, 'None', 'SERGIO ENRIQUE', 'FLORES RAMIREZ');
INSERT INTO candidato VALUES (66009070, 'D', 70, 6009, 481, 188, 'ESTER BARRIENTOS VARGAS', 'ESTER BARRIENTOS VARGAS', '', true, 'None', 'ESTER', 'BARRIENTOS VARGAS');
INSERT INTO candidato VALUES (66009071, 'D', 71, 6009, 481, 188, 'LUIS ALBERTO DONOSO URIBE', 'LUIS ALBERTO DONOSO URIBE', '', true, 'None', 'LUIS ALBERTO', 'DONOSO URIBE');
INSERT INTO candidato VALUES (66009072, 'D', 72, 6009, 493, 200, 'MANUEL ENRIQUE MUÑOZ PALACIOS', 'MANUEL ENRIQUE MUÑOZ PALACIOS', '', false, 'None', 'MANUEL ENRIQUE', 'MUÑOZ PALACIOS');
INSERT INTO candidato VALUES (66009073, 'D', 73, 6009, 493, 200, 'XUXA ALVAREZ FERNANDEZ', 'XUXA ALVAREZ FERNANDEZ', '', false, 'None', 'XUXA', 'ALVAREZ FERNANDEZ');
INSERT INTO candidato VALUES (66009074, 'D', 74, 6009, 493, 200, 'JOSE GUILLERMO ROJAS INOSTROZA', 'JOSE GUILLERMO ROJAS INOSTROZA', '', false, 'None', 'JOSE GUILLERMO', 'ROJAS INOSTROZA');
INSERT INTO candidato VALUES (66009075, 'D', 75, 6009, 493, 200, 'ISABEL PALMA PALMA', 'ISABEL PALMA PALMA', '', false, 'None', 'ISABEL', 'PALMA PALMA');
INSERT INTO candidato VALUES (66009076, 'D', 76, 6009, 493, 200, 'MARIA ELENA VALENZUELA PINO', 'MARIA ELENA VALENZUELA PINO', '', false, 'None', 'MARIA ELENA', 'VALENZUELA PINO');
INSERT INTO candidato VALUES (66009077, 'D', 77, 6009, 493, 200, 'LORENZO LEPIN ARANEDA', 'LORENZO LEPIN ARANEDA', '', false, 'None', 'LORENZO', 'LEPIN ARANEDA');
INSERT INTO candidato VALUES (66009078, 'D', 78, 6009, 493, 200, 'DANIEL EDUARDO CANTO GONZALEZ', 'DANIEL EDUARDO CANTO GONZALEZ', '', false, 'None', 'DANIEL EDUARDO', 'CANTO GONZALEZ');
INSERT INTO candidato VALUES (66009079, 'D', 79, 6009, 493, 200, 'ROBERTO LOBOS VILLASECA', 'ROBERTO LOBOS VILLASECA', '', false, 'None', 'ROBERTO', 'LOBOS VILLASECA');
INSERT INTO candidato VALUES (66009080, 'D', 80, 6009, 489, 157, 'TAMARA ALEJANDRA RAMIREZ RAMIREZ', 'TAMARA ALEJANDRA RAMIREZ RAMIREZ', '', false, 'None', 'TAMARA ALEJANDRA', 'RAMIREZ RAMIREZ');
INSERT INTO candidato VALUES (66009081, 'D', 81, 6009, 489, 157, 'ANDRES RIGOBERTO CACERES BRAVO', 'ANDRES RIGOBERTO CACERES BRAVO', '', false, 'None', 'ANDRES RIGOBERTO', 'CACERES BRAVO');
INSERT INTO candidato VALUES (66009082, 'D', 82, 6009, 489, 157, 'PAMELA DEL TRANSITO AMARO ARAYA', 'PAMELA DEL TRANSITO AMARO ARAYA', '', false, 'None', 'PAMELA DEL TRANSITO', 'AMARO ARAYA');
INSERT INTO candidato VALUES (66009083, 'D', 83, 6009, 489, 157, 'FRANCISCO JAVIER LIZANA DONOSO', 'FRANCISCO JAVIER LIZANA DONOSO', '', false, 'None', 'FRANCISCO JAVIER', 'LIZANA DONOSO');
INSERT INTO candidato VALUES (66009084, 'D', 84, 6009, 489, 157, 'CESAR ABRAHAM SUAY JEREZ', 'CESAR ABRAHAM SUAY JEREZ', '', false, 'None', 'CESAR ABRAHAM', 'SUAY JEREZ');
INSERT INTO candidato VALUES (66009085, 'D', 85, 6009, 489, 157, 'MARIA SOLEDAD LIEMPAN APELEO', 'MARIA SOLEDAD LIEMPAN APELEO', '', false, 'None', 'MARIA SOLEDAD', 'LIEMPAN APELEO');
INSERT INTO candidato VALUES (66009086, 'D', 86, 6009, 489, 157, 'CRESCENCIO ALBERTO LOPEZ PEREZ', 'CRESCENCIO ALBERTO LOPEZ PEREZ', '', false, 'None', 'CRESCENCIO ALBERTO', 'LOPEZ PEREZ');
INSERT INTO candidato VALUES (66009087, 'D', 87, 6009, 489, 157, 'CHRISTOPHER ELIAS YAÑEZ LEAL', 'CHRISTOPHER ELIAS YAÑEZ LEAL', '', false, 'None', 'CHRISTOPHER ELIAS', 'YAÑEZ LEAL');
INSERT INTO candidato VALUES (66009088, 'D', 88, 6009, 485, 3, 'GUILLERMO RAMIREZ DIEZ', 'GUILLERMO RAMIREZ DIEZ', '', false, 'None', 'GUILLERMO', 'RAMIREZ DIEZ');
INSERT INTO candidato VALUES (66009089, 'D', 89, 6009, 485, 3, 'JOSE MIGUEL GONZALEZ ZAPATA', 'JOSE MIGUEL GONZALEZ ZAPATA', '', false, 'None', 'JOSE MIGUEL', 'GONZALEZ ZAPATA');
INSERT INTO candidato VALUES (66009090, 'D', 90, 6009, 485, 198, 'ERIKA OLIVERA DE LA FUENTE', 'ERIKA OLIVERA DE LA FUENTE', '', false, 'None', 'ERIKA', 'OLIVERA DE LA FUENTE');
INSERT INTO candidato VALUES (66009091, 'D', 91, 6009, 485, 198, 'VERONICA MONTECINOS ORTIZ', 'VERONICA MONTECINOS ORTIZ', '', false, 'None', 'VERONICA', 'MONTECINOS ORTIZ');
INSERT INTO candidato VALUES (66009092, 'D', 92, 6009, 485, 1, 'ALDO DUQUE SANTOS', 'ALDO DUQUE SANTOS', '', true, 'None', 'ALDO', 'DUQUE SANTOS');
INSERT INTO candidato VALUES (66009093, 'D', 93, 6009, 485, 1, 'MARIA ELENA BARCO SANCHEZ', 'MARIA ELENA BARCO SANCHEZ', '', false, 'None', 'MARIA ELENA', 'BARCO SANCHEZ');
INSERT INTO candidato VALUES (66009094, 'D', 94, 6009, 485, 37, 'FELIPE VIDAL CUEVAS', 'FELIPE VIDAL CUEVAS', '', true, 'None', 'FELIPE', 'VIDAL CUEVAS');
INSERT INTO candidato VALUES (66009095, 'D', 95, 6009, 485, 37, 'JUAN MANUEL SANTA CRUZ CAMPAÑA', 'JUAN MANUEL SANTA CRUZ CAMPAÑA', '', false, 'None', 'JUAN MANUEL', 'SANTA CRUZ CAMPAÑA');
INSERT INTO candidato VALUES (66009096, 'D', 96, 6009, 479, 150, 'JOSE CARLOS MEZA PEREIRA', 'JOSE CARLOS MEZA PEREIRA', '', false, 'None', 'JOSE CARLOS', 'MEZA PEREIRA');
INSERT INTO candidato VALUES (66009097, 'D', 97, 6009, 479, 150, 'MACARENA GARCIA-HUIDOBRO LLORT', 'MACARENA GARCIA-HUIDOBRO LLORT', '', false, 'None', 'MACARENA', 'GARCIA-HUIDOBRO LLORT');
INSERT INTO candidato VALUES (66009098, 'D', 98, 6009, 479, 150, 'JAVIERA RODRIGUEZ PASCUAL', 'JAVIERA RODRIGUEZ PASCUAL', '', false, 'None', 'JAVIERA', 'RODRIGUEZ PASCUAL');
INSERT INTO candidato VALUES (66009099, 'D', 99, 6009, 479, 235, 'MAXIMILIANO MURATH MANSILLA', 'MAXIMILIANO MURATH MANSILLA', '', false, 'None', 'MAXIMILIANO', 'MURATH MANSILLA');
INSERT INTO candidato VALUES (66009100, 'D', 100, 6009, 479, 235, 'MARGARITA GARRIDO ACEVEDO', 'MARGARITA GARRIDO ACEVEDO', '', false, 'None', 'MARGARITA', 'GARRIDO ACEVEDO');
INSERT INTO candidato VALUES (66009101, 'D', 101, 6009, 479, 197, 'VALESKA OYARCE PEÑA', 'VALESKA OYARCE PEÑA', '', false, 'None', 'VALESKA', 'OYARCE PEÑA');
INSERT INTO candidato VALUES (66009102, 'D', 102, 6009, 479, 197, 'ALBERTO SEGUEL MENA', 'ALBERTO SEGUEL MENA', '', false, 'None', 'ALBERTO', 'SEGUEL MENA');
INSERT INTO candidato VALUES (66009103, 'D', 103, 6009, 479, 197, 'CAROLINA GARATE VERGARA', 'CAROLINA GARATE VERGARA', '', false, 'None', 'CAROLINA', 'GARATE VERGARA');
INSERT INTO candidato VALUES (66010051, 'D', 51, 6010, 487, 190, 'FRANCISCO ESTEVEZ VALENCIA', 'FRANCISCO ESTEVEZ VALENCIA', '', true, 'None', 'FRANCISCO', 'ESTEVEZ VALENCIA');
INSERT INTO candidato VALUES (66010052, 'D', 52, 6010, 487, 190, 'GLORIA CAROLINA PEREZ SEPULVEDA', 'GLORIA CAROLINA PEREZ SEPULVEDA', '', true, 'None', 'GLORIA CAROLINA', 'PEREZ SEPULVEDA');
INSERT INTO candidato VALUES (66010053, 'D', 53, 6010, 487, 190, 'CLAUDIA RUIZ MONTECINO', 'CLAUDIA RUIZ MONTECINO', '', true, 'None', 'CLAUDIA', 'RUIZ MONTECINO');
INSERT INTO candidato VALUES (66010054, 'D', 54, 6010, 487, 190, 'LUIS MARIANO RENDON ESCOBAR', 'LUIS MARIANO RENDON ESCOBAR', '', true, 'None', 'LUIS MARIANO', 'RENDON ESCOBAR');
INSERT INTO candidato VALUES (66010055, 'D', 55, 6010, 487, 130, 'CLAUDIA RUZ ROTHEN', 'CLAUDIA RUZ ROTHEN', '', false, 'None', 'CLAUDIA', 'RUZ ROTHEN');
INSERT INTO candidato VALUES (66010056, 'D', 56, 6010, 487, 130, 'ANTONIO ARRIAGADA JURE', 'ANTONIO ARRIAGADA JURE', '', true, 'None', 'ANTONIO', 'ARRIAGADA JURE');
INSERT INTO candidato VALUES (66010057, 'D', 57, 6010, 487, 130, 'JAVIERA GONZALEZ ARENAS', 'JAVIERA GONZALEZ ARENAS', '', false, 'None', 'JAVIERA', 'GONZALEZ ARENAS');
INSERT INTO candidato VALUES (66010058, 'D', 58, 6010, 487, 130, 'KATHERINE PEREZ CONTRERAS', 'KATHERINE PEREZ CONTRERAS', '', true, 'None', 'KATHERINE', 'PEREZ CONTRERAS');
INSERT INTO candidato VALUES (66010059, 'D', 59, 6010, 487, 130, 'MARCIA SOTO DIAZ', 'MARCIA SOTO DIAZ', '', true, 'None', 'MARCIA', 'SOTO DIAZ');
INSERT INTO candidato VALUES (66010060, 'D', 60, 6010, 483, 232, 'GONZALO WINTER ETCHEBERRY', 'GONZALO WINTER ETCHEBERRY', '', false, 'None', 'GONZALO', 'WINTER ETCHEBERRY');
INSERT INTO candidato VALUES (66010061, 'D', 61, 6010, 483, 232, 'EMILIA SCHNEIDER VIDELA', 'EMILIA SCHNEIDER VIDELA', '', false, 'None', 'EMILIA', 'SCHNEIDER VIDELA');
INSERT INTO candidato VALUES (66010062, 'D', 62, 6010, 483, 232, 'LORENA FRIES MONLEON', 'LORENA FRIES MONLEON', '', false, 'None', 'LORENA', 'FRIES MONLEON');
INSERT INTO candidato VALUES (66010063, 'D', 63, 6010, 483, 6, 'ALEJANDRA PLACENCIA CABELLO', 'ALEJANDRA PLACENCIA CABELLO', '', false, 'None', 'ALEJANDRA', 'PLACENCIA CABELLO');
INSERT INTO candidato VALUES (66010064, 'D', 64, 6010, 483, 6, 'IRACI HASSLER JACOB', 'IRACI HASSLER JACOB', '', false, 'None', 'IRACI', 'HASSLER JACOB');
INSERT INTO candidato VALUES (66010065, 'D', 65, 6010, 483, 5, 'FERNANDA VILLEGAS ACEVEDO', 'FERNANDA VILLEGAS ACEVEDO', '', false, 'None', 'FERNANDA', 'VILLEGAS ACEVEDO');
INSERT INTO candidato VALUES (66010066, 'D', 66, 6010, 483, 2, 'ANA MARIA HERNANDEZ SAN MARTIN', 'ANA MARIA HERNANDEZ SAN MARTIN', '', false, 'None', 'ANA MARIA', 'HERNANDEZ SAN MARTIN');
INSERT INTO candidato VALUES (66010067, 'D', 67, 6010, 483, 4, 'HELIA MOLINA MILMAN', 'HELIA MOLINA MILMAN', '', false, 'None', 'HELIA', 'MOLINA MILMAN');
INSERT INTO candidato VALUES (66010068, 'D', 68, 6010, 483, 4, 'JOSE TORO KEMP', 'JOSE TORO KEMP', '', false, 'None', 'JOSE', 'TORO KEMP');
INSERT INTO candidato VALUES (66010069, 'D', 69, 6010, 481, 188, 'CELESTE JIMENEZ RIVEROS', 'CELESTE JIMENEZ RIVEROS', '', true, 'None', 'CELESTE', 'JIMENEZ RIVEROS');
INSERT INTO candidato VALUES (66010070, 'D', 70, 6010, 481, 188, 'ALFREDO GROSSI ROBLES', 'ALFREDO GROSSI ROBLES', '', true, 'None', 'ALFREDO', 'GROSSI ROBLES');
INSERT INTO candidato VALUES (66010071, 'D', 71, 6010, 481, 188, 'DANIELA KING REYES', 'DANIELA KING REYES', '', true, 'None', 'DANIELA', 'KING REYES');
INSERT INTO candidato VALUES (66010072, 'D', 72, 6010, 481, 188, 'GARY JAVIER NUÑEZ ORDOÑA', 'GARY JAVIER NUÑEZ ORDOÑA', '', false, 'None', 'GARY JAVIER', 'NUÑEZ ORDOÑA');
INSERT INTO candidato VALUES (66010073, 'D', 73, 6010, 481, 188, 'JORGE PALMA ACUÑA', 'JORGE PALMA ACUÑA', '', true, 'None', 'JORGE', 'PALMA ACUÑA');
INSERT INTO candidato VALUES (66010074, 'D', 74, 6010, 481, 188, 'MATIAS JORGE REYES VARGAS', 'MATIAS JORGE REYES VARGAS', '', true, 'None', 'MATIAS JORGE', 'REYES VARGAS');
INSERT INTO candidato VALUES (66010075, 'D', 75, 6010, 481, 188, 'CAROLINA VENEGAS RIVERA', 'CAROLINA VENEGAS RIVERA', '', true, 'None', 'CAROLINA', 'VENEGAS RIVERA');
INSERT INTO candidato VALUES (66010076, 'D', 76, 6010, 481, 188, 'IBAR NICOLAS ZEPEDA ALCOTA', 'IBAR NICOLAS ZEPEDA ALCOTA', '', false, 'None', 'IBAR NICOLAS', 'ZEPEDA ALCOTA');
INSERT INTO candidato VALUES (66010077, 'D', 77, 6010, 497, 220, 'DAUNO TOTORO NAVARRO', 'DAUNO TOTORO NAVARRO', '', false, 'None', 'DAUNO', 'TOTORO NAVARRO');
INSERT INTO candidato VALUES (66010078, 'D', 78, 6010, 497, 220, 'JOSEFFE TAMARA CACERES TORRES', 'JOSEFFE TAMARA CACERES TORRES', '', false, 'None', 'JOSEFFE TAMARA', 'CACERES TORRES');
INSERT INTO candidato VALUES (66010079, 'D', 79, 6010, 497, 220, 'FABIAN ERNESTO PUELMA MULLER', 'FABIAN ERNESTO PUELMA MULLER', '', false, 'None', 'FABIAN ERNESTO', 'PUELMA MULLER');
INSERT INTO candidato VALUES (66010080, 'D', 80, 6010, 497, 220, 'BARBARA BELEN BRITO CARRASCO', 'BARBARA BELEN BRITO CARRASCO', '', false, 'None', 'BARBARA BELEN', 'BRITO CARRASCO');
INSERT INTO candidato VALUES (66010081, 'D', 81, 6010, 497, 220, 'YURI ERNESTO PEÑA JIMENEZ', 'YURI ERNESTO PEÑA JIMENEZ', '', false, 'None', 'YURI ERNESTO', 'PEÑA JIMENEZ');
INSERT INTO candidato VALUES (66010082, 'D', 82, 6010, 497, 220, 'VALERIA PAZ YAÑEZ ALVAREZ', 'VALERIA PAZ YAÑEZ ALVAREZ', '', false, 'None', 'VALERIA PAZ', 'YAÑEZ ALVAREZ');
INSERT INTO candidato VALUES (66010083, 'D', 83, 6010, 497, 220, 'JULIO HUMBERTO MANCILLA MARABOLI', 'JULIO HUMBERTO MANCILLA MARABOLI', '', false, 'None', 'JULIO HUMBERTO', 'MANCILLA MARABOLI');
INSERT INTO candidato VALUES (66010084, 'D', 84, 6010, 497, 220, 'CLAUDIA ANDREA TASSARA RUILOVA', 'CLAUDIA ANDREA TASSARA RUILOVA', '', false, 'None', 'CLAUDIA ANDREA', 'TASSARA RUILOVA');
INSERT INTO candidato VALUES (66010085, 'D', 85, 6010, 497, 220, 'YAMILA DE LOURDES MARTINEZ URRUTIA', 'YAMILA DE LOURDES MARTINEZ URRUTIA', '', false, 'None', 'YAMILA DE LOURDES', 'MARTINEZ URRUTIA');
INSERT INTO candidato VALUES (66010086, 'D', 86, 6010, 493, 200, 'NICOL AGUILERA ORTIZ', 'NICOL AGUILERA ORTIZ', '', false, 'None', 'NICOL', 'AGUILERA ORTIZ');
INSERT INTO candidato VALUES (66010087, 'D', 87, 6010, 493, 200, 'HECTOR SOTO GALLARDO', 'HECTOR SOTO GALLARDO', '', false, 'None', 'HECTOR', 'SOTO GALLARDO');
INSERT INTO candidato VALUES (66010088, 'D', 88, 6010, 493, 200, 'SOFIA MARIELA GONZALEZ PERALTA', 'SOFIA MARIELA GONZALEZ PERALTA', '', false, 'None', 'SOFIA MARIELA', 'GONZALEZ PERALTA');
INSERT INTO candidato VALUES (66010089, 'D', 89, 6010, 493, 200, 'CATALINA MILITZA DURAN CHANAN', 'CATALINA MILITZA DURAN CHANAN', '', false, 'None', 'CATALINA MILITZA', 'DURAN CHANAN');
INSERT INTO candidato VALUES (66010090, 'D', 90, 6010, 493, 200, 'CESAR LORCA HIDALGO', 'CESAR LORCA HIDALGO', '', false, 'None', 'CESAR', 'LORCA HIDALGO');
INSERT INTO candidato VALUES (66010091, 'D', 91, 6010, 493, 200, 'NELLA REYES VALLEJOS', 'NELLA REYES VALLEJOS', '', false, 'None', 'NELLA', 'REYES VALLEJOS');
INSERT INTO candidato VALUES (66010092, 'D', 92, 6010, 493, 200, 'JESSICA SAINT-PIERRE COLLADO', 'JESSICA SAINT-PIERRE COLLADO', '', false, 'None', 'JESSICA', 'SAINT-PIERRE COLLADO');
INSERT INTO candidato VALUES (66010093, 'D', 93, 6010, 493, 200, 'BELEN JESUS CARVAJAL ZUÑIGA', 'BELEN JESUS CARVAJAL ZUÑIGA', '', false, 'None', 'BELEN JESUS', 'CARVAJAL ZUÑIGA');
INSERT INTO candidato VALUES (66010094, 'D', 94, 6010, 493, 200, 'ANDRES URZUA CORVALAN', 'ANDRES URZUA CORVALAN', '', false, 'None', 'ANDRES', 'URZUA CORVALAN');
INSERT INTO candidato VALUES (66010095, 'D', 95, 6010, 489, 157, 'KAREN OSORIO MUÑOZ', 'KAREN OSORIO MUÑOZ', '', false, 'None', 'KAREN', 'OSORIO MUÑOZ');
INSERT INTO candidato VALUES (66010096, 'D', 96, 6010, 489, 157, 'GIANNY CONTENLA OJEDA', 'GIANNY CONTENLA OJEDA', '', false, 'None', 'GIANNY', 'CONTENLA OJEDA');
INSERT INTO candidato VALUES (66010097, 'D', 97, 6010, 489, 157, 'ALEJANDRA JARA QUIROZ', 'ALEJANDRA JARA QUIROZ', '', false, 'None', 'ALEJANDRA', 'JARA QUIROZ');
INSERT INTO candidato VALUES (66010098, 'D', 98, 6010, 489, 157, 'ANDREA DEL PILAR HERRERA CACHAÑA', 'ANDREA DEL PILAR HERRERA CACHAÑA', '', false, 'None', 'ANDREA DEL PILAR', 'HERRERA CACHAÑA');
INSERT INTO candidato VALUES (66010099, 'D', 99, 6010, 489, 157, 'BARBARA MOLINA SILVA', 'BARBARA MOLINA SILVA', '', false, 'None', 'BARBARA', 'MOLINA SILVA');
INSERT INTO candidato VALUES (66010100, 'D', 100, 6010, 489, 157, 'FRANCISCA ANDREA ACEVEDO LEON', 'FRANCISCA ANDREA ACEVEDO LEON', '', false, 'None', 'FRANCISCA ANDREA', 'ACEVEDO LEON');
INSERT INTO candidato VALUES (66010101, 'D', 101, 6010, 489, 157, 'BETZABE PATRICIA VIGORENA NUÑEZ', 'BETZABE PATRICIA VIGORENA NUÑEZ', '', false, 'None', 'BETZABE PATRICIA', 'VIGORENA NUÑEZ');
INSERT INTO candidato VALUES (66010102, 'D', 102, 6010, 489, 157, 'JASMIN NICOLE OSORIO CESPED', 'JASMIN NICOLE OSORIO CESPED', '', false, 'None', 'JASMIN NICOLE', 'OSORIO CESPED');
INSERT INTO candidato VALUES (66010103, 'D', 103, 6010, 489, 157, 'FRANCISCO JAVIER PATIÑO TOBAR', 'FRANCISCO JAVIER PATIÑO TOBAR', '', false, 'None', 'FRANCISCO JAVIER', 'PATIÑO TOBAR');
INSERT INTO candidato VALUES (66010104, 'D', 104, 6010, 485, 3, 'JORGE ALESSANDRI VERGARA', 'JORGE ALESSANDRI VERGARA', '', false, 'None', 'JORGE', 'ALESSANDRI VERGARA');
INSERT INTO candidato VALUES (66010105, 'D', 105, 6010, 485, 3, 'MACARENA ZARHI CORDERO', 'MACARENA ZARHI CORDERO', '', true, 'None', 'MACARENA', 'ZARHI CORDERO');
INSERT INTO candidato VALUES (66010106, 'D', 106, 6010, 485, 3, 'MARIA JESUS SCHWERTER CABEZAS', 'MARIA JESUS SCHWERTER CABEZAS', '', false, 'None', 'MARIA JESUS', 'SCHWERTER CABEZAS');
INSERT INTO candidato VALUES (66010107, 'D', 107, 6010, 485, 198, 'JUAN PABLO SAEZ REY', 'JUAN PABLO SAEZ REY', '', true, 'None', 'JUAN PABLO', 'SAEZ REY');
INSERT INTO candidato VALUES (66010108, 'D', 108, 6010, 485, 198, 'VICENTE ALMONACID HEYL', 'VICENTE ALMONACID HEYL', '', true, 'None', 'VICENTE', 'ALMONACID HEYL');
INSERT INTO candidato VALUES (66010109, 'D', 109, 6010, 485, 198, 'SANDRA SOLIMANO LATORRE', 'SANDRA SOLIMANO LATORRE', '', true, 'None', 'SANDRA', 'SOLIMANO LATORRE');
INSERT INTO candidato VALUES (66010110, 'D', 110, 6010, 485, 1, 'MARIA LUISA CORDERO VELASQUEZ', 'MARIA LUISA CORDERO VELASQUEZ', '', true, 'None', 'MARIA LUISA', 'CORDERO VELASQUEZ');
INSERT INTO candidato VALUES (66010111, 'D', 111, 6010, 485, 1, 'JOHANNA OLIVARES GRIBBELL', 'JOHANNA OLIVARES GRIBBELL', '', false, 'None', 'JOHANNA', 'OLIVARES GRIBBELL');
INSERT INTO candidato VALUES (66010112, 'D', 112, 6010, 485, 1, 'FRANCISCO ORREGO GUTIERREZ', 'FRANCISCO ORREGO GUTIERREZ', '', false, 'None', 'FRANCISCO', 'ORREGO GUTIERREZ');
INSERT INTO candidato VALUES (66010113, 'D', 113, 6010, 479, 235, 'HANS MAROWSKI CUEVAS', 'HANS MAROWSKI CUEVAS', '', false, 'None', 'HANS', 'MAROWSKI CUEVAS');
INSERT INTO candidato VALUES (66010114, 'D', 114, 6010, 479, 235, 'LETICIA ARAYA AHUMADA', 'LETICIA ARAYA AHUMADA', '', false, 'None', 'LETICIA', 'ARAYA AHUMADA');
INSERT INTO candidato VALUES (66010115, 'D', 115, 6010, 479, 235, 'FRANCO FRIAS GUTIERREZ', 'FRANCO FRIAS GUTIERREZ', '', false, 'None', 'FRANCO', 'FRIAS GUTIERREZ');
INSERT INTO candidato VALUES (66010116, 'D', 116, 6010, 479, 235, 'EVELYN HERNANDEZ FLORES', 'EVELYN HERNANDEZ FLORES', '', false, 'None', 'EVELYN', 'HERNANDEZ FLORES');
INSERT INTO candidato VALUES (66010117, 'D', 117, 6010, 479, 197, 'JEAN BONVALLET SETTI', 'JEAN BONVALLET SETTI', '', true, 'None', 'JEAN', 'BONVALLET SETTI');
INSERT INTO candidato VALUES (66010118, 'D', 118, 6010, 479, 197, 'GINO LORENZINI BARRIOS', 'GINO LORENZINI BARRIOS', '', true, 'None', 'GINO', 'LORENZINI BARRIOS');
INSERT INTO candidato VALUES (66010119, 'D', 119, 6010, 479, 150, 'MATIAS BELLOLIO MERINO', 'MATIAS BELLOLIO MERINO', '', false, 'None', 'MATIAS', 'BELLOLIO MERINO');
INSERT INTO candidato VALUES (66010120, 'D', 120, 6010, 479, 150, 'ABIGAIL ABURTO CARDENAS', 'ABIGAIL ABURTO CARDENAS', '', true, 'None', 'ABIGAIL', 'ABURTO CARDENAS');
INSERT INTO candidato VALUES (66010121, 'D', 121, 6010, 479, 150, 'JOSE ANTONIO KAST ADRIASOLA', 'JOSE ANTONIO KAST ADRIASOLA', '', false, 'None', 'JOSE ANTONIO', 'KAST ADRIASOLA');
INSERT INTO candidato VALUES (66011051, 'D', 51, 6011, 487, 190, 'TOMAS HIRSCH GOLDSCHMIDT', 'TOMAS HIRSCH GOLDSCHMIDT', '', false, 'None', 'TOMAS', 'HIRSCH GOLDSCHMIDT');
INSERT INTO candidato VALUES (66011052, 'D', 52, 6011, 487, 190, 'ELIZABETH CONTRERAS BECERRA', 'ELIZABETH CONTRERAS BECERRA', '', true, 'None', 'ELIZABETH', 'CONTRERAS BECERRA');
INSERT INTO candidato VALUES (66011053, 'D', 53, 6011, 487, 190, 'CATALINA VIDAL MENDEZ', 'CATALINA VIDAL MENDEZ', '', false, 'None', 'CATALINA', 'VIDAL MENDEZ');
INSERT INTO candidato VALUES (66011054, 'D', 54, 6011, 487, 190, 'PEDRO  DAVIS URZUA', 'PEDRO  DAVIS URZUA', '', true, 'None', 'PEDRO ', 'DAVIS URZUA');
INSERT INTO candidato VALUES (66011055, 'D', 55, 6011, 487, 190, 'MYRIAM MEZA ANCATEN', 'MYRIAM MEZA ANCATEN', '', false, 'None', 'MYRIAM', 'MEZA ANCATEN');
INSERT INTO candidato VALUES (66011056, 'D', 56, 6011, 487, 130, 'GERMAN ROJAS VOLMAR', 'GERMAN ROJAS VOLMAR', '', false, 'None', 'GERMAN', 'ROJAS VOLMAR');
INSERT INTO candidato VALUES (66011057, 'D', 57, 6011, 487, 130, 'MELINA GIANELLI ALTAMIRANO', 'MELINA GIANELLI ALTAMIRANO', '', false, 'None', 'MELINA', 'GIANELLI ALTAMIRANO');
INSERT INTO candidato VALUES (66011058, 'D', 58, 6011, 483, 137, 'RODRIGO ALFONSO RETTIG VARGAS', 'RODRIGO ALFONSO RETTIG VARGAS', '', false, 'None', 'RODRIGO ALFONSO', 'RETTIG VARGAS');
INSERT INTO candidato VALUES (66011059, 'D', 59, 6011, 483, 137, 'MARCELA HEVIA CUBILLOS', 'MARCELA HEVIA CUBILLOS', '', true, 'None', 'MARCELA', 'HEVIA CUBILLOS');
INSERT INTO candidato VALUES (66011060, 'D', 60, 6011, 483, 232, 'CONSTANZA SCHONHAUT SOTO', 'CONSTANZA SCHONHAUT SOTO', '', false, 'None', 'CONSTANZA', 'SCHONHAUT SOTO');
INSERT INTO candidato VALUES (66011061, 'D', 61, 6011, 483, 232, 'ISIDORA ALCALDE EGAÑA', 'ISIDORA ALCALDE EGAÑA', '', false, 'None', 'ISIDORA', 'ALCALDE EGAÑA');
INSERT INTO candidato VALUES (66011062, 'D', 62, 6011, 483, 4, 'CINDY SOLIS IBARRA', 'CINDY SOLIS IBARRA', '', true, 'None', 'CINDY', 'SOLIS IBARRA');
INSERT INTO candidato VALUES (66011063, 'D', 63, 6011, 483, 7, 'MARIA ESTER OLEA RODRIGUEZ', 'MARIA ESTER OLEA RODRIGUEZ', '', false, 'None', 'MARIA ESTER', 'OLEA RODRIGUEZ');
INSERT INTO candidato VALUES (66011064, 'D', 64, 6011, 483, 2, 'CECILIA CELIS AHUMADA', 'CECILIA CELIS AHUMADA', '', false, 'None', 'CECILIA', 'CELIS AHUMADA');
INSERT INTO candidato VALUES (66011065, 'D', 65, 6011, 481, 188, 'NELSON NICOLAS PEÑA GALLARDO', 'NELSON NICOLAS PEÑA GALLARDO', '', false, 'None', 'NELSON NICOLAS', 'PEÑA GALLARDO');
INSERT INTO candidato VALUES (66011066, 'D', 66, 6011, 481, 188, 'GUILLERMO GONZALEZ CASTRO', 'GUILLERMO GONZALEZ CASTRO', '', true, 'None', 'GUILLERMO', 'GONZALEZ CASTRO');
INSERT INTO candidato VALUES (66011067, 'D', 67, 6011, 481, 188, 'MARIA ANGELICA ROMERO DONOSO', 'MARIA ANGELICA ROMERO DONOSO', '', false, 'None', 'MARIA ANGELICA', 'ROMERO DONOSO');
INSERT INTO candidato VALUES (66011068, 'D', 68, 6011, 481, 188, 'ELIO ZARATE MORAGA', 'ELIO ZARATE MORAGA', '', true, 'None', 'ELIO', 'ZARATE MORAGA');
INSERT INTO candidato VALUES (66011069, 'D', 69, 6011, 481, 188, 'NICOLAS ANDRES ROMERO REEVES', 'NICOLAS ANDRES ROMERO REEVES', '', true, 'None', 'NICOLAS ANDRES', 'ROMERO REEVES');
INSERT INTO candidato VALUES (66011070, 'D', 70, 6011, 481, 188, 'NINOSKA HENRIQUEZ ARAYA', 'NINOSKA HENRIQUEZ ARAYA', '', true, 'None', 'NINOSKA', 'HENRIQUEZ ARAYA');
INSERT INTO candidato VALUES (66011071, 'D', 71, 6011, 481, 188, 'ELIZABETH TUDELA CRUZ', 'ELIZABETH TUDELA CRUZ', '', false, 'None', 'ELIZABETH', 'TUDELA CRUZ');
INSERT INTO candidato VALUES (66011072, 'D', 72, 6011, 493, 200, 'IGOR CONTRERAS JERIA', 'IGOR CONTRERAS JERIA', '', false, 'None', 'IGOR', 'CONTRERAS JERIA');
INSERT INTO candidato VALUES (66011073, 'D', 73, 6011, 493, 200, 'PAULA HUECHAQUEO ROJAS', 'PAULA HUECHAQUEO ROJAS', '', false, 'None', 'PAULA', 'HUECHAQUEO ROJAS');
INSERT INTO candidato VALUES (66011074, 'D', 74, 6011, 489, 157, 'RICARDO ANDRES AVILES RUBILAR', 'RICARDO ANDRES AVILES RUBILAR', '', false, 'None', 'RICARDO ANDRES', 'AVILES RUBILAR');
INSERT INTO candidato VALUES (66011075, 'D', 75, 6011, 489, 157, 'CRISTOPHER ALEXEIS SUAREZ GONZALEZ', 'CRISTOPHER ALEXEIS SUAREZ GONZALEZ', '', false, 'None', 'CRISTOPHER ALEXEIS', 'SUAREZ GONZALEZ');
INSERT INTO candidato VALUES (66011076, 'D', 76, 6011, 489, 157, 'ELIZABETH FUENTES BRAVO', 'ELIZABETH FUENTES BRAVO', '', false, 'None', 'ELIZABETH', 'FUENTES BRAVO');
INSERT INTO candidato VALUES (66011077, 'D', 77, 6011, 489, 157, 'ERNESTO EXEQUIEL CORTEZ ULBRICH', 'ERNESTO EXEQUIEL CORTEZ ULBRICH', '', false, 'None', 'ERNESTO EXEQUIEL', 'CORTEZ ULBRICH');
INSERT INTO candidato VALUES (66011078, 'D', 78, 6011, 489, 157, 'MARCELA IVONNE CABALLERO REYES', 'MARCELA IVONNE CABALLERO REYES', '', false, 'None', 'MARCELA IVONNE', 'CABALLERO REYES');
INSERT INTO candidato VALUES (66011079, 'D', 79, 6011, 489, 157, 'MARICEL DONOSO ACEVEDO', 'MARICEL DONOSO ACEVEDO', '', false, 'None', 'MARICEL', 'DONOSO ACEVEDO');
INSERT INTO candidato VALUES (66011080, 'D', 80, 6011, 489, 157, 'RICARDO ANDRES SILVA CALCAGNO', 'RICARDO ANDRES SILVA CALCAGNO', '', false, 'None', 'RICARDO ANDRES', 'SILVA CALCAGNO');
INSERT INTO candidato VALUES (66011081, 'D', 81, 6011, 485, 37, 'FRANCISCO UNDURRAGA GAZITUA', 'FRANCISCO UNDURRAGA GAZITUA', '', false, 'None', 'FRANCISCO', 'UNDURRAGA GAZITUA');
INSERT INTO candidato VALUES (66011082, 'D', 82, 6011, 485, 37, 'MACARENA CORNEJO FUENTES', 'MACARENA CORNEJO FUENTES', '', false, 'None', 'MACARENA', 'CORNEJO FUENTES');
INSERT INTO candidato VALUES (66011083, 'D', 83, 6011, 485, 1, 'DIEGO SCHALPER SEPULVEDA', 'DIEGO SCHALPER SEPULVEDA', '', false, 'None', 'DIEGO', 'SCHALPER SEPULVEDA');
INSERT INTO candidato VALUES (66011084, 'D', 84, 6011, 485, 1, 'CLAUDIA MORA VEGA', 'CLAUDIA MORA VEGA', '', false, 'None', 'CLAUDIA', 'MORA VEGA');
INSERT INTO candidato VALUES (66011085, 'D', 85, 6011, 485, 198, 'PERCY CARTER MORONG', 'PERCY CARTER MORONG', '', true, 'None', 'PERCY', 'CARTER MORONG');
INSERT INTO candidato VALUES (66011086, 'D', 86, 6011, 485, 3, 'CARLOS WARD EDWARDS', 'CARLOS WARD EDWARDS', '', false, 'None', 'CARLOS', 'WARD EDWARDS');
INSERT INTO candidato VALUES (66011087, 'D', 87, 6011, 485, 3, 'CONSTANZA HUBE PORTUS', 'CONSTANZA HUBE PORTUS', '', false, 'None', 'CONSTANZA', 'HUBE PORTUS');
INSERT INTO candidato VALUES (66011088, 'D', 88, 6011, 479, 150, 'CRISTIAN ARAYA LERDO DE TEJADA', 'CRISTIAN ARAYA LERDO DE TEJADA', '', false, 'None', 'CRISTIAN', 'ARAYA LERDO DE TEJADA');
INSERT INTO candidato VALUES (66011089, 'D', 89, 6011, 479, 150, 'CATALINA DEL REAL MIHOVILOVIC', 'CATALINA DEL REAL MIHOVILOVIC', '', false, 'None', 'CATALINA', 'DEL REAL MIHOVILOVIC');
INSERT INTO candidato VALUES (66011090, 'D', 90, 6011, 479, 150, 'PEDRO LEA-PLAZA EDWARDS', 'PEDRO LEA-PLAZA EDWARDS', '', false, 'None', 'PEDRO', 'LEA-PLAZA EDWARDS');
INSERT INTO candidato VALUES (66011091, 'D', 91, 6011, 479, 197, 'MICHEL CARTES ZUÑIGA', 'MICHEL CARTES ZUÑIGA', '', false, 'None', 'MICHEL', 'CARTES ZUÑIGA');
INSERT INTO candidato VALUES (66011092, 'D', 92, 6011, 479, 235, 'CRISTIAN DALY DAGORRET', 'CRISTIAN DALY DAGORRET', '', false, 'None', 'CRISTIAN', 'DALY DAGORRET');
INSERT INTO candidato VALUES (66011093, 'D', 93, 6011, 479, 235, 'CARLOS ALARCON CASTRO', 'CARLOS ALARCON CASTRO', '', false, 'None', 'CARLOS', 'ALARCON CASTRO');
INSERT INTO candidato VALUES (66011094, 'D', 94, 6011, 479, 235, 'MARIA CAROLINA COTAPOS MARDONES', 'MARIA CAROLINA COTAPOS MARDONES', '', false, 'None', 'MARIA CAROLINA', 'COTAPOS MARDONES');
INSERT INTO candidato VALUES (66012051, 'D', 51, 6012, 487, 190, 'ANA MARIA GAZMURI VIEIRA', 'ANA MARIA GAZMURI VIEIRA', '', false, 'None', 'ANA MARIA', 'GAZMURI VIEIRA');
INSERT INTO candidato VALUES (66012052, 'D', 52, 6012, 487, 190, 'MARGARITA PAZ ARAYA FLORES', 'MARGARITA PAZ ARAYA FLORES', '', false, 'None', 'MARGARITA PAZ', 'ARAYA FLORES');
INSERT INTO candidato VALUES (66012053, 'D', 53, 6012, 487, 190, 'GIOVANNA GRANDON CARO', 'GIOVANNA GRANDON CARO', '', true, 'None', 'GIOVANNA', 'GRANDON CARO');
INSERT INTO candidato VALUES (66012054, 'D', 54, 6012, 487, 190, 'FABRIZIO ALDAY VALDOVINOS', 'FABRIZIO ALDAY VALDOVINOS', '', true, 'None', 'FABRIZIO', 'ALDAY VALDOVINOS');
INSERT INTO candidato VALUES (66012055, 'D', 55, 6012, 487, 130, 'HERNAN PALMA PEREZ', 'HERNAN PALMA PEREZ', '', false, 'None', 'HERNAN', 'PALMA PEREZ');
INSERT INTO candidato VALUES (66012056, 'D', 56, 6012, 487, 130, 'GUSTAVO LORCA QUITRAL', 'GUSTAVO LORCA QUITRAL', '', true, 'None', 'GUSTAVO', 'LORCA QUITRAL');
INSERT INTO candidato VALUES (66012057, 'D', 57, 6012, 487, 130, 'RICARDO SANTANA PEREZ', 'RICARDO SANTANA PEREZ', '', true, 'None', 'RICARDO', 'SANTANA PEREZ');
INSERT INTO candidato VALUES (66012058, 'D', 58, 6012, 483, 6, 'DANIELA SERRANO SALAZAR', 'DANIELA SERRANO SALAZAR', '', false, 'None', 'DANIELA', 'SERRANO SALAZAR');
INSERT INTO candidato VALUES (66012059, 'D', 59, 6012, 483, 6, 'JUAN NAVARRO ROMERO', 'JUAN NAVARRO ROMERO', '', false, 'None', 'JUAN', 'NAVARRO ROMERO');
INSERT INTO candidato VALUES (66012060, 'D', 60, 6012, 483, 232, 'SIMON RAMIREZ GONZALEZ', 'SIMON RAMIREZ GONZALEZ', '', false, 'None', 'SIMON', 'RAMIREZ GONZALEZ');
INSERT INTO candidato VALUES (66012061, 'D', 61, 6012, 483, 232, 'MARCO VELARDE SALINAS', 'MARCO VELARDE SALINAS', '', false, 'None', 'MARCO', 'VELARDE SALINAS');
INSERT INTO candidato VALUES (66012062, 'D', 62, 6012, 483, 5, 'CLAUDIA HASBUN FAILA', 'CLAUDIA HASBUN FAILA', '', false, 'None', 'CLAUDIA', 'HASBUN FAILA');
INSERT INTO candidato VALUES (66012063, 'D', 63, 6012, 483, 5, 'LI FRIDMAN MOSES', 'LI FRIDMAN MOSES', '', true, 'None', 'LI', 'FRIDMAN MOSES');
INSERT INTO candidato VALUES (66012064, 'D', 64, 6012, 483, 2, 'DINKA TOMICIC BOBADILLA', 'DINKA TOMICIC BOBADILLA', '', false, 'None', 'DINKA', 'TOMICIC BOBADILLA');
INSERT INTO candidato VALUES (66012065, 'D', 65, 6012, 483, 2, 'MONICA ARCE CASTRO', 'MONICA ARCE CASTRO', '', true, 'None', 'MONICA', 'ARCE CASTRO');
INSERT INTO candidato VALUES (66012066, 'D', 66, 6012, 481, 188, 'NATALIA GARRIDO TORO', 'NATALIA GARRIDO TORO', '', true, 'None', 'NATALIA', 'GARRIDO TORO');
INSERT INTO candidato VALUES (66012068, 'D', 68, 6012, 481, 188, 'RAFAEL HARVEY VALDES', 'RAFAEL HARVEY VALDES', '', true, 'None', 'RAFAEL', 'HARVEY VALDES');
INSERT INTO candidato VALUES (66012069, 'D', 69, 6012, 481, 188, 'RITA PINO MARDONES', 'RITA PINO MARDONES', '', true, 'None', 'RITA', 'PINO MARDONES');
INSERT INTO candidato VALUES (66012070, 'D', 70, 6012, 481, 188, 'JUAN CARLOS ZURITA MEDINA', 'JUAN CARLOS ZURITA MEDINA', '', false, 'None', 'JUAN CARLOS', 'ZURITA MEDINA');
INSERT INTO candidato VALUES (66012071, 'D', 71, 6012, 481, 188, 'PAULA  OCARES CERDA', 'PAULA  OCARES CERDA', '', true, 'None', 'PAULA ', 'OCARES CERDA');
INSERT INTO candidato VALUES (66012072, 'D', 72, 6012, 481, 188, 'DOMINIQUE MUÑOZ VENEGAS', 'DOMINIQUE MUÑOZ VENEGAS', '', true, 'None', 'DOMINIQUE', 'MUÑOZ VENEGAS');
INSERT INTO candidato VALUES (66012073, 'D', 73, 6012, 481, 188, 'CATALINA VALESKA VALENZUELA MAUREIRA', 'CATALINA VALESKA VALENZUELA MAUREIRA', '', false, 'None', 'CATALINA VALESKA', 'VALENZUELA MAUREIRA');
INSERT INTO candidato VALUES (66012074, 'D', 74, 6012, 493, 200, 'PATRICIA DEL PILAR TOLEDO JEREZ', 'PATRICIA DEL PILAR TOLEDO JEREZ', '', false, 'None', 'PATRICIA DEL PILAR', 'TOLEDO JEREZ');
INSERT INTO candidato VALUES (66012075, 'D', 75, 6012, 493, 200, 'SEBASTIAN RODRIGUEZ CORTES', 'SEBASTIAN RODRIGUEZ CORTES', '', false, 'None', 'SEBASTIAN', 'RODRIGUEZ CORTES');
INSERT INTO candidato VALUES (66012076, 'D', 76, 6012, 493, 200, 'ANDRES TEODORO JARA PEREZ', 'ANDRES TEODORO JARA PEREZ', '', false, 'None', 'ANDRES TEODORO', 'JARA PEREZ');
INSERT INTO candidato VALUES (66012077, 'D', 77, 6012, 493, 200, 'NICOLAS PATRICIO FARNET TOLEDO', 'NICOLAS PATRICIO FARNET TOLEDO', '', false, 'None', 'NICOLAS PATRICIO', 'FARNET TOLEDO');
INSERT INTO candidato VALUES (66012078, 'D', 78, 6012, 493, 200, 'DARLYNG DAYANE FUENTES GOMEZ', 'DARLYNG DAYANE FUENTES GOMEZ', '', false, 'None', 'DARLYNG DAYANE', 'FUENTES GOMEZ');
INSERT INTO candidato VALUES (66012079, 'D', 79, 6012, 493, 200, 'VALENTINA IGNACIA CASTILLO REYES', 'VALENTINA IGNACIA CASTILLO REYES', '', false, 'None', 'VALENTINA IGNACIA', 'CASTILLO REYES');
INSERT INTO candidato VALUES (66012080, 'D', 80, 6012, 493, 200, 'VANIA ANDREA NECULQUEO SAAVEDRA', 'VANIA ANDREA NECULQUEO SAAVEDRA', '', false, 'None', 'VANIA ANDREA', 'NECULQUEO SAAVEDRA');
INSERT INTO candidato VALUES (66012081, 'D', 81, 6012, 489, 157, 'PAMELA JILES MORENO', 'PAMELA JILES MORENO', '', false, 'None', 'PAMELA', 'JILES MORENO');
INSERT INTO candidato VALUES (66012082, 'D', 82, 6012, 489, 157, 'PABLO MALTES BISKUPOVIC', 'PABLO MALTES BISKUPOVIC', '', false, 'None', 'PABLO', 'MALTES BISKUPOVIC');
INSERT INTO candidato VALUES (66012083, 'D', 83, 6012, 489, 157, 'ZANDRA PARISI FERNANDEZ', 'ZANDRA PARISI FERNANDEZ', '', false, 'None', 'ZANDRA', 'PARISI FERNANDEZ');
INSERT INTO candidato VALUES (66012084, 'D', 84, 6012, 489, 157, 'LUIS EDUARDO MOLINA CASTILLO', 'LUIS EDUARDO MOLINA CASTILLO', '', false, 'None', 'LUIS EDUARDO', 'MOLINA CASTILLO');
INSERT INTO candidato VALUES (66012085, 'D', 85, 6012, 489, 157, 'LEONARDO JAVIER MATURANA VERGARA', 'LEONARDO JAVIER MATURANA VERGARA', '', false, 'None', 'LEONARDO JAVIER', 'MATURANA VERGARA');
INSERT INTO candidato VALUES (66012086, 'D', 86, 6012, 489, 157, 'HERNAN JONATHAN ALVAREZ VARGAS', 'HERNAN JONATHAN ALVAREZ VARGAS', '', false, 'None', 'HERNAN JONATHAN', 'ALVAREZ VARGAS');
INSERT INTO candidato VALUES (66012087, 'D', 87, 6012, 489, 157, 'JORGE MARCELO CHAVEZ AREVALO', 'JORGE MARCELO CHAVEZ AREVALO', '', false, 'None', 'JORGE MARCELO', 'CHAVEZ AREVALO');
INSERT INTO candidato VALUES (66012088, 'D', 88, 6012, 485, 1, 'XIMENA OSSANDON IRARRAZABAL', 'XIMENA OSSANDON IRARRAZABAL', '', false, 'None', 'XIMENA', 'OSSANDON IRARRAZABAL');
INSERT INTO candidato VALUES (66012089, 'D', 89, 6012, 485, 1, 'PAOLA ROMERO LLANOS', 'PAOLA ROMERO LLANOS', '', true, 'None', 'PAOLA', 'ROMERO LLANOS');
INSERT INTO candidato VALUES (66012090, 'D', 90, 6012, 485, 1, 'HUGO ESTRELLA MUÑOZ', 'HUGO ESTRELLA MUÑOZ', '', false, 'None', 'HUGO', 'ESTRELLA MUÑOZ');
INSERT INTO candidato VALUES (66012091, 'D', 91, 6012, 485, 3, 'PAZ ORTUZAR FUENZALIDA', 'PAZ ORTUZAR FUENZALIDA', '', true, 'None', 'PAZ', 'ORTUZAR FUENZALIDA');
INSERT INTO candidato VALUES (66012092, 'D', 92, 6012, 485, 3, 'CLAUDIA RASSO SOCIAS', 'CLAUDIA RASSO SOCIAS', '', true, 'None', 'CLAUDIA', 'RASSO SOCIAS');
INSERT INTO candidato VALUES (66012093, 'D', 93, 6012, 485, 3, 'ANIBAL PINTO FERRADA', 'ANIBAL PINTO FERRADA', '', false, 'None', 'ANIBAL', 'PINTO FERRADA');
INSERT INTO candidato VALUES (66012094, 'D', 94, 6012, 485, 198, 'JOHANA CONCHA ORTIZ', 'JOHANA CONCHA ORTIZ', '', false, 'None', 'JOHANA', 'CONCHA ORTIZ');
INSERT INTO candidato VALUES (66012095, 'D', 95, 6012, 485, 198, 'JONATHAN BARRERA GUAJARDO', 'JONATHAN BARRERA GUAJARDO', '', false, 'None', 'JONATHAN', 'BARRERA GUAJARDO');
INSERT INTO candidato VALUES (66012096, 'D', 96, 6012, 479, 197, 'JUDITH MARIN MORALES', 'JUDITH MARIN MORALES', '', false, 'None', 'JUDITH', 'MARIN MORALES');
INSERT INTO candidato VALUES (66012097, 'D', 97, 6012, 479, 197, 'ELEIN OSSANDON MANRIQUE', 'ELEIN OSSANDON MANRIQUE', '', false, 'None', 'ELEIN', 'OSSANDON MANRIQUE');
INSERT INTO candidato VALUES (66012098, 'D', 98, 6012, 479, 197, 'KEVIN VALENZUELA ARROYO', 'KEVIN VALENZUELA ARROYO', '', false, 'None', 'KEVIN', 'VALENZUELA ARROYO');
INSERT INTO candidato VALUES (66012099, 'D', 99, 6012, 479, 235, 'CAMILLE SIGL FUENTES', 'CAMILLE SIGL FUENTES', '', false, 'None', 'CAMILLE', 'SIGL FUENTES');
INSERT INTO candidato VALUES (66012100, 'D', 100, 6012, 479, 235, 'MARIA ISABEL SAEZ VILA', 'MARIA ISABEL SAEZ VILA', '', false, 'None', 'MARIA ISABEL', 'SAEZ VILA');
INSERT INTO candidato VALUES (66012101, 'D', 101, 6012, 479, 235, 'ANDRES ARCE BUSTOS', 'ANDRES ARCE BUSTOS', '', false, 'None', 'ANDRES', 'ARCE BUSTOS');
INSERT INTO candidato VALUES (66012102, 'D', 102, 6012, 479, 150, 'MACARENA SANTELICES CAÑAS', 'MACARENA SANTELICES CAÑAS', '', false, 'None', 'MACARENA', 'SANTELICES CAÑAS');
INSERT INTO candidato VALUES (66012103, 'D', 103, 6012, 479, 150, 'ALVARO CARTER FERNANDEZ', 'ALVARO CARTER FERNANDEZ', '', false, 'None', 'ALVARO', 'CARTER FERNANDEZ');
INSERT INTO candidato VALUES (66013051, 'D', 51, 6013, 487, 130, 'JOSE SILVA DIAZ', 'JOSE SILVA DIAZ', '', true, 'None', 'JOSE', 'SILVA DIAZ');
INSERT INTO candidato VALUES (66013052, 'D', 52, 6013, 487, 130, 'SEBASTIAN VEGA UMATINO', 'SEBASTIAN VEGA UMATINO', '', true, 'None', 'SEBASTIAN', 'VEGA UMATINO');
INSERT INTO candidato VALUES (66013053, 'D', 53, 6013, 487, 130, 'ROXANA RIQUELME TABACH', 'ROXANA RIQUELME TABACH', '', true, 'None', 'ROXANA', 'RIQUELME TABACH');
INSERT INTO candidato VALUES (66013054, 'D', 54, 6013, 487, 130, 'MATIAS FREIRE VALLEJOS', 'MATIAS FREIRE VALLEJOS', '', true, 'None', 'MATIAS', 'FREIRE VALLEJOS');
INSERT INTO candidato VALUES (66013055, 'D', 55, 6013, 487, 190, 'PERCY CAMPOS CORONEL', 'PERCY CAMPOS CORONEL', '', true, 'None', 'PERCY', 'CAMPOS CORONEL');
INSERT INTO candidato VALUES (66013056, 'D', 56, 6013, 483, 6, 'LORENA PIZARRO SIERRA', 'LORENA PIZARRO SIERRA', '', false, 'None', 'LORENA', 'PIZARRO SIERRA');
INSERT INTO candidato VALUES (66013057, 'D', 57, 6013, 483, 232, 'GAEL YEOMANS ARAYA', 'GAEL YEOMANS ARAYA', '', false, 'None', 'GAEL', 'YEOMANS ARAYA');
INSERT INTO candidato VALUES (66013058, 'D', 58, 6013, 483, 4, 'CRISTOBAL BARRA CATALAN', 'CRISTOBAL BARRA CATALAN', '', false, 'None', 'CRISTOBAL', 'BARRA CATALAN');
INSERT INTO candidato VALUES (66013059, 'D', 59, 6013, 483, 2, 'RENATA VASQUEZ ALDUNCE', 'RENATA VASQUEZ ALDUNCE', '', false, 'None', 'RENATA', 'VASQUEZ ALDUNCE');
INSERT INTO candidato VALUES (66013060, 'D', 60, 6013, 483, 7, 'ELIZABETH ZUÑIGA CRUZ', 'ELIZABETH ZUÑIGA CRUZ', '', false, 'None', 'ELIZABETH', 'ZUÑIGA CRUZ');
INSERT INTO candidato VALUES (66013061, 'D', 61, 6013, 483, 5, 'DANIEL MELO CONTRERAS', 'DANIEL MELO CONTRERAS', '', false, 'None', 'DANIEL', 'MELO CONTRERAS');
INSERT INTO candidato VALUES (66013062, 'D', 62, 6013, 481, 188, 'JORGE CRISTIAN MUÑOZ REYES', 'JORGE CRISTIAN MUÑOZ REYES', '', true, 'None', 'JORGE CRISTIAN', 'MUÑOZ REYES');
INSERT INTO candidato VALUES (66013063, 'D', 63, 6013, 481, 188, 'FERNANDO ISRAEL VILCHES CESPEDES', 'FERNANDO ISRAEL VILCHES CESPEDES', '', false, 'None', 'FERNANDO ISRAEL', 'VILCHES CESPEDES');
INSERT INTO candidato VALUES (66013064, 'D', 64, 6013, 481, 188, 'GAZZI ANDRES JACOB NUÑEZ', 'GAZZI ANDRES JACOB NUÑEZ', '', true, 'None', 'GAZZI ANDRES', 'JACOB NUÑEZ');
INSERT INTO candidato VALUES (66013065, 'D', 65, 6013, 481, 188, 'MARISELA DEL PILAR PETERSEN BASAEZ', 'MARISELA DEL PILAR PETERSEN BASAEZ', '', true, 'None', 'MARISELA DEL PILAR', 'PETERSEN BASAEZ');
INSERT INTO candidato VALUES (66013066, 'D', 66, 6013, 497, 220, 'JUAN FRANCISCO GAMBOA HIGUERA', 'JUAN FRANCISCO GAMBOA HIGUERA', '', false, 'None', 'JUAN FRANCISCO', 'GAMBOA HIGUERA');
INSERT INTO candidato VALUES (66013067, 'D', 67, 6013, 497, 220, 'MARIA ISABEL MARGARITA MARTINEZ LIZAMA', 'MARIA ISABEL MARGARITA MARTINEZ LIZAMA', '', false, 'None', 'MARIA ISABEL MARGARITA', 'MARTINEZ LIZAMA');
INSERT INTO candidato VALUES (66013068, 'D', 68, 6013, 497, 220, 'CAMILA PAZ BURGOS GONZALEZ', 'CAMILA PAZ BURGOS GONZALEZ', '', false, 'None', 'CAMILA PAZ', 'BURGOS GONZALEZ');
INSERT INTO candidato VALUES (66013069, 'D', 69, 6013, 493, 200, 'PAOLA JOYCE MARTINEZ SANDOVAL', 'PAOLA JOYCE MARTINEZ SANDOVAL', '', false, 'None', 'PAOLA JOYCE', 'MARTINEZ SANDOVAL');
INSERT INTO candidato VALUES (66013070, 'D', 70, 6013, 493, 200, 'PEDRO ALEJANDRO VALENZUELA YAÑEZ', 'PEDRO ALEJANDRO VALENZUELA YAÑEZ', '', false, 'None', 'PEDRO ALEJANDRO', 'VALENZUELA YAÑEZ');
INSERT INTO candidato VALUES (66013071, 'D', 71, 6013, 489, 157, 'CRISTIAN ARTURO SEGUEL OLIVOS', 'CRISTIAN ARTURO SEGUEL OLIVOS', '', false, 'None', 'CRISTIAN ARTURO', 'SEGUEL OLIVOS');
INSERT INTO candidato VALUES (66013072, 'D', 72, 6013, 489, 157, 'MARCELO ANDRES OLIVARES FIGUEROA', 'MARCELO ANDRES OLIVARES FIGUEROA', '', false, 'None', 'MARCELO ANDRES', 'OLIVARES FIGUEROA');
INSERT INTO candidato VALUES (66013073, 'D', 73, 6013, 489, 157, 'ALEXANDER RODOLFO ROJAS VILLARROEL', 'ALEXANDER RODOLFO ROJAS VILLARROEL', '', false, 'None', 'ALEXANDER RODOLFO', 'ROJAS VILLARROEL');
INSERT INTO candidato VALUES (66013074, 'D', 74, 6013, 489, 157, 'ERIKA MARIBEL LIZAMA FUENTES', 'ERIKA MARIBEL LIZAMA FUENTES', '', false, 'None', 'ERIKA MARIBEL', 'LIZAMA FUENTES');
INSERT INTO candidato VALUES (66013075, 'D', 75, 6013, 489, 157, 'NELSON DAVID ALVAREZ GALLEGUILLOS', 'NELSON DAVID ALVAREZ GALLEGUILLOS', '', false, 'None', 'NELSON DAVID', 'ALVAREZ GALLEGUILLOS');
INSERT INTO candidato VALUES (66013076, 'D', 76, 6013, 489, 157, 'NOEMI LAPOSTOL JARA', 'NOEMI LAPOSTOL JARA', '', false, 'None', 'NOEMI', 'LAPOSTOL JARA');
INSERT INTO candidato VALUES (66013077, 'D', 77, 6013, 485, 1, 'EDUARDO DURAN SALINAS', 'EDUARDO DURAN SALINAS', '', false, 'None', 'EDUARDO', 'DURAN SALINAS');
INSERT INTO candidato VALUES (66013078, 'D', 78, 6013, 485, 1, 'SUSAN ATUAN SALCEDO', 'SUSAN ATUAN SALCEDO', '', false, 'None', 'SUSAN', 'ATUAN SALCEDO');
INSERT INTO candidato VALUES (66013079, 'D', 79, 6013, 485, 37, 'MACARENA VENEGAS TASSARA', 'MACARENA VENEGAS TASSARA', '', true, 'None', 'MACARENA', 'VENEGAS TASSARA');
INSERT INTO candidato VALUES (66013080, 'D', 80, 6013, 485, 37, 'DANIEL CORONADO CORONADO', 'DANIEL CORONADO CORONADO', '', false, 'None', 'DANIEL', 'CORONADO CORONADO');
INSERT INTO candidato VALUES (66013081, 'D', 81, 6013, 485, 3, 'CLAUDIA LANGE FARIAS', 'CLAUDIA LANGE FARIAS', '', false, 'None', 'CLAUDIA', 'LANGE FARIAS');
INSERT INTO candidato VALUES (66013082, 'D', 82, 6013, 485, 3, 'CRISTHIAN MOREIRA BARROS', 'CRISTHIAN MOREIRA BARROS', '', false, 'None', 'CRISTHIAN', 'MOREIRA BARROS');
INSERT INTO candidato VALUES (66013083, 'D', 83, 6013, 479, 150, 'FELIPE ROSS CORREA', 'FELIPE ROSS CORREA', '', false, 'None', 'FELIPE', 'ROSS CORREA');
INSERT INTO candidato VALUES (66013084, 'D', 84, 6013, 479, 150, 'VALENTINA BECERRA PEÑA', 'VALENTINA BECERRA PEÑA', '', false, 'None', 'VALENTINA', 'BECERRA PEÑA');
INSERT INTO candidato VALUES (66013085, 'D', 85, 6013, 479, 235, 'TARYN COOPMAN PALAVICINO', 'TARYN COOPMAN PALAVICINO', '', false, 'None', 'TARYN', 'COOPMAN PALAVICINO');
INSERT INTO candidato VALUES (66013086, 'D', 86, 6013, 479, 235, 'OSCAR CALFILEO CASTRO', 'OSCAR CALFILEO CASTRO', '', false, 'None', 'OSCAR', 'CALFILEO CASTRO');
INSERT INTO candidato VALUES (66013087, 'D', 87, 6013, 479, 197, 'CRISTIAN VIVIAN TRONCOSO', 'CRISTIAN VIVIAN TRONCOSO', '', false, 'None', 'CRISTIAN', 'VIVIAN TRONCOSO');
INSERT INTO candidato VALUES (66013088, 'D', 88, 6013, 479, 197, 'DANIEL TAPIA MELLA', 'DANIEL TAPIA MELLA', '', true, 'None', 'DANIEL', 'TAPIA MELLA');
INSERT INTO candidato VALUES (66014051, 'D', 51, 6014, 487, 130, 'PILAR FARFAN VILLAGRA', 'PILAR FARFAN VILLAGRA', '', false, 'None', 'PILAR', 'FARFAN VILLAGRA');
INSERT INTO candidato VALUES (66014052, 'D', 52, 6014, 487, 130, 'EVELYN BASTIAS ARAYA', 'EVELYN BASTIAS ARAYA', '', false, 'None', 'EVELYN', 'BASTIAS ARAYA');
INSERT INTO candidato VALUES (66014053, 'D', 53, 6014, 487, 130, 'DANIEL DOMINGUEZ GONZALEZ', 'DANIEL DOMINGUEZ GONZALEZ', '', true, 'None', 'DANIEL', 'DOMINGUEZ GONZALEZ');
INSERT INTO candidato VALUES (66014054, 'D', 54, 6014, 487, 130, 'MARIA ELENA FLORES MARTINEZ', 'MARIA ELENA FLORES MARTINEZ', '', true, 'None', 'MARIA ELENA', 'FLORES MARTINEZ');
INSERT INTO candidato VALUES (66014055, 'D', 55, 6014, 487, 130, 'BERNARDA LAGOS FARFAN', 'BERNARDA LAGOS FARFAN', '', false, 'None', 'BERNARDA', 'LAGOS FARFAN');
INSERT INTO candidato VALUES (66014056, 'D', 56, 6014, 487, 190, 'CARLOS MORALES FLORES', 'CARLOS MORALES FLORES', '', true, 'None', 'CARLOS', 'MORALES FLORES');
INSERT INTO candidato VALUES (66014057, 'D', 57, 6014, 487, 190, 'SARA PASCUAL RODRIGUEZ', 'SARA PASCUAL RODRIGUEZ', '', false, 'None', 'SARA', 'PASCUAL RODRIGUEZ');
INSERT INTO candidato VALUES (66014058, 'D', 58, 6014, 483, 5, 'RAUL LEIVA CARVAJAL', 'RAUL LEIVA CARVAJAL', '', false, 'None', 'RAUL', 'LEIVA CARVAJAL');
INSERT INTO candidato VALUES (66014059, 'D', 59, 6014, 483, 5, 'ROBERTO SOTO FERRADA', 'ROBERTO SOTO FERRADA', '', false, 'None', 'ROBERTO', 'SOTO FERRADA');
INSERT INTO candidato VALUES (66014060, 'D', 60, 6014, 483, 6, 'MARISELA SANTIBAÑEZ NOVOA', 'MARISELA SANTIBAÑEZ NOVOA', '', true, 'None', 'MARISELA', 'SANTIBAÑEZ NOVOA');
INSERT INTO candidato VALUES (66014061, 'D', 61, 6014, 483, 232, 'IGNACIO ACHURRA DIAZ', 'IGNACIO ACHURRA DIAZ', '', false, 'None', 'IGNACIO', 'ACHURRA DIAZ');
INSERT INTO candidato VALUES (66014062, 'D', 62, 6014, 483, 2, 'NIBALDO MEZA GARFIA', 'NIBALDO MEZA GARFIA', '', false, 'None', 'NIBALDO', 'MEZA GARFIA');
INSERT INTO candidato VALUES (66014063, 'D', 63, 6014, 483, 7, 'CHRISTIAN PINO LOPEZ', 'CHRISTIAN PINO LOPEZ', '', true, 'None', 'CHRISTIAN', 'PINO LOPEZ');
INSERT INTO candidato VALUES (66014064, 'D', 64, 6014, 483, 4, 'CAMILA MUSANTE MULLER', 'CAMILA MUSANTE MULLER', '', true, 'None', 'CAMILA', 'MUSANTE MULLER');
INSERT INTO candidato VALUES (66014065, 'D', 65, 6014, 481, 188, 'RICARDO MARTINEZ VALENCIA', 'RICARDO MARTINEZ VALENCIA', '', true, 'None', 'RICARDO', 'MARTINEZ VALENCIA');
INSERT INTO candidato VALUES (66014066, 'D', 66, 6014, 481, 188, 'GUSTAVO ENRIQUE GONZALEZ ARAYA', 'GUSTAVO ENRIQUE GONZALEZ ARAYA', '', true, 'None', 'GUSTAVO ENRIQUE', 'GONZALEZ ARAYA');
INSERT INTO candidato VALUES (66014067, 'D', 67, 6014, 481, 188, 'ABRAHAM MUÑOZ VILCHES', 'ABRAHAM MUÑOZ VILCHES', '', true, 'None', 'ABRAHAM', 'MUÑOZ VILCHES');
INSERT INTO candidato VALUES (66014068, 'D', 68, 6014, 481, 188, 'JASMIN LIZETTE DONOSO ROMERO', 'JASMIN LIZETTE DONOSO ROMERO', '', false, 'None', 'JASMIN LIZETTE', 'DONOSO ROMERO');
INSERT INTO candidato VALUES (66014069, 'D', 69, 6014, 481, 188, 'DINA LUISA FIGUEROA MARDONES', 'DINA LUISA FIGUEROA MARDONES', '', true, 'None', 'DINA LUISA', 'FIGUEROA MARDONES');
INSERT INTO candidato VALUES (66014070, 'D', 70, 6014, 481, 188, 'FELIPE ALEXANDER PINO CASTILLO', 'FELIPE ALEXANDER PINO CASTILLO', '', true, 'None', 'FELIPE ALEXANDER', 'PINO CASTILLO');
INSERT INTO candidato VALUES (66014071, 'D', 71, 6014, 481, 188, 'FRANCISCO VALDES REYES', 'FRANCISCO VALDES REYES', '', true, 'None', 'FRANCISCO', 'VALDES REYES');
INSERT INTO candidato VALUES (66014072, 'D', 72, 6014, 493, 200, 'TAMARA FREDES GUTIERREZ', 'TAMARA FREDES GUTIERREZ', '', false, 'None', 'TAMARA', 'FREDES GUTIERREZ');
INSERT INTO candidato VALUES (66014073, 'D', 73, 6014, 493, 200, 'KEIN SOTO LAMA', 'KEIN SOTO LAMA', '', false, 'None', 'KEIN', 'SOTO LAMA');
INSERT INTO candidato VALUES (66014074, 'D', 74, 6014, 493, 200, 'SERGIO MILLALEN HIMILAF', 'SERGIO MILLALEN HIMILAF', '', false, 'None', 'SERGIO', 'MILLALEN HIMILAF');
INSERT INTO candidato VALUES (66014075, 'D', 75, 6014, 489, 157, 'ANDRES SANCHEZ FREDES', 'ANDRES SANCHEZ FREDES', '', false, 'None', 'ANDRES', 'SANCHEZ FREDES');
INSERT INTO candidato VALUES (66014076, 'D', 76, 6014, 489, 157, 'LETICIA DEL CARMEN ZUÑIGA SILVA', 'LETICIA DEL CARMEN ZUÑIGA SILVA', '', false, 'None', 'LETICIA DEL CARMEN', 'ZUÑIGA SILVA');
INSERT INTO candidato VALUES (66014077, 'D', 77, 6014, 489, 157, 'CINDY MACIAS TOLEDO', 'CINDY MACIAS TOLEDO', '', false, 'None', 'CINDY', 'MACIAS TOLEDO');
INSERT INTO candidato VALUES (66014078, 'D', 78, 6014, 489, 157, 'JUAN ANSELMO MELO RAMIREZ', 'JUAN ANSELMO MELO RAMIREZ', '', false, 'None', 'JUAN ANSELMO', 'MELO RAMIREZ');
INSERT INTO candidato VALUES (66014079, 'D', 79, 6014, 489, 157, 'SERGIO ANTONIO PALMA BRIONES', 'SERGIO ANTONIO PALMA BRIONES', '', false, 'None', 'SERGIO ANTONIO', 'PALMA BRIONES');
INSERT INTO candidato VALUES (66014080, 'D', 80, 6014, 489, 157, 'ROGELIO ALFREDO URBINA LEAL', 'ROGELIO ALFREDO URBINA LEAL', '', false, 'None', 'ROGELIO ALFREDO', 'URBINA LEAL');
INSERT INTO candidato VALUES (66014081, 'D', 81, 6014, 489, 157, 'JORGE ANDRES MEZA INFANTE', 'JORGE ANDRES MEZA INFANTE', '', false, 'None', 'JORGE ANDRES', 'MEZA INFANTE');
INSERT INTO candidato VALUES (66014082, 'D', 82, 6014, 485, 3, 'JAIME COLOMA ALAMOS', 'JAIME COLOMA ALAMOS', '', false, 'None', 'JAIME', 'COLOMA ALAMOS');
INSERT INTO candidato VALUES (66014083, 'D', 83, 6014, 485, 3, 'CHRISTIAN GOMEZ DIAZ', 'CHRISTIAN GOMEZ DIAZ', '', true, 'None', 'CHRISTIAN', 'GOMEZ DIAZ');
INSERT INTO candidato VALUES (66014084, 'D', 84, 6014, 485, 3, 'CLAUDIA CASTRO GUTIERREZ', 'CLAUDIA CASTRO GUTIERREZ', '', true, 'None', 'CLAUDIA', 'CASTRO GUTIERREZ');
INSERT INTO candidato VALUES (66014085, 'D', 85, 6014, 485, 1, 'ALEJANDRA NOVOA SANDOVAL', 'ALEJANDRA NOVOA SANDOVAL', '', false, 'None', 'ALEJANDRA', 'NOVOA SANDOVAL');
INSERT INTO candidato VALUES (66014086, 'D', 86, 6014, 485, 1, 'PABLO MIRA HURTADO', 'PABLO MIRA HURTADO', '', false, 'None', 'PABLO', 'MIRA HURTADO');
INSERT INTO candidato VALUES (66014087, 'D', 87, 6014, 485, 1, 'PABLO HERRERA ROGERS', 'PABLO HERRERA ROGERS', '', true, 'None', 'PABLO', 'HERRERA ROGERS');
INSERT INTO candidato VALUES (66014088, 'D', 88, 6014, 485, 37, 'TRINIDAD BIGGS MONTANER', 'TRINIDAD BIGGS MONTANER', '', false, 'None', 'TRINIDAD', 'BIGGS MONTANER');
INSERT INTO candidato VALUES (66014089, 'D', 89, 6014, 479, 150, 'JUAN IRARRAZAVAL ROSSEL', 'JUAN IRARRAZAVAL ROSSEL', '', false, 'None', 'JUAN', 'IRARRAZAVAL ROSSEL');
INSERT INTO candidato VALUES (66014090, 'D', 90, 6014, 479, 150, 'DIEGO VERGARA RODRIGUEZ', 'DIEGO VERGARA RODRIGUEZ', '', false, 'None', 'DIEGO', 'VERGARA RODRIGUEZ');
INSERT INTO candidato VALUES (66014091, 'D', 91, 6014, 479, 150, 'ANNEMARIE MULLER DURING', 'ANNEMARIE MULLER DURING', '', false, 'None', 'ANNEMARIE', 'MULLER DURING');
INSERT INTO candidato VALUES (66014092, 'D', 92, 6014, 479, 197, 'JUAN MOLINA ROMO', 'JUAN MOLINA ROMO', '', false, 'None', 'JUAN', 'MOLINA ROMO');
INSERT INTO candidato VALUES (66014093, 'D', 93, 6014, 479, 197, 'CARLOS BARBERIS AVENDAÑO', 'CARLOS BARBERIS AVENDAÑO', '', false, 'None', 'CARLOS', 'BARBERIS AVENDAÑO');
INSERT INTO candidato VALUES (66014094, 'D', 94, 6014, 479, 235, 'CLAUDIA ORMEÑO URRA', 'CLAUDIA ORMEÑO URRA', '', false, 'None', 'CLAUDIA', 'ORMEÑO URRA');
INSERT INTO candidato VALUES (66014095, 'D', 95, 6014, 479, 235, 'JOSEFINA DIEGUEZ RUSSELL', 'JOSEFINA DIEGUEZ RUSSELL', '', false, 'None', 'JOSEFINA', 'DIEGUEZ RUSSELL');
INSERT INTO candidato VALUES (66015051, 'D', 51, 6015, 487, 190, 'NICOLAS SALGADO AHUMADA', 'NICOLAS SALGADO AHUMADA', '', true, 'None', 'NICOLAS', 'SALGADO AHUMADA');
INSERT INTO candidato VALUES (66015052, 'D', 52, 6015, 487, 190, 'CLAUDIO SEGOVIA COFRE', 'CLAUDIO SEGOVIA COFRE', '', true, 'None', 'CLAUDIO', 'SEGOVIA COFRE');
INSERT INTO candidato VALUES (66015053, 'D', 53, 6015, 487, 190, 'FRANKLIN ESTEBAN GALLARDO GALLARDO', 'FRANKLIN ESTEBAN GALLARDO GALLARDO', '', true, 'None', 'FRANKLIN ESTEBAN', 'GALLARDO GALLARDO');
INSERT INTO candidato VALUES (66015054, 'D', 54, 6015, 487, 130, 'HUGO BOZA VALDENEGRO', 'HUGO BOZA VALDENEGRO', '', false, 'None', 'HUGO', 'BOZA VALDENEGRO');
INSERT INTO candidato VALUES (66015055, 'D', 55, 6015, 487, 130, 'MARTA GONZALEZ OLEA', 'MARTA GONZALEZ OLEA', '', true, 'None', 'MARTA', 'GONZALEZ OLEA');
INSERT INTO candidato VALUES (66015056, 'D', 56, 6015, 487, 130, 'HUGO GUZMAN MILLAN', 'HUGO GUZMAN MILLAN', '', true, 'None', 'HUGO', 'GUZMAN MILLAN');
INSERT INTO candidato VALUES (66015057, 'D', 57, 6015, 483, 4, 'RAUL SOTO MARDONES', 'RAUL SOTO MARDONES', '', false, 'None', 'RAUL', 'SOTO MARDONES');
INSERT INTO candidato VALUES (66015058, 'D', 58, 6015, 483, 4, 'FERNANDO ZAMORANO PERALTA', 'FERNANDO ZAMORANO PERALTA', '', false, 'None', 'FERNANDO', 'ZAMORANO PERALTA');
INSERT INTO candidato VALUES (66015059, 'D', 59, 6015, 483, 6, 'RAISA MARTINEZ MUÑOZ', 'RAISA MARTINEZ MUÑOZ', '', false, 'None', 'RAISA', 'MARTINEZ MUÑOZ');
INSERT INTO candidato VALUES (66015060, 'D', 60, 6015, 483, 232, 'VALENTINA CACERES MONSALVEZ', 'VALENTINA CACERES MONSALVEZ', '', true, 'None', 'VALENTINA', 'CACERES MONSALVEZ');
INSERT INTO candidato VALUES (66015061, 'D', 61, 6015, 483, 5, 'CAROLINA HERRERA CONTRERAS', 'CAROLINA HERRERA CONTRERAS', '', true, 'None', 'CAROLINA', 'HERRERA CONTRERAS');
INSERT INTO candidato VALUES (66015062, 'D', 62, 6015, 483, 7, 'MARCELA RIQUELME ALIAGA', 'MARCELA RIQUELME ALIAGA', '', true, 'None', 'MARCELA', 'RIQUELME ALIAGA');
INSERT INTO candidato VALUES (66015063, 'D', 63, 6015, 491, 191, 'CAROL AROS SEGUEL', 'CAROL AROS SEGUEL', '', false, 'None', 'CAROL', 'AROS SEGUEL');
INSERT INTO candidato VALUES (66015064, 'D', 64, 6015, 491, 191, 'ALEJANDRO VALDIVIA LATORRE', 'ALEJANDRO VALDIVIA LATORRE', '', false, 'None', 'ALEJANDRO', 'VALDIVIA LATORRE');
INSERT INTO candidato VALUES (66015065, 'D', 65, 6015, 491, 191, 'MAURICIO MELLA VASQUEZ', 'MAURICIO MELLA VASQUEZ', '', false, 'None', 'MAURICIO', 'MELLA VASQUEZ');
INSERT INTO candidato VALUES (66015066, 'D', 66, 6015, 491, 191, 'PABLO VASQUEZ PAVEZ', 'PABLO VASQUEZ PAVEZ', '', false, 'None', 'PABLO', 'VASQUEZ PAVEZ');
INSERT INTO candidato VALUES (66015067, 'D', 67, 6015, 491, 191, 'ALEX BECERRA ESPINOZA', 'ALEX BECERRA ESPINOZA', '', false, 'None', 'ALEX', 'BECERRA ESPINOZA');
INSERT INTO candidato VALUES (66015068, 'D', 68, 6015, 491, 191, 'PAZ SUAREZ BRIONES', 'PAZ SUAREZ BRIONES', '', false, 'None', 'PAZ', 'SUAREZ BRIONES');
INSERT INTO candidato VALUES (66015069, 'D', 69, 6015, 493, 200, 'DAMARIE MOYANO MADRID', 'DAMARIE MOYANO MADRID', '', false, 'None', 'DAMARIE', 'MOYANO MADRID');
INSERT INTO candidato VALUES (66015070, 'D', 70, 6015, 493, 200, 'LUIS ANTONIO DOTE ORELLANA', 'LUIS ANTONIO DOTE ORELLANA', '', false, 'None', 'LUIS ANTONIO', 'DOTE ORELLANA');
INSERT INTO candidato VALUES (66015071, 'D', 71, 6015, 493, 200, 'RICARDO LISBOA HENRIQUEZ', 'RICARDO LISBOA HENRIQUEZ', '', false, 'None', 'RICARDO', 'LISBOA HENRIQUEZ');
INSERT INTO candidato VALUES (66015072, 'D', 72, 6015, 493, 200, 'KATHERINE ALEJANDRA TOLEDO GUERRA', 'KATHERINE ALEJANDRA TOLEDO GUERRA', '', false, 'None', 'KATHERINE ALEJANDRA', 'TOLEDO GUERRA');
INSERT INTO candidato VALUES (66015073, 'D', 73, 6015, 493, 200, 'JUDITH MERCEDES CORNEJO TOLEDO', 'JUDITH MERCEDES CORNEJO TOLEDO', '', false, 'None', 'JUDITH MERCEDES', 'CORNEJO TOLEDO');
INSERT INTO candidato VALUES (66015074, 'D', 74, 6015, 489, 157, 'PEDRO GUBERNATTI TORO', 'PEDRO GUBERNATTI TORO', '', false, 'None', 'PEDRO', 'GUBERNATTI TORO');
INSERT INTO candidato VALUES (66015075, 'D', 75, 6015, 489, 157, 'MARCELA NARVAEZ ZAPATA', 'MARCELA NARVAEZ ZAPATA', '', false, 'None', 'MARCELA', 'NARVAEZ ZAPATA');
INSERT INTO candidato VALUES (66015076, 'D', 76, 6015, 489, 157, 'JOSE MIGUEL LATORRE LUDUEÑA', 'JOSE MIGUEL LATORRE LUDUEÑA', '', false, 'None', 'JOSE MIGUEL', 'LATORRE LUDUEÑA');
INSERT INTO candidato VALUES (66015077, 'D', 77, 6015, 489, 157, 'CARLA EUGENIA RUBIO CARRASCO', 'CARLA EUGENIA RUBIO CARRASCO', '', false, 'None', 'CARLA EUGENIA', 'RUBIO CARRASCO');
INSERT INTO candidato VALUES (66015078, 'D', 78, 6015, 489, 157, 'LUISA ELENA CACERES MIRANDA', 'LUISA ELENA CACERES MIRANDA', '', false, 'None', 'LUISA ELENA', 'CACERES MIRANDA');
INSERT INTO candidato VALUES (66015079, 'D', 79, 6015, 489, 157, 'RODRIGO PEÑAILILLO VALENZUELA', 'RODRIGO PEÑAILILLO VALENZUELA', '', false, 'None', 'RODRIGO', 'PEÑAILILLO VALENZUELA');
INSERT INTO candidato VALUES (66015080, 'D', 80, 6015, 485, 198, 'PATRICIO LAGUNA GEBAUER', 'PATRICIO LAGUNA GEBAUER', '', true, 'None', 'PATRICIO', 'LAGUNA GEBAUER');
INSERT INTO candidato VALUES (66015081, 'D', 81, 6015, 485, 198, 'LENNIN ARROYO VEGA', 'LENNIN ARROYO VEGA', '', true, 'None', 'LENNIN', 'ARROYO VEGA');
INSERT INTO candidato VALUES (66015082, 'D', 82, 6015, 485, 1, 'EMILIANO ORUETA BUSTOS', 'EMILIANO ORUETA BUSTOS', '', false, 'None', 'EMILIANO', 'ORUETA BUSTOS');
INSERT INTO candidato VALUES (66015083, 'D', 83, 6015, 485, 1, 'JUAN DE DIOS VALDIVIESO TAGLE', 'JUAN DE DIOS VALDIVIESO TAGLE', '', false, 'None', 'JUAN DE DIOS', 'VALDIVIESO TAGLE');
INSERT INTO candidato VALUES (66015084, 'D', 84, 6015, 485, 3, 'PIA MARGARIT BAHAMONDE', 'PIA MARGARIT BAHAMONDE', '', false, 'None', 'PIA', 'MARGARIT BAHAMONDE');
INSERT INTO candidato VALUES (66015085, 'D', 85, 6015, 485, 3, 'NATALIA ROMERO TALGUIA', 'NATALIA ROMERO TALGUIA', '', true, 'None', 'NATALIA', 'ROMERO TALGUIA');
INSERT INTO candidato VALUES (66015086, 'D', 86, 6015, 479, 197, 'PATRICIO ARENAS ROMAN', 'PATRICIO ARENAS ROMAN', '', false, 'None', 'PATRICIO', 'ARENAS ROMAN');
INSERT INTO candidato VALUES (66015087, 'D', 87, 6015, 479, 197, 'PAULA MUÑOZ CARRASCO', 'PAULA MUÑOZ CARRASCO', '', false, 'None', 'PAULA', 'MUÑOZ CARRASCO');
INSERT INTO candidato VALUES (66015088, 'D', 88, 6015, 479, 150, 'FERNANDO UGARTE TEJEDA', 'FERNANDO UGARTE TEJEDA', '', false, 'None', 'FERNANDO', 'UGARTE TEJEDA');
INSERT INTO candidato VALUES (66015089, 'D', 89, 6015, 479, 150, 'EMILIANO GARCIA BOBADILLA', 'EMILIANO GARCIA BOBADILLA', '', false, 'None', 'EMILIANO', 'GARCIA BOBADILLA');
INSERT INTO candidato VALUES (66015090, 'D', 90, 6015, 479, 235, 'CHRISTIAN VARGAS PAREDES', 'CHRISTIAN VARGAS PAREDES', '', false, 'None', 'CHRISTIAN', 'VARGAS PAREDES');
INSERT INTO candidato VALUES (66015091, 'D', 91, 6015, 479, 235, 'JAVIERA MORENO CERPA', 'JAVIERA MORENO CERPA', '', false, 'None', 'JAVIERA', 'MORENO CERPA');
INSERT INTO candidato VALUES (66016051, 'D', 51, 6016, 487, 130, 'ANTONIO CARVACHO CARDENAS', 'ANTONIO CARVACHO CARDENAS', '', false, 'None', 'ANTONIO', 'CARVACHO CARDENAS');
INSERT INTO candidato VALUES (66016052, 'D', 52, 6016, 487, 130, 'CRISTIAN DIAZ CORREA', 'CRISTIAN DIAZ CORREA', '', true, 'None', 'CRISTIAN', 'DIAZ CORREA');
INSERT INTO candidato VALUES (66016053, 'D', 53, 6016, 487, 130, 'JAIME GONZALEZ RAMIREZ', 'JAIME GONZALEZ RAMIREZ', '', true, 'None', 'JAIME', 'GONZALEZ RAMIREZ');
INSERT INTO candidato VALUES (66016054, 'D', 54, 6016, 487, 130, 'MARIA CAROLINA MIRANDA CAMPOS', 'MARIA CAROLINA MIRANDA CAMPOS', '', true, 'None', 'MARIA CAROLINA', 'MIRANDA CAMPOS');
INSERT INTO candidato VALUES (66016055, 'D', 55, 6016, 487, 190, 'PAMELA NAVARRO LEPPE', 'PAMELA NAVARRO LEPPE', '', true, 'None', 'PAMELA', 'NAVARRO LEPPE');
INSERT INTO candidato VALUES (66016056, 'D', 56, 6016, 483, 232, 'FELIX BUGUEÑO SOTELO', 'FELIX BUGUEÑO SOTELO', '', false, 'None', 'FELIX', 'BUGUEÑO SOTELO');
INSERT INTO candidato VALUES (66016057, 'D', 57, 6016, 483, 4, 'FLORENIA CARVAJAL CID', 'FLORENIA CARVAJAL CID', '', false, 'None', 'FLORENIA', 'CARVAJAL CID');
INSERT INTO candidato VALUES (66016058, 'D', 58, 6016, 483, 5, 'CAROLINA CUCUMIDES CALDERON', 'CAROLINA CUCUMIDES CALDERON', '', true, 'None', 'CAROLINA', 'CUCUMIDES CALDERON');
INSERT INTO candidato VALUES (66016059, 'D', 59, 6016, 483, 2, 'GLORIA PAREDES VALDES', 'GLORIA PAREDES VALDES', '', false, 'None', 'GLORIA', 'PAREDES VALDES');
INSERT INTO candidato VALUES (66016060, 'D', 60, 6016, 483, 7, 'COSME MELLADO PINO', 'COSME MELLADO PINO', '', false, 'None', 'COSME', 'MELLADO PINO');
INSERT INTO candidato VALUES (66016061, 'D', 61, 6016, 489, 157, 'SUSAN EVELYN GOMEZ PARDO', 'SUSAN EVELYN GOMEZ PARDO', '', false, 'None', 'SUSAN EVELYN', 'GOMEZ PARDO');
INSERT INTO candidato VALUES (66016062, 'D', 62, 6016, 489, 157, 'JOSE ANTONIO CARVALLO CASTRO', 'JOSE ANTONIO CARVALLO CASTRO', '', false, 'None', 'JOSE ANTONIO', 'CARVALLO CASTRO');
INSERT INTO candidato VALUES (66016063, 'D', 63, 6016, 489, 157, 'DANIELA DENISSE GAETE CORNEJO', 'DANIELA DENISSE GAETE CORNEJO', '', false, 'None', 'DANIELA DENISSE', 'GAETE CORNEJO');
INSERT INTO candidato VALUES (66016064, 'D', 64, 6016, 489, 157, 'HECTOR ANDRES SANCHEZ MORENO', 'HECTOR ANDRES SANCHEZ MORENO', '', false, 'None', 'HECTOR ANDRES', 'SANCHEZ MORENO');
INSERT INTO candidato VALUES (66016065, 'D', 65, 6016, 489, 157, 'RODRIGO ANDRES MALDONADO BECERRA', 'RODRIGO ANDRES MALDONADO BECERRA', '', false, 'None', 'RODRIGO ANDRES', 'MALDONADO BECERRA');
INSERT INTO candidato VALUES (66016066, 'D', 66, 6016, 485, 1, 'CARLA MORALES MALDONADO', 'CARLA MORALES MALDONADO', '', false, 'None', 'CARLA', 'MORALES MALDONADO');
INSERT INTO candidato VALUES (66016067, 'D', 67, 6016, 485, 1, 'HUMBERTO GARCIA DIAZ', 'HUMBERTO GARCIA DIAZ', '', true, 'None', 'HUMBERTO', 'GARCIA DIAZ');
INSERT INTO candidato VALUES (66016068, 'D', 68, 6016, 485, 37, 'IGNACIO MORI PEREZ', 'IGNACIO MORI PEREZ', '', false, 'None', 'IGNACIO', 'MORI PEREZ');
INSERT INTO candidato VALUES (66016069, 'D', 69, 6016, 485, 3, 'RICARDO NEUMANN BERTIN', 'RICARDO NEUMANN BERTIN', '', false, 'None', 'RICARDO', 'NEUMANN BERTIN');
INSERT INTO candidato VALUES (66016070, 'D', 70, 6016, 485, 3, 'EDUARDO CORNEJO LAGOS', 'EDUARDO CORNEJO LAGOS', '', false, 'None', 'EDUARDO', 'CORNEJO LAGOS');
INSERT INTO candidato VALUES (66016071, 'D', 71, 6016, 479, 150, 'SEBASTIAN CRISTOFFANINI JARAQUEMADA', 'SEBASTIAN CRISTOFFANINI JARAQUEMADA', '', false, 'None', 'SEBASTIAN', 'CRISTOFFANINI JARAQUEMADA');
INSERT INTO candidato VALUES (66016072, 'D', 72, 6016, 479, 150, 'MARIA DEL PILAR ZUÑIGA ZAMORANO', 'MARIA DEL PILAR ZUÑIGA ZAMORANO', '', false, 'None', 'MARIA DEL PILAR', 'ZUÑIGA ZAMORANO');
INSERT INTO candidato VALUES (66016073, 'D', 73, 6016, 479, 235, 'LUIS BUSTAMANTE MORAGA', 'LUIS BUSTAMANTE MORAGA', '', false, 'None', 'LUIS', 'BUSTAMANTE MORAGA');
INSERT INTO candidato VALUES (66016074, 'D', 74, 6016, 479, 197, 'FRANCISCO AVARIA MARRACCINI', 'FRANCISCO AVARIA MARRACCINI', '', false, 'None', 'FRANCISCO', 'AVARIA MARRACCINI');
INSERT INTO candidato VALUES (66017051, 'D', 51, 6017, 487, 130, 'JOSE EDUARDO GONZALEZ GAETE', 'JOSE EDUARDO GONZALEZ GAETE', '', false, 'None', 'JOSE EDUARDO', 'GONZALEZ GAETE');
INSERT INTO candidato VALUES (66017052, 'D', 52, 6017, 487, 130, 'MARISOL PEREZ SAAVEDRA', 'MARISOL PEREZ SAAVEDRA', '', false, 'None', 'MARISOL', 'PEREZ SAAVEDRA');
INSERT INTO candidato VALUES (66017053, 'D', 53, 6017, 487, 130, 'ELIA PIEDRAS GARRIDO', 'ELIA PIEDRAS GARRIDO', '', true, 'None', 'ELIA', 'PIEDRAS GARRIDO');
INSERT INTO candidato VALUES (66017054, 'D', 54, 6017, 487, 190, 'CLAUDIA MORALES COURTIN', 'CLAUDIA MORALES COURTIN', '', true, 'None', 'CLAUDIA', 'MORALES COURTIN');
INSERT INTO candidato VALUES (66017055, 'D', 55, 6017, 487, 190, 'JOSE IGNACIO AVELLO ORTIZ', 'JOSE IGNACIO AVELLO ORTIZ', '', true, 'None', 'JOSE IGNACIO', 'AVELLO ORTIZ');
INSERT INTO candidato VALUES (66017056, 'D', 56, 6017, 487, 190, 'SANDRA PATRICIA SANCHEZ AGUILAR', 'SANDRA PATRICIA SANCHEZ AGUILAR', '', true, 'None', 'SANDRA PATRICIA', 'SANCHEZ AGUILAR');
INSERT INTO candidato VALUES (66017057, 'D', 57, 6017, 487, 190, 'JOSE NUÑEZ HERRERA', 'JOSE NUÑEZ HERRERA', '', true, 'None', 'JOSE', 'NUÑEZ HERRERA');
INSERT INTO candidato VALUES (66017058, 'D', 58, 6017, 483, 232, 'ROBERTO CELEDON FERNANDEZ', 'ROBERTO CELEDON FERNANDEZ', '', true, 'None', 'ROBERTO', 'CELEDON FERNANDEZ');
INSERT INTO candidato VALUES (66017059, 'D', 59, 6017, 483, 232, 'NATALY ROJAS SEGUEL', 'NATALY ROJAS SEGUEL', '', false, 'None', 'NATALY', 'ROJAS SEGUEL');
INSERT INTO candidato VALUES (66017060, 'D', 60, 6017, 483, 2, 'PRISCILLA CASTILLO GERLI', 'PRISCILLA CASTILLO GERLI', '', false, 'None', 'PRISCILLA', 'CASTILLO GERLI');
INSERT INTO candidato VALUES (66017061, 'D', 61, 6017, 483, 2, 'JAVIER MUÑOZ RIQUELME', 'JAVIER MUÑOZ RIQUELME', '', false, 'None', 'JAVIER', 'MUÑOZ RIQUELME');
INSERT INTO candidato VALUES (66017062, 'D', 62, 6017, 483, 5, 'BORIS DURAN REYES', 'BORIS DURAN REYES', '', false, 'None', 'BORIS', 'DURAN REYES');
INSERT INTO candidato VALUES (66017063, 'D', 63, 6017, 483, 5, 'GABRIEL ROJAS ROJAS', 'GABRIEL ROJAS ROJAS', '', true, 'None', 'GABRIEL', 'ROJAS ROJAS');
INSERT INTO candidato VALUES (66017064, 'D', 64, 6017, 483, 7, 'ANA MUÑOZ MUÑOZ', 'ANA MUÑOZ MUÑOZ', '', true, 'None', 'ANA', 'MUÑOZ MUÑOZ');
INSERT INTO candidato VALUES (66017065, 'D', 65, 6017, 483, 7, 'PABLO DEL RIO JIMENEZ', 'PABLO DEL RIO JIMENEZ', '', false, 'None', 'PABLO', 'DEL RIO JIMENEZ');
INSERT INTO candidato VALUES (66017066, 'D', 66, 6017, 489, 157, 'GUILLERMO VICTORIANO VALDES CARMONA', 'GUILLERMO VICTORIANO VALDES CARMONA', '', false, 'None', 'GUILLERMO VICTORIANO', 'VALDES CARMONA');
INSERT INTO candidato VALUES (66017067, 'D', 67, 6017, 489, 157, 'VIVIANA DE LAS MERCEDES RODRIGUEZ SAAVEDRA', 'VIVIANA DE LAS MERCEDES RODRIGUEZ SAAVEDRA', '', false, 'None', 'VIVIANA DE LAS MERCEDES', 'RODRIGUEZ SAAVEDRA');
INSERT INTO candidato VALUES (66017068, 'D', 68, 6017, 489, 157, 'NICOLAS ENRIQUE GARCIA ESPINOZA', 'NICOLAS ENRIQUE GARCIA ESPINOZA', '', false, 'None', 'NICOLAS ENRIQUE', 'GARCIA ESPINOZA');
INSERT INTO candidato VALUES (66017069, 'D', 69, 6017, 489, 157, 'EDUARDO ALEXANDER OTEIZA VASQUEZ', 'EDUARDO ALEXANDER OTEIZA VASQUEZ', '', false, 'None', 'EDUARDO ALEXANDER', 'OTEIZA VASQUEZ');
INSERT INTO candidato VALUES (66017070, 'D', 70, 6017, 489, 157, 'ROSA IRENE BRAVO HERRERA', 'ROSA IRENE BRAVO HERRERA', '', false, 'None', 'ROSA IRENE', 'BRAVO HERRERA');
INSERT INTO candidato VALUES (66017071, 'D', 71, 6017, 489, 157, 'LORENA ALEJANDRA BALLADARES CHAMORRO', 'LORENA ALEJANDRA BALLADARES CHAMORRO', '', false, 'None', 'LORENA ALEJANDRA', 'BALLADARES CHAMORRO');
INSERT INTO candidato VALUES (66017072, 'D', 72, 6017, 489, 157, 'DANIELA FRANCISCA DIAZ GOMEZ', 'DANIELA FRANCISCA DIAZ GOMEZ', '', false, 'None', 'DANIELA FRANCISCA', 'DIAZ GOMEZ');
INSERT INTO candidato VALUES (66017073, 'D', 73, 6017, 489, 157, 'JAVIER MORALES MORALES', 'JAVIER MORALES MORALES', '', false, 'None', 'JAVIER', 'MORALES MORALES');
INSERT INTO candidato VALUES (66017074, 'D', 74, 6017, 485, 37, 'JORGE GUZMAN ZEPEDA', 'JORGE GUZMAN ZEPEDA', '', false, 'None', 'JORGE', 'GUZMAN ZEPEDA');
INSERT INTO candidato VALUES (66017075, 'D', 75, 6017, 485, 37, 'CLAUDIA URRUTIA MARQUEZ', 'CLAUDIA URRUTIA MARQUEZ', '', true, 'None', 'CLAUDIA', 'URRUTIA MARQUEZ');
INSERT INTO candidato VALUES (66017077, 'D', 77, 6017, 485, 1, 'BALDEMAR HIGUERAS VIVAR', 'BALDEMAR HIGUERAS VIVAR', '', true, 'None', 'BALDEMAR', 'HIGUERAS VIVAR');
INSERT INTO candidato VALUES (66017078, 'D', 78, 6017, 485, 198, 'ISABEL UBAL FAUNDEZ', 'ISABEL UBAL FAUNDEZ', '', false, 'None', 'ISABEL', 'UBAL FAUNDEZ');
INSERT INTO candidato VALUES (66017079, 'D', 79, 6017, 485, 3, 'CAROLINA TORRES PIRAZZOLI', 'CAROLINA TORRES PIRAZZOLI', '', false, 'None', 'CAROLINA', 'TORRES PIRAZZOLI');
INSERT INTO candidato VALUES (66017080, 'D', 80, 6017, 485, 3, 'FELIPE DONOSO CASTRO', 'FELIPE DONOSO CASTRO', '', false, 'None', 'FELIPE', 'DONOSO CASTRO');
INSERT INTO candidato VALUES (66017081, 'D', 81, 6017, 479, 150, 'BENJAMIN MORENO BASCUR', 'BENJAMIN MORENO BASCUR', '', false, 'None', 'BENJAMIN', 'MORENO BASCUR');
INSERT INTO candidato VALUES (66017082, 'D', 82, 6017, 479, 150, 'GREIS PARADA ROJAS', 'GREIS PARADA ROJAS', '', false, 'None', 'GREIS', 'PARADA ROJAS');
INSERT INTO candidato VALUES (66017083, 'D', 83, 6017, 479, 150, 'BERNARDO FONTAINE MONTERO', 'BERNARDO FONTAINE MONTERO', '', true, 'None', 'BERNARDO', 'FONTAINE MONTERO');
INSERT INTO candidato VALUES (66017084, 'D', 84, 6017, 479, 235, 'MARIO CARAVES HECK', 'MARIO CARAVES HECK', '', false, 'None', 'MARIO', 'CARAVES HECK');
INSERT INTO candidato VALUES (66017085, 'D', 85, 6017, 479, 235, 'GERMAN VERDUGO SOTO', 'GERMAN VERDUGO SOTO', '', false, 'None', 'GERMAN', 'VERDUGO SOTO');
INSERT INTO candidato VALUES (66017086, 'D', 86, 6017, 479, 197, 'PATRICIO LINEROS GONZALEZ', 'PATRICIO LINEROS GONZALEZ', '', false, 'None', 'PATRICIO', 'LINEROS GONZALEZ');
INSERT INTO candidato VALUES (66017087, 'D', 87, 6017, 479, 197, 'BERNARDO VASQUEZ BOBADILLA', 'BERNARDO VASQUEZ BOBADILLA', '', false, 'None', 'BERNARDO', 'VASQUEZ BOBADILLA');
INSERT INTO candidato VALUES (66017088, 'D', 88, 6017, 479, 197, 'FERNANDA AGUIRRE TORRES', 'FERNANDA AGUIRRE TORRES', '', false, 'None', 'FERNANDA', 'AGUIRRE TORRES');
INSERT INTO candidato VALUES (66018051, 'D', 51, 6018, 487, 190, 'RODRIGO BRAVO BUSTOS', 'RODRIGO BRAVO BUSTOS', '', false, 'None', 'RODRIGO', 'BRAVO BUSTOS');
INSERT INTO candidato VALUES (66018052, 'D', 52, 6018, 487, 190, 'PAULINA ALVAREZ RODRIGUEZ', 'PAULINA ALVAREZ RODRIGUEZ', '', true, 'None', 'PAULINA', 'ALVAREZ RODRIGUEZ');
INSERT INTO candidato VALUES (66018053, 'D', 53, 6018, 487, 190, 'EDWARD ROBINSON FLORES Y CASTILLO', 'EDWARD ROBINSON FLORES Y CASTILLO', '', true, 'None', 'EDWARD', 'ROBINSON FLORES Y CASTILLO');
INSERT INTO candidato VALUES (66018054, 'D', 54, 6018, 487, 130, 'DAPHNE SALDAÑA SAN MARTIN', 'DAPHNE SALDAÑA SAN MARTIN', '', true, 'None', 'DAPHNE', 'SALDAÑA SAN MARTIN');
INSERT INTO candidato VALUES (66018055, 'D', 55, 6018, 487, 130, 'ANGELA SELMIRA VELIZ GONZALEZ', 'ANGELA SELMIRA VELIZ GONZALEZ', '', true, 'None', 'ANGELA SELMIRA', 'VELIZ GONZALEZ');
INSERT INTO candidato VALUES (66018056, 'D', 56, 6018, 483, 7, 'CONSUELO VELOSO AVILA', 'CONSUELO VELOSO AVILA', '', true, 'None', 'CONSUELO', 'VELOSO AVILA');
INSERT INTO candidato VALUES (66018057, 'D', 57, 6018, 483, 2, 'LUCIA GONZALEZ GAETE', 'LUCIA GONZALEZ GAETE', '', false, 'None', 'LUCIA', 'GONZALEZ GAETE');
INSERT INTO candidato VALUES (66018058, 'D', 58, 6018, 483, 5, 'RODRIGO HERMOSILLA GATICA', 'RODRIGO HERMOSILLA GATICA', '', false, 'None', 'RODRIGO', 'HERMOSILLA GATICA');
INSERT INTO candidato VALUES (66018059, 'D', 59, 6018, 483, 4, 'MONICA MUÑOZ GUAJARDO', 'MONICA MUÑOZ GUAJARDO', '', false, 'None', 'MONICA', 'MUÑOZ GUAJARDO');
INSERT INTO candidato VALUES (66018060, 'D', 60, 6018, 483, 232, 'KARINA CARTAGENA BASTIAS', 'KARINA CARTAGENA BASTIAS', '', false, 'None', 'KARINA', 'CARTAGENA BASTIAS');
INSERT INTO candidato VALUES (66018061, 'D', 61, 6018, 489, 157, 'RUBEN IGNACIO MARTINEZ NUÑEZ', 'RUBEN IGNACIO MARTINEZ NUÑEZ', '', false, 'None', 'RUBEN IGNACIO', 'MARTINEZ NUÑEZ');
INSERT INTO candidato VALUES (66018062, 'D', 62, 6018, 489, 157, 'DANIELA DEL PILAR OLGUIN ANDRADE', 'DANIELA DEL PILAR OLGUIN ANDRADE', '', false, 'None', 'DANIELA DEL PILAR', 'OLGUIN ANDRADE');
INSERT INTO candidato VALUES (66018063, 'D', 63, 6018, 489, 157, 'CARLOS ANTONIO BASCUÑAN TAPIA', 'CARLOS ANTONIO BASCUÑAN TAPIA', '', false, 'None', 'CARLOS ANTONIO', 'BASCUÑAN TAPIA');
INSERT INTO candidato VALUES (66018064, 'D', 64, 6018, 489, 157, 'CAROLINA ALEJANDRA MORALES ORTEGA', 'CAROLINA ALEJANDRA MORALES ORTEGA', '', false, 'None', 'CAROLINA ALEJANDRA', 'MORALES ORTEGA');
INSERT INTO candidato VALUES (66018065, 'D', 65, 6018, 489, 157, 'RODRIGO REIMUNDO VERGARA VALDES', 'RODRIGO REIMUNDO VERGARA VALDES', '', false, 'None', 'RODRIGO REIMUNDO', 'VERGARA VALDES');
INSERT INTO candidato VALUES (66018066, 'D', 66, 6018, 485, 3, 'GUSTAVO BENAVENTE VERGARA', 'GUSTAVO BENAVENTE VERGARA', '', false, 'None', 'GUSTAVO', 'BENAVENTE VERGARA');
INSERT INTO candidato VALUES (66018067, 'D', 67, 6018, 485, 3, 'PAULA RETAMAL URRUTIA', 'PAULA RETAMAL URRUTIA', '', true, 'None', 'PAULA', 'RETAMAL URRUTIA');
INSERT INTO candidato VALUES (66018068, 'D', 68, 6018, 485, 198, 'GLADYS GONZALEZ ALVAREZ', 'GLADYS GONZALEZ ALVAREZ', '', true, 'None', 'GLADYS', 'GONZALEZ ALVAREZ');
INSERT INTO candidato VALUES (66018069, 'D', 69, 6018, 485, 1, 'RODRIGO RAMIREZ PARRA', 'RODRIGO RAMIREZ PARRA', '', true, 'None', 'RODRIGO', 'RAMIREZ PARRA');
INSERT INTO candidato VALUES (66018070, 'D', 70, 6018, 485, 1, 'MACARENA SAN MARTIN FREIRE', 'MACARENA SAN MARTIN FREIRE', '', false, 'None', 'MACARENA', 'SAN MARTIN FREIRE');
INSERT INTO candidato VALUES (66018071, 'D', 71, 6018, 479, 197, 'GENESIS VELOSO LOBOS', 'GENESIS VELOSO LOBOS', '', false, 'None', 'GENESIS', 'VELOSO LOBOS');
INSERT INTO candidato VALUES (66018072, 'D', 72, 6018, 479, 150, 'CRISTOBAL GARCIA OGAZ', 'CRISTOBAL GARCIA OGAZ', '', false, 'None', 'CRISTOBAL', 'GARCIA OGAZ');
INSERT INTO candidato VALUES (66018073, 'D', 73, 6018, 479, 150, 'DANIEL BUSTOS LEAL', 'DANIEL BUSTOS LEAL', '', false, 'None', 'DANIEL', 'BUSTOS LEAL');
INSERT INTO candidato VALUES (66018074, 'D', 74, 6018, 479, 150, 'CRISTIAN MENCHACA PINOCHET', 'CRISTIAN MENCHACA PINOCHET', '', true, 'None', 'CRISTIAN', 'MENCHACA PINOCHET');
INSERT INTO candidato VALUES (66018075, 'D', 75, 6018, 479, 235, 'JOAQUIN MORALES GOMEZ', 'JOAQUIN MORALES GOMEZ', '', false, 'None', 'JOAQUIN', 'MORALES GOMEZ');
INSERT INTO candidato VALUES (66019051, 'D', 51, 6019, 499, 236, 'FELIPE AYLWIN LAGOS', 'FELIPE AYLWIN LAGOS', '', false, 'None', 'FELIPE', 'AYLWIN LAGOS');
INSERT INTO candidato VALUES (66019052, 'D', 52, 6019, 499, 236, 'GRACIELA HUENUMAN LINCOPI', 'GRACIELA HUENUMAN LINCOPI', '', false, 'None', 'GRACIELA', 'HUENUMAN LINCOPI');
INSERT INTO candidato VALUES (66019053, 'D', 53, 6019, 499, 236, 'PATRICIO ANTONIO PALMA MOLINA', 'PATRICIO ANTONIO PALMA MOLINA', '', false, 'None', 'PATRICIO ANTONIO', 'PALMA MOLINA');
INSERT INTO candidato VALUES (66019054, 'D', 54, 6019, 499, 236, 'ELIANA SANHUEZA ORTIZ', 'ELIANA SANHUEZA ORTIZ', '', false, 'None', 'ELIANA', 'SANHUEZA ORTIZ');
INSERT INTO candidato VALUES (66019055, 'D', 55, 6019, 499, 236, 'CAROLINA MONSALVES SANHUEZA', 'CAROLINA MONSALVES SANHUEZA', '', false, 'None', 'CAROLINA', 'MONSALVES SANHUEZA');
INSERT INTO candidato VALUES (66019056, 'D', 56, 6019, 499, 236, 'JUAN MANUEL RIVAS GARRIDO', 'JUAN MANUEL RIVAS GARRIDO', '', false, 'None', 'JUAN MANUEL', 'RIVAS GARRIDO');
INSERT INTO candidato VALUES (66019057, 'D', 57, 6019, 487, 130, 'WILSON OLIVARES BUSTAMANTE', 'WILSON OLIVARES BUSTAMANTE', '', true, 'None', 'WILSON', 'OLIVARES BUSTAMANTE');
INSERT INTO candidato VALUES (66019058, 'D', 58, 6019, 487, 130, 'MARIA ROMERO PEÑA', 'MARIA ROMERO PEÑA', '', false, 'None', 'MARIA', 'ROMERO PEÑA');
INSERT INTO candidato VALUES (66019059, 'D', 59, 6019, 487, 130, 'CATALINA MEDINA RIVAS', 'CATALINA MEDINA RIVAS', '', false, 'None', 'CATALINA', 'MEDINA RIVAS');
INSERT INTO candidato VALUES (66019060, 'D', 60, 6019, 487, 130, 'FANNY ARAYA BAHAMONDE', 'FANNY ARAYA BAHAMONDE', '', false, 'None', 'FANNY', 'ARAYA BAHAMONDE');
INSERT INTO candidato VALUES (66019061, 'D', 61, 6019, 487, 130, 'PATRICIA TORRES ASTETE', 'PATRICIA TORRES ASTETE', '', false, 'None', 'PATRICIA', 'TORRES ASTETE');
INSERT INTO candidato VALUES (66019062, 'D', 62, 6019, 483, 2, 'FELIPE CAMAÑO CARDENAS', 'FELIPE CAMAÑO CARDENAS', '', true, 'None', 'FELIPE', 'CAMAÑO CARDENAS');
INSERT INTO candidato VALUES (66019063, 'D', 63, 6019, 483, 232, 'ERICK SOLO DE ZALDIVAR GARAY', 'ERICK SOLO DE ZALDIVAR GARAY', '', false, 'None', 'ERICK', 'SOLO DE ZALDIVAR GARAY');
INSERT INTO candidato VALUES (66019064, 'D', 64, 6019, 483, 137, 'JOSEFA JAVIERA DEL PILAR BALMACEDA VASQUEZ', 'JOSEFA JAVIERA DEL PILAR BALMACEDA VASQUEZ', '', true, 'None', 'JOSEFA JAVIERA DEL PILAR', 'BALMACEDA VASQUEZ');
INSERT INTO candidato VALUES (66019065, 'D', 65, 6019, 483, 7, 'CESAR RIQUELME ALARCON', 'CESAR RIQUELME ALARCON', '', false, 'None', 'CESAR', 'RIQUELME ALARCON');
INSERT INTO candidato VALUES (66019066, 'D', 66, 6019, 483, 5, 'FRANCISCO CRISOSTOMO LLANOS', 'FRANCISCO CRISOSTOMO LLANOS', '', false, 'None', 'FRANCISCO', 'CRISOSTOMO LLANOS');
INSERT INTO candidato VALUES (66019067, 'D', 67, 6019, 483, 4, 'SCARLET HIDALGO JARA', 'SCARLET HIDALGO JARA', '', false, 'None', 'SCARLET', 'HIDALGO JARA');
INSERT INTO candidato VALUES (66019068, 'D', 68, 6019, 481, 201, 'CESAR URIBE ARAYA', 'CESAR URIBE ARAYA', '', true, 'None', 'CESAR', 'URIBE ARAYA');
INSERT INTO candidato VALUES (66019069, 'D', 69, 6019, 481, 201, 'EDUARDO SAVATTINI NUÑEZ', 'EDUARDO SAVATTINI NUÑEZ', '', false, 'None', 'EDUARDO', 'SAVATTINI NUÑEZ');
INSERT INTO candidato VALUES (66019070, 'D', 70, 6019, 481, 201, 'SUSANA YAÑEZ BALAGUE', 'SUSANA YAÑEZ BALAGUE', '', true, 'None', 'SUSANA', 'YAÑEZ BALAGUE');
INSERT INTO candidato VALUES (66019071, 'D', 71, 6019, 481, 201, 'VALENTINA IBARRA MOYA', 'VALENTINA IBARRA MOYA', '', false, 'None', 'VALENTINA', 'IBARRA MOYA');
INSERT INTO candidato VALUES (66019072, 'D', 72, 6019, 481, 201, 'JAMES MERY BELL', 'JAMES MERY BELL', '', true, 'None', 'JAMES', 'MERY BELL');
INSERT INTO candidato VALUES (66019073, 'D', 73, 6019, 481, 201, 'PATRICIO SAN MARTIN SOLIS', 'PATRICIO SAN MARTIN SOLIS', '', true, 'None', 'PATRICIO', 'SAN MARTIN SOLIS');
INSERT INTO candidato VALUES (66019074, 'D', 74, 6019, 491, 191, 'REINALDO HENRY FIGUEROA ALARCON', 'REINALDO HENRY FIGUEROA ALARCON', '', false, 'None', 'REINALDO HENRY', 'FIGUEROA ALARCON');
INSERT INTO candidato VALUES (66019075, 'D', 75, 6019, 491, 191, 'OSVALDO ANTONIO CARO CARO', 'OSVALDO ANTONIO CARO CARO', '', false, 'None', 'OSVALDO ANTONIO', 'CARO CARO');
INSERT INTO candidato VALUES (66019076, 'D', 76, 6019, 491, 191, 'RODRIGO ANDRES CASTRO GALAZ', 'RODRIGO ANDRES CASTRO GALAZ', '', false, 'None', 'RODRIGO ANDRES', 'CASTRO GALAZ');
INSERT INTO candidato VALUES (66019077, 'D', 77, 6019, 491, 191, 'CECILIA VICTORIA ROXANA JACQUELINE ORTIZ VERA', 'CECILIA VICTORIA ROXANA JACQUELINE ORTIZ VERA', '', false, 'None', 'CECILIA VICTORIA ROXANA JACQUELINE', 'ORTIZ VERA');
INSERT INTO candidato VALUES (66019078, 'D', 78, 6019, 491, 191, 'SERGIO HERMAN CONTRERAS NAVARRO', 'SERGIO HERMAN CONTRERAS NAVARRO', '', false, 'None', 'SERGIO HERMAN', 'CONTRERAS NAVARRO');
INSERT INTO candidato VALUES (66019079, 'D', 79, 6019, 491, 191, 'HERNAN ALVAREZ ROMAN', 'HERNAN ALVAREZ ROMAN', '', false, 'None', 'HERNAN', 'ALVAREZ ROMAN');
INSERT INTO candidato VALUES (66019080, 'D', 80, 6019, 493, 200, 'JULIA LETICIA ZAPPETTINI VASQUEZ', 'JULIA LETICIA ZAPPETTINI VASQUEZ', '', false, 'None', 'JULIA LETICIA', 'ZAPPETTINI VASQUEZ');
INSERT INTO candidato VALUES (66019081, 'D', 81, 6019, 493, 200, 'RICARDO RODRIGUEZ RIVAS', 'RICARDO RODRIGUEZ RIVAS', '', false, 'None', 'RICARDO', 'RODRIGUEZ RIVAS');
INSERT INTO candidato VALUES (66019082, 'D', 82, 6019, 493, 200, 'OSCAR MIGUEL MONTECINOS GARCIA', 'OSCAR MIGUEL MONTECINOS GARCIA', '', false, 'None', 'OSCAR MIGUEL', 'MONTECINOS GARCIA');
INSERT INTO candidato VALUES (66019083, 'D', 83, 6019, 489, 157, 'DANIEL GODOY LAGOS', 'DANIEL GODOY LAGOS', '', false, 'None', 'DANIEL', 'GODOY LAGOS');
INSERT INTO candidato VALUES (66019084, 'D', 84, 6019, 489, 157, 'JENIFFER CAROLINA SALAZAR ZUÑIGA', 'JENIFFER CAROLINA SALAZAR ZUÑIGA', '', false, 'None', 'JENIFFER CAROLINA', 'SALAZAR ZUÑIGA');
INSERT INTO candidato VALUES (66019085, 'D', 85, 6019, 489, 157, 'HECTOR GUZMAN VASQUEZ', 'HECTOR GUZMAN VASQUEZ', '', false, 'None', 'HECTOR', 'GUZMAN VASQUEZ');
INSERT INTO candidato VALUES (66019086, 'D', 86, 6019, 489, 157, 'IGNACIO LUENGO QUIJADA', 'IGNACIO LUENGO QUIJADA', '', false, 'None', 'IGNACIO', 'LUENGO QUIJADA');
INSERT INTO candidato VALUES (66019087, 'D', 87, 6019, 489, 157, 'MARIELA ESPINOZA NAVARRETE', 'MARIELA ESPINOZA NAVARRETE', '', false, 'None', 'MARIELA', 'ESPINOZA NAVARRETE');
INSERT INTO candidato VALUES (66019088, 'D', 88, 6019, 489, 157, 'CLIFF HENRIQUEZ RETAMAL', 'CLIFF HENRIQUEZ RETAMAL', '', false, 'None', 'CLIFF', 'HENRIQUEZ RETAMAL');
INSERT INTO candidato VALUES (66019089, 'D', 89, 6019, 485, 3, 'CRISTOBAL MARTINEZ RAMIREZ', 'CRISTOBAL MARTINEZ RAMIREZ', '', false, 'None', 'CRISTOBAL', 'MARTINEZ RAMIREZ');
INSERT INTO candidato VALUES (66019090, 'D', 90, 6019, 485, 3, 'MARTA BRAVO SALINAS', 'MARTA BRAVO SALINAS', '', false, 'None', 'MARTA', 'BRAVO SALINAS');
INSERT INTO candidato VALUES (66019091, 'D', 91, 6019, 485, 1, 'FRANK SAUERBAUM MUÑOZ', 'FRANK SAUERBAUM MUÑOZ', '', false, 'None', 'FRANK', 'SAUERBAUM MUÑOZ');
INSERT INTO candidato VALUES (66019092, 'D', 92, 6019, 485, 1, 'CARLOS CHANDIA ALARCON', 'CARLOS CHANDIA ALARCON', '', false, 'None', 'CARLOS', 'CHANDIA ALARCON');
INSERT INTO candidato VALUES (66019093, 'D', 93, 6019, 485, 198, 'PATRICIO CAAMAÑO VIVEROS', 'PATRICIO CAAMAÑO VIVEROS', '', true, 'None', 'PATRICIO', 'CAAMAÑO VIVEROS');
INSERT INTO candidato VALUES (66019094, 'D', 94, 6019, 485, 198, 'JORGE SABAG VILLALOBOS', 'JORGE SABAG VILLALOBOS', '', true, 'None', 'JORGE', 'SABAG VILLALOBOS');
INSERT INTO candidato VALUES (66019095, 'D', 95, 6019, 479, 197, 'SARA CONCHA SMITH', 'SARA CONCHA SMITH', '', false, 'None', 'SARA', 'CONCHA SMITH');
INSERT INTO candidato VALUES (66019096, 'D', 96, 6019, 479, 197, 'ERICK JIMENEZ GARAY', 'ERICK JIMENEZ GARAY', '', false, 'None', 'ERICK', 'JIMENEZ GARAY');
INSERT INTO candidato VALUES (66019097, 'D', 97, 6019, 479, 197, 'ALEJANDRA OSORIO CORTES', 'ALEJANDRA OSORIO CORTES', '', false, 'None', 'ALEJANDRA', 'OSORIO CORTES');
INSERT INTO candidato VALUES (66019098, 'D', 98, 6019, 479, 150, 'MAGDALENA OYARCE SEPULVEDA', 'MAGDALENA OYARCE SEPULVEDA', '', false, 'None', 'MAGDALENA', 'OYARCE SEPULVEDA');
INSERT INTO candidato VALUES (66019099, 'D', 99, 6019, 479, 150, 'DIEGO SEPULVEDA PALMA', 'DIEGO SEPULVEDA PALMA', '', false, 'None', 'DIEGO', 'SEPULVEDA PALMA');
INSERT INTO candidato VALUES (66019100, 'D', 100, 6019, 479, 235, 'FREDDY BLANC SPERBERG', 'FREDDY BLANC SPERBERG', '', false, 'None', 'FREDDY', 'BLANC SPERBERG');
INSERT INTO candidato VALUES (66020051, 'D', 51, 6020, 499, 236, 'FELIX GONZALEZ GATICA', 'FELIX GONZALEZ GATICA', '', false, 'None', 'FELIX', 'GONZALEZ GATICA');
INSERT INTO candidato VALUES (66020052, 'D', 52, 6020, 499, 236, 'ELIZABETH MUJICA ZEPEDA', 'ELIZABETH MUJICA ZEPEDA', '', false, 'None', 'ELIZABETH', 'MUJICA ZEPEDA');
INSERT INTO candidato VALUES (66020053, 'D', 53, 6020, 499, 236, 'HERNAN PINO SEGUEL', 'HERNAN PINO SEGUEL', '', false, 'None', 'HERNAN', 'PINO SEGUEL');
INSERT INTO candidato VALUES (66020054, 'D', 54, 6020, 499, 236, 'ATRIX BADILLA HERNANDEZ', 'ATRIX BADILLA HERNANDEZ', '', false, 'None', 'ATRIX', 'BADILLA HERNANDEZ');
INSERT INTO candidato VALUES (66020055, 'D', 55, 6020, 499, 236, 'FELIPE ARANCIBIA LABRAÑA', 'FELIPE ARANCIBIA LABRAÑA', '', false, 'None', 'FELIPE', 'ARANCIBIA LABRAÑA');
INSERT INTO candidato VALUES (66020056, 'D', 56, 6020, 499, 236, 'PAULA OLIMPIA VALDEBENITO CHAVEZ', 'PAULA OLIMPIA VALDEBENITO CHAVEZ', '', false, 'None', 'PAULA OLIMPIA', 'VALDEBENITO CHAVEZ');
INSERT INTO candidato VALUES (66020057, 'D', 57, 6020, 499, 236, 'JAVIER MUÑOZ CAUCHUPAN', 'JAVIER MUÑOZ CAUCHUPAN', '', false, 'None', 'JAVIER', 'MUÑOZ CAUCHUPAN');
INSERT INTO candidato VALUES (66020058, 'D', 58, 6020, 499, 236, 'MARISOL VIDAL FRIZ', 'MARISOL VIDAL FRIZ', '', false, 'None', 'MARISOL', 'VIDAL FRIZ');
INSERT INTO candidato VALUES (66020059, 'D', 59, 6020, 499, 236, 'MANUEL JARA BAO', 'MANUEL JARA BAO', '', false, 'None', 'MANUEL', 'JARA BAO');
INSERT INTO candidato VALUES (66020060, 'D', 60, 6020, 487, 130, 'ANA ALBORNOZ CUEVAS', 'ANA ALBORNOZ CUEVAS', '', true, 'None', 'ANA', 'ALBORNOZ CUEVAS');
INSERT INTO candidato VALUES (66020061, 'D', 61, 6020, 487, 130, 'ELSA OLAVE SOTO', 'ELSA OLAVE SOTO', '', true, 'None', 'ELSA', 'OLAVE SOTO');
INSERT INTO candidato VALUES (66020062, 'D', 62, 6020, 487, 130, 'ROMINA TOLEDO QUEVEDO', 'ROMINA TOLEDO QUEVEDO', '', true, 'None', 'ROMINA', 'TOLEDO QUEVEDO');
INSERT INTO candidato VALUES (66020063, 'D', 63, 6020, 487, 130, 'MARIO GONZALEZ FIGUEROA', 'MARIO GONZALEZ FIGUEROA', '', false, 'None', 'MARIO', 'GONZALEZ FIGUEROA');
INSERT INTO candidato VALUES (66020064, 'D', 64, 6020, 487, 130, 'ALEJANDRO NAVARRO BRAIN', 'ALEJANDRO NAVARRO BRAIN', '', true, 'None', 'ALEJANDRO', 'NAVARRO BRAIN');
INSERT INTO candidato VALUES (66020065, 'D', 65, 6020, 487, 130, 'GUSTAVO SOTOMAYOR OLATE', 'GUSTAVO SOTOMAYOR OLATE', '', true, 'None', 'GUSTAVO', 'SOTOMAYOR OLATE');
INSERT INTO candidato VALUES (66020066, 'D', 66, 6020, 487, 130, 'FELIPE ROMERO PEDREROS', 'FELIPE ROMERO PEDREROS', '', true, 'None', 'FELIPE', 'ROMERO PEDREROS');
INSERT INTO candidato VALUES (66020067, 'D', 67, 6020, 487, 130, 'JORGE AGUAYO CERRO', 'JORGE AGUAYO CERRO', '', true, 'None', 'JORGE', 'AGUAYO CERRO');
INSERT INTO candidato VALUES (66020068, 'D', 68, 6020, 483, 6, 'MARIA CANDELARIA ACEVEDO SAEZ', 'MARIA CANDELARIA ACEVEDO SAEZ', '', false, 'None', 'MARIA CANDELARIA', 'ACEVEDO SAEZ');
INSERT INTO candidato VALUES (66020069, 'D', 69, 6020, 483, 6, 'EDUARDO BARRA JOFRE', 'EDUARDO BARRA JOFRE', '', false, 'None', 'EDUARDO', 'BARRA JOFRE');
INSERT INTO candidato VALUES (66020070, 'D', 70, 6020, 483, 4, 'ALICIA YAÑEZ SOTO', 'ALICIA YAÑEZ SOTO', '', false, 'None', 'ALICIA', 'YAÑEZ SOTO');
INSERT INTO candidato VALUES (66020071, 'D', 71, 6020, 483, 137, 'CAROLINA BEATRIZ MARTINEZ EBNER', 'CAROLINA BEATRIZ MARTINEZ EBNER', '', false, 'None', 'CAROLINA BEATRIZ', 'MARTINEZ EBNER');
INSERT INTO candidato VALUES (66020072, 'D', 72, 6020, 483, 232, 'DANIELA DRESDNER VICENCIO', 'DANIELA DRESDNER VICENCIO', '', false, 'None', 'DANIELA', 'DRESDNER VICENCIO');
INSERT INTO candidato VALUES (66020073, 'D', 73, 6020, 483, 7, 'MACARENA FLORES MONTOYA', 'MACARENA FLORES MONTOYA', '', false, 'None', 'MACARENA', 'FLORES MONTOYA');
INSERT INTO candidato VALUES (66020074, 'D', 74, 6020, 483, 5, 'ANTONIO RIVAS VILLALOBOS', 'ANTONIO RIVAS VILLALOBOS', '', false, 'None', 'ANTONIO', 'RIVAS VILLALOBOS');
INSERT INTO candidato VALUES (66020075, 'D', 75, 6020, 483, 2, 'ALVARO ORTIZ VERA', 'ALVARO ORTIZ VERA', '', false, 'None', 'ALVARO', 'ORTIZ VERA');
INSERT INTO candidato VALUES (66020076, 'D', 76, 6020, 483, 2, 'ERIC AEDO JELDRES', 'ERIC AEDO JELDRES', '', false, 'None', 'ERIC', 'AEDO JELDRES');
INSERT INTO candidato VALUES (66020077, 'D', 77, 6020, 481, 201, 'JAVIER SANDOVAL OJEDA', 'JAVIER SANDOVAL OJEDA', '', false, 'None', 'JAVIER', 'SANDOVAL OJEDA');
INSERT INTO candidato VALUES (66020078, 'D', 78, 6020, 481, 201, 'CAMILA ARRIAGADA GONZALEZ', 'CAMILA ARRIAGADA GONZALEZ', '', false, 'None', 'CAMILA', 'ARRIAGADA GONZALEZ');
INSERT INTO candidato VALUES (66020079, 'D', 79, 6020, 481, 201, 'XIMENA MUÑOZ VALLEJOS', 'XIMENA MUÑOZ VALLEJOS', '', false, 'None', 'XIMENA', 'MUÑOZ VALLEJOS');
INSERT INTO candidato VALUES (66020080, 'D', 80, 6020, 481, 201, 'ELIANA QUEVEDO HERNANDEZ', 'ELIANA QUEVEDO HERNANDEZ', '', true, 'None', 'ELIANA', 'QUEVEDO HERNANDEZ');
INSERT INTO candidato VALUES (66020081, 'D', 81, 6020, 481, 201, 'MAURICIO SANDOVAL SALAZAR', 'MAURICIO SANDOVAL SALAZAR', '', true, 'None', 'MAURICIO', 'SANDOVAL SALAZAR');
INSERT INTO candidato VALUES (66020082, 'D', 82, 6020, 481, 201, 'ANGELICA ALVAREZ RODRIGUEZ', 'ANGELICA ALVAREZ RODRIGUEZ', '', true, 'None', 'ANGELICA', 'ALVAREZ RODRIGUEZ');
INSERT INTO candidato VALUES (66020083, 'D', 83, 6020, 481, 201, 'MELISSA SANTIBAÑEZ MANCILLA', 'MELISSA SANTIBAÑEZ MANCILLA', '', true, 'None', 'MELISSA', 'SANTIBAÑEZ MANCILLA');
INSERT INTO candidato VALUES (66020084, 'D', 84, 6020, 481, 201, 'JAVIER DEL RIO RICHTER', 'JAVIER DEL RIO RICHTER', '', true, 'None', 'JAVIER', 'DEL RIO RICHTER');
INSERT INTO candidato VALUES (66020085, 'D', 85, 6020, 489, 157, 'PATRICIO ANTONIO BRIONES MOLLER', 'PATRICIO ANTONIO BRIONES MOLLER', '', false, 'None', 'PATRICIO ANTONIO', 'BRIONES MOLLER');
INSERT INTO candidato VALUES (66020086, 'D', 86, 6020, 489, 157, 'CAROLINA ANDREA VENEGAS ARANDA', 'CAROLINA ANDREA VENEGAS ARANDA', '', false, 'None', 'CAROLINA ANDREA', 'VENEGAS ARANDA');
INSERT INTO candidato VALUES (66020087, 'D', 87, 6020, 489, 157, 'HUGO ANTONIO SOTO BECERRA', 'HUGO ANTONIO SOTO BECERRA', '', false, 'None', 'HUGO ANTONIO', 'SOTO BECERRA');
INSERT INTO candidato VALUES (66020088, 'D', 88, 6020, 489, 157, 'MARIELLA ANDREA GONZALEZ HIDALGO', 'MARIELLA ANDREA GONZALEZ HIDALGO', '', false, 'None', 'MARIELLA ANDREA', 'GONZALEZ HIDALGO');
INSERT INTO candidato VALUES (66020089, 'D', 89, 6020, 489, 157, 'LUIS ZUÑIGA MONTT', 'LUIS ZUÑIGA MONTT', '', false, 'None', 'LUIS', 'ZUÑIGA MONTT');
INSERT INTO candidato VALUES (66020090, 'D', 90, 6020, 489, 157, 'MARCELA ANDREA GONZALEZ ZARATE', 'MARCELA ANDREA GONZALEZ ZARATE', '', false, 'None', 'MARCELA ANDREA', 'GONZALEZ ZARATE');
INSERT INTO candidato VALUES (66020091, 'D', 91, 6020, 489, 157, 'BERNARDO ORLANDO ULLOA PEREIRA', 'BERNARDO ORLANDO ULLOA PEREIRA', '', false, 'None', 'BERNARDO ORLANDO', 'ULLOA PEREIRA');
INSERT INTO candidato VALUES (66020092, 'D', 92, 6020, 489, 157, 'FRANCISCA MARIANA ZENTENO ARAOS', 'FRANCISCA MARIANA ZENTENO ARAOS', '', false, 'None', 'FRANCISCA MARIANA', 'ZENTENO ARAOS');
INSERT INTO candidato VALUES (66020093, 'D', 93, 6020, 489, 157, 'JULIETTE CRISTINA VILLALOBOS CARES', 'JULIETTE CRISTINA VILLALOBOS CARES', '', false, 'None', 'JULIETTE CRISTINA', 'VILLALOBOS CARES');
INSERT INTO candidato VALUES (66020094, 'D', 94, 6020, 485, 3, 'SERGIO BOBADILLA MUÑOZ', 'SERGIO BOBADILLA MUÑOZ', '', false, 'None', 'SERGIO', 'BOBADILLA MUÑOZ');
INSERT INTO candidato VALUES (66020095, 'D', 95, 6020, 485, 3, 'MARLENE PEREZ CARTES', 'MARLENE PEREZ CARTES', '', true, 'None', 'MARLENE', 'PEREZ CARTES');
INSERT INTO candidato VALUES (66020096, 'D', 96, 6020, 485, 3, 'HENRY CAMPOS COA', 'HENRY CAMPOS COA', '', false, 'None', 'HENRY', 'CAMPOS COA');
INSERT INTO candidato VALUES (66020097, 'D', 97, 6020, 485, 1, 'LUCIANO SILVA MORA', 'LUCIANO SILVA MORA', '', false, 'None', 'LUCIANO', 'SILVA MORA');
INSERT INTO candidato VALUES (66020098, 'D', 98, 6020, 485, 1, 'ROBERT CONTRERAS REYES', 'ROBERT CONTRERAS REYES', '', false, 'None', 'ROBERT', 'CONTRERAS REYES');
INSERT INTO candidato VALUES (66020099, 'D', 99, 6020, 485, 1, 'MIRTHA ENCINA OVALLE', 'MIRTHA ENCINA OVALLE', '', false, 'None', 'MIRTHA', 'ENCINA OVALLE');
INSERT INTO candidato VALUES (66020100, 'D', 100, 6020, 485, 198, 'VICTOR HUGO FIGUEROA REBOLLEDO', 'VICTOR HUGO FIGUEROA REBOLLEDO', '', true, 'None', 'VICTOR HUGO', 'FIGUEROA REBOLLEDO');
INSERT INTO candidato VALUES (66020101, 'D', 101, 6020, 485, 198, 'ANDREA DE LA BARRA MANRIQUEZ', 'ANDREA DE LA BARRA MANRIQUEZ', '', true, 'None', 'ANDREA', 'DE LA BARRA MANRIQUEZ');
INSERT INTO candidato VALUES (66020102, 'D', 102, 6020, 485, 198, 'ANA ARANEDA GOMEZ', 'ANA ARANEDA GOMEZ', '', true, 'None', 'ANA', 'ARANEDA GOMEZ');
INSERT INTO candidato VALUES (66020103, 'D', 103, 6020, 479, 197, 'FRANCESCA MUÑOZ GONZALEZ', 'FRANCESCA MUÑOZ GONZALEZ', '', false, 'None', 'FRANCESCA', 'MUÑOZ GONZALEZ');
INSERT INTO candidato VALUES (66020104, 'D', 104, 6020, 479, 197, 'ROBERTO ARROYO MUÑOZ', 'ROBERTO ARROYO MUÑOZ', '', false, 'None', 'ROBERTO', 'ARROYO MUÑOZ');
INSERT INTO candidato VALUES (66020105, 'D', 105, 6020, 479, 197, 'ANTARIS VARELA COMPAGNON', 'ANTARIS VARELA COMPAGNON', '', false, 'None', 'ANTARIS', 'VARELA COMPAGNON');
INSERT INTO candidato VALUES (66020106, 'D', 106, 6020, 479, 197, 'JESSICA FLORES REYES', 'JESSICA FLORES REYES', '', false, 'None', 'JESSICA', 'FLORES REYES');
INSERT INTO candidato VALUES (66020107, 'D', 107, 6020, 479, 197, 'GABRIEL TORRES HERMOSILLA', 'GABRIEL TORRES HERMOSILLA', '', true, 'None', 'GABRIEL', 'TORRES HERMOSILLA');
INSERT INTO candidato VALUES (66020108, 'D', 108, 6020, 479, 235, 'REINALDO GONZALEZ MARIANGEL', 'REINALDO GONZALEZ MARIANGEL', '', false, 'None', 'REINALDO', 'GONZALEZ MARIANGEL');
INSERT INTO candidato VALUES (66020109, 'D', 109, 6020, 479, 235, 'JIMENA FIGUEROA NEGRON', 'JIMENA FIGUEROA NEGRON', '', false, 'None', 'JIMENA', 'FIGUEROA NEGRON');
INSERT INTO candidato VALUES (66020110, 'D', 110, 6020, 479, 150, 'JAMES ARGO CHAVEZ', 'JAMES ARGO CHAVEZ', '', false, 'None', 'JAMES', 'ARGO CHAVEZ');
INSERT INTO candidato VALUES (66020111, 'D', 111, 6020, 479, 150, 'PAZ CHARPENTIER RAJCEVICH', 'PAZ CHARPENTIER RAJCEVICH', '', false, 'None', 'PAZ', 'CHARPENTIER RAJCEVICH');
INSERT INTO candidato VALUES (66020112, 'D', 112, 6020, 999, 99, 'SAUL GONZALEZ CACERES', 'SAUL GONZALEZ CACERES', '', true, 'None', 'SAUL', 'GONZALEZ CACERES');
INSERT INTO candidato VALUES (66021051, 'D', 51, 6021, 499, 236, 'ALEXIS ZUÑIGA JELVEZ', 'ALEXIS ZUÑIGA JELVEZ', '', false, 'None', 'ALEXIS', 'ZUÑIGA JELVEZ');
INSERT INTO candidato VALUES (66021052, 'D', 52, 6021, 499, 236, 'JOHANNA BARRA ASTUDILLO', 'JOHANNA BARRA ASTUDILLO', '', false, 'None', 'JOHANNA', 'BARRA ASTUDILLO');
INSERT INTO candidato VALUES (66021053, 'D', 53, 6021, 499, 236, 'PEDRO PABLO VALENZUELA CASTRO', 'PEDRO PABLO VALENZUELA CASTRO', '', false, 'None', 'PEDRO PABLO', 'VALENZUELA CASTRO');
INSERT INTO candidato VALUES (66021054, 'D', 54, 6021, 499, 236, 'BARBARA LEPEZ MONSALVEZ', 'BARBARA LEPEZ MONSALVEZ', '', false, 'None', 'BARBARA', 'LEPEZ MONSALVEZ');
INSERT INTO candidato VALUES (66021055, 'D', 55, 6021, 499, 236, 'RICARDO FLORES PAREDES', 'RICARDO FLORES PAREDES', '', false, 'None', 'RICARDO', 'FLORES PAREDES');
INSERT INTO candidato VALUES (66021056, 'D', 56, 6021, 487, 130, 'LUIS ISLAS COFRE', 'LUIS ISLAS COFRE', '', false, 'None', 'LUIS', 'ISLAS COFRE');
INSERT INTO candidato VALUES (66021057, 'D', 57, 6021, 487, 130, 'RODRIGO REINOSO CENDOYA', 'RODRIGO REINOSO CENDOYA', '', false, 'None', 'RODRIGO', 'REINOSO CENDOYA');
INSERT INTO candidato VALUES (66021058, 'D', 58, 6021, 487, 130, 'JOAQUIN SANHUEZA VILLAMAN', 'JOAQUIN SANHUEZA VILLAMAN', '', true, 'None', 'JOAQUIN', 'SANHUEZA VILLAMAN');
INSERT INTO candidato VALUES (66021059, 'D', 59, 6021, 487, 130, 'JORGE RIVAS FIGUEROA', 'JORGE RIVAS FIGUEROA', '', true, 'None', 'JORGE', 'RIVAS FIGUEROA');
INSERT INTO candidato VALUES (66021060, 'D', 60, 6021, 483, 232, 'CLARA SAGARDIA CABEZAS', 'CLARA SAGARDIA CABEZAS', '', false, 'None', 'CLARA', 'SAGARDIA CABEZAS');
INSERT INTO candidato VALUES (66021061, 'D', 61, 6021, 483, 232, 'ADOLFO MILLABUR ÑANCUIL', 'ADOLFO MILLABUR ÑANCUIL', '', true, 'None', 'ADOLFO', 'MILLABUR ÑANCUIL');
INSERT INTO candidato VALUES (66021062, 'D', 62, 6021, 483, 7, 'LORENA PEREZ LARENAS', 'LORENA PEREZ LARENAS', '', false, 'None', 'LORENA', 'PEREZ LARENAS');
INSERT INTO candidato VALUES (66021063, 'D', 63, 6021, 483, 7, 'ANWAR  FARRAN VELOSO', 'ANWAR  FARRAN VELOSO', '', true, 'None', 'ANWAR ', 'FARRAN VELOSO');
INSERT INTO candidato VALUES (66021064, 'D', 64, 6021, 483, 2, 'PATRICIO PINILLA VALENCIA', 'PATRICIO PINILLA VALENCIA', '', false, 'None', 'PATRICIO', 'PINILLA VALENCIA');
INSERT INTO candidato VALUES (66021065, 'D', 65, 6021, 483, 2, 'KAREN MEDINA VASQUEZ', 'KAREN MEDINA VASQUEZ', '', true, 'None', 'KAREN', 'MEDINA VASQUEZ');
INSERT INTO candidato VALUES (66021066, 'D', 66, 6021, 481, 201, 'CARLA BELEN BURGOS ESCOBAR', 'CARLA BELEN BURGOS ESCOBAR', '', false, 'None', 'CARLA BELEN', 'BURGOS ESCOBAR');
INSERT INTO candidato VALUES (66021067, 'D', 67, 6021, 489, 157, 'LILIAN ALEJANDRA BETANCURT DELGADO', 'LILIAN ALEJANDRA BETANCURT DELGADO', '', false, 'None', 'LILIAN ALEJANDRA', 'BETANCURT DELGADO');
INSERT INTO candidato VALUES (66021068, 'D', 68, 6021, 489, 157, 'CARLOS ALBERTO PEÑA OPAZO', 'CARLOS ALBERTO PEÑA OPAZO', '', false, 'None', 'CARLOS ALBERTO', 'PEÑA OPAZO');
INSERT INTO candidato VALUES (66021069, 'D', 69, 6021, 489, 157, 'KAREN MARCELA MORALES ROZAS', 'KAREN MARCELA MORALES ROZAS', '', false, 'None', 'KAREN MARCELA', 'MORALES ROZAS');
INSERT INTO candidato VALUES (66021070, 'D', 70, 6021, 489, 157, 'CARLOS FELIPE AGURTO PEDREROS', 'CARLOS FELIPE AGURTO PEDREROS', '', false, 'None', 'CARLOS FELIPE', 'AGURTO PEDREROS');
INSERT INTO candidato VALUES (66021071, 'D', 71, 6021, 489, 157, 'CHRISTIAN RODRIGO FUENTES CABEZAS', 'CHRISTIAN RODRIGO FUENTES CABEZAS', '', false, 'None', 'CHRISTIAN RODRIGO', 'FUENTES CABEZAS');
INSERT INTO candidato VALUES (66021072, 'D', 72, 6021, 489, 157, 'SANDRA AMERICA NEIRA ESPINOZA', 'SANDRA AMERICA NEIRA ESPINOZA', '', false, 'None', 'SANDRA AMERICA', 'NEIRA ESPINOZA');
INSERT INTO candidato VALUES (66021073, 'D', 73, 6021, 485, 198, 'JOANNA PEREZ OLEA', 'JOANNA PEREZ OLEA', '', false, 'None', 'JOANNA', 'PEREZ OLEA');
INSERT INTO candidato VALUES (66021074, 'D', 74, 6021, 485, 198, 'ELIZABETH MARICAN RIVAS', 'ELIZABETH MARICAN RIVAS', '', true, 'None', 'ELIZABETH', 'MARICAN RIVAS');
INSERT INTO candidato VALUES (66021075, 'D', 75, 6021, 485, 37, 'BARBARA KAST SOMMERHOFF', 'BARBARA KAST SOMMERHOFF', '', false, 'None', 'BARBARA', 'KAST SOMMERHOFF');
INSERT INTO candidato VALUES (66021076, 'D', 76, 6021, 485, 37, 'JORGE CONTRERAS BLUMEL', 'JORGE CONTRERAS BLUMEL', '', true, 'None', 'JORGE', 'CONTRERAS BLUMEL');
INSERT INTO candidato VALUES (66021077, 'D', 77, 6021, 485, 3, 'MARIO GIERKE QUEVEDO', 'MARIO GIERKE QUEVEDO', '', true, 'None', 'MARIO', 'GIERKE QUEVEDO');
INSERT INTO candidato VALUES (66021078, 'D', 78, 6021, 485, 3, 'FLOR WEISSE NOVOA', 'FLOR WEISSE NOVOA', '', false, 'None', 'FLOR', 'WEISSE NOVOA');
INSERT INTO candidato VALUES (66021079, 'D', 79, 6021, 479, 235, 'CRISTOBAL URRUTICOECHEA RIOS', 'CRISTOBAL URRUTICOECHEA RIOS', '', false, 'None', 'CRISTOBAL', 'URRUTICOECHEA RIOS');
INSERT INTO candidato VALUES (66021080, 'D', 80, 6021, 479, 235, 'EVELYN CAAMAÑO GONZALEZ', 'EVELYN CAAMAÑO GONZALEZ', '', false, 'None', 'EVELYN', 'CAAMAÑO GONZALEZ');
INSERT INTO candidato VALUES (66021081, 'D', 81, 6021, 479, 150, 'FERNANDO PEÑA RIVERA', 'FERNANDO PEÑA RIVERA', '', false, 'None', 'FERNANDO', 'PEÑA RIVERA');
INSERT INTO candidato VALUES (66021082, 'D', 82, 6021, 479, 150, 'SOLANGE ETCHEPARE LACOSTE', 'SOLANGE ETCHEPARE LACOSTE', '', true, 'None', 'SOLANGE', 'ETCHEPARE LACOSTE');
INSERT INTO candidato VALUES (66021083, 'D', 83, 6021, 479, 197, 'IVANIA PAOLA ROJAS CASTILLO', 'IVANIA PAOLA ROJAS CASTILLO', '', false, 'None', 'IVANIA PAOLA', 'ROJAS CASTILLO');
INSERT INTO candidato VALUES (66021084, 'D', 84, 6021, 479, 197, 'PATRICIO BADILLA COFRE', 'PATRICIO BADILLA COFRE', '', false, 'None', 'PATRICIO', 'BADILLA COFRE');
INSERT INTO candidato VALUES (66022051, 'D', 51, 6022, 499, 236, 'VALENTINA SAEZ CASANOVA', 'VALENTINA SAEZ CASANOVA', '', false, 'None', 'VALENTINA', 'SAEZ CASANOVA');
INSERT INTO candidato VALUES (66022052, 'D', 52, 6022, 499, 236, 'RAUL HUILCAL BARRIA', 'RAUL HUILCAL BARRIA', '', false, 'None', 'RAUL', 'HUILCAL BARRIA');
INSERT INTO candidato VALUES (66022053, 'D', 53, 6022, 499, 236, 'WANGLEN MILA HUENUMILLA', 'WANGLEN MILA HUENUMILLA', '', false, 'None', 'WANGLEN', 'MILA HUENUMILLA');
INSERT INTO candidato VALUES (66022054, 'D', 54, 6022, 499, 236, 'EDUARDO CUELLAR FERREIRA', 'EDUARDO CUELLAR FERREIRA', '', false, 'None', 'EDUARDO', 'CUELLAR FERREIRA');
INSERT INTO candidato VALUES (66022055, 'D', 55, 6022, 487, 130, 'EMILIA COÑUMIL QUIÑIMIL', 'EMILIA COÑUMIL QUIÑIMIL', '', false, 'None', 'EMILIA', 'COÑUMIL QUIÑIMIL');
INSERT INTO candidato VALUES (66022056, 'D', 56, 6022, 487, 130, 'LAUTARO GUANCA VALLEJOS', 'LAUTARO GUANCA VALLEJOS', '', true, 'None', 'LAUTARO', 'GUANCA VALLEJOS');
INSERT INTO candidato VALUES (66022057, 'D', 57, 6022, 487, 130, 'JUAN PABLO JARAMILLO GONZALEZ', 'JUAN PABLO JARAMILLO GONZALEZ', '', true, 'None', 'JUAN PABLO', 'JARAMILLO GONZALEZ');
INSERT INTO candidato VALUES (66022058, 'D', 58, 6022, 483, 4, 'ANDREA PARRA SAUTEREL', 'ANDREA PARRA SAUTEREL', '', false, 'None', 'ANDREA', 'PARRA SAUTEREL');
INSERT INTO candidato VALUES (66022059, 'D', 59, 6022, 483, 4, 'PATRICIO POZA BARRERA', 'PATRICIO POZA BARRERA', '', false, 'None', 'PATRICIO', 'POZA BARRERA');
INSERT INTO candidato VALUES (66022060, 'D', 60, 6022, 483, 232, 'LUIS PENCHULEO MORALES', 'LUIS PENCHULEO MORALES', '', false, 'None', 'LUIS', 'PENCHULEO MORALES');
INSERT INTO candidato VALUES (66022061, 'D', 61, 6022, 483, 232, 'MANUELA ROYO LETELIER', 'MANUELA ROYO LETELIER', '', true, 'None', 'MANUELA', 'ROYO LETELIER');
INSERT INTO candidato VALUES (66022062, 'D', 62, 6022, 483, 2, 'XIMENA SEPULVEDA VARAS', 'XIMENA SEPULVEDA VARAS', '', true, 'None', 'XIMENA', 'SEPULVEDA VARAS');
INSERT INTO candidato VALUES (66022063, 'D', 63, 6022, 491, 191, 'MARCELA ROA SUAZO', 'MARCELA ROA SUAZO', '', false, 'None', 'MARCELA', 'ROA SUAZO');
INSERT INTO candidato VALUES (66022064, 'D', 64, 6022, 491, 191, 'JAVIERA FRANCISCA VICTORIA IBARRA LARENAS', 'JAVIERA FRANCISCA VICTORIA IBARRA LARENAS', '', false, 'None', 'JAVIERA FRANCISCA VICTORIA', 'IBARRA LARENAS');
INSERT INTO candidato VALUES (66022065, 'D', 65, 6022, 491, 191, 'LLERY YANIRA CARRASCO ESPINOZA', 'LLERY YANIRA CARRASCO ESPINOZA', '', false, 'None', 'LLERY YANIRA', 'CARRASCO ESPINOZA');
INSERT INTO candidato VALUES (66022066, 'D', 66, 6022, 491, 191, 'EDITH ELENA PALMA MENDEZ', 'EDITH ELENA PALMA MENDEZ', '', false, 'None', 'EDITH ELENA', 'PALMA MENDEZ');
INSERT INTO candidato VALUES (66022067, 'D', 67, 6022, 489, 157, 'DANIELA NATALY GONZALEZ FARIÑA', 'DANIELA NATALY GONZALEZ FARIÑA', '', false, 'None', 'DANIELA NATALY', 'GONZALEZ FARIÑA');
INSERT INTO candidato VALUES (66022068, 'D', 68, 6022, 489, 157, 'GUIDO ANTONIO DIAZ VERGARA', 'GUIDO ANTONIO DIAZ VERGARA', '', false, 'None', 'GUIDO ANTONIO', 'DIAZ VERGARA');
INSERT INTO candidato VALUES (66022069, 'D', 69, 6022, 489, 157, 'ALEXIS OJEDA ALTAMIRANO', 'ALEXIS OJEDA ALTAMIRANO', '', false, 'None', 'ALEXIS', 'OJEDA ALTAMIRANO');
INSERT INTO candidato VALUES (66022070, 'D', 70, 6022, 489, 157, 'PATRICIA DEL CARMEN MUÑOZ BELTRAN', 'PATRICIA DEL CARMEN MUÑOZ BELTRAN', '', false, 'None', 'PATRICIA DEL CARMEN', 'MUÑOZ BELTRAN');
INSERT INTO candidato VALUES (66022071, 'D', 71, 6022, 489, 157, 'RAMIRO ADRIAN RODRIGUEZ MAUREIRA', 'RAMIRO ADRIAN RODRIGUEZ MAUREIRA', '', false, 'None', 'RAMIRO ADRIAN', 'RODRIGUEZ MAUREIRA');
INSERT INTO candidato VALUES (66022072, 'D', 72, 6022, 485, 1, 'JUAN CARLOS BELTRAN SILVA', 'JUAN CARLOS BELTRAN SILVA', '', false, 'None', 'JUAN CARLOS', 'BELTRAN SILVA');
INSERT INTO candidato VALUES (66022073, 'D', 73, 6022, 485, 3, 'EDUARDO CRETTON REBOLLEDO', 'EDUARDO CRETTON REBOLLEDO', '', false, 'None', 'EDUARDO', 'CRETTON REBOLLEDO');
INSERT INTO candidato VALUES (66022074, 'D', 74, 6022, 485, 37, 'VICTOR MANOLI NAZAL', 'VICTOR MANOLI NAZAL', '', true, 'None', 'VICTOR', 'MANOLI NAZAL');
INSERT INTO candidato VALUES (66022075, 'D', 75, 6022, 485, 198, 'JORGE SAFFIRIO ESPINOZA', 'JORGE SAFFIRIO ESPINOZA', '', true, 'None', 'JORGE', 'SAFFIRIO ESPINOZA');
INSERT INTO candidato VALUES (66022076, 'D', 76, 6022, 479, 235, 'GLORIA NAVEILLAN ARRIAGADA', 'GLORIA NAVEILLAN ARRIAGADA', '', false, 'None', 'GLORIA', 'NAVEILLAN ARRIAGADA');
INSERT INTO candidato VALUES (66022077, 'D', 77, 6022, 479, 235, 'VICTOR BADILLA URRA', 'VICTOR BADILLA URRA', '', false, 'None', 'VICTOR', 'BADILLA URRA');
INSERT INTO candidato VALUES (66022078, 'D', 78, 6022, 479, 197, 'ROBERTO QUINTANA BURGOS', 'ROBERTO QUINTANA BURGOS', '', false, 'None', 'ROBERTO', 'QUINTANA BURGOS');
INSERT INTO candidato VALUES (66022079, 'D', 79, 6022, 479, 150, 'FELIPE MARTINEZ REYES', 'FELIPE MARTINEZ REYES', '', false, 'None', 'FELIPE', 'MARTINEZ REYES');
INSERT INTO candidato VALUES (66022080, 'D', 80, 6022, 479, 150, 'DEBORAH NEGRETE PLAZA', 'DEBORAH NEGRETE PLAZA', '', true, 'None', 'DEBORAH', 'NEGRETE PLAZA');
INSERT INTO candidato VALUES (66023051, 'D', 51, 6023, 499, 236, 'JESSICA MENDEZ CANAVES', 'JESSICA MENDEZ CANAVES', '', false, 'None', 'JESSICA', 'MENDEZ CANAVES');
INSERT INTO candidato VALUES (66023052, 'D', 52, 6023, 499, 236, 'IVAN GORKY ROJAS VILLAGRA', 'IVAN GORKY ROJAS VILLAGRA', '', false, 'None', 'IVAN GORKY', 'ROJAS VILLAGRA');
INSERT INTO candidato VALUES (66023053, 'D', 53, 6023, 499, 236, 'CONSTANZA GONZALEZ GONZALEZ', 'CONSTANZA GONZALEZ GONZALEZ', '', false, 'None', 'CONSTANZA', 'GONZALEZ GONZALEZ');
INSERT INTO candidato VALUES (66023054, 'D', 54, 6023, 499, 236, 'VICTOR VILCHES VARGAS', 'VICTOR VILCHES VARGAS', '', false, 'None', 'VICTOR', 'VILCHES VARGAS');
INSERT INTO candidato VALUES (66023055, 'D', 55, 6023, 499, 236, 'DORIS BLANCO LLANQUILEO', 'DORIS BLANCO LLANQUILEO', '', false, 'None', 'DORIS', 'BLANCO LLANQUILEO');
INSERT INTO candidato VALUES (66023056, 'D', 56, 6023, 499, 236, 'LEONEL MERIÑO BAHAMONDE', 'LEONEL MERIÑO BAHAMONDE', '', false, 'None', 'LEONEL', 'MERIÑO BAHAMONDE');
INSERT INTO candidato VALUES (66023057, 'D', 57, 6023, 499, 236, 'TAMARA MORALES SILVA', 'TAMARA MORALES SILVA', '', false, 'None', 'TAMARA', 'MORALES SILVA');
INSERT INTO candidato VALUES (66023058, 'D', 58, 6023, 487, 130, 'DANIEL SANDOVAL POBLETE', 'DANIEL SANDOVAL POBLETE', '', false, 'None', 'DANIEL', 'SANDOVAL POBLETE');
INSERT INTO candidato VALUES (66023059, 'D', 59, 6023, 487, 130, 'MARCELO CARRASCO CARRASCO', 'MARCELO CARRASCO CARRASCO', '', true, 'None', 'MARCELO', 'CARRASCO CARRASCO');
INSERT INTO candidato VALUES (66023060, 'D', 60, 6023, 487, 130, 'PAMELA ÑANCUPIL MARTIN', 'PAMELA ÑANCUPIL MARTIN', '', true, 'None', 'PAMELA', 'ÑANCUPIL MARTIN');
INSERT INTO candidato VALUES (66023061, 'D', 61, 6023, 487, 130, 'DANIEL HIDALGO VELOSO', 'DANIEL HIDALGO VELOSO', '', false, 'None', 'DANIEL', 'HIDALGO VELOSO');
INSERT INTO candidato VALUES (66023062, 'D', 62, 6023, 487, 130, 'OSCAR ALBORNOZ TORRES', 'OSCAR ALBORNOZ TORRES', '', true, 'None', 'OSCAR', 'ALBORNOZ TORRES');
INSERT INTO candidato VALUES (66023063, 'D', 63, 6023, 487, 130, 'ANA NICUL SABARIA', 'ANA NICUL SABARIA', '', true, 'None', 'ANA', 'NICUL SABARIA');
INSERT INTO candidato VALUES (66023064, 'D', 64, 6023, 487, 130, 'HECTOR CUMILAF HUENTEMIL', 'HECTOR CUMILAF HUENTEMIL', '', true, 'None', 'HECTOR', 'CUMILAF HUENTEMIL');
INSERT INTO candidato VALUES (66023065, 'D', 65, 6023, 487, 130, 'PATRICIA ESCOBAR APABLAZA', 'PATRICIA ESCOBAR APABLAZA', '', true, 'None', 'PATRICIA', 'ESCOBAR APABLAZA');
INSERT INTO candidato VALUES (66023066, 'D', 66, 6023, 483, 4, 'JAIME QUINTANA LEAL', 'JAIME QUINTANA LEAL', '', false, 'None', 'JAIME', 'QUINTANA LEAL');
INSERT INTO candidato VALUES (66023067, 'D', 67, 6023, 483, 4, 'JOSE MONTALVA FEUERHAKE', 'JOSE MONTALVA FEUERHAKE', '', true, 'None', 'JOSE', 'MONTALVA FEUERHAKE');
INSERT INTO candidato VALUES (66023068, 'D', 68, 6023, 483, 232, 'COCA ÑANCO VASQUEZ', 'COCA ÑANCO VASQUEZ', '', false, 'None', 'COCA', 'ÑANCO VASQUEZ');
INSERT INTO candidato VALUES (66023069, 'D', 69, 6023, 483, 232, 'CHRISTIAN DULANSKY ARAYA', 'CHRISTIAN DULANSKY ARAYA', '', false, 'None', 'CHRISTIAN', 'DULANSKY ARAYA');
INSERT INTO candidato VALUES (66023070, 'D', 70, 6023, 483, 2, 'PABLO DIAZ SALAZAR', 'PABLO DIAZ SALAZAR', '', false, 'None', 'PABLO', 'DIAZ SALAZAR');
INSERT INTO candidato VALUES (66023071, 'D', 71, 6023, 483, 2, 'CARLOS ALEXIS VALLEJOS VALLEJOS', 'CARLOS ALEXIS VALLEJOS VALLEJOS', '', false, 'None', 'CARLOS ALEXIS', 'VALLEJOS VALLEJOS');
INSERT INTO candidato VALUES (66023072, 'D', 72, 6023, 483, 5, 'CLAUDIA  TAPIA DE LA PEÑA', 'CLAUDIA  TAPIA DE LA PEÑA', '', false, 'None', 'CLAUDIA ', 'TAPIA DE LA PEÑA');
INSERT INTO candidato VALUES (66023073, 'D', 73, 6023, 483, 5, 'RAUL ALLARD SOTO', 'RAUL ALLARD SOTO', '', false, 'None', 'RAUL', 'ALLARD SOTO');
INSERT INTO candidato VALUES (66023074, 'D', 74, 6023, 491, 191, 'ANDRES ALFONSO JOUANNET VALDERRAMA', 'ANDRES ALFONSO JOUANNET VALDERRAMA', '', false, 'None', 'ANDRES ALFONSO', 'JOUANNET VALDERRAMA');
INSERT INTO candidato VALUES (66023075, 'D', 75, 6023, 491, 191, 'FRANCISCA SYLVIA HUIRILEF BARRA', 'FRANCISCA SYLVIA HUIRILEF BARRA', '', false, 'None', 'FRANCISCA SYLVIA', 'HUIRILEF BARRA');
INSERT INTO candidato VALUES (66023076, 'D', 76, 6023, 491, 191, 'JORGE DENNIS JARAMILLO HOTT', 'JORGE DENNIS JARAMILLO HOTT', '', false, 'None', 'JORGE DENNIS', 'JARAMILLO HOTT');
INSERT INTO candidato VALUES (66023077, 'D', 77, 6023, 491, 191, 'ISADORA ALEJANDRA REYNOLDS CAVALLIERI', 'ISADORA ALEJANDRA REYNOLDS CAVALLIERI', '', false, 'None', 'ISADORA ALEJANDRA', 'REYNOLDS CAVALLIERI');
INSERT INTO candidato VALUES (66023078, 'D', 78, 6023, 491, 191, 'MIGUEL ANGEL CORTES IBARRA', 'MIGUEL ANGEL CORTES IBARRA', '', false, 'None', 'MIGUEL ANGEL', 'CORTES IBARRA');
INSERT INTO candidato VALUES (66023079, 'D', 79, 6023, 491, 191, 'SOLEDAD BURGOS MARTINEZ', 'SOLEDAD BURGOS MARTINEZ', '', false, 'None', 'SOLEDAD', 'BURGOS MARTINEZ');
INSERT INTO candidato VALUES (66023080, 'D', 80, 6023, 491, 191, 'SERGIO HECTOR YAÑEZ REVECO', 'SERGIO HECTOR YAÑEZ REVECO', '', false, 'None', 'SERGIO HECTOR', 'YAÑEZ REVECO');
INSERT INTO candidato VALUES (66023081, 'D', 81, 6023, 491, 191, 'SOLANGE NOEL CARMINE ROJAS', 'SOLANGE NOEL CARMINE ROJAS', '', false, 'None', 'SOLANGE NOEL', 'CARMINE ROJAS');
INSERT INTO candidato VALUES (66023082, 'D', 82, 6023, 489, 157, 'FLOR ROSSANY CONTRERAS VIVALLO', 'FLOR ROSSANY CONTRERAS VIVALLO', '', false, 'None', 'FLOR ROSSANY', 'CONTRERAS VIVALLO');
INSERT INTO candidato VALUES (66023083, 'D', 83, 6023, 489, 157, 'ORLANDO CHRISTIAN MACHEFERT INOSTROZA', 'ORLANDO CHRISTIAN MACHEFERT INOSTROZA', '', false, 'None', 'ORLANDO CHRISTIAN', 'MACHEFERT INOSTROZA');
INSERT INTO candidato VALUES (66023084, 'D', 84, 6023, 489, 157, 'CRISTIAN ALIRO MUÑOZ GARRIDO', 'CRISTIAN ALIRO MUÑOZ GARRIDO', '', false, 'None', 'CRISTIAN ALIRO', 'MUÑOZ GARRIDO');
INSERT INTO candidato VALUES (66023085, 'D', 85, 6023, 489, 157, 'HERNAN GONZALO COÑOMAN LEPIMAN', 'HERNAN GONZALO COÑOMAN LEPIMAN', '', false, 'None', 'HERNAN GONZALO', 'COÑOMAN LEPIMAN');
INSERT INTO candidato VALUES (66023086, 'D', 86, 6023, 489, 157, 'ROBINSON DARIO ILLANES ACUÑA', 'ROBINSON DARIO ILLANES ACUÑA', '', false, 'None', 'ROBINSON DARIO', 'ILLANES ACUÑA');
INSERT INTO candidato VALUES (66023087, 'D', 87, 6023, 489, 157, 'JESSICA LORENA ANTILEF LINCOLAO', 'JESSICA LORENA ANTILEF LINCOLAO', '', false, 'None', 'JESSICA LORENA', 'ANTILEF LINCOLAO');
INSERT INTO candidato VALUES (66023088, 'D', 88, 6023, 489, 157, 'MARIA DELIA YAÑEZ BARRERA', 'MARIA DELIA YAÑEZ BARRERA', '', false, 'None', 'MARIA DELIA', 'YAÑEZ BARRERA');
INSERT INTO candidato VALUES (66023089, 'D', 89, 6023, 489, 157, 'AMERICO ARLIN MUÑOZ BELTRAN', 'AMERICO ARLIN MUÑOZ BELTRAN', '', false, 'None', 'AMERICO ARLIN', 'MUÑOZ BELTRAN');
INSERT INTO candidato VALUES (66023090, 'D', 90, 6023, 485, 37, 'TOMAS KAST SOMMERHOFF', 'TOMAS KAST SOMMERHOFF', '', false, 'None', 'TOMAS', 'KAST SOMMERHOFF');
INSERT INTO candidato VALUES (66023091, 'D', 91, 6023, 485, 37, 'CLAUDIA SALAS MELINAO', 'CLAUDIA SALAS MELINAO', '', true, 'None', 'CLAUDIA', 'SALAS MELINAO');
INSERT INTO candidato VALUES (66023092, 'D', 92, 6023, 485, 198, 'IGNACIA GOMEZ MARTINEZ', 'IGNACIA GOMEZ MARTINEZ', '', true, 'None', 'IGNACIA', 'GOMEZ MARTINEZ');
INSERT INTO candidato VALUES (66023093, 'D', 93, 6023, 485, 198, 'AXEL GONZALEZ MANQUEIN', 'AXEL GONZALEZ MANQUEIN', '', true, 'None', 'AXEL', 'GONZALEZ MANQUEIN');
INSERT INTO candidato VALUES (66023094, 'D', 94, 6023, 485, 3, 'GENOVEVA SEPULVEDA VENEGAS', 'GENOVEVA SEPULVEDA VENEGAS', '', false, 'None', 'GENOVEVA', 'SEPULVEDA VENEGAS');
INSERT INTO candidato VALUES (66023095, 'D', 95, 6023, 485, 3, 'GERMAN VERGARA LAGOS', 'GERMAN VERGARA LAGOS', '', false, 'None', 'GERMAN', 'VERGARA LAGOS');
INSERT INTO candidato VALUES (66023096, 'D', 96, 6023, 485, 1, 'RENE MANUEL GARCIA GARCIA', 'RENE MANUEL GARCIA GARCIA', '', false, 'None', 'RENE MANUEL', 'GARCIA GARCIA');
INSERT INTO candidato VALUES (66023097, 'D', 97, 6023, 485, 1, 'PEDRO DURAN SANHUEZA', 'PEDRO DURAN SANHUEZA', '', false, 'None', 'PEDRO', 'DURAN SANHUEZA');
INSERT INTO candidato VALUES (66023098, 'D', 98, 6023, 479, 150, 'STEPHAN SCHUBERT RUBIO', 'STEPHAN SCHUBERT RUBIO', '', false, 'None', 'STEPHAN', 'SCHUBERT RUBIO');
INSERT INTO candidato VALUES (66023099, 'D', 99, 6023, 479, 150, 'CRISTIAN NEIRA MARTINEZ', 'CRISTIAN NEIRA MARTINEZ', '', false, 'None', 'CRISTIAN', 'NEIRA MARTINEZ');
INSERT INTO candidato VALUES (66023100, 'D', 100, 6023, 479, 235, 'CLAUDIA STAMBUK MARDONES', 'CLAUDIA STAMBUK MARDONES', '', false, 'None', 'CLAUDIA', 'STAMBUK MARDONES');
INSERT INTO candidato VALUES (66023101, 'D', 101, 6023, 479, 235, 'CLAUDIA PICHULMAN CUADRA', 'CLAUDIA PICHULMAN CUADRA', '', false, 'None', 'CLAUDIA', 'PICHULMAN CUADRA');
INSERT INTO candidato VALUES (66023102, 'D', 102, 6023, 479, 235, 'RODOLFO VALENZUELA PARDO', 'RODOLFO VALENZUELA PARDO', '', false, 'None', 'RODOLFO', 'VALENZUELA PARDO');
INSERT INTO candidato VALUES (66023103, 'D', 103, 6023, 479, 197, 'MIGUEL SANZANA VILLABLANCA', 'MIGUEL SANZANA VILLABLANCA', '', false, 'None', 'MIGUEL', 'SANZANA VILLABLANCA');
INSERT INTO candidato VALUES (66023104, 'D', 104, 6023, 479, 197, 'JOSE BRAVO BURGOS', 'JOSE BRAVO BURGOS', '', true, 'None', 'JOSE', 'BRAVO BURGOS');
INSERT INTO candidato VALUES (66023105, 'D', 105, 6023, 479, 197, 'JORGE SEPULVEDA ROSALES', 'JORGE SEPULVEDA ROSALES', '', false, 'None', 'JORGE', 'SEPULVEDA ROSALES');
INSERT INTO candidato VALUES (66024051, 'D', 51, 6024, 487, 130, 'CECILIA BRAVO MORAGA', 'CECILIA BRAVO MORAGA', '', false, 'None', 'CECILIA', 'BRAVO MORAGA');
INSERT INTO candidato VALUES (66024052, 'D', 52, 6024, 487, 130, 'MARIO MONTECINOS AROS', 'MARIO MONTECINOS AROS', '', false, 'None', 'MARIO', 'MONTECINOS AROS');
INSERT INTO candidato VALUES (66024053, 'D', 53, 6024, 487, 130, 'JOVA OPORTO VALENZUELA', 'JOVA OPORTO VALENZUELA', '', false, 'None', 'JOVA', 'OPORTO VALENZUELA');
INSERT INTO candidato VALUES (66024054, 'D', 54, 6024, 487, 130, 'YESSICA GAVILAN ROBLES', 'YESSICA GAVILAN ROBLES', '', true, 'None', 'YESSICA', 'GAVILAN ROBLES');
INSERT INTO candidato VALUES (66024055, 'D', 55, 6024, 487, 130, 'JUAN ARAYA MARDONES', 'JUAN ARAYA MARDONES', '', true, 'None', 'JUAN', 'ARAYA MARDONES');
INSERT INTO candidato VALUES (66024056, 'D', 56, 6024, 483, 5, 'ANA MARIA BRAVO CASTRO', 'ANA MARIA BRAVO CASTRO', '', false, 'None', 'ANA MARIA', 'BRAVO CASTRO');
INSERT INTO candidato VALUES (66024057, 'D', 57, 6024, 483, 5, 'MARCOS ILABACA CERDA', 'MARCOS ILABACA CERDA', '', false, 'None', 'MARCOS', 'ILABACA CERDA');
INSERT INTO candidato VALUES (66024058, 'D', 58, 6024, 483, 232, 'MATIAS FERNANDEZ HARTWIG', 'MATIAS FERNANDEZ HARTWIG', '', false, 'None', 'MATIAS', 'FERNANDEZ HARTWIG');
INSERT INTO candidato VALUES (66024059, 'D', 59, 6024, 483, 2, 'WALDO FLORES VERA', 'WALDO FLORES VERA', '', false, 'None', 'WALDO', 'FLORES VERA');
INSERT INTO candidato VALUES (66024060, 'D', 60, 6024, 483, 4, 'VANESSA HUAIQUIMILLA PINOCHET', 'VANESSA HUAIQUIMILLA PINOCHET', '', false, 'None', 'VANESSA', 'HUAIQUIMILLA PINOCHET');
INSERT INTO candidato VALUES (66024061, 'D', 61, 6024, 483, 7, 'LORENNA SALDIAS YAÑEZ', 'LORENNA SALDIAS YAÑEZ', '', false, 'None', 'LORENNA', 'SALDIAS YAÑEZ');
INSERT INTO candidato VALUES (66024062, 'D', 62, 6024, 489, 157, 'GERARDO LARA MARTINEZ', 'GERARDO LARA MARTINEZ', '', false, 'None', 'GERARDO', 'LARA MARTINEZ');
INSERT INTO candidato VALUES (66024063, 'D', 63, 6024, 489, 157, 'TABINA GABRIELA MANQUE MANQUE', 'TABINA GABRIELA MANQUE MANQUE', '', false, 'None', 'TABINA GABRIELA', 'MANQUE MANQUE');
INSERT INTO candidato VALUES (66024064, 'D', 64, 6024, 489, 157, 'FELIPE EMILIO ARANDA SARAVIA', 'FELIPE EMILIO ARANDA SARAVIA', '', false, 'None', 'FELIPE EMILIO', 'ARANDA SARAVIA');
INSERT INTO candidato VALUES (66024065, 'D', 65, 6024, 489, 157, 'ANDREA BURGOS VICUÑA', 'ANDREA BURGOS VICUÑA', '', false, 'None', 'ANDREA', 'BURGOS VICUÑA');
INSERT INTO candidato VALUES (66024066, 'D', 66, 6024, 489, 157, 'MARCELO MIGUEL FRANCO FRANCO', 'MARCELO MIGUEL FRANCO FRANCO', '', false, 'None', 'MARCELO MIGUEL', 'FRANCO FRANCO');
INSERT INTO candidato VALUES (66024067, 'D', 67, 6024, 485, 3, 'GASTON VON MUHLENBROCK ZAMORA', 'GASTON VON MUHLENBROCK ZAMORA', '', false, 'None', 'GASTON', 'VON MUHLENBROCK ZAMORA');
INSERT INTO candidato VALUES (66024068, 'D', 68, 6024, 485, 3, 'OMAR SABAT GUZMAN', 'OMAR SABAT GUZMAN', '', true, 'None', 'OMAR', 'SABAT GUZMAN');
INSERT INTO candidato VALUES (66024069, 'D', 69, 6024, 485, 3, 'ANN HUNTER GUTIERREZ', 'ANN HUNTER GUTIERREZ', '', true, 'None', 'ANN', 'HUNTER GUTIERREZ');
INSERT INTO candidato VALUES (66024070, 'D', 70, 6024, 485, 1, 'KARINA SILVA FERNANDEZ', 'KARINA SILVA FERNANDEZ', '', false, 'None', 'KARINA', 'SILVA FERNANDEZ');
INSERT INTO candidato VALUES (66024071, 'D', 71, 6024, 485, 1, 'SYLVIA YUNGE WULF', 'SYLVIA YUNGE WULF', '', false, 'None', 'SYLVIA', 'YUNGE WULF');
INSERT INTO candidato VALUES (66024072, 'D', 72, 6024, 485, 1, 'DANIEL VALENZUELA SALAZAR', 'DANIEL VALENZUELA SALAZAR', '', true, 'None', 'DANIEL', 'VALENZUELA SALAZAR');
INSERT INTO candidato VALUES (66024073, 'D', 73, 6024, 479, 197, 'TAMAR MUÑOZ SEPULVEDA', 'TAMAR MUÑOZ SEPULVEDA', '', false, 'None', 'TAMAR', 'MUÑOZ SEPULVEDA');
INSERT INTO candidato VALUES (66024074, 'D', 74, 6024, 479, 235, 'LUIS GAETE ALVAREZ', 'LUIS GAETE ALVAREZ', '', false, 'None', 'LUIS', 'GAETE ALVAREZ');
INSERT INTO candidato VALUES (66024075, 'D', 75, 6024, 479, 150, 'LEANDRO KUNSTMANN COLLADO', 'LEANDRO KUNSTMANN COLLADO', '', false, 'None', 'LEANDRO', 'KUNSTMANN COLLADO');
INSERT INTO candidato VALUES (66024076, 'D', 76, 6024, 479, 150, 'PAULINA HERNANDEZ VALDERRAMA', 'PAULINA HERNANDEZ VALDERRAMA', '', false, 'None', 'PAULINA', 'HERNANDEZ VALDERRAMA');
INSERT INTO candidato VALUES (66024077, 'D', 77, 6024, 999, 99, 'JOSÉ ANTONIO URRUTIA RIESCO', 'JOSÉ ANTONIO URRUTIA RIESCO', '', true, 'None', 'JOSÉ ANTONIO', 'URRUTIA RIESCO');
INSERT INTO candidato VALUES (66025051, 'D', 51, 6025, 487, 130, 'GUSTAVO LOBOS CONTRERAS', 'GUSTAVO LOBOS CONTRERAS', '', false, 'None', 'GUSTAVO', 'LOBOS CONTRERAS');
INSERT INTO candidato VALUES (66025052, 'D', 52, 6025, 487, 130, 'MANUEL RIVERA ALTAMIRANO', 'MANUEL RIVERA ALTAMIRANO', '', true, 'None', 'MANUEL', 'RIVERA ALTAMIRANO');
INSERT INTO candidato VALUES (66025053, 'D', 53, 6025, 487, 130, 'FLORA COLIPAI PAFIAN', 'FLORA COLIPAI PAFIAN', '', false, 'None', 'FLORA', 'COLIPAI PAFIAN');
INSERT INTO candidato VALUES (66025054, 'D', 54, 6025, 487, 130, 'CARLOS LIZANA MARDONES', 'CARLOS LIZANA MARDONES', '', true, 'None', 'CARLOS', 'LIZANA MARDONES');
INSERT INTO candidato VALUES (66025055, 'D', 55, 6025, 487, 130, 'PAMELA MANSILLA LAVADO', 'PAMELA MANSILLA LAVADO', '', true, 'None', 'PAMELA', 'MANSILLA LAVADO');
INSERT INTO candidato VALUES (66025056, 'D', 56, 6025, 483, 2, 'HECTOR BARRIA ANGULO', 'HECTOR BARRIA ANGULO', '', false, 'None', 'HECTOR', 'BARRIA ANGULO');
INSERT INTO candidato VALUES (66025057, 'D', 57, 6025, 483, 232, 'JAIME FIGUEROA LEVIGUAN', 'JAIME FIGUEROA LEVIGUAN', '', false, 'None', 'JAIME', 'FIGUEROA LEVIGUAN');
INSERT INTO candidato VALUES (66025058, 'D', 58, 6025, 483, 137, 'NATALY JAVIERA OYARZO CARDENAS', 'NATALY JAVIERA OYARZO CARDENAS', '', false, 'None', 'NATALY JAVIERA', 'OYARZO CARDENAS');
INSERT INTO candidato VALUES (66025059, 'D', 59, 6025, 483, 4, 'RAMON ESPINOZA SANDOVAL', 'RAMON ESPINOZA SANDOVAL', '', true, 'None', 'RAMON', 'ESPINOZA SANDOVAL');
INSERT INTO candidato VALUES (66025060, 'D', 60, 6025, 483, 5, 'EMILIA  NUYADO ANCAPICHUN', 'EMILIA  NUYADO ANCAPICHUN', '', false, 'None', 'EMILIA ', 'NUYADO ANCAPICHUN');
INSERT INTO candidato VALUES (66025061, 'D', 61, 6025, 489, 157, 'ISIDORO RODOLFO BARQUIN PARDO', 'ISIDORO RODOLFO BARQUIN PARDO', '', false, 'None', 'ISIDORO RODOLFO', 'BARQUIN PARDO');
INSERT INTO candidato VALUES (66025062, 'D', 62, 6025, 489, 157, 'MAURICE GOUDIE DOMINGUEZ', 'MAURICE GOUDIE DOMINGUEZ', '', false, 'None', 'MAURICE', 'GOUDIE DOMINGUEZ');
INSERT INTO candidato VALUES (66025063, 'D', 63, 6025, 489, 157, 'ANGELICA ELIANA MANRIQUEZ SANTIBAÑEZ', 'ANGELICA ELIANA MANRIQUEZ SANTIBAÑEZ', '', false, 'None', 'ANGELICA ELIANA', 'MANRIQUEZ SANTIBAÑEZ');
INSERT INTO candidato VALUES (66025064, 'D', 64, 6025, 489, 157, 'ERWIN DAVID PEREZ MONJE', 'ERWIN DAVID PEREZ MONJE', '', false, 'None', 'ERWIN DAVID', 'PEREZ MONJE');
INSERT INTO candidato VALUES (66025065, 'D', 65, 6025, 489, 157, 'SAMUEL DARIO CARDENAS VIVAR', 'SAMUEL DARIO CARDENAS VIVAR', '', false, 'None', 'SAMUEL DARIO', 'CARDENAS VIVAR');
INSERT INTO candidato VALUES (66025066, 'D', 66, 6025, 485, 3, 'DANIEL LILAYU VIVANCO', 'DANIEL LILAYU VIVANCO', '', false, 'None', 'DANIEL', 'LILAYU VIVANCO');
INSERT INTO candidato VALUES (66025067, 'D', 67, 6025, 485, 3, 'RAMON BAHAMONDE CEA', 'RAMON BAHAMONDE CEA', '', true, 'None', 'RAMON', 'BAHAMONDE CEA');
INSERT INTO candidato VALUES (66025068, 'D', 68, 6025, 485, 1, 'LORENA LEICHTLE BERTIN', 'LORENA LEICHTLE BERTIN', '', false, 'None', 'LORENA', 'LEICHTLE BERTIN');
INSERT INTO candidato VALUES (66025069, 'D', 69, 6025, 485, 1, 'MATIAS DOMEYKO PRIETO', 'MATIAS DOMEYKO PRIETO', '', true, 'None', 'MATIAS', 'DOMEYKO PRIETO');
INSERT INTO candidato VALUES (66025070, 'D', 70, 6025, 485, 37, 'JUANCLAUDIO GARCIA FILUN', 'JUANCLAUDIO GARCIA FILUN', '', false, 'None', 'JUANCLAUDIO', 'GARCIA FILUN');
INSERT INTO candidato VALUES (66025071, 'D', 71, 6025, 479, 235, 'SEBASTIAN CRISTI ALFONSO', 'SEBASTIAN CRISTI ALFONSO', '', false, 'None', 'SEBASTIAN', 'CRISTI ALFONSO');
INSERT INTO candidato VALUES (66025072, 'D', 72, 6025, 479, 235, 'PAULINA MUÑOZ MINTE', 'PAULINA MUÑOZ MINTE', '', false, 'None', 'PAULINA', 'MUÑOZ MINTE');
INSERT INTO candidato VALUES (66025073, 'D', 73, 6025, 479, 150, 'KAREN BERRIOS GUERRA', 'KAREN BERRIOS GUERRA', '', false, 'None', 'KAREN', 'BERRIOS GUERRA');
INSERT INTO candidato VALUES (66025074, 'D', 74, 6025, 479, 150, 'ANDREA ITURRIAGA HEWSTONE', 'ANDREA ITURRIAGA HEWSTONE', '', true, 'None', 'ANDREA', 'ITURRIAGA HEWSTONE');
INSERT INTO candidato VALUES (66026051, 'D', 51, 6026, 487, 130, 'ADRIANA AMPUERO BARRIENTOS', 'ADRIANA AMPUERO BARRIENTOS', '', true, 'None', 'ADRIANA', 'AMPUERO BARRIENTOS');
INSERT INTO candidato VALUES (66026052, 'D', 52, 6026, 487, 130, 'MARISOL ROSAS ALVARADO', 'MARISOL ROSAS ALVARADO', '', false, 'None', 'MARISOL', 'ROSAS ALVARADO');
INSERT INTO candidato VALUES (66026053, 'D', 53, 6026, 487, 130, 'CLAUDIO TURRA GONZALEZ', 'CLAUDIO TURRA GONZALEZ', '', true, 'None', 'CLAUDIO', 'TURRA GONZALEZ');
INSERT INTO candidato VALUES (66026054, 'D', 54, 6026, 487, 130, 'DANIELA QUEZADA SERON', 'DANIELA QUEZADA SERON', '', false, 'None', 'DANIELA', 'QUEZADA SERON');
INSERT INTO candidato VALUES (66026055, 'D', 55, 6026, 487, 130, 'CLAUDIO CID JARA', 'CLAUDIO CID JARA', '', false, 'None', 'CLAUDIO', 'CID JARA');
INSERT INTO candidato VALUES (66026056, 'D', 56, 6026, 487, 130, 'JUAN CARCAMO CARCAMO', 'JUAN CARCAMO CARCAMO', '', true, 'None', 'JUAN', 'CARCAMO CARCAMO');
INSERT INTO candidato VALUES (66026057, 'D', 57, 6026, 483, 4, 'HECTOR ULLOA AGUILERA', 'HECTOR ULLOA AGUILERA', '', true, 'None', 'HECTOR', 'ULLOA AGUILERA');
INSERT INTO candidato VALUES (66026058, 'D', 58, 6026, 483, 232, 'JAIME SAEZ QUIROZ', 'JAIME SAEZ QUIROZ', '', false, 'None', 'JAIME', 'SAEZ QUIROZ');
INSERT INTO candidato VALUES (66026059, 'D', 59, 6026, 483, 5, 'MANUEL BALLESTEROS CURUMILLA', 'MANUEL BALLESTEROS CURUMILLA', '', false, 'None', 'MANUEL', 'BALLESTEROS CURUMILLA');
INSERT INTO candidato VALUES (66026060, 'D', 60, 6026, 483, 6, 'ALEXIS OSSES MOYANO', 'ALEXIS OSSES MOYANO', '', false, 'None', 'ALEXIS', 'OSSES MOYANO');
INSERT INTO candidato VALUES (66026061, 'D', 61, 6026, 483, 2, 'FEVE HUGO LORCA', 'FEVE HUGO LORCA', '', false, 'None', 'FEVE', 'HUGO LORCA');
INSERT INTO candidato VALUES (66026062, 'D', 62, 6026, 483, 137, 'ALEJANDRO JAVIER BERNALES MALDONADO', 'ALEJANDRO JAVIER BERNALES MALDONADO', '', false, 'None', 'ALEJANDRO JAVIER', 'BERNALES MALDONADO');
INSERT INTO candidato VALUES (66026063, 'D', 63, 6026, 489, 157, 'ALEX MANUEL NAHUELQUIN NAHUELQUIN', 'ALEX MANUEL NAHUELQUIN NAHUELQUIN', '', false, 'None', 'ALEX MANUEL', 'NAHUELQUIN NAHUELQUIN');
INSERT INTO candidato VALUES (66026064, 'D', 64, 6026, 489, 157, 'ANDREA QUINTANA DIAZ', 'ANDREA QUINTANA DIAZ', '', false, 'None', 'ANDREA', 'QUINTANA DIAZ');
INSERT INTO candidato VALUES (66026065, 'D', 65, 6026, 489, 157, 'XIMENA URIBE CANOBRA', 'XIMENA URIBE CANOBRA', '', false, 'None', 'XIMENA', 'URIBE CANOBRA');
INSERT INTO candidato VALUES (66026066, 'D', 66, 6026, 489, 157, 'ALEXIS MALDONADO RAMOS', 'ALEXIS MALDONADO RAMOS', '', false, 'None', 'ALEXIS', 'MALDONADO RAMOS');
INSERT INTO candidato VALUES (66026067, 'D', 67, 6026, 489, 157, 'LUIS MARIANO CHODIL SOTO', 'LUIS MARIANO CHODIL SOTO', '', false, 'None', 'LUIS MARIANO', 'CHODIL SOTO');
INSERT INTO candidato VALUES (66026068, 'D', 68, 6026, 485, 1, 'MAURO GONZALEZ VILLARROEL', 'MAURO GONZALEZ VILLARROEL', '', false, 'None', 'MAURO', 'GONZALEZ VILLARROEL');
INSERT INTO candidato VALUES (66026069, 'D', 69, 6026, 485, 1, 'JUAN EDUARDO VERA SANHUEZA', 'JUAN EDUARDO VERA SANHUEZA', '', false, 'None', 'JUAN EDUARDO', 'VERA SANHUEZA');
INSERT INTO candidato VALUES (66026070, 'D', 70, 6026, 485, 37, 'LORETO KEMP OYARZUN', 'LORETO KEMP OYARZUN', '', false, 'None', 'LORETO', 'KEMP OYARZUN');
INSERT INTO candidato VALUES (66026071, 'D', 71, 6026, 485, 37, 'ALEJANDRO CAROCA MARAZZI', 'ALEJANDRO CAROCA MARAZZI', '', true, 'None', 'ALEJANDRO', 'CAROCA MARAZZI');
INSERT INTO candidato VALUES (66026072, 'D', 72, 6026, 485, 3, 'KATERINE MONTEALEGRE NAVARRO', 'KATERINE MONTEALEGRE NAVARRO', '', false, 'None', 'KATERINE', 'MONTEALEGRE NAVARRO');
INSERT INTO candidato VALUES (66026073, 'D', 73, 6026, 485, 3, 'FERNANDO BORQUEZ MONTECINOS', 'FERNANDO BORQUEZ MONTECINOS', '', false, 'None', 'FERNANDO', 'BORQUEZ MONTECINOS');
INSERT INTO candidato VALUES (66026074, 'D', 74, 6026, 479, 150, 'CLAUDIA REYES LARENAS', 'CLAUDIA REYES LARENAS', '', false, 'None', 'CLAUDIA', 'REYES LARENAS');
INSERT INTO candidato VALUES (66026075, 'D', 75, 6026, 479, 150, 'CARLOS SEITZ ASPEE', 'CARLOS SEITZ ASPEE', '', false, 'None', 'CARLOS', 'SEITZ ASPEE');
INSERT INTO candidato VALUES (66026076, 'D', 76, 6026, 479, 235, 'MARIA SOLEDAD LORCA SAU', 'MARIA SOLEDAD LORCA SAU', '', false, 'None', 'MARIA SOLEDAD', 'LORCA SAU');
INSERT INTO candidato VALUES (66026077, 'D', 77, 6026, 479, 235, 'MARCELO CASTILLO ALDUNATE', 'MARCELO CASTILLO ALDUNATE', '', false, 'None', 'MARCELO', 'CASTILLO ALDUNATE');
INSERT INTO candidato VALUES (66026078, 'D', 78, 6026, 479, 197, 'MARCO MELO HERNANDEZ', 'MARCO MELO HERNANDEZ', '', false, 'None', 'MARCO', 'MELO HERNANDEZ');
INSERT INTO candidato VALUES (66026079, 'D', 79, 6026, 479, 197, 'NATACHA RIVAS MORALES', 'NATACHA RIVAS MORALES', '', false, 'None', 'NATACHA', 'RIVAS MORALES');
INSERT INTO candidato VALUES (66027051, 'D', 51, 6027, 487, 130, 'RENE ALINCO BUSTOS', 'RENE ALINCO BUSTOS', '', true, 'None', 'RENE', 'ALINCO BUSTOS');
INSERT INTO candidato VALUES (66027052, 'D', 52, 6027, 487, 130, 'SERGIO GONZALEZ BORQUEZ', 'SERGIO GONZALEZ BORQUEZ', '', true, 'None', 'SERGIO', 'GONZALEZ BORQUEZ');
INSERT INTO candidato VALUES (66027053, 'D', 53, 6027, 487, 130, 'DANIELA OLAVARRIA MOREIRA', 'DANIELA OLAVARRIA MOREIRA', '', true, 'None', 'DANIELA', 'OLAVARRIA MOREIRA');
INSERT INTO candidato VALUES (66027054, 'D', 54, 6027, 487, 130, 'BORIS ROMERO BELLO', 'BORIS ROMERO BELLO', '', true, 'None', 'BORIS', 'ROMERO BELLO');
INSERT INTO candidato VALUES (66027055, 'D', 55, 6027, 483, 5, 'ANDREA MACIAS PALMA', 'ANDREA MACIAS PALMA', '', false, 'None', 'ANDREA', 'MACIAS PALMA');
INSERT INTO candidato VALUES (66027056, 'D', 56, 6027, 483, 232, 'ROMINA CEJAS HIDALGO', 'ROMINA CEJAS HIDALGO', '', false, 'None', 'ROMINA', 'CEJAS HIDALGO');
INSERT INTO candidato VALUES (66027057, 'D', 57, 6027, 483, 7, 'LUPERCIANO MUÑOZ GONZALEZ', 'LUPERCIANO MUÑOZ GONZALEZ', '', true, 'None', 'LUPERCIANO', 'MUÑOZ GONZALEZ');
INSERT INTO candidato VALUES (66027058, 'D', 58, 6027, 483, 2, 'PATRICIO AYLWIN FUENTEALBA', 'PATRICIO AYLWIN FUENTEALBA', '', false, 'None', 'PATRICIO', 'AYLWIN FUENTEALBA');
INSERT INTO candidato VALUES (66027059, 'D', 59, 6027, 489, 157, 'KARIN PAMELA CONTRERAS MURTSCHWA', 'KARIN PAMELA CONTRERAS MURTSCHWA', '', false, 'None', 'KARIN PAMELA', 'CONTRERAS MURTSCHWA');
INSERT INTO candidato VALUES (66027060, 'D', 60, 6027, 485, 1, 'MARCIA RAPHAEL MORA', 'MARCIA RAPHAEL MORA', '', false, 'None', 'MARCIA', 'RAPHAEL MORA');
INSERT INTO candidato VALUES (66027061, 'D', 61, 6027, 485, 3, 'ALEJANDRA VALDEBENITO TORRES', 'ALEJANDRA VALDEBENITO TORRES', '', false, 'None', 'ALEJANDRA', 'VALDEBENITO TORRES');
INSERT INTO candidato VALUES (66027062, 'D', 62, 6027, 485, 198, 'GUILLERMO PEREZ PACHECO', 'GUILLERMO PEREZ PACHECO', '', false, 'None', 'GUILLERMO', 'PEREZ PACHECO');
INSERT INTO candidato VALUES (66027063, 'D', 63, 6027, 485, 37, 'GEOCONDA NAVARRETE ARRATIA', 'GEOCONDA NAVARRETE ARRATIA', '', false, 'None', 'GEOCONDA', 'NAVARRETE ARRATIA');
INSERT INTO candidato VALUES (66027064, 'D', 64, 6027, 479, 235, 'CRISTIAN BORQUEZ ACUÑA', 'CRISTIAN BORQUEZ ACUÑA', '', false, 'None', 'CRISTIAN', 'BORQUEZ ACUÑA');
INSERT INTO candidato VALUES (66027065, 'D', 65, 6027, 479, 197, 'JORGE PEREZ URRA', 'JORGE PEREZ URRA', '', false, 'None', 'JORGE', 'PEREZ URRA');
INSERT INTO candidato VALUES (66027066, 'D', 66, 6027, 479, 150, 'JAIME CEBALLOS VERGARA', 'JAIME CEBALLOS VERGARA', '', false, 'None', 'JAIME', 'CEBALLOS VERGARA');
INSERT INTO candidato VALUES (66028051, 'D', 51, 6028, 487, 130, 'RODRIGO UTZ CONTRERAS', 'RODRIGO UTZ CONTRERAS', '', true, 'None', 'RODRIGO', 'UTZ CONTRERAS');
INSERT INTO candidato VALUES (66028052, 'D', 52, 6028, 487, 130, 'THOMAS LORCA ALMONACID', 'THOMAS LORCA ALMONACID', '', false, 'None', 'THOMAS', 'LORCA ALMONACID');
INSERT INTO candidato VALUES (66028053, 'D', 53, 6028, 483, 232, 'JAVIERA MORALES ALVARADO', 'JAVIERA MORALES ALVARADO', '', false, 'None', 'JAVIERA', 'MORALES ALVARADO');
INSERT INTO candidato VALUES (66028054, 'D', 54, 6028, 483, 7, 'VERONICA AGUILAR MARTINEZ', 'VERONICA AGUILAR MARTINEZ', '', true, 'None', 'VERONICA', 'AGUILAR MARTINEZ');
INSERT INTO candidato VALUES (66028055, 'D', 55, 6028, 483, 6, 'IVANIA SALINAS VILLANUEVA', 'IVANIA SALINAS VILLANUEVA', '', false, 'None', 'IVANIA', 'SALINAS VILLANUEVA');
INSERT INTO candidato VALUES (66028056, 'D', 56, 6028, 483, 5, 'PABLO BUSSENIUS CORNEJO', 'PABLO BUSSENIUS CORNEJO', '', false, 'None', 'PABLO', 'BUSSENIUS CORNEJO');
INSERT INTO candidato VALUES (66028057, 'D', 57, 6028, 489, 157, 'ABEL ALEJANDRO FERNANDEZ TRAIPE', 'ABEL ALEJANDRO FERNANDEZ TRAIPE', '', false, 'None', 'ABEL ALEJANDRO', 'FERNANDEZ TRAIPE');
INSERT INTO candidato VALUES (66028058, 'D', 58, 6028, 489, 157, 'ROBERTO SAHR DOMIAN', 'ROBERTO SAHR DOMIAN', '', false, 'None', 'ROBERTO', 'SAHR DOMIAN');
INSERT INTO candidato VALUES (66028059, 'D', 59, 6028, 485, 37, 'RICARDO HERNANDEZ CREMASCHI', 'RICARDO HERNANDEZ CREMASCHI', '', false, 'None', 'RICARDO', 'HERNANDEZ CREMASCHI');
INSERT INTO candidato VALUES (66028060, 'D', 60, 6028, 485, 1, 'JENNIFFER ROJAS GARCIA', 'JENNIFFER ROJAS GARCIA', '', false, 'None', 'JENNIFFER', 'ROJAS GARCIA');
INSERT INTO candidato VALUES (66028061, 'D', 61, 6028, 485, 3, 'GRACIELA ANDRADE PACHECO', 'GRACIELA ANDRADE PACHECO', '', true, 'None', 'GRACIELA', 'ANDRADE PACHECO');
INSERT INTO candidato VALUES (66028062, 'D', 62, 6028, 485, 3, 'CHRISTIAN MATHESON VILLAN', 'CHRISTIAN MATHESON VILLAN', '', true, 'None', 'CHRISTIAN', 'MATHESON VILLAN');
INSERT INTO candidato VALUES (66028063, 'D', 63, 6028, 479, 150, 'ALEJANDRO RIQUELME DUCCI', 'ALEJANDRO RIQUELME DUCCI', '', false, 'None', 'ALEJANDRO', 'RIQUELME DUCCI');
INSERT INTO candidato VALUES (66028064, 'D', 64, 6028, 479, 150, 'JUAN SRDANOVIC ARCOS', 'JUAN SRDANOVIC ARCOS', '', true, 'None', 'JUAN', 'SRDANOVIC ARCOS');
INSERT INTO candidato VALUES (66028065, 'D', 65, 6028, 479, 197, 'JAVIERA CALVO RIFO', 'JAVIERA CALVO RIFO', '', false, 'None', 'JAVIERA', 'CALVO RIFO');
INSERT INTO candidato VALUES (66028066, 'D', 66, 6028, 479, 235, 'RAMON AGUILAR TOBAR', 'RAMON AGUILAR TOBAR', '', false, 'None', 'RAMON', 'AGUILAR TOBAR');
INSERT INTO candidato VALUES (66028067, 'D', 67, 6028, 999, 99, 'CARLOS ANTONIO KARIM BIANCHI CHELECH', 'CARLOS ANTONIO KARIM BIANCHI CHELECH', '', true, 'None', 'CARLOS ANTONIO KARIM', 'BIANCHI CHELECH');
INSERT INTO candidato VALUES (66028068, 'D', 68, 6028, 999, 99, 'CLAUDIA PAOLA BARRIENTOS SANCHEZ', 'CLAUDIA PAOLA BARRIENTOS SANCHEZ', '', true, 'None', 'CLAUDIA PAOLA', 'BARRIENTOS SANCHEZ');
INSERT INTO candidato VALUES (41900101, 'P', 1, 19001, 999, 157, 'FRANCO PARISI FERNANDEZ', 'FRANCO PARISI FERNANDEZ', '', false, 'None', 'FRANCO', 'PARISI');


--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('candidato_candidato_id_seq', 1, false);


--
-- Name: candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('candidato_id_seq', 4, true);


--
-- Data for Name: comuna; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO comuna VALUES (2825, 3015, 6001, 'GENERAL LAGOS');
INSERT INTO comuna VALUES (2824, 3015, 6001, 'PUTRE');
INSERT INTO comuna VALUES (2823, 3015, 6001, 'CAMARONES');
INSERT INTO comuna VALUES (2822, 3015, 6001, 'ARICA');
INSERT INTO comuna VALUES (2507, 3001, 6002, 'PICA');
INSERT INTO comuna VALUES (2506, 3001, 6002, 'HUARA');
INSERT INTO comuna VALUES (2505, 3001, 6002, 'COLCHANE');
INSERT INTO comuna VALUES (2504, 3001, 6002, 'CAMIÑA');
INSERT INTO comuna VALUES (2503, 3001, 6002, 'POZO ALMONTE');
INSERT INTO comuna VALUES (2502, 3001, 6002, 'ALTO HOSPICIO');
INSERT INTO comuna VALUES (2501, 3001, 6002, 'IQUIQUE');
INSERT INTO comuna VALUES (2516, 3002, 6003, 'MARIA ELENA');
INSERT INTO comuna VALUES (2515, 3002, 6003, 'TOCOPILLA');
INSERT INTO comuna VALUES (2514, 3002, 6003, 'SAN PEDRO DE ATACAMA');
INSERT INTO comuna VALUES (2513, 3002, 6003, 'OLLAGUE');
INSERT INTO comuna VALUES (2512, 3002, 6003, 'CALAMA');
INSERT INTO comuna VALUES (2511, 3002, 6003, 'TALTAL');
INSERT INTO comuna VALUES (2510, 3002, 6003, 'SIERRA GORDA');
INSERT INTO comuna VALUES (2509, 3002, 6003, 'MEJILLONES');
INSERT INTO comuna VALUES (2508, 3002, 6003, 'ANTOFAGASTA');
INSERT INTO comuna VALUES (2525, 3003, 6004, 'HUASCO');
INSERT INTO comuna VALUES (2524, 3003, 6004, 'FREIRINA');
INSERT INTO comuna VALUES (2523, 3003, 6004, 'ALTO DEL CARMEN');
INSERT INTO comuna VALUES (2522, 3003, 6004, 'VALLENAR');
INSERT INTO comuna VALUES (2521, 3003, 6004, 'DIEGO DE ALMAGRO');
INSERT INTO comuna VALUES (2520, 3003, 6004, 'CHAÑARAL');
INSERT INTO comuna VALUES (2519, 3003, 6004, 'TIERRA AMARILLA');
INSERT INTO comuna VALUES (2518, 3003, 6004, 'CALDERA');
INSERT INTO comuna VALUES (2517, 3003, 6004, 'COPIAPO');
INSERT INTO comuna VALUES (2540, 3004, 6005, 'RIO HURTADO');
INSERT INTO comuna VALUES (2539, 3004, 6005, 'PUNITAQUI');
INSERT INTO comuna VALUES (2538, 3004, 6005, 'MONTE PATRIA');
INSERT INTO comuna VALUES (2537, 3004, 6005, 'COMBARBALA');
INSERT INTO comuna VALUES (2536, 3004, 6005, 'OVALLE');
INSERT INTO comuna VALUES (2535, 3004, 6005, 'SALAMANCA');
INSERT INTO comuna VALUES (2534, 3004, 6005, 'LOS VILOS');
INSERT INTO comuna VALUES (2533, 3004, 6005, 'CANELA');
INSERT INTO comuna VALUES (2532, 3004, 6005, 'ILLAPEL');
INSERT INTO comuna VALUES (2531, 3004, 6005, 'VICUÑA');
INSERT INTO comuna VALUES (2530, 3004, 6005, 'PAIHUANO');
INSERT INTO comuna VALUES (2529, 3004, 6005, 'LA HIGUERA');
INSERT INTO comuna VALUES (2528, 3004, 6005, 'ANDACOLLO');
INSERT INTO comuna VALUES (2527, 3004, 6005, 'COQUIMBO');
INSERT INTO comuna VALUES (2526, 3004, 6005, 'LA SERENA');
INSERT INTO comuna VALUES (2578, 3005, 6006, 'VILLA ALEMANA');
INSERT INTO comuna VALUES (2577, 3005, 6006, 'OLMUE');
INSERT INTO comuna VALUES (2576, 3005, 6006, 'LIMACHE');
INSERT INTO comuna VALUES (2575, 3005, 6006, 'QUILPUE');
INSERT INTO comuna VALUES (2574, 3005, 6006, 'SANTA MARIA');
INSERT INTO comuna VALUES (2573, 3005, 6006, 'PUTAENDO');
INSERT INTO comuna VALUES (2572, 3005, 6006, 'PANQUEHUE');
INSERT INTO comuna VALUES (2571, 3005, 6006, 'LLAY-LLAY');
INSERT INTO comuna VALUES (2570, 3005, 6006, 'CATEMU');
INSERT INTO comuna VALUES (2569, 3005, 6006, 'SAN FELIPE');
INSERT INTO comuna VALUES (2568, 3005, 6007, 'SANTO DOMINGO');
INSERT INTO comuna VALUES (2567, 3005, 6007, 'EL TABO');
INSERT INTO comuna VALUES (2566, 3005, 6007, 'EL QUISCO');
INSERT INTO comuna VALUES (2565, 3005, 6007, 'CARTAGENA');
INSERT INTO comuna VALUES (2564, 3005, 6007, 'ALGARROBO');
INSERT INTO comuna VALUES (2563, 3005, 6007, 'SAN ANTONIO');
INSERT INTO comuna VALUES (2562, 3005, 6006, 'NOGALES');
INSERT INTO comuna VALUES (2561, 3005, 6006, 'LA CRUZ');
INSERT INTO comuna VALUES (2560, 3005, 6006, 'HIJUELAS');
INSERT INTO comuna VALUES (2559, 3005, 6006, 'CALERA');
INSERT INTO comuna VALUES (2558, 3005, 6006, 'QUILLOTA');
INSERT INTO comuna VALUES (2557, 3005, 6006, 'ZAPALLAR');
INSERT INTO comuna VALUES (2556, 3005, 6006, 'PETORCA');
INSERT INTO comuna VALUES (2555, 3005, 6006, 'PAPUDO');
INSERT INTO comuna VALUES (2554, 3005, 6006, 'CABILDO');
INSERT INTO comuna VALUES (2553, 3005, 6006, 'LA LIGUA');
INSERT INTO comuna VALUES (2552, 3005, 6006, 'SAN ESTEBAN');
INSERT INTO comuna VALUES (2551, 3005, 6006, 'RINCONADA');
INSERT INTO comuna VALUES (2550, 3005, 6006, 'CALLE LARGA');
INSERT INTO comuna VALUES (2549, 3005, 6006, 'LOS ANDES');
INSERT INTO comuna VALUES (2548, 3005, 6007, 'ISLA DE PASCUA');
INSERT INTO comuna VALUES (2547, 3005, 6007, 'VIÑA DEL MAR');
INSERT INTO comuna VALUES (2546, 3005, 6006, 'QUINTERO');
INSERT INTO comuna VALUES (2545, 3005, 6006, 'PUCHUNCAVI');
INSERT INTO comuna VALUES (2544, 3005, 6007, 'JUAN FERNANDEZ');
INSERT INTO comuna VALUES (2543, 3005, 6007, 'CONCON');
INSERT INTO comuna VALUES (2542, 3005, 6007, 'CASABLANCA');
INSERT INTO comuna VALUES (2541, 3005, 6007, 'VALPARAISO');
INSERT INTO comuna VALUES (2809, 3013, 6014, 'PEÑAFLOR');
INSERT INTO comuna VALUES (2808, 3013, 6014, 'PADRE HURTADO');
INSERT INTO comuna VALUES (2807, 3013, 6014, 'ISLA DE MAIPO');
INSERT INTO comuna VALUES (2806, 3013, 6014, 'EL MONTE');
INSERT INTO comuna VALUES (2805, 3013, 6014, 'TALAGANTE');
INSERT INTO comuna VALUES (2804, 3013, 6014, 'SAN PEDRO');
INSERT INTO comuna VALUES (2803, 3013, 6014, 'MARIA PINTO');
INSERT INTO comuna VALUES (2802, 3013, 6014, 'CURACAVI');
INSERT INTO comuna VALUES (2801, 3013, 6014, 'ALHUE');
INSERT INTO comuna VALUES (2800, 3013, 6014, 'MELIPILLA');
INSERT INTO comuna VALUES (2799, 3013, 6014, 'PAINE');
INSERT INTO comuna VALUES (2798, 3013, 6014, 'CALERA DE TANGO');
INSERT INTO comuna VALUES (2797, 3013, 6014, 'BUIN');
INSERT INTO comuna VALUES (2796, 3013, 6014, 'SAN BERNARDO');
INSERT INTO comuna VALUES (2795, 3013, 6008, 'TILTIL');
INSERT INTO comuna VALUES (2794, 3013, 6008, 'LAMPA');
INSERT INTO comuna VALUES (2793, 3013, 6008, 'COLINA');
INSERT INTO comuna VALUES (2792, 3013, 6012, 'SAN JOSE DE MAIPO');
INSERT INTO comuna VALUES (2791, 3013, 6012, 'PIRQUE');
INSERT INTO comuna VALUES (2790, 3013, 6012, 'PUENTE ALTO');
INSERT INTO comuna VALUES (2789, 3013, 6011, 'VITACURA');
INSERT INTO comuna VALUES (2788, 3013, 6013, 'SAN RAMON');
INSERT INTO comuna VALUES (2787, 3013, 6013, 'SAN MIGUEL');
INSERT INTO comuna VALUES (2786, 3013, 6010, 'SAN JOAQUIN');
INSERT INTO comuna VALUES (2785, 3013, 6009, 'RENCA');
INSERT INTO comuna VALUES (2784, 3013, 6009, 'RECOLETA');
INSERT INTO comuna VALUES (2783, 3013, 6009, 'QUINTA NORMAL');
INSERT INTO comuna VALUES (2782, 3013, 6008, 'QUILICURA');
INSERT INTO comuna VALUES (2781, 3013, 6008, 'PUDAHUEL');
INSERT INTO comuna VALUES (2780, 3013, 6010, 'PROVIDENCIA');
INSERT INTO comuna VALUES (2779, 3013, 6011, 'PEÑALOLEN');
INSERT INTO comuna VALUES (2778, 3013, 6013, 'PEDRO AGUIRRE CERDA');
INSERT INTO comuna VALUES (2777, 3013, 6010, 'ÑUÑOA');
INSERT INTO comuna VALUES (2776, 3013, 6008, 'MAIPU');
INSERT INTO comuna VALUES (2775, 3013, 6010, 'MACUL');
INSERT INTO comuna VALUES (2774, 3013, 6009, 'LO PRADO');
INSERT INTO comuna VALUES (2773, 3013, 6013, 'LO ESPEJO');
INSERT INTO comuna VALUES (2772, 3013, 6011, 'LO BARNECHEA');
INSERT INTO comuna VALUES (2771, 3013, 6011, 'LAS CONDES');
INSERT INTO comuna VALUES (2770, 3013, 6011, 'LA REINA');
INSERT INTO comuna VALUES (2769, 3013, 6012, 'LA PINTANA');
INSERT INTO comuna VALUES (2768, 3013, 6010, 'LA GRANJA');
INSERT INTO comuna VALUES (2767, 3013, 6012, 'LA FLORIDA');
INSERT INTO comuna VALUES (2766, 3013, 6013, 'LA CISTERNA');
INSERT INTO comuna VALUES (2765, 3013, 6009, 'INDEPENDENCIA');
INSERT INTO comuna VALUES (2764, 3013, 6009, 'HUECHURABA');
INSERT INTO comuna VALUES (2763, 3013, 6008, 'ESTACION CENTRAL');
INSERT INTO comuna VALUES (2762, 3013, 6013, 'EL BOSQUE');
INSERT INTO comuna VALUES (2761, 3013, 6009, 'CONCHALI');
INSERT INTO comuna VALUES (2760, 3013, 6009, 'CERRO NAVIA');
INSERT INTO comuna VALUES (2759, 3013, 6008, 'CERRILLOS');
INSERT INTO comuna VALUES (2758, 3013, 6010, 'SANTIAGO');
INSERT INTO comuna VALUES (2611, 3006, 6016, 'SANTA CRUZ');
INSERT INTO comuna VALUES (2610, 3006, 6016, 'PUMANQUE');
INSERT INTO comuna VALUES (2609, 3006, 6016, 'PLACILLA');
INSERT INTO comuna VALUES (2608, 3006, 6016, 'PERALILLO');
INSERT INTO comuna VALUES (2607, 3006, 6016, 'PALMILLA');
INSERT INTO comuna VALUES (2606, 3006, 6016, 'NANCAGUA');
INSERT INTO comuna VALUES (2605, 3006, 6016, 'LOLOL');
INSERT INTO comuna VALUES (2604, 3006, 6016, 'CHIMBARONGO');
INSERT INTO comuna VALUES (2603, 3006, 6016, 'CHEPICA');
INSERT INTO comuna VALUES (2602, 3006, 6016, 'SAN FERNANDO');
INSERT INTO comuna VALUES (2601, 3006, 6016, 'PAREDONES');
INSERT INTO comuna VALUES (2600, 3006, 6016, 'NAVIDAD');
INSERT INTO comuna VALUES (2599, 3006, 6016, 'MARCHIGUE');
INSERT INTO comuna VALUES (2598, 3006, 6016, 'LITUECHE');
INSERT INTO comuna VALUES (2597, 3006, 6016, 'LA ESTRELLA');
INSERT INTO comuna VALUES (2596, 3006, 6016, 'PICHILEMU');
INSERT INTO comuna VALUES (2595, 3006, 6016, 'SAN VICENTE');
INSERT INTO comuna VALUES (2594, 3006, 6015, 'REQUINOA');
INSERT INTO comuna VALUES (2593, 3006, 6015, 'RENGO');
INSERT INTO comuna VALUES (2592, 3006, 6015, 'QUINTA DE TILCOCO');
INSERT INTO comuna VALUES (2591, 3006, 6016, 'PICHIDEGUA');
INSERT INTO comuna VALUES (2590, 3006, 6016, 'PEUMO');
INSERT INTO comuna VALUES (2589, 3006, 6015, 'OLIVAR');
INSERT INTO comuna VALUES (2588, 3006, 6015, 'MOSTAZAL');
INSERT INTO comuna VALUES (2587, 3006, 6015, 'MALLOA');
INSERT INTO comuna VALUES (2586, 3006, 6015, 'MACHALI');
INSERT INTO comuna VALUES (2585, 3006, 6016, 'LAS CABRAS');
INSERT INTO comuna VALUES (2584, 3006, 6015, 'GRANEROS');
INSERT INTO comuna VALUES (2583, 3006, 6015, 'DOÑIHUE');
INSERT INTO comuna VALUES (2582, 3006, 6015, 'COLTAUCO');
INSERT INTO comuna VALUES (2581, 3006, 6015, 'COINCO');
INSERT INTO comuna VALUES (2580, 3006, 6015, 'CODEGUA');
INSERT INTO comuna VALUES (2579, 3006, 6015, 'RANCAGUA');
INSERT INTO comuna VALUES (2641, 3007, 6018, 'YERBAS BUENAS');
INSERT INTO comuna VALUES (2640, 3007, 6018, 'VILLA ALEGRE');
INSERT INTO comuna VALUES (2639, 3007, 6018, 'SAN JAVIER');
INSERT INTO comuna VALUES (2638, 3007, 6018, 'RETIRO');
INSERT INTO comuna VALUES (2637, 3007, 6018, 'PARRAL');
INSERT INTO comuna VALUES (2636, 3007, 6018, 'LONGAVI');
INSERT INTO comuna VALUES (2635, 3007, 6018, 'COLBUN');
INSERT INTO comuna VALUES (2634, 3007, 6018, 'LINARES');
INSERT INTO comuna VALUES (2633, 3007, 6017, 'VICHUQUEN');
INSERT INTO comuna VALUES (2632, 3007, 6017, 'TENO');
INSERT INTO comuna VALUES (2631, 3007, 6017, 'SAGRADA FAMILIA');
INSERT INTO comuna VALUES (2630, 3007, 6017, 'ROMERAL');
INSERT INTO comuna VALUES (2629, 3007, 6017, 'RAUCO');
INSERT INTO comuna VALUES (2628, 3007, 6017, 'MOLINA');
INSERT INTO comuna VALUES (2627, 3007, 6017, 'LICANTEN');
INSERT INTO comuna VALUES (2626, 3007, 6017, 'HUALAÑE');
INSERT INTO comuna VALUES (2625, 3007, 6017, 'CURICO');
INSERT INTO comuna VALUES (2624, 3007, 6018, 'PELLUHUE');
INSERT INTO comuna VALUES (2623, 3007, 6018, 'CHANCO');
INSERT INTO comuna VALUES (2622, 3007, 6018, 'CAUQUENES');
INSERT INTO comuna VALUES (2621, 3007, 6017, 'SAN RAFAEL');
INSERT INTO comuna VALUES (2620, 3007, 6017, 'SAN CLEMENTE');
INSERT INTO comuna VALUES (2619, 3007, 6017, 'RIO CLARO');
INSERT INTO comuna VALUES (2618, 3007, 6017, 'PENCAHUE');
INSERT INTO comuna VALUES (2617, 3007, 6017, 'PELARCO');
INSERT INTO comuna VALUES (2616, 3007, 6017, 'MAULE');
INSERT INTO comuna VALUES (2615, 3007, 6017, 'EMPEDRADO');
INSERT INTO comuna VALUES (2614, 3007, 6017, 'CUREPTO');
INSERT INTO comuna VALUES (2613, 3007, 6017, 'CONSTITUCION');
INSERT INTO comuna VALUES (2612, 3007, 6017, 'TALCA');
INSERT INTO comuna VALUES (2846, 3016, 6019, 'SAN NICOLAS');
INSERT INTO comuna VALUES (2845, 3016, 6019, 'SAN FABIAN');
INSERT INTO comuna VALUES (2844, 3016, 6019, 'ÑIQUEN');
INSERT INTO comuna VALUES (2843, 3016, 6019, 'COIHUECO');
INSERT INTO comuna VALUES (2842, 3016, 6019, 'SAN CARLOS');
INSERT INTO comuna VALUES (2841, 3016, 6019, 'TREHUACO');
INSERT INTO comuna VALUES (2840, 3016, 6019, 'RANQUIL');
INSERT INTO comuna VALUES (2839, 3016, 6019, 'PORTEZUELO');
INSERT INTO comuna VALUES (2838, 3016, 6019, 'NINHUE');
INSERT INTO comuna VALUES (2837, 3016, 6019, 'COELEMU');
INSERT INTO comuna VALUES (2836, 3016, 6019, 'COBQUECURA');
INSERT INTO comuna VALUES (2835, 3016, 6019, 'QUIRIHUE');
INSERT INTO comuna VALUES (2834, 3016, 6019, 'YUNGAY');
INSERT INTO comuna VALUES (2833, 3016, 6019, 'SAN IGNACIO');
INSERT INTO comuna VALUES (2832, 3016, 6019, 'QUILLON');
INSERT INTO comuna VALUES (2831, 3016, 6019, 'PINTO');
INSERT INTO comuna VALUES (2830, 3016, 6019, 'PEMUCO');
INSERT INTO comuna VALUES (2829, 3016, 6019, 'EL CARMEN');
INSERT INTO comuna VALUES (2828, 3016, 6019, 'CHILLAN VIEJO');
INSERT INTO comuna VALUES (2827, 3016, 6019, 'BULNES');
INSERT INTO comuna VALUES (2826, 3016, 6019, 'CHILLAN');
INSERT INTO comuna VALUES (2674, 3008, 6021, 'ALTO BIOBIO');
INSERT INTO comuna VALUES (2673, 3008, 6021, 'YUMBEL');
INSERT INTO comuna VALUES (2672, 3008, 6021, 'TUCAPEL');
INSERT INTO comuna VALUES (2671, 3008, 6021, 'SANTA BARBARA');
INSERT INTO comuna VALUES (2670, 3008, 6021, 'SAN ROSENDO');
INSERT INTO comuna VALUES (2669, 3008, 6021, 'QUILLECO');
INSERT INTO comuna VALUES (2668, 3008, 6021, 'QUILACO');
INSERT INTO comuna VALUES (2667, 3008, 6021, 'NEGRETE');
INSERT INTO comuna VALUES (2666, 3008, 6021, 'NACIMIENTO');
INSERT INTO comuna VALUES (2665, 3008, 6021, 'MULCHEN');
INSERT INTO comuna VALUES (2664, 3008, 6021, 'LAJA');
INSERT INTO comuna VALUES (2663, 3008, 6021, 'CABRERO');
INSERT INTO comuna VALUES (2662, 3008, 6021, 'ANTUCO');
INSERT INTO comuna VALUES (2661, 3008, 6021, 'LOS ANGELES');
INSERT INTO comuna VALUES (2660, 3008, 6021, 'TIRUA');
INSERT INTO comuna VALUES (2659, 3008, 6021, 'LOS ALAMOS');
INSERT INTO comuna VALUES (2658, 3008, 6021, 'CURANILAHUE');
INSERT INTO comuna VALUES (2657, 3008, 6021, 'CONTULMO');
INSERT INTO comuna VALUES (2656, 3008, 6021, 'CAÑETE');
INSERT INTO comuna VALUES (2655, 3008, 6021, 'ARAUCO');
INSERT INTO comuna VALUES (2654, 3008, 6021, 'LEBU');
INSERT INTO comuna VALUES (2653, 3008, 6020, 'HUALPEN');
INSERT INTO comuna VALUES (2652, 3008, 6020, 'TOME');
INSERT INTO comuna VALUES (2651, 3008, 6020, 'TALCAHUANO');
INSERT INTO comuna VALUES (2650, 3008, 6020, 'SANTA JUANA');
INSERT INTO comuna VALUES (2649, 3008, 6020, 'SAN PEDRO DE LA PAZ');
INSERT INTO comuna VALUES (2648, 3008, 6020, 'PENCO');
INSERT INTO comuna VALUES (2647, 3008, 6021, 'LOTA');
INSERT INTO comuna VALUES (2646, 3008, 6020, 'HUALQUI');
INSERT INTO comuna VALUES (2645, 3008, 6020, 'FLORIDA');
INSERT INTO comuna VALUES (2644, 3008, 6020, 'CHIGUAYANTE');
INSERT INTO comuna VALUES (2643, 3008, 6020, 'CORONEL');
INSERT INTO comuna VALUES (2642, 3008, 6020, 'CONCEPCION');
INSERT INTO comuna VALUES (2706, 3009, 6022, 'VICTORIA');
INSERT INTO comuna VALUES (2705, 3009, 6022, 'TRAIGUEN');
INSERT INTO comuna VALUES (2704, 3009, 6022, 'RENAICO');
INSERT INTO comuna VALUES (2703, 3009, 6022, 'PUREN');
INSERT INTO comuna VALUES (2702, 3009, 6022, 'LUMACO');
INSERT INTO comuna VALUES (2701, 3009, 6022, 'LOS SAUCES');
INSERT INTO comuna VALUES (2700, 3009, 6022, 'LONQUIMAY');
INSERT INTO comuna VALUES (2699, 3009, 6022, 'ERCILLA');
INSERT INTO comuna VALUES (2698, 3009, 6022, 'CURACAUTIN');
INSERT INTO comuna VALUES (2697, 3009, 6022, 'COLLIPULLI');
INSERT INTO comuna VALUES (2696, 3009, 6022, 'ANGOL');
INSERT INTO comuna VALUES (2695, 3009, 6023, 'CHOLCHOL');
INSERT INTO comuna VALUES (2694, 3009, 6023, 'VILLARRICA');
INSERT INTO comuna VALUES (2693, 3009, 6022, 'VILCUN');
INSERT INTO comuna VALUES (2692, 3009, 6023, 'TOLTEN');
INSERT INTO comuna VALUES (2691, 3009, 6023, 'TEODORO SCHMIDT');
INSERT INTO comuna VALUES (2690, 3009, 6023, 'SAAVEDRA');
INSERT INTO comuna VALUES (2689, 3009, 6023, 'PUCON');
INSERT INTO comuna VALUES (2688, 3009, 6023, 'PITRUFQUEN');
INSERT INTO comuna VALUES (2687, 3009, 6022, 'PERQUENCO');
INSERT INTO comuna VALUES (2686, 3009, 6023, 'PADRE LAS CASAS');
INSERT INTO comuna VALUES (2685, 3009, 6023, 'NUEVA IMPERIAL');
INSERT INTO comuna VALUES (2684, 3009, 6022, 'MELIPEUCO');
INSERT INTO comuna VALUES (2683, 3009, 6023, 'LONCOCHE');
INSERT INTO comuna VALUES (2682, 3009, 6022, 'LAUTARO');
INSERT INTO comuna VALUES (2681, 3009, 6023, 'GORBEA');
INSERT INTO comuna VALUES (2680, 3009, 6022, 'GALVARINO');
INSERT INTO comuna VALUES (2679, 3009, 6023, 'FREIRE');
INSERT INTO comuna VALUES (2678, 3009, 6023, 'CURARREHUE');
INSERT INTO comuna VALUES (2677, 3009, 6023, 'CUNCO');
INSERT INTO comuna VALUES (2676, 3009, 6023, 'CARAHUE');
INSERT INTO comuna VALUES (2675, 3009, 6023, 'TEMUCO');
INSERT INTO comuna VALUES (2821, 3014, 6024, 'RIO BUENO');
INSERT INTO comuna VALUES (2820, 3014, 6024, 'LAGO RANCO');
INSERT INTO comuna VALUES (2819, 3014, 6024, 'FUTRONO');
INSERT INTO comuna VALUES (2818, 3014, 6024, 'LA UNION');
INSERT INTO comuna VALUES (2817, 3014, 6024, 'PANGUIPULLI');
INSERT INTO comuna VALUES (2816, 3014, 6024, 'PAILLACO');
INSERT INTO comuna VALUES (2815, 3014, 6024, 'MARIQUINA');
INSERT INTO comuna VALUES (2814, 3014, 6024, 'MAFIL');
INSERT INTO comuna VALUES (2813, 3014, 6024, 'LOS LAGOS');
INSERT INTO comuna VALUES (2812, 3014, 6024, 'LANCO');
INSERT INTO comuna VALUES (2811, 3014, 6024, 'CORRAL');
INSERT INTO comuna VALUES (2810, 3014, 6024, 'VALDIVIA');
INSERT INTO comuna VALUES (2736, 3010, 6026, 'PALENA');
INSERT INTO comuna VALUES (2735, 3010, 6026, 'HUALAIHUE');
INSERT INTO comuna VALUES (2734, 3010, 6026, 'FUTALEUFU');
INSERT INTO comuna VALUES (2733, 3010, 6026, 'CHAITEN');
INSERT INTO comuna VALUES (2732, 3010, 6025, 'SAN PABLO');
INSERT INTO comuna VALUES (2731, 3010, 6025, 'SAN JUAN DE LA COSTA');
INSERT INTO comuna VALUES (2730, 3010, 6025, 'RIO NEGRO');
INSERT INTO comuna VALUES (2729, 3010, 6025, 'PUYEHUE');
INSERT INTO comuna VALUES (2728, 3010, 6025, 'PURRANQUE');
INSERT INTO comuna VALUES (2727, 3010, 6025, 'PUERTO OCTAY');
INSERT INTO comuna VALUES (2726, 3010, 6025, 'OSORNO');
INSERT INTO comuna VALUES (2725, 3010, 6026, 'QUINCHAO');
INSERT INTO comuna VALUES (2724, 3010, 6026, 'QUEMCHI');
INSERT INTO comuna VALUES (2723, 3010, 6026, 'QUELLON');
INSERT INTO comuna VALUES (2722, 3010, 6026, 'QUEILEN');
INSERT INTO comuna VALUES (2721, 3010, 6026, 'PUQUELDON');
INSERT INTO comuna VALUES (2720, 3010, 6026, 'DALCAHUE');
INSERT INTO comuna VALUES (2719, 3010, 6026, 'CURACO DE VELEZ');
INSERT INTO comuna VALUES (2718, 3010, 6026, 'CHONCHI');
INSERT INTO comuna VALUES (2717, 3010, 6026, 'ANCUD');
INSERT INTO comuna VALUES (2716, 3010, 6026, 'CASTRO');
INSERT INTO comuna VALUES (2715, 3010, 6025, 'PUERTO VARAS');
INSERT INTO comuna VALUES (2714, 3010, 6026, 'MAULLIN');
INSERT INTO comuna VALUES (2713, 3010, 6025, 'LLANQUIHUE');
INSERT INTO comuna VALUES (2712, 3010, 6025, 'LOS MUERMOS');
INSERT INTO comuna VALUES (2711, 3010, 6025, 'FRUTILLAR');
INSERT INTO comuna VALUES (2710, 3010, 6025, 'FRESIA');
INSERT INTO comuna VALUES (2709, 3010, 6026, 'COCHAMO');
INSERT INTO comuna VALUES (2708, 3010, 6026, 'CALBUCO');
INSERT INTO comuna VALUES (2707, 3010, 6026, 'PUERTO MONTT');
INSERT INTO comuna VALUES (2746, 3011, 6027, 'RIO IBAÑEZ');
INSERT INTO comuna VALUES (2745, 3011, 6027, 'CHILE CHICO');
INSERT INTO comuna VALUES (2744, 3011, 6027, 'TORTEL');
INSERT INTO comuna VALUES (2743, 3011, 6027, 'OHIGGINS');
INSERT INTO comuna VALUES (2742, 3011, 6027, 'COCHRANE');
INSERT INTO comuna VALUES (2741, 3011, 6027, 'GUAITECAS');
INSERT INTO comuna VALUES (2740, 3011, 6027, 'CISNES');
INSERT INTO comuna VALUES (2739, 3011, 6027, 'AYSEN');
INSERT INTO comuna VALUES (2738, 3011, 6027, 'LAGO VERDE');
INSERT INTO comuna VALUES (2737, 3011, 6027, 'COYHAIQUE');
INSERT INTO comuna VALUES (2757, 3012, 6028, 'TORRES DEL PAINE');
INSERT INTO comuna VALUES (2756, 3012, 6028, 'NATALES');
INSERT INTO comuna VALUES (2755, 3012, 6028, 'TIMAUKEL');
INSERT INTO comuna VALUES (2754, 3012, 6028, 'PRIMAVERA');
INSERT INTO comuna VALUES (2753, 3012, 6028, 'PORVENIR');
INSERT INTO comuna VALUES (2752, 3012, 6028, 'ANTARTICA');
INSERT INTO comuna VALUES (2751, 3012, 6028, 'CABO DE HORNOS');
INSERT INTO comuna VALUES (2750, 3012, 6028, 'SAN GREGORIO');
INSERT INTO comuna VALUES (2749, 3012, 6028, 'RIO VERDE');
INSERT INTO comuna VALUES (2748, 3012, 6028, 'LAGUNA BLANCA');
INSERT INTO comuna VALUES (2747, 3012, 6028, 'PUNTA ARENAS');


--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('comuna_comuna_id_seq', 1, false);


--
-- Name: comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('comuna_id_seq', 1, false);


--
-- Data for Name: imagen; Type: TABLE DATA; Schema: public; Owner: app_vav
--



--
-- Name: imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('imagen_id_seq', 9, true);


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('imagen_imagen_id_seq', 1, false);


--
-- Data for Name: mesa; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO mesa VALUES (1, 1, 'D', 6012, 'DISTRITO 12', 'LA FLORIDA', NULL, 'MESA  ', 1, 0, 0, 0, 0, '2025-11-11 09:53:40.111858', '2025-11-11 09:53:40.111858', NULL);
INSERT INTO mesa VALUES (2, 2, 'D', 6010, 'DISTRITO 10', 'PROVIDENCIA', 'prueba', 'MESA  123', 1, 1, 0, 0, 0, '2025-11-11 09:59:49.404037', '2025-11-11 09:59:06.892597', '1762865989');
INSERT INTO mesa VALUES (4, 2, 'S', 5006, 'CIRCUNSCRIPCIÓN 6', 'VIÑA DEL MAR', 'liceo j. f. vergara', 'MESA  555', 1, 1, 0, 0, 0, '2025-11-11 10:01:21.12324', '2025-11-11 10:00:42.035874', '1762866081');
INSERT INTO mesa VALUES (3, 2, 'P', 19001, 'LAS CONDES', 'LAS CONDES', 'escuela sagrado corazón', 'MESA  25', 1, 1, 0, 0, 0, '2025-11-12 00:18:23.148282', '2025-11-11 10:00:01.207458', '1762866012');


--
-- Name: mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_id_seq', 4, true);


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_mesa_id_seq', 1, false);


--
-- Data for Name: pacto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO pacto VALUES (498, 'A', 'PARTIDO ECOLOGISTA VERDE');
INSERT INTO pacto VALUES (499, 'A', 'PARTIDO ECOLOGISTA VERDE');
INSERT INTO pacto VALUES (486, 'B', 'VERDES, REGIONALISTAS Y HUMANISTAS');
INSERT INTO pacto VALUES (487, 'B', 'VERDES, REGIONALISTAS Y HUMANISTAS');
INSERT INTO pacto VALUES (483, 'C', 'UNIDAD POR CHILE');
INSERT INTO pacto VALUES (482, 'C', 'UNIDAD POR CHILE');
INSERT INTO pacto VALUES (481, 'D', 'IZQUIERDA ECOLOGISTA POPULAR ANIMALISTA Y HUMANISTA');
INSERT INTO pacto VALUES (480, 'D', 'IZQUIERDA ECOLOGISTA POPULAR ANIMALISTA Y HUMANISTA');
INSERT INTO pacto VALUES (491, 'E', 'MOVIMIENTO AMARILLOS POR CHILE');
INSERT INTO pacto VALUES (497, 'F', 'PARTIDO DE TRABAJADORES REVOLUCIONARIOS');
INSERT INTO pacto VALUES (493, 'G', 'PARTIDO ALIANZA VERDE POPULAR');
INSERT INTO pacto VALUES (492, 'G', 'PARTIDO ALIANZA VERDE POPULAR');
INSERT INTO pacto VALUES (494, 'H', 'POPULAR');
INSERT INTO pacto VALUES (495, 'H', 'POPULAR');
INSERT INTO pacto VALUES (488, 'I', 'PARTIDO DE LA GENTE');
INSERT INTO pacto VALUES (489, 'I', 'PARTIDO DE LA GENTE');
INSERT INTO pacto VALUES (484, 'J', 'CHILE GRANDE Y UNIDO');
INSERT INTO pacto VALUES (485, 'J', 'CHILE GRANDE Y UNIDO');
INSERT INTO pacto VALUES (479, 'K', 'CAMBIO POR CHILE');
INSERT INTO pacto VALUES (478, 'K', 'CAMBIO POR CHILE');
INSERT INTO pacto VALUES (999, 'K', 'SIN PACTO');


--
-- Name: pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('pacto_id_seq', 1, false);


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('pacto_pacto_id_seq', 1, false);


--
-- Data for Name: partido; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO partido VALUES (1, 'RENOVACION NACIONAL', 'RN');
INSERT INTO partido VALUES (2, 'PARTIDO DEMOCRATA CRISTIANO', 'PDC');
INSERT INTO partido VALUES (3, 'UNION DEMOCRATA INDEPENDIENTE', 'UDI');
INSERT INTO partido VALUES (4, 'PARTIDO POR LA DEMOCRACIA', 'PPD');
INSERT INTO partido VALUES (5, 'PARTIDO SOCIALISTA DE CHILE', 'PS');
INSERT INTO partido VALUES (6, 'PARTIDO COMUNISTA DE CHILE', 'PC');
INSERT INTO partido VALUES (7, 'PARTIDO RADICAL DE CHILE', 'PR');
INSERT INTO partido VALUES (37, 'EVOLUCION POLITICA', 'EVO');
INSERT INTO partido VALUES (99, 'INDEPENDIENTES', 'IND');
INSERT INTO partido VALUES (130, 'FEDERACION REGIONALISTA VERDE SOCIAL', 'FRVS');
INSERT INTO partido VALUES (137, 'PARTIDO LIBERAL DE CHILE', 'PL');
INSERT INTO partido VALUES (150, 'PARTIDO REPUBLICANO DE CHILE', 'REP');
INSERT INTO partido VALUES (157, 'PARTIDO DE LA GENTE', 'PDG');
INSERT INTO partido VALUES (188, 'PARTIDO HUMANISTA', 'PH');
INSERT INTO partido VALUES (190, 'PARTIDO ACCIÓN HUMANISTA', 'AH');
INSERT INTO partido VALUES (191, 'MOVIMIENTO AMARILLOS POR CHILE', 'AM');
INSERT INTO partido VALUES (197, 'PARTIDO SOCIAL CRISTIANO', 'PSC');
INSERT INTO partido VALUES (198, 'PARTIDO DEMOCRATAS CHILE', 'DM');
INSERT INTO partido VALUES (200, 'PARTIDO ALIANZA VERDE POPULAR', 'PAVP');
INSERT INTO partido VALUES (201, 'IGUALDAD', 'IG');
INSERT INTO partido VALUES (203, 'POPULAR', 'PO');
INSERT INTO partido VALUES (220, 'PARTIDO DE TRABAJADORES REVOLUCIONARIOS', 'PTR');
INSERT INTO partido VALUES (232, 'FRENTE AMPLIO', 'FA');
INSERT INTO partido VALUES (235, 'PARTIDO NACIONAL LIBERTARIO', 'PNL');
INSERT INTO partido VALUES (236, 'PARTIDO ECOLOGISTA VERDE', 'PEV');


--
-- Name: partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('partido_id_seq', 1, true);


--
-- Name: partido_partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('partido_partido_id_seq', 1, false);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO region VALUES (3015, 'ARICA Y PARINACOTA', 'XV');
INSERT INTO region VALUES (3001, 'TARAPACA', 'I');
INSERT INTO region VALUES (3002, 'ANTOFAGASTA', 'II');
INSERT INTO region VALUES (3003, 'ATACAMA', 'III');
INSERT INTO region VALUES (3004, 'COQUIMBO', 'IV');
INSERT INTO region VALUES (3005, 'VALPARAISO', 'V');
INSERT INTO region VALUES (3013, 'METROPOLITANA', 'XIII');
INSERT INTO region VALUES (3006, 'OHIGGINS', 'VI');
INSERT INTO region VALUES (3007, 'MAULE', 'VII');
INSERT INTO region VALUES (3016, 'ÑUBLE', 'XVI');
INSERT INTO region VALUES (3008, 'BIOBIO', 'VIII');
INSERT INTO region VALUES (3009, 'ARAUCANIA', 'IX');
INSERT INTO region VALUES (3014, 'LOS RIOS', 'XIV');
INSERT INTO region VALUES (3010, 'LOS LAGOS', 'X');
INSERT INTO region VALUES (3011, 'AYSEN', 'XI');
INSERT INTO region VALUES (3012, 'MAGALLANES', 'XII');


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('region_id_seq', 1, false);


--
-- Name: region_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('region_region_id_seq', 1, false);


--
-- Data for Name: swich; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO swich VALUES (2, 4, 14, 3, 9, 10, '0', '2024-10-25 10:02:53.969109', 0);
INSERT INTO swich VALUES (1, 2, 3, 0, 0, 0, '0', '2025-11-12 00:16:22.298082', 0);


--
-- Name: swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('swich_id_seq', 2, true);


--
-- Name: swich_swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('swich_swich_id_seq', 1, false);


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO usuario VALUES (1, 'AD', 1, 'm', 'Administrador', 'admin', 'admin2025', 3, '2020-03-10 10:33:05.700099', '2020-03-10 10:33:05.700099');
INSERT INTO usuario VALUES (2, 'OP', 1, 'n', 'Prensa 1', 'prensa1', 'pwd', 1, '2021-05-15 19:06:10.580988', '2021-05-15 19:06:10.580988');
INSERT INTO usuario VALUES (3, 'OP', 1, 'n', 'Prensa 2', 'prensa2', 'pwd', 1, '2021-05-16 12:02:19.180109', '2021-05-16 12:02:19.180109');
INSERT INTO usuario VALUES (4, 'OP', 1, 'n', 'Prensa 3', 'prensa3', 'pwd', 1, '2021-05-16 12:09:04.143502', '2021-05-16 12:09:04.143502');
INSERT INTO usuario VALUES (5, 'OP', 1, 'n', 'Prensa 4', 'prensa4', 'pwd', 1, '2021-05-16 12:30:59.800617', '2021-05-16 12:30:59.800617');
INSERT INTO usuario VALUES (6, 'OP', 1, 'n', 'Prensa 5', 'prensa5', 'pwd', 1, '2021-05-16 12:32:27.107286', '2021-05-16 12:32:27.107286');
INSERT INTO usuario VALUES (7, 'OP', 1, 'n', 'Prensa 6', 'prensa6', 'pwd', 1, '2021-05-16 12:32:44.65376', '2021-05-16 12:32:44.65376');
INSERT INTO usuario VALUES (8, 'OP', 1, 'n', 'Prensa 7', 'prensa7', 'pwd', 1, '2021-05-16 12:33:04.883941', '2021-05-16 12:33:04.883941');
INSERT INTO usuario VALUES (9, 'OP', 1, 'n', 'Prensa 8', 'prensa8', 'pwd', 1, '2021-05-16 12:33:26.60897', '2021-05-16 12:33:26.60897');
INSERT INTO usuario VALUES (10, 'OP', 1, 'n', 'Prensa 9', 'prensa9', 'pwd', 1, '2021-05-16 12:33:42.400539', '2021-05-16 12:33:42.400539');
INSERT INTO usuario VALUES (11, 'OP', 1, 'n', 'Prensa 10', 'prensa10', 'pwd', 1, '2021-05-16 12:34:02.97873', '2021-05-16 12:34:02.97873');
INSERT INTO usuario VALUES (12, 'OP', 1, 'n', 'Prensa 11', 'prensa11', 'pwd', 1, '2022-09-01 14:28:40.919892', '2022-09-01 14:28:40.919892');
INSERT INTO usuario VALUES (13, 'OP', 1, 'n', 'Prensa 12', 'prensa12', 'pwd', 1, '2022-09-01 14:29:08.372841', '2022-09-01 14:29:08.372841');
INSERT INTO usuario VALUES (14, 'OP', 1, 'n', 'Prensa 13', 'prensa13', 'pwd', 1, '2022-09-01 14:29:25.917857', '2022-09-01 14:29:25.917857');
INSERT INTO usuario VALUES (15, 'OP', 1, 'n', 'Prensa 14', 'prensa14', 'pwd', 1, '2022-09-01 14:29:49.173472', '2022-09-01 14:29:49.173472');
INSERT INTO usuario VALUES (16, 'OP', 1, 'n', 'Prensa 15', 'prensa15', 'pwd', 1, '2022-09-01 14:30:14.271053', '2022-09-01 14:30:14.271053');
INSERT INTO usuario VALUES (17, 'OP', 1, 'n', 'Prensa 16', 'prensa16', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (18, 'OP', 1, 'n', 'Prensa 17', 'prensa17', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (19, 'OP', 1, 'n', 'Prensa 18', 'prensa18', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (20, 'OP', 1, 'n', 'Prensa 19', 'prensa19', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (21, 'OP', 1, 'n', 'Prensa 20', 'prensa20', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (22, 'OP', 1, 'n', 'Prensa 21', 'prensa21', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (23, 'OP', 1, 'n', 'Prensa 22', 'prensa22', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (24, 'OP', 1, 'n', 'Prensa 23', 'prensa23', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (25, 'OP', 1, 'n', 'Prensa 24', 'prensa24', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (26, 'OP', 1, 'n', 'Prensa 25', 'prensa25', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (27, 'OP', 1, 'n', 'Prensa 26', 'prensa26', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (28, 'OP', 1, 'n', 'Prensa 27', 'prensa27', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (29, 'OP', 1, 'n', 'Prensa 28', 'prensa28', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (30, 'OP', 1, 'n', 'Prensa 29', 'prensa29', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (31, 'OP', 1, 'n', 'Prensa 30', 'prensa30', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (32, 'OP', 1, 'n', 'Prensa 31', 'prensa31', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (33, 'OP', 1, 'n', 'Prensa 32', 'prensa32', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (34, 'OP', 1, 'n', 'Prensa 33', 'prensa33', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (35, 'OP', 1, 'n', 'Prensa 34', 'prensa34', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (36, 'OP', 1, 'n', 'Prensa 35', 'prensa35', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (37, 'OP', 1, 'n', 'Prensa 36', 'prensa36', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (38, 'OP', 1, 'n', 'Prensa 37', 'prensa37', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (39, 'OP', 1, 'n', 'Prensa 38', 'prensa38', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (40, 'OP', 1, 'n', 'Prensa 39', 'prensa39', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (41, 'OP', 1, 'n', 'Prensa 40', 'prensa40', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (42, 'OP', 1, 'n', 'Prensa 41', 'prensa41', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (43, 'OP', 1, 'n', 'Prensa 42', 'prensa42', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (44, 'OP', 1, 'n', 'Prensa 43', 'prensa43', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (45, 'OP', 1, 'n', 'Prensa 44', 'prensa44', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (46, 'OP', 1, 'n', 'Prensa 45', 'prensa45', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (47, 'OP', 1, 'n', 'Prensa 46', 'prensa46', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (48, 'OP', 1, 'n', 'Prensa 47', 'prensa47', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (49, 'OP', 1, 'n', 'Prensa 48', 'prensa48', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (50, 'OP', 1, 'n', 'Prensa 49', 'prensa49', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (51, 'OP', 1, 'n', 'Prensa 50', 'prensa50', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (52, 'VZ', 1, 'n', 'Tv', 'tv', 'tv', 1, '2022-09-02 08:25:13.05714', '2022-09-02 08:25:13.05714');


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('usuario_id_seq', 54, true);


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('usuario_usuario_id_seq', 1, false);


--
-- Data for Name: voto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO voto VALUES (100, 66012067, 1, 0);
INSERT INTO voto VALUES (101, 66012051, 1, 0);
INSERT INTO voto VALUES (102, 66012052, 1, 0);
INSERT INTO voto VALUES (103, 66012053, 1, 0);
INSERT INTO voto VALUES (104, 66012054, 1, 0);
INSERT INTO voto VALUES (105, 66012055, 1, 0);
INSERT INTO voto VALUES (106, 66012056, 1, 0);
INSERT INTO voto VALUES (107, 66012057, 1, 0);
INSERT INTO voto VALUES (108, 66012058, 1, 0);
INSERT INTO voto VALUES (109, 66012059, 1, 0);
INSERT INTO voto VALUES (110, 66012060, 1, 0);
INSERT INTO voto VALUES (111, 66012061, 1, 0);
INSERT INTO voto VALUES (112, 66012062, 1, 0);
INSERT INTO voto VALUES (113, 66012063, 1, 0);
INSERT INTO voto VALUES (114, 66012064, 1, 0);
INSERT INTO voto VALUES (115, 66012065, 1, 0);
INSERT INTO voto VALUES (116, 66012066, 1, 0);
INSERT INTO voto VALUES (117, 66012068, 1, 0);
INSERT INTO voto VALUES (118, 66012069, 1, 0);
INSERT INTO voto VALUES (119, 66012070, 1, 0);
INSERT INTO voto VALUES (120, 66012071, 1, 0);
INSERT INTO voto VALUES (121, 66012072, 1, 0);
INSERT INTO voto VALUES (122, 66012073, 1, 0);
INSERT INTO voto VALUES (123, 66012074, 1, 0);
INSERT INTO voto VALUES (124, 66012075, 1, 0);
INSERT INTO voto VALUES (125, 66012076, 1, 0);
INSERT INTO voto VALUES (126, 66012077, 1, 0);
INSERT INTO voto VALUES (127, 66012078, 1, 0);
INSERT INTO voto VALUES (128, 66012079, 1, 0);
INSERT INTO voto VALUES (129, 66012080, 1, 0);
INSERT INTO voto VALUES (130, 66012081, 1, 0);
INSERT INTO voto VALUES (131, 66012082, 1, 0);
INSERT INTO voto VALUES (132, 66012083, 1, 0);
INSERT INTO voto VALUES (133, 66012084, 1, 0);
INSERT INTO voto VALUES (134, 66012085, 1, 0);
INSERT INTO voto VALUES (135, 66012086, 1, 0);
INSERT INTO voto VALUES (136, 66012087, 1, 0);
INSERT INTO voto VALUES (137, 66012088, 1, 0);
INSERT INTO voto VALUES (138, 66012089, 1, 0);
INSERT INTO voto VALUES (139, 66012090, 1, 0);
INSERT INTO voto VALUES (140, 66012091, 1, 0);
INSERT INTO voto VALUES (141, 66012092, 1, 0);
INSERT INTO voto VALUES (142, 66012093, 1, 0);
INSERT INTO voto VALUES (143, 66012094, 1, 0);
INSERT INTO voto VALUES (144, 66012095, 1, 0);
INSERT INTO voto VALUES (145, 66012096, 1, 0);
INSERT INTO voto VALUES (146, 66012097, 1, 0);
INSERT INTO voto VALUES (147, 66012098, 1, 0);
INSERT INTO voto VALUES (148, 66012099, 1, 0);
INSERT INTO voto VALUES (149, 66012100, 1, 0);
INSERT INTO voto VALUES (150, 66012101, 1, 0);
INSERT INTO voto VALUES (151, 66012102, 1, 0);
INSERT INTO voto VALUES (152, 66012103, 1, 0);
INSERT INTO voto VALUES (153, 66010051, 2, 0);
INSERT INTO voto VALUES (154, 66010052, 2, 0);
INSERT INTO voto VALUES (155, 66010053, 2, 0);
INSERT INTO voto VALUES (156, 66010054, 2, 0);
INSERT INTO voto VALUES (157, 66010055, 2, 0);
INSERT INTO voto VALUES (158, 66010056, 2, 0);
INSERT INTO voto VALUES (159, 66010057, 2, 0);
INSERT INTO voto VALUES (160, 66010058, 2, 0);
INSERT INTO voto VALUES (161, 66010059, 2, 0);
INSERT INTO voto VALUES (162, 66010060, 2, 0);
INSERT INTO voto VALUES (163, 66010061, 2, 0);
INSERT INTO voto VALUES (164, 66010062, 2, 0);
INSERT INTO voto VALUES (165, 66010063, 2, 0);
INSERT INTO voto VALUES (166, 66010064, 2, 0);
INSERT INTO voto VALUES (167, 66010065, 2, 0);
INSERT INTO voto VALUES (168, 66010066, 2, 0);
INSERT INTO voto VALUES (169, 66010067, 2, 0);
INSERT INTO voto VALUES (170, 66010068, 2, 0);
INSERT INTO voto VALUES (171, 66010069, 2, 0);
INSERT INTO voto VALUES (172, 66010070, 2, 0);
INSERT INTO voto VALUES (173, 66010071, 2, 0);
INSERT INTO voto VALUES (174, 66010072, 2, 0);
INSERT INTO voto VALUES (175, 66010073, 2, 0);
INSERT INTO voto VALUES (176, 66010074, 2, 0);
INSERT INTO voto VALUES (177, 66010075, 2, 0);
INSERT INTO voto VALUES (178, 66010076, 2, 0);
INSERT INTO voto VALUES (179, 66010077, 2, 0);
INSERT INTO voto VALUES (180, 66010078, 2, 0);
INSERT INTO voto VALUES (181, 66010079, 2, 0);
INSERT INTO voto VALUES (182, 66010080, 2, 0);
INSERT INTO voto VALUES (183, 66010081, 2, 0);
INSERT INTO voto VALUES (184, 66010082, 2, 0);
INSERT INTO voto VALUES (185, 66010083, 2, 0);
INSERT INTO voto VALUES (186, 66010084, 2, 0);
INSERT INTO voto VALUES (187, 66010085, 2, 0);
INSERT INTO voto VALUES (188, 66010086, 2, 0);
INSERT INTO voto VALUES (189, 66010087, 2, 0);
INSERT INTO voto VALUES (190, 66010088, 2, 0);
INSERT INTO voto VALUES (191, 66010089, 2, 0);
INSERT INTO voto VALUES (192, 66010090, 2, 0);
INSERT INTO voto VALUES (193, 66010091, 2, 0);
INSERT INTO voto VALUES (194, 66010092, 2, 0);
INSERT INTO voto VALUES (195, 66010093, 2, 0);
INSERT INTO voto VALUES (196, 66010094, 2, 0);
INSERT INTO voto VALUES (197, 66010095, 2, 0);
INSERT INTO voto VALUES (198, 66010096, 2, 0);
INSERT INTO voto VALUES (199, 66010097, 2, 0);
INSERT INTO voto VALUES (200, 66010098, 2, 0);
INSERT INTO voto VALUES (201, 66010099, 2, 0);
INSERT INTO voto VALUES (202, 66010100, 2, 0);
INSERT INTO voto VALUES (203, 66010101, 2, 0);
INSERT INTO voto VALUES (204, 66010102, 2, 0);
INSERT INTO voto VALUES (205, 66010103, 2, 0);
INSERT INTO voto VALUES (206, 66010104, 2, 0);
INSERT INTO voto VALUES (207, 66010105, 2, 0);
INSERT INTO voto VALUES (208, 66010106, 2, 0);
INSERT INTO voto VALUES (209, 66010107, 2, 0);
INSERT INTO voto VALUES (210, 66010108, 2, 0);
INSERT INTO voto VALUES (211, 66010109, 2, 0);
INSERT INTO voto VALUES (212, 66010110, 2, 0);
INSERT INTO voto VALUES (213, 66010111, 2, 0);
INSERT INTO voto VALUES (214, 66010112, 2, 0);
INSERT INTO voto VALUES (215, 66010113, 2, 0);
INSERT INTO voto VALUES (216, 66010114, 2, 0);
INSERT INTO voto VALUES (217, 66010115, 2, 0);
INSERT INTO voto VALUES (218, 66010116, 2, 0);
INSERT INTO voto VALUES (219, 66010117, 2, 0);
INSERT INTO voto VALUES (220, 66010118, 2, 0);
INSERT INTO voto VALUES (221, 66010119, 2, 0);
INSERT INTO voto VALUES (222, 66010120, 2, 0);
INSERT INTO voto VALUES (223, 66010121, 2, 0);
INSERT INTO voto VALUES (232, 55006011, 4, 0);
INSERT INTO voto VALUES (233, 55006012, 4, 0);
INSERT INTO voto VALUES (234, 55006013, 4, 0);
INSERT INTO voto VALUES (235, 55006014, 4, 0);
INSERT INTO voto VALUES (230, 41900106, 3, 13);
INSERT INTO voto VALUES (224, 41900105, 3, 22);
INSERT INTO voto VALUES (226, 41900107, 3, 16);
INSERT INTO voto VALUES (228, 41900104, 3, 15);
INSERT INTO voto VALUES (227, 41900108, 3, 11);
INSERT INTO voto VALUES (229, 41900102, 3, 13);
INSERT INTO voto VALUES (236, 55006015, 4, 0);
INSERT INTO voto VALUES (237, 55006016, 4, 0);
INSERT INTO voto VALUES (238, 55006017, 4, 0);
INSERT INTO voto VALUES (239, 55006018, 4, 0);
INSERT INTO voto VALUES (240, 55006019, 4, 0);
INSERT INTO voto VALUES (241, 55006020, 4, 0);
INSERT INTO voto VALUES (242, 55006021, 4, 0);
INSERT INTO voto VALUES (243, 55006022, 4, 0);
INSERT INTO voto VALUES (244, 55006023, 4, 0);
INSERT INTO voto VALUES (245, 55006024, 4, 0);
INSERT INTO voto VALUES (246, 55006025, 4, 0);
INSERT INTO voto VALUES (247, 55006026, 4, 0);
INSERT INTO voto VALUES (248, 55006027, 4, 0);
INSERT INTO voto VALUES (249, 55006028, 4, 0);
INSERT INTO voto VALUES (250, 55006029, 4, 0);
INSERT INTO voto VALUES (251, 55006030, 4, 0);
INSERT INTO voto VALUES (252, 55006031, 4, 0);
INSERT INTO voto VALUES (253, 55006032, 4, 0);
INSERT INTO voto VALUES (254, 55006033, 4, 0);
INSERT INTO voto VALUES (255, 55006034, 4, 0);
INSERT INTO voto VALUES (256, 55006035, 4, 0);
INSERT INTO voto VALUES (257, 55006036, 4, 0);
INSERT INTO voto VALUES (225, 41900103, 3, 13);
INSERT INTO voto VALUES (231, 41900101, 3, 23);


--
-- Name: voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_id_seq', 257, true);


--
-- Name: voto_voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_voto_id_seq', 1, false);


--
-- Name: candidato_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_pkey PRIMARY KEY (candidato_id);


--
-- Name: comuna_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY comuna
    ADD CONSTRAINT comuna_pkey PRIMARY KEY (comuna_id);


--
-- Name: imagen_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY imagen
    ADD CONSTRAINT imagen_pkey PRIMARY KEY (imagen_id);


--
-- Name: mesa_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (mesa_id);


--
-- Name: pacto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY pacto
    ADD CONSTRAINT pacto_pkey PRIMARY KEY (pacto_id);


--
-- Name: partido_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY partido
    ADD CONSTRAINT partido_pkey PRIMARY KEY (partido_id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: swich_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY swich
    ADD CONSTRAINT swich_pkey PRIMARY KEY (swich_id);


--
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuario_id);


--
-- Name: voto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT voto_pkey PRIMARY KEY (voto_id);


--
-- Name: candidato_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT candidato_id_fk FOREIGN KEY (candidato_id) REFERENCES candidato(candidato_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: candidato_pacto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_pacto_id_fkey FOREIGN KEY (pacto_id) REFERENCES pacto(pacto_id) ON DELETE CASCADE;


--
-- Name: candidato_partido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_partido_id_fkey FOREIGN KEY (partido_id) REFERENCES partido(partido_id) ON DELETE CASCADE;


--
-- Name: comuna_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY comuna
    ADD CONSTRAINT comuna_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON DELETE RESTRICT;


--
-- Name: mesa_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT mesa_id_fk FOREIGN KEY (mesa_id) REFERENCES mesa(mesa_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mesa_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO app_vav;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: candidato; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE candidato FROM PUBLIC;
REVOKE ALL ON TABLE candidato FROM app_vav;
GRANT ALL ON TABLE candidato TO app_vav;


--
-- Name: comuna; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE comuna FROM PUBLIC;
REVOKE ALL ON TABLE comuna FROM app_vav;
GRANT ALL ON TABLE comuna TO app_vav;


--
-- Name: mesa; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE mesa FROM PUBLIC;
REVOKE ALL ON TABLE mesa FROM app_vav;
GRANT ALL ON TABLE mesa TO app_vav;


--
-- Name: pacto; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE pacto FROM PUBLIC;
REVOKE ALL ON TABLE pacto FROM app_vav;
GRANT ALL ON TABLE pacto TO app_vav;


--
-- Name: partido; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE partido FROM PUBLIC;
REVOKE ALL ON TABLE partido FROM app_vav;
GRANT ALL ON TABLE partido TO app_vav;


--
-- Name: region; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE region FROM PUBLIC;
REVOKE ALL ON TABLE region FROM app_vav;
GRANT ALL ON TABLE region TO app_vav;


--
-- Name: voto; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE voto FROM PUBLIC;
REVOKE ALL ON TABLE voto FROM app_vav;
GRANT ALL ON TABLE voto TO app_vav;


--
-- PostgreSQL database dump complete
--

