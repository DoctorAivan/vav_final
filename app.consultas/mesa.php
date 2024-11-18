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

?>