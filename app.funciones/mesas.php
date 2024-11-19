<?php

//  Obtener el icono relacionado
    function obtener_icono( $icono )
    {
        if( $icono == 'G' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'A' )
        {
            return 'fa-sticky-note';
        }
    }

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Obtener el titulo del tipo
    function obtener_titulo( $icono )
    {
        if( $icono == 'G' )
        {
            return '🔴&nbsp;&nbsp;&nbsp;GOBERNADORES';
        }
        else if( $icono == 'A' )
        {
            return '🔵&nbsp;&nbsp;&nbsp;ALCALDES';
        }
        else if( $icono == 'P' )
        {
            return '🔵&nbsp;&nbsp;&nbsp;PLEBISCITO';
        }
    }

?>