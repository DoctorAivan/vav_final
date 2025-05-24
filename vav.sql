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
-- Name: mesa_nuevo(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

DROP FUNCTION mesa_nuevo(integer);
DROP FUNCTION mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying);

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
	--	INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo AND candidato_zona = in_mesa_zona;
    	INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo;

        RETURN in_mesa_id;
	        
	END $$;


ALTER FUNCTION public.mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) OWNER TO app_vav;

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

CREATE FUNCTION swich_consolidados_presidenciales_totales(in_mesa_tipo character varying) RETURNS TABLE(votos_total bigint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_independiente boolean, partido_id bigint, pacto_id bigint)
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
-- Name: swich_consolidados_totales(character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

DROP FUNCTION swich_consolidados_presidenciales();
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

INSERT INTO candidato VALUES (16302612, 'G', 7, 3013, 398, 1, 'FRANCISCO ORREGO GUTIERREZ', 'FRANCISCO ORREGO GUTIERREZ', '', false, 'None', 'FRANCISCO', 'ORREGO');
INSERT INTO candidato VALUES (9404352, 'G', 8, 3013, 999, 99, 'CLAUDIO ORREGO LARRAIN', 'CLAUDIO ORREGO LARRAIN', '', true, 'None', 'CLAUDIO', 'ORREGO');
INSERT INTO candidato VALUES (8718045, 'G', 4, 3005, 466, 99, 'RODRIGO EDUARDO ALEXIS MUNDACA CABRERA', 'RODRIGO EDUARDO ALEXIS MUNDACA CABRERA', '', false, 'None', 'RODRIGO', 'MUNDACA');
INSERT INTO candidato VALUES (13231848, 'G', 6, 3005, 398, 3, 'MARIA JOSE HOFFMANN OPAZO', 'MARIA JOSE HOFFMANN OPAZO', '', false, 'None', 'MARIA JOSE', 'HOFFMANN');
INSERT INTO candidato VALUES (13657157, 'G', 6, 3006, 437, 150, 'FERNANDO UGARTE TEJEDA', 'FERNANDO UGARTE TEJEDA', '', false, 'None', 'FERNANDO', 'UGARTE');
INSERT INTO candidato VALUES (8910303, 'G', 3, 3006, 466, 5, 'PABLO SILVA AMAYA', 'PABLO SILVA AMAYA', '', false, 'None', 'PABLO', 'SILVA');
INSERT INTO candidato VALUES (8514830, 'G', 2, 3002, 456, 7, 'MARCELA XIMENA HERNANDO PEREZ', 'MARCELA XIMENA HERNANDO PEREZ', '', false, 'None', 'MARCELA', 'HERNANDO');
INSERT INTO candidato VALUES (10671964, 'G', 3, 3002, 466, 99, 'RICARDO HERIBERTO DIAZ CORTES', 'RICARDO HERIBERTO DIAZ CORTES', '', false, 'None', 'RICARDO', 'DIAZ');
INSERT INTO candidato VALUES (13829838, 'G', 8, 3004, 398, 99, 'CRISTOBAL JULIA DE LA VEGA', 'CRISTOBAL JULIA DE LA VEGA', '', false, 'None', 'CRISTOBAL', 'JULIA');
INSERT INTO candidato VALUES (13425064, 'G', 4, 3004, 466, 6, 'JAVIER ANDRES VEGA ORTIZ', 'JAVIER ANDRES VEGA ORTIZ', '', false, 'None', 'JAVIER', 'VEGA');
INSERT INTO candidato VALUES (15248646, 'G', 4, 3009, 398, 99, 'LUCIANO RIVAS STEPKE', 'LUCIANO RIVAS STEPKE', '', false, 'None', 'LUCIANO', 'RIVAS');
INSERT INTO candidato VALUES (6966327, 'G', 5, 3009, 999, 99, 'RENE SAFFIRIO ESPINOZA', 'RENE SAFFIRIO ESPINOZA', '', true, 'None', 'RENE', 'SAFFIRIO');
INSERT INTO candidato VALUES (14354950, 'G', 7, 3008, 398, 99, 'SERGIO GIACAMAN GARCIA', 'SERGIO GIACAMAN GARCIA', '', false, 'None', 'SERGIO', 'GIACAMAN');
INSERT INTO candidato VALUES (8510034, 'G', 4, 3008, 462, 99, 'ALEJANDRO NAVARRO BRAIN', 'ALEJANDRO NAVARRO BRAIN', '', false, 'None', 'ALEJANDRO', 'NAVARRO');
INSERT INTO candidato VALUES (10638055, 'G', 3, 3003, 466, 99, 'MIGUEL VARGAS CORREA', 'MIGUEL VARGAS CORREA', '', false, 'None', 'MIGUEL', 'VARGAS CORREA');
INSERT INTO candidato VALUES (14168814, 'G', 6, 3003, 398, 3, 'NICOLAS NOMAN GARRIDO', 'NICOLAS NOMAN GARRIDO', '', false, 'None', 'NICOLAS', 'NOMAN GARRIDO');
INSERT INTO candidato VALUES (13100846, 'G', 5, 3007, 398, 3, 'PEDRO PABLO ALVAREZ-SALAMANCA RAMIREZ', 'PEDRO PABLO ALVAREZ-SALAMANCA RAMIREZ', '', false, 'None', 'PEDRO PABLO', 'ALVAREZ-SALAMANCA RAMIREZ');
INSERT INTO candidato VALUES (14487223, 'G', 2, 3007, 454, 2, 'CRISTINA BRAVO CASTRO', 'CRISTINA BRAVO CASTRO', '', false, 'None', 'CRISTINA', 'BRAVO CASTRO');
INSERT INTO candidato VALUES (13848213, 'G', 4, 3010, 437, 150, 'CLAUDIA ELENA REYES LARENAS', 'CLAUDIA ELENA REYES LARENAS', '', false, 'None', 'CLAUDIA ELENA', 'REYES LARENAS');
INSERT INTO candidato VALUES (10053111, 'G', 5, 3010, 398, 1, 'ALEJANDRO SANTANA TIRACHINI', 'ALEJANDRO SANTANA TIRACHINI', '', false, 'None', 'ALEJANDRO', 'SANTANA TIRACHINI');
INSERT INTO candidato VALUES (17557048, 'G', 7, 3015, 398, 1, 'DIEGO PACO MAMANI', 'DIEGO PACO MAMANI', '', false, 'None', 'DIEGO', 'PACO MAMANI');
INSERT INTO candidato VALUES (15313018, 'G', 5, 3015, 454, 2, 'JORGE DIAZ IBARRA', 'JORGE DIAZ IBARRA', '', false, 'None', 'JORGE', 'DIAZ IBARRA');


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

INSERT INTO comuna VALUES (2823, 3015, 6001, 'CAMARONES');
INSERT INTO comuna VALUES (2822, 3015, 6001, 'ARICA');
INSERT INTO comuna VALUES (2825, 3015, 6001, 'GENERAL LAGOS');
INSERT INTO comuna VALUES (2824, 3015, 6001, 'PUTRE');
INSERT INTO comuna VALUES (2502, 3001, 6002, 'ALTO HOSPICIO');
INSERT INTO comuna VALUES (2501, 3001, 6002, 'IQUIQUE');
INSERT INTO comuna VALUES (2507, 3001, 6002, 'PICA');
INSERT INTO comuna VALUES (2506, 3001, 6002, 'HUARA');
INSERT INTO comuna VALUES (2505, 3001, 6002, 'COLCHANE');
INSERT INTO comuna VALUES (2504, 3001, 6002, 'CAMIÑA');
INSERT INTO comuna VALUES (2503, 3001, 6002, 'POZO ALMONTE');
INSERT INTO comuna VALUES (2511, 3002, 6003, 'TALTAL');
INSERT INTO comuna VALUES (2510, 3002, 6003, 'SIERRA GORDA');
INSERT INTO comuna VALUES (2509, 3002, 6003, 'MEJILLONES');
INSERT INTO comuna VALUES (2508, 3002, 6003, 'ANTOFAGASTA');
INSERT INTO comuna VALUES (2514, 3002, 6003, 'SAN PEDRO DE ATACAMA');
INSERT INTO comuna VALUES (2513, 3002, 6003, 'OLLAGUE');
INSERT INTO comuna VALUES (2512, 3002, 6003, 'CALAMA');
INSERT INTO comuna VALUES (2516, 3002, 6003, 'MARIA ELENA');
INSERT INTO comuna VALUES (2515, 3002, 6003, 'TOCOPILLA');
INSERT INTO comuna VALUES (2519, 3003, 6004, 'TIERRA AMARILLA');
INSERT INTO comuna VALUES (2518, 3003, 6004, 'CALDERA');
INSERT INTO comuna VALUES (2517, 3003, 6004, 'COPIAPO');
INSERT INTO comuna VALUES (2521, 3003, 6004, 'DIEGO DE ALMAGRO');
INSERT INTO comuna VALUES (2520, 3003, 6004, 'CHAÑARAL');
INSERT INTO comuna VALUES (2525, 3003, 6004, 'HUASCO');
INSERT INTO comuna VALUES (2524, 3003, 6004, 'FREIRINA');
INSERT INTO comuna VALUES (2523, 3003, 6004, 'ALTO DEL CARMEN');
INSERT INTO comuna VALUES (2522, 3003, 6004, 'VALLENAR');
INSERT INTO comuna VALUES (2531, 3004, 6005, 'VICUÑA');
INSERT INTO comuna VALUES (2530, 3004, 6005, 'PAIHUANO');
INSERT INTO comuna VALUES (2529, 3004, 6005, 'LA HIGUERA');
INSERT INTO comuna VALUES (2528, 3004, 6005, 'ANDACOLLO');
INSERT INTO comuna VALUES (2527, 3004, 6005, 'COQUIMBO');
INSERT INTO comuna VALUES (2526, 3004, 6005, 'LA SERENA');
INSERT INTO comuna VALUES (2535, 3004, 6005, 'SALAMANCA');
INSERT INTO comuna VALUES (2534, 3004, 6005, 'LOS VILOS');
INSERT INTO comuna VALUES (2533, 3004, 6005, 'CANELA');
INSERT INTO comuna VALUES (2532, 3004, 6005, 'ILLAPEL');
INSERT INTO comuna VALUES (2540, 3004, 6005, 'RIO HURTADO');
INSERT INTO comuna VALUES (2539, 3004, 6005, 'PUNITAQUI');
INSERT INTO comuna VALUES (2538, 3004, 6005, 'MONTE PATRIA');
INSERT INTO comuna VALUES (2537, 3004, 6005, 'COMBARBALA');
INSERT INTO comuna VALUES (2536, 3004, 6005, 'OVALLE');
INSERT INTO comuna VALUES (2547, 3005, 6007, 'VIÑA DEL MAR');
INSERT INTO comuna VALUES (2546, 3005, 6006, 'QUINTERO');
INSERT INTO comuna VALUES (2545, 3005, 6006, 'PUCHUNCAVI');
INSERT INTO comuna VALUES (2544, 3005, 6007, 'JUAN FERNANDEZ');
INSERT INTO comuna VALUES (2543, 3005, 6007, 'CONCON');
INSERT INTO comuna VALUES (2542, 3005, 6007, 'CASABLANCA');
INSERT INTO comuna VALUES (2541, 3005, 6007, 'VALPARAISO');
INSERT INTO comuna VALUES (2548, 3005, 6007, 'ISLA DE PASCUA');
INSERT INTO comuna VALUES (2552, 3005, 6006, 'SAN ESTEBAN');
INSERT INTO comuna VALUES (2551, 3005, 6006, 'RINCONADA');
INSERT INTO comuna VALUES (2550, 3005, 6006, 'CALLE LARGA');
INSERT INTO comuna VALUES (2549, 3005, 6006, 'LOS ANDES');
INSERT INTO comuna VALUES (2557, 3005, 6006, 'ZAPALLAR');
INSERT INTO comuna VALUES (2556, 3005, 6006, 'PETORCA');
INSERT INTO comuna VALUES (2555, 3005, 6006, 'PAPUDO');
INSERT INTO comuna VALUES (2554, 3005, 6006, 'CABILDO');
INSERT INTO comuna VALUES (2553, 3005, 6006, 'LA LIGUA');
INSERT INTO comuna VALUES (2562, 3005, 6006, 'NOGALES');
INSERT INTO comuna VALUES (2561, 3005, 6006, 'LA CRUZ');
INSERT INTO comuna VALUES (2560, 3005, 6006, 'HIJUELAS');
INSERT INTO comuna VALUES (2559, 3005, 6006, 'CALERA');
INSERT INTO comuna VALUES (2558, 3005, 6006, 'QUILLOTA');
INSERT INTO comuna VALUES (2568, 3005, 6007, 'SANTO DOMINGO');
INSERT INTO comuna VALUES (2567, 3005, 6007, 'EL TABO');
INSERT INTO comuna VALUES (2566, 3005, 6007, 'EL QUISCO');
INSERT INTO comuna VALUES (2565, 3005, 6007, 'CARTAGENA');
INSERT INTO comuna VALUES (2564, 3005, 6007, 'ALGARROBO');
INSERT INTO comuna VALUES (2563, 3005, 6007, 'SAN ANTONIO');
INSERT INTO comuna VALUES (2574, 3005, 6006, 'SANTA MARIA');
INSERT INTO comuna VALUES (2573, 3005, 6006, 'PUTAENDO');
INSERT INTO comuna VALUES (2572, 3005, 6006, 'PANQUEHUE');
INSERT INTO comuna VALUES (2571, 3005, 6006, 'LLAY-LLAY');
INSERT INTO comuna VALUES (2570, 3005, 6006, 'CATEMU');
INSERT INTO comuna VALUES (2569, 3005, 6006, 'SAN FELIPE');
INSERT INTO comuna VALUES (2578, 3005, 6006, 'VILLA ALEMANA');
INSERT INTO comuna VALUES (2577, 3005, 6006, 'OLMUE');
INSERT INTO comuna VALUES (2576, 3005, 6006, 'LIMACHE');
INSERT INTO comuna VALUES (2575, 3005, 6006, 'QUILPUE');
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
INSERT INTO comuna VALUES (2792, 3013, 6012, 'SAN JOSE DE MAIPO');
INSERT INTO comuna VALUES (2791, 3013, 6012, 'PIRQUE');
INSERT INTO comuna VALUES (2790, 3013, 6012, 'PUENTE ALTO');
INSERT INTO comuna VALUES (2795, 3013, 6008, 'TILTIL');
INSERT INTO comuna VALUES (2794, 3013, 6008, 'LAMPA');
INSERT INTO comuna VALUES (2793, 3013, 6008, 'COLINA');
INSERT INTO comuna VALUES (2799, 3013, 6014, 'PAINE');
INSERT INTO comuna VALUES (2798, 3013, 6014, 'CALERA DE TANGO');
INSERT INTO comuna VALUES (2797, 3013, 6014, 'BUIN');
INSERT INTO comuna VALUES (2796, 3013, 6014, 'SAN BERNARDO');
INSERT INTO comuna VALUES (2804, 3013, 6014, 'SAN PEDRO');
INSERT INTO comuna VALUES (2803, 3013, 6014, 'MARIA PINTO');
INSERT INTO comuna VALUES (2802, 3013, 6014, 'CURACAVI');
INSERT INTO comuna VALUES (2801, 3013, 6014, 'ALHUE');
INSERT INTO comuna VALUES (2800, 3013, 6014, 'MELIPILLA');
INSERT INTO comuna VALUES (2809, 3013, 6014, 'PEÑAFLOR');
INSERT INTO comuna VALUES (2808, 3013, 6014, 'PADRE HURTADO');
INSERT INTO comuna VALUES (2807, 3013, 6014, 'ISLA DE MAIPO');
INSERT INTO comuna VALUES (2806, 3013, 6014, 'EL MONTE');
INSERT INTO comuna VALUES (2805, 3013, 6014, 'TALAGANTE');
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
INSERT INTO comuna VALUES (2601, 3006, 6016, 'PAREDONES');
INSERT INTO comuna VALUES (2600, 3006, 6016, 'NAVIDAD');
INSERT INTO comuna VALUES (2599, 3006, 6016, 'MARCHIGUE');
INSERT INTO comuna VALUES (2598, 3006, 6016, 'LITUECHE');
INSERT INTO comuna VALUES (2597, 3006, 6016, 'LA ESTRELLA');
INSERT INTO comuna VALUES (2596, 3006, 6016, 'PICHILEMU');
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
INSERT INTO comuna VALUES (2624, 3007, 6018, 'PELLUHUE');
INSERT INTO comuna VALUES (2623, 3007, 6018, 'CHANCO');
INSERT INTO comuna VALUES (2622, 3007, 6018, 'CAUQUENES');
INSERT INTO comuna VALUES (2633, 3007, 6017, 'VICHUQUEN');
INSERT INTO comuna VALUES (2632, 3007, 6017, 'TENO');
INSERT INTO comuna VALUES (2631, 3007, 6017, 'SAGRADA FAMILIA');
INSERT INTO comuna VALUES (2630, 3007, 6017, 'ROMERAL');
INSERT INTO comuna VALUES (2629, 3007, 6017, 'RAUCO');
INSERT INTO comuna VALUES (2628, 3007, 6017, 'MOLINA');
INSERT INTO comuna VALUES (2627, 3007, 6017, 'LICANTEN');
INSERT INTO comuna VALUES (2626, 3007, 6017, 'HUALAÑE');
INSERT INTO comuna VALUES (2625, 3007, 6017, 'CURICO');
INSERT INTO comuna VALUES (2641, 3007, 6018, 'YERBAS BUENAS');
INSERT INTO comuna VALUES (2640, 3007, 6018, 'VILLA ALEGRE');
INSERT INTO comuna VALUES (2639, 3007, 6018, 'SAN JAVIER');
INSERT INTO comuna VALUES (2638, 3007, 6018, 'RETIRO');
INSERT INTO comuna VALUES (2637, 3007, 6018, 'PARRAL');
INSERT INTO comuna VALUES (2636, 3007, 6018, 'LONGAVI');
INSERT INTO comuna VALUES (2635, 3007, 6018, 'COLBUN');
INSERT INTO comuna VALUES (2634, 3007, 6018, 'LINARES');
INSERT INTO comuna VALUES (2834, 3016, 6019, 'YUNGAY');
INSERT INTO comuna VALUES (2833, 3016, 6019, 'SAN IGNACIO');
INSERT INTO comuna VALUES (2832, 3016, 6019, 'QUILLON');
INSERT INTO comuna VALUES (2831, 3016, 6019, 'PINTO');
INSERT INTO comuna VALUES (2830, 3016, 6019, 'PEMUCO');
INSERT INTO comuna VALUES (2829, 3016, 6019, 'EL CARMEN');
INSERT INTO comuna VALUES (2828, 3016, 6019, 'CHILLAN VIEJO');
INSERT INTO comuna VALUES (2827, 3016, 6019, 'BULNES');
INSERT INTO comuna VALUES (2826, 3016, 6019, 'CHILLAN');
INSERT INTO comuna VALUES (2841, 3016, 6019, 'TREHUACO');
INSERT INTO comuna VALUES (2840, 3016, 6019, 'RANQUIL');
INSERT INTO comuna VALUES (2839, 3016, 6019, 'PORTEZUELO');
INSERT INTO comuna VALUES (2838, 3016, 6019, 'NINHUE');
INSERT INTO comuna VALUES (2837, 3016, 6019, 'COELEMU');
INSERT INTO comuna VALUES (2836, 3016, 6019, 'COBQUECURA');
INSERT INTO comuna VALUES (2835, 3016, 6019, 'QUIRIHUE');
INSERT INTO comuna VALUES (2846, 3016, 6019, 'SAN NICOLAS');
INSERT INTO comuna VALUES (2845, 3016, 6019, 'SAN FABIAN');
INSERT INTO comuna VALUES (2844, 3016, 6019, 'ÑIQUEN');
INSERT INTO comuna VALUES (2843, 3016, 6019, 'COIHUECO');
INSERT INTO comuna VALUES (2842, 3016, 6019, 'SAN CARLOS');
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
INSERT INTO comuna VALUES (2660, 3008, 6021, 'TIRUA');
INSERT INTO comuna VALUES (2659, 3008, 6021, 'LOS ALAMOS');
INSERT INTO comuna VALUES (2658, 3008, 6021, 'CURANILAHUE');
INSERT INTO comuna VALUES (2657, 3008, 6021, 'CONTULMO');
INSERT INTO comuna VALUES (2656, 3008, 6021, 'CAÑETE');
INSERT INTO comuna VALUES (2655, 3008, 6021, 'ARAUCO');
INSERT INTO comuna VALUES (2654, 3008, 6021, 'LEBU');
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
INSERT INTO comuna VALUES (2817, 3014, 6024, 'PANGUIPULLI');
INSERT INTO comuna VALUES (2816, 3014, 6024, 'PAILLACO');
INSERT INTO comuna VALUES (2815, 3014, 6024, 'MARIQUINA');
INSERT INTO comuna VALUES (2814, 3014, 6024, 'MAFIL');
INSERT INTO comuna VALUES (2813, 3014, 6024, 'LOS LAGOS');
INSERT INTO comuna VALUES (2812, 3014, 6024, 'LANCO');
INSERT INTO comuna VALUES (2811, 3014, 6024, 'CORRAL');
INSERT INTO comuna VALUES (2810, 3014, 6024, 'VALDIVIA');
INSERT INTO comuna VALUES (2821, 3014, 6024, 'RIO BUENO');
INSERT INTO comuna VALUES (2820, 3014, 6024, 'LAGO RANCO');
INSERT INTO comuna VALUES (2819, 3014, 6024, 'FUTRONO');
INSERT INTO comuna VALUES (2818, 3014, 6024, 'LA UNION');
INSERT INTO comuna VALUES (2715, 3010, 6025, 'PUERTO VARAS');
INSERT INTO comuna VALUES (2714, 3010, 6026, 'MAULLIN');
INSERT INTO comuna VALUES (2713, 3010, 6025, 'LLANQUIHUE');
INSERT INTO comuna VALUES (2712, 3010, 6025, 'LOS MUERMOS');
INSERT INTO comuna VALUES (2711, 3010, 6025, 'FRUTILLAR');
INSERT INTO comuna VALUES (2710, 3010, 6025, 'FRESIA');
INSERT INTO comuna VALUES (2709, 3010, 6026, 'COCHAMO');
INSERT INTO comuna VALUES (2708, 3010, 6026, 'CALBUCO');
INSERT INTO comuna VALUES (2707, 3010, 6026, 'PUERTO MONTT');
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
INSERT INTO comuna VALUES (2732, 3010, 6025, 'SAN PABLO');
INSERT INTO comuna VALUES (2731, 3010, 6025, 'SAN JUAN DE LA COSTA');
INSERT INTO comuna VALUES (2730, 3010, 6025, 'RIO NEGRO');
INSERT INTO comuna VALUES (2729, 3010, 6025, 'PUYEHUE');
INSERT INTO comuna VALUES (2728, 3010, 6025, 'PURRANQUE');
INSERT INTO comuna VALUES (2727, 3010, 6025, 'PUERTO OCTAY');
INSERT INTO comuna VALUES (2726, 3010, 6025, 'OSORNO');
INSERT INTO comuna VALUES (2736, 3010, 6026, 'PALENA');
INSERT INTO comuna VALUES (2735, 3010, 6026, 'HUALAIHUE');
INSERT INTO comuna VALUES (2734, 3010, 6026, 'FUTALEUFU');
INSERT INTO comuna VALUES (2733, 3010, 6026, 'CHAITEN');
INSERT INTO comuna VALUES (2738, 3011, 6027, 'LAGO VERDE');
INSERT INTO comuna VALUES (2737, 3011, 6027, 'COYHAIQUE');
INSERT INTO comuna VALUES (2741, 3011, 6027, 'GUAITECAS');
INSERT INTO comuna VALUES (2740, 3011, 6027, 'CISNES');
INSERT INTO comuna VALUES (2739, 3011, 6027, 'AYSEN');
INSERT INTO comuna VALUES (2744, 3011, 6027, 'TORTEL');
INSERT INTO comuna VALUES (2776, 3013, 6008, 'MAIPÚ');


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



--
-- Name: mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_id_seq', 1, false);


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_mesa_id_seq', 1, false);


--
-- Data for Name: pacto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO pacto VALUES (403, 'A', 'POR CHILE, SEGUIMOS');
INSERT INTO pacto VALUES (431, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (433, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (430, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (432, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (458, 'C', 'TODAS Y TODOS POR CHILE');
INSERT INTO pacto VALUES (442, 'D', 'DEMOCRATAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (394, 'E', 'CHILE VAMOS UDI-EVOPOLI E INDEPENDIENTES');
INSERT INTO pacto VALUES (387, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (399, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (386, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (397, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (405, 'G', 'VERDES LIBERALES POR UNA COMUNA SEGURA');
INSERT INTO pacto VALUES (401, 'H', 'CONTIGO CHILE MEJOR');
INSERT INTO pacto VALUES (393, 'I', 'CHILE VAMOS RENOVACION NACIONAL - INDEPENDIENTES');
INSERT INTO pacto VALUES (392, 'I', 'CHILE VAMOS RENOVACIÓN NACIONAL - INDEPENDIENTES');
INSERT INTO pacto VALUES (443, 'J', 'AMARILLOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (428, 'K', 'IZQUIERDA DE TRABAJADORES E INDEPENDIENTES');
INSERT INTO pacto VALUES (429, 'K', 'IZQUIERDA DE TRABAJADORES E INDEPENDIENTES');
INSERT INTO pacto VALUES (456, 'L', 'TU REGION RADICAL');
INSERT INTO pacto VALUES (457, 'L', 'TU REGION RADICAL');
INSERT INTO pacto VALUES (461, 'M', 'REGIONES VERDES LIBERALES');
INSERT INTO pacto VALUES (462, 'M', 'REGIONES VERDES LIBERALES');
INSERT INTO pacto VALUES (463, 'N', 'LO MEJOR PARA CHILE');
INSERT INTO pacto VALUES (466, 'O', 'POR CHILE Y SUS REGIONES');
INSERT INTO pacto VALUES (418, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (416, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (417, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (419, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (455, 'Q', 'POR UN CHILE MEJOR');
INSERT INTO pacto VALUES (454, 'Q', 'POR UN CHILE MEJOR');
INSERT INTO pacto VALUES (446, 'R', 'CENTRO DEMOCRATICO');
INSERT INTO pacto VALUES (444, 'R', 'CENTRO DEMOCRATICO');
INSERT INTO pacto VALUES (445, 'R', 'CENTRO DEMOCRATICO');
INSERT INTO pacto VALUES (451, 'S', 'FRENTE AMPLIO');
INSERT INTO pacto VALUES (404, 'T', 'TU COMUNA RADICAL');
INSERT INTO pacto VALUES (402, 'U', 'CHILE MUCHO MEJOR');
INSERT INTO pacto VALUES (395, 'V', 'CHILE VAMOS UDI - INDEPENDIENTES');
INSERT INTO pacto VALUES (390, 'W', 'CHILE VAMOS EVOPOLI - INDEPENDIENTES');
INSERT INTO pacto VALUES (426, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (424, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (427, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (425, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (437, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (438, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (439, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (440, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (398, 'Z', 'CHILE VAMOS');
INSERT INTO pacto VALUES (400, 'Z', 'CHILE VAMOS');
INSERT INTO pacto VALUES (999, '0', 'INDEPENDIENTES');


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

INSERT INTO partido VALUES (2, 'PARTIDO DEMOCRATA CRISTIANO', 'DC');
INSERT INTO partido VALUES (6, 'PARTIDO COMUNISTA DE CHILE', 'PC');
INSERT INTO partido VALUES (37, 'EVOLUCION POLITICA', 'EVO');
INSERT INTO partido VALUES (130, 'FEDERACION REGIONALISTA VERDE SOCIAL', 'FRVS');
INSERT INTO partido VALUES (150, 'PARTIDO REPUBLICANO DE CHILE', 'REP');
INSERT INTO partido VALUES (191, 'MOVIMIENTO AMARILLOS POR CHILE', 'AMA');
INSERT INTO partido VALUES (198, 'PARTIDO DEMOCRATAS CHILE', 'DEM');
INSERT INTO partido VALUES (200, 'PARTIDO ALIANZA VERDE POPULAR', 'AVP');
INSERT INTO partido VALUES (201, 'IGUALDAD', 'PIG');
INSERT INTO partido VALUES (203, 'POPULAR', 'PP');
INSERT INTO partido VALUES (220, 'PARTIDO DE TRABAJADORES REVOLUCIONARIOS', 'PTRV');
INSERT INTO partido VALUES (1, 'RENOVACION NACIONAL', 'RN');
INSERT INTO partido VALUES (3, 'UNION DEMOCRATA INDEPENDIENTE', 'UDI');
INSERT INTO partido VALUES (4, 'PARTIDO POR LA DEMOCRACIA', 'PPD');
INSERT INTO partido VALUES (5, 'PARTIDO SOCIALISTA DE CHILE', 'PS');
INSERT INTO partido VALUES (7, 'PARTIDO RADICAL DE CHILE', 'PR');
INSERT INTO partido VALUES (99, 'INDEPENDIENTES', 'IND');
INSERT INTO partido VALUES (137, 'PARTIDO LIBERAL DE CHILE', 'PL');
INSERT INTO partido VALUES (157, 'PARTIDO DE LA GENTE', 'PDG');
INSERT INTO partido VALUES (188, 'PARTIDO HUMANISTA', 'PH');
INSERT INTO partido VALUES (190, 'PARTIDO ACCIÓN HUMANISTA', 'AH');
INSERT INTO partido VALUES (197, 'PARTIDO SOCIAL CRISTIANO', 'PSC');
INSERT INTO partido VALUES (232, 'FRENTE AMPLIO', 'FA');


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

INSERT INTO region VALUES (3015, 'DE ARICA Y PARINACOTA', 'XV');
INSERT INTO region VALUES (3001, 'DE TARAPACA', 'I');
INSERT INTO region VALUES (3002, 'DE ANTOFAGASTA', 'II');
INSERT INTO region VALUES (3003, 'DE ATACAMA', 'III');
INSERT INTO region VALUES (3004, 'DE COQUIMBO', 'IV');
INSERT INTO region VALUES (3005, 'DE VALPARAISO', 'V');
INSERT INTO region VALUES (3013, 'METROPOLITANA', 'XIII');
INSERT INTO region VALUES (3006, 'DE OHIGGINS', 'VI');
INSERT INTO region VALUES (3007, 'DEL MAULE', 'VII');
INSERT INTO region VALUES (3016, 'DE ÑUBLE', 'XVI');
INSERT INTO region VALUES (3008, 'DEL BIOBIO', 'VIII');
INSERT INTO region VALUES (3009, 'DE LA ARAUCANIA', 'IX');
INSERT INTO region VALUES (3014, 'DE LOS RIOS', 'XIV');
INSERT INTO region VALUES (3010, 'DE LOS LAGOS', 'X');
INSERT INTO region VALUES (3011, 'DE AYSEN', 'XI');
INSERT INTO region VALUES (3012, 'DE MAGALLANES', 'XII');


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
INSERT INTO swich VALUES (1, 2, 1, 2, 0, 0, '0', '2024-11-21 09:13:40.872137', 0);


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

INSERT INTO usuario VALUES (1, 'AD', 1, 'm', 'Administrador', 'admin', 'admin2023', 3, '2020-03-10 10:33:05.700099', '2020-03-10 10:33:05.700099');
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



--
-- Name: voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_id_seq', 100, false);


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

