<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER LISTADO DE MESAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	$CCNF_RESULTADOS_PAGINAS				=	100;
	$CONF_PAGINA_ACTUAL						=	0;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

		SELECT * FROM mesa_switch_listado( $CCNF_RESULTADOS_PAGINAS , ( $CCNF_RESULTADOS_PAGINAS * $CONF_PAGINA_ACTUAL ) );

	";

//	Ejecutar Query
	$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER MESAS ALMACENADAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	$SWITCH_ID = 1;

//	Construir SQL
	$QUERY									=	"

		SELECT * FROM swich_obtener_datos( $SWITCH_ID );

	";

//	Ejecutar Query
	$QUERY_SWICH							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	Obtener información del Swich
	$_SWICH									=	pg_fetch_object($QUERY_SWICH);

?>